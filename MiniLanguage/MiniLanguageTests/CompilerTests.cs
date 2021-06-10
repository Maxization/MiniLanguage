using MiniLanguage;
using System;
using System.Collections.Generic;
using Xunit;

namespace MiniLanguageTests
{
    public class CompilerTests
    {
        private readonly int noErrors = 0;
        public static IEnumerable<object[]> ValidTestNames => Utility.GetFiles(Utility.ValidTestsPath);
        public static IEnumerable<object[]> OutputTestNames => Utility.GetFiles(Utility.OutputTestsPath);

        [Theory]
        [MemberData(nameof(ValidTestNames))]
        public void ValidProgram(string test_name)
        {
            var path = Utility.GetFile(Utility.ValidTestsPath, test_name);
            string[] args = new string[] { path };
            int result = Compiler.Main(args);

            Assert.Equal(noErrors, result);

            var llPath = Compiler.OutputFile;

            Utility.Run(llPath);
        }

        [Theory]
        [MemberData(nameof(OutputTestNames))]
        public void OutputProgram(string test_name)
        {
            var path = Utility.GetFile(Utility.OutputTestsPath, test_name);
            string[] args = new string[] { path };
            int result = Compiler.Main(args);

            Assert.Equal(noErrors, result);

            var llPath = Compiler.OutputFile;

            var output = Utility.Run(llPath);

            foreach((string program_name, string output) k in Utility.Outputs)
            {
                if(k.program_name == test_name)
                {
                    Assert.Equal(k.output, output);
                }
            }
        }

        
    }
}
