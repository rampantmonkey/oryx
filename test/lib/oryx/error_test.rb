require_relative '../../test_helper'

module Oryx
  class TestError < Test::Unit::TestCase
    context "Error Hierarchy" do
      should "be subclasssed from standard error" do
        assert Error.ancestors.include? StandardError
      end

      should "be namespaced" do
        assert Error.name.include? "::"
      end

      should "have Oryx namespace" do
        assert_equal Error.name.to_s.split("::").first, "Oryx"
      end
    end
  end
end
