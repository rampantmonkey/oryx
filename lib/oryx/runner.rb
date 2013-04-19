require_relative '../oryx.rb'
require 'colorize'

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
      print "lexing".blue+"."*17
      l = Lexer.new
      output_filename.open('w:UTF-8') { |f| f.write(tabularize_output l.lex_file(input_filename.to_s)) }
      puts "complete".green

      p = Parser.new
      ast = p.parse(l.lex_file(input_filename.to_s), parse_tree: 'tree.dot', verbose: 'parse.out')

      c = Contractor.new
      c.begin ast

      output_ir c.module

    end

    private
      def tabularize_output tokens
        s = table_header
        tokens.each do |t|
          line = ""
          line += format " %-9s", t.type
          line += " "
          line += center t.value.to_s, 10
          line += " "
          line += center("#{t.position.line_number},#{t.position.line_offset}", 13) if t.position
          s += line + "\n"
        end
        s
      end

      def output_ir ir_module
        ir_module.verify
        orig_stderr = $stderr.clone
        $stderr.reopen File.new("#{input_filename.to_s.split('.').first}.ll", "w")
        ir_module.dump
        $stderr.reopen orig_stderr
      end

      def table_header
        s = center "TYPE", 10
        s += "|"
        s += center "VALUE", 10
        s += "|"
        s += center "POSITION", 12
        s += "\n"
        s += "-"*35
        s += "\n"
      end


      def center text, width
        left = (width - text.length)/2
        right = width - text.length - left
        " "*left + text + " "*right
      end
  end
end
