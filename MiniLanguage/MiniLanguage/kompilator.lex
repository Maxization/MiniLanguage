%using QUT.Gppg;
%using MiniLanguage;
%namespace GardensPoint

IntNumber   [0-9]+
RealNumber  [0-9]+\.[0-9]+
Ident       ("@"|"$")[a-z]
PrintErr    "print"("@"|"$"|[a-z0-9])[a-z0-9]*

%%

{IntNumber}   { yylval.type=IntMiniType; return (int)Tokens.IntNumber; }
{RealNumber}  { yylval.type=DoubleMiniType; return (int)Tokens.RealNumber; }
{Ident}       { yylval.str=yytext; return (int)Tokens.Ident; }
"="           { return (int)Tokens.Assign; }
"+"           { return (int)Tokens.Plus; }
"-"           { return (int)Tokens.Minus; }
"*"           { return (int)Tokens.Multiplies; }
"/"           { return (int)Tokens.Divides; }
"("           { return (int)Tokens.OpenPar; }
")"           { return (int)Tokens.ClosePar; }
"\r"          { return (int)Tokens.Endl; }
<<EOF>>       { return (int)Tokens.Eof; }
" "           { }
"\t"          { }
{PrintErr}    { return (int)Tokens.Error; }
.             { return (int)Tokens.Error; }