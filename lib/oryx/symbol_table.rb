module Oryx
  class SymbolTable
    def initialize
      @values = [{}]
    end

    def enter_scope
      values.push Hash.new
    end

    def exit_scope
      raise "Cannot exit global scope." if current_scope == 0
      values.pop
    end

    def lookup variable
      values.reverse.each do |v|
        return v.fetch variable.to_sym if v.include? variable.to_sym
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
  end
end
