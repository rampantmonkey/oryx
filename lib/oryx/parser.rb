require 'rltk'
require_relative "../oryx"

module Oryx
  class Parser < RLTK::Parser

    production(:statment) do
      clause('e SEMI') { |e, _| e }
    end

    production(:e) do
      clause('NUM')   { |i| Number.new i.to_i }
      clause('IDENT') { |i| Variable.new i }

      clause('e PLUS e')  { |e0, _, e1|  Add.new(e0, e1) }
      clause('e MINUS e') { |e0, _, e1|  Sub.new(e0, e1) }
      clause('e TIMES e') { |e0, _, e1|  Mul.new(e0, e1) }
      clause('e DIV e')   { |e0, _, e1|  Div.new(e0, e1) }
    end

    finalize
  end
end
