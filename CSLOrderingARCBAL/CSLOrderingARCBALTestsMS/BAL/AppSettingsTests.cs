using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSLOrderingARCBAL.BAL;
using Microsoft.VisualStudio.TestTools.UnitTesting;
namespace CSLOrderingARCBAL.BAL.Tests
{
    [TestClass()]
    public class AppSettingsTests
    {
        [TestMethod()]
        public void GetAppValuesTest()
        {
            AppSettings setttings = new AppSettings();
            ApplicationDTO data = setttings.GetAppValues();
            string s= "Pyronix or".ToString().TrimEnd('o','r');
            Assert.Fail();
        }
    }
}
