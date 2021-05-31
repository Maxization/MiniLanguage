%using QUT.Gppg;
%using MiniLanguage;
%namespace GardensPoint

Ident       [a-zA-Z]([a-zA-Z0-9])*
Double      (0|[1-9][0-9]*)\.[0-9]+
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

{Ident}       { yylval.str=yytext; return (int)Tokens.Ident; }

<<EOF>>       { return (int)Tokens.EOF; }
"\r"          { }
" "           { }
"\t"          { }
"\n"          { }
.             { return (int)Tokens.error; }