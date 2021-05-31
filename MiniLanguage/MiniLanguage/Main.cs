using System;
using System.IO;
using System.Collections.Generic;
using GardensPoint;

namespace MiniLanguage
{
    public class Compiler
    {
        public static int errors = 0;

        private static StreamWriter sw;
        public static Program Program { get; set; }
        public static CodeGenerator codeGenerator { get; set; }
        public static SyntaxTreeGenerator STG => new SyntaxTreeGenerator();

        public static List<string> source;

        // arg[0] określa plik źródłowy
        // pozostałe argumenty są ignorowane
        public static int Main(string[] args)
        {
            string file;
            FileStream source;
            Console.WriteLine("\nLLVM Code Generator for Mini Language");
            if (args.Length >= 1)
                file = args[0];
            else
            {
                Console.Write("\nsource file:  ");
                file = Console.ReadLine();
            }
            try
            {
                var sr = new StreamReader(file);
                string str = sr.ReadToEnd();
                sr.Close();
                Compiler.source = new List<string>(str.Split(new string[] { "\r\n" }, System.StringSplitOptions.None));
                source = new FileStream(file, FileMode.Open);
            }
            catch (Exception e)
            {
                Console.WriteLine("\n" + e.Message);
                return 1;
            }
            Scanner scanner = new Scanner(source);
            Parser parser = new Parser(scanner);
            Console.WriteLine();
            parser.Parse();
            source.Close();
            if (errors == 0)
            {
                sw = new StreamWriter(file + ".ll");
                codeGenerator = new CodeGenerator(sw);
                codeGenerator.GenCode(Program);
                sw.Close();
                Console.WriteLine("  compilation successful\n");
            }
            else
                Console.WriteLine($"\n  {errors} errors detected\n");
            return errors == 0 ? 0 : 2;
        }

    }

    #region Types
    public abstract class AbstractMiniType
    {
        private readonly string _type;

        protected AbstractMiniType(string type) => _type = type;
        public override string ToString() => _type;
    }

    public class IntMiniType: AbstractMiniType
    {
        public IntMiniType(): base("int") { }
    }

    public class DoubleMiniType: AbstractMiniType
    {
        public DoubleMiniType(): base("double") { }
    }

    public class BoolMiniType: AbstractMiniType
    {
        public BoolMiniType(): base("bool") { }
    }

    #endregion

    public class SyntaxTreeGenerator
    {
        private static int nr;
        private Dictionary<string, Declaration> Declarations { get; }

        public SyntaxTreeGenerator()
        {
            Declarations = new Dictionary<string, Declaration>();
        }

        public static string NewTemp(string prefix) => $"{prefix}_{++nr}";

        public Declaration AddDeclaration(string name, AbstractMiniType type)
        {
            string uniqueName = NewTemp(name);
            //TODO: Check types and if exists

            Identifier ident = new Identifier(uniqueName, type);
            Declaration dec = new Declaration(ident);

            Declarations.Add(name, dec);
            return dec;
        }

        public Identifier FindIdent(string name)
        {
            //TODO: Check for errors etc
            return Declarations[name].Identifier;
        }
    }

    #region visitor
    public interface IVisitor
    {
        void Visit(Program program);
        void Visit(Block block);
        void Visit(Declaration declaration);
    }

    public class CodeGenerator : IVisitor
    {
        private static StreamWriter sw;
        public static void EmitCode(string instr = null) => sw.WriteLine(instr);
        public static void EmitCode(string instr, params object[] args) => sw.WriteLine(instr, args);

        public CodeGenerator(StreamWriter streamWriter)
        {
            sw = streamWriter;
        }

        public void GenCode(Program program)
        {
            program.Accept(this);
        }

        
        private void GenProlog()
        {
            EmitCode("; prolog");
            EmitCode("declare i32 @printf(i8*, ...)");
            EmitCode("define void @main()");
        }

        public void Visit(Program program)
        {
            GenProlog();
            program.MainBody.Accept(this);
        }

        public void Visit(Block block)
        {
            EmitCode("{");
            foreach (INode node in block.Statements)
                node.Accept(this);
            EmitCode("ret void");
            EmitCode("}");
        }

        public void Visit(Declaration declaration)
        {
            string code = $"%{declaration.Identifier.Name} = alloca ";
            switch(declaration.Identifier.Type.ToString())
            {
                case "int":
                    code += "i32";
                    break;
                case "bool":
                    code += "i1";
                    break;
                case "double":
                    code += "double";
                    break;
            }
            EmitCode(code);
        }
    }

    #endregion

    public interface INode
    {
        void Accept(IVisitor visitor);
    }

    public class Program : INode
    {
        public Block MainBody { get; set; }

        public Program(Block body) => MainBody = body;

        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public class Block : INode
    {
        public List<INode> Statements { get; }

        public Block(List<INode> statements) => Statements = statements;

        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public interface IEvaluable
    {
        AbstractMiniType Type { get; }
        string Value { get; }
    }

    // TODO
    public class Constant : IEvaluable
    {
        public AbstractMiniType Type { get; }
        public string Value { get; }
        public Constant(AbstractMiniType type, string value)
        {
            Type = type;
            Value = value;
        }
    }

    // TODO
    public class Variable : IEvaluable
    {
        public Identifier Identifier { get; }
        public string Value { get => Identifier.Name; }
        public AbstractMiniType Type { get => Identifier.Type; }
        public Variable(Identifier ident) => Identifier = ident;
    }

    // TODO
    public class Assignment : INode
    {
        public string Name { get; }
        public Assignment(string name, IEvaluable eval)
        {

        }
        public void Accept(IVisitor visitor)
        {
            throw new NotImplementedException();
        }
    }

    // TODO
    public class Write : INode
    {
        public Write(string exp)
        {
            
        }
        public void Accept(IVisitor visitor) { }
    }

    public class Declaration : INode
    {
        public Identifier Identifier { get; }
        public Declaration(Identifier ident) => Identifier = ident;
        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public struct Identifier
    {
        public string Name { get; }
        public AbstractMiniType Type { get; }

        public Identifier(string name, AbstractMiniType type)
        {
            Name = name;
            Type = type;
        }
    }
}
