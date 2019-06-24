using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Linq;
using System.Data.Linq.SqlClient;
using CSLOrderingARCBAL;
using CSLOrderingARCBAL.BAL;
using CSLOrderingARCBAL.Common;

public partial class Products : MainPage
{

    #region Properties
    public int CategoryID { get; set; }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Session[enumSessions.User_Id.ToString()] == null)
                Response.Redirect("Login.aspx");

            if (!Page.IsPostBack)
            {
                if (Request.QueryString["CategoryId"] != null)
                {
                    this.CategoryID = Convert.ToInt32(Request.QueryString["CategoryId"]);
                    if (CategoryID == 0)
                    {
                        Response.Redirect("Categories.aspx"); 
                    }

                    LoadProductDetails();
                }
            }
        }
        catch (System.Threading.ThreadAbortException ex)
        {
            //
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    private void LoadProductDetails()
    {
        if (this.CategoryID == 0)
        {
            return;
        }

        LinqToSqlDataContext db = new LinqToSqlDataContext();
        dlProducts.DataSource = db.USP_GetProductsByCategoryAndArc(CategoryID, Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString()));
        dlProducts.DataBind();
        db.Dispose();

        db = new LinqToSqlDataContext();
        var categoryName = (from cats in db.Categories
                            where cats.CategoryId == CategoryID
                            select cats.CategoryName).Single<string>();
        lblCategoryName.Text = categoryName.ToString();
        db.Dispose();
    }


    protected void ProductsRepeater_ItemBound(object sender, RepeaterItemEventArgs args)
    {
        //if (args.Item.ItemType == ListItemType.Item || args.Item.ItemType == ListItemType.AlternatingItem)
        //{
        //    Product product = (Product)args.Item.DataItem;
        //    Repeater rep = (Repeater)args.Item.FindControl("rptrRelatedProducts");

        //    LinqToSqlDataContext db = new LinqToSqlDataContext();
        //    rep.DataSource = db.USP_GetRelatedProductsByCategoryId(this.CategoryID, product.ProductId);
        //    rep.DataBind();
        //    db.Dispose();
        //}
    }

}


