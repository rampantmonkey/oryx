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

  end
end
