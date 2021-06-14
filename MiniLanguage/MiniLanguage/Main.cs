using System;
using System.IO;
using System.Collections.Generic;
using GardensPoint;
using System.Text;

namespace MiniLanguage
{

    public class Compiler
    {
        public static int errors;
        public static int linenum = 1;
        private static StreamWriter sw;
        public static Program Program { get; set; }
        public static CodeGenerator codeGenerator { get; set; }
        public static string OutputFile { get; set; }
        public static SyntaxTreeGenerator STG => new SyntaxTreeGenerator();
        public static List<string> source;

        public static void Reset()
        {
            errors = 0;
            linenum = 1;
            Program = null;
            codeGenerator = null;
            STG.Reset();
            source = null;
        }

        public static void PrintError(string message = null, bool lin_mes = true)
        {
            if (lin_mes)
                Console.Write($"line: {linenum}, ");
            if (message is null)
                Console.WriteLine($"syntax error");
            else
                Console.WriteLine(message);
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
            {
                file = args[0];
            }
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
                errors++;
                Console.WriteLine($"error: line {linenum}, {ex.Message}");
            }
            source.Close();

            if (Program == null)
            {
                errors++;
                PrintError("syntax errors", false);
            }

            if (errors == 0)
            {
                OutputFile = file + ".ll";
                sw = new StreamWriter(OutputFile);
                codeGenerator = new CodeGenerator(sw);
                codeGenerator.GenCode(Program);
                sw.Close();
                Console.WriteLine("Compilation successful\n");
            }
            else
            {
                Console.WriteLine($"\n errors detected\n");
            }

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
            if (Declarations.ContainsKey(name))
            {
                Compiler.errors++;
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
            if (!Declarations.ContainsKey(name))
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

        public static string GetRelation(Relation relation, AbstractMiniType type)
        {
            bool isDouble = type == MiniTypes.Double;
            switch (relation)
            {
                case Relation.Equal:
                    if (isDouble)
                        return "oeq";
                    return "eq";
                case Relation.NotEqual:
                    if (isDouble)
                        return "one";
                    return "ne";
                case Relation.Greater:
                    if (isDouble)
                        return "ogt";
                    return "sgt";
                case Relation.GreaterEqual:
                    if (isDouble)
                        return "oge";
                    return "sge";
                case Relation.Less:
                    if (isDouble)
                        return "olt";
                    return "slt";
                default:
                case Relation.LessEqual:
                    if (isDouble)
                        return "ole";
                    return "sle";
            }
        }

        public static string GetMathematical(Mathhematical mathhematical, AbstractMiniType type)
        {
            bool isDouble = type == MiniTypes.Double;
            switch (mathhematical)
            {
                default:
                case Mathhematical.Add:
                    if (isDouble)
                        return "fadd";
                    return "add";
                case Mathhematical.Sub:
                    if (isDouble)
                        return "fsub";
                    return "sub";
                case Mathhematical.Mul:
                    if (isDouble)
                        return "fmul";
                    return "mul";
                case Mathhematical.Div:
                    if (isDouble)
                        return "fdiv";
                    return "sdiv";
            }
        }

        public static string GetBitwise(Bitwise bitwise)
        {
            switch (bitwise)
            {
                case Bitwise.And:
                    return "and";
                default:
                case Bitwise.Or:
                    return "or";
            }
        }

        public static (string str, int len) ParseString(string value)
        {
            var tmp = value.Substring(1, value.Length - 2);

            var result = new StringBuilder();
            var counter = 0;

            for (int i = 0; i < tmp.Length; i++)
            {
                if (tmp[i] == '\\')
                {
                    switch (tmp[i + 1])
                    {
                        case 'n':
                            result.Append("\\0A");
                            break;
                        case '\"':
                            result.Append("\\22");
                            break;
                        case '\\':
                            result.Append("\\5C");
                            break;
                        default:
                            result.Append(tmp[i + 1]);
                            break;
                    }

                    counter++;
                    i++;
                }
                else
                {
                    result.Append(tmp[i]);
                }
            }

            return (result.ToString(), tmp.Length - counter);
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
        void Visit(RelationOp relationOp);
        void Visit(MathhematicalOp mathhematicalOp);
        void Visit(BitwiseOp bitwiseOp);
        void Visit(UnaryOp unaryOp);
        void Visit(IfStatement ifStatement);
        void Visit(ReturnStatement returnStatement);
        void Visit(WhileStatement whileStatement);
        void Visit(WriteHex writeHex);
        void Visit(WriteString writeString);
        void Visit(Read read);
        void Visit(ReadHex readHex);
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

        public string EmitIntToDouble(string ident_int)
        {
            var tmp = Helper.NewTmp();
            EmitCode($"%{tmp} = sitofp i32 %{ident_int} to double");
            return tmp;
        }

        private void GenProlog()
        {
            EmitCode("; prolog");
            EmitCode("@int_res = constant [3 x i8] c\"%d\\00\"");
            EmitCode("@hex_res = constant [5 x i8] c\"0X%X\\00\"");
            EmitCode("@double_res = constant [4 x i8] c\"%lf\\00\"");
            EmitCode("@true_res = constant [5 x i8] c\"True\\00\"");
            EmitCode("@false_res = constant [6 x i8] c\"False\\00\"");
            EmitCode("@int_read = constant [ 3 x i8] c\"%d\\00\"");
            EmitCode("@hex_read = constant [3 x i8] c\"%X\\00\"");
            EmitCode("@double_read = constant [ 4 x i8] c\"%lf\\00\"");
            EmitCode("declare i32 @printf(i8*, ...)");
            EmitCode("declare i32 @scanf(i8*, ...)");
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

            var tmp = assignment.Right.Identifier.Name;
            var type = Helper.GetType(assignment.Left.Identifier.Type);
            var leftType = assignment.Left.Identifier.Type;
            var rightType = assignment.Right.Identifier.Type;

            if (leftType == MiniTypes.Double && rightType == MiniTypes.Int)
            {
                tmp = EmitIntToDouble(assignment.Right.Identifier.Name);
            }

            EmitCode($"store {type} %{tmp}, {type}* %{assignment.Left.Name}");
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
            var label_true = Helper.NewLabel();
            var label_false = Helper.NewLabel();
            var label_end = Helper.NewLabel();

            EmitCode($"br i1 %{logicAnd.Left.Identifier.Name}, label %{label_true}, label %{label_false}");

            EmitCode($"{label_false}:");
            EmitCode($"store i1 0, i1* %bool");
            EmitCode($"br label %{label_end}");

            EmitCode($"{label_true}:");
            logicAnd.Right.Accept(this);
            EmitCode($"%{tmp} = and i1 %{logicAnd.Left.Identifier.Name}, %{logicAnd.Right.Identifier.Name}");
            EmitCode($"store i1 %{tmp}, i1* %bool");
            EmitCode($"br label %{label_end}");

            EmitCode($"{label_end}:");
            EmitCode($"%{logicAnd.Identifier.Name} = load i1, i1* %bool");
        }

        public void Visit(LogicOr logicOr)
        {
            logicOr.Left.Accept(this);

            var tmp = Helper.NewTmp();
            var label_true = Helper.NewLabel();
            var label_false = Helper.NewLabel();
            var label_end = Helper.NewLabel();

            EmitCode($"br i1 %{logicOr.Left.Identifier.Name}, label %{label_true}, label %{label_false}");

            EmitCode($"{label_true}:");
            EmitCode($"store i1 1, i1* %bool");
            EmitCode($"br label %{label_end}");

            EmitCode($"{label_false}:");
            logicOr.Right.Accept(this);
            EmitCode($"%{tmp} = or i1 %{logicOr.Left.Identifier.Name}, %{logicOr.Right.Identifier.Name}");
            EmitCode($"store i1 %{tmp}, i1* %bool");
            EmitCode($"br label %{label_end}");

            EmitCode($"{label_end}:");
            EmitCode($"%{logicOr.Identifier.Name} = load i1, i1* %bool");
        }

        public void Visit(RelationOp relationOp)
        {
            relationOp.Left.Accept(this);
            relationOp.Right.Accept(this);

            string tmp1 = relationOp.Left.Identifier.Name;
            string tmp2 = relationOp.Right.Identifier.Name;

            AbstractMiniType leftType = relationOp.Left.Identifier.Type;
            AbstractMiniType rightType = relationOp.Right.Identifier.Type;

            if (leftType == MiniTypes.Double || rightType == MiniTypes.Double)
            {
                if (rightType == MiniTypes.Int)
                {
                    tmp2 = EmitIntToDouble(relationOp.Right.Identifier.Name);
                }
                else if (leftType == MiniTypes.Int)
                {
                    tmp1 = EmitIntToDouble(relationOp.Left.Identifier.Name);
                }

                var relation = Helper.GetRelation(relationOp.Relation, MiniTypes.Double);
                EmitCode($"%{relationOp.Identifier.Name} = fcmp {relation} double %{tmp1}, %{tmp2}");
            }
            else if (leftType == MiniTypes.Int)
            {
                var relation = Helper.GetRelation(relationOp.Relation, MiniTypes.Int);
                EmitCode($"%{relationOp.Identifier.Name} = icmp {relation} i32 %{tmp1}, %{tmp2}");
            }
            else
            {
                var relation = Helper.GetRelation(relationOp.Relation, MiniTypes.Bool);
                EmitCode($"%{relationOp.Identifier.Name} = icmp {relation} i1 %{tmp1}, %{tmp2}");
            }
        }

        public void Visit(Write write)
        {
            write.Evaluable.Accept(this);

            var type = write.Evaluable.Identifier.Type;
            if (type == MiniTypes.Bool)
            {
                var label_true = Helper.NewLabel();
                var label_false = Helper.NewLabel();
                var label_end = Helper.NewLabel();
                EmitCode($"br i1 %{write.Evaluable.Identifier.Name}, label %{label_true}, label %{label_false}");
                EmitCode($"{label_true}:");
                EmitCode($"call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))");
                EmitCode($"br label %{label_end}");
                EmitCode($"{label_false}:");
                EmitCode($"call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))");
                EmitCode($"br label %{label_end}");
                EmitCode($"{label_end}:");

            }
            else if (type == MiniTypes.Double)
            {
                EmitCode($"call i32 (i8*, ...) @printf(i8* bitcast ([4 x i8]* @double_res to i8*)," +
                $" double %{write.Evaluable.Identifier.Name})");
            }
            else
            {
                EmitCode($"call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*)," +
                $" i32 %{write.Evaluable.Identifier.Name})");
            }
        }

        public void Visit(WriteHex writeHex)
        {
            writeHex.Evaluable.Accept(this);

            EmitCode($"call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @hex_res to i8*), i32 %{writeHex.Evaluable.Identifier.Name})");
        }

        public void Visit(WriteString writeString)
        {
            int len = writeString.Length + 1;
            var tmp = Helper.NewTmp();
            var tmp2 = Helper.NewTmp();
            EmitCode($"%{tmp} = alloca [{len} x i8]");
            EmitCode($"store [{len} x i8] c\"{writeString.Value}\\00\", [{len} x i8]* %{tmp}");
            EmitCode($"%{tmp2} = bitcast [{len} x i8]* %{tmp} to i8*");
            EmitCode($"call i32 (i8*, ...) @printf(i8* %{tmp2})");
        }

        public void Visit(MathhematicalOp mathhematicalOp)
        {
            mathhematicalOp.Left.Accept(this);
            mathhematicalOp.Right.Accept(this);

            var resultType = mathhematicalOp.Identifier.Type;
            var op = Helper.GetMathematical(mathhematicalOp.Mathhematical, resultType);

            var tmpLeft = mathhematicalOp.Left.Identifier.Name;
            var leftType = mathhematicalOp.Left.Identifier.Type;

            var tmpRight = mathhematicalOp.Right.Identifier.Name;
            var rightType = mathhematicalOp.Right.Identifier.Type;

            if (resultType == MiniTypes.Int)
            {
                EmitCode($"%{mathhematicalOp.Identifier.Name} = {op} i32 %{tmpLeft}, %{tmpRight}");
            }
            else
            {
                if (leftType == MiniTypes.Int)
                {
                    tmpLeft = EmitIntToDouble(tmpLeft);
                }

                if (rightType == MiniTypes.Int)
                {
                    tmpRight = EmitIntToDouble(tmpRight);
                }

                EmitCode($"%{mathhematicalOp.Identifier.Name} = {op} double %{tmpLeft}, %{tmpRight}");
            }
        }

        public void Visit(BitwiseOp bitwiseOp)
        {
            bitwiseOp.Left.Accept(this);
            bitwiseOp.Right.Accept(this);

            var op = Helper.GetBitwise(bitwiseOp.Bitwise);

            EmitCode($"%{bitwiseOp.Identifier.Name} = {op} i32 %{bitwiseOp.Left.Identifier.Name}, %{bitwiseOp.Right.Identifier.Name}");
        }

        public void Visit(UnaryOp unaryOp)
        {
            unaryOp.Evaluable.Accept(this);

            var type = unaryOp.Evaluable.Identifier.Type;
            var eval = unaryOp.Evaluable.Identifier.Name;
            if (unaryOp.Unary == Unary.ConversionToInt)
            {
                if (type == MiniTypes.Bool)
                {
                    EmitCode($"%{unaryOp.Identifier.Name} = zext i1 %{eval} to i32");
                }
                else if (type == MiniTypes.Double)
                {
                    EmitCode($"%{unaryOp.Identifier.Name} = fptosi double %{eval} to i32");
                }
                else
                {
                    EmitCode($"%{unaryOp.Identifier.Name} = add i32 %{eval}, 0");
                }
            }
            else if (unaryOp.Unary == Unary.ConversionToDouble)
            {
                if (type == MiniTypes.Int)
                {
                    EmitCode($"%{unaryOp.Identifier.Name} = sitofp i32 %{eval} to double");
                }
                else
                {
                    EmitCode($"%{unaryOp.Identifier.Name} = fadd double %{eval}, 0.0");
                }
            }
            else if (unaryOp.Unary == Unary.LogicNegation)
            {
                EmitCode($"%{unaryOp.Identifier.Name} = xor i1 %{eval}, 1");
            }
            else if (unaryOp.Unary == Unary.BitNegation)
            {
                EmitCode($"%{unaryOp.Identifier.Name} = xor i32 %{eval}, -1");
            }
            else if (unaryOp.Unary == Unary.Minus)
            {
                if (type == MiniTypes.Double)
                {
                    EmitCode($"%{unaryOp.Identifier.Name} = fsub double 0.0, %{eval}");
                }
                else
                {
                    EmitCode($"%{unaryOp.Identifier.Name} = sub i32 0, %{eval}");
                }

            }
        }

        public void Visit(IfStatement ifStatement)
        {
            ifStatement.Test.Accept(this);

            var label_true = Helper.NewLabel();
            var label_false = Helper.NewLabel();
            var label_end = Helper.NewLabel();

            EmitCode($"br i1 %{ifStatement.Test.Identifier.Name}, label %{label_true}, label %{label_false}");
            EmitCode($"{label_true}:");
            ifStatement.Statement.Accept(this);
            EmitCode($"br label %{label_end}");
            EmitCode($"{label_false}:");
            if (ifStatement.ElseStatement != null)
            {
                ifStatement.ElseStatement.Accept(this);
            }
            EmitCode($"br label %{label_end}");
            EmitCode($"{label_end}:");
        }

        public void Visit(ReturnStatement returnStatement)
        {
            EmitCode($"ret i32 0");
        }

        public void Visit(WhileStatement whileStatement)
        {
            var start_label = Helper.NewLabel();
            var true_label = Helper.NewLabel();
            var false_label = Helper.NewLabel();

            EmitCode($"br label %{start_label}");
            EmitCode($"{start_label}:");
            whileStatement.Test.Accept(this);
            EmitCode($"br i1 %{whileStatement.Test.Identifier.Name}, label %{true_label}, label %{false_label}");
            EmitCode($"{true_label}:");
            whileStatement.Statement.Accept(this);
            EmitCode($"br label %{start_label}");
            EmitCode($"{false_label}:");
        }

        public void Visit(Read read)
        {
            if (read.Variable.Type == MiniTypes.Int)
            {
                EmitCode($"call i32 (i8*, ...) @scanf(i8* bitcast ([3 x i8]* @int_read to i8*), i32* %{read.Variable.Name})");
            }
            else
            {
                EmitCode($"call i32 (i8*, ...) @scanf(i8* bitcast ([4 x i8]* @double_read to i8*), double* %{read.Variable.Name})");
            }
        }

        public void Visit(ReadHex readHex)
        {
            EmitCode($"call i32 (i8*, ...) @scanf(i8* bitcast ([3 x i8]* @hex_read to i8*), i32* %{readHex.Variable.Name})");
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
            else if (type == MiniTypes.Int)
            {
                Value = value;
            }
            else if (type == MiniTypes.Bool)
            {
                if (value == "true")
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
                Value = string.Format(System.Globalization.CultureInfo.InvariantCulture, "{0:0.0###############}", value);
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

    public interface IEvaluable : INode
    {
        Identifier Identifier { get; }
    }

    public interface IAssignable : IEvaluable
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

    public class WriteHex : INode
    {
        public IEvaluable Evaluable { get; }
        public WriteHex(IEvaluable evaluable)
        {
            Evaluable = evaluable;
            if (evaluable.Identifier.Type != MiniTypes.Int)
            {
                Compiler.errors++;
                Compiler.PrintError("Invalid types");
            }
        }
        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public class WriteString : INode
    {
        public string Value { get; }
        public int Length { get; }
        public WriteString(string value) => (Value, Length) = Helper.ParseString(value);
        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public class Read : INode
    {
        public Variable Variable { get; }
        public Read(Variable variable)
        {
            Variable = variable;

            if (Variable.Type == MiniTypes.Bool)
            {
                Compiler.errors++;
                Compiler.PrintError("Invalid types");
            }
        }
        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public class ReadHex : INode
    {
        public Variable Variable { get; }
        public ReadHex(Variable variable)
        {
            Variable = variable;

            if (Variable.Type != MiniTypes.Int)
            {
                Compiler.errors++;
                Compiler.PrintError("Invalid types");
            }
        }
        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public class IfStatement : INode
    {
        public IEvaluable Test { get; }
        public INode Statement { get; }
        public INode ElseStatement { get; }

        public IfStatement(IEvaluable test, INode statement, INode elseStatement = null)
        {
            Test = test;
            Statement = statement;
            ElseStatement = elseStatement;

            if (test.Identifier.Type != MiniTypes.Bool)
            {
                Compiler.errors++;
                Compiler.PrintError("Invalid types");
            }
        }

        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public class ReturnStatement : INode
    {
        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public class WhileStatement : INode
    {
        public IEvaluable Test { get; }
        public INode Statement { get; }

        public WhileStatement(IEvaluable test, INode statement)
        {
            Test = test;
            Statement = statement;

            if (test.Identifier.Type != MiniTypes.Bool)
            {
                Compiler.errors++;
                Compiler.PrintError("Invalid types");
            }
        }
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

            if ((assignable.Type == MiniTypes.Double && evaluable.Identifier.Type == MiniTypes.Bool) ||
               (assignable.Type == MiniTypes.Int && evaluable.Identifier.Type != MiniTypes.Int) ||
               (assignable.Type == MiniTypes.Bool && evaluable.Identifier.Type != MiniTypes.Bool))
            {
                Compiler.errors++;
                Compiler.PrintError("Invalid types");
            }
        }

        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }


    #region operators
    public interface IBinaryOperator
    {
        IEvaluable Left { get; }
        IEvaluable Right { get; }
    }

    public abstract class LogicOp : IBinaryOperator, IEvaluable
    {
        public IEvaluable Left { get; }
        public IEvaluable Right { get; }

        public Identifier Identifier { get; }

        public LogicOp(IEvaluable eval1, IEvaluable eval2)
        {
            if (eval1.Identifier.Type != MiniTypes.Bool || eval2.Identifier.Type != MiniTypes.Bool)
            {
                Compiler.errors++;
                Compiler.PrintError("Invalid types");
            }
            Left = eval1;
            Right = eval2;

            Identifier = new Identifier(Helper.NewTmp(), eval1.Identifier.Type);
        }

        public abstract void Accept(IVisitor visitor);
    }

    public class LogicAnd : LogicOp, IEvaluable
    {
        public LogicAnd(IEvaluable eval1, IEvaluable eval2) : base(eval1, eval2) { }
        public override void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public class LogicOr : LogicOp, IEvaluable
    {
        public LogicOr(IEvaluable eval1, IEvaluable eval2) : base(eval1, eval2) { }
        public override void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public enum Relation
    {
        Equal,
        NotEqual,
        Greater,
        GreaterEqual,
        Less,
        LessEqual
    }

    public class RelationOp : IEvaluable, IBinaryOperator
    {
        public Relation Relation { get; }
        public Identifier Identifier { get; }

        public IEvaluable Left { get; }

        public IEvaluable Right { get; }

        public RelationOp(IEvaluable eval1, IEvaluable eval2, Relation relation)
        {
            Relation = relation;
            Identifier = new Identifier(Helper.NewTmp(), MiniTypes.Bool);
            Left = eval1;
            Right = eval2;

            var leftType = eval1.Identifier.Type;
            var rightType = eval2.Identifier.Type;

            if (relation == Relation.Equal || relation == Relation.NotEqual)
            {
                if ((leftType == MiniTypes.Bool && rightType != MiniTypes.Bool) ||
                    (rightType == MiniTypes.Bool && leftType != MiniTypes.Bool))
                {
                    Compiler.errors++;
                    Compiler.PrintError("Invalid types");
                }
            }
            else if (leftType == MiniTypes.Bool || rightType == MiniTypes.Bool)
            {
                Compiler.errors++;
                Compiler.PrintError("Invalid types");
            }

        }

        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public enum Mathhematical
    {
        Add,
        Sub,
        Mul,
        Div
    }
    public class MathhematicalOp : IEvaluable, IBinaryOperator
    {
        public Mathhematical Mathhematical { get; }
        public IEvaluable Left { get; }

        public IEvaluable Right { get; }

        public Identifier Identifier { get; }

        public MathhematicalOp(IEvaluable left, IEvaluable right, Mathhematical mathhematical)
        {
            Mathhematical = mathhematical;
            Left = left;
            Right = right;

            var leftType = left.Identifier.Type;
            var rightType = right.Identifier.Type;

            AbstractMiniType resultType;
            if (leftType == MiniTypes.Int && rightType == MiniTypes.Int)
            {
                resultType = MiniTypes.Int;
            }
            else
            {
                resultType = MiniTypes.Double;
            }

            if (leftType == MiniTypes.Bool || rightType == MiniTypes.Bool)
            {
                Compiler.errors++;
                Compiler.PrintError("Invalid types");
            }

            Identifier = new Identifier(Helper.NewTmp(), resultType);
        }

        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public enum Bitwise
    {
        And,
        Or
    }

    public class BitwiseOp : IEvaluable, IBinaryOperator
    {
        public Bitwise Bitwise { get; }
        public Identifier Identifier { get; }
        public IEvaluable Left { get; }
        public IEvaluable Right { get; }

        public BitwiseOp(IEvaluable left, IEvaluable right, Bitwise bitwise)
        {
            Bitwise = bitwise;
            Left = left;
            Right = right;

            var leftType = left.Identifier.Type;
            var rightType = right.Identifier.Type;

            if (leftType != MiniTypes.Int || rightType != MiniTypes.Int)
            {
                Compiler.errors++;
                Compiler.PrintError("Invalid types");
            }

            Identifier = new Identifier(Helper.NewTmp(), MiniTypes.Int);
        }
        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }

    public enum Unary
    {
        Minus,
        BitNegation,
        LogicNegation,
        ConversionToInt,
        ConversionToDouble
    }

    public class UnaryOp : IEvaluable
    {
        public Unary Unary { get; }
        public Identifier Identifier { get; }
        public IEvaluable Evaluable { get; }
        public UnaryOp(IEvaluable evaluable, Unary unary)
        {
            Evaluable = evaluable;
            Unary = unary;

            var type = evaluable.Identifier.Type;

            AbstractMiniType resultType = MiniTypes.Int;
            if (unary == Unary.Minus && (type == MiniTypes.Int || type == MiniTypes.Double))
            {
                resultType = type;
            }
            else if (unary == Unary.BitNegation && type == MiniTypes.Int)
            {
                resultType = MiniTypes.Int;
            }
            else if (unary == Unary.LogicNegation && type == MiniTypes.Bool)
            {
                resultType = MiniTypes.Bool;
            }
            else
            {
                Compiler.errors++;
                Compiler.PrintError("Invalid types");
            }

            Identifier = new Identifier(Helper.NewTmp(), resultType);
        }

        public UnaryOp(IEvaluable evaluable, AbstractMiniType type)
        {
            Evaluable = evaluable;

            var resultType = evaluable.Identifier.Type;

            if (type == MiniTypes.Int)
            {
                Unary = Unary.ConversionToInt;
            }
            else if (type == MiniTypes.Double)
            {
                Unary = Unary.ConversionToDouble;
            }

            if (Unary == Unary.ConversionToInt)
            {
                resultType = MiniTypes.Int;
            }
            else if (Unary == Unary.ConversionToDouble && (resultType == MiniTypes.Int || resultType == MiniTypes.Double))
            {
                resultType = MiniTypes.Double;
            }
            else
            {
                Compiler.errors++;
                Compiler.PrintError("Invalid types");
            }

            Identifier = new Identifier(Helper.NewTmp(), resultType);
        }
        public void Accept(IVisitor visitor) => visitor.Visit(this);
    }
    #endregion

}
