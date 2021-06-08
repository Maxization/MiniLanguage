using MiniLanguage;
using System;
using System.Collections.Generic;
using Xunit;

namespace MiniLanguageTests
{
    public class ValidTests
    {
        private readonly int noErrors = 0;

        [Theory]
        [MemberData(nameof(TesstNames))]
        public void ValidProgram(string test_name)
        {
            var path = Utility.GetFile(test_name);
            string[] args = new string[] { path };
            int result = Compiler.Main(args);

            Assert.Equal(noErrors, result);

            var llPath = Compiler.OutputFile;

            Utility.Run(llPath);
        }

        public static IEnumerable<object[]> TesstNames => Utility.GetValidFiles();
    }
}
