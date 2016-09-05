%{
#include "node.h"

Int16* liga = new Int16(255);
Int16* desliga = new Int16(0);

Int16* delayCompleto = new Int16(1000);
Int16* delayProximo = new Int16(4000);
Int16* delayMeio = new Int16(500);
Int16* delayMeio1 = new Int16(700);

class Node;
class Stmts;

Stmts *UFG() {
	Stmts *comms = new Stmts(new OutPort("4", liga));
	comms->append(new OutPort("2",liga));
	comms->append(new Delay(delayCompleto));
	comms->append(new OutPort("4", desliga));
	comms->append(new OutPort("2", desliga));

	comms->append(new OutPort("5", liga));
	comms->append(new Delay(delayCompleto));
	comms->append(new OutPort("5", desliga));
	return comms;
}

%}

%token TOK_INTEIRO TOK_PRINT TOK_DELAY
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

%type <node> term expr factor stmt condblock elseblock whileblock logicexpr logicterm logicfactor  
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

stmt : 	TOK_QUADRADO '(' ')' ';' {
								Stmts *comms = new Stmts(new OutPort("2", liga));
								comms->append(new Delay(delayCompleto));
								comms->append(new OutPort("2", desliga));
								comms->append(new OutPort("4",liga));
								comms->append(new Delay(delayMeio1));
								comms->append(new OutPort("7", liga));
								comms->append(new Delay(delayCompleto));
								comms->append(new OutPort("4",desliga));
								comms->append(new OutPort("7", desliga));
								comms->append(new OutPort("3", liga));
								comms->append(new Delay(delayCompleto));
								comms->append(new OutPort("3", desliga));
								comms->append(new OutPort("5", liga));
								comms->append(new OutPort("6", liga));
								comms->append(new Delay(delayMeio));
								comms->append(new Delay(delayMeio));
								comms->append(new OutPort("5", desliga));
								comms->append(new OutPort("6",desliga));

								$$ = comms;
} 	

	| TOK_DESENHA_UFG '(' ')' ';'				{ 
								Stmts *comms = new Stmts(new OutPort("2", liga));
								comms->append(new Delay(delayCompleto));
								comms->append(new OutPort("2", desliga));
								comms->append(new OutPort("4",liga));
								comms->append(new Delay(delayMeio1));
								comms->append(new OutPort("7", liga));
								comms->append(new Delay(delayCompleto));
								comms->append(new OutPort("4",desliga));
								comms->append(new OutPort("7", desliga));
								comms->append(new OutPort("3", liga));
								comms->append(new Delay(delayCompleto));
								comms->append(new OutPort("3", desliga));
								comms->append(new Delay(delayProximo));
								comms->append(new OutPort("5", liga));
								comms->append(new OutPort("6", liga));
								comms->append(new Delay(delayCompleto));
								comms->append(new OutPort("5", desliga));
								comms->append(new OutPort("6",desliga));
								comms->append(new OutPort("2", liga));
								comms->append(new Delay(delayCompleto));
								comms->append(new OutPort("2",desliga));
								comms->append(new OutPort("3", liga));
								comms->append(new Delay(delayMeio1));
								comms->append(new OutPort("3",desliga));
								comms->append(new OutPort("4",liga));
								comms->append(new OutPort("7", liga));
								comms->append(new Delay(delayCompleto));
								comms->append(new OutPort("4",desliga));
								comms->append(new OutPort("7", desliga));
								comms->append(new Delay(delayProximo));
								comms->append(new OutPort("5", liga));
								comms->append(new OutPort("6", liga));
								comms->append(new Delay(delayCompleto));
								comms->append(new OutPort("5", desliga));
								comms->append(new OutPort("6",desliga));
								comms->append(new OutPort("2", liga));
								comms->append(new Delay(delayCompleto));
								comms->append(new OutPort("2",desliga));
								comms->append(new OutPort("3", liga));
								comms->append(new Delay(delayMeio1));
								comms->append(new OutPort("3",desliga));
								comms->append(new OutPort("4",liga));
								comms->append(new OutPort("7", liga));
								comms->append(new Delay(delayCompleto));
								comms->append(new OutPort("4",desliga));
								comms->append(new OutPort("7", desliga));
								comms->append(new OutPort("2", liga));
								comms->append(new Delay(delayMeio1));
								comms->append(new OutPort("2",desliga));
								comms->append(new OutPort("5",liga));
								comms->append(new OutPort("6", liga));
								comms->append(new Delay(delayMeio1));
								comms->append(new OutPort("5",desliga));
								comms->append(new OutPort("6", desliga));

								$$ = comms;
	}	
	 | TOK_DELAY expr';'					{ $$ = new Delay($2); }
	 | condblock						{ $$ = new Capsule($1); }
	 | whileblock						{ $$ = new Capsule($1); }
	 ;

condblock : TOK_IF '(' logicexpr ')' stmt %prec IFX				{ $$ = new If($3, $5, NULL); }
		  | TOK_IF '(' logicexpr ')' stmt elseblock				{ $$ = new If($3, $5, $6); }
		  | TOK_IF '(' logicexpr ')' '{' stmts '}' %prec IFX		{ $$ = new If($3, $6, NULL); }
		  | TOK_IF '(' logicexpr ')' '{' stmts '}' elseblock		{ $$ = new If($3, $6, $8); }
		  ;

elseblock : TOK_ELSE stmt				{ $$ = $2; }
		  | TOK_ELSE '{' stmts '}'		{ $$ = $3; }
		  ;

whileblock : TOK_ENQUANTO '(' logicexpr ')' '{' stmts '}' { $$ = new While($3, $6); }
		   ;

logicexpr : | logicterm						{ $$ = new Capsule($1); }
		  ;

logicterm : logicfactor						{ $$ = new Capsule($1); }
		  ;

logicfactor : '(' logicexpr ')'		{ $$ = new Capsule($2); }
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

