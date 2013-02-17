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
      puts "lexing...\n\n"
      l = Lexer.new
      l.lex_file(input_filename.to_s).each do |t|
        s = "#{t.type} #{t.value}"
        s += " @ #{t.position.line_number},#{t.position.line_offset}" if t.position
        puts s
      end
    end
  end
end
