# Project Name: CUCU Grammar Description and Parser Development

## Overview
Developed a grammar description for the CUCU language, focusing on variable declarations, function declarations, and function definitions. Implemented a lexer to parse CUCU source files, supporting features like comments and control statements.

## Language Features
- **Variable Declaration:** Supports types `int` and `char *`.
- **Function Declaration:** Includes optional function arguments with type and identifier.
- **Function Definition:** Includes optional function arguments and a function body enclosed in braces.
- **Control Statements:** Implemented `if` and `while` statements with support for boolean and arithmetic expressions.
- **Comments:** Supported using `/* */`, ensuring correct parsing and handling within functions and statements.

## Additional Functions Implemented
- `appendParam()`, `printParamList()`, and `freeParamList()`: Manage function parameter lists during declaration, definition, and function calls. Ensured parameter lists are printed alongside function names for clarity in function definitions and calls.

## Lexer Implementation
Designed to parse sample CUCU files (`Sample1.cu` and `Sample2.cu` provided in the repository's main function). Handles nested comments and adheres to CUCU grammar rules for accurate syntax recognition.

## Assumptions and Scope
- Boolean expressions limited to `==`, `!=`, `>`, `<`, `<=`, `>=`, `||`, and `&&`, used specifically in control statements.
- Ensured correct handling of comments inside functions and conditional loops for robust parsing.
- This project aims to provide a comprehensive grammar specification and parser implementation for the CUCU language, enabling developers to understand and extend the language's capabilities efficiently.

## How to Compile and Run (on VS Code)
1. **Step 1:** Install Flex and Bison, if not already installed.
2. **Step 2:** Generate lexer and parser files by executing the commands:
   ```bash
   flex cucu.l
   bison -dy cucu.y
3. **Step 3:** Compile lexer and parser together with
   ```bash
   gcc lex.yy.c y.tab.c -o out
4. **Step 4:** Lexer.txt and Parser.txt are generated as Output files.
