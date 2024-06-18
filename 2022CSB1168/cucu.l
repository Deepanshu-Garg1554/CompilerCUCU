%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cucu.tab.h" //Include the generated header file from yacc
FILE *fp;
%}

%%
[ \t]+ ; //Ignore whitespace
\n  ; //Ignore newline
"int" {fprintf(fp,"TYPE : int\n"); return INTEGER;/*Regular expression for tokenizing integer datatype*/}
"char *" {fprintf(fp,"TYPE : char*\n"); return CHARACTER;/*Regular expression for tokenizing char * datatype*/}
"while" {fprintf(fp,"WHILE : while\n"); return LOOP;/*Regular expression for tokenizing while loop*/}
"if" {fprintf(fp,"IF : if\n"); return CONDITIONAL;/*Regular expression for tokenizing if statement*/}
"else" {fprintf(fp,"ELSE : else\n"); return OTHERWISE;/*Regular expression for tokenizing else statement*/}
"return" {fprintf(fp, "RETURN : return\n"); return RETURNS;/*Regular expression for tokenizing return statement*/}
[a-zA-Z][a-zA-Z0-9_]* {fprintf(fp,"ID : %s\n", yytext); yylval.chstr=strdup(yytext); return IDENTIFIER;/*Regular expression for tokenizing identifiers*/}
\"[a-zA-Z0-9]*\" {/*Regular expression for tokenizing string*/
                    fprintf(fp,"STRING : ");
                    for(int idx=1;idx<yyleng-1;idx++){
                        fprintf(fp,"%c",yytext[idx]);
                    }
                    fprintf(fp,"\n");
                    yylval.chstr=strdup(yytext);
                    return STRING;
                    }
[0-9]+ {fprintf(fp,"NUM : %d\n", yylval.numeric_value=atoi(yytext)); return NUMBER; /*Regular expression for tokenizing decimal number*/}
"=" {fprintf(fp,"ASSIGNMENT : =\n"); return ASSIGNMENT;/*Regular expression for tokenizing assignment operator*/}
"+" {fprintf(fp,"ADDITION : +\n"); return ADDITION;/*Regular expression for tokenizing addition operator*/}
"-" {fprintf(fp,"SUBTRACTION : -\n"); return SUBTRACTION;/*Regular expression for tokenizing subtraction operator*/}
"*" {fprintf(fp,"MULTIPLICATION : *\n"); return MULTIPLICATION;/*Regular expression for tokenizing multiplication operator*/}
"/" {fprintf(fp,"DIVISION : /\n"); return DIVISION;/*Regular expression for tokenizing division operator*/}
"&" {fprintf(fp,"LOGICAL AND : &\n"); return LOG_AND;/*Regular expression for tokenizing logical and logical operator*/}
"|" {fprintf(fp,"LOGICAL OR : |\n"); return LOG_OR;/*Regular expression for tokenizing logical or logical operator*/}
">" {fprintf(fp,"GREATER_THAN : >\n"); return GREATER_THAN;/*Regular expression for tokenizing greater than relational operator*/}
"<" {fprintf(fp,"LESS_THAN : <\n"); return LESS_THAN;/*Regular expression for tokenizing less than relational operator*/}
"==" {fprintf(fp,"EQUAL : ==\n"); return EQUAL;/*Regular expression for tokenizing equal to relational operator*/}
"<=" {fprintf(fp,"LESS_THAN_OR_EQUAL : <=\n"); return LESS_THAN_OR_EQUAL;/*Regular expression for tokenizing less than or equal to relational operator*/}
">=" {fprintf(fp,"GREATER_THAN_OR_EQUAL : >=\n"); return GREATER_THAN_OR_EQUAL;/*Regular expression for tokenizing greater than or equal relational operator*/}
"!=" {fprintf(fp,"NOT_EQUAL : !=\n"); return NOT_EQUAL;/*Regular expression for tokenizing not equal relational operator*/}
"," {fprintf(fp,"COMMA : ,\n"); return COMMA;/*Regular expression for tokenizing comma*/}
";" {fprintf(fp,"SEMICOLON : ;\n"); return SEMICOLON;/*Regular expression for tokenizing semicolon*/}
"{" {fprintf(fp,"LEFT_BRACE : {\n"); return LEFT_BRACE;/*Regular expression for tokenizing left curly bracket*/}
"}" {fprintf(fp,"RIGHT_BRACE : }\n"); return RIGHT_BRACE;/*Regular expression for tokenizing right curly bracket*/}
"(" {fprintf(fp,"LEFT_BRACKET : (\n"); return LEFT_BRACKET;/*Regular expression for tokenizing left bracket*/}
")" {fprintf(fp,"RIGHT_BRACKET : )\n"); return RIGHT_BRACKET;/*Regular expression for tokenizing right bracket*/}
"[" {fprintf(fp,"LEFT_SQUARE_BRACKET : [\n"); return LEFT_SQUARE_BRACKET;/*Regular expression for tokenizing left square bracket*/}
"]" {fprintf(fp,"RIGHT_SQUARE_BRACKET : ]\n"); return RIGHT_SQUARE_BRACKET;/*Regular expression for tokenizing right square bracket*/}
\/\*([^(\*\/)]|\n)*\*\/ ; //Ignore multiline comments
. {fprintf(stderr, "Invalid character: %s\n", yytext);} //Error in case of invalid character
%%

int yywrap() {
    return 1;
}
