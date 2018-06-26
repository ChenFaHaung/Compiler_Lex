key noodles
sp [ \t]+
letter [a-zA-Z_]+
output {letter}{sp}{letter}{sp}{key}{sp}{letter}
%%
{output} {ECHO;printf("\n");}
.|\n	;
%%
int main(int argc, char *argv[]) {
	yylex();
	return(0);
}
