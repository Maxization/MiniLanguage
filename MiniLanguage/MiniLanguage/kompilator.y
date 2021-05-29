
// Uwaga: W wywo³aniu generatora gppg nale¿y u¿yæ opcji /gplex
%using MiniLanguage
%namespace GardensPoint

%union
{
    public AbstractMiniType type;
    public string str;
}

%token Program Write Assign OpenBrace CloseBrace Semicolon Comma
%token <type> Type
%token <str> Ident

//%type <type> value

%%

start: Program block { Compiler.Program = new Program($2); };

block: OpenBrace statements CloseBrace { $$ = new Block($2); };

statements: statement statements { $2.Add($1); $$ = $2; }
          |                      { $$ = new List<INode>(); }
          ;

statement: line Semicolon { $$ = $1; };

line: write        { $$ = $1; }
    | declarations { $$ = $1; }
    ;

declarations: declaration declarations { $2.Add($1); $$ = $2 }
            |                          { $$ = new List<INode>(); }
            ;

declaration: Type idents Ident { };

write: Write exp { $$ = new Write($2) }; //?

exp: Ident     {}
   | assigment {}
   ;

idents: idents Ident Comma {}
      |                    {}
      ;

%%
