%{
int i,j,k;
unsigned int lt=0,rt=0,tbcount=0, tabcount=0;
char word[1000];
%}
lt	[{]
rt	[}]
letter  [^\t\n]+
tab	[\t]+
%%
{lt}	{for(j=0;j<lt;j++){printf("\t");}ECHO;lt+=1;}
{rt}	{lt-=1;for(k=0;k<lt;k++){printf("\t");}ECHO;rt+=1;}
\n	;
letter	{for(i=0;i<lt;i++){printf("\t");}ECHO;printf("//%d\n",lt);}
{tab}	;
%%
int main(int argc, char *argv[]) {
	yylex();
	return(0);
}
