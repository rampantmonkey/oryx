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
      puts ast.length
      puts ast.class
      ast.each {|a| dispatch a}
    end

    on Function do |node|
      if fun = @module.functions[node.i]
        raise GenerationError, "Redefinition of function #{node.i}."
      else
        param_types = visit node.params
        return_type = visit node.return_type
        puts param_types
        puts return_type
        fun = @module.functions.add(node.i, return_type, param_types)
      end


      st.enter_scope
      puts "FUNCTION: #{visit node.return_type} #{node.i}"
      node.params.params.each {|p| visit p}
      visit node.body
      st.exit_scope
    end

    on ParamList do |node|
      node.params.map do |p|
        t = visit p.type
      end
    end

    on Int do |node|
      RLTK::CG::NativeIntType
    end

    on Variable do |node|
      puts "#{visit node.type} #{node.name}"
    end

    on CodeBlock do |node|
      node.statements.each {|s| visit s}
    end

    on Return do |node|
      result = visit node.right
      puts "RETURN: #{result}"
    end

    on Binary do |node|
      left = visit node.left
      right = visit node.right

      case node
      when Add then puts "ADD: #{left} + #{right} --> #{left + right}"
      when Sub then puts "SUB: #{left} - #{right} --> #{left - right}"
      when Mul then puts "MUL: #{left} * #{right} --> #{left * right}"
      when Div then puts "DIV: #{left} / #{right} --> #{left / right}"
      when GE  then puts "GE: #{left} > #{right} --> #{left > right}"
      when GEQ then puts "GEQ: #{left} >= #{right} --> #{left >= right}"
      when LE  then puts "LE: #{left} < #{right} --> #{left < right}"
      when LEQ then puts "LEQ: #{left} <= #{right} --> #{left <= right}"
      when EQ  then puts "EQ: #{left} == #{right} --> #{left == right}"
      when NEQ then puts "NEQ: #{left} != #{right} --> #{left != right}"
      end
    end

    on Number do |node|
      node.value
    end


    private
      def dispatch node
        case node
        when Function then visit node
        else raise GenerationError "Unhandled node type #{node}"
        end
      end
  end
end
