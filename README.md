# Oryx
C-Flat to x86 compiler.

## Progress

- 20 Feb 13
    + Oryx 0.1.1
    + Lexer complete

## C-Flat
C-Flat is a working subset of C designed for use in compilers courses. C-flat includes expressions, basic control flow, recursive functions, and strict type checking. It is object-compatible with ordinary C and thus can take advantage of the standard C library, at least when using limited types.

## Installation

    $ gem install oryx

## Requirements

- Ruby >= 1.9.3

## Usage

    $ oryx ~/test.cflat

For more details try

    $ oryx -h

## See Also
`bin/oryx.markdown`


## Contributing
As this is a course project pull requests will be ignored.

## Build Status
[![Build Status](https://travis-ci.org/rampantmonkey/oryx.png?branch=master)](https://travis-ci.org/rampantmonkey/oryx)

Provided by [Travis-CI](http://travis-ci.org)

## License

MIT
