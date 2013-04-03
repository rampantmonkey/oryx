# C-Flat 2013

C-Flat is a working subset of C designed for use in compilers courses. C-Flat includes expressions, control flow, recursion, and strict type checking. This document will outline an **informal** description of the language, its features, and design decisions.

## Operators

C-Flat includes many of the arithmetic operators found in C. Here they are enumerated with precedence.

    ( )                  grouping            ^   (highest precedence)
    * /                  multiplication      |
    + -                  addition            |
    < <= >= == !=        comparison          |
    &&                   logical and         |
    ||                   logical or          |
    =                    assignment         ---  (lowest precedence)

## Types

C-Flat is strictly typed. This means that there is no type casting or type promotion, which means that an error occurs when the operand types differ. C-Flat supports four or five types (depending on how you count). All types can be used as function return types and can all (except for void) be used as a type of variable.

### Integer

    int x = 123;

`integers` are always signed 32-bit values.

### Character

    char c = 'q';

`character` represents a single ASCII character.

### String

    string s = "hello world\n";

A `string` is an immutable, doubly quoted list of `character`s.

### Boolean
    boolean b = false;

`boolean` represents the literal values *true* and *false*.

### Void

Void is slightly different than all the other types. It can only be used in one context, the return type of a function. In this context, `void` indicates that the function does not return a value.



