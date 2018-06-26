%{
unsigned int charCount=0, wordCount=0, lineCount=0;
%}
key  	noodles
letter 	[a-zA-Z_ ]
eol 	\n
all 	{letter}*{key}{letter}*
%%
{all} {ECHO;printf("\n");}
{eol} ;
.     ;
%%
int main(int argc, char *argv[]) {
	yylex();	
 	return(0);
}
