# Oryx
![oryx.png](doc/oryx.png)

C-Flat to x86 compiler.

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

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

If you are looking for ideas check out the [issue tracker](https://github.com/rampantmonkey/oryx/issues) or [TODO.md](TODO.md).


## Build Status
[![Build Status](https://travis-ci.org/rampantmonkey/oryx.png?branch=master)](https://travis-ci.org/rampantmonkey/oryx)

Provided by [Travis-CI](http://travis-ci.org)

## License

Oryx is licensed under [The MIT License](http://opensource.org/licenses/MIT).
