%using QUT.Gppg;
%using MiniLanguage;
%namespace GardensPoint

Ident       [a-zA-Z]([a-zA-Z0-9])*
Double      (0|[1-9][0-9]*)\.[0-9]+
Bool        true|false
Int         0|[1-9][0-9]*
Hex         (0x|0X)[0-9a-fA-F]+
Comment     \/\/.*\n
String      \"(\\.|[^"\\\n])*\"

%%

"program"     { return (int)Tokens.Program; }
"int"         { yylval.type=MiniTypes.Int; return (int)Tokens.Type; }
"double"      { yylval.type=MiniTypes.Double; return (int)Tokens.Type; }
"bool"        { yylval.type=MiniTypes.Bool; return (int)Tokens.Type; }
"write"       { return (int)Tokens.Write; }
"read"        { return (int)Tokens.Read; }
"if"          { return (int)Tokens.If; }
"else"        { return (int)Tokens.Else; }
"return"      { return (int)Tokens.Return; }
"while"       { return (int)Tokens.While; }
"hex"         { return (int)Tokens.Hex; }
"{"           { return (int)Tokens.OpenBrace; }
"}"           { return (int)Tokens.CloseBrace; }
"("           { return (int)Tokens.OpenBracket; }
")"           { return (int)Tokens.CloseBracket; }
","           { return (int)Tokens.Comma; }
";"           { return (int)Tokens.Semicolon; }

"~"           { return (int)Tokens.BitNegation; }
"!"           { return (int)Tokens.LogicNegation; }

"+"           { return (int)Tokens.Plus; }
"-"           { return (int)Tokens.Minus; }

"/"           { return (int)Tokens.Div; }
"*"           { return (int)Tokens.Mul; }

"=="          { return (int)Tokens.Equal; }
"!="          { return (int)Tokens.NotEqual; }
">"           { return (int)Tokens.Greater; }
">="          { return (int)Tokens.GreaterEqual; }
"<"           { return (int)Tokens.Less; }
"<="          { return (int)Tokens.LessEqual; }

"&&"          { return (int)Tokens.And; }
"||"          { return (int)Tokens.Or; }

"&"           { return (int)Tokens.BitAnd; }
"|"           { return (int)Tokens.BitOr; }

"="           { return (int)Tokens.Assign; }

{String}      { yylval.str=yytext; return (int)Tokens.String; }
{Bool}        { yylval.eval=new Const(yytext, MiniTypes.Bool); return (int)Tokens.Bool; }
{Int}         { yylval.eval=new Const(yytext, MiniTypes.Int); return (int)Tokens.IntNum; }
{Double}      { yylval.eval=new Const(yytext, MiniTypes.Double); return (int)Tokens.DoubleNum; }
{Hex}         { yylval.eval=new Const(yytext, MiniTypes.Int, true); return (int)Tokens.IntNum; }
{Ident}       { yylval.str=yytext; return (int)Tokens.Ident; }

<<EOF>>       { return (int)Tokens.EOF; }
"\r"          { }
" "           { }
"\t"          { }
"\n"          { Compiler.linenum++; }
{Comment}     { }
.             { return (int)Tokens.error; }