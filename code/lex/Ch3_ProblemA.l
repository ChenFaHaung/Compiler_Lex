key  	cpy
letter 	[a-zA-Z_0-9]
eol 	\n 
output 	{letter}*{key}{letter}*
%%
{output} {ECHO;printf("\n"); }
{eol}  ;
.       ;
%%
int main(int argc, char *argv[]) {
	yylex();	
 	return(0);
}
