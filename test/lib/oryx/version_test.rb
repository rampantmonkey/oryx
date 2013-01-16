require_relative '../../test_helper'

module Oryx
  class TestVersion < Test::Unit::TestCase
    context "version" do
      should "be defined" do
        assert_not_nil Oryx::VERSION
      end
    end
  end
end

