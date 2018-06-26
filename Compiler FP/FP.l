%{
#include "y.tab.h"
%}
digit	[0-9]
letter	[a-z]
%%
\n	{
		//return(0);
	}
[ \t]	{
		//printf("%s\n",yytext);
		//return(yytext[0]);
		;
	}
"+"|"-"|"*"|"/"		{
				//printf("%s\n",yytext);
				return(yytext[0]);
			}
">"|"<"|"="	{
			return(yytext[0]);
		}
"("|")"		{
			//printf("%s\n",yytext);
			return(yytext[0]);
		}
"mod"		{
			return(mod);
		}
"and"		{
			return(and);
		}
"or"		{
			return(or);
		}
"not"		{
			return(not);
		}
"#f"|"#t"	{
			yylval.word = strdup(yytext);
			return(boolval);
		}
"if"		{
			return(ifop);
		}
"define"	{
			return(define);
		}
"fun"		{
			return (fun);
		}
"print-num"	{
			//printf("%s\n",yytext);
			return(printnum);
		}
"print-bool"	{
			//printf("%s\n",yytext);
			return(printbool);
		}
0|[1-9]{digit}*|-[1-9]{digit}*	{
					//printf("%s\n",yytext);
					yylval.ival = atoi(yytext);
					return(number);
				}
{letter}({letter}|{digit}|"-")*	{
					yylval.word = strdup(yytext);
					return(id);
				}
.		{
			return(yytext[0]);
		}
%%
