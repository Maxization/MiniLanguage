
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
    public IEvaluable eval;
}

%token Program OpenBrace CloseBrace Semicolon Comma Assign And Or
%token <type> Type
%token <str> Ident
%token <eval> IntNum DoubleNum Bool

%type <node> mainBlock block statement
%type <nodeList> declaration declarations statements
%type <strList> idents
%type <eval> value evaluable logicOp

%%

start: Program mainBlock { Compiler.Program = new Program($2 as MainBlock); }
     | Program error EOF { Compiler.errors++; Compiler.PrintError(); YYABORT; }
     | EOF { Compiler.errors++; Compiler.PrintError(); YYABORT; }
     ;

mainBlock: OpenBrace declarations statements CloseBrace { $$ = new MainBlock($2, $3); }
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

statements: statements statement { $1.Add($2); $$ = $1; }
          |                      { $$ = new List<INode>(); }
          ;

statement: evaluable Semicolon { $$ = $1; }
         | block                { $$ = $1; }
         ;

block: OpenBrace statements CloseBrace { $$ = new Block($2); }
     ;

evaluable: Ident Assign evaluable { $$ = new Assignment(new Variable(Compiler.STG.FindIdent($1)), $3); }
         | logicOp                { $$ = $1; }
         ;

value: IntNum     { $$ = $1; }
     | DoubleNum  { $$ = $1; }
     | Bool       { $$ = $1; }
     | Ident      { $$ = new Variable(Compiler.STG.FindIdent($1)); }
     ;

logicOp: logicOp And value { $$ = new LogicAnd($1, $3); }
       | value             { $$ = $1; }
       ;

%%

public Parser(Scanner scanner) : base(scanner) { }