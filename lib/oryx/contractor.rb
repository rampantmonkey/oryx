require_relative "../oryx"

require "rltk/cg/contractor"
require "rltk/cg/llvm"
require "rltk/cg/module"

RLTK::CG::LLVM.init(:x86)

module Oryx
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
      when GE  then icmp(:sgt, left, right)
      when GEQ then puts "GEQ: #{left} >= #{right} --> #{left >= right}"
      when LE  then puts "LE: #{left} < #{right} --> #{left < right}"
      when LEQ then puts "LEQ: #{left} <= #{right} --> #{left <= right}"
      when EQ  then puts "EQ: #{left} == #{right} --> #{left == right}"
      when NEQ then puts "NEQ: #{left} != #{right} --> #{left != right}"
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


    private
      def dispatch node
        case node
        when Function then visit node
        when GInitialization then visit node
        when GDeclaration then visit node
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
