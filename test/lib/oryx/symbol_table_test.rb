require_relative '../../test_helper'

module Oryx
  class TestSymbolTable < Test::Unit::TestCase
    context "basics" do
      attr_accessor :st

      setup do
        @st = SymbolTable.new
      end

      should "exist" do
        st = SymbolTable.new
        assert_not_nil st
      end

      should "have base scope" do
        assert_equal st.current_scope, 0
      end

      should "store an empty variable" do
        st.insert :a
        assert_equal st.lookup(:a), nil
      end

      should "store an assigned variable" do
        st.insert :b, 7
        assert_equal 7, st.lookup(:b)
      end

    end
  end
end
