%{
#include "node.h"
#include "funcoes.h"


class Node;
class Stmts;

%}

%token TOK_INTEIRO TOK_PRINT TOK_DELAY TOK_AGUARDE
%token  TOK_ENTRADA TOK_QUADRADO TOK_DESENHA_UFG
%token TOK_IF TOK_ELSE TOK_ENQUANTO 
%token EQ_OP NE_OP LT_OP GT_OP LE_OP GE_OP


%union {
	char *port;
	char *ident;
	char *str;
	int nint;
	float nfloat;
	Node *node;
	Stmts *stmt;
}

%type <node> term expr factor stmt condblock elseblock whileblock logicfactor  
%type <stmt> stmts
%type <port> TOK_ENTRADA
%type <nint> TOK_INTEIRO

%nonassoc IFX

%start programa

%%

programa : stmts    { Program p;
                      p.generate($1); }
		 ;

stmts : stmts stmt			{ $$->append($2); }
	  | stmt				{ $$ = new Stmts($1); }
	  ;

stmt : 	TOK_QUADRADO 			 			{ $$ = QUADRADO(); }
		| TOK_AGUARDE						{ $$ = AGUARDE (); }
		| TOK_DESENHA_UFG					{ $$ = UFG(); }	
		| TOK_DELAY expr';'					{ $$ = new Delay($2); }
		| condblock							{ $$ = new Capsule($1); }
		| whileblock						{ $$ = new Capsule($1); }
	 ;

condblock : TOK_IF '(' logicfactor ')' stmt %prec IFX				{ $$ = new If($3, $5, NULL); }
		  | TOK_IF '(' logicfactor ')' stmt elseblock				{ $$ = new If($3, $5, $6); }
		  | TOK_IF '(' logicfactor ')' '{' stmts '}' %prec IFX		{ $$ = new If($3, $6, NULL); }
		  | TOK_IF '(' logicfactor ')' '{' stmts '}' elseblock		{ $$ = new If($3, $6, $8); }
		  ;

elseblock : TOK_ELSE stmt				{ $$ = $2; }
		  | TOK_ELSE '{' stmts '}'		{ $$ = $3; }
		  ;

whileblock : TOK_ENQUANTO '(' logicfactor ')' '{' stmts '}' { $$ = new While($3, $6); }
		   ;

logicfactor : '(' logicfactor ')'		{ $$ = new Capsule($2); }
			| expr EQ_OP expr		{ $$ = new CmpOp($1, EQ_OP, $3); }
			| expr NE_OP expr		{ $$ = new CmpOp($1, NE_OP, $3); }
			| expr LE_OP expr		{ $$ = new CmpOp($1, LE_OP, $3); }
			| expr GE_OP expr		{ $$ = new CmpOp($1, GE_OP, $3); }
			| expr LT_OP expr		{ $$ = new CmpOp($1, LT_OP, $3); }
			| expr GT_OP expr		{ $$ = new CmpOp($1, GT_OP, $3); }
			;

expr : expr '+' term			{ $$ = new BinaryOp($1, '+', $3); }
	 | expr '-' term			{ $$ = new BinaryOp($1, '-', $3); }
	 | term					{ $$ = $1; }
	 ;

term : term '*' factor		{ $$ = new BinaryOp($1, '*', $3); }
	 | term '/' factor		{ $$ = new BinaryOp($1, '/', $3); }
	 | factor				{ $$ = $1; }
	 ;

factor : '(' expr ')'		{ $$ = $2; }
	   | TOK_INTEIRO		{ $$ = new Int16($1); }
	   | TOK_ENTRADA		{ $$ = new InPort($1); }
	   ;
%%

extern int yylineno;
extern char *yytext;
extern char *build_filename;

void yyerror(const char *s)
{
	fprintf(stderr, "%s:%d: error: %s %s\n", 
		build_filename, yylineno, s, yytext);
	exit(1);
}

extern "C" int yywrap() {
	return 1;
}

