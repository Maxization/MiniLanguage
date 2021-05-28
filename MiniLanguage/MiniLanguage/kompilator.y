
// Uwaga: W wywo³aniu generatora gppg nale¿y u¿yæ opcji /gplex
%using MiniLanguage
%namespace GardensPoint

%union
{
public string  val;
public char    type;
}

%token Program Write Assign OpenBrace CloseBrace Semicolon Comma
%token <val> Type Ident IntNumber RealNumber

%%

start: Program block { Compiler.Program = new Program($2) };

block: OpenBrace statements CloseBrace { $$ = new Block($2) };

statements: declaration statements { $$ = $2 }
          | statement statements   {
                                     $2.Add($1);
                                     $$ = $2
                                   }
          |                        { $$ = new List<INode>() }
          ;

statement: line Semicolon {};

line: write              {}
    | Ident Assign value {}
    ;

value: IntNumber {};

write: Write exp {};

exp: Ident {};

declaration: Type idents Ident Semicolon {};

idents: idents Ident Comma {}
      |                    {}
      ;

%%
