using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Text;
using CSLOrderingARCBAL.Common;
using CSLOrderingARCBAL.BAL;
using System.ComponentModel;

public partial class Modules_ProductBadge : System.Web.UI.UserControl
{

    #region Properties

    public int ProductID;
    public string ProductCode;
    public string ProductTitle;
    public string ThumbImageUrl;
    public string ProductPrice;
    public string CategoryID;

    #endregion



    public event ClickEvent customButtonClickEvent;
    public delegate void ClickEvent();



    public void OnUserControlButtonClick()
    {
        if (customButtonClickEvent != null)
        {
            customButtonClickEvent();
        }
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!Page.IsPostBack)
            {
                LoadProductDetails();
            }
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), ((System.Reflection.MemberInfo)(objException.TargetSite)).Name, Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }



    private void LoadProductDetails()
    {
        if (ProductID == 0)
        {
            return;
        }

        lblProductCode.Text = this.ProductCode;
        lblProductTitle.Text = this.ProductTitle;
        lblProductPrice.Text = "£" + this.ProductPrice + " (ex vat) ";
        string url = SiteUtility.GetRewriterUrl("productdetailview", ProductID, "");
        lnkProductView.CommandArgument = url;
        lnkProductView.AlternateText = url;
        lnkProductView.ImageUrl = string.IsNullOrEmpty(ThumbImageUrl) ? SiteUtility.GetSiteRoot() + "/images/noImage.gif" : SiteUtility.GetSiteRoot() + "/" + ThumbImageUrl;
        btnAddToBasket.CommandArgument = ProductID.ToString();
        btnAddToBasket.Enabled = this.ProductCode.Trim() == "CS2367" ? false : true;

        if (Session[enumSessions.User_Role.ToString()] != null && Session[enumSessions.User_Role.ToString()].ToString().ToUpper() == "ARC_ADMIN")
            lblProductPrice.Visible = false;
    }



    protected void btnAddToBasket_Click(object sender, ImageClickEventArgs e)
    {
        //if (MainPage.IsUserAuthenticated())
        //{
        //    ImageButton btnAddToBasket = sender as ImageButton;
        //    Product product = ProductController.GetProduct(new Guid(btnAddToBasket.CommandArgument));
        //    OrderController.AddItem(SiteUtility.GetUserName(), product, 1);
        //    animationShowLoginMsg.Enabled = true;
        //    lblItemAddedMsg.Visible = true;
        //}
        //else
        //{
        //    Response.Redirect(SiteUtility.GetSiteRoot() + "/Login.aspx?q=true");
        //}

        //OnUserControlButtonClick();
    }



    protected void lnkProductView_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton btn = sender as ImageButton;
        Response.Redirect(btn.CommandArgument);
    }
}
