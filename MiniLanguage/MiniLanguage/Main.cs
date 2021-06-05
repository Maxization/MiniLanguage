using System;
using System.IO;
using System.Collections.Generic;
using GardensPoint;

namespace MiniLanguage
{

    public class Compiler
    {
        public static int errors;
        public static int linenum;
        private static StreamWriter sw;
        public static Program Program { get; set; }
        public static CodeGenerator codeGenerator { get; set; }
        public static SyntaxTreeGenerator STG => new SyntaxTreeGenerator();
        public static List<string> source;

        public static void Reset()
        {
            errors = 0;
            linenum = 0;
            Program = null;
            codeGenerator = null;
            STG.Reset();
            source = null;
        }

        public static void PrintError(string message = null)
        {
            if (message is null)
                Console.WriteLine($"line: {linenum}, syntax error");
            else
                Console.WriteLine($"line: {linenum}, " + message);
        }

        // arg[0] określa plik źródłowy
        // pozostałe argumenty są ignorowane
        public static int Main(string[] args)
        {
            Reset();
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

            try
            {
                parser.Parse();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"error: line {linenum}, {ex.Message}");
            }
            
            source.Close();
            if (errors == 0)
            {
                sw = new StreamWriter(file + ".ll");
                codeGenerator = new CodeGenerator(sw);
                codeGenerator.GenCode(Program);
                sw.Close();
                Console.WriteLine("Compilation successful\n");
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
        private static Dictionary<string, Declaration> Declarations = new Dictionary<string, Declaration>();

        public static string NewName(string prefix) => $"{prefix}_{++nr}";


        public void Reset()
        {
            nr = 0;
            Declarations = new Dictionary<string, Declaration>();
        }
        public Declaration AddDeclaration(string name, AbstractMiniType type)
        {
            if(Declarations.ContainsKey(name))
            {
                Compiler.PrintError("variable already declared");
                return null;
            }

            string uniqueName = NewName(name);

            Identifier ident = new Identifier(uniqueName, type);
            Declaration dec = new Declaration(ident);

            Declarations.Add(name, dec);
            return dec;
        }

        public Identifier FindIdent(string name)
        {
            if(!Declarations.ContainsKey(name))
            {
                // TODO: Not throw exception
                throw new InvalidOperationException("undeclared variable");
            }
            return Declarations[name].Identifier;
        }
    }

    public static class Helper
    {
        private static int nr;
        public static string NewTmp() => $"tmp_{++nr}";
        public static string GetType(AbstractMiniType type)
        {
            switch (type.ToString())
            {
                case "double":
                    return "double";
                case "bool":
                    return "i1";
                case "int":
                default:
                    return "i32";
            }
        }
    }

    #region visitor
    public interface IVisitor
    {
        void Visit(Program program);
        void Visit(MainBlock mainBlock);
        void Visit(Block block);
        void Visit(Declaration declaration);
        void Visit(Const constant);
        void Visit(Assignment assignment);
        void Visit(LogicAnd logicAnd);
        void Visit(Variable variable);
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
            EmitCode("@int_res = constant [2 x i8] c\"%d\"");
            EmitCode("declare i32 @printf(i8*, ...)");
            EmitCode("define i32 @main()");
            EmitCode("{");
            EmitCode("%int = alloca i32");
            EmitCode("%double = alloca double");
            EmitCode("%bool = alloca i1");
            
        }

        private void GenEpilog()
        {
            EmitCode("ret i32 0");
            EmitCode("}");
        }

        public void Visit(Program program)
        {
            GenProlog();
            program.MainBody.Accept(this);
            GenEpilog();
        }

        public void Visit(MainBlock mainBlock)
        {
            foreach (INode node in mainBlock.Declarations)
                node.Accept(this);
            foreach (INode node in mainBlock.Statements)
                node.Accept(this);
        }

        public void Visit(Block block)
        {
            foreach (INode node in block.Statements)
                node.Accept(this);
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

        public void Visit(Const constant)
        {
            string type = Helper.GetType(constant.Identifier.Type);

            EmitCode($"store {type} {constant.Value}, {type}* %{constant.Identifier.Type}");
            EmitCode($"%{constant.Identifier.Name} = load {type}, {type}* %{constant.Identifier.Type}");
        }

        public void Visit(Assignment assignment)
        {
            assignment.Right.Accept(this);

            var type = Helper.GetType(assignment.Right.Identifier.Type);

            // TODO: Check types etc.
            EmitCode($"store {type} %{assignment.Right.Identifier.Name}, {type}* %{assignment.Left.Name}");
            assignment.Left.Accept(this);
        }

        public void Visit(LogicAnd logicAnd)
        {
            logicAnd.Left.Accept(this);
            logicAnd.Right.Accept(this);
            var tmp1 = Helper.NewTmp();
            var tmp2 = Helper.NewTmp();

            EmitCode($"%{tmp1} = load i1, i1* %{logicAnd.Left.Identifier.Name}");
            EmitCode($"%{tmp2} = load i1, i1* %{logicAnd.Right.Identifier.Name}");
            EmitCode($"%{logicAnd.Identifier.Name} = and i1 %{tmp1}, %{tmp2}");
        }

        public void Visit(Variable variable)
        {
            var type = Helper.GetType(variable.Type);
            EmitCode($"%{variable.Identifier.Name} = load {type}, {type}* %{variable.Name}");
        }
    }

    #endregion

    public interface INode
    {
        void Accept(IVisitor visitor);
    }

    public class Program : INode
    {
        public MainBlock MainBody { get; set; }

        public Program(MainBlock body) => MainBody = body;

        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public class MainBlock : INode
    {
        public List<INode> Declarations { get; }
        public List<INode> Statements { get; }

        public MainBlock(List<INode> declarations, List<INode> statements)
        {
            Declarations = declarations;
            Statements = statements;
        }

        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public class Block : INode
    {
        public List<INode> Statements { get; }

        public Block(List<INode> statements) => Statements = statements;

        public void Accept(IVisitor visitor) => visitor.Visit(this);
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

    public class Const : IEvaluable
    {
        public string Value { get; }
        public Identifier Identifier { get; }

        private string ConvertHexToInt(string value)
        {
            int val = Int32.Parse(value.Substring(2), System.Globalization.NumberStyles.HexNumber);
            return val.ToString();
        }
        public Const(string value, AbstractMiniType type, bool hex = false)
        {
            string type_str = type.ToString();
            if (type_str == "int" && hex)
            {
                Value = ConvertHexToInt(value);
            }
            else if (type_str == "bool")
            {
                if(value == "true")
                {
                    Value = "1";
                }
                else
                {
                    Value = "0";
                }
                
            }
            else
            {
                Value = value;
            }
            
            Identifier = new Identifier(Helper.NewTmp(), type);
        }
        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public class Variable : IEvaluable, IAssignable
    {
        public Identifier Identifier { get; }

        public string Name { get; }

        public AbstractMiniType Type { get; }

        public Variable(Identifier ident)
        {
            Name = ident.Name;
            Type = ident.Type;

            Identifier = new Identifier(Helper.NewTmp(), Type);
        }
        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public interface IEvaluable: INode
    {
        Identifier Identifier { get; }
    }

    public interface IAssignable: IEvaluable
    {
        string Name { get; }
        AbstractMiniType Type { get; }
    }

    public interface BinaryOperator
    {
        IEvaluable Left { get; }
        IEvaluable Right { get; }
    }

    public class Assignment : IEvaluable
    {
        public IAssignable Left { get; }
        public IEvaluable Right { get; }

        public Identifier Identifier => Left.Identifier;

        public Assignment(IAssignable assignable, IEvaluable evaluable)
        {
            Left = assignable;
            Right = evaluable;
        }

        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public class LogicAnd : IEvaluable, BinaryOperator
    {
        public IEvaluable Left { get; }
        public IEvaluable Right { get;  }
        public Identifier Identifier { get; }

        public LogicAnd(IEvaluable eval1, IEvaluable eval2)
        {
            // TODO: Verify types
            Identifier = new Identifier(Helper.NewTmp(), eval1.Identifier.Type);
            Left = eval1;
            Right = eval2;
        }
        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }
}
