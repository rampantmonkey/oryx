module Oryx
  class Test::Unit::TestCase
    def self.should_generate_toolchain_output base_name, return_value
      context base_name do
        setup do
          setup_helper base_name
        end

        teardown do
          teardown_helper base_name
        end

        should "create files" do
          path = @directory + "#{@base_name}.ll"
          assert path.exist?, "#{path} was not created"

          path = @directory + "#{@base_name}.s"
          assert path.exist?, "#{path} was not created"

          path = @directory + "#{@base_name}.out"
          assert path.exist?, "#{path} was not created"
          assert path.executable?, "#{path} is not an executable"

          path = @directory + "#{@base_name}.out"
          assert_equal return_value, %x[#{path}; echo $?].to_i, "Wrong result returned"
        end
      end
    end

    private
      def stfu
        orig_stdout = $stdout.clone
        orig_stderr = $stderr.clone
        $stdout.reopen "/dev/null", "w"
        $stderr.reopen "/dev/null", "w"
        yield if block_given?
        $stdout.reopen orig_stdout
        $stderr.reopen orig_stderr
      end

      def setup_helper file
        @directory = Pathname.new "test/data/"
        @base_name = file
        r = Runner.new [(@directory+"#{@base_name}.c")]
        stfu {r.run}
      end

      def teardown_helper file
        %w[ll s out].each do |e|
          path = @directory+"#{@base_name}.#{e}"
          path.delete if path.exist?
        end
      end
  end
end
