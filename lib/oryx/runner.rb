require_relative '../oryx.rb'

module Oryx
  class Runner
    attr_reader :input_filename, :output_filename

    def initialize argv
      @options = Options.new argv
      @input_filename  = @options.input
      @output_filename = @options.output
    end

    def run
      puts "input:  #{input_filename}"
      puts "output: #{output_filename}"
    end
  end
end
