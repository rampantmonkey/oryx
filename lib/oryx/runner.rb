require_relative '../oryx.rb'
require 'colorize'

module Oryx
  class Runner
    attr_reader :input_filename, :output_filename

    def initialize argv
      @options = Options.new argv
      @input_filename  = @options.input
      @output_filename = @options.output
      @verbose = @options.verbose
    end

    def run
      puts "input:  #{input_filename}"
      puts "output: #{output_filename}"

      print "lexing".blue+"."*17
      l = Lexer.new
      tokens = l.lex_file(input_filename.to_s)
      output("lex") { tabularize_output tokens }
      puts "complete".green

      print "parsing".blue+"."*17
      finalize_parser
      p = Parser.new
      parse_flags = Hash.new
      parse_flags.merge!( {
                          parse_tree: name("parse.dot"),
                          verbose:    name("parse.log")
                         }
                        ) if @verbose
      ast = p.parse(tokens, parse_flags)
      puts "complete".green

      c = Contractor.new
      c.begin ast

      output_ir c.module

      translate_to_assembly
      create_executable

    end

    private
      def finalize_parser
        if 0 == Parser.class_eval { @states.length }
          if @verbose
            explain_file = name("parse")
            Parser.class_eval do
              finalize explain: explain_file
            end
          else
            Parser.class_eval { finalize }
          end
        end
      end

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

      def base_name
        input_filename.to_s.split('.').first
      end

      def name extension
        "#{base_name}.#{extension.to_s}"
      end

      def output extension
        if @verbose
          file = Pathname.new name(extension)
          file.open('w:UTF-8') { |f| f.write (yield) }
        end
      end

      def output_ir ir_module
        ir_module.verify
        orig_stderr = $stderr.clone
        $stderr.reopen File.new("#{base_name}.ll", "w")
        ir_module.dump
        $stderr.reopen orig_stderr
      end

      def translate_to_assembly
        `llc -disable-cfi #{base_name}.ll`
      end

      def create_executable
        `gcc #{base_name}.s -o #{base_name}.out`
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
