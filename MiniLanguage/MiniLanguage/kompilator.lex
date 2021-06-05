%using QUT.Gppg;
%using MiniLanguage;
%namespace GardensPoint

Ident       [a-zA-Z]([a-zA-Z0-9])*
Double      (0|[1-9][0-9]*)\.[0-9]+
Bool        true|false
Int         0|[1-9][0-9]*
Hex         (0x|0X)[0-9a-fA-F]+
Comment     \/\/.*\n
String      ".*"


%%

"program"     { return (int)Tokens.Program; }
"int"         { yylval.type=new IntMiniType(); return (int)Tokens.Type; }
"double"      { yylval.type=new DoubleMiniType(); return (int)Tokens.Type; }
"bool"        { yylval.type=new BoolMiniType(); return (int)Tokens.Type; }
"{"           { return (int)Tokens.OpenBrace; }
"}"           { return (int)Tokens.CloseBrace; }
","           { return (int)Tokens.Comma; }
";"           { return (int)Tokens.Semicolon; }
"="           { return (int)Tokens.Assign; }
"&&"          { return (int)Tokens.And; }
"||"          { return (int)Tokens.Or; }
"write"       { return (int)Tokens.Write; }

{Bool}        { yylval.eval=new Const(yytext, new BoolMiniType()); return (int)Tokens.Bool; }
{Int}         { yylval.eval=new Const(yytext, new IntMiniType()); return (int)Tokens.IntNum; }
{Double}      { yylval.eval=new Const(yytext, new DoubleMiniType()); return (int)Tokens.DoubleNum; }
{Hex}         { yylval.eval=new Const(yytext, new IntMiniType(), true); return (int)Tokens.IntNum; }
{Ident}       { yylval.str=yytext; return (int)Tokens.Ident; }


<<EOF>>       { return (int)Tokens.EOF; }
"\r"          { }
" "           { }
"\t"          { }
"\n"          { }
{Comment}     { }
.             { return (int)Tokens.error; }