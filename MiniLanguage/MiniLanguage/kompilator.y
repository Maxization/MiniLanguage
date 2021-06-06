
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

%token Program OpenBrace CloseBrace Semicolon Comma Assign And Or Write 
%token Equal NotEqual Greater GreaterEqual Less LessEqual
%token Add Sub
%token Mul Div
%token BitAnd BitOr
%token Minus BitNegation LogicNegation
%token <type> Type
%token <str> Ident
%token <eval> IntNum DoubleNum Bool

%type <node> mainBlock block statement write
%type <nodeList> declaration declarations statements
%type <strList> idents
%type <eval> value evaluable logicOp relationOp additiveOp multiplicativeOp bitwiseOp unaryOp

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
         | block               { $$ = $1; }
         | write               { $$ = $1; }
         ;

write: Write evaluable Semicolon {$$ = new Write($2); }
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

logicOp: logicOp And relationOp { $$ = new LogicAnd($1, $3); }
       | logicOp Or relationOp  { $$ = new LogicOr($1, $3); }
       | relationOp             { $$ = $1; }
       ;

relationOp: relationOp Equal additiveOp        { $$ = new RelationOp($1, $3, Relation.Equal); }
          | relationOp NotEqual additiveOp     { $$ = new RelationOp($1, $3, Relation.NotEqual); }
          | relationOp Greater additiveOp      { $$ = new RelationOp($1, $3, Relation.Greater); }
          | relationOp GreaterEqual additiveOp { $$ = new RelationOp($1, $3, Relation.GreaterEqual); }
          | relationOp Less additiveOp         { $$ = new RelationOp($1, $3, Relation.Less); }
          | relationOp LessEqual additiveOp    { $$ = new RelationOp($1, $3, Relation.LessEqual); }
          | additiveOp                         { $$ = $1; }
          ;

additiveOp: additiveOp Add multiplicativeOp { $$ = new AdditiveOp($1, $3, Additive.Add); }
          | additiveOp Sub multiplicativeOp { $$ = new AdditiveOp($1, $3, Additive.Sub); }
          | multiplicativeOp                { $$ = $1; }
          ;

multiplicativeOp: multiplicativeOp Mul bitwiseOp { $$ = new MultiplicativeOp($1, $3, Multiplicative.Mul); }
                | multiplicativeOp Div bitwiseOp { $$ = new MultiplicativeOp($1, $3, Multiplicative.Div); }
                | bitwiseOp                      { $$ = $1; }
                ;

bitwiseOp: bitwiseOp BitAnd unarOp { $$ = new BitwiseOp($1, $3, Bitwise.And); }
         | bitwiseOp BitOr unarOp  { $$ = new BitwiseOp($1, $3, Bitwise.Or); }
         | unarOp                  { $$ = $1; }
         ;

unarOp: Minus unarOp          {}
      | BitNegation unaryOp   {}
      | LogicNegation unaryOp {}
      | value                 {}
      ;


%%

public Parser(Scanner scanner) : base(scanner) { }