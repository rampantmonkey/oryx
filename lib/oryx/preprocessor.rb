module Oryx
  class Preprocessor
    def initialize
    end

    def parse content
      remove_comment content
    end

    def remove_comment content
      content.gsub /\/\*.*?\*\//, ''
    end


  end
end
