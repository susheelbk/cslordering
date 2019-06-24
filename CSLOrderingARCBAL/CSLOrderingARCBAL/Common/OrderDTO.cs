using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSLOrderingARCBAL.Common
{
    public class OrderDTO
    {
        public int OrderId { get; set; }
        public string SpecialInstructions { get; set; }
        public string CSLOrderNo { get; set; }
        public string OrderQty { get; set; }
        public DateTime OrderDate { get; set; }
        public string ARCOrderRefNo { get; set; }
        public string DeliveryType { get; set; }
        public string DeliveryCost { get; set; }
        public string OrderTotal { get; set; }
        public string VATAmount { get; set; }
        public string TotalAmountToPay { get; set; }
        public DateTime? orderfromdate { get; set; }
        public DateTime? ordertodate { get; set; }
        public int orderprodid { get; set; }
        public int orderctgid { get; set; }
        public int orderarcid { get; set; }
        public string ARCDisp { get; set; }
        public string UserEmail { get; set; }
        public string CreatedBy { get; set; }
        public string UserName { get; set; }
        public string InstallerId { get; set; }
        public String CompanyName { get; set; }
        public string TrackingNo { get; set; }
        public Guid UserId { get; set; }
        public int? InstallationAddressId { get; set; }
        public string ItemDlvNoteNo { get; set; }
        public string OrderStatus { get; set; }
        public String ChipNo { get; set; }

    }

    public class OrderItemDetailsDTO
    {

        public String GPRSNo { get; set; }
        public String PSTNNo { get; set; }
        public String GSMNo { get; set; }
        public String LANNo { get; set; }
        public String GPRSNoPostCode { get; set; }
        public String DataNo { get; set; }
        public String ICCID { get; set; }
        public String OrderItemStatus { get; set; }
        public String OptionName { get; set; }

    }
}
