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
    end

    def begin ast
      ast.each {|a| dispatch a}
    end

    on Function do |node|
      fun = nil
      if fun = @module.functions[node.i]
        raise GenerationError, "Redefinition of function #{node.i}."
      else
        param_types = parameter_types node.params
        return_type = visit node.return_type
        puts param_types
        puts return_type
        fun = @module.functions.add(node.i, return_type, param_types)
      end

      puts "FUNCTION: #{visit node.return_type} #{node.i}"

      st.enter_scope
      node.params.params.each {|p| visit p}
      puts fun
      ret (visit node.body, at: fun.blocks.append('entry'))
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
        st.lookup node.name.to_sym
      rescue SymbolTableError => e
        STDERR.puts e.message, "Attempting to continue without this value."
      end
    end

    on CodeBlock do |node|
      a = node.statements.map {|s| visit s}
      a.first
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
      end
    end

    on Number do |node|
      RLTK::CG::NativeInt.new(node.value)
    end

    on GInitialization do |node|
      name = node.name.to_sym
      value = visit node.right
      begin
        st.insert(name, value)
      rescue SymbolTableError => e
        STDERR.puts e.message, "Continuing processing without modifying the symbol table"
      end
    end

    on GDeclaration do |node|
      name = node.name.to_sym
      begin
        st.insert name
      rescue SymbolTableError => e
        STDERR.puts e.message, "Continuing processing without modifying the symbol table"
      end
    end

    on Assign do |node|
      value = visit node.right
      name = node.name.to_sym
      begin
        st.update name, value
      rescue SymbolTableError => e
        STDERR.puts e.message, "Continuing processing witout modifying the symbol table"
      end
    end

    on Call do |node|
      callee = @module.functions[node.name]
      raise GenerationError, "Unknown function referenced" unless callee

      call callee
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
  end
end
