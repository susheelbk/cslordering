using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
namespace CSLOrderingARCBAL.BAL
{
    public class ReadTemplates  
    {


        public static String ReadMailTemplate(String templatePath,String templateName)
        {
            try
            {
                String mailBody= System.IO.File.ReadAllText(templatePath + "/" + templateName);
                return mailBody; 
            }
            catch (Exception ex)
            {
                //throw ex;
                return "";
            }

        }
    }
}
