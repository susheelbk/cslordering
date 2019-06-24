using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for PriceBandList
/// </summary>
public class PriceBandList
{
    public int ProductId { get; set; }
    public string ProductCode { get; set; }
    public string ProductName { get; set; }
    public decimal Price { get; set; }
    public decimal? AnnualPrice { get; set; }
    public int ListOrder { get; set; }
    public string CurrencySymbol { get; set; }
}