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

    context "scope basics " do
      attr_accessor :st

      setup do
        @st = SymbolTable.new
        @initial_values = {a: 1, b:2, c:3, d:4, e:'a', f: 1.2}
        @initial_values.each{ |k, v| st.insert k, v }
      end

      should "increase the scope" do
        st.enter_scope
        assert_equal 1, st.current_scope
      end

      should "decrease the scope" do
        st.enter_scope
        assert_nothing_raised do
          st.exit_scope
        end

        assert_equal 0, st.current_scope
      end

      should "increase and decrease the scope many times" do
        n = 73
        (0..n).map do |i|
          st.enter_scope
          assert_equal i+1, st.current_scope
          n-i
        end.map do |i|
          st.exit_scope
          assert_equal i, st.current_scope
        end
      end

      should "leave base values alone" do
        st.enter_scope
        st.exit_scope
        @initial_values.each{ |k, v| assert_equal v, st.lookup(k) }
      end

      should "find values from lower scope" do
        st.enter_scope
        @initial_values.each{ |k, v| assert_equal v, st.lookup(k) }
      end

      should "mask previously defined variables" do
        st.enter_scope
        st.insert :a,  "pi"
        assert_equal "pi", st.lookup(:a)
      end

      should "not delete lower scoped values" do
        st.enter_scope
        st.insert :a, "pi"
        st.exit_scope
        assert_equal 1, st.lookup(:a)
      end

      should "update variable" do
        st.update :a, "5"
        assert_equal "5", st.lookup(:a)
      end

      should "update variable in correct scope" do
        st.enter_scope
        st.insert :c, "cow"
        st.update :c, "monkey"
        assert_equal "monkey", st.lookup(:c)

        st.exit_scope
        assert_equal 3, st.lookup(:c)
      end
    end

    context "errors" do
      setup do
        @st = SymbolTable.new
      end

      should "raise an exception when exiting global scope" do
        assert_raise SymbolTableError do
          st.exit_scope
        end
      end


    end
  end
end
