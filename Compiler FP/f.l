%{
#include "y.tab.h"
unsigned count=0;
%}
letter 	 [a-z]
digit 	 [0-9]
%%
[ \t\n]		{}
"("|")"		{return(yytext[0]);}
"+"|"-"|"/"|"*" {return(yytext[0]);}
"print-num"	{return(printnum);}
"print-bool"	{return(printbl);}
"mod"		{return(mod);}
"and"		{return(and);}
"or"		{return(or);}
"not"		{return(not);}
"#t"|"#f"	{yylval.der = strdup(yytext); return(DER);}
"if"		{return(ifop);}
"define"	{return(define);}
0|[1-9]{digit}*|-[1-9]{digit}*	{yylval.rval = atoi(yytext); return(number);}
{letter}({letter}|{digit}|'-')*	{yylval.idd = strdup(yytext); return(ID);}
.		{return(yytext[0]);}

%%
