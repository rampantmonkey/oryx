require_relative "../oryx"

require "rltk/cg/contractor"
require "rltk/cg/llvm"
require "rltk/cg/module"

RLTK::CG::LLVM.init(:x86)

module Oryx

  ZERO = RLTK::CG::NativeInt.new(0)

  class Contractor < RLTK::CG::Contractor
    attr_reader :module, :st

    def initialize
      super
      @module = RLTK::CG::Module.new('Oryx JIT')
      @st = SymbolTable.new
      @branch_needed = true
    end

    def begin ast
      ast.each {|a| dispatch a}
    end

    on Function do |node|
      fun = nil
      if fun = @module.functions[node.i]
        raise GenerationError, "Redefinition of function #{node.i}."
      else
        st.enter_scope
        param_types = parameter_types node.params
        return_type = visit node.return_type
        fun = @module.functions.add(node.i, return_type, param_types)
        param_names = parameter_names node.params
        param_names.each_with_index do |name, i|
          fun.params[i].name = name
        end
      end
      build(fun.blocks.append('entry')) do
        fun.params.each do |param|
          loc = alloca RLTK::CG::NativeIntType, param.name
          st.insert param.name, loc
          store param, loc
        end
        ret ( visit node.body )
      end
      st.exit_scope

      returning(fun) { fun.verify }
    end

    on ParamList do |node|
    end

    on Int do |node|
      RLTK::CG::NativeIntType
    end

    on Variable do |node|
      begin
       self.load (st.lookup node.name.to_sym), node.name
      rescue SymbolTableError => e
        STDERR.puts e.message, "Attempting to continue without this value."
      end
    end

    on CodeBlock do |node|
      st.enter_scope
      start = current_block
      fun = start.parent
      b = fun.blocks.append('code_block')
      value = ''
      next_b = [b]
      node.statements.each do |s|
        value, new_b = visit s, at: next_b.last, rcb: true
        if new_b != b
          build(next_b.last) { br new_b} if @branch_needed
          @branch_needed = true
          next_b << new_b
        end
      end


      phi_bb = fun.blocks.append('phi_bb', self)
      phi_inst = build(phi_bb) { phi RLTK::CG::NativeIntType, { next_b.last=> value, next_b.last => value}, 'iftmp' }
      build(start) { br b }
      build(next_b.last) { br phi_bb }
      st.exit_scope
      returning(phi_inst) { target phi_bb }
    end

    on Return do |node|
      result = visit node.right
      result
    end

    on Binary do |node|
      left = visit node.left
      right = visit node.right

      case node
      when Add then add(left, right, 'addtmp')
      when Sub then sub(left, right, 'subtmp')
      when Mul then mul(left, right, 'multmp')
      when Div then sdiv(left, right, 'divtmp')
      when GE  then integer_cast(icmp(:sgt, left, right), RLTK::CG::NativeIntType, 'booltmp')
      when GEQ then integer_cast(icmp(:sge, left, right), RLTK::CG::NativeIntType, 'booltmp')
      when LE  then integer_cast(icmp(:slt, left, right), RLTK::CG::NativeIntType, 'booltmp')
      when LEQ then integer_cast(icmp(:sle, left, right), RLTK::CG::NativeIntType, 'booltmp')
      when EQ  then integer_cast(icmp(:eq, left, right), RLTK::CG::NativeIntType, 'booltmp')
      when NEQ then integer_cast(icmp(:ne, left, right), RLTK::CG::NativeIntType, 'booltmp')
      when And then integer_cast((build_inst :and, left, right), RLTK::CG::NativeIntType, 'andtmp')
      when Or  then integer_cast((build_inst :or, left, right), RLTK::CG::NativeIntType, 'ortmp')
      end
    end

    on Number do |node|
      RLTK::CG::NativeInt.new(node.value)
    end

    on BoolConst do |node|
      int_val = (node.value == :true) ? 1 : 0
      RLTK::CG::Int1.new(int_val)
    end

    on Neg do |node|
      right = visit node.right
      sub(ZERO, right, 'negtmp')
    end

    on GInitialization do |node|
      name = node.name.to_sym
      value = visit node.right
      loc = alloca RLTK::CG::NativeIntType, name.to_s
      puts "#{name} -> #{loc}"
      begin
        st.insert(name, loc)
      rescue SymbolTableError => e
        STDERR.puts e.message, "Continuing processing without modifying the symbol table"
      end
      puts "#{name} -> #{st.lookup name}"
      store value, loc
    end

    on Initialization do |node|
      name = node.name.to_sym
      value = visit node.right
      loc = alloca RLTK::CG::NativeIntType, name.to_s
      begin
        st.insert(name, loc)
        store value, loc
      rescue SymbolTableError => e
        STDERR.puts e.message, "Continuing processing without modifying the symbol table"
      end
    end

    on GDeclaration do |node|
      name = node.name.to_sym
      loc = alloca RLTK::CG::NativeIntType, name.to_s
      begin
        st.insert name, loc
      rescue SymbolTableError => e
        STDERR.puts e.message, "Continuing processing without modifying the symbol table"
      end
    end

    on Declaration do |node|
      name = node.name.to_sym
      loc = alloca RLTK::CG::NativeIntType, name.to_s
      begin
        st.insert name, loc
      rescue SymbolTableError => e
        STDERR.puts e.message, "Continuing processing without modifying the symbol table"
      end
    end

    on Assign do |node|
      value = visit node.right
      name = node.name.to_sym
      begin
        loc = st.lookup name
        store value, loc
      rescue SymbolTableError => e
        STDERR.puts e.message, "Continuing processing witout modifying the symbol table"
      end
    end

    on Call do |node|
      callee = @module.functions[node.name]
      raise GenerationError, "Unknown function referenced" unless callee

      raise GenerationError, "Function #{node.name} expected #{callee.params.size} argument(s) but was called with #{node.args.args.length}." unless callee.params.size == node.args.args.length
      args = node.args.args.map { |a| visit a }
      call callee, *args.push('calltmp')
    end

    on If do |node|
      cond_val = icmp :ne, (visit node.cond), ZERO, 'ifcond'
      start_bb = current_block
      fun = start_bb.parent
      then_bb = fun.blocks.append('then')
      then_val, new_then_bb = visit node.then, at: then_bb, rcb: true

      else_bb = fun.blocks.append('else')
      else_val, new_else_bb = visit node.else, at: else_bb, rcb: true

      merge_bb = fun.blocks.append('merge', self)
      phi_inst = build(merge_bb) { phi RLTK::CG::NativeIntType, {new_then_bb => then_val, new_else_bb => else_val}, 'iftmp' }

      build(start_bb) { cond cond_val, then_bb, else_bb }
      build(new_then_bb) { br merge_bb }
      build(new_else_bb) { br merge_bb }
      @branch_needed = false
      returning(phi_inst) { target merge_bb }
    end


    private
      def dispatch node
        case node
        when Function then visit node
        when GInitialization then visit node
        when GDeclaration then visit node
        when Call then visit node
        else raise GenerationError "Unhandled node type #{node}"
        end
      end

      def parameter_types node
        node.params.map do |p|
          t = visit p.type
        end
      end

      def parameter_names node
        node.params.map do |p|
          t = p.name
        end
      end
  end
end
