require 'optparse'
require 'pathname'

module Oryx
  class Options
    DEFAULT_INPUT = ""
    DEFAULT_OUTPUT = "a.out"

    def initialize(argv)
      @config = {output:  DEFAULT_OUTPUT,
                 input:   DEFAULT_INPUT,
                 verbose: false}

      parse(argv)

      begin
        input = Pathname.new(argv.pop).expand_path
        @config[:input] = input
      rescue TypeError => e
        STDERR.puts "No input_file specified.\nUse --help for more information."
        exit(-1)
      end
    end

    def method_missing m, *args, &block
      if @config.has_key? m
        @config[m]
      else
        super
      end
    end

    def parse(argv)
      OptionParser.new do |opts|
        opts.banner = "Usage:   oryx [ options ] input_file"
        opts.on("-h", "--help", "Show this message") do
          puts opts
          exit
        end
        opts.on("-o", "--output FILE", String, "Output filename") do |path|
          @config[:output] = Pathname.new(path).expand_path
        end
        opts.on("-v", "--verbose", "Auxilary information about compilation process") do
          @config[:verbose] = true
        end

        begin
          argv = ["-h"] if argv.empty?
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
          STDERR.puts e.message, "\n", opts
          exit(-1)
        end
      end
    end
  end
end
