require_relative '../../test_helper'

module Oryx
  class TestPreprocessor < Test::Unit::TestCase
    context "one line inputs" do
      setup do
        @preprocessor = Preprocessor.new
      end

      should "not modify empty input" do
        test_input = ""
        assert_equal test_input, @preprocessor.parse(test_input)
      end

      should "not modify simple assignment" do
        test_input = "int length=7;"
        assert_equal test_input, @preprocessor.parse(test_input)
      end
    end
  end
end

