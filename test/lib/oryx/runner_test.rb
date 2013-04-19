require_relative '../../test_helper'

module Oryx
  class TestRunner < Test::Unit::TestCase
    def stfu
      orig_stdout = $stdout.clone
      orig_stderr = $stderr.clone
      $stdout.reopen "/dev/null", "w"
      $stderr.reopen "/dev/null", "w"
      yield if block_given?
      $stdout.reopen orig_stdout
      $stderr.reopen orig_stderr
    end

    context "return.c" do
      setup do
        @directory = Pathname.new "test/data/"
        @base_name = "return"
        r = Runner.new [(@directory+"#{@base_name}.c")]
        stfu {r.run}
      end

      teardown do
        %w[ll s out].each { |e| (@directory+"#{@base_name}.#{e}").delete }
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

      should "return the Answer to the Ultimate Question of Life, The Universe, and Everything" do
        path = @directory + "#{@base_name}.out"
        assert_equal 42, %x[#{path}; echo $?].to_i
      end
    end
  end
end
