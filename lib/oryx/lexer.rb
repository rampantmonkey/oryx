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
    rule(/^[^\d\W]\w*/) { |t| [:IDENT, t] }

    # Numerics
    rule(/\d+/) { |t| [:NUM, t] }

    # Comments
    rule(/\/\//)             { push_state :cpp_comment }
    rule(/\n/, :cpp_comment) { pop_state }
    rule(/./, :cpp_comment)
    rule(/\/\*/)             { push_state :c_comment; set_flag :c_comment}
    rule(/\*\//, :c_comment) { pop_state; unset_flag :c_comment }
    rule(/\*\//)             { :UCOMTER }
    rule(/\n/, :c_comment)
    rule(/./, :c_comment)

    # Strings and Characters
    rule(/\'((\\(a|b|f|n|r|t|v|\'|\"|\\|\?))|[^\']{1})'/) { |t| [:CHARCON, t[1...-1]] }
    rule(/\'[^\']*'/) { |t| [:INVCON, t[1...-1]] }

    # Invalid token starters
    rule(/[^(\w|\s|\(|\)|\*|\/|\+|-|<|>|=|\!|&|\|)\"|\']/) { |t| [:INVCHR, t] }

    # Pokémon Rule
    rule(/./) { |t| [:INVCHR, t]}

    def lex string, file_name = nil
      tokens = super
      if env.flags.include? :c_comment
        tokens.insert -2, RLTK::Token.new(:MCOMTER)
      end
      tokens
    end
  end
end
