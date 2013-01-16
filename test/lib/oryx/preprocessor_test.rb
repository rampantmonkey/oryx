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

      should "remove block comment" do
        test_input = "/* this is a block comment in c */"
        assert_equal "", @preprocessor.parse(test_input)
      end

      should "remove trailing comment" do
        test_input = "int a = 5; /* a */"
        assert_equal "int a = 5;", @preprocessor.parse(test_input)
      end

      should "remove starting comment" do
        test_input = "/* a */ int a = 5;"
        assert_equal "int a = 5;", @preprocessor.parse(test_input)
      end

      should "remove both comments" do
        test_input = "/* a */ int a = 5; /* b */"
        assert_equal "int a = 5;", @preprocessor.parse(test_input)
      end

      should "remove tons of comments" do
        test_input = "/* a */"*700 + " int a = 5; " + "/* b */"*107
        assert_equal "int a = 5;", @preprocessor.parse(test_input)
      end
    end
  end
end

