# Project Description

[Oryx](https://github.com/rampantmonkey/oryx) is a compiler for the C-Flat language written in [Ruby](http://www.ruby-lang.org/en/).

# Goals

- Produce tokens from source code (Oryx 0.1.1)
- Create parse tree from token stream (Oryx 0.2.1)
- Symbol Table working (Oryx 0.2.7)
- Translate parse tree into AST (Oryx 0.3.1)
- Emit LLVM intermediate code by walking AST (Oryx 0.3.7)
- Loops and Printing (Oryx ?.?.?)
- Implement Semantic Analysis (Oryx ?.?.?)
- Use LLVM optimizations (Oryx ?.?.?)
- Improved error handling (Oryx ?.?.?)

# Implementation Overview

Ruby was chosen as the implementation language since it supports numerous programming styles simultaneously. This feature allows Oryx to use the [programming paradigm](http://en.wikipedia.org/wiki/Programming_paradigm) which most directly models each piece of the compiler. The alternative being choosing one paradigm and forcing each piece of the compiler to fit that model. Ruby elegantly [combines three programming paradigms](http://en.wikipedia.org/wiki/Ruby_(programming_language)) which can produce powerful code that is easy to understand. The three paradigms -- [imperative](http://en.wikipedia.org/wiki/Imperative_programming), [functional](http://en.wikipedia.org/wiki/Functional_programming), and [object oriented](http://en.wikipedia.org/wiki/Object-oriented_programming) -- each shine with different types of problems.

Imperative techniques are a direct abstraction of the capabilities of the execution environment and are therefore provide the least friction when interfacing with the machine (I/O in this program). The functional paradigm is the programming language incarnation of mathematical theory. Due to the strong link to theory, it is simple to implement compiler design (also based strongly in theory). The object oriented paradigm comes from observations about biological systems. Under this paradigm programs are constructed as independent units which communicate, and therefore get work done, by sending messages to other objects. Object oriented techniques tend to be useful for code organization due to their compartmentalization.

Beyond the theoretical reasoning, Ruby has many practical advantages. Ruby's main focus is developer happiness (reference). This goal has lead to many development tools, libraries, and distribution mechanisms. Unit testing (with automation) and static [code analysis](http://codeclimate.org) are two of the development tools I used to assist development of Oryx. Ruby uses gems as the main mechanism for sharing and distributing libraries. The main library used is [RLTK](https://github.com/chriswailes/RLTK). The Ruby Language Tool Kit provides a lexer generator, parser generator, abstract syntax tree nodes, and LLVM bindings.

My familiarity with Ruby re-enforced the choice of language.

# Program Flow

    #####################
    #                   #
    #      source       #
    #                   #
    #####################
             |
             | Character by character
             |
             V
    #####################
    #                   #
    #      lexer        #
    #                   #
    #####################
             |
             | Token Stream
             |
             V
    #####################
    #                   #
    #      parser       #
    #                   #
    #####################
             |
             | Abstract Syntax Tree
             |
             V
    #####################
    #                   #
    #     semantic      #
    #     analysis      #
    #                   #
    #####################
             |
             | Verified Syntax Tree
             |
             V
    #####################
    #                   #
    #       code        #
    #    generation     #
    #                   #
    #####################
             |
             | Executable (via LLVM)
             |
             V


# Table of Contents

- [Introduction](intro.md)
- [C-Flat](cflat.md)
- [Tools Available](tools.md)
- [Lexer](lexer.md)
- [Parser](parser.md)
- [Abstract Syntax Tree](ast.md)
- [Symbol Table](symbol_table.md)
- [Intermediate Representation](intermediate_lang.md)
- [Translation into x86 Assembly](x86_translation.md)
- [Conclusion](conclusion.md)
- [Releases](releases.md)
