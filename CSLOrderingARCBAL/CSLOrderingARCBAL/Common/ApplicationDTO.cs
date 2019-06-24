using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSLOrderingARCBAL.BAL
{
   public class ApplicationDTO
    {
        public string smtphost { get; set; }
        public string mailFrom { get; set; }
        public string mailCC { get; set; }
        public string mailTO { get; set; }
        public decimal? VATRate { get; set; }
        public string billingemail { get; set; }
        public String ARC_CC { get; set;}
        public string FedexURL { get; set; }
        public string TeleSalesEmail { get; set; }
        public string ConnectionOnlyCodes { get; set; }
       
    }
}
