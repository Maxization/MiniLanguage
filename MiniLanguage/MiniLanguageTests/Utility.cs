using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
    }
}
