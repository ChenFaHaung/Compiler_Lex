%{
unsigned int localcount = 0,lettercount = 0,tempcount=0,checkcount=0,linecount=0;
char word[100];
%}
loc	 Favorite
key	 noodles
letter	 [a-zA-z]*
space	 [ \t]*
%%
\n	{strcpy(word,"");tempcount=lettercount;linecount+=1;}
{loc}	{lettercount+=1;if(tempcount==0){localcount=lettercount;};}
{key}	{lettercount+=1;if(lettercount==tempcount+localcount){printf("%s",word);checkcount=tempcount;ECHO;strcpy(word,"");}}
{letter}	{lettercount+=1;strcat(word,yytext);if(checkcount==tempcount&&checkcount!=0){if(lettercount%(linecount+1)==0){printf("%s",word);printf("\n");}}/*if(checkcount==tempcount&&checkcount!=0){ECHO;printf("\n");};strcat(word,yytext);*/}
{space}		{/*if(checkcount==tempcount&&checkcount!=0){ECHO;};*/strcat(word,yytext);}
.	;
%%
int main(int argc, char *argv[]) {
	yylex();
	//printf("localcount=%d,lettercount=%d \n",localcount,lettercount);
	return(0);
}

