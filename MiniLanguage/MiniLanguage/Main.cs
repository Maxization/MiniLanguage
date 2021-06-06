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
        public override bool Equals(object obj)
        {
            return _type == obj.ToString();
        }
        public override int GetHashCode()
        {
            return base.GetHashCode();
        }

        public static bool operator ==(AbstractMiniType lhs, AbstractMiniType rhs)
        {
            return Equals(lhs, rhs);
        }

        public static bool operator !=(AbstractMiniType lhs, AbstractMiniType rhs)
        {
            return !Equals(lhs, rhs);
        }
    }

    public class IntMiniType : AbstractMiniType
    {
        public IntMiniType() : base("int") { }
    }

    public class DoubleMiniType : AbstractMiniType
    {
        public DoubleMiniType() : base("double") { }
    }

    public class BoolMiniType : AbstractMiniType
    {
        public BoolMiniType() : base("bool") { }
    }

    public static class MiniTypes
    {
        public static AbstractMiniType Int => new IntMiniType();
        public static AbstractMiniType Double => new DoubleMiniType();
        public static AbstractMiniType Bool => new BoolMiniType();
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
                Compiler.linenum++;
                Compiler.PrintError("variable already declared");
                return new Declaration(new Identifier());
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
                Compiler.errors++;
                Compiler.PrintError("undeclared variable");
                return new Identifier();
            }
            return Declarations[name].Identifier;
        }
    }

    public static class Helper
    {
        private static int label_nr;
        private static int nr;
        public static string NewTmp() => $"tmp_{++nr}";
        public static string NewLabel() => $"LABEL_{++label_nr}";
        public static string GetType(AbstractMiniType type)
        {
            if (type == MiniTypes.Double)
            {
                return "double";
            }
            else if (type == MiniTypes.Bool)
            {
                return "i1";
            }
            else
            {
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
        void Visit(LogicOr logicOr);
        void Visit(Variable variable);
        void Visit(Write write);
        void Visit(RelationEqual relationEqual);
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
            EmitCode("@bool_res = constant [2 x i8] c\"%d\"");
            EmitCode("@double_res = constant [2 x i8] c\"%f\"");
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
            code += Helper.GetType(declaration.Identifier.Type);
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

            EmitCode($"store {type} %{assignment.Right.Identifier.Name}, {type}* %{assignment.Left.Name}");
            assignment.Left.Accept(this);
        }

        public void Visit(Variable variable)
        {
            var type = Helper.GetType(variable.Type);
            EmitCode($"%{variable.Identifier.Name} = load {type}, {type}* %{variable.Name}");
        }

        public void Visit(LogicAnd logicAnd)
        {
            logicAnd.Left.Accept(this);

            var tmp = Helper.NewTmp();
            var tmp2 = Helper.NewTmp();
            var label_true = Helper.NewLabel();
            var label_false = Helper.NewLabel();
            var label_end = Helper.NewLabel();

            EmitCode($"%{tmp} = icmp eq i1 %{logicAnd.Left.Identifier.Name}, 1");

            EmitCode($"br i1 %{tmp}, label %{label_true}, label %{label_false}");

            EmitCode($"{label_false}:");
            EmitCode($"store i1 0, i1* %bool");
            EmitCode($"br label %{label_end}");

            EmitCode($"{label_true}:");
            logicAnd.Right.Accept(this);
            EmitCode($"%{tmp2} = and i1 %{logicAnd.Left.Identifier.Name}, %{logicAnd.Right.Identifier.Name}");
            EmitCode($"store i1 %{tmp2}, i1* %bool");
            EmitCode($"br label %{label_end}");

            EmitCode($"{label_end}:");
            EmitCode($"%{logicAnd.Identifier.Name} = load i1, i1* %bool");
        }

        public void Visit(LogicOr logicOr)
        {
            logicOr.Left.Accept(this);

            var tmp = Helper.NewTmp();
            var tmp2 = Helper.NewTmp();
            var label_true = Helper.NewLabel();
            var label_false = Helper.NewLabel();
            var label_end = Helper.NewLabel();

            EmitCode($"%{tmp} = icmp eq i1 %{logicOr.Left.Identifier.Name}, 1");

            EmitCode($"br i1 %{tmp}, label %{label_true}, label %{label_false}");

            EmitCode($"{label_true}:");
            EmitCode($"store i1 1, i1* %bool");
            EmitCode($"br label %{label_end}");

            EmitCode($"{label_false}:");
            logicOr.Right.Accept(this);
            EmitCode($"%{tmp2} = or i1 %{logicOr.Left.Identifier.Name}, %{logicOr.Right.Identifier.Name}");
            EmitCode($"store i1 %{tmp2}, i1* %bool");
            EmitCode($"br label %{label_end}");

            EmitCode($"{label_end}:");
            EmitCode($"%{logicOr.Identifier.Name} = load i1, i1* %bool");
        }

        public void Visit(RelationEqual relationEqual)
        {
            relationEqual.Left.Accept(this);
            relationEqual.Right.Accept(this);


        }

        public void Visit(Write write)
        {
            write.Evaluable.Accept(this);

            var type = Helper.GetType(write.Evaluable.Identifier.Type);
            EmitCode($"call i32 (i8*, ...) @printf(i8* bitcast ([2 x i8]* @{write.Evaluable.Identifier.Type}_res to i8*)," +
                $" {type} %{write.Evaluable.Identifier.Name})");
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
            int val = int.Parse(value.Substring(2), System.Globalization.NumberStyles.HexNumber);
            return val.ToString();
        }
        public Const(string value, AbstractMiniType type, bool hex = false)
        {
            if (type == MiniTypes.Int && hex)
            {
                Value = ConvertHexToInt(value);
            }
            else if (type == MiniTypes.Bool)
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

    public class Write : INode
    {
        public IEvaluable Evaluable { get; }
        public Write(IEvaluable eval) => Evaluable = eval;
        public void Accept(IVisitor visitor) => visitor.Visit(this);
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

            if((assignable.Type == MiniTypes.Double && evaluable.Identifier.Type == MiniTypes.Bool) ||
               (assignable.Type == MiniTypes.Int && evaluable.Identifier.Type != MiniTypes.Int) ||
               (assignable.Type == MiniTypes.Bool && evaluable.Identifier.Type != MiniTypes.Bool))
            {
                Compiler.errors++;
                Compiler.PrintError("InvalidTypes");
            }
        }

        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public interface IBinaryOperator
    {
        IEvaluable Left { get; }
        IEvaluable Right { get; }
    }

    public abstract class LogicOp : IBinaryOperator
    {
        public IEvaluable Left { get; }
        public IEvaluable Right { get; }

        public LogicOp(IEvaluable eval1, IEvaluable eval2)
        {
            if(eval1.Identifier.Type != MiniTypes.Bool ||  eval2.Identifier.Type != MiniTypes.Bool)
            {
                Compiler.errors++;
                Compiler.PrintError("Invalid types");
            }
            Left = eval1;
            Right = eval2;
        }
    }
    public class LogicAnd : LogicOp, IEvaluable
    {
        public Identifier Identifier { get; }

        public LogicAnd(IEvaluable eval1, IEvaluable eval2): base(eval1, eval2)
        {
            Identifier = new Identifier(Helper.NewTmp(), eval1.Identifier.Type);
        }
        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public class LogicOr : LogicOp, IEvaluable
    {
        public Identifier Identifier { get; }
        public LogicOr(IEvaluable eval1, IEvaluable eval2) : base(eval1, eval2)
        {
            Identifier = new Identifier(Helper.NewTmp(), eval1.Identifier.Type);
        }
        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public class RelationEqual : IEvaluable, IBinaryOperator
    {
        public Identifier Identifier { get; }

        public IEvaluable Left { get; }

        public IEvaluable Right { get; }

        public RelationEqual(IEvaluable eval1, IEvaluable eval2)
        {
            Identifier = new Identifier(Helper.NewTmp(), MiniTypes.Bool);
            Left = eval1;
            Right = eval2;

            if((eval1.Identifier.Type == MiniTypes.Bool && eval2.Identifier.Type != MiniTypes.Bool) ||
               (eval2.Identifier.Type == MiniTypes.Bool && eval1.Identifier.Type != MiniTypes.Bool))
            {
                Compiler.errors++;
                Compiler.PrintError("Invalid types");
            }
        }

        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }
}
