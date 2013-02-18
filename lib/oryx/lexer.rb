require 'rltk'

module Oryx
  class Lexer < RLTK::Lexer
    # Skip whitespace
    rule(/\s/)

    # Keywords
    rule(/boolean/) { :BOOLEAN }
    rule(/char/)    { :CHAR    }
    rule(/else/)    { :ELSE    }
    rule(/false/)   { :FALSE   }
    rule(/if/)      { :IF      }
    rule(/int/)     { :INT     }
    rule(/print/)   { :PRINT   }
    rule(/return/)  { :RETURN  }
    rule(/string/)  { :STRING  }
    rule(/true/)    { :TRUE    }
    rule(/void/)    { :VOID    }
    rule(/while/)   { :WHILE   }

    # Operators and delimiters
    rule(/\(/)      { :LPAREN }
    rule(/\)/)      { :RPAREN }
    rule(/\*/)      { :TIMES  }
    rule(/\//)      { :DIV    }
    rule(/\+/)      { :PLUS   }
    rule(/-/)       { :MINUS  }
    rule(/</)       { :LE     }
    rule(/<=/)      { :LEQ    }
    rule(/>=/)      { :GEQ    }
    rule(/>/)       { :GE     }
    rule(/==/)      { :EQ     }
    rule(/\!=/)     { :NEQ    }
    rule(/&&/)      { :AND    }
    rule(/\|\|/)    { :OR     }
    rule(/=/)       { :ASSIGN }

    # Identifier
    rule(/[_A-Za-z][_A-Za-z0-9]*/) { |t| [:IDENT, t] }

    # Numerics
    rule(/\d+/) { |t| [:NUM, t] }

    # Comments
    rule(/\/\//)             { push_state :cpp_comment }
    rule(/\n/, :cpp_comment) { pop_state }
    rule(/./, :cpp_comment)
    rule(/\/\*/)             { push_state :c_comment }
    rule(/\*\//, :c_comment) { pop_state }
    rule(/\*\//)             { :UCOMTER }
    rule(/./, :c_comment)

    # Invalid token starters
    rule(/[^(_A-Z|a-z|\s|\(|\)|\*|\/|\+|-|<|>|=|\!|&|\|)]/) { |t| [:INVCHR, t] }
  end
end
