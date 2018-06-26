%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
void yyerror(const char *message);
int datatype[50];
char idstore[50][100], datastore[50][100], temp[100];
int i, idcount, var = 0;// var for check the redefine.
%}
%union {
	int rval;
	char* idd;
	char* der;
	struct struct_of_calculate{
		int type;
		int val;	//0
		char* bln;	//1
	} vall;
	struct struct_of_mutiple_expr{
		int type;
		int add; 	//0
		int equal; 	//0
		int mul;  	//0
		char* equcnt; 	//1 for equal content
		char* andcnt;   //and content
		char* orcnt;    //or content
	} muex;
	struct struct_of_mutiple_ifstmt{
		int type;
		int corrInt;	//store the integer answer
		char* corrCha;	//store the true false answer
	} ifs;
}
%token<rval> number
%token<idd> ID
%token<der> DER
%token mod and or not printnum printbl define ifop
%type<vall> expr numop plus minus mul divide mods great small equal logicop andop orop notop
%type<muex> exprs
%type<ifs> ifels
%type<idd> variab
%%

line	: Stmt 
   	;
Stmt 	: Stmt stmt
	| stmt
	;
stmt 	: expr
	| printSt
	| defSt
     	;
printSt :'(' printnum expr ')'{
		if($<vall>3.type == 0){
			printf("%d\n", $<vall>3.val);
		}else{
			yyerror("Type Error!");
		}
}
    	|'(' printbl expr ')'{
		if($<vall>3.type == 1){
			printf("%s\n", $<vall>3.bln);
		}else{
			yyerror("Type Error!");
		}		
}
     	;
defSt :'(' define variab expr ')'{
	for(i = 0; i < idcount; i++){//redefine default
		if(strcmp(idstore[i], $<idd>3) == 0){
			var = 1;
			yyerror("Type Error!");
		}
	}
	if(var == 0){	
		strcpy(idstore[idcount], $<idd>3);
			switch($<vall>4.type){
			case 0:
				sprintf(temp, "%d", $<vall>4.val); // copy the value by changing value.
				strcpy(datastore[idcount], temp);
				datatype[idcount] = 1;
				break;	
			case 1:
				strcpy(datastore[idcount], $<vall>4.bln);
				datatype[idcount] = 2;
				break;
			}
			idcount += 1; // ready for the next id
			var = 0; 
	}
} 
	;
variab  : ID{
	$<idd>$ = $<idd>1;
}
	;
ifels	: '(' ifop expr expr expr ')' {
	if($<vall>3.type == 1){
		if(strcmp($<vall>3.bln, "#t") == 0){
			if($<vall>4.type == 0){
				$<ifs>$.type = $<vall>4.type;
				$<ifs>$.corrInt = $<vall>4.val;
			}else if($<vall>4.type == 1){
				$<ifs>$.type = $<vall>4.type;
				$<ifs>$.corrCha = $<vall>4.bln;
			}else{
				$<ifs>$.type = 3;
			}		
		}else{
			if($<vall>5.type == 0){
				$<ifs>$.type = $<vall>5.type;
				$<ifs>$.corrInt = $<vall>5.val;
			}else if($<vall>5.type == 1){
				$<ifs>$.type = $<vall>5.type;
				$<ifs>$.corrCha = $<vall>5.bln;
			}else{
				$<ifs>$.type = 3;
			}		
		}
	}else {yyerror("Type error!");}
}
	;
expr	: numop	{
		if($<vall>1.type == 0){
			$<vall>$.val = $<vall>1.val;
		}
		if($<vall>1.type == 1){
			$<vall>$.bln = $<vall>1.bln;  
		}
		$<vall>$.type = $<vall>1.type;
}
	| number{
		$<vall>$.val = $<rval>1;  //pass the value back
		$<vall>$.type = 0;  // remind the type!
}
	| DER{  // boolean value.
		$<vall>$.bln = $<der>1;
		$<vall>$.type = 1;
		
}
	|logicop {
		$<vall>$.bln = $<vall>1.bln;
		$<vall>$.type = $<vall>1.type;
}
	| ifels{ 
	if($<ifs>1.type == 0){
		$<vall>$.val = $<ifs>1.corrInt;
	}else if($<ifs>1.type == 1){
		$<vall>$.bln = $<ifs>1.corrCha;
	}
	$<vall>$.type = $<ifs>1.type;
}	
	| variab {
		for(i = 0; i < idcount; i++){//maybe not only one.
			if(strcmp(idstore[i], $<idd>1) == 0){
				switch(datatype[i]){
					case 1:
						$<vall>$.val = atoi(datastore[i]); // remember to change the data type.
						$<vall>$.type = 0;
						break;
					case 2:
						$<vall>$.bln = datastore[i];
						$<vall>$.type = 1;
						break;
				}
				var = 1; // check to be the variable.
			}
		}
		if(var == 0){ // need to be variable
			yyerror("Type Error!");
		}else{
			var = 0;
		}
}
	;
numop	: plus{
		$<vall>$.type = $<vall>1.type;
		$<vall>$.val = $<vall>1.val;
}
	| minus{
		$<vall>$.type = $<vall>1.type;
		$<vall>$.val = $<vall>1.val;
}
	| divide{
		$<vall>$.type = $<vall>1.type;
		$<vall>$.val = $<vall>1.val;
}
	| mul{
		$<vall>$.type = $<vall>1.type;
		$<vall>$.val = $<vall>1.val;
}
	| mods{
		$<vall>$.type = $<vall>1.type;
		$<vall>$.val = $<vall>1.val;
}
	| great{
		$<vall>$.type = $<vall>1.type;
		$<vall>$.bln = $<vall>1.bln;
}
	| small{
		$<vall>$.type = $<vall>1.type;
		$<vall>$.bln = $<vall>1.bln;
}
	| equal{
		$<vall>$.type = $<vall>1.type;
		$<vall>$.bln = $<vall>1.bln;
}
	;
logicop	: andop{
		$<vall>$.type = $<vall>1.type;
		$<vall>$.bln = $<vall>1.bln;
}
	| orop{
		$<vall>$.type = $<vall>1.type;
		$<vall>$.bln = $<vall>1.bln;
}
	| notop{
		$<vall>$.type = $<vall>1.type;
		$<vall>$.bln = $<vall>1.bln;
}
	;
plus	: '(' '+' exprs ')' {
		if($<muex>3.type == 0){ // muex => exprs' type
			$<vall>$.val = $<muex>3.add;
			$<vall>$.type = 0;
		}else {
			$<vall>$.type = 2;
			printf("Type error!");
		}
}
	;
minus	: '(' '-' expr expr ')' {
		if($<vall>3.type == 0 && $<vall>4.type == 0){
			$<vall>$.val = $<vall>3.val - $<vall>4.val;
			$<vall>$.type = 0;
		}else{$<vall>$.type = 2; printf("Type error!");}
}
	;
divide	: '(' '/' expr expr ')' {
		if($<vall>4.val == 0){yyerror("Denominator cannot be 0!");}
		if($<vall>3.type == 0 && $<vall>4.type == 0){
			$<vall>$.val = $<vall>3.val / $<vall>4.val;
			$<vall>$.type = 0;
		}else {$<vall>$.type = 2; printf("Type error!");}
}
	;
mul	: '(' '*' exprs ')' {
		if($<muex>3.type == 0){
			$<vall>$.val = $<muex>3.mul;
			$<vall>$.type = 0;
		}else {$<vall>$.type = 2; yyerror("Type error!");}
}
	;
mods	: '(' mod expr expr ')' {
		if($<vall>3.type == 0 && $<vall>4.type == 0){
			$<vall>$.val = $<vall>3.val % $<vall>4.val;
			$<vall>$.type = 0;
		}else {$<vall>$.type = 2; yyerror("Type error!");}
}
	;
great	: '(' '>' expr expr ')' {
		if($<vall>3.type == 0 && $<vall>4.type == 0){
			if($<vall>3.val > $<vall>4.val){
				$<vall>$.bln = "#t";
			}else{$<vall>$.bln = "#f";}
			$<vall>$.type = 1;
		}else{$<vall>$.type = 2; yyerror("Type error!");}
}
	;
small	: '(' '<' expr expr ')' {
		if($<vall>3.type == 0 && $<vall>4.type == 0){
			if($<vall>3.val < $<vall>4.val){
			$<vall>$.bln = "#t";
			}else {$<vall>$.bln = "#f";}
			$<vall>$.type = 1;
		}else {$<vall>$.type = 2; yyerror("Type error!");}
}
	;
equal	: '(' '=' exprs ')' {
		if($<muex>3.type == 0){
			$<vall>$.bln = $<muex>3.equcnt;
			$<vall>$.type = 1;
		}else {$<vall>$.type = 3; yyerror("Type error!");}
}
	;
notop 	: '('not expr ')'	{
		if($<vall>3.type == 1){
			if(strcmp($<vall>3.bln, "#t") == 0){
				$<vall>$.bln = "#f";
			}else if(strcmp($<vall>3.bln, "#f") == 0) {
				$<vall>$.bln = "#t";	
			}
			$<vall>$.type = 1;
		}else {$<vall>$.type = 2;yyerror("Type error!");}
}
	;
andop	: '(' and exprs ')' {
		if($<muex>3.type == 1){
			$<vall>$.bln = $<muex>3.andcnt;
			$<vall>$.type = 1;
		}else {$<vall>$.type = 2; yyerror("Type error!");}
}
	; 
orop	: '(' or exprs ')' {
		if($<muex>3.type == 1){
			$<vall>$.bln = $<muex>3.orcnt;
			$<vall>$.type = 1;
		}else {$<vall>$.type = 2; yyerror("Type error!");}
}
	;
 
exprs	: exprs expr {
		if($<muex>1.type == 0 && $<vall>2.type == 0 ){
			$<muex>$.add = $<muex>1.add + $<vall>2.val;
			$<muex>$.mul = $<muex>1.mul * $<vall>2.val;
			if(strcmp($<muex>1.equcnt, "#t") == 0){
				if($<muex>1.equal == $<vall>2.val){
					$<muex>$.equal = $<vall>1.val;
					$<muex>$.equcnt = "#t";
				}else {$<muex>$.equcnt = "#f";}
			}else {$<muex>$.equcnt = "#f";}
			$<muex>$.type = 0;
		}else if($<muex>1.type == 1 && $<muex>2.type == 1){
			if(strcmp($<muex>1.andcnt, "#t") == 0 && strcmp($<vall>2.bln, "#t") == 0){
				$<muex>$.andcnt = "#t";
			}else {$<muex>$.andcnt = "#f";}

			if(strcmp($<muex>1.orcnt, "#t") == 0 || strcmp($<vall>2.bln, "#t") == 0){
				$<muex>$.orcnt = "#t"; 
			}else {$<muex>$.orcnt = "#f";} 

			$<muex>$.type = 1;
		}else {$<muex>$.type = 2;}	
		
	}
	| expr expr {
		if($<vall>1.type == 0 && $<vall>2.type == 0 ){
			$<muex>$.add = $<vall>1.val + $<vall>2.val;
			$<muex>$.mul = $<vall>1.val * $<vall>2.val;
			if($<vall>1.val == $<vall>2.val){
				$<muex>$.equal = $<vall>1.val;
				$<muex>$.equcnt = "#t";
			}else {$<muex>$.equcnt = "#f";}
			$<muex>$.type = 0;
		}else if($<vall>1.type == 1 && $<vall>2.type == 1){
			if(strcmp($<vall>1.bln, "#t") == 0 && strcmp($<vall>2.bln, "#t") == 0){
				$<muex>$.andcnt = "#t"; 
			}else {$<muex>$.andcnt = "#f";}
 
			if(strcmp($<vall>1.bln, "#t") == 0 || strcmp($<vall>2.bln, "#t") == 0){
				$<muex>$.orcnt = "#t"; 
			}else {$<muex>$.orcnt = "#f";} 

			$<muex>$.type = 1;
		}else {$<muex>$.type = 2;}
		
	}
	;
%%

void yyerror(const char *message)
{
	fprintf(stderr, "%s\n",message);
}

int main(int argc, char *argv[])
{
    yyparse();
    return(0);
}

