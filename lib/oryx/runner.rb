require_relative '../oryx.rb'

module Oryx
  class Runner
    attr_reader :output_filename

    def initialize argv
      @options = Options.new argv
      @output_filename = @options.output
    end

    def run
      puts output_filename
    end
  end
end
