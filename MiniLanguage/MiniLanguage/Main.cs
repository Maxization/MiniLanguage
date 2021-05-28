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

    public interface INode
    {

    }

    public class Program : INode
    {
        public Block MainBody { get; set; }

        public Program(Block body) => MainBody = body;
    }

    public class Block : INode
    {
        List<INode> Statements { get; }

        public Block(List<INode> statements) => Statements = statements;
    }

}
