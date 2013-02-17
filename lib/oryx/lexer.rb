require 'rltk'

module Oryx
  class Lexer < RLTK::Lexer
    # Skip whitespace
    rule(/\s/)

  end
end
