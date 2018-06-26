%{
int i,j,k;
unsigned int lt=0,rt=0,tbcount=0, tabcount=0, x=0, f=0;
char word[1000];
%}
lt      [^\t\n]*[{]
rt      [^\t\n]*[}]
letter  [^\t\n]+.*
tab     [\t]
%%
{lt}    {for(j=0;j<lt;j++){printf("\t");}ECHO;printf("//%d",lt);printf("\n");lt+=1;tbcount+=1;}
{rt}    {lt--;rt++; for(i=0;i<lt;i++){printf("\t");};ECHO; printf("//%d", lt);tbcount+=1;}
{letter}  {for(i=0;i<lt;i++){printf("\t");} ECHO; printf("//%d", lt);tbcount+=1;}
\n	{if(tbcount==0){for(i=0;i<lt;i++){printf("\t");}printf("//%d\n",lt);}else{printf("\n");};tbcount=0;}
{tab}	;

%%
int main(int argc, char *argv[]) {
        yylex();
        return(0);
}