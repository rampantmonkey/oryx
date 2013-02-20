# Oryx
C-Flat to x86 compiler.

## Progress

- 20 Feb 13
    + Oryx 0.1.0
    + Lexer complete

## C-Flat
C-Flat is a working subset of C designed for use in compilers courses. C-flat includes expressions, basic control flow, recursive functions, and strict type checking. It is object-compatible with ordinary C and thus can take advantage of the standard C library, at least when using limited types.

## Installation

Add this line to your application's Gemfile:

    gem 'oryx'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oryx

## Usage

    $ oryx ~/test.cflat

For more details try

    $ oryx -h

or

    $ man oryx

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Build Status
[![Build Status](https://travis-ci.org/rampantmonkey/oryx.png)](https://travis-ci.org/rampantmonkey/oryx)

Provided by [Travis-CI](http://travis-ci.org)

## License

MIT
