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

        should "create LLVM IR" do
          path = @directory + "#{@base_name}.ll"
          assert path.exist?, "#{path} was not created"
        end

        should "translate IR into Assembly" do
          path = @directory + "#{@base_name}.s"
          assert path.exist?, "#{path} was not created"
        end

        should "create executable" do
          path = @directory + "#{@base_name}.out"
          assert path.exist?, "#{path} was not created"
          assert path.executable?, "#{path} is not an executable"
        end

        should "return the correct result" do
          path = @directory + "#{@base_name}.out"
          assert_equal return_value, %x[#{path}; echo $?].to_i
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
        %w[ll s out].each { |e| (@directory+"#{@base_name}.#{e}").delete }
      end
  end
end
