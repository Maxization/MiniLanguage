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
        public static string GetFile(string name)
        {
            return Path.Combine(ValidTestsPath, name);
        }

        public static IEnumerable<object[]> GetValidFiles()
        {
            List<object[]> result = new List<object[]>();
            string[] files = Directory.GetFiles(ValidTestsPath);
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
                    CreateNoWindow = false
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
    }
}
