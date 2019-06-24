using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;
using CSLOrderingARCBAL.BAL;
using CSLOrderingARCBAL.Common;

public partial class ADMIN_ManageProductCategory : System.Web.UI.Page
{
    LinqToSqlDataContext db = null;
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            try
            {
                LoadData();
            }
            catch (Exception objException)
            {
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
            finally
            {
                db.Dispose();
            }
        }
    }

    public void LoadData()
    {
        try
        {
            // binding all categories with dropdown
            db = new LinqToSqlDataContext();
            var ctgs = (from ctg in db.Categories
                        where ctg.IsDeleted == false
                        orderby ctg.ListOrder
                        select new { ctg.CategoryId, CategoryDisp = ctg.CategoryName + "[" + ctg.CategoryCode + "] " });


            ddlCategory.DataSource = ctgs;
            ddlCategory.DataValueField = "CategoryId";
            ddlCategory.DataTextField = "CategoryDisp";
            ddlCategory.DataBind();
            ddlCategory.Items.Insert(0, new ListItem("-----Select-----", "-1"));

            //binding gvctg in panel products
            db = new LinqToSqlDataContext();
            var ctgdata = (from ctg in db.Categories
                           where ctg.IsDeleted == false
                           orderby ctg.ListOrder
                           select new { ctg.CategoryId, CategoryDisp = ctg.CategoryName + " [" + ctg.CategoryCode + "]" });
            gvctg.DataSource = ctgdata;
            gvctg.DataBind();


        }
        catch (Exception objException)
        {

            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LoadData", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    #region Save Category related Product

    protected void btnSave_Click(object sender, EventArgs e)
    {

        if (Page.IsValid)
        {

            db = new LinqToSqlDataContext();
            string category = "";
            try
            {
                //delete all existing related products for this Category

                var delprod = db.CategoryRelatedProducts.Where(item => item.CategoryId == Convert.ToInt32(ddlCategory.SelectedValue));
                db.CategoryRelatedProducts.DeleteAllOnSubmit(delprod);
                db.SubmitChanges();

                //enter all newly checked Products
                foreach (GridViewRow ctgrow in gvctg.Rows)
                {
                    if (ctgrow.RowType == DataControlRowType.DataRow)
                    {
                        GridView innergrid = ctgrow.FindControl("gvinner") as GridView;
                        foreach (GridViewRow prodrow in innergrid.Rows)
                        {
                            if (prodrow.RowType == DataControlRowType.DataRow)
                            {
                                CheckBox chkpro = prodrow.FindControl("chkprod") as CheckBox;
                                if (chkpro.Checked == true)
                                {

                                    int Prodid = int.Parse(innergrid.DataKeys[prodrow.RowIndex].Value.ToString());
                                    CategoryRelatedProduct cmp = new CategoryRelatedProduct();
                                    cmp.CategoryId = Convert.ToInt32(ddlCategory.SelectedValue.ToString());
                                    category = ddlCategory.SelectedItem.ToString();
                                    cmp.ProductId = Convert.ToInt32(Prodid);
                                    db.CategoryRelatedProducts.InsertOnSubmit(cmp);
                                    db.SubmitChanges();

                                }
                            }

                        }
                    }

                }
                pnlProductList.Visible = false;
                ddlCategory.SelectedIndex = 0;
                string script = "alertify.alert('" + ltrSaved.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);

            }
            catch (Exception objException)
            {

                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSave_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }

            finally
            {
                Audit audit = new Audit();
                audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
                audit.ChangeID = Convert.ToInt32(enumAudit.Manage_Related_Products);
                audit.CreatedOn = DateTime.Now;
                audit.Notes = category;
                if (Request.ServerVariables["LOGON_USER"] != null)
                {
                    audit.WindowsUser = Request.ServerVariables["LOGON_USER"];
                }
                audit.IPAddress = Request.UserHostAddress;
                db.Audits.InsertOnSubmit(audit);
                db.SubmitChanges();
                db.Dispose();
            }
        }
        else
        {
            string script = "alertify.alert('" + ltrFill.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            MaintainScrollPositionOnPostBack = false;
        }
    }

    #endregion

    protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlCategory.SelectedValue != null && ddlCategory.SelectedValue != "-1")
        {
            CheckProd();

        }
        else
        {
            string script = "alertify.alert('" + ltrChooseCat.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            pnlProductList.Visible = false;
        }

    }


    public void CheckProd()
    {
        try
        {
            pnlProductList.Visible = true;
            // uncheck all Products first
            foreach (GridViewRow ctgrow in gvctg.Rows)
            {
                if (ctgrow.RowType == DataControlRowType.DataRow)
                {
                    CheckBox chkctg = ctgrow.FindControl("chkctg") as CheckBox;
                    chkctg.Checked = false;
                    GridView innergrid = ctgrow.FindControl("gvinner") as GridView;
                    foreach (GridViewRow prodrow in innergrid.Rows)
                    {
                        if (prodrow.RowType == DataControlRowType.DataRow)
                        {
                            CheckBox chkpro = prodrow.FindControl("chkprod") as CheckBox;
                            chkpro.Checked = false;
                        }

                    }
                }

            }
            int Cat_Id = 0;
            db = new LinqToSqlDataContext();
            var cat = (from c in db.CategoryRelatedProducts
                       where c.CategoryId == Convert.ToInt32(ddlCategory.SelectedValue.ToString())
                       select c);
            if (cat.Any(x => x != null))
            {
                foreach (var objp in cat)
                {

                    Cat_Id = Convert.ToInt32(objp.ProductId);
                    foreach (GridViewRow ctgrow in gvctg.Rows)
                    {
                        GridView innergrid = ctgrow.FindControl("gvinner") as GridView;
                        foreach (GridViewRow prodrow in innergrid.Rows)
                        {
                            int chkProdid = int.Parse(innergrid.DataKeys[prodrow.RowIndex].Value.ToString());
                            if (chkProdid == Cat_Id)
                            {
                                CheckBox chkpro = prodrow.FindControl("chkprod") as CheckBox;
                                chkpro.Checked = true;
                                chkprod_CheckedChanged(chkpro, null);

                            }

                        }

                    }

                }

            }
            else
            {
                string script = "alertify.alert('" + ltrNoProd.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
        }
        catch (Exception objException)
        {

            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "CheckProd", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    protected void gvctg_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            GridView innergrid = e.Row.FindControl("gvinner") as GridView;
            int ctgid = int.Parse(gvctg.DataKeys[e.Row.RowIndex].Value.ToString());
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            var Productdata = (from prod in db.Products
                               join prodctg in db.Category_Product_Maps on prod.ProductId equals prodctg.ProductId
                               where prod.IsDeleted == false &&
                               prod.IsDependentProduct == false &&
                               prodctg.CategoryId == ctgid
                               orderby prod.ProductCode
                               select new { prod.ProductId, ProductDisp = prod.ProductName + " [" + prod.ProductCode + "]" });
            if (Productdata.Any(x => x != null))
            {
                innergrid.DataSource = Productdata;
                innergrid.DataBind();
            }

        }
    }


    protected void chkctg_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox chk = sender as CheckBox;
        GridViewRow Parentrow = chk.NamingContainer as GridViewRow;
        int ctgid = int.Parse(gvctg.DataKeys[Parentrow.RowIndex].Value.ToString());

        GridView innergrid = Parentrow.FindControl("gvinner") as GridView;
        if (chk.Checked == true)
        {
            foreach (GridViewRow childrow in innergrid.Rows)
            {
                CheckBox chkprod = childrow.FindControl("chkprod") as CheckBox;
                chkprod.Checked = true;

            }
        }
        else
        {
            foreach (GridViewRow childrow in innergrid.Rows)
            {
                CheckBox chkprod = childrow.FindControl("chkprod") as CheckBox;
                chkprod.Checked = false;

            }
        }

    }
    protected void chkprod_CheckedChanged(object sender, EventArgs e)
    {

        CheckBox chkprod = sender as CheckBox;
        //GridViewRow parentrow = chkprod.Parent.NamingContainer as GridViewRow;
        GridViewRow childrow = chkprod.NamingContainer as GridViewRow;
        GridViewRow parentrow = childrow.Parent.Parent.NamingContainer as GridViewRow;
        CheckBox chkctg = parentrow.FindControl("chkctg") as CheckBox;
        if (chkprod.Checked == false)
        {

            if (chkctg.Checked == true)
            {
                chkctg.Checked = false;
            }
        }
        else
        {
            //fetch how many of products are checked.counterchkprod=0, if items are 5 and checked
            // are 4(only 1 less) then on checking chkprod to true will set ctgchk to true else do nothing
            GridView gridproduct = parentrow.FindControl("gvinner") as GridView;
            int i = gridproduct.Rows.Count;
            int Countercheckedproducts = 0;
            foreach (GridViewRow childprodrow in gridproduct.Rows)
            {
                CheckBox chkpro = childprodrow.FindControl("chkprod") as CheckBox;
                if (chkpro.Checked)
                {
                    Countercheckedproducts += 1;
                }
            }

            if (i == Countercheckedproducts)
            {
                chkctg.Checked = true;
            }

        }

    }
    protected void btnReset_Click(object sender, EventArgs e)
    {
        ddlCategory_SelectedIndexChanged(sender, e);
    }
}