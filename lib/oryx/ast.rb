require 'rltk/ast'

module Oryx
  class Expression < RLTK::ASTNode; end

  class Number < Expression
    value :value, Integer
  end

  class Cstring < Expression
    value :value, String
  end

  class BoolConst < Expression
    value :value, Symbol
  end

  class Type < Expression
    value :t, String
  end

  class Variable < Expression
    value :name, String
    child :type, Type
  end

  class Binary < Expression
    child :left, Expression
    child :right, Expression
  end

  class Uniary < Expression
    child :right, Expression
  end

  class Neg < Uniary; end

  class Initialization < Expression
    value :name, String
    child :right, Expression
    child :type, Type
  end

  class GInitialization < Initialization; end

  class Declaration < Expression
    value :name, String
    child :type, Type
  end

  class GDeclaration < Declaration; end

  class Assign < Expression
    value :name, String
    child :right, Expression
  end

  class ParamList < RLTK::ASTNode
    child :params, [Declaration]
  end

  class ArgList < RLTK::ASTNode
    child :args, [Expression]
  end

  class Call < Expression
    value :name, String
    child :args, ArgList
  end

  class Add < Binary; end
  class Sub < Binary; end
  class Mul < Binary; end
  class Div < Binary; end

  class GE  < Binary; end
  class GEQ < Binary; end
  class LE  < Binary; end
  class LEQ < Binary; end
  class EQ  < Binary; end
  class NEQ < Binary; end
  class And < Binary; end
  class Or  < Binary; end

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

  class Function < RLTK::ASTNode
    value :i, String
    child :params, ParamList
    child :body, CodeBlock
    child :return_type, Type
  end

  class While < Expression
    child :condition, Expression
    child :body, CodeBlock
  end

  class Boolean < Type; end
  class Char < Type; end
  class Int < Type; end
  class Str < Type; end

end
