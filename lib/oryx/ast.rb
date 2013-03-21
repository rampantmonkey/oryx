require 'rltk/ast'

module Oryx
  class Expression < RLTK::ASTNode; end

  class Number < Expression
    value :value, Integer
  end

  class Variable < Expression
    value :name, String
  end

end
