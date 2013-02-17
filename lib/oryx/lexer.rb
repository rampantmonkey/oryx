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

  end
end
