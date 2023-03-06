%{
  // BIL 395 - Programming Languages - HW 1
  // METIN EREN DURUCAN    201101038
  // ONUR ÖZCAN            211101050
  // peakasso.y - a simple parser for the Peakasso language
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <ctype.h>

  #define MAX_BRUSH_COUNT 1000

  extern FILE *yyin;
  extern int line_number;
  extern int tabnum;
  FILE *output;

  char brushArray[200][200];
  char *programName;
  int canvasX = 100, canvasY = 100;
  int cursorX = 0, cursorY = 0;
  int brushCursor = 0;

  int yylex(void);
  void yyerror(char *errormsg);
  int yyparse();
  void initCanvas();
  void renewBrush(char *brushName);
  void paintCanvas(int index);
  void exhibitCanvas();
  void moveCursorX(int delta);
  void moveCursorY(int delta);
  void printBrushes();
  char* trimName(char* str);
  char* extractMessage(char *str);
  
  typedef struct {
    char *name;
    int height;
    int width;
  } Brush;

  // This array stores the brushes that are created in the program
  Brush BRUSHES[MAX_BRUSH_COUNT];

  // prints the current state of the canvas for testing purposes
  void printBrushes() {
    for (int i = 0; i < brushCursor; i++) {
      printf("Brush %d: \n - NAME: %s \n - HEIGHT: %d \n - WIDTH: %d\n", i, BRUSHES[i].name, BRUSHES[i].height, BRUSHES[i].width);
    }
  }

  // Initializes the brush array
  void initCanvas() {
    for (int i = 0; i < canvasY; i++) {
      for (int j = 0; j < canvasX; j++) {
        brushArray[i][j] = ' ';
      }
    }
  }

  // Draw the brush on the canvas
  void paintCanvas(int index) {
    for (int positionY = cursorY; positionY < cursorY + BRUSHES[index].height && positionY < canvasY; positionY++) {
      for (int positionX = cursorX; positionX < cursorX + BRUSHES[index].width && positionX < canvasX; positionX++) {
        brushArray[positionY][positionX] = '*';
      }
    }
  }

  // Print the canvas on the screen
  void exhibitCanvas() {
    // logic to display the current painting on the screen
    for (int i = 0; i < canvasY; i++) {
      for (int j = 0; j < canvasX; j++) {
        // logic to display a single pixel at (i, j)
        if (brushArray[i][j] == '*') {
          putchar('*');
        } else  {
          putchar(' ');
        }
      }
      putchar('\n');
    }
  }

  // Move the cursor to the given position
  void moveCursorX(int delta) {
    if (delta >= 0 && delta <= canvasX) {
      cursorX = delta;
    } else {
      printf("WARNING: CursorX moves out of canvas, movement ignored\n");
    }
  }

  // Move the cursor to the given position
  void moveCursorY(int delta) {
    if (delta >= 0 && delta <= canvasY) {
      cursorY = delta;
    } else {
      printf("WARNING: CursorY moves out of canvas, movement ignored\n");
    }
  }

  // Trim the name of the brush and return it
  char* trimName(char* str) {
    int i = 0;
    int j = 0;
    int len = strlen(str);
    while (i < len && str[i] != '=' && str[i] != ';') {
        if (!isspace(str[i])) {
            str[j++] = str[i];
        }
        i++;
    }
    str[j] = '\0';
    return str;
  }

  // Extract the message from the string and return it
  char* extractMessage(char *str) {
    int i, j, k;
    char *result;
    i = 0;
    j = 0;
    k = 0;
    while (str[i] != '\0') {
      if (str[i] == '\'') {
        j = i + 1;
        while (str[j] != '\'' && str[j] != '\0') {
          j++;
        }
        if (str[j] == '\0') {
          break;
        }
        result = (char *)malloc(j - i);
        for (k = i + 1; k < j; k++) {
          result[k - i - 1] = str[k];
        }
        result[k - i - 1] = '\0';
        return result;
      }
      i++;
    }
    return " ";
  }
%}

// This union is used to store the type information of the tokens
%union {
  int value;
  char *string;
}

// These are the tokens that the parser will recognize
%token PROGRAM
%token <string> id
%token <string> MESSAGE
%token <value> INT_LIT
%token <value> CanvasX 
%token <value> CanvasY 
%token <value> CursorX 
%token <value> CursorY
%token DRAWING_SECTION BRUSH MOVE TO CONST SEMICOLON COLON ASSIGN COMMA
%token EXHIBIT_CANVAS CANVAS_INIT_SECTION BRUSH_DECLARATION_SECTION RENEW_BRUSH PAINT_CANVAS
%token PLUS MINUS

// These are the non-terminals that the parser will recognize
%type <string> ID
%type <string> Brush_Name
%type <string> Cursor
%type <value> Expression
%type <value> Term
%type <value> Factor

// These are the precedence rules for the parser
%left PLUS MINUS
%left TO
%left ASSIGN
%right '(' ')'

// This is the start symbol for the parser
%start Peakasso

%%

// This is the grammar for the parser
Peakasso : PROGRAM ID SEMICOLON Canvas_Init_Section Brush_Declaration_Section Drawing_Section { programName = trimName($2); printf("\n[SYSTEM] : Peakasso program \"%s\" parsed successfully.", programName); }
;

Canvas_Init_Section : CANVAS_INIT_SECTION COLON Canvas_Size_Init Cursor_Pos_Init { initCanvas(); }
;

Canvas_Size_Init : CONST CanvasX ASSIGN INT_LIT SEMICOLON CONST CanvasY ASSIGN INT_LIT SEMICOLON {if ( ($4 >= 5 && $4 <= 200)) {canvasX = $4;} else {printf("CanvasX out of range (canvasX = 100)");  canvasX = 100;} if ( ($9 >= 5 && $9 <= 200)) {canvasY = $9;} else {printf("CanvasY out of range (canvasY = 100)"); canvasY = 100;} }
;

Cursor_Pos_Init : CursorX ASSIGN INT_LIT SEMICOLON CursorY ASSIGN INT_LIT SEMICOLON {cursorX = $3; cursorY = $7;}
;

Brush_Declaration_Section : BRUSH_DECLARATION_SECTION COLON Brush_List
;

Brush_List : Variable_Def
| Brush_List Variable_Def
;

Variable_Def : BRUSH Brush_Name_List SEMICOLON
;

Brush_Name_List : Brush_Name COMMA Brush_Name_List
| Brush_Name 
;

Brush_Name : ID { char *tempName = trimName($1); BRUSHES[brushCursor].name = malloc(strlen(tempName) + 1); strcpy(BRUSHES[brushCursor].name, tempName); BRUSHES[brushCursor].height = 1; BRUSHES[brushCursor].width = 1; brushCursor++; }
| ID ASSIGN INT_LIT INT_LIT { char *tempName = trimName($1); BRUSHES[brushCursor].name = malloc(strlen(tempName) + 1); strcpy(BRUSHES[brushCursor].name, tempName); BRUSHES[brushCursor].height = $3; BRUSHES[brushCursor].width = $4; brushCursor++; }
;

ID : id { $$ = $1; }

Drawing_Section : DRAWING_SECTION COLON Statement_List
;

Statement_List : Statement Statement_List
| Statement
;

Statement : Renew_Stmt
| Paint_Stmt
| Exhibit_Stmt
| Cursor_Move_Stmt
;

Renew_Stmt : RENEW_BRUSH MESSAGE Brush_Name SEMICOLON { int temp = -1; char *tempN = trimName($3); char *msg = extractMessage($2); printf("[MESSAGE] : %s\n", msg); for (int i = 0; i < brushCursor; i++) { if (strcmp(BRUSHES[i].name, tempN) == 0) { temp = i; break; } } if (temp == -1) { printf("[WARN] : Brush \"%s\" not found\n", tempN); } else { scanf("%d %d", &BRUSHES[temp].height, &BRUSHES[temp].width); } }
;

Paint_Stmt : PAINT_CANVAS Brush_Name SEMICOLON { char *tempNameBuffer = trimName($2); for (int i = 0; i < brushCursor; i++) { if (strcmp(BRUSHES[i].name, tempNameBuffer) == 0) { paintCanvas(i); } } }
;

Exhibit_Stmt : EXHIBIT_CANVAS SEMICOLON { exhibitCanvas(); }
;

Cursor_Move_Stmt : MOVE Cursor TO Expression SEMICOLON { if ( strcmp($2, "cursorX") == 0 ) { moveCursorX($4); } else if ( strcmp($2, "cursorY") == 0 ) { moveCursorY($4); } }
;

Expression : Term         { $$ = $1; }
| Expression PLUS Term    { $$ = $1 + $3; }
| Expression MINUS Term   { $$ = $1 - $3; }
;

Term : Factor         { $$ = $1; }
;

Factor : INT_LIT      { $$ = $1; }
| Cursor              { if ( strcmp($1, "cursorX") == 0 ) { $$ = cursorX; } else { $$ = cursorY; } }
| CanvasX             { $$ = canvasX; }
| CanvasY             { $$ = canvasY; }
| '(' Expression ')'  { $$ = $2; } 
;

Cursor : CursorX      { $$ = "cursorX"; }
| CursorY             { $$ = "cursorY"; }
;

%%

// Error handling function
void yyerror(char *errormsg) {
  fprintf(stderr, "[ERROR] Line %d : %s \n", line_number, errormsg);
}

// When the scanner receives an EOF, it calls this function to end the parsing
// If yywrap returns 1, the parsing ends
// If yywrap returns 0, the parsing continues
int yywrap(void)
{
  return 1;
}

// This main function is for input from file (input.txt)
void main(int argc, char *argv[])
{
  FILE *fp;

  fp = fopen("input.txt", "r");
  yyin = fp;

  yyparse();

  // TEST PRINT
  // printBrushes();
}

/* Standart main function (input one by one) 
int main(int argc, char *argv[]) {
  printf("\n|=========================================|");
  printf("\n| [SYSTEM] : Peakasso program is started. |");
  printf("\n|            Type input and press enter.  |");
  printf("\n|=========================================|\n\n");

  return yyparse();
}
*/