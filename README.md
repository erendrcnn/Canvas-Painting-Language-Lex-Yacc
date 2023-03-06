# Canvas-painting-language

The language:
<!---
# <Peakasso> -> PROGRAM <ID> ; <Canvas Init Section> <Brush Declaration Section> <Drawing Section>
# <Canvas Init Section> -> CANVAS-INIT-SECTION : <Canvas Size Init> <Cursor Pos Init>
# <Canvas Size Init> -> CONST CanvasX = int_lit ; CONST CanvasY = int_lit ;
# <Cursor Pos Init> -> CursorX = int_lit ; CursorY = int_lit ;
# <Brush Declaration Section> -> BRUSH-DECLARATION-SECTION : [ <Variable Def> ]
# <Variable Def> -> BRUSH <Brush List> ;
# <Brush List> -> <Brush Name> | <Brush Name>, <Brush List>
# <Brush Name> -> <ID> [= int_lit int_lit ]
# <ID> | id
# <Drawing Section> -> DRAWING-SECTION : { <Statement>; }
# <Statement> -> <Renew Stmt> | <Paint Stmt> | <Exhibit Stmt> | <Cursor Move Stmt>
# <Renew Stmt> -> RENEW-BRUSH 'message ' <Brush Name>
# <Paint Stmt> -> PAINT-CANVAS <Brush Name>
# <Exhibit Stmt> -> EXHIBIT-CANVAS
# <Cursor Move Stmt> -> MOVE <Cursor> TO <Expression>
# <Cursor> -> CursorX | CursorY
# <Expression> -> <Term> | <Expression> (PLUS | MINUS) <Term>
# <Term> -> <Factor>
# <Factor> -> int_lit | <Cursor> | CanvasX | CanvasY | ( <Expression> )
-->

Other key information about the language is as follows:

TOKENS: 
Other than the keyword lexemes, there are three tokens in the language. 
The _rst is id which is a letter followed by any number
of letters or digits, i.e., ["a"-"z","A"-"Z"] ( ["a"-"z","A"-"Z", "0"-"9"])*.
The second is the int_lit which is a sequence of digits between 0-9, with optional sign symbol (e.g., "+" or "-"). The third one is the message, any sequence of characters other than newline, for user interaction.

COMMENTS: The rest of any line starting with the text "!!" is comment, therefore it should be skipped. Multi-line comments are not allowed.

WHITESPACE CHARS: All whitespace characters, (blank, tab and newline), should be neglected. The only exception is the whitespace characters within the message.

VARIABLES AND TYPES: Every variable belongs to the only type of BRUSH. Every variable (brush) has to be declared but need not to be explicitly
initialized. Each brush has two components height and width, the de- fault values for which are use of undeclared variables in statements is an error and this encounter terminates the program execution.

CONSTANTS: CanvasX and CanvasY are constants, the value of which are initialized at the very beginning and remain the same until the
program quits. The valid ranges are 5 to 200. In case an out of scope value is assigned at the initialization, give a warning and assume the respective value is 100.

OPERATOR SET: There are two arithmetic operators: addition and subtraction, the objective with which are to move the cursor on the canvas.
The operators have the usual meanings for integer arithmetic. In the cursor move statement, in case the CursorX or CursorY moves out of
the canvas, give a warning and use the old value, i.e., such movement statements are neglected.

OPERATOR PRECEDENCE: The operator precedences are already enforced by the grammar.

OPERATOR ASSOCIATIVITY: The operator associativities are already en- forced by the grammar.

AMBIGUITY : The grammar is unambiguous but during implementation you may come up with some problems like lookahead. 
In such problematic cases, you need to rewrite some part of the grammar to get rid of the respective problem.

CASE SENSITIVITY: The language is case-sensitive like C and Java. So, for instance, "A" and "a" are di_erent entities.

RESERVED KEYWORDS: All the lexemes (e.g., RENEW-BRUSH, EXHIBIT-CANVAS, CursorX, CanvasX, PLUS, TO etc.) are reserved and can not be used as identifiers. If used, you are expected to raise a compile time error.

COMMANDS:
* RENEW-BRUSH: The user is allowed to change the height and width of the respective brush.
* PAINT-CANVAS: The respective brush stroke is applied on the canvas at the cursor location (CursorX, CursorY). Top-left of the brush starts at the cursor location.
* EXHIBIT-CANVAS: The current painting is put on the exhibition, i.e., it is displayed on the screen.
* MOVE: CursorX or CursorY is moved to a new location.
