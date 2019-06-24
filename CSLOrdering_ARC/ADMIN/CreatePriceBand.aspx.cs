using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;

public partial class ADMIN_CreatePriceBand : System.Web.UI.Page
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
                BindPriceBandDropdown();
            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    #endregion

    #region Bind PriceBand DropDown


    /// <summary>
    /// Bind All PriceBand's with dropdown on page load  
    /// 
    /// </summary>
    private void BindPriceBandDropdown()
    {
        txtNewPriceBand.Visible = false;
        ddlPriceBand.Visible = true;
        btnNewPriceBand.Visible = true;
        btnCancelNewPriceBand.Visible = false;
        btnAddNewPriceBand.Visible = false;

        db = new LinqToSqlDataContext();
        var priceBand = (from pbn in db.BandNameMasters
                         orderby pbn.BandName ascending
                         select pbn);

        ddlPriceBand.DataValueField = "ID";
        ddlPriceBand.DataTextField = "BandName";
        ddlPriceBand.DataSource = priceBand;
        ddlPriceBand.DataBind();
        ddlPriceBand.Items.Insert(0, new ListItem("-----------------------------------Select-----------------------------------", "0"));

        var currency = (from c in db.Currencies select c).ToList();
        ddlCurrency.DataValueField = "CurrencyID";
        ddlCurrency.DataTextField = "CurrencyCode";
        ddlCurrency.DataSource = currency;
        ddlCurrency.DataBind();
    }


    #endregion

    #region Bind selected Installer's Products

    /// <summary>
    /// Get product details of selected Installer 
    /// </summary>
    /// <param name="InstallerCompanyId"></param>
    private decimal GetPriceByBandandCurrency(int ProductID, int BandID, int CurrencyID)
    {
        decimal retprice = 0.00M;

        var productprice = (from p in db.Products
                            join pb in db.PriceBands on p.ProductId equals pb.ProductId
                            join c in db.Currencies on pb.CurrencyID equals c.CurrencyID
                            where p.ProductId == ProductID && pb.BandNameId == BandID && c.CurrencyID == CurrencyID
                            select pb.Price
                           ).FirstOrDefault();

        if (productprice != null) { retprice = Convert.ToDecimal(productprice); }
           
        return retprice;
           

    }
    private decimal GetAnnualPriceByBandandCurrency(int ProductID, int BandID, int CurrencyID)
    {
        decimal retprice = 0.00M;

        var productprice = (from p in db.Products
                            join pb in db.PriceBands on p.ProductId equals pb.ProductId
                            join c in db.Currencies on pb.CurrencyID equals c.CurrencyID
                            where p.ProductId == ProductID && pb.BandNameId == BandID && c.CurrencyID == CurrencyID
                            select pb.AnnualPrice
                           ).FirstOrDefault();

        if (productprice != null) { retprice = Convert.ToDecimal(productprice); }

        return retprice;


    }
    private void BindProducts()
    {
        db = new LinqToSqlDataContext();
        trCurrency.Visible = true;

        var ProductData = (from p in db.Products
                           where p.ListedonCSLConnect == true 
                           select new PriceBandList
                           {
                               ProductId = p.ProductId,
                               ProductCode = p.ProductCode,
                               ProductName = p.ProductName,
                               CurrencySymbol = ddlCurrency.SelectedItem.Text,
                               Price = GetPriceByBandandCurrency(p.ProductId,Convert.ToInt32(ddlPriceBand.SelectedValue),Convert.ToInt32(ddlCurrency.SelectedValue)),
                               AnnualPrice = GetAnnualPriceByBandandCurrency(p.ProductId,Convert.ToInt32(ddlPriceBand.SelectedValue),Convert.ToInt32(ddlCurrency.SelectedValue)),
                               ListOrder = p.ListOrder
                           }).ToList();

        if (ProductData != null)
        {
            gvProducts.DataSource = ProductData;
            gvProducts.DataBind();
        }


        if (gvProducts.Rows.Count == 0)
        {
            string script = "alertify.alert('" + ltrNoMap.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
        }
    }


    #endregion

    #region Save

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                Audit audit = new Audit();
                string notes = null;
                if (ddlPriceBand.SelectedIndex > 0)
                {
                    if (gvProducts.Rows.Count > 0)
                    {
                        int retrun = -1;
                        foreach (GridViewRow row in gvProducts.Rows)
                        {
                            Decimal objtxtPrice = -1;
                            Decimal objtxtAnnualPrice = -1;
                            String objCurrencyId = ddlCurrency.SelectedValue;
                            Int32 objProductId = Convert.ToInt32((row.FindControl("ProductId") as Label).Text); // get product id    

                            if ((row.FindControl("txtPrice") as TextBox).Text.Trim() != "")
                                objtxtPrice = Convert.ToDecimal((row.FindControl("txtPrice") as TextBox).Text); // get entered Price    

                            if ((row.FindControl("txtAnnualPrice") as TextBox).Text.Trim() != "")
                                objtxtAnnualPrice = Convert.ToDecimal((row.FindControl("txtAnnualPrice") as TextBox).Text); // get entered Annual Price 

                            db = new LinqToSqlDataContext();
                            var exists = (from p in db.PriceBands
                                          where p.ProductId == objProductId && p.BandNameId == Convert.ToInt32(ddlPriceBand.SelectedValue) && p.CurrencyID == Convert.ToInt32(objCurrencyId)
                                          select p).Count();
                            if (exists > 0)
                            {
                                if (objtxtPrice > -1 && objtxtAnnualPrice > -1 && !String.IsNullOrEmpty(objCurrencyId))
                                {
                                    var prod = (from p in db.PriceBands
                                                join pbn in db.BandNameMasters on p.BandNameId equals pbn.ID
                                                where p.ProductId == objProductId && pbn.BandName == ddlPriceBand.SelectedItem.ToString() && p.CurrencyID == Convert.ToInt32(objCurrencyId)
                                                select p).Single();
                                    var priceBandCount = (from pb in db.PriceBands
                                                          where pb.ProductId == objProductId &&
                                                          pb.Price == objtxtPrice &&
                                                          pb.AnnualPrice == objtxtAnnualPrice &&
                                                          pb.BandNameId == Convert.ToInt32(ddlPriceBand.SelectedValue) &&
                                                          pb.CurrencyID == Convert.ToInt32(objCurrencyId)
                                                          select pb).Count();
                                    if (objtxtPrice != prod.Price || objtxtAnnualPrice != prod.AnnualPrice || priceBandCount == 0)
                                    {
                                        retrun = db.USP_CreatePriceBands(ddlPriceBand.SelectedItem.Text, objProductId, Convert.ToInt32(objCurrencyId), objtxtPrice, objtxtAnnualPrice, Convert.ToString(Session[enumSessions.User_Id.ToString()])); // pass all values to save 
                                    }
                                }
                            }
                            else
                            {
                                retrun = db.USP_CreatePriceBands(ddlPriceBand.SelectedItem.Text, objProductId, Convert.ToInt32(objCurrencyId), objtxtPrice, objtxtAnnualPrice, Convert.ToString(Session[enumSessions.User_Id.ToString()])); // pass all values to save 
                            }
                            notes += "Product: " + objProductId + ", Price: " + objtxtPrice + ", Annual Price: " + objtxtAnnualPrice + ", InstallerId: " + ddlPriceBand.SelectedValue + ", CurrencyId: " + objCurrencyId + ", ";
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

                        BindProducts(); // Bind updated price/date with Gridview 
                    }
                    else
                    {
                        string script = "alertify.alert('" + ltrNoProdMap.Text + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    }
                }

                else
                {
                    string script = "alertify.alert('" + ltrSelectInstaller.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                }
                audit.Notes = "ARC: " + ddlPriceBand.SelectedItem.ToString() + ", " + notes;
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


    #region Get Products by selected Installer

    protected void ddlPriceBand_SelectedIndexChanges(object sender, EventArgs e)
    {

        try
        {
            if (ddlPriceBand.SelectedIndex > 0)
            {
                BindProducts();
            }
            else
            {
                trCurrency.Visible = false;
                string script = "alertify.alert('" + ltrSelectInstaller.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                btnSave.Visible = false;
                gvProducts.DataSource = null;
                gvProducts.DataBind();
                return;
            }


            if (gvProducts.Rows.Count > 0)
            {
                btnSave.Visible = true;
            }
            else
            {
                btnSave.Visible = false;
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

    #region gvProducts Paging

    protected void gvProducts_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            gvProducts.PageIndex = e.NewPageIndex;
            BindProducts();
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvProducts_PageIndexChanging", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }

    }

    #endregion

    protected void btnNewPriceBand_Click(object sender, EventArgs e)
    {
        txtNewPriceBand.Visible = true;
        ddlPriceBand.Visible = false;
        btnNewPriceBand.Visible = false;
        btnCancelNewPriceBand.Visible = true;
        btnAddNewPriceBand.Visible = true;
        trCurrency.Visible = false;
        btnSave.Visible = false;
        gvProducts.DataSource = null;
        gvProducts.DataBind();
        
    }

    protected void btnCancelNewPriceBand_Click(object sender, EventArgs e)
    {
        txtNewPriceBand.Visible = false;
        txtNewPriceBand.Text = String.Empty;
        ddlPriceBand.Visible = true;
        btnNewPriceBand.Visible = true;
        btnCancelNewPriceBand.Visible = false;
        btnAddNewPriceBand.Visible = false;
        btnSave.Visible = true;
        
    }
    protected void btnAddNewPriceBand_Click(object sender, EventArgs e)
    {
        try
        {
            int retrun = -1;
            if (txtNewPriceBand.Text.Length >100)
            {
                string script = "alertify.alert('" + ltrBandNameLength.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                return;
            }
            db = new LinqToSqlDataContext();
            Int32 objCurrencyId = Convert.ToInt32(ddlCurrency.SelectedValue);
            var validate = (from p in db.PriceBands
                            join pbn in db.BandNameMasters on p.BandNameId equals pbn.ID
                            where pbn.BandName == txtNewPriceBand.Text && p.CurrencyID == objCurrencyId
                            select p).Count();
            if (validate == 0)
            {
                db = new LinqToSqlDataContext();
                var prods = (from prod in db.Products
                             where prod.ListedonCSLConnect == true
                             select prod).ToList();
                foreach (var p in prods)
                {
                    retrun = db.USP_CreatePriceBands(txtNewPriceBand.Text.ToUpper(), p.ProductId, objCurrencyId, p.Price, p.AnnualPrice, Convert.ToString(Session[enumSessions.User_Id.ToString()])); // pass all values to save 
                }
                txtNewPriceBand.Visible = false;
                txtNewPriceBand.Text = String.Empty;
                ddlPriceBand.Visible = true;
                btnNewPriceBand.Visible = true;
                btnCancelNewPriceBand.Visible = false;
                btnAddNewPriceBand.Visible = false;
                if (retrun == 0)
                {
                    string script = "alertify.alert('" + ltrBandCreated.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                }
                else
                {
                    string script = "alertify.alert('" + ltrBandNotCreated.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                }
                BindPriceBandDropdown();
            }
            else
            {
                string script = "alertify.alert('" + ltrBandExists.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                return;
            }
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvProducts_PageIndexChanging", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    protected void ddlCurrency_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindProducts();
    }

   
   
}