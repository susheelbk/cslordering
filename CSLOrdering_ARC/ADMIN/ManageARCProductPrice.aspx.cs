using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;

public partial class ADMIN_ManageARCProductPrice : System.Web.UI.Page
{
    #region Variable

    LinqToSqlDataContext db;

    #endregion

    #region Page Load

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                BindARCDropdown();
            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    #endregion

    #region Bind ARC DropDown


    /// <summary>
    /// Bind All ARC's with dropdown on page load  
    /// 
    /// </summary>
    private void BindARCDropdown()
    {
        db = new LinqToSqlDataContext();
        var ARCdata = (from arc in db.ARCs
                       orderby arc.CompanyName ascending
                       where arc.IsDeleted == false
                       select new { arc.ARCId, ARCDisp = arc.CompanyName + " - [" + arc.ARC_Code + "] " });

        ddlArc.DataValueField = "ARCId";
        ddlArc.DataTextField = "ARCDisp";
        ddlArc.DataSource = ARCdata;
        ddlArc.DataBind();
        ddlArc.Items.Insert(0, new ListItem("-----------------------------------Select-----------------------------------", "0"));


    }


    #endregion

    #region Bind selected ARC's Products

    /// <summary>
    /// Get product details of selected ARC 
    /// </summary>
    /// <param name="arcId"></param>
    private void BindProducts(int arcId)
    {
        db = new LinqToSqlDataContext();
        var ProductData = db.USP_GetProductsByArc(arcId); // call sp


        gvProducts.DataSource = ProductData;
        gvProducts.DataBind();

        if (gvProducts.Rows.Count == 0)
        {
            string script = "alertify.alert('" + ltrNoMap.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
        }
    }


    #endregion

    #region Save ARC price

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                Audit audit = new Audit();
                string notes = null;
                if (ddlArc.SelectedIndex > 0)
                {
                    if (gvProducts.Rows.Count > 0)
                    {
                        int retrun = -1;
                        foreach (GridViewRow row in gvProducts.Rows)
                        {
                            Decimal objtxtPrice = -1;
                            DateTime? objtxtExpiryDate = null;
                            Int32 objlblProuctId = Convert.ToInt32((row.FindControl("ProductId") as Label).Text); // get product id            
                            if ((row.FindControl("txtPrice") as TextBox).Text.Trim() != "")
                                objtxtPrice = Convert.ToDecimal((row.FindControl("txtPrice") as TextBox).Text); // get entered Price 

                            if ((row.FindControl("txtExpiryDate") as TextBox).Text.Trim() != "")
                                objtxtExpiryDate = DateTime.Parse((row.FindControl("txtExpiryDate") as TextBox).Text); // get selected expiry date

                            if (objtxtPrice > -1 && objtxtExpiryDate != null)
                            {
                                db = new LinqToSqlDataContext();
                                retrun = db.USP_SaveARCProductPrice(Convert.ToInt32(ddlArc.SelectedValue), objlblProuctId, objtxtPrice, objtxtExpiryDate, Convert.ToString(Session[enumSessions.User_Id.ToString()])); // pass all values to save 
                            }
                            notes += "Product: " + objlblProuctId + ", Price: " + objtxtPrice + ", Date: " + objtxtExpiryDate + ", ";
                        }

                        if (retrun == 0)
                        {
                            string script = "alertify.alert('" + ltrProdPriceUpdate.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        }
                        else
                        {
                            string script = "alertify.alert('" + ltrEntered.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        }

                        BindProducts(Convert.ToInt32(ddlArc.SelectedValue.ToString())); // Bind updated price/date with Gridview 
                    }
                    else
                    {
                        string script = "alertify.alert('" + ltrNoProdMap.Text + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    }
                }

                else
                {
                    string script = "alertify.alert('" + ltrSelectARC.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                }
                audit.Notes = "ARC: " + ddlArc.SelectedItem.ToString() + ", " + notes;
                audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
                audit.ChangeID = Convert.ToInt32(enumAudit.Manage_ARC_Product_Price);
                audit.CreatedOn = DateTime.Now;
                if (Request.ServerVariables["LOGON_USER"] != null)
                {
                    audit.WindowsUser = Request.ServerVariables["LOGON_USER"];
                }
                audit.IPAddress = Request.UserHostAddress;
                db.Audits.InsertOnSubmit(audit);
                db.SubmitChanges();
            }
            catch (Exception objException)
            {

                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSave_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
            finally
            {
                if (db != null)
                    db.Dispose();
            }
        }
    }

    #endregion


    #region Get Products by selected ARC

    protected void ddlArc_SelectedIndexChanges(object sender, EventArgs e)
    {

        try
        {
            if (ddlArc.SelectedIndex > 0)
            {
                BindProducts(Convert.ToInt32(ddlArc.SelectedValue.ToString()));

            }
            else
            {
                string script = "alertify.alert('" + ltrSelectARC.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                btnSave.Visible = false;
                btnDeleted.Visible = false;
                gvProducts.DataSource = null;
                gvProducts.DataBind();
                return;
            }


            if (gvProducts.Rows.Count > 0)
            {
                btnSave.Visible = true;
                btnDeleted.Visible = true;
            }
            else
            {
                btnSave.Visible = false;
                btnDeleted.Visible = false;
            }
        }
        catch (Exception objException)
        {

            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "ddlArc_SelectedIndexChanges", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
        finally
        {
            if (db != null)
                db.Dispose();
        }


    }

    #endregion

    protected void btnDeleted_Click(object sender, EventArgs e)
    {
        try
        {
            Audit audit = new Audit();
            string notes = null;
            db = new LinqToSqlDataContext();
            foreach (GridViewRow row in gvProducts.Rows)
            {
                if (!String.IsNullOrEmpty((row.FindControl("ProductId") as Label).Text))
                {
                    Int32 productId = Convert.ToInt32((row.FindControl("ProductId") as Label).Text);
                    Boolean isDeleted = (row.FindControl("chkDelete") as CheckBox).Checked;


                    Decimal objtxtPrice = -1;
                    DateTime? objtxtExpiryDate = null;
                    Int32 objlblProuctId = Convert.ToInt32((row.FindControl("ProductId") as Label).Text); // get product id            
                    if ((row.FindControl("txtPrice") as TextBox).Text.Trim() != "")
                        objtxtPrice = Convert.ToDecimal((row.FindControl("txtPrice") as TextBox).Text); // get entered Price 

                    if ((row.FindControl("txtExpiryDate") as TextBox).Text.Trim() != "")
                        objtxtExpiryDate = DateTime.Parse((row.FindControl("txtExpiryDate") as TextBox).Text); // get selected expiry date


                    if (isDeleted == true && objtxtPrice > -1 && objtxtExpiryDate != null)
                    {
                        var productPrice = (from p in db.ARC_Product_Price_Maps where p.ProductId == productId && p.ARCId == Convert.ToInt32(ddlArc.SelectedValue.ToString()) && p.IsDeleted == false select p).Single();
                        productPrice.IsDeleted = true;
                        productPrice.ModifiedOn = DateTime.Now;
                        productPrice.ModifiedBy = Session[enumSessions.User_Id.ToString()].ToString();
                        db.SubmitChanges();

                        string script = "alertify.alert('" + ltrProdPriceDeleted.Text + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    }

                    notes += "Product: " + objlblProuctId + ", Price: " + objtxtPrice + ", Date: " + objtxtExpiryDate + ", ";
                }
            }

            BindProducts(Convert.ToInt32(ddlArc.SelectedValue.ToString())); // bind grid after delete ARC price

            audit.Notes = "Deleted - ARC: " + ddlArc.SelectedItem.ToString() + ", " + notes;
            audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
            audit.ChangeID = Convert.ToInt32(enumAudit.Manage_ARC_Product_Price);
            audit.CreatedOn = DateTime.Now;
            if (Request.ServerVariables["LOGON_USER"] != null)
            {
                audit.WindowsUser = Request.ServerVariables["LOGON_USER"];
            }
            audit.IPAddress = Request.UserHostAddress;
            db.Audits.InsertOnSubmit(audit);
            db.SubmitChanges();
        }
        catch (Exception objException)
        {

            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnDeleted_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
        finally
        {
            if (db != null)
                db.Dispose();
        }


    }

    #region gvProducts Paging

    protected void gvProducts_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            gvProducts.PageIndex = e.NewPageIndex;
            BindProducts(Convert.ToInt32(ddlArc.SelectedValue.ToString()));
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvProducts_PageIndexChanging", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }

    }

    #endregion
}