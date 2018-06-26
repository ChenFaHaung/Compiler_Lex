%{
#include <stdio.h>
#include <string.h>
unsigned int count, i, flag, dect = 0;
unsigned int stack[100];
int ip = 1;
int yylex(void);
void yyerror(const char *message);
%}
%union {
	int rval;
	char* word;
}

%token <rval> number
%token <word> load add sub mul mod inc dec
%%
line	: stmts	{
		if(i != 1 || ip == 0){
			printf("Invalid format\n");
		}else{
			printf("%d\n", stack[0]);}
}
	;
stmts	: stmts stmt
	| stmt
	;
stmt	: load number	{
		stack[i] = $2;
		i += 1;//stack number
}
	| add {
		if(i > 1){
		stack[i-2] = stack[i-1] + stack[i - 2];
		i = i -  1;
		}else{
			ip = 0;
		}
}
	| sub {
		if(i > 1){
		stack[i-2] = stack[i-1] - stack[i - 2];
		i -= 1;
		}else{
			ip = 0;
		}
}
	| mul {
		if(i > 1){
		stack[i - 2] = stack[i - 1] * stack[i - 2];
		i -= 1;
		}else{
			ip = 0;
		}
}
	| mod {
		if(i > 1){
		stack[i - 2] = stack[i - 1] % stack[i - 2];
		i -= 1;
		}else{
			ip = 0;
		}
}
	| inc {
		stack[i - 1] = stack[i - 1] + 1;
}
	| dec {
		stack[i - 1] = stack[i - 1] - 1;
		
}
	;
%%

void yyerror (const char *message) {
	fprintf(stderr, "%s\n", message);
}
int main(int argc, char *argv[]){
	yyparse();
	return 0;
}
