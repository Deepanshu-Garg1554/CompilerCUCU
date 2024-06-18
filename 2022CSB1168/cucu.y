%{
#include <stdio.h>
#include <math.h>
int yylex();
void yyerror(char const *);
extern FILE *yyin,*yyout,*fp;
%}

%token INTEGER CHARACTER LOOP CONDITIONAL OTHERWISE RETURNS COMMA ASSIGNMENT ADDITION SUBTRACTION MULTIPLICATION DIVISION LOG_AND LOG_OR SEMICOLON LEFT_BRACE RIGHT_BRACE LEFT_BRACKET RIGHT_BRACKET LEFT_SQUARE_BRACKET RIGHT_SQUARE_BRACKET GREATER_THAN LESS_THAN EQUAL NOT_EQUAL LESS_THAN_OR_EQUAL GREATER_THAN_OR_EQUAL
%union{
    int numeric_value;
    char *chstr;
}
%token <numeric_value> NUMBER
%token <chstr> IDENTIFIER
%token <chstr> STRING
%left ADDITION SUBTRACTION
%left MULTIPLICATION DIVISION
%left LEFT_BRACKET RIGHT_BRACKET

%%
programs : program
;

program : variable_declaration {fprintf(yyout,"\n");}
    | function_declaration {fprintf(yyout,"\n");}
    | function_definition {fprintf(yyout,"\n");}
    | program variable_declaration {fprintf(yyout,"\n");}
    | program function_declaration {fprintf(yyout,"\n");}
    | program function_definition {fprintf(yyout,"\n");}
;

variable_declaration : dat_type_int ident SEMICOLON  
    | dat_type_int ident ASSIGNMENT expr SEMICOLON {fprintf(yyout,"Assignment : =\n");}
    | dat_type_char ident SEMICOLON
    | dat_type_char ident ASSIGNMENT litstr SEMICOLON {fprintf(yyout,"Assignment : =\n");}        
;

function_declaration : dat_type_int ident LEFT_BRACKET function_arguments RIGHT_BRACKET SEMICOLON {fprintf(yyout,"Function declared above\n\n");}
    | dat_type_int ident LEFT_BRACKET RIGHT_BRACKET SEMICOLON {fprintf(yyout,"Function declared above\n\n");}
    | dat_type_char ident LEFT_BRACKET function_arguments RIGHT_BRACKET SEMICOLON {fprintf(yyout,"Function declared above\n\n");}
    | dat_type_char ident LEFT_BRACKET RIGHT_BRACKET SEMICOLON {fprintf(yyout,"Function declared above\n\n");}
;

function_arguments : dat_type_int ident {fprintf(yyout,"Function Arguments Passed Above\n\n");}
    | dat_type_int ident COMMA function_arguments
    | dat_type_char ident {fprintf(yyout,"Function Arguments Passed Above\n\n");}
    | dat_type_char ident COMMA function_arguments
;

function_call :  ident LEFT_BRACKET RIGHT_BRACKET SEMICOLON
    | ident LEFT_BRACKET para RIGHT_BRACKET SEMICOLON
;

para : bool_expr
    | bool_expr COMMA para
;

function_definition : dat_type_int ident LEFT_BRACKET function_arguments RIGHT_BRACKET function_body {fprintf(yyout,"Function Defined above\n\n");}
    | dat_type_int ident LEFT_BRACKET RIGHT_BRACKET function_body {fprintf(yyout,"Function Defined above\n\n");}
    |   dat_type_char ident LEFT_BRACKET function_arguments RIGHT_BRACKET function_body {fprintf(yyout,"Function Defined above\n\n");}
    | dat_type_char ident LEFT_BRACKET RIGHT_BRACKET function_body {fprintf(yyout,"Function Defined above\n\n");}
;

function_body : LEFT_BRACE stmt_list RIGHT_BRACE
    | stmt
;

stmt_list : stmt_list stmt
    | stmt
;

stmt : variable_declaration
    | function_call {fprintf(yyout,"Function call ends \n\n");}
    | expr SEMICOLON
    | condition {fprintf(yyout,"if Condition Ends \n\n");}
    | loop {fprintf(yyout,"while Loop Ends \n\n");}
    | assignment_stmt
    | return_stmt {fprintf(yyout,"Return statement \n\n");}
;

assignment_stmt : expr ASSIGNMENT bool_expr SEMICOLON
;

return_stmt : RETURNS SEMICOLON
    | RETURNS bool_expr SEMICOLON
;

condition : CONDITIONAL LEFT_BRACKET bool_expr RIGHT_BRACKET function_body
    | CONDITIONAL LEFT_BRACKET bool_expr RIGHT_BRACKET function_body OTHERWISE function_body
;

loop : LOOP LEFT_BRACKET bool_expr RIGHT_BRACKET function_body
;

bool_expr : bool_expr LESS_THAN bool_expr {fprintf(yyout,"Relational Operator : < \n");}
    | bool_expr GREATER_THAN bool_expr {fprintf(yyout,"Relational Operator : > \n");}
    | bool_expr EQUAL bool_expr {fprintf(yyout,"Relational Operator : == \n");}
    | bool_expr NOT_EQUAL bool_expr {fprintf(yyout,"Relational Operator : != \n");}
    | bool_expr LESS_THAN_OR_EQUAL bool_expr {fprintf(yyout,"Relational Operator : <= \n");}
    | bool_expr GREATER_THAN_OR_EQUAL bool_expr {fprintf(yyout,"Relational Operator : >= \n");}
    | expr
;

expr : LEFT_BRACKET expr RIGHT_BRACKET
    | expr ADDITION expr {fprintf(yyout,"Arithmetic Operator : + \n");}
    | expr SUBTRACTION expr {fprintf(yyout,"Arithmetic Operator : - \n");}
    | expr MULTIPLICATION expr {fprintf(yyout,"Arithmetic Operator : * \n");}
    | expr DIVISION expr {fprintf(yyout,"Arithmetic Operator : / \n");}
    | expr LOG_AND expr {fprintf(yyout,"Logical Operator : & \n");}
    | expr LOG_OR expr {fprintf(yyout,"Logical Operator : | \n");}
    | litint
    | litstr              
    | ident
;

ident : IDENTIFIER LEFT_SQUARE_BRACKET expr RIGHT_SQUARE_BRACKET {fprintf(yyout,"Array Variable : %s\n", $1);}
    | IDENTIFIER {fprintf(yyout,"Variable : %s \n", $1);}
;

dat_type_int : INTEGER {fprintf(yyout,"Datatype : int\n");}
;

dat_type_char: CHARACTER {fprintf(yyout,"Datatype : char *\n");}
;

litint : NUMBER {fprintf(yyout,"Value : %d \n", $1);}
;

litstr : STRING {fprintf(yyout,"Value : %s \n", $1);}
;

%%

int main(){
    yyin=fopen("Sample1.cu","r");
    //yyin=fopen("Sample2.cu","r");
    yyout=fopen("parser.txt","w");
    fp=fopen("lexer.txt","w");
    yyparse();
    return 0;
}

void yyerror(char const *s){
    printf("Syntax Error\n");
}
