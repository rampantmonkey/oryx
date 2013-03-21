require 'rltk'
require_relative "../oryx"

module Oryx
  class Parser < RLTK::Parser

    left :ASSIGN
    left :PLUS, :MINUS
    left :TIMES, :DIV

    production(:input) do
      clause('') { || [] }
      clause('ext_dec_list') { |edl| edl }
    production(:external_declaration) do
      clause('vdecl') { |v| v }
      clause('vinit') { |v| v }
    end

    production(:ext_dec_list) do
      clause('') { || [] }
      clause('ext_dec_list external_declaration') { |edl, ed| [edl] + Array(ed) }
      clause('external_declaration') { |ed| [ed] }
    end

    production(:vdecl) do
      clause('type_spec IDENT SEMI') { |t, i, _| Variable.new i}
    end

    production(:vinit) do
      clause('type_spec IDENT ASSIGN constant SEMI') { |t, i, _, c, _| Variable.new i}
    end

    production(:constant) do
      clause('NUM')     { |n| n }
      clause('STRCON')  { |s| s }
      clause('CHARCON') { |c| c }
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
