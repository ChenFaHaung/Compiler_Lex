%{
#include "exam3.tab.h"

%}

%%

^\n                { return(0); /* EOF */ }
[ \t]+            { /* do nothing */ }
[0-9]+            { yylval.ival = atoi(yytext); return(INUM); }
load              { yylval.word = strdup(yytext); return(LOAD); }
add               { yylval.word = strdup(yytext); return(ADD); }
sub               { yylval.word = strdup(yytext); return(SUB); }
mul               { yylval.word = strdup(yytext); return(MUL); }
mod               { yylval.word = strdup(yytext); return(MOD); }
inc               { yylval.word = strdup(yytext); return(INC); }
dec               { yylval.word = strdup(yytext); return(DEC); }
.                 { return(yytext[0]); }

%%
