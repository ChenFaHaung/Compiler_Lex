key  	noodles
letter 	[a-zA-Z_ 0-9]
eol 	\n
output 	{letter}*{key}{letter}*
%%
{output} {ECHO;printf("\n");}
{eol} ;
.     ;
%%
int main(int argc, char *argv[]) {
	yylex();	
 	return(0);
}
