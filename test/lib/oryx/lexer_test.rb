require_relative '../../test_helper'
require 'rltk'

module Oryx
  class TestLexer < Test::Unit::TestCase
    def compare(input, expected)
      l = Lexer.new
      l.lex(input).each_with_index do |t, i|
        assert_equal expected[i], t.to_s
      end
    end

    def valid_id? query_id
      assert is_id? query_id
    end

    def invalid_id? query_id
      assert !is_id?(query_id), "#{query_id} is a valid id"
    end

    def is_id? query_id
      l = Lexer.new
      tokens = l.lex(query_id).map{|t| ["IDENT", "EOS"].include? t.type.to_s }
      !tokens.include? false
    end

    context "keywords" do
      should "match boolean" do
        compare("boolean", ["BOOLEAN", "EOS"])
      end
      should "match char" do
        compare("char", ["CHAR", "EOS"])
      end
      should "match else" do
        compare("else", ["ELSE", "EOS"])
      end
      should "match false" do
        compare("false", ["FALSE", "EOS"])
      end
      should "match if" do
        compare("if", ["IF", "EOS"])
      end
      should "match int" do
        compare("int", ["INT", "EOS"])
      end
      should "match print" do
        compare("print", ["PRINT", "EOS"])
      end
      should "match return" do
        compare("return", ["RETURN", "EOS"])
      end
      should "match string" do
        compare("string", ["STRING", "EOS"])
      end
      should "match true" do
        compare("true", ["TRUE", "EOS"])
      end
      should "match void" do
        compare("void", ["VOID", "EOS"])
      end
      should "match while" do
        compare("while", ["WHILE", "EOS"])
      end
    end

    context "operators and delimiters" do
      should "match )" do
        compare('(', ["LPAREN", "EOS"])
      end
      should "match (" do
        compare(')', ["RPAREN", "EOS"])
      end
      should "match *" do
        compare('*', ["TIMES", "EOS"])
      end
      should "match " do
        compare('/', ["DIV", "EOS"])
      end
      should "match +" do
        compare('+', ["PLUS", "EOS"])
      end
      should "match -" do
        compare('-', ["MINUS", "EOS"])
      end
      should "match <" do
        compare('<', ["LE", "EOS"])
      end
      should "match <=" do
        compare('<=', ["LEQ", "EOS"])
      end
      should "match >=" do
        compare('>=', ["GEQ", "EOS"])
      end
      should "match >" do
        compare('>', ["GE", "EOS"])
      end
      should "match ==" do
        compare('==', ["EQ", "EOS"])
      end
      should "match !=" do
        compare('!=', ["NEQ", "EOS"])
      end
      should "match &&" do
        compare('&&', ["AND", "EOS"])
      end
      should "match ||" do
        compare('||', ["OR", "EOS"])
      end
      should "match =" do
        compare('=', ["ASSIGN", "EOS"])
      end
    end

    context "identifiers" do
      should "be valid ids" do
        queries = [ "a",
                    "a1",
                    "qwerty_uiop",
                    "abc123",
                    "ab_12",
                    "etc",
                    "j",
                    "LastNumber",
                    "not_sureHow_many_more_areNecessary"]
        queries.each { |q| valid_id? q }
      end

      should "be invalid ids" do
        queries = [ "if",
                    '?',
                    "1a",
                    "1.ab",
                    "1b a",
                    "ab 12",
                    "abc.126",
                    "!abc123"]
        queries.each { |q| invalid_id? q }
      end
    end

    context "comments" do
      should "remove the c-style commment" do
        compare "/* this is a comment */", ["EOS"]
      end

      should "remove two line c-style comment" do
        compare "/* line 1 \n line 2 */", ["EOS"]
      end

      should "remove multi-line comment (c-style)" do
        input = "/*" + "dnfdikas kenib UHJa ia !( *(*#ASD}{asdfi%*&) \n"*50 + "*/"
        compare input, ["EOS"]
      end

      should "remove c++-style comment" do
        compare "//\n", ["EOS"]
      end

      should "return warning with eos in comment" do
        compare  "/*", ["MCOMTER", "EOS"]
      end

    end

    context "test.cflat" do
      should "replicate results from example" do
        input = "char true boolean\nboolean ( +\nstring s"
        result = ["CHAR", "TRUE", "BOOLEAN", "BOOLEAN", "LPAREN", "PLUS", "STRING", "IDENT(s)", "EOS"]
        compare input, result
      end
    end

    context "comments" do
      should "produce error token" do
        compare '*/', ["UCOMTER", "EOS"]
      end
    end

  end
end

