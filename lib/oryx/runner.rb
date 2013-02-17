module Oryx
  class Runner
    def initialize argv=[]
      @argv = argv
    end

    def run
      puts @argv
    end
  end
end
