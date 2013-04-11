# Lexer

The lexer is the first step in the compilation of C-Flat. The input for the lexer is the raw source code and the output is a stream of tokens. The lexer processes the source file one character at a time looking for valid *tokens*. Some examples of valid tokens are identifiers, punctuation (commas, semi colons, parentheses, etc.), and string constants. The lexer also removes comments and whitespace.

The main mechanism behind the lexer is a finite automaton. The states are defined by a series of regular expressions. The regular expressions are joined together to form an automaton which represents all of the valid tokens in C-Flat (as well as some error tokens).


## Lexer Rules

Each regular expression is designed to find one type of lexeme and return the corresponding token when complete. Ruby's [block semantics](http://c2.com/cgi/wiki?BlocksInRuby) provide a convienent method for expressing this idiom. Blocks are essentially anonymous functions which can be stored and executed later. Here is an example from the lexer source code.

    rule(/^[^\d\W]\w*/)      { |t| [:IDENT, t] }

There are two important things to know in order to truly appreciate this line of code. The code is divided into two pieces, the rule definition and the function to execute on a successful match. The rule method adds the regular expression to the state machine as a valid pattern. The block has one parameter `t` which represents the matched lexeme and returns a token of type `IDENT` and containing the matched lexeme.


## Lexer States

Some rules do not require a lexeme, e.g. `IF` or `WHILE`. And some are more complicated requiring an additional lexer feature. This additional feature is states and is required for processing string constants and comments.

The term *states* is overloaded in this context so I will use the term *lexer state* when referring to the lexer feature, otherwise I am referring to the 'states' of the finite automaton.

Without *lexer states* each of the accepting states return to the initial start state. *lexer states* can be viewed as an additional start state to which additional rules may be attached or as a new [namespace](http://en.wikipedia.org/wiki/Namespace_(computer_science)) in which to define new rules. The separation created by *lexer states* is useful in processing strings and comments since the only important character is the comment/string terminator. When this token is encountered the *lexer state* is exited and lexing returns to the default state.


## Lexer Flags

One final feature which improves the robustness of the lexer is *flags*. Flags represent certain conditions which should result in an error upon exit but are not currently an error. One such case is comments. A source code file with an unclosed comment is most likely a mistake and is defined as an error in the language specification. Thus Oryx needs to detect this issue.

Flags are boolean values. Oryx uses one flag for comment processing, which is `true` during comment processing and `false` otherwise. When the `EOF` character is read, the lexer checks the status of each flag and prints an error message if the flag is set.



