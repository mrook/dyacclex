%{
unit expr;

interface


uses 
	dlib,
	yacclib,
	lexlib;


var x : array [1..26] of Real;



%}

%token <Real> NUM       /* constants */
%token <Integer> ID     /* variables */
%type <Real> expr	/* expressions */

%left '+' '-'      	/* operators */
%left '*' '/'
%right UMINUS

%token ILLEGAL 		/* illegal token */

%%

input	: /* empty */
	| input '\n'		 { yyaccept; }
	| input expr '\n'	 { writeln($2:10:2); }
	| input ID '=' expr '\n' { x[$2] := $4; writeln($4:10:2); }
	| error '\n'             { yyerrok; }
	;

expr    :  expr '+' expr	 { $$ := $1 + $3; }
	|  expr '-' expr	 { writeln('LDC ', $1); writeln('LDC ', $3); writeln('SUB'); }
	|  expr '*' expr	 { $$ := $1 * $3; }
	|  expr '/' expr	 { $$ := $1 / $3; }
	|  '(' expr ')'		 { $$ := $2; }
	|  '-' expr              { $$ := -$2; }
           %prec UMINUS
	|  NUM                   { $$ := $1; }
        |  ID                    { $$ := x[$1]; }
	;

%%

{$I exprlex.pas}

var 
	i : Integer;
	
begin
  for i := 1 to 26 do x[i] := 0.0;
end.
