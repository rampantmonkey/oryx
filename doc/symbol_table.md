# Symbol Table

The symbol table is a key data structure used during the semantic analysis and code generation phases of compilation. Thus a correct and efficient implementation is vital to the success of this project. Here we will discuss the implementation of symbol tables used in Oryx from the basic operations necessary to the design decisions made during development.

## Basic Operations

A symbol table for C-Flat has to support 5 basic operations -- `insert`, `update`, `lookup`, `enter` scope, and `exit` scope. When a variable is declared, regardless of the context, `insert` is used to store the fact that a variable exists. Assigning a value to a variable, whether during initialization or as the result of an expression, requires `update`. It is only possible to `update` a variable that has already been inserted into the table. `lookup` returns the value associated with a given variable. `enter` and `exit` scope are called when entering/exiting a code block which allows previously defined variables to be redefined temporarily.

## Data Structures

The 5 basic operations can be divided into two groups. `insert`, `update`, and `lookup` form the first group while `enter`, `exit` form the second. When looking at these two groupings it is apparent that there is a different data structure which supports each set of instructions. The first group directly maps to a hash table and the second to a stack. These conceptual data structures are represented differently in various programming languages. First we will look at how Ruby provides these structures, then we will see how to combine them into a symbol table.

### Hash Tables in Ruby

As part of the language, Ruby provides a [`Hash` class](http://ruby-doc.org/core-2.0/Hash.html) which implements a hash table. `Hash` stores and retrieves objects by label. A label can be any object which implements the `==` (equality) operator, but the typical objects used for labels are [`String`](http://ruby-doc.org/core-2.0/String.html) and [`Symbol`](http://ruby-doc.org/core-2.0/Symbol.html). `String`s are, as expected, a list of characters. `Symbol`s can be viewed as strings with two important distinctions. `Symbol`s are __immutable__ and __globally__ scoped. `Symbol`s are implemented as a pointer to a memory object containing the name of the symbol, thus comparisons are extremely fast. All of these properties make `Symbol`s an ideal choice for storing values in a hash table.

### Stacks in Ruby

Ruby does not provide a specific `stack` class, however the `push` and `pop` methods are implemented for the [`Array` class](http://ruby-doc.org/core-2.0/Array.html).

## Bringing It Together

Combining these data structures into a symbol table is straight forward. The symbol table is implemented as an `Array` of `Hash`es. The first `Hash` in the `Array` represents the global program scope while successive elements represent more localized scopes. When a function exits the last entry is removed from the `Array`, effectively destroying the values created inside of the scope.
