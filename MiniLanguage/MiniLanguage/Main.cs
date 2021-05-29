using System;
using System.IO;
using System.Collections.Generic;
using GardensPoint;

namespace MiniLanguage
{
    public class Compiler
    {
        public static int errors = 0;
        public static Program Program { get; set; }

        public static List<string> source;

        // arg[0] określa plik źródłowy
        // pozostałe argumenty są ignorowane
        public static int Main(string[] args)
        {
            string file;
            FileStream source;
            Console.WriteLine("\nLLVM Code Generator for Multiline Calculator - Recursive Descent Method");
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
                GenCode();
                sw.Close();
                Console.WriteLine("  compilation successful\n");
            }
            else
                Console.WriteLine($"\n  {errors} errors detected\n");
            return errors == 0 ? 0 : 2;
        }

        public static void EmitCode(string instr = null)
        {
            sw.WriteLine(instr);
        }

        public static void EmitCode(string instr, params object[] args)
        {
            sw.WriteLine(instr, args);
        }

        public static string NewTemp()
        {
            return string.Format($"%t{++nr}");
        }

        private static StreamWriter sw;
        private static int nr;

        private static void GenCode()
        {
            EmitCode("; prolog");
            EmitCode("@int_res = constant [15 x i8] c\"  Result:  %d\\0A\\00\"");
            EmitCode("@double_res = constant [16 x i8] c\"  Result:  %lf\\0A\\00\"");
            EmitCode("@end = constant [20 x i8] c\"\\0AEnd of execution\\0A\\0A\\00\"");
            EmitCode("declare i32 @printf(i8*, ...)");
            EmitCode("define void @main()");
            EmitCode("{");
            for (char c = 'a'; c <= 'z'; ++c)
            {
                EmitCode($"%i{c} = alloca i32");
                EmitCode($"store i32 0, i32* %i{c}");
                EmitCode($"%r{c} = alloca double");
                EmitCode($"store double 0.0, double* %r{c}");
            }
            EmitCode();

            //TODO: Emit Program code
            //for (int i = 0; i < code.Count; ++i)
            //{
            //    EmitCode($"; linia {i + 1,3} :  " + source[i]);
            //    code[i].GenCode();
            //    EmitCode();
            //}
            EmitCode("}");
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

    #region

    public abstract class BinaryOperator
    {

    }


    #endregion

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
        private static int nr;
        public static string NewTemp(string prefix) => $"{prefix}_{++nr}";
        public static void EmitCode(string instr = null) => sw.WriteLine(instr);
        public static void EmitCode(string instr, params object[] args) => sw.WriteLine(instr, args);
        private Dictionary<string, Declaration> Declarations => new Dictionary<string, Declaration>();

        public Declaration AddDeclaration(string name, AbstractMiniType type)
        {
            string uniqueName = NewTemp(name);
            //Check types and if exists
            Identifier ident = new Identifier(uniqueName, type);
            Declaration dec = new Declaration(ident);

            Declarations.Add(name, dec);
            return dec;
        }

        
        private static void GenProlog()
        {
            EmitCode("; prolog");
            EmitCode("@int_res = constant [15 x i8] c\"  Result:  %d\\0A\\00\"");
            EmitCode("@double_res = constant [16 x i8] c\"  Result:  %lf\\0A\\00\"");
            EmitCode("@end = constant [20 x i8] c\"\\0AEnd of execution\\0A\\0A\\00\"");
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

    public class Assigment : INode
    {
        public void Accept(IVisitor visitor)
        {
            throw new NotImplementedException();
        }
    }

    public class Write : INode
    {
        public void Accept(IVisitor visitor)
        {
            throw new NotImplementedException();
        }
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

    public class Variable : INode
    {
        public Identifier Identifier { get; }
        public string Value { get; set; }
        public void Accept(IVisitor visitor)
        {
            throw new NotImplementedException();
        }
    }

}
