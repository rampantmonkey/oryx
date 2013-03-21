require 'rltk/ast'

module Oryx
  class Expression < RLTK::ASTNode; end

  class Number < Expression
    value :value, Integer
  end

  class Variable < Expression
    value :name, String
  end

  class Binary < Expression
    child :left, Expression
    child :right, Expression
  end


  class Add < Binary; end
  class Sub < Binary; end
  class Mul < Binary; end
  class Div < Binary; end
end
