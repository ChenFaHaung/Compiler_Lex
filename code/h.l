%{
#include "y.tab.h"
%}

%%
^\n		{return(0);}
\n		;
[ \t]+		{}
load		{yylval.word = strdup(yytext);return(load);}
add		{yylval.word = strdup(yytext);return(add);}
sub		{yylval.word = strdup(yytext);return(sub);}
mul		{yylval.word = strdup(yytext);return(mul);}
mod		{yylval.word = strdup(yytext);return(mod);}
inc		{yylval.word = strdup(yytext);return(inc);}
dec		{yylval.word = strdup(yytext);return(dec);}
[0-9][0-9]*	{yylval.rval = atoi(yytext); return (number);}
.		{return(yytext[0]);}
%%
