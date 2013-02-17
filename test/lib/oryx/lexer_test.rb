require_relative '../../test_helper'
require 'rltk'

module Oryx
  class TestLexer < Test::Unit::TestCase
    def compare(input, expected)
      l = Lexer.new
      l.lex(input).each_with_index do |t, i|
        assert_equal expected[i].upcase, t.to_s
      end
    end

    context "keywords" do
      should "match boolean" do
        compare("boolean", ["boolean", "eos"])
      end
      should "match char" do
        compare("char", ["char", "eos"])
      end
      should "match else" do
        compare("else", ["else", "eos"])
      end
      should "match false" do
        compare("false", ["false", "eos"])
      end
      should "match if" do
        compare("if", ["if", "eos"])
      end
      should "match int" do
        compare("int", ["int", "eos"])
      end
      should "match print" do
        compare("print", ["print", "eos"])
      end
      should "match return" do
        compare("return", ["return", "eos"])
      end
      should "match string" do
        compare("string", ["string", "eos"])
      end
      should "match true" do
        compare("true", ["true", "eos"])
      end
      should "match void" do
        compare("void", ["void", "eos"])
      end
      should "match while" do
        compare("while", ["while", "eos"])
      end
    end

    context "test.cflat" do
      should "replicate results from example" do
        input = "char true boolean\nboolean ( +\nstring s"
        result = ["CHAR", "TRUE", "BOOLEAN", "BOOLEAN", "LPAREN", "PLUS", "STRING", "IDENT(s)", "EOS"]
        compare input, result
      end
    end

  end
end

