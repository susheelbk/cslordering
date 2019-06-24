using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSLOrderingARCBAL.Common
{
    public class ProductDTO
    {
        public string ProductName { get; set; }
        public string ProductCode { get; set; }
        public int ProductId { get; set; }
        public string DefaultImage { get; set; }
        public int CategoryID { get; set; }
        public int Qty { get; set; }
        public List<ProductItemDetailsDTO> productItemDetailsDTOList { get; set; }
    }


    public class ProductItemDetailsDTO
    {
        public string GPRS_ChipNo { get; set; }
    }

    public class GradeDTO
    {
        public String Grade { get; set; }
    }


    public class ProductGradeDTO
    {
        public int ProductGradeID { get; set; }
        public String ProductCode { get; set; }
        public String Grade { get; set; }

    }

    public class BOSDeviceDTO
    {
        public String Dev_Account_Code { get; set; }
        public String Dev_Connect_Number { get; set; }
        public String Dev_Code { get; set; }
        public String EMNo { get; set; }
        public String Dev_Type { get; set; }
        public String Dev_Arc_Primary { get; set; }
        public int Dev_Inst_UnqCode { get; set; }
        public String InstallerName { get; set; }
        public String ARCName { get; set; }
        public string PostCode { get; set; }
    }

}
