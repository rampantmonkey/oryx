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
      st.enter_scope
      puts "FUNCTION: #{node.return_type} #{node.i}"
      node.params.params.each {|p| visit p}
      visit node.body
    end

    on Variable do |node|
      puts "#{node.type} #{node.name}"
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
