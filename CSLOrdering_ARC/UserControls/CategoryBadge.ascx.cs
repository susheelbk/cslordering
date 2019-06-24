using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Text;
using CSLOrderingARCBAL;
using CSLOrderingARCBAL.BAL;

public partial class Modules_CategoryBadge : System.Web.UI.UserControl
{

    public string CategoryName { get; set; }
    public string CategoryCode { get; set; }
    public int CategoryID { get; set; }
    public string CategoryDefaultImage { get; set; }
    public string CategoryDesc { get; set; }


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            lnkCategoryName.Text = this.CategoryName;
            imgCatProducts.ImageUrl = string.IsNullOrEmpty(this.CategoryDefaultImage) ? SiteUtility.GetSiteRoot() + "/images/noImage.gif" : SiteUtility.GetSiteRoot() + "/" + this.CategoryDefaultImage;
            lnkCategoryName.NavigateUrl = "../ProductList.aspx?CategoryId=" + this.CategoryID;
            lnkCategoryImage.NavigateUrl = "../ProductList.aspx?CategoryId=" + this.CategoryID;
            hdnCatID.Value = this.CategoryID.ToString();
            lblCategoryDesc.Text = this.CategoryDesc;
        }
        Submit.Click += Submit_Click;
    }

    void Submit_Click(object sender, EventArgs e)
    {
        Response.Redirect(SiteUtility.GetSiteRoot() + "/ProductList.aspx?CategoryId=" + hdnCatID.Value);
    }
}