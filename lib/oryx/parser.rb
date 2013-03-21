require 'rltk'
require_relative "../oryx"

module Oryx
  class Parser < RLTK::Parser

    left :ASSIGN
    left :PLUS, :MINUS
    left :TIMES, :DIV

    production(:input) do
      clause('') { || [] }
      clause('statement_list') { |sl| sl }
    production(:vdecl) do
      clause('type_spec IDENT SEMI') { |t, i, _| Variable.new i}
    end

    production(:type_spec) do
      clause('BOOLEAN') { |_| }
      clause('CHAR')    { |_| }
      clause('INT')     { |_| }
      clause('STRING')  { |_| }
      clause('VOID')    { |_| }
    end

    end

    production(:statement_list) do
      clause('') { || [] }
      clause('statement_list statement') { |sl, s| [sl] + Array(s) }
      clause('statement') { |s| [s] }
    end

    production(:statement) do
      clause('e SEMI') { |e, _| e }
    end

    production(:e) do
      clause('LPAREN e RPAREN') { |_, e, _| e }

      clause('NUM')   { |i| Number.new i.to_i }
      clause('IDENT') { |i| Variable.new i }
      clause('IDENT ASSIGN e') { |e0, _, e1| Assign.new e0, e1 }

      clause('e PLUS e')  { |e0, _, e1|  Add.new(e0, e1) }
      clause('e MINUS e') { |e0, _, e1|  Sub.new(e0, e1) }
      clause('e TIMES e') { |e0, _, e1|  Mul.new(e0, e1) }
      clause('e DIV e')   { |e0, _, e1|  Div.new(e0, e1) }
    end

    finalize
  end
end
