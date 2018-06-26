%{
unsigned int charCount=0, wordCount=0, lineCount=0;
%}
key  	cpy
letter 	[a-zA-Z_]
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
