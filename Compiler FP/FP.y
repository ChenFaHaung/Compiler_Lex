%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
void yyerror(const char* message);
char defineid[50][100];
char data[50][100];
int datastyle[50];
char temp[100];
int definesize = 0;
int loop = 0;
int checkvar = 0;
%}
%union{
int ival;
char* word;
//type = 1 => number type = 2 => bool type = 3 => error
struct s1{int add;int mul;int eqval;char* eqop;char* andop;char* orop;int type;} allop;
//type = 1 => number type = 2 => bool type 3 = error 
struct s2{int val;char* bval;int type;} oper;
struct s3{int type;int ans;char* bans;} ifoper;
}
%token <ival> number
%token <word> boolval id
%token mod and or not ifop define fun printnum printbool
%type <oper> EXPR NUMBEROP PLUS MINU MULT DIVI MOD GREATER SMALLER EQUAL LOGICALOP ANDOP OROP NOTOP
%type <ifoper> CONDEXPR
%type <word> VARIABLE
%type <allop> EXPRS
%%
PROGRAM : STMTS
	;

STMTS : STMTS STMT
      | STMT
      ;

STMT : EXPR
     | PRINTSTMT
     | DEFSTMT
     ;

PRINTSTMT : '('printnum EXPR')'{	
					if($<oper>3.type == 1){
						printf("%d\n",$<oper>3.val);
					}else{
						yyerror("Type Error: Print Type Error.");
					}
			       }
	  | '('printbool EXPR')'{
					if($<oper>3.type == 2){
						printf("%s\n",$<oper>3.bval);
					}else{
						yyerror("Type Error: Print Type Error.");
					}
				}
     	  ;

CONDEXPR : '(' ifop EXPR EXPR EXPR')'{
					if($<oper>3.type == 2){
						if(strcmp($<oper>3.bval,"#t")==0){
							switch($<oper>4.type){
							case 1:
								$<ifoper>$.type = 1;
								$<ifoper>$.ans = $<oper>4.val;
								break;
							case 2:
								$<ifoper>$.type = 2;
								$<ifoper>$.bans = $<oper>4.bval;
								break;
							default:
								$<ifoper>$.type = 3;
								break;
							}
						}else{
							switch($<oper>5.type){
							case 1:
								$<ifoper>$.type = 1;
								$<ifoper>$.ans = $<oper>5.val;
								break;
							case 2:
								$<ifoper>$.type = 2;
								$<ifoper>$.bans = $<oper>5.bval;
								break;
							default:
								$<ifoper>$.type = 3;
								break;
							}
						}
					}else{
						yyerror("Type Error: Conditon expect ‘boolean'.");						
					}
			   	     }
      	 ;

DEFSTMT : '(' define VARIABLE EXPR')'{
					for(loop = 0 ; loop < definesize; loop++){
						if(strcmp(defineid[loop],$<word>3)==0){
							checkvar = 1;
							yyerror("Error :Repet declared variable.");
						}
					}
					if(checkvar == 0){
					//printf("%s\n",$<word>3);
						strcpy(defineid[definesize],$<word>3);
						switch($<oper>4.type){
						case 1:
							datastyle[definesize]=1;
							sprintf(temp,"%d",$<oper>4.val);
							strcpy(data[definesize],temp);
							break;	
						case 2:
							datastyle[definesize]=2;
							strcpy(data[definesize],$<oper>4.bval);						   
							break;
						}
						definesize += 1;
						checkvar = 0;
					}
				     }
	;

VARIABLE : id {
		//printf("id %s\n",$<word>1);
		$<word>$ = $<word>1;
	      }
	 ;

EXPR : number{
		$<oper>$.val = $<ival>1;
		$<oper>$.type = 1;
	     }
     | boolval{
		$<oper>$.bval = $<word>1;
		$<oper>$.type = 2;
	      }
     | NUMBEROP{
			if($<oper>1.type == 1){
				$<oper>$.val = $<oper>1.val;
				//printf("0 %d\n",$<oper>$.val);
			}
			if($<oper>1.type == 2){
				$<oper>$.bval = $<oper>1.bval;
				//printf("1 %s\n",$<oper>$.bval);
			}
			$<oper>$.type = $<oper>1.type;
	       }
     | LOGICALOP{
			$<oper>$.bval = $<oper>1.bval;
			$<oper>$.type = $<oper>1.type;
		}
     | VARIABLE{
			for(loop = 0 ; loop < definesize ; loop++){
				if(strcmp(defineid[loop],$<word>1)==0){
					switch(datastyle[loop]){
					case 1:
						$<oper>$.val = atoi(data[loop]);
						$<oper>$.type = 1;
						break;
					case 2:
						$<oper>$.bval = data[loop];
						$<oper>$.type = 2;
						break;
					}
				checkvar = 1;
				}
			}
			if(checkvar == 0){
				//printf("%d\n",$<oper>$.type);
				yyerror("Error : This variable is undeclared!");
			}else{
				checkvar = 0;
			}
	       }
     | CONDEXPR{
			if($<ifoper>1.type == 1){
				$<oper>$.val = $<ifoper>1.ans;
			}
			if($<ifoper>1.type == 2){
				$<oper>$.bval = $<ifoper>1.bans;
			}
			$<oper>$.type = $<ifoper>1.type;
	       }
     /*| FUNEXPR{
	      }
     | FUNCALL{
	      }*/
     ;

NUMBEROP : PLUS{
			$<oper>$.val = $<oper>1.val;
			$<oper>$.type = $<oper>1.type;
               }
	 | MINU{
			$<oper>$.val = $<oper>1.val;
			$<oper>$.type = $<oper>1.type;
	       }
	 | MULT{
			$<oper>$.val = $<oper>1.val;
			$<oper>$.type = $<oper>1.type;
               }
         | DIVI{
			$<oper>$.val = $<oper>1.val;
			$<oper>$.type = $<oper>1.type;
               }
         | MOD{
			$<oper>$.val = $<oper>1.val;
			$<oper>$.type = $<oper>1.type;
              }
	 | GREATER{
			$<oper>$.bval = $<oper>1.bval;
			$<oper>$.type = $<oper>1.type;
                  }
         | SMALLER{
			$<oper>$.bval = $<oper>1.bval;
			$<oper>$.type = $<oper>1.type;
                  }
         | EQUAL{
			$<oper>$.bval = $<oper>1.bval;
			$<oper>$.type = $<oper>1.type;
                }
         ;

PLUS : '(' '+' EXPRS')'{	
				if($<allop>3.type == 1){
					$<oper>$.val = $<allop>3.add;
					$<oper>$.type = 1;
				}else if($<allop>3.type == 0){
					yyerror("Error: There is undeclared variable.");
				}else if($<allop>3.type == 4){
					$<oper>$.type = 3;
					yyerror("Error: There is undeclared variable.");
					yyerror("Type Error: Expect ‘boolean’ but got ‘number’.");
				}else{
					$<oper>$.type = 3;
					yyerror("Type Error: Expect ‘boolean’ but got ‘number’.");
				}
		       }
     ;

MINU : '(' '-' EXPR EXPR')'{
				if($<oper>3.type==1&&$<oper>4.type==1){
					$<oper>$.val = $<oper>3.val - $<oper>4.val;
					$<oper>$.type = 1;
				}else if($<oper>3.type == 0 || $<oper>4.type == 0){
					yyerror("Error: There is undeclared variable.");
				}

				if($<oper>3.type == 2 || $<oper>3.type == 3 || $<oper>4.type == 2 || $<oper>4.type == 3){
					$<oper>$.type = 3;
					yyerror("Type Error: Expect ‘number’ but got ‘boolean’.");
				}
			   }
     ;

MULT : '(' '*' EXPRS')'{
				if($<allop>3.type == 1){
					$<oper>$.val = $<allop>3.mul;
					$<oper>$.type = 1;
				}else if($<allop>3.type == 0){
					yyerror("Error: There is undeclared variable.");
				}else if($<allop>3.type == 4){
					$<oper>$.type = 3;
					yyerror("Error: There is undeclared variable.");
					yyerror("Type Error: Expect ‘boolean’ but got ‘number’.");
				}else{
					$<oper>$.type = 3;
					yyerror("Type Error: Expect ‘boolean’ but got ‘number’.");
				}
                       }
     ;

DIVI : '(' '/' EXPR EXPR')'{
				if($<oper>3.type==1&&$<oper>4.type==1){
					$<oper>$.val = $<oper>3.val / $<oper>4.val;
					$<oper>$.type = 1;
				}else if($<oper>3.type == 0 || $<oper>4.type == 0){
					yyerror("Error: There is undeclared variable.");
				}

				if($<oper>3.type == 2 || $<oper>3.type == 3 || $<oper>4.type == 2 || $<oper>4.type == 3){
					$<oper>$.type = 3;
					yyerror("Type Error: Expect ‘number’ but got ‘boolean’.");
				}
			   }
     ;

MOD : '(' mod EXPR EXPR')'{
				if($<oper>3.type==1&&$<oper>4.type==1){
					$<oper>$.val = $<oper>3.val % $<oper>4.val;
					$<oper>$.type = 1;
				}else if($<oper>3.type == 0 || $<oper>4.type == 0){
					yyerror("Error: There is undeclared variable.");
				}

				if($<oper>3.type == 2 || $<oper>3.type == 3 || $<oper>4.type == 2 || $<oper>4.type == 3){
					$<oper>$.type = 3;
					yyerror("Type Error: Expect ‘number’ but got ‘boolean’.");
				}
			  }
    ;

GREATER : '(' '>' EXPR EXPR')'{
					if($<oper>3.type==1&&$<oper>4.type==1){
						if($<oper>3.val > $<oper>4.val){
							$<oper>$.bval = "#t";
 						}else{
							$<oper>$.bval = "#f";
						}
						$<oper>$.type = 2;
					}else if($<oper>3.type == 0 || $<oper>4.type == 0){
						yyerror("Error: There is undeclared variable.");
					}

					if($<oper>3.type == 2 || $<oper>3.type == 3 || $<oper>4.type == 2 || $<oper>4.type == 3){
						$<oper>$.type = 3;
						yyerror("Type Error: Expect ‘number’ but got ‘boolean’.");
					}
                              }
        ;

SMALLER : '(' '<' EXPR EXPR')'{	
					if($<oper>3.type==1&&$<oper>4.type==1){
						if($<oper>3.val < $<oper>4.val){
							$<oper>$.bval = "#t";
 						}else{
							$<oper>$.bval = "#f";
						}
						$<oper>$.type = 2;
					}else if($<oper>3.type == 0 || $<oper>4.type == 0){
						yyerror("Error: There is undeclared variable.");
					}

					if($<oper>3.type == 2 || $<oper>3.type == 3 || $<oper>4.type == 2 || $<oper>4.type == 3){
						$<oper>$.type = 3;
						yyerror("Type Error: Expect ‘number’ but got ‘boolean’.");
					}
                              }
        ;

EQUAL : '(' '=' EXPRS')'{
				if($<allop>3.type == 1){
					$<oper>$.bval = $<allop>3.eqop;
					$<oper>$.type = 2;
				}else if($<allop>3.type == 0){
					yyerror("Error: There is undeclared variable.");
				}else if($<allop>3.type == 4){
					$<oper>$.type = 3;
					yyerror("Error: There is undeclared variable.");
					yyerror("Type Error: Expect ‘boolean’ but got ‘number’.");
				}else{
					$<oper>$.type = 3;
					yyerror("Type Error: Expect ‘boolean’ but got ‘number’.");
				}
			}
      ;

LOGICALOP : ANDOP{
			$<oper>$.bval = $<oper>1.bval;
			$<oper>$.type = $<oper>1.type;
		 }
	  | OROP{
			$<oper>$.bval = $<oper>1.bval;
			$<oper>$.type = $<oper>1.type;
		}
          | NOTOP{
			$<oper>$.bval = $<oper>1.bval;
			$<oper>$.type = $<oper>1.type;
		 }
          ;

ANDOP : '(' and EXPRS')'{
				if($<allop>3.type == 2){
					$<oper>$.bval = $<allop>3.andop;
					$<oper>$.type = 2;
				}else if($<allop>3.type == 0){
					yyerror("Error: There is undeclared variable.");
				}else if($<allop>3.type == 4){
					$<oper>$.type = 3;
					yyerror("Error: There is undeclared variable.");
					yyerror("Type Error: Expect ‘boolean’ but got ‘number’.");
				}else{
					$<oper>$.type = 3;
					yyerror("Type Error: Expect ‘boolean’ but got ‘number’.");
				}
			}
      ;

OROP : '(' or EXPRS')'{		if($<allop>3.type == 2){
					$<oper>$.bval = $<allop>3.orop;
					$<oper>$.type = 2;
				}else if($<allop>3.type == 0){
					yyerror("Error: There is undeclared variable.");
				}else if($<allop>3.type == 4){
					$<oper>$.type = 3;
					yyerror("Error: There is undeclared variable.");
					yyerror("Type Error: Expect ‘boolean’ but got ‘number’.");
				}else{
					$<oper>$.type = 3;
					yyerror("Type Error: Expect ‘boolean’ but got ‘number’.");
				}
		      }
     ;

NOTOP : '(' not EXPR')'{
				if($<oper>3.type==2){
					if(strcmp($<oper>3.bval,"#t")==0){
						$<oper>$.bval = "#f";
					}else if(strcmp($<oper>3.bval,"#f")==0){
						$<oper>$.bval = "#t";
					}
					$<oper>$.type = 2;
				}else if($<oper>3.type == 0){
					yyerror("Error: There is undeclared variable.");
				}
				
				if($<oper>3.type == 1 || $<oper>3.type == 3){
					$<oper>$.type = 3;
					yyerror("Type Error: Expect ‘boolean’ but got ‘numbr’.");
				}
		       }
      ;

EXPRS : EXPRS EXPR  {	
			if($<oper>2.type == 1 && $<allop>1.type == 1){
				$<allop>$.add = $<allop>1.add + $<oper>2.val;
				$<allop>$.mul = $<allop>1.mul * $<oper>2.val;
			
				if(strcmp($<allop>1.eqop,"#t")==0){
					if($<allop>1.eqval==$<oper>2.val){
						$<allop>$.eqval = $<allop>1.eqval;
						$<allop>$.eqop = "#t";
					}else{
						$<allop>$.eqop = "#f";
					}		
				}else{
					$<allop>$.eqop = "#f";
				}
				$<allop>$.type = 1;
			}else if($<oper>2.type == 2 && $<allop>1.type == 2){
				//and
				if(strcmp($<allop>1.andop,"#t")==0){
					if(strcmp($<oper>2.bval,"#t")==0){
						$<allop>$.andop = "#t";
					}else{
						$<allop>$.andop = "#f";
					}
				}else{
					$<allop>$.andop = "#f";
				}
				//or
				if(strcmp($<allop>1.orop,"#f")==0){
					if(strcmp($<oper>2.bval,"#t")==0){
						$<allop>$.orop = "#t";
					}else{
						$<allop>$.orop = "#f";
					}
				}else{
					$<allop>$.orop = "#t";
				}
				$<allop>$.type = 2;
			}else if($<allop>1.type == 0 && $<oper>2.type == 0){
				$<allop>$.type = 0;
			}else if($<allop>1.type == 0 || $<oper>2.type == 0){
				$<allop>$.type = 4;
			}else{
				$<allop>$.type = 3;
			}
		    }
      | EXPR EXPR    {
			if($<oper>1.type == 1 && $<oper>2.type == 1){
				$<allop>$.add = $<oper>1.val + $<oper>2.val;
				$<allop>$.mul = $<oper>1.val * $<oper>2.val;
			
				if($<oper>1.val == $<oper>2.val){
					$<allop>$.eqval = $<oper>1.val;
					$<allop>$.eqop = "#t";
				}else{
					$<allop>$.eqop = "#f";
				}
				$<allop>$.type = 1;
			}else if($<oper>1.type == 2 && $<oper>2.type ==2){
				//and
				if(strcmp($<oper>1.bval,"#t")==0 && strcmp($<oper>2.bval,"#t")==0){
					$<allop>$.andop = "#t";
				}else{
					$<allop>$.andop = "#f";
				}
				//or
				if(strcmp($<oper>1.bval,"#t")==0 || strcmp($<oper>2.bval,"#t")==0){
					$<allop>$.orop = "#t";
				}else{
					$<allop>$.orop = "#f";
				}
				$<allop>$.type = 2;
			}else if($<oper>1.type == 0 && $<oper>2.type == 0){
				$<allop>$.type = 0;
			}else if($<oper>1.type == 0 || $<oper>2.type == 0){
				$<allop>$.type = 4;
			}else{
				$<allop>$.type = 3;
			}
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
