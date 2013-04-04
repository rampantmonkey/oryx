module Oryx
  class Error < StandardError; end

  class LexError < Error; end
  class ParseError < Error; end
  class GenerationError < Error; end
  class SybmolTableError < Error; end
end
