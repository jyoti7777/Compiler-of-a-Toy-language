%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
void yyerror(char *);
int yywrap(void);
extern FILE * lexout;
FILE * yyin;
%}

%%

(int)  {fprintf(lexout, "Data Type: int\n"); yylval.str=strdup(yytext); return INT ;}
(char[ ]*\*)  {fprintf(lexout, "Data Type: char *\n"); yylval.str=strdup(yytext); return CHAR_P ;}
(return)        {fprintf(lexout, "Keyword: return\n"); yylval.str=strdup(yytext); return RETURN;}
(if)        {fprintf(lexout, "Keyword_control_statement: if\n"); yylval.str=strdup(yytext); return IF;}
(else)        {fprintf(lexout, "Keyword_control_statement: else\n"); yylval.str=strdup(yytext); return ELSE;}
(while)        {fprintf(lexout, "Keyword_control_statement: while\n"); yylval.str=strdup(yytext); return WHILE;}
[a-zA-Z][a-zA-Z0-9_]*    {yylval.str=strdup(yytext); fprintf(lexout, "Identifier: %s\n", yylval.str); return ID;}
[0-9]+                   {yylval.str=strdup(yytext); fprintf(lexout,"NUM: %s\n",yylval.str); return NUM;}
(;)                      {fprintf(lexout, "Semi colon: ;\n"); yylval.str=strdup(yytext);return SEMI;}
(,)                  {fprintf(lexout, "Comma: ,\n"); yylval.str=strdup(yytext);return COMMA;}
[=]{2}                {yylval.str=strdup(yytext); fprintf(lexout, "Equals: ==\n");return EQQ;}
(\/\*[^\/\*]*\*\/)       {yylval.str = strdup(yytext) ; fprintf(lexout, "Comment: %s\n", yylval.str); return COMMENT;}
[=]                    {yylval.str=strdup(yytext); fprintf(lexout, "Assignment: =\n"); return EQ;}
[&]{2}                 {yylval.str=strdup(yytext); fprintf(lexout, "AND: =\n"); return AND;}
[|]{2}                 {yylval.str=strdup(yytext); fprintf(lexout, "OR: =\n"); return OR;}
[-]                    {yylval.str=strdup(yytext); fprintf(lexout, "Minus: -\n");return MINUS;}
[+]                    {yylval.str=strdup(yytext); fprintf(lexout, "Plus: +\n");return PLUS;}
[\*]                    {yylval.str=strdup(yytext); fprintf(lexout, "Multiply: *\n");return MULTI;}
[\/]                    {yylval.str=strdup(yytext);fprintf(lexout, "Divide: /\n"); return DIVIDE;}
(!=)                    {yylval.str=strdup(yytext); fprintf(lexout, "Not equals: != \n");return NEQQ;}
(<)                     {yylval.str=strdup(yytext); fprintf(lexout, "Less than: %s\n", yylval.str); return LESS_THAN;}
(<=)                    {yylval.str=strdup(yytext); fprintf(lexout, "Less than equal to: %s\n", yylval.str); return LESS_THAN_EQ;}
(>)                     {yylval.str=strdup(yytext); fprintf(lexout, "Greater than: %s\n", yylval.str); return GREATER_THAN;}
(>=)                     {yylval.str=strdup(yytext); fprintf(lexout, "Greater than equal to: %s\n", yylval.str); return GREATER_THAN_EQ;}
(\()                   {yylval.str=strdup(yytext); fprintf(lexout, "Left Bracket: %s\n", yylval.str); return LEFT_BRAC;}
(\))                   {yylval.str=strdup(yytext); fprintf(lexout, "Right Bracket: %s\n", yylval.str); return RIGHT_BRAC;}
(\{)                   {yylval.str=strdup(yytext); fprintf(lexout, "Left Curly Bracket: %s\n", yylval.str); return LEFT_CURLY;}
(\})                   {yylval.str=strdup(yytext); fprintf(lexout, "Right Curly Bracket: %s\n", yylval.str); return RIGHT_CURLY;}
[ \t\n]                   
(.)                    {yyerror("Lexer Syntax Error\n");}
%%
int yywrap(){
    return 1;
}



