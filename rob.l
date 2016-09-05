%{

#include "node.h"
#include "bison.hpp"

extern void unescape(char *s);

%}

%option yylineno
%x COMMENT

%%

[ \t\n\r]				{ /* espaços */ }
"/*"					{ yymore(); BEGIN COMMENT; }
<COMMENT>[^*]			{ yymore(); }
<COMMENT>"*"/[^/]		{ yymore(); }
<COMMENT>"*/"			{ BEGIN(INITIAL); }

"//".*$					{ fprintf(stderr, "Comentario: %s\n", yytext); /* comentario de linha */}

"print"					{ return(TOK_PRINT); }

"entrada"[0-9]+			{ yylval.port = strndup(yytext+7, yyleng-7);
						  return(TOK_ENTRADA);
						}
"UFG"					{ return(TOK_DESENHA_UFG); }
"quadrado"			 	{ return(TOK_QUADRADO); }
"delay"					{ return(TOK_DELAY); }
"enquanto"				{ return(TOK_ENQUANTO); }
"=="					{ return(EQ_OP); }
"!="					{ return(NE_OP); }
"<="					{ return(LE_OP); }
">="					{ return(GE_OP); }
">"					{ return(GT_OP); }
"<"					{ return(LT_OP); }

-?[0-9]+				{ yylval.nint = atoi(yytext);
						  return(TOK_INTEIRO); }

"("						{ return('('); }
")"						{ return(')'); }
"{"						{ return('{'); }
"}"						{ return('}'); }


"*"						{ return('*'); }
"/"						{ return('/'); }
"+"						{ return('+'); }
"-"						{ return('-'); }
"="						{ return('='); }
";"						{ return(';'); }

%%


