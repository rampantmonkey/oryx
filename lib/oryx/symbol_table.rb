require_relative '../oryx'

module Oryx
  class SymbolTable
    def initialize
      @values = [{}]
    end

    def enter_scope
      values.push Hash.new
    end

    def exit_scope
      raise SymbolTableError, "Cannot exit global scope." if current_scope == 0
      values.pop
    end

    def lookup variable
      return values[scope_level_of variable][variable.to_sym]
    end

    def update variable, value=nil
      level = scope_level_of variable
      values[level][variable.to_sym] = value
    end

    def insert variable, value=nil
      raise SymbolTableError, "Re-definition of #{variable} not allowed" if values.last.include? variable.to_sym

      values[current_scope][variable.to_sym] = value
    end

    def current_scope
      values.length - 1
    end

    private
      attr_accessor :values

      def scope_level_of variable
        values.reverse.each_with_index do |v, i|
          return current_scope - i if v.include? variable.to_sym
        end

        raise SymbolTableError, "Variable #{variable} not found in symbol table."
      end
  end
end
