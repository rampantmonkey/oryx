require_relative '../../test_helper'
require 'rltk'

module Oryx
  class TestLexer < Test::Unit::TestCase
    def compare(input, expected)
      l = Lexer.new
      l.lex(input).each_with_index do |t, i|
        assert_equal expected[i], t.to_s unless t.to_s == "EOS"
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
        compare("boolean", ["BOOLEAN"])
      end
      should "match char" do
        compare("char", ["CHAR"])
      end
      should "match else" do
        compare("else", ["ELSE"])
      end
      should "match false" do
        compare("false", ["FALSE"])
      end
      should "match if" do
        compare("if", ["IF"])
      end
      should "match int" do
        compare("int", ["INT"])
      end
      should "match print" do
        compare("print", ["PRINT"])
      end
      should "match return" do
        compare("return", ["RETURN"])
      end
      should "match string" do
        compare("string", ["STRING"])
      end
      should "match true" do
        compare("true", ["TRUE"])
      end
      should "match void" do
        compare("void", ["VOID"])
      end
      should "match while" do
        compare("while", ["WHILE"])
      end
    end

    context "operators and delimiters" do
      should "match )" do
        compare('(', ["LPAREN"])
      end
      should "match (" do
        compare(')', ["RPAREN"])
      end
      should "match {" do
        compare('{', ["LCURLY"])
      end
      should "match }" do
        compare('}', ["RCURLY"])
      end
      should "match *" do
        compare('*', ["TIMES"])
      end
      should "match " do
        compare('/', ["DIV"])
      end
      should "match +" do
        compare('+', ["PLUS"])
      end
      should "match -" do
        compare('-', ["MINUS"])
      end
      should "match <" do
        compare('<', ["LE"])
      end
      should "match <=" do
        compare('<=', ["LEQ"])
      end
      should "match >=" do
        compare('>=', ["GEQ"])
      end
      should "match >" do
        compare('>', ["GE"])
      end
      should "match ==" do
        compare('==', ["EQ"])
      end
      should "match !=" do
        compare('!=', ["NEQ"])
      end
      should "match &&" do
        compare('&&', ["AND"])
      end
      should "match ||" do
        compare('||', ["OR"])
      end
      should "match =" do
        compare('=', ["ASSIGN"])
      end
      should "match ;" do
        compare(';', ["SEMI"])
      end
      should "match ," do
        compare(',', ["COMMA"])
      end
      should "match newline" do
        queries = [ "\\\n",
                    "\\\t\n",
                    "\\   \n"]
        queries.each { |q| compare q, ["CONTNL"] }
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
        compare  "/*", ["MCOMTER"]
      end

    end

    context "test.cflat" do
      should "replicate results from example" do
        input = "char true boolean\nboolean ( +\nstring s"
        result = ["CHAR", "TRUE", "BOOLEAN", "BOOLEAN", "LPAREN", "PLUS", "STRING", "IDENT(s)"]
        compare input, result
      end
    end

    context "comments" do
      should "produce error token" do
        compare '*/', ["UCOMTER"]
      end
    end

    context "characters" do
      should "produce a character constant token" do
        compare "'a'", ["CHARCON(a)"]
      end

      should "not be a character constant" do
        compare "'abc'", ["INVCON(abc)"]
      end

      should "disallow empty character constants" do
        compare "''", ["INVCON()"]
      end

      should "match escape sequences" do
        valid_escapes = %w{n 0}
        valid_escapes.each do |v|
          sequence = "'\\#{v.lstrip}'"
          result = ["CHARCON(\\#{v.lstrip})"]
          compare sequence, result
        end
      end

      should "return character for non-special escape sequence" do
        test_escapes = %w{c d e g h ! ^ &}
        test_escapes.each do |t|
          sequence = "'\\#{t.lstrip}'"
          result = ["CHARCON(#{t.lstrip})"]
          compare sequence, result
        end
      end
    end

    context "strings" do
      should "produce a string constant token" do
        compare '"a"', ["STRCON(a)"]
      end

      should "produce a longer string constant" do
        input = '"Why, you stuck up, half-witted, scruffy-looking Nerf herder."'
        compare input, ["STRCON(#{input[1...-1]})"]
      end

      should "handle escaped double quote in string" do
        input = '"\""'
        compare input, ["STRCON(#{input[1...-1]})"]
      end

      should "report missing closing double quote" do
        input = '"asdfasdf
        '
        compare input, ["STRCON(asdfasdf)", "MSTRTER"]
      end

      should "report that string is too long" do
        input = '"' + "a"*259 + '"'
        compare input, ["STRCON(#{'a'*255})", "STRLNG"]
      end
    end

    context "fibonacci sequence example" do
      should "match the expected result" do
        input = <<-'EOF'
          int x=35;
          void fib( int x )
          {
            if(x<2) {
              return 1;
            } else {
              return fib(x-1)+fib(x-2);
            } }
            int main() {
              int i=x;
                while(i>0) {
                  print "fib(", i, ") = ", fib(i), "\n";
                  i=i-1; }
              return 0;
           }
        EOF
        expected = %w{INT IDENT(x) ASSIGN NUM(35) SEMI VOID IDENT(fib) LPAREN INT
                      IDENT(x) RPAREN LCURLY IF LPAREN IDENT(x) LE NUM(2) RPAREN
                      LCURLY RETURN NUM(1) SEMI RCURLY ELSE LCURLY RETURN IDENT(fib)
                      LPAREN IDENT(x) MINUS NUM(1) RPAREN PLUS IDENT(fib) LPAREN
                      IDENT(x) MINUS NUM(2) RPAREN SEMI RCURLY RCURLY INT IDENT(main)
                      LPAREN RPAREN LCURLY INT IDENT(i) ASSIGN IDENT(x) SEMI WHILE
                      LPAREN IDENT(i) GE NUM(0) RPAREN LCURLY PRINT STRCON(fib()
                      COMMA IDENT(i) COMMA STRCON()\ =\ ) COMMA IDENT(fib) LPAREN
                      IDENT(i) RPAREN COMMA STRCON(\\n) SEMI IDENT(i) ASSIGN IDENT(i)
                      MINUS NUM(1) SEMI RCURLY RETURN NUM(0) SEMI RCURLY EOS}
        compare input, expected
      end
    end

    context "randomness" do
      should "not raise an error" do
        assert_nothing_raised do
          random = `cat /dev/urandom | strings | head -100`
          random.encode!("ISO-8859-1", invalid: :replace)
          input = random.encode("UTF-8", invalid: :replace)
          l = Lexer.new
          l.lex(input)
        end
      end
    end

  end
end

