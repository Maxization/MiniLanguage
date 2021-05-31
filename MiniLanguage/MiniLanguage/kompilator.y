
// Uwaga: W wywo³aniu generatora gppg nale¿y u¿yæ opcji /gplex
%using MiniLanguage
%using System.Linq
%namespace GardensPoint

%union
{
    public AbstractMiniType type;
    public string str;
    public List<string> strList;
    public INode node;
    public List<INode> nodeList;
}

%token Program OpenBrace CloseBrace Semicolon Comma
%token <type> Type
%token <str> Ident

%type <node> mainBlock
%type <nodeList> declaration declarations
%type <strList> idents

%%

start: Program mainBlock { Compiler.Program = new Program($2 as Block); }
     | Program error EOF { Compiler.errors++; Compiler.PrintError(); YYABORT; }
     | EOF { Compiler.errors++; Compiler.PrintError(); YYABORT; }
     ;

mainBlock: OpenBrace declarations CloseBrace { $$ = new Block($2); }
         | OpenBrace declarations error EOF { Compiler.errors++; Compiler.PrintError(); YYABORT; }
         ;

declarations: declarations declaration Semicolon { $1.AddRange($2); $$ = $1; Compiler.linenum++; }
            |                                    { $$ = new List<INode>(); }
            ;

declaration: Type idents Ident { $2.Add($3); $$ = $2.Select(name => Compiler.STG.AddDeclaration(name, $1) as INode).ToList(); }
           ;

idents: idents Ident Comma { $1.Add($2); $$ = $1; }
      |                    { $$ = new List<string>(); }
      ;

%%

public Parser(Scanner scanner) : base(scanner) { }