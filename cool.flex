/*
 *  The scanner definition for COOL. Joe Ho 2021/2/3
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

int chk_len(char str[],int k);

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */
char CH1, CH2;
char wkstr[MAX_STR_CONST];
int i = 0;
int j = 1;
int k = 0;
int m = 0;
int totalLEN = 0;
int err = 0;
int flag = 0;
int rezlt = 0;
bool cont = false;
bool ini = true;
bool inC = false;
bool inS = false;
bool NLisOK = false;
bool noADDline = false;
%}

%S MORE FORADD SPECIAL EIOK  
/*
 * Define names for regular expressions here.
 */

DARROW          =>

%%
<<EOF>>  { /*   cout << "in EOF" << endl; */
	/*	cout << "flag in EOF-->" << flag << endl;  */
		if (flag == 66)
		{
			flag = 0;
			inC = false;
			inS = false;
		}
		else {
		if (flag)
		{
			flag = 0;
			inC = false;
			inS = false;
	cool_yylval.error_msg = "Unterminated string constant (flag)";
		  	return  (ERROR);
		}
		else {
		if (inC)
		{
			inC = false;
			cool_yylval.error_msg = "EOF in comment";
		  	return  (ERROR);
		}
		else { if (inS)
		       {
			inS = false;
			cool_yylval.error_msg = "EOF in string constant";
			return  (ERROR);
		}	}	}   }
			
		yyterminate();
	
		  }   /* end of pattern */ 
 /*
  *  Nested comments
  */


<MORE>([ *]|[^*]*)  |
<INITIAL>\(\*[^*]*   { BEGIN MORE;
		inC = true; 
	/* scan newline first */
		for(i=0;i<yyleng;i++)
		{
			if (yytext[i] == 0xa)
			  curr_lineno++;
		}
	/* end of scan */
		  if (yytext[yyleng-1] == 0xa) 
		      { 
		/*	j = 1;       */
		/*	BEGIN 0;     */
		        yyless(yyleng);
  		      }
		  else {
		  	if (yytext[yyleng-1] == '*')
			{
			  CH1 = yyinput();
			  if (CH1 == ')')
			  {
			      	 j--;
				if (j < 0)
				{	j = 1;
					BEGIN 0;
					inC = false;
					; 
				  cool_yylval.error_msg = "UNmatched comment";
					return (ERROR); 
				} else
				 {
				  if (j == 0)
					{  
					  j = 1;
					  BEGIN 0;
					  inC =false;
					   ;
					}
				  else {  ; }
				}  
			}    /* end ) */
				
		else {  
			if (CH1 == '(')
			{
				yyunput(CH1,yytext);
				;
			}
			else  {
			if (CH1 == '*')
			{
			   CH2 = yyinput();
			if (CH2 == ')')
			{	
			      	 j--;
				if (j < 0)
				{	j = 1;
					BEGIN 0;
					inC = false;
					; 
				  cool_yylval.error_msg = "UNmatched comment";
					return (ERROR); 
				} else
				 {
				  if (j == 0)
					{  
					  j = 1;
					  BEGIN 0;
					  inC =false;
					}
				  else {  ; }
				}  
			}    /* end ) */
		else { if (CH2 == '(' || CH2 == '*')
			{ yyunput(CH2,yytext);
			   ;	 }
			else { ; }
		} } } } }
		else { /* last char != 0xa and * */				
			if (yytext[yyleng-1] == '(')
			{  j++;
			   yyinput();
				;
			}
			else {
				yyinput();
				CH1 = yyinput();
				if (CH1 == ')')
				{
			      	 	j--;
					if (j < 0)
					{	j = 1;
						BEGIN 0;
						inC = false;
					; 
				  cool_yylval.error_msg = "UNmatched comment";
					return (ERROR); 
					} else
				 	  {
				  		if (j == 0)
						{  
					  		j = 1;
					  		BEGIN 0;
					  		inC =false;
					   		;
						}
				 	 else {  ; }
				}  }

				else
				{
				 if (CH1 == '(')
				 {
					yyunput(CH1,yytext);
					;
				 }
				else
				{ if (CH1 == '*')
				  {
				    CH2 = yyinput();
				    if (CH2 == ')')
				    { 
			      	 	j--;
					if (j < 0)
					{	j = 1;
						BEGIN 0;
						inC = false;
					; 
				  cool_yylval.error_msg = "UNmatched comment";
					return (ERROR); 
					} else
				 	  {
				  		if (j == 0)
						{  
					  		j = 1;
					  		BEGIN 0;
					  		inC =false;
					   		;
						}
				 	 else {  ; }

				    } }
				    else { if (CH2 == '(' || CH2 == '*')
					   { yyunput(CH2,yytext);
						; }
					
					else { ; }
			} } }
		} } } } }  /* end of pattern */


<INITIAL>\*\)  {
		j =1; inC = false; 
		yyless(yyleng);   
		cool_yylval.error_msg = "Unmatched *)";
		return (ERROR); ;  } 

	/* end of nested comments */

"--".*  { ; }

 /*
  *  The multiple-character operators.
  */
{DARROW}		{ return  (DARROW); }
"<="                      { return  (LE); }
"<-"                      { return  (ASSIGN); }
 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */
[cC][lL][aA][sS][sS]     { return  (CLASS); }
[eE][lL][sS][eE]         { return  (ELSE); }     
[f][aA][lL][sS][eE]      { cool_yylval.boolean = false;
				return  (BOOL_CONST); }
[t][rR][uU][eE]          { cool_yylval.boolean = true;
				return  (BOOL_CONST); }
[fF][iI]                 { return   (FI); }
[iI][fF]                 { return  (IF); }
[iI][nN]                 { return  (IN); }
[iI][nN][hH][eE][rR][iI][tT][sS] { return  (INHERITS); }
[iI][sS][vV][oO][iI][dD] { return  (ISVOID); }
[lL][eE][tT]             { return  (LET); }
[lL][oO][oO][pP]         { return  (LOOP); }
[pP][oO][oO][lL]         { return  (POOL); }
[tT][hH][eE][nN]         { return  (THEN); }
[wW][hH][iI][lL][eE]     { return  (WHILE); }
[cC][aA][sS][eE]         { return  (CASE); }
[eE][sS][aA][cC]         { return  (ESAC); }
[nN][eE][wW]		 { return  (NEW); }
[oO][fF]                 { return  (OF); }
[nN][oO][tT]             { return  (NOT); }


 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */

<INITIAL>\"[^"]* {  
	 
	inS = true;
	   /* cout << "-----------in INITIAL-----------" << endl; */
	/*  cout << "yytext-->" << yytext << endl; */
	/*   cout << "yyleng-->" << yyleng << endl; */	
	/*  cout << "inS -->" << inS << endl; */
	/*  cout << "cont -->" << cont << endl; */
	/*  cout << "flag-->" << flag << endl; */
	 if (ini)
	{
	 totalLEN += (yyleng-1);
	    /* cout << "INITIAL ini" << endl;  */
	 ini = false;
	}
	 else 
	{
	    /* cout << "INITIAL not ini" << endl; */
	 totalLEN += yyleng;
	}

	  /* cout << "-----------before for loop ------------" << endl; */
	  /* cout << "totalLen-->" << totalLEN << endl;  */
	/*  cout << "last CH-->" << yytext[yyleng-1] << endl; */
 /*
  * scan func  (INITIAL state)
  */

		 cont = false;    /* ok ? 2021/1/30 */
	for(i = 0;i < yyleng;i++)	
	{
	 /*  cout << "loop i -->" << i << endl; */
	   CH1 = yytext[i];
	    /* cout << "THIS CH1-->" << CH1 << endl; */
	   switch(CH1){
	       case 0x0: err = 1;
		     	  break;
	       case 0xa: if (NLisOK)
			{
			if (i == (yyleng-1))  
			{
				flag = 1;
				BEGIN SPECIAL;
			}
			else
				BEGIN 0;
				
			  cont =true;  
			  curr_lineno++;  
			  wkstr[k] = 0xa;
			  k++;
			  yyless(i+1);
			  break;
			  }
			else
			{
			   err = 2;  
			   cont = true;
			   break;
			}     
	       case 0x5c: if (i == (yyleng-1))
		     {
			cont = true;
			totalLEN--;
			break;
		     }
		     	else
		     {
			cont = false;
			  i++;	
		   CH2 = yytext[i];
	   /* cout << "THIS CH2-->" << CH2 << endl; */
		     switch(CH2){
			case 'n': wkstr[k] = 0xa; break;
			case 'b': wkstr[k] = 0x8; break;
			case 't': wkstr[k] = 0x9; break;
			case 'f': wkstr[k] = 0xc; break;
		/*	case 'r': wkstr[k] = 0xd; break;  */
			case '0': wkstr[k] = 0x30; break;
			case ' ': wkstr[k] = 0x20; NLisOK = true; break;
			case 0x0: wkstr[k] = 0x0; err = 4; break;
			case 0xa: wkstr[k] = 0xa; 
				if (i == (yyleng-1)) 
				{
				/*	flag = 1;  */
					BEGIN SPECIAL;
					wkstr[k] = 0xa;
					curr_lineno++;
 					cont = true;
					NLisOK = true; 
				/*	flag = 1; */
 					break;
				}
				while(true)
				{
				 if (yytext[i+1] != 0xa)
					break;
				wkstr[k] = 0xa;
				k++;
				totalLEN++;
				curr_lineno++;
				i++;
				}
				if (i == (yyleng-1))
				{
					cont = true;
				/*	flag = 1; */
					BEGIN SPECIAL;
					wkstr[k] = 0xa;
					curr_lineno++; 
					NLisOK = true;
 					break;
				}
				else
				{
					cont = true;
					wkstr[k] = 0xa;
					curr_lineno++; 
					NLisOK = true;
 					break;
				}
			case 0x8: wkstr[k] = 0x8; NLisOK = true; break;
			case 0x9: wkstr[k] = 0x9; NLisOK = true; break;
			case 0xc: wkstr[k] = 0xc; NLisOK = true; break;
			default: wkstr[k] = CH2; break; } 
			totalLEN--;
		/*	cont = false;   */
			k++; 
			break;}
  
  /* 	  case '"':    if(!ini)
   *			if (yyleng ==1)
   *			
   *				cont = false;
   *				break;
   *			
   */
		
	  default: wkstr[k] = CH1;
			k++;
			if (i == (yyleng-1))
				cont = false; 
			break; 
	}    
	 /* cout << "cont-->" << cont << endl; */
	/* cout << "NLisOK-->" << NLisOK << endl; */
	/*  cout << "ini-->" << ini << endl; */
	/*  cout << "inS-->" << inS << endl; */
	if (err == 1) 
	{
		  /* cout << "------in err 1------" <<endl; */
		err = 0;
	   	ini = true; 
		inS =false;     
		for (i;i<yyleng;i++)
	 	{
	 		if (yytext[i] == 0xa)
	 			break;
	 	}
		/* cout << "yyleng-->" << yyleng << endl; */
		/* cout << "yytext-->" << yytext << endl; */
		/* cout << "i-->" << i << endl; */
		/* cout << "flag-->" << flag << endl; */
	   	if (i == yyleng)
	  		yyless(yyleng+1);
	   	else
			yyless(i+1);   /* yyleng  */
	 /*  	else */
	/*		yyinput();  */
	/*	yyless(i+1);	*/
	/*	yyinput();	*/
	   	k = 0; totalLEN = 0; cont = false; 
		flag = 66;
		cool_yylval.error_msg = "String contains null cahracter";
	  	     return  (ERROR);
	}
	else
	if (err == 2)   
	{
	   /* cout << "-----------in err 2-----------" << endl; */
	/*  cout << "yytext-->" << yytext << endl; */
	/*  cout << "yyleng-->" << yyleng << endl; */
	 /*  cout << "inS -->" << inS << endl; */
	/*  cout << "cont -->" << cont << endl; */
		inS = false;  
	/*	CH1 = yyinput();  */
	/*	cout << "i-->" << i << endl; */
	/*	CH1 = yytext[i+1];   +2 ?? */
	/*	if (CH1 == '\377') */
	/*	*/
	/*	 cool_yylval.error_msg = "EOF in string constant"; */
	/*		return  (ERROR); */
	/*	  */
	/*	BEGIN FORADD; */
	/*	flag = 1;  */
	/*	BEGIN SPECIAL; */
		err = 0;  
	   	ini = true; 
		curr_lineno++;   
		wkstr[k] = 0xa; 
		k++;
		yyless(i+1);	 /* i+1 ?? or for loop till 0xa ? */
	   	k = 0; totalLEN = 0; cont = false; NLisOK = false; 
         	cool_yylval.error_msg = "Unterminated string constant (err2)"; 
	 	    return  (ERROR); 
		/* no need break for 0xa should be the last char */
	}
	else
	if (err == 3)  /* no one come here */
	{
	 /* cout << "-----------in err 3-----------" << endl;  */
	/* cout << "yytext-->" << yytext << endl; */
	/* cout << "yyleng-->" << yyleng << endl;  */
	/* cout << "inS -->" << inS << endl; */
		/* cout << "in err 3" <<endl; */
		CH1 = yytext[i+2];  /* +1 ?? */
		if (CH1 == '\377')
		{
		 cool_yylval.error_msg = "EOF in string constant(1)";
			return  (ERROR);
		}
		BEGIN EIOK; 
		err = 0;  
		curr_lineno++;   
		yyless(i+1);	 /* i+1 ?? or for loop till 0xa ? */
        /* 	cool_yylval.error_msg = "Unterminated string constant"; */
	/* 	    return  (ERROR); */
		/* no need break for 0xa should be the last char */
	}
	else
	if (err == 4)   
	{
		 /* cout << "------in err 4------" <<endl; */

		err = 0;
	   	ini = true;
		inS = false;    
		noADDline = true;
		BEGIN FORADD;
	   	if (yytext[yyleng-1] == 0xa)
			yyless(yyleng);
	   	else
			yyinput();
	/*	yyless(i+1);	  i+1 ?? */
	   	k = 0; totalLEN = 0; cont = false; NLisOK = false;
         	cool_yylval.error_msg = "Escaped NULL found"; 
	 	    return  (ERROR); 
	}
	else  /* to be deleted */
	if (err == 5)   
	{
	 /* cout << "-----------in err 5-----------" << endl; */
	/* cout << "yytext-->" << yytext << endl; */
	/* cout << "yyleng-->" << yyleng << endl; */
	/* cout << "inS -->" << inS << endl; */
		/* cout << "--------in err 5-------" <<endl; */
	/*	inS = false;  determinated in SPECIAL state */
		err = 0;
	/*   	ini = true; */
		curr_lineno++;  
		yyless(i+1);	 /* i+1 ?? or for loop till 0xa ? */
	/*   	k = 0; totalLEN = 0; cont = false; NLisOK = false; */
        /* 	cool_yylval.error_msg = "Unterminated string constant 2"; */
	/*	 	    return  (ERROR);   */
	/*	flag = 1;  */
		BEGIN SPECIAL;
		/* no need break for 0xa should be the last char */
	}
	else continue;
	} 
         /* check string length */ 


	   /* cout << "-----------end of for loop  ----------" << endl; */
	   /* cout << "totalLen2-->" << totalLEN << endl; */ 
	   /* cout << "cont2-->" << cont << endl; */ 
	   /* cout << "inS-->" << inS << endl; */
	   /* cout << "flag-->" << flag << endl; */
        if (!cont)
	   {
		/* cout << "-------IN !cont------" << endl; */
		if (flag == 66)
		{
		  flag =0;
		  inS = false;
		}
		else 
		{
		/* cout << "flag (befor write) -->" << flag << endl; */
		/* cout << "yytext -->" << yytext << endl; */
		/* cout << "yyleng -->" << yyleng << endl; */
		CH1 = yyinput();  /* +2 ?? */
		if (CH1 != '"')
		{
		 inS = false;
		 cool_yylval.error_msg = "EOF in string constant(2)"; 
			return  (ERROR);
		}
		else 
		 	yyunput(CH1,yytext); 

		/* rezlt = chk_len(wkstr,k); */
		if (totalLEN < 1025)
		{
		 /* cout << "wkstr-->" << wkstr << endl;  */
		BEGIN 0;
		 if (yytext[yyleng-1] != 0xa) 
			yyinput(); 
	   cool_yylval.symbol = stringtable.add_string(wkstr+1,totalLEN);
	   k = 0; totalLEN = 0; cont = false; 
	   ini = true; inS = false; NLisOK = false;
			  return  (STR_CONST); 
	   }
		else {
			BEGIN 0;
	   		k = 0; totalLEN = 0; cont = false; 
	   		ini = true; inS = false; NLisOK = false;
		 if (yytext[yyleng-1] != 0xa) 
			yyinput(); 
		/*	if (yyleng > 1)  */
		/*	yyinput(); */
			
		cool_yylval.error_msg = "String constant too long";
			return(ERROR);
	}  }
	   
		  }
	else { ;
		/* cout << "flag in contine-->" << flag << endl; */  }
	}
	/* end of string constant */

<FORADD>.  {
	/* cout << "-----------in FORADD-----------" << endl; */
	/* cout << "yytext-->" << yytext << endl; */
	/* cout << "yyleng-->" << yyleng << endl;	*/
	/* cout << "inS -->" << inS << endl; */
		if (noADDline)
			noADDline = false;
		else
 			curr_lineno++;
		inS = false;
		yyunput(yytext[0],yytext); 
	/*	yyless(0);  */
		BEGIN 0;
	  }
<SPECIAL>.|[\n]  {  /*  (.*|(.[\n])*) */
		    /* cout << "--------in SPECIAL-------" << endl; */
		/*   cout << "yytext-->" << yytext << endl; */
		/*   cout << "yyleng-->" << yyleng << endl; */
		/*   cout << "inS -->" << inS << endl; */
		/*   cout << "cont -->" << cont << endl; */
 	/*	curr_lineno++;   */
		while(true)
		{
			if (yytext[0] == 0xa)
			{
			 /* cout << "-----HERE 0xa -----" << endl; */
			  curr_lineno++;
			  wkstr[k] = 0xa;
			  k++;
			  totalLEN++;
		/*	  yyless(1);    */
		/*	  flag = 1;     */
		  	  BEGIN SPECIAL;
			  break;
			}
			if (yytext[0] == '"')
			{	
			  /* cout << "-----HERE 0x22 -----" << endl; */
			  inS = false;    /* ok ? 2021/1/30 */
		if (totalLEN > 1024)
		{
			BEGIN 0;
	   		k = 0; totalLEN = 0; cont = false; 
	   		ini = true; inS = false; NLisOK = false;
		/*	yyless(1);  */
		cool_yylval.error_msg = "String constant too long";
			return(ERROR);
		}
		else {
			BEGIN 0;
		/*	yyless(1);   */
	   cool_yylval.symbol = stringtable.add_string(wkstr+1,totalLEN);
	   k = 0; totalLEN = 0; cont = false; 
	   ini = true; inS = false; NLisOK = false;
			  return  (STR_CONST); 
			} 	}
		 /* cout << "-----HERE others -----" << endl; */
		inS = false; 
	   	ini = true;
		BEGIN 0;
	/*	yyless(0);	 */
		yyless(i+1);	 
	   	k = 0; totalLEN = 0; cont = false; NLisOK = false; 
         	cool_yylval.error_msg = "Unterminated string constant 2"; 
		 	    return  (ERROR);   
		} }
<EIOK>.|[\n]  {  /*  (.*|(.[\n])*) */
		 /* cout << "--------in EIOK-------" << endl; */
		/* cout << "yytext-->" << yytext << endl; */
		/* cout << "yyleng-->" << yyleng << endl; */
		/* cout << "inS -->" << inS << endl; */
 	/*	curr_lineno++;   */
		while(true)
		{
			if (yytext[0] == 0xa)
			{
			  curr_lineno++;
			  wkstr[k] = 0xa;
			  k++;
			  totalLEN++;
		/*	  yyless(1);    */
		  	  BEGIN EIOK;
			  break;
			}
			if (yytext[0] == '"')
			{	
			  inS = false;    /* ok ? 2021/1/30 */
		if (totalLEN > 1024)
		{
			BEGIN 0;
	   		k = 0; totalLEN = 0; cont = false; 
	   		ini = true; inS = false; NLisOK = false;
		/*	yyless(1);  */
		cool_yylval.error_msg = "String constant too long";
			return(ERROR);
		}
		else {
			BEGIN 0;
		/*	yyless(1);   */
	   cool_yylval.symbol = stringtable.add_string(wkstr+1,totalLEN);
	   k = 0; totalLEN = 0; cont = false; 
	   ini = true; inS = false; NLisOK = false;
			  return  (STR_CONST); 
			} 	}
	/*	inS = false; */
	/*   	ini = true;  */ 
	/*	BEGIN HOMORE; */
		BEGIN 0; 
	/*	yyless(0);	 */
		yyless(i+1);	 
	/*   	k = 0; totalLEN = 0; cont = false; NLisOK = false; */
        /* 	cool_yylval.error_msg = "Unterminated string constant 2"; */
	/*	 	    return  (ERROR);  */ 
		} }


[-+]?[0-9]+  {
		if (yytext[0] == 0x2b || yytext[0]  == 0x2d)
		{	
			yyless(1);
			return (yytext[0]);
		}
		else
		{	 
			cool_yylval.symbol = inttable.add_string(yytext);
		  	return  (INT_CONST); 
		}
	}


[A-Z][_a-zA-Z0-9]*  { cool_yylval.symbol = idtable.add_string(yytext);
		return  (TYPEID); }
[a-z][_a-zA-Z0-9]*  { cool_yylval.symbol = idtable.add_string(yytext);
		return  (OBJECTID); }
[_][_a-zA-Z0-9]*  {
		    cool_yylval.error_msg = yytext;
		    yyless(1);
		    return  (ERROR);
		  }

[{] { return (0x7b); }
[(] { return (0x28); }
[)] { return (0x29); }
[}] { return (0x7d); }
[:] { return (0x3a); }
[;] { return (0x3b); }
[+] { return (0x2b); }
[-] { return (0x2d); }
[*] { return (0x2a); }
[/] { return (0x2f); }
"." { return (0x2e); }
[,] { return (0x2c); }
[=] { return (0x3d); }
[<] { return (0x3c); }
['] { return (0x27); }
"@"  { return (0x40); }
"~"  { return (0x7e); }

[ \f\r\t\v]+      { ; }
[\n]             { curr_lineno++; }  

.   		{ ; 
		cool_yylval.error_msg = yytext;
		    return  (ERROR);
		}

 /* { printf("LEX BUG: UNMATCHED %s\n", yytext); } */

%%

int chk_len(char str[],int k)
{
	k--;
	m = k;
	for(i=0;i<k;i++)
	{
		CH1 = str[i];
		switch(CH1) {
			case 0xa :
			case 0x8 :
			case 0x9 :
			case 0xc : m--;break;
			}
	}
		if (m < 1025)
			return 0;
		else
			return 1;
}
