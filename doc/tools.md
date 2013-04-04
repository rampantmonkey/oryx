# Tools Available

## RLTK

[The Ruby Language Toolkit](https://github.com/chriswailes/RLTK) (or RLTK) by [Chris Wailes](http://chris.wailes.name/) provides a large collection of tools useful for translating languages - lexer generator, parser generator, abstract syntax tree node base class, and LLVM bindings. RLTK is also well documented and includes tutorials on constructing compilers. The LLVM bindings are of particular interest since it is rapidly evolving into an important part of the development toolchain.

## Others

Ruby provides a [foreign function interface](https://github.com/ffi/ffi) for interfacing with C functions and libraries. This means that any options from C, such as `yacc`, are available in Ruby. There are also options to interface with Java libraries so jcup and jflex would also be possibilities. The downside to all of these options is that they require a translation layer between Ruby and the library, which reduces the usefulness of Ruby.
