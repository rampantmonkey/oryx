module Oryx
  class Preprocessor
    def initialize
    end

    def parse content
      content = remove_comment content
      remove_outer_whitespace content
    end

    def remove_comment content
      content.gsub /\/\*.*?\*\//, ''
    end

    def remove_outer_whitespace content
      content.lstrip.rstrip
    end


  end
end
