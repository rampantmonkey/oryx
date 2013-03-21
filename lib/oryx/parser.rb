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
    end

    finalize
  end
end
