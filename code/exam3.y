%{
#include <stdio.h>
#include <string.h>
void yyerror(const char *message);
int result[1000];
int count = 0,check = 1;
%}

%union{
	int ival;
	char* word;
}

%token <ival> INUM
%token <word> LOAD
%token <word> ADD
%token <word> SUB
%token <word> MUL
%token <word> MOD
%token <word> INC
%token <word> DEC

%%

stmt    : expr                 { if(count != 1 || check == 0){printf("invalid format\n");}else{printf("%d\n",result[0]);} }
        ;
expr    : expr op
        | op
        ;
op      : LOAD INUM            { result[count] = $2; count = count + 1; }
        | ADD                  { if(count>1){result[count-2] = result[count-1] + result[count-2]; count = count - 1;}else{check = 0;} }
        | SUB                  { if(count>1){result[count-2] = result[count-1] - result[count-2]; count = count - 1;}else{check = 0;} }
        | MUL                  { if(count>1){result[count-2] = result[count-1] * result[count-2]; count = count - 1;}else{check = 0;} }
        | MOD                  { if(count>1){result[count-2] = result[count-1] % result[count-2]; count = count - 1;}else{check = 0;} }
        | INC                  { result[count-1] = result[count-1] + 1;}
        | DEC                  { result[count-1] = result[count-1] - 1;}
        ;

%%
void yyerror(const char *message){
	fprintf(stderr,"%s\n", message);
}

int main(int argc, char *argv[]){
	yyparse();
	return(0);
}
