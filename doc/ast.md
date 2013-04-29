# Abstract Syntax Tree

## Design

The abstract syntax tree serves as the data structure which bridges parsing and code generation. As such, there should be a simple mapping from parser to AST and from AST to intermediate code.  The base class provided by RLTK is `ASTNode`. This class holds the functionality required for a tree: traversal and references to parents and children.

There are two methods for distinguishing between similar classes (e.g. `Oryx::Add` and `Oryx::Sub`): inheritance or additional parameter. Inheritance was chosen for this project because it is consistent with the traversal method in code generation and it is simpler to create additional objects with the parser.

## Construction

This section describes the creation of an AST from the token stream. Each grammar rule in the parser finds sequences of tokens which match the CFlat language. When the proper match is determined (see [parser documentation](parser.md) for details) Oryx generates a node in the tree. A simple example is the `Oryx::Number` class. This node has one attribute, the integer which the lexeme represents.

## Generation

This section introduces the code generation from the AST. During code generation, `Oryx` traverses the tree and emits intermediate code corresponding to the class type. For example consider `Oryx::Add`. This class has two values (inherited from `Oryx::Binary`) `left` and `right` which correspond directly to the LLVM instruction `add`.

## Class Hierarchy

                   |- Expression -|- Assign          |-  Add
                   |- ParamList   |- Binary ---------|-  Div
                   |              |                  |-  EQ
                   |              |                  |-  GE
                   |              |                  |-  GEQ
                   |              |                  |-  LE
                   |              |                  |-  LEQ
                   |              |                  |-  Mul
                   |              |                  |-  NEQ
                   |              |
    RLTK::ASTNode -|- ArgList     |
                   |              |- Call
                   |- Function    |
                                  |- CodeBlock
                                  |- Declaration ------ GDeclaration
                                  |- If
                                  |- Initialization --- GInitialization
                                  |- Number
                                  |- Return
                                  |                  |- Boolean
                                  |- Type -----------|- Char
                                  |                  |- Int
                                  |                  |- Str
                                  |- Variable
                                  |- While

## Class Descriptions

Here the details of each class of the syntax tree defined in Oryx.

### Add
Subclass of `Binary` for addition.
### ArgList
List of expressions to be evaluated and passed to a function. Only used as a direct descendant of `Call`.
### Assign
Assign the result of an expression to a pre-existing variable.
### Binary
An abstraction designed to represent expressions which have two arguments - `left` and `right`.
### Boolean
Node representing the `boolean` data type.
### Call
Call a function with the given parameters.
### Char
Node representing the `character` data type.
### CodeBlock
A list of expressions surrounded by curly braces.
### Declaration
Declare a new variable with no value.
### Div
Subclass of `Binary` for division.
### EQ
Subclass of `Binary` for equality comparison.
### Expression
Generic base class, inherited from `RLTK::ASTNode` to simplify the interface between the external library.
### Function
Create a new function which contains a list of expressions and optional parameters.
### GDeclaration
Subclass of `Declaration` for variables declared in a global scope.
### GE
Subclass of `Binary` for greater-than comparison.
### GEQ
Subclass of `Binary` for greater-than-or-equal comparison.
### GInitialization
Subclass of `Initialization` for variables initialized in a global scope.
### If
Stores a conditional and two `CodeBlocks` (or `Expressions`) to be evaluated based on result of conditional.
### Initialization
Create a new variable with a default value.
### Int
Node representing the `integer` data type.
### LE
Subclass of `Binary` for less-than comparison.
### LEQ
Subclass of `Binary` for less-than-or-equal comparison.
### Mul
Subclass of `Binary` for multiplication.
### NEQ
Subclass of `Binary` for not-equal comparison.
### Number
Contains the numerical value of a lexeme; used for numerical constants.
### ParamList
List of formal parameters to a `Function`; used in a `Function` definition.
### Return
Return the value of the child of this node from a function.
### Str
Node representing the `string` data type.
### Type
Abstraction designed to represent data types.
### Variable
Variable lookup(or reference).
### While
While loop construct with a `CodeBlock` and an `Expression`.
