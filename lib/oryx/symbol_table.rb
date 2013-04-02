module Oryx
  class SymbolTable
    def initialize
      @values = [{}]
    end

    def enter_scope
    end

    def exit_scope
    end

    def lookup variable

      s = current_scope
      while(s >= 0) do
        v = lookup_in s, variable
        return v unless v == :not_found
        s -= 1
      end
    end

    def insert variable, value=nil
      values[current_scope][variable.to_sym] = value
    end

    def current_scope
      values.length - 1
    end

    private
      attr_accessor :values

      def lookup_in scope, variable
        values[scope].fetch variable.to_sym {:not_found}
      end
  end
end
