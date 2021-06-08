
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

%token Program OpenBrace CloseBrace Semicolon Comma Assign And Or Write OpenBracket CloseBracket If Else
%token Equal NotEqual Greater GreaterEqual Less LessEqual
%token Plus Minus Mul Div
%token BitAnd BitOr
%token BitNegation LogicNegation
%token Return
%token <type> Type
%token <str> Ident
%token <eval> IntNum DoubleNum Bool

%type <node> mainBlock block statement write if return
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

statement: evaluable Semicolon { $$ = $1; Compiler.linenum++; }
         | write Semicolon     { $$ = $1; }
         | return Semicolon    { $$ = $1; }
         | block               { $$ = $1; }
         | if                  { $$ = $1; }
         | evaluable error     { $$ = $1; Compiler.errors++; Compiler.PrintError(); }
         | write error         { $$ = $1; Compiler.errors++; Compiler.PrintError(); }
         ;

return: Return { $$ = new ReturnStatement(); }
      ;

if: If OpenBracket evaluable CloseBracket statement                { $$ = new IfStatement($3, $5); }
  | If OpenBracket evaluable CloseBracket statement Else statement { $$ = new IfStatement($3, $5, $7); }
  ;

write: Write evaluable {$$ = new Write($2); }
     ;

block: OpenBrace statements CloseBrace { $$ = new Block($2); }
     ;

evaluable: Ident Assign evaluable { $$ = new Assignment(new Variable(Compiler.STG.FindIdent($1)), $3); }
         | logicOp                { $$ = $1; }
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

additiveOp: additiveOp Plus multiplicativeOp { $$ = new MathhematicalOp($1, $3, Mathhematical.Add); }
          | additiveOp Minus multiplicativeOp { $$ = new MathhematicalOp($1, $3, Mathhematical.Sub); }
          | multiplicativeOp                { $$ = $1; }
          ;

multiplicativeOp: multiplicativeOp Mul bitwiseOp { $$ = new MathhematicalOp($1, $3, Mathhematical.Mul); }
                | multiplicativeOp Div bitwiseOp { $$ = new MathhematicalOp($1, $3, Mathhematical.Div); }
                | bitwiseOp                      { $$ = $1; }
                ;

bitwiseOp: bitwiseOp BitAnd unaryOp { $$ = new BitwiseOp($1, $3, Bitwise.And); }
         | bitwiseOp BitOr unaryOp  { $$ = new BitwiseOp($1, $3, Bitwise.Or); }
         | unaryOp                  { $$ = $1; }
         ;

unaryOp: Minus unaryOp                         { $$ = new UnaryOp($2, Unary.Minus); }
       | BitNegation unaryOp                   { $$ = new UnaryOp($2, Unary.BitNegation); }
       | LogicNegation unaryOp                 { $$ = new UnaryOp($2, Unary.LogicNegation); }
       | OpenBracket Type CloseBracket unaryOp { $$ = new UnaryOp($4, $2); }
       | OpenBracket evaluable CloseBracket    { $$ = $2; }
       | value                                 { $$ = $1; }
       ;

value: IntNum     { $$ = $1; }
     | DoubleNum  { $$ = $1; }
     | Bool       { $$ = $1; }
     | Ident      { $$ = new Variable(Compiler.STG.FindIdent($1)); }
     ;

%%

public Parser(Scanner scanner) : base(scanner) { }