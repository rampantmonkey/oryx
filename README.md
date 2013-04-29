# Oryx
C-Flat to x86 compiler.

## Progress

- 20 Feb 13
    + Oryx 0.1.1
    + Lexer complete
- 1 April 13
    + Oryx 0.2.1
    + Parse Tree successfully generated
- 3 April 13
    + Oryx 0.2.7
    + Symbol Table implemented
- 29 April 13
    + Oryx 0.3.1
    + Abstract Syntax Tree defined and generated
    + Fixed Travis errors by pre-compiling LLVM shared library

## C-Flat
C-Flat is a working subset of C designed for use in compilers courses. C-flat includes expressions, basic control flow, recursive functions, and strict type checking. It is object-compatible with ordinary C and thus can take advantage of the standard C library, at least when using limited types.

## Installation

    $ gem install oryx

## Requirements

- Ruby >= 1.9.3
- [LLVM 3.0](http://llvm.org/releases/) shared library

## Usage

    $ oryx ~/test.cflat

For more details try

    $ oryx -h

## See Also

`doc/intro.md`


## Contributing
As this is a course project pull requests will be ignored.

## Build Status
[![Build Status](https://travis-ci.org/rampantmonkey/oryx.png?branch=master)](https://travis-ci.org/rampantmonkey/oryx)

Provided by [Travis-CI](http://travis-ci.org)

## License

MIT
