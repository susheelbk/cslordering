using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSLOrderingARCBAL.Common
{
    public class SendEmailDTO
    {
        public string specialInstructions { get; set; }
        public string orderDate { get; set; }
        public string orderNo { get; set; }
        public string orderID { get; set; }
        public string ARCOrderRefNo { get; set; }
        public string DdeliveryType { get; set; }
        public string deliveryCost { get; set; }
        public int orderQuantity { get; set; }
        public decimal orderTotal { get; set; }
        public string vatAmount { get; set; }
        public string totalAmountToPay { get; set; }
        public string userEmail { get; set; }
       
     

        // public string createdBy { get; set; }
        public string userID { get; set; }
        public string userName { get; set; }
        public string installerID { get; set; }
       // public int? InstallationAddId { get; set; }
       // public bool instadd_differs { get; set; }
    }
}
