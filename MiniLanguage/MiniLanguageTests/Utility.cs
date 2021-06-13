using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace MiniLanguageTests
{
    public static class Utility
    {
        public static string ValidTestsPath { get => Path.Combine(AppDomain.CurrentDomain.BaseDirectory, @"..\..\..\ValidTests"); }
        public static string OutputTestsPath { get => Path.Combine(AppDomain.CurrentDomain.BaseDirectory, @"..\..\..\OutputTests"); }
        public static string FailTestPath { get => Path.Combine(AppDomain.CurrentDomain.BaseDirectory, @"..\..\..\FailTests"); }
        public static string GetFile(string path, string name)
        {
            return Path.Combine(path, name);
        }

        public static IEnumerable<object[]> GetFiles(string sourcePath)
        {
            List<object[]> result = new List<object[]>();
            string[] files = Directory.GetFiles(sourcePath);
            foreach(string path in files)
            {
                if(!path.EndsWith(".ll"))
                {
                    result.Add(new object[] { Path.GetFileName(path) });
                }
            }
            return result;
        }

        public static string Run(string path)
        {
            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "cmd.exe",
                    Arguments = $"/C lli {path}",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    CreateNoWindow = true
                }
            };

            process.Start();
            Task<string> output = process.StandardOutput.ReadToEndAsync();

            string filename = Path.GetFileName(path);
            bool exited = process.WaitForExit(5000);
            Assert.True(exited, $"{filename} took more than 5 seconds");
            Assert.Equal(0, process.ExitCode);

            return output.GetAwaiter().GetResult();
        }

        public static (string, string)[] Outputs => new (string, string)[]
                {
                    ("bit_ops.mini", "15 40.000000 0 3"),
                    ("brodka1.mini", "5 123.456000 True "),
                    ("brodka2.mini", "1 12 True"),
                    ("comp_ops.mini", "True False False False True True True True True"),
                    ("default.mini", "0 0.000000 False"),
                    ("ifelse.mini", "7 22 11 34 17 52 26 13 40 20 10 5 16 8 4 2 iters: 16"),
                    ("logic_ops.mini", "True True False True False"),
                    ("math_ops.mini", "3 -1 2 0.000000 0.500000 2.000000 6 -2.000000 25.000000 6 6"),
                    ("monte_carlo.mini", "PI between 3 and 3.3: True"),
                    ("multi_assignment.mini", "6 6 6.000000"),
                    ("return.mini", "return"),
                    ("strings.mini", "\\\"\r\n?"),
                    ("unary.mini", "-1 5 False True -2 1 3.560000 8.000000 5 1 3 1 0"),
                    ("while.mini", "40320 1 2 3 4 5 9 -2 0"),
                    ("hex_test", "506\r\n0X1FA\r\n506\r\n0X1FA\r\n506\r\n0X1FA\r\n31\r\n0X1F\r\n")
                };
    }
}
