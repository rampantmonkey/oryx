require_relative '../../test_helper'

module Oryx
  class TestRunner < Test::Unit::TestCase
    context "test runner with many different files" do
      should_generate_toolchain_output("return", 42)
      should_generate_toolchain_output("add", 12)
      should_generate_toolchain_output("sub", (-7)%256)
      should_generate_toolchain_output("mul", 175)
      should_generate_toolchain_output("div", 2)
      should_generate_toolchain_output("gvar_1", 7)
      should_generate_toolchain_output("gvar_2", 42)
      should_generate_toolchain_output("gvar_3", 15)
      should_generate_toolchain_output("fun_1", 9)
      should_generate_toolchain_output("fun_2", 25)
      should_generate_toolchain_output("ge", 7)
      should_generate_toolchain_output("le", 8)
      should_generate_toolchain_output("leq", 15)
      should_generate_toolchain_output("geq", 9)
      should_generate_toolchain_output("eq", 5)
      should_generate_toolchain_output("neq", 4)
      should_generate_toolchain_output("if", 21)
      should_generate_toolchain_output("fib", 34)
    end
  end
end
