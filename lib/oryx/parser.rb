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
      clause('ext_dec_list external_declaration') { |edl, ed| edl + Array(ed)}
      clause('external_declaration') { |ed| [ed] }
    end

    production(:vdecl) do
      clause('type_spec IDENT SEMI') { |t, i, _| GDeclaration.new i, t}
    end

    production(:vinit) do
      clause('type_spec IDENT ASSIGN constant SEMI') { |t, i, _, c, _| GInitialization.new i, c, t }
    end

    production(:fdecl) do
      clause('type_spec IDENT LPAREN opt_param_list RPAREN code_block') { |t, i, _, opl,  _, c| Function.new i, opl, c, t }
    end

    production(:opt_param_list) do
      clause('') { || ParamList.new [] }
      clause('param_list') { |pl| ParamList.new pl}
    end

    production(:param_list) do
      clause('param') { |p| [p] }
      clause('param COMMA param_list') { |p, _, pl| Array(p) + pl }
    end

    production(:param) do
      clause('type_spec IDENT') { |t, i| Declaration.new i, t }
    end

    production(:opt_arg_list) do
      clause('') { || ArgList.new [] }
      clause('arg_list') { |al| ArgList.new al}
    end

    production(:arg_list) do
      clause('arg') { |a| [a] }
      clause('arg COMMA arg_list') { |a, _, al| Array(a) + al }
    end

    production(:arg) do
      clause('e') { |e| e }
    end

    production(:constant) do
      clause('NUM')     { |n| Number.new n.to_i }
      clause('STRCON')  { |s| Cstring.new s}
      clause('CHARCON') { |c| Char.new c }
    end

    production(:type_spec) do
      clause('BOOLEAN') { |_| Boolean.new 'bool'}
      clause('CHAR')    { |_| Char.new 'char'}
      clause('INT')     { |_| Int.new 'int'}
      clause('STRING')  { |_| Str.new 'str'}
      clause('VOID')    { |_| }
    end

    production(:code_block) do
      clause('LCURLY statement_list RCURLY') { |_, sl, _| CodeBlock.new(sl) }
    end

    production(:statement_list) do
      clause('') { || [] }
      clause('statement_list statement') { |sl, s| sl + Array(s) }
      clause('statement') { |s| [s] }
    end

    production(:statement) do
      clause('e SEMI') { |e, _| e }
      clause('if_statement') { |i| i}
      clause('WHILE LPAREN e RPAREN code_block') {|_,_,e,_,c| While.new(e,c) }
      clause('type_spec IDENT ASSIGN e SEMI')         { |t, e0, _, e1, _| Initialization.new e0, e1, t }
      clause('type_spec IDENT SEMI')                  { |t, i, _ | Declaration.new i,t }
    end

    production(:if_statement) do
      clause('if_preamble statement')                  { |e, s|      If.new(e, s, nil) }
      clause('if_preamble code_block')                 { |e, c|      If.new(e, c, nil) }
      clause('if_preamble statement ELSE statement')   { |e,ts,_,fs| If.new(e, ts, fs) }
      clause('if_preamble code_block ELSE code_block') { |e,tc,_,fc| If.new(e, tc, fc) }
      clause('if_preamble statement ELSE code_block')  { |e,ts,_,fc| If.new(e, ts, fc) }
      clause('if_preamble code_block ELSE statement')  { |e,tc,_,fs| If.new(e, tc, fs) }
    end

    production(:if_preamble) do
      clause('IF LPAREN e RPAREN') { |_, _, e, _| e }
    end

    production(:e) do
      clause('LPAREN e RPAREN') { |_, e, _| e }

      clause('IDENT') { |i| Variable.new i }
      clause('constant') { |c| c }
      clause('IDENT ASSIGN e') { |e0, _, e1| Assign.new e0, e1 }

      clause('MINUS e')   { |_, e|      Neg.new(e) }
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
      clause('e AND e')   { |e0, _, e1| And.new(e0, e1) }

      clause('TRUE')      { |t| BoolConst.new (:true) }
      clause('FALSE')      { |t| BoolConst.new (:false) }

      clause('RETURN e')  { |_, e| Return.new e }

      clause('IDENT LPAREN opt_arg_list RPAREN') { |i, _, oal, _| Call.new(i, oal) }
    end

  end
end
