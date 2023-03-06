%{
    // BIL 395 - Programming Languages - HW 1
    // METIN EREN DURUCAN    201101038
    // ONUR ÖZCAN            211101050
    // peakasso.l - Lexical Analyzer for Peakasso
    #include <stdio.h>
    #include <string.h>
    #include "peakasso.tab.h"

    int line_number = 1;
    int tabnum = 0;
    int yyparse();
    int yyterminate();
    void yyerror(char *errormsg);
%}

alpha [a-zA-Z]
digit [0-9]

%option noyywrap
%option noinput

%%

"PROGRAM"                       { return PROGRAM; }
"CANVAS-INIT-SECTION"           { return CANVAS_INIT_SECTION; }
"CONST"                         { return CONST; }
"CanvasX"                       { return CanvasX; }
"CanvasY"                       { return CanvasY; }
"BRUSH-DECLARATION-SECTION"     { return BRUSH_DECLARATION_SECTION; }
"BRUSH"                         { return BRUSH; }
"DRAWING-SECTION"               { return DRAWING_SECTION; }
"RENEW-BRUSH"                   { return RENEW_BRUSH; }
"PAINT-CANVAS"                  { return PAINT_CANVAS; }
"EXHIBIT-CANVAS"                { return EXHIBIT_CANVAS; }
"MOVE"                          { return MOVE; }
"TO"                            { return TO; }
"CursorX"                       { return CursorX; }
"CursorY"                       { return CursorY; }
"PLUS"                          { return PLUS; }
"MINUS"                         { return MINUS; }
";"                             { return SEMICOLON; }
":"                             { return COLON; }
","                             { return COMMA; }
"="                             { return ASSIGN; }
{alpha}({alpha}|{digit})*       { yylval.string = yytext; return id; }

[\n]	                        { line_number++; } 

[\t ]+	                        { tabnum++; }

"!!".*                          /* skip comments */ { ; }

[-+]?{digit}+                   { yylval.value = atoi(yytext); return INT_LIT; }

['].*[']                        { yylval.string = yytext; return MESSAGE; }

.                               { yyerror("Unknown command"); return *yytext; }

%%