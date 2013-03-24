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

  class Assign < Expression
    value :name, String
    child :right, Expression
  end

  class Add < Binary; end
  class Sub < Binary; end
  class Mul < Binary; end
  class Div < Binary; end

  class GE  < Binary; end
  class GEQ < Binary; end
  class LE  < Binary; end
  class LEQ < Binary; end
  class EQ < Binary; end
  class NEQ < Binary; end

  class Return < Expression
    child :right, Expression
  end

  class If < Expression
    child :cond, Expression
    child :then, Expression
    child :else, Expression
  end

  class CodeBlock < Expression
    child :statements, [Expression]
  end

  class ParamList < RLTK::ASTNode
    child :params, [Expression]
  end

  class Function < RLTK::ASTNode
    value :i, String
    child :params, ParamList
    child :body, CodeBlock
  end


end
