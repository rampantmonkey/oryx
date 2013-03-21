require 'rltk'
require_relative "../oryx"

module Oryx
  class Parser < RLTK::Parser

    left :ASSIGN, :RETURN
    left :EQ, :NEQ
    left :GE, :GEQ, :LE, :LEQ
    left :PLUS, :MINUS
    left :TIMES, :DIV

    production(:input) do
      clause('') { || [] }
      clause('ext_dec_list') { |edl| edl }
    end

    production(:external_declaration) do
      clause('vdecl') { |v| v }
      clause('vinit') { |v| v }
      clause('fdecl') { |f| f }
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

    production(:fdecl) do
      clause('type_spec IDENT LPAREN opt_param_list RPAREN code_block') { |t, i, _, opl,  _, c| c }
    end

    production(:opt_param_list) do
      clause('') { || [] }
      clause('param_list') { |pl| pl }
    end

    production(:param_list) do
      clause('param') { |p| [p] }
      clause('param COMMA param_list') { |p, _, pl| Array(p) + [pl] }
    end

    production(:param) do
      clause('type_spec IDENT') { |t, i| Variable.new i }
    end

    production(:constant) do
      clause('NUM')     { |n| Number.new n.to_i }
      clause('STRCON')  { |s| Cstring.new s}
      clause('CHARCON') { |c| Char.new c }
    end

    production(:type_spec) do
      clause('BOOLEAN') { |_| }
      clause('CHAR')    { |_| }
      clause('INT')     { |_| }
      clause('STRING')  { |_| }
      clause('VOID')    { |_| }
    end

    production(:code_block) do
      clause('LCURLY statement_list RCURLY') { |_, sl, _| sl }
    end

    production(:statement_list) do
      clause('') { || [] }
      clause('statement_list statement') { |sl, s| [sl] + Array(s) }
      clause('statement') { |s| [s] }
    end

    production(:statement) do
      clause('e SEMI') { |e, _| e }
      clause('IF LPAREN e RPAREN statement') { |_, _, e, _, s| If.new(e, s, nil) }
      clause('IF LPAREN e RPAREN statement ELSE statement') { |_,_,e,_,ts,_,fs| If.new(e, ts, fs) }
    end

    production(:e) do
      clause('LPAREN e RPAREN') { |_, e, _| e }

      clause('IDENT') { |i| Variable.new i }
      clause('constant') { |c| c }
      clause('IDENT ASSIGN e') { |e0, _, e1| Assign.new e0, e1 }

      clause('e PLUS e')  { |e0, _, e1| Add.new(e0, e1) }
      clause('e MINUS e') { |e0, _, e1| Sub.new(e0, e1) }
      clause('e TIMES e') { |e0, _, e1| Mul.new(e0, e1) }
      clause('e DIV e')   { |e0, _, e1| Div.new(e0, e1) }
      clause('e GE e')    { |e0, _, e1| GE.new(e0, e1) }
      clause('e GEQ e')   { |e0, _, e1| GEQ.new(e0, e1) }
      clause('e LE e')    { |e0, _, e1| LE.new(e0, e1) }
      clause('e LEQ e')   { |e0, _, e1| LEQ.new(e0, e1) }
      clause('e EQ e')    { |e0, _, e1| EQ.new(e0, e1) }
      clause('e NEQ e')   { |e0, _, e1| NEQ.new(e0, e1) }


      clause('RETURN e')  { |_, e| Return.new e }
    end

    finalize
  end
end
