%{

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
int yylex();
void yyerror(char const *);
 FILE *yyin,*yyout,*lexout;

struct Param {
        char *data_type;
        char *variable_name;
        struct Param *next;
    };
    struct Param *param_list = NULL; // Global parameter list

void appendParam(char *data_type, char *variable_name) {
    struct Param *new_param = (struct Param *)malloc(sizeof(struct Param));
    if (new_param == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    new_param->data_type = data_type;
    new_param->variable_name = variable_name;
    new_param->next = NULL;
    
    if (param_list == NULL) {
        param_list = new_param;
    } else {
        struct Param *temp = param_list;
        while (temp->next != NULL) {
            temp = temp->next;
        }
        temp->next = new_param;
    }
}
void freeParamList() {
    struct Param *temp_param = param_list;
    while (temp_param != NULL) {
        struct Param *next_param = temp_param->next;
        free(temp_param->data_type);
        temp_param->variable_name=NULL;
        free(temp_param->variable_name);
        temp_param=NULL;
        free(temp_param);
        temp_param = next_param;
    }
    param_list = NULL; // Set the global pointer to NULL after freeing the memory
}
void printParamList() {
    struct Param *current = param_list;
    while (current != NULL) {
        if(current->data_type!=NULL){
        fprintf(yyout,"Data type: %s, Variable name: %s\n", current->data_type, current->variable_name);
        }
        else{
         fprintf(yyout,"Variable name: %s\n", current->variable_name); }
    
        current = current->next;
     
    }
}
%}

%union {
    char *str;
}


%token <str> INT CHAR_P RETURN IF ELSE WHILE SEMI COMMA ID LEFT_BRAC RIGHT_BRAC LEFT_CURLY RIGHT_CURLY  COMMENT PLUS MINUS MULTI DIVIDE EQQ NEQQ EQ NUM GREATER_THAN_EQ GREATER_THAN LESS_THAN_EQ LESS_THAN AND OR
%type <str> expr bool bool1 

%left AND OR 
%left GREATER_THAN GREATER_THAT_EQ LESS_THAN LESS_THAN_EQ
%left EQ
%left EQQ NEQQ
%left PLUS MINUS
%left MUL DIVIDE
%left LEFT_BRAC RIGHT_BRAC

%%

programs : program      
;

program : var_decl           {fprintf(yyout,"\n");}
    | func_decl              {fprintf(yyout,"\n");}
    | func_def               {fprintf(yyout,"\n");}
    | program var_decl       {fprintf(yyout,"\n");}
    | program func_decl      {fprintf(yyout,"\n");}
    | program func_def       {fprintf(yyout,"\n");}
    | COMMENT               {fprintf(yyout,"Comment:%s\n",$1);}
    | program COMMENT            {fprintf(yyout,"Comment:%s\n",$2);}   
;



var_decl : INT ident_list SEMI         {fprintf(yyout,"Variable(s) declared above of type int\n");}
         | CHAR_P ident_list SEMI      {fprintf(yyout,"Variable(s) declared above of type char *\n");}           
            ;
ident_list: ID COMMA ident_list         {fprintf(yyout,"variable: %s\n",$1);}
          |ID EQ expr COMMA ident_list {fprintf(yyout,"variable: %s, Assignment : = %s\n",$1,$3);}
          |ID                         {fprintf(yyout,"variable: %s\n",$1);}
          |ID EQ expr       {fprintf(yyout,"variable: %s, Assignment : = %s\n",$1,$3);}
          ;

func_decl : INT ID LEFT_BRAC param_list_id RIGHT_BRAC SEMI           {fprintf(yyout,"Paramter list:");printParamList();freeParamList();fprintf(yyout,"Function %s declared above\n\n",$2);}
    | INT ID LEFT_BRAC RIGHT_BRAC SEMI                           {fprintf(yyout,"Function %s declared above\n\n",$2);}
    | CHAR_P ID LEFT_BRAC param_list_id RIGHT_BRAC SEMI                {fprintf(yyout,"Paramter list:");printParamList();freeParamList();fprintf(yyout,"Function %s declared above\n\n",$2);}
    | CHAR_P ID LEFT_BRAC RIGHT_BRAC SEMI                          {fprintf(yyout,"Function %s declared above\n\n",$2);}
    |INT ID LEFT_BRAC param_list_noid RIGHT_BRAC SEMI           {fprintf(yyout,"Paramter list:");printParamList();freeParamList();fprintf(yyout,"Function %s declared above\n\n",$2);}
    | CHAR_P ID LEFT_BRAC param_list_noid RIGHT_BRAC SEMI                {fprintf(yyout,"Paramter list:");printParamList();freeParamList();fprintf(yyout,"Function %s declared above\n\n",$2);}
;

func_def : INT ID LEFT_BRAC param_list_id RIGHT_BRAC func_body       {fprintf(yyout,"Paramter list:");printParamList();freeParamList();fprintf(yyout,"Function %s Defined above, return type: int\n\n",$2);}
    | INT ID LEFT_BRAC RIGHT_BRAC func_body                      {fprintf(yyout,"Function %s Defined above, return type: int\n\n",$2);}
    | CHAR_P ID LEFT_BRAC param_list_id RIGHT_BRAC func_body           {fprintf(yyout,"Paramter list:");printParamList();freeParamList();fprintf(yyout,"Function %s Defined above, return type: char * \n\n",$2);}
    | CHAR_P ID LEFT_BRAC RIGHT_BRAC func_body                     {fprintf(yyout,"Function %s Defined above, return type: char *\n\n",$2);}
;



param_list_id: CHAR_P ID {
                appendParam($1, $2);         
             }
             | INT ID {
               printf("here\n");
                appendParam($1, $2);
             }
             | CHAR_P ID COMMA param_list_id {
                appendParam($1, $2);
             }
             | INT ID COMMA param_list_id {
                appendParam($1, $2);
             }
          
             ;

param_list_noid: CHAR_P {
                    appendParam($1, NULL);
                 }
               | INT {
                    appendParam($1, NULL);
                 }
               | CHAR_P COMMA param_list_noid {
                    appendParam($1, NULL);
                 }
               | INT COMMA param_list_noid {
                    appendParam($1, NULL);
                 }

               ;




func_body : LEFT_CURLY stmt_list RIGHT_CURLY
;

stmt_list : stmt_list stmt
    | stmt
;

stmt : assign_stmt
    | func_call             
    | return_stmt           
    | condition             {fprintf(yyout,"If Condition Ends \n\n");}
    | loop                  {fprintf(yyout,"While Loop Ends \n\n");}
    | var_decl
    | COMMENT            {fprintf(yyout,"Comment:%s\n",$1);}          
;
  

assign_stmt : ID EQ expr SEMI      {fprintf(yyout,"Variable_name: %s assigns: %s\n\n",$1,$3);}
;
 
return_stmt : RETURN SEMI             {fprintf(yyout,"Return statement: return type: void \n\n");}
    | RETURN expr SEMI                {fprintf(yyout,"Return statement: return type:%s \n\n",$2);}        
; 

act_param_list: expr COMMA act_param_list    {fprintf(yyout,", %s ",$1);}
               | expr                         {fprintf(yyout,"Actual Paramter list: %s",$1);}
               ;

func_call : ID LEFT_BRAC RIGHT_BRAC SEMI   {fprintf(yyout,"\nFunction %s called \n\n",$1);}
    | ID EQ ID LEFT_BRAC RIGHT_BRAC SEMI   {fprintf(yyout,"\nFunction %s returning to: %s, called \n\n",$3,$1);}
    |ID LEFT_BRAC act_param_list RIGHT_BRAC SEMI   {fprintf(yyout,"\nFunction %s called \n\n",$1);}
    | ID EQ ID LEFT_BRAC act_param_list RIGHT_BRAC SEMI   {fprintf(yyout,"\nFunction %s returning to: %s, called \n\n",$3,$1);}
;

condition : IF LEFT_BRAC bool2 RIGHT_BRAC func_body
    | IF LEFT_BRAC bool2 RIGHT_BRAC func_body ELSE func_body
;

loop : WHILE LEFT_BRAC bool2 RIGHT_BRAC func_body  
;
bool2: bool1
     |bool1 bool2
     ;

bool1: bool
     | bool AND bool       
     {  char * content = (char *)malloc(strlen($1) + strlen($3) + strlen(" && ") + 1);
            sprintf(content, "%s && %s", $1, $3);
            $$ = content; 
        fprintf(yyout,"Bool expr: %s Conditional operator  : && %s\n",$1,$3);}

    | bool OR bool        
    {  char * content = (char *)malloc(strlen($1) + strlen($3) + strlen(" || ") + 1);
            sprintf(content, "%s || %s", $1, $3);
            $$ = content; 
        fprintf(yyout,"Bool expr: %s Conditional operator  : || %s\n",$1,$3);}
    ;

bool : bool LESS_THAN bool              
      {  char * content = (char *)malloc(strlen($1) + strlen($3) + strlen(" < ") + 1);
            sprintf(content, "%s < %s", $1, $3);
            $$ = content; 
        fprintf(yyout,"Bool expr: %s Conditional operator  : < %s\n",$1,$3);}
    |bool LESS_THAN_EQ bool              
      {  char * content = (char *)malloc(strlen($1) + strlen($3) + strlen(" <= ") + 1);
            sprintf(content, "%s <= %s", $1, $3);
            $$ = content; 
        fprintf(yyout,"Bool expr: %s Conditional operator  : <= %s\n",$1,$3);}
    | bool GREATER_THAN bool            
    { 
        char * content = (char *)malloc(strlen($1) + strlen($3) + strlen(" > ") + 1);
        sprintf(content, "%s > %s", $1, $3);
        $$ = content; 
        fprintf(yyout,"Bool expr: %s Conditional operator  : > %s\n",$1,$3);}
    | bool EQQ bool                       
    {  char * content = (char *)malloc(strlen($1) + strlen($3) + strlen(" == ") + 1);
        sprintf(content, "%s == %s", $1, $3);
        $$ = content; 
        fprintf(yyout,"Bool expr: %s Conditional operator  : == %s\n",$1,$3);}
    | bool NEQQ bool                    
     {  char * content = (char *)malloc(strlen($1) + strlen($3) + strlen(" != ") + 1);
        sprintf(content, "%s != %s", $1, $3);
        $$ = content; 
        fprintf(yyout,"Bool expr: %s Conditional operator  : != %s\n",$1,$3);}
    | bool GREATER_THAN_EQ bool       
    {  char * content = (char *)malloc(strlen($1) + strlen($3) + strlen(" >= ") + 1);
        sprintf(content, "%s >= %s", $1, $3);
        $$ = content; 
        fprintf(yyout,"Bool expr: %s Conditional operator  : >= %s\n",$1,$3);}
    | expr
;





expr: expr PLUS  expr   {
            char *content = (char *)malloc(strlen($1) + strlen($3) + strlen(" + ") + 1);
            sprintf(content, "%s + %s", $1, $3);
            $$ = content ;
            
            //appendStatement( "Expression", content);
        }
    | expr MINUS  expr  {
            char *content = (char *)malloc(strlen($1) + strlen($3) + strlen(" - ") + 1);
            sprintf(content, "%s - %s", $1, $3);
            $$ = content; 
        }
    | expr MULTI  expr  {
            char *content = (char *)malloc(strlen($1) + strlen($3) + strlen(" * ") + 1);
            sprintf(content, "%s * %s", $1, $3);
            $$ = content ;
        }
    | expr DIVIDE  expr  {
            char *content = (char *)malloc(strlen($1) + strlen($3) + strlen(" / ") + 1);
            sprintf(content, "%s / %s", $1, $3);
            $$ = content ;
        }
    | LEFT_BRAC expr RIGHT_BRAC {
            char *content = (char *)malloc(strlen($2) + 2); // +2 for brackets and null terminator
            sprintf(content, "(%s)", $2);
            $$ = content ;
        }
    | ID  {  
        char *content = (char *)malloc(strlen($1) + strlen("Variable_name:") + 1); // +1 for null terminator
        sprintf(content, "Variable_name:%s", strdup($1));
        $$ = content;
    }
    | NUM  {
        char *content = (char *)malloc(strlen($1) + strlen("Constant literal:") + 1); // +1 for null terminator
        sprintf(content, "Constant literal:%s", strdup($1));
        $$ = content;
    }
    ;

%%

int main()
{
    yyin=fopen("Sample1.cu","r");
    //yyin=fopen("Sample2.cu","r");
    yyout=fopen("parser.txt","w");
    lexout=fopen("lexer.txt","w");
   
    if (yyin == NULL) {
        printf("Error opening the input file.\n");
        return 1; // Exit the program with an error
    }
    yyparse();
    fclose(yyin);
    fclose(lexout);
    fclose(yyout);
    return 0;
}

void yyerror(char const *s){
    //printf("syntaax Error\n");
    fprintf(lexout,"%s\n",s);
    fprintf(yyout,"%s\n",s);
}