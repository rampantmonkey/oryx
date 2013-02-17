require 'optparse'
require 'pathname'

module Oryx
  class Options
    DEFAULT_INPUT = ""
    DEFAULT_OUTPUT = Pathname.new("/tmp/oryx-output")

    def initialize(argv)
      @config = {output: DEFAULT_OUTPUT,
                 input:  DEFAULT_INPUT}
      parse(argv)
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
          puts path
          @config[:output] = Pathname.new(path).expand_path
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
