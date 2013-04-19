require_relative '../../test_helper'

module Oryx
  class TestRunner < Test::Unit::TestCase
    context "test runner with many different files" do
      should_generate_toolchain_output("return", 42)
      should_generate_toolchain_output("add", 12)
      should_generate_toolchain_output("sub", (-7)%256)
      should_generate_toolchain_output("mul", 175)
      should_generate_toolchain_output("div", 2)
    end
  end
end
