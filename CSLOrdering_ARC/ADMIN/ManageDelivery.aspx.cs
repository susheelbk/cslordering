using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Linq;
using System.Data.Linq.SqlClient;
using CSLOrderingARCBAL;
using CSLOrderingARCBAL.BAL;
using CSLOrderingARCBAL.Common;
using System.Reflection;
using System.Data.Sql;



public partial class ADMIN_ManageDelivery : System.Web.UI.Page
{
    LinqToSqlDataContext db;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                LoadData();
                Session[enumSessions.DeliveryTypeId.ToString()] = null;
                Session[enumSessions.DeliveryOfferId.ToString()] = null;
                txtdlvnamesrch.Attributes.Add("onkeydown", "return (event.keyCode!=13);");
                txtdlvcodesrch.Attributes.Add("onkeydown", "return (event.keyCode!=13);");
            }
            catch (Exception objException)
            {
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }

        }

    }

    public void LoadData()
    {
        try
        {
            RefreshAllFields();
            divdlvoffer.Visible = false;
            divDlvPrice.Visible = false;
            //binding all deliverycompanies in delivery grid

            db = new LinqToSqlDataContext();
            var dlv = (from dlr in db.DeliveryTypes
                       orderby dlr.DeliveryCompanyName ascending
                       where dlr.IsDeleted == false
                       select dlr);
            gvDelivery.DataSource = dlv;
            gvDelivery.DataBind();

            //binding arc in dropdown

            db = new LinqToSqlDataContext();
            ddarc.DataSource = (from arc in db.ARCs
                                orderby arc.CompanyName ascending
                                where arc.IsDeleted == false
                                select new { arc.ARCId, ARCDisp = "[" + arc.ARC_Code + "] - " + arc.CompanyName });
            ddarc.DataTextField = "ARCDisp";
            ddarc.DataValueField = "ARCId";
            ddarc.DataBind();
            ListItem li = new ListItem();
            li.Text = "--Select--";
            li.Value = "-1";
            ddarc.Items.Insert(0, li);
            ddarc.SelectedIndex = 0;

            //binding products to dropdown

            db = new LinqToSqlDataContext();
            ddpro.DataSource = (from prod in db.Products
                                orderby prod.ProductCode ascending
                                where prod.IsDeleted == false &&
                                prod.IsDependentProduct == false
                                select new { prod.ProductId, ProductDisp = "[" + prod.ProductCode + "] - " + prod.ProductName });
            ddpro.DataTextField = "ProductDisp";
            ddpro.DataValueField = "ProductId";
            ddpro.DataBind();
            ListItem li2 = new ListItem();
            li2.Text = "--Select--";
            li2.Value = "-1";
            ddpro.Items.Insert(0, li2);
            ddpro.SelectedIndex = 0;


            db = new LinqToSqlDataContext();
            var cnt = (from country in db.CountryMasters
                       orderby country.CountryName descending
                       select country);

            DdcountryCode.DataSource = cnt;
            DdcountryCode.DataTextField = "CountryCode";
            DdcountryCode.DataValueField = "CountryCode";
            DdcountryCode.DataBind();

            //// Bind Installers 
            //var installerQry = db.GetInstallersByNameCode(String.Empty, String.Empty, Convert.ToInt32(ddarc.SelectedValue));
            //foreach (var dbInstaller in installerQry)
            //{
            //    ListItem item = new ListItem();
            //    item.Text = dbInstaller.CompanyName + " [ " + dbInstaller.Town + ", " + dbInstaller.PostCode + " ]";
            //    item.Value = dbInstaller.InstallerCompanyID.ToString();
            //    ddlInstallers.Items.Add(item);
            //}
            //ddlInstallers.DataBind();
            //ddlInstallers.Items.Insert(0, new ListItem("Select", "0"));

            var currency = (from c in db.Currencies select c).ToList();
            ddlCurrency.DataValueField = "CurrencyID";
            ddlCurrency.DataTextField = "CurrencyCode";
            ddlCurrency.DataSource = currency;
            ddlCurrency.DataBind();
            ddlCurrency.Items.Insert(0, new ListItem("Select", "0"));
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LoadData", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    public void RefreshAllFields()
    {
        divdlvoffer.Visible = false;
        divDlvPrice.Visible = false;
        txtdlvCode.Text = "";
        txtdlvcodesrch.Text = "";
        txtdlvdesc.Text = "";
        txtdlvName.Text = "";
        txtdlvnamesrch.Text = "";
        Txtprice.Text = "";
        Session[enumSessions.DeliveryTypeId.ToString()] = null;
        Session[enumSessions.DeliveryOfferId.ToString()] = null;
    }

    protected void btnShowAll_Click(object sender, EventArgs e)
    {
        LoadData();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            db = new LinqToSqlDataContext();
            var dlvTypes = (from dlv in db.DeliveryTypes
                            where
                                dlv.IsDeleted == false
                                && dlv.DeliveryCompanyName.Contains(txtdlvnamesrch.Text.Trim())
                                && dlv.DeliveryCode.Contains(txtdlvcodesrch.Text.Trim())
                            select dlv);

            gvDelivery.DataSource = dlvTypes;
            gvDelivery.DataBind();

            if (dlvTypes.Count() == 0)
            {
                string script = "alertify.alert('" + ltrNoMatch.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
            RefreshAllFields();
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSearch_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            if (Page.IsValid)
            {
                string dlvCode = "";
                Audit audit = new Audit();
                if (!string.IsNullOrEmpty(txtdlvName.Text) && !string.IsNullOrEmpty(txtdlvCode.Text) && !string.IsNullOrEmpty(Txtprice.Text))
                {
                    db = new LinqToSqlDataContext();

                    //if updating delivery and delete all the mapped arc's and products of this dlvery.

                    if (Session[enumSessions.DeliveryTypeId.ToString()] != null)
                    {
                        var dlvInfo = (from dlv in db.DeliveryTypes
                                       where dlv.DeliveryTypeId == Convert.ToInt32(Session[enumSessions.DeliveryTypeId.ToString()])
                                       select dlv).SingleOrDefault();

                        dlvCode = txtdlvCode.Text.ToString();
                        var dlvr = db.CreateDelivery(Convert.ToInt32(Session[enumSessions.DeliveryTypeId.ToString()].ToString()),
                            txtdlvCode.Text.ToString(), txtdlvName.Text.ToString(),
                            txtdlvdesc.Text.ToString(), Session[enumSessions.User_Id.ToString()].ToString(),
                            Convert.ToDecimal(Txtprice.Text.ToString()), DdcountryCode.SelectedValue.ToString()).SingleOrDefault();

                        if (dlvr != null)
                        {
                            Session[enumSessions.DeliveryTypeId.ToString()] = dlvr.DeliveryTypeId;
                            string script = "alertify.alert('" + ltrDelUpdated.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        }

                        audit.Notes = "Delivery Type Id: " + Convert.ToInt32(Session[enumSessions.DeliveryTypeId.ToString()].ToString()) + ", Code: " +
                            txtdlvCode.Text.ToString() + ", Name: " + txtdlvName.Text.ToString() + ", Description: " +
                            txtdlvdesc.Text.ToString() + ", Price: " + Convert.ToDecimal(Txtprice.Text.ToString()) + ", Country Code: " + DdcountryCode.SelectedValue.ToString();
                    }
                    else
                    {
                        // create new delivery 

                        var dlvr = db.CreateDelivery(0, txtdlvCode.Text.ToString(), txtdlvName.Text.ToString(), txtdlvdesc.Text.ToString(), Session[enumSessions.User_Id.ToString()].ToString(), Convert.ToDecimal(Txtprice.Text.ToString()), DdcountryCode.SelectedValue.ToString()).SingleOrDefault();
                        if (dlvr != null)
                        {
                            Session[enumSessions.DeliveryTypeId.ToString()] = dlvr.DeliveryTypeId;
                            string script = "alertify.alert('" + ltrDelCreated.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        }

                        audit.Notes = "Delivery Type Id: " + dlvr.DeliveryTypeId.ToString() + ", Code: " +
                            txtdlvCode.Text.ToString() + ", Name: " + txtdlvName.Text.ToString() + ", Description: " +
                            txtdlvdesc.Text.ToString() + ", Price: " + Convert.ToDecimal(Txtprice.Text.ToString()) + ", Country Code: " + DdcountryCode.SelectedValue.ToString();
                    }
                }
                pnlDeliveryDetails.Visible = false;
                pnlDeliverylist.Visible = true;
                LoadData();
                MaintainScrollPositionOnPostBack = false;

                audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
                audit.ChangeID = Convert.ToInt32(enumAudit.Manage_Delivery);
                audit.CreatedOn = DateTime.Now;
                if (Request.ServerVariables["LOGON_USER"] != null)
                {
                    audit.WindowsUser = Request.ServerVariables["LOGON_USER"];
                }
                audit.IPAddress = Request.UserHostAddress;
                db.Audits.InsertOnSubmit(audit);
                db.SubmitChanges();
            }
            else
            {
                string script = "alertify.alert('" + ltrFill.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                MaintainScrollPositionOnPostBack = false;
            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSave_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    protected void LinkButtondelete_click(object sender, System.EventArgs e)
    {
        try
        {

            LinkButton lbdel = sender as LinkButton;
            GridViewRow gvr = (GridViewRow)lbdel.NamingContainer;
            db = new LinqToSqlDataContext();
            Label lbl2 = gvr.FindControl("DeliveryTypeId") as Label;
            Session[enumSessions.DeliveryTypeId.ToString()] = lbl2.Text.ToString();

            //delete deliverycompany
            var dlv = db.DeliveryTypes.Single(deldlv => deldlv.DeliveryTypeId == Convert.ToInt32(Session[enumSessions.DeliveryTypeId.ToString()].ToString()));
            dlv.IsDeleted = true;
            db.SubmitChanges();

            ////delete offers of that deliv
            db = new LinqToSqlDataContext();

            var deloffer = db.DeliveryOffers.Where(item => item.DeliveryTypeId == Convert.ToInt32(Session[enumSessions.DeliveryTypeId.ToString()].ToString()));
            db.DeliveryOffers.DeleteAllOnSubmit(deloffer);
            db.SubmitChanges();
            string script = "alertify.alert('" + ltrDelDeleted.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            LoadData();
        }

        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LinkButtondelete_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    protected void LnkBtnupdateDeliverytype_click(object sender, System.EventArgs e)
    {
        try
        {
            pnlDeliveryDetails.Visible = true;
            pnlDeliverylist.Visible = false;
            litAction.Text = "You choose to <b>EDIT DELIVERY TYPE</b>";
            txtdlvName.Focus();
            ddarc.SelectedValue = "-1";
            ddpro.SelectedValue = "-1";
            Textmax.Text = String.Empty;
            TextMin.Text = String.Empty;
            Textordervalue.Text = String.Empty;
            db = new LinqToSqlDataContext();
            divdlvoffer.Visible = true;
            divDlvPrice.Visible = true;
            LinkButton lbdlv = sender as LinkButton;
            if (lbdlv != null)
            {
                GridViewRow gvr = (GridViewRow)lbdlv.NamingContainer;
                Label lbl1 = gvr.FindControl("DeliveryTypeId") as Label;
                Session[enumSessions.DeliveryTypeId.ToString()] = lbl1.Text.ToString();
            }
            else
            {
                //Reset 
                if (Session[enumSessions.DeliveryTypeId.ToString()] != null)
                { }
                else
                {
                    //Do a cancel as no value in session
                    btnCancel_Click(sender, e);
                }

            }
            db = new LinqToSqlDataContext();
            DeliveryType dlv = db.DeliveryTypes.Where(dl => dl.DeliveryTypeId == Convert.ToInt16(Session[enumSessions.DeliveryTypeId.ToString()])).SingleOrDefault();
            txtdlvCode.Text = dlv.DeliveryCode;
            txtdlvName.Text = dlv.DeliveryCompanyName;
            DdcountryCode.SelectedValue = dlv.CountryCode;
            if (dlv.DeliveryShortDesc == "&nbsp;")
                txtdlvdesc.Text = "";
            else txtdlvdesc.Text = dlv.DeliveryShortDesc;
            Txtprice.Text = dlv.DeliveryPrice.ToString();
            Session[enumSessions.DeliveryOfferId.ToString()] = null;

            var offerdata = db.GetOfferData(Convert.ToInt16(Session[enumSessions.DeliveryTypeId.ToString()].ToString()));
            if (offerdata.Any())
            {
                Gvoffer.Visible = true;
                Gvoffer.DataSource = db.GetOfferData(Convert.ToInt16(Session[enumSessions.DeliveryTypeId.ToString()].ToString()));
                Gvoffer.DataBind();

            }
            else
            {
                Gvoffer.Visible = false;

            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LnkBtnupdateDeliverytype_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    protected void LnkBtnupdateOffer_click(object sender, System.EventArgs e)
    {

        try
        {
            System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-GB", false);
            pnlOfferList.Visible = true;
            pnlOfferDetails.Visible = true;
            LinkButton lbofr = sender as LinkButton;
            if (lbofr != null)
            {
                GridViewRow gvr = (GridViewRow)lbofr.NamingContainer;
                Label dlvofrId = gvr.FindControl("DeliveryOfferId") as Label;
                Session[enumSessions.DeliveryOfferId.ToString()] = dlvofrId.Text.ToString();
            }
            else
            {
                //Reset 
                if (Session[enumSessions.DeliveryOfferId.ToString()] != null)
                { }
                else
                {
                    //Do a cancel as no value in session
                    btnCancelOffer_Click(sender, e);
                }

            }
            db = new LinqToSqlDataContext();
            DeliveryOffer dlvOffer = db.DeliveryOffers.Where(offer => offer.DeliveryOfferId == Convert.ToInt16(Session[enumSessions.DeliveryOfferId.ToString()])).SingleOrDefault();
            ddarc.SelectedValue = dlvOffer.ARCId.ToString();
            ddpro.SelectedValue = dlvOffer.ProductId.ToString();
            Textmax.Text = dlvOffer.MaxQty.ToString();
            TextMin.Text = dlvOffer.MinQty.ToString();
            Textordervalue.Text = dlvOffer.OrderValue.ToString();
            USP_GetInstallerNameByInstallerIdResult installerName = db.USP_GetInstallerNameByInstallerId(dlvOffer.InstallerCompanyID.Value.ToString()).SingleOrDefault();
            ListItem installers = new ListItem(installerName.CompanyName.ToString(), dlvOffer.InstallerCompanyID.Value.ToString());
            ddlInstallers.Items.Clear();
            ddlInstallers.Items.Add(installers);
            ddlInstallers.SelectedValue = installerName.CompanyName.ToString();
            txtExpiryDate.Text = dlvOffer.ExpiryDate.Value.ToShortDateString();
        }
        catch (Exception objException)
        {
            string script = "alertify.alert('" + objException.Message + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LnkBtnupdateOffer_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }
    }

    protected void LnkBtndeleteoffer_click(object sender, System.EventArgs e)
    {
        try
        {

            LinkButton lbdel = sender as LinkButton;
            GridViewRow gvr = (GridViewRow)lbdel.NamingContainer;
            db = new LinqToSqlDataContext();
            Label lbl2 = gvr.FindControl("DeliveryOfferId") as Label;
            Session[enumSessions.DeliveryOfferId.ToString()] = lbl2.Text.ToString();
            if (Session[enumSessions.DeliveryOfferId.ToString()] != null)
            {
                //delete all sibblings on this offer
                var sibb = db.Delivery_Product_Sibblings.Where(sib => sib.DeliveryOfferId == Convert.ToInt16(Session[enumSessions.DeliveryOfferId.ToString()]));
                db.Delivery_Product_Sibblings.DeleteAllOnSubmit(sibb);

                //delete Offer
                var offer = db.DeliveryOffers.Single(delofr => delofr.DeliveryOfferId == Convert.ToInt16(Session[enumSessions.DeliveryOfferId.ToString()]));
                db.DeliveryOffers.DeleteOnSubmit(offer);
                db.SubmitChanges();

                var offerdata = db.GetOfferData(Convert.ToInt16(Session[enumSessions.DeliveryTypeId.ToString()].ToString()));
                if (offerdata.Any())
                {
                    Gvoffer.Visible = true;
                    Gvoffer.DataSource = db.GetOfferData(Convert.ToInt16(Session[enumSessions.DeliveryTypeId.ToString()].ToString()));
                    Gvoffer.DataBind();

                }

                string script = "alertify.alert('" + ltrOfferDeleted.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }

        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LinkButtondelete2_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }


    }

    protected void lbDeleteSibb_click(object sender, System.EventArgs e)
    {
        try
        {

            LinkButton lbdel = sender as LinkButton;
            GridViewRow gvr = (GridViewRow)lbdel.NamingContainer;
            db = new LinqToSqlDataContext();
            GridView gvsibbling = gvr.Parent.Parent as GridView;
            int deliveryProdSibblingId = int.Parse(gvsibbling.DataKeys[gvr.RowIndex].Value.ToString());

            //delete single Sibbling
            var sibbling = db.Delivery_Product_Sibblings.Single(delsibb => delsibb.Delivery_Prod_SibblingId == deliveryProdSibblingId);
            if (sibbling != null)
            {
                db.Delivery_Product_Sibblings.DeleteOnSubmit(sibbling);
                db.SubmitChanges();
            }

            var offerdata = db.GetOfferData(Convert.ToInt16(Session[enumSessions.DeliveryTypeId.ToString()].ToString()));
            if (offerdata.Any(x => x != null))
            {
                Gvoffer.Visible = true;
                Gvoffer.DataSource = db.GetOfferData(Convert.ToInt16(Session[enumSessions.DeliveryTypeId.ToString()].ToString()));
                Gvoffer.DataBind();

            }
            string script = "alertify.alert('" + ltrSibbDeleted.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);

        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "lbDeleteSibb_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }


    }

    protected void SaveOfferbtn_Click(object sender, EventArgs e)
    {
        try
        {
            Audit audit = new Audit();
            System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-GB", false);
            if (Page.IsValid)
            {
                db = new LinqToSqlDataContext();

                //if updating offer

                if (string.IsNullOrEmpty(Textordervalue.Text))
                    Textordervalue.Text = "0";
                if (string.IsNullOrEmpty(Textmax.Text))
                    Textmax.Text = "0";
                if (string.IsNullOrEmpty(TextMin.Text))
                    TextMin.Text = "0";

                Guid? installersGUID = null;
                if (ddlInstallers.SelectedValue.ToString() != "")
                {
                    installersGUID = new Guid(ddlInstallers.SelectedValue);
                }

                if (Session[enumSessions.DeliveryOfferId.ToString()] != null)
                {

                    var dofr = db.CreateDlvOffer(Convert.ToInt32(Session[enumSessions.DeliveryOfferId.ToString()].ToString()), Convert.ToInt32(Session[enumSessions.DeliveryTypeId.ToString()].ToString()), Convert.ToDecimal(Textordervalue.Text.ToString()), Convert.ToInt32(ddarc.SelectedValue.ToString()), Convert.ToInt32(ddpro.SelectedValue.ToString()), Session[enumSessions.User_Id.ToString()].ToString(), Convert.ToInt16(TextMin.Text.ToString()), Convert.ToInt16(Textmax.Text.ToString()), installersGUID, Convert.ToDateTime(txtExpiryDate.Text)).SingleOrDefault();
                    if (dofr != null)
                    {
                        Session[enumSessions.DeliveryOfferId.ToString()] = dofr.DeliveryOfferId;
                        string script = "alertify.alert('" + ltrOfferUpdated.Text + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        audit.Notes = "DeliveryOfferId: " +Session[enumSessions.DeliveryOfferId.ToString()].ToString() + ", DeliveryTypeId: " +
                            Session[enumSessions.DeliveryTypeId.ToString()].ToString() + ", Order Value: " + Textordervalue.Text.ToString() + ", ARC: " +
                            ddarc.SelectedValue.ToString() + ", Product: " +ddpro.SelectedValue.ToString() + ", Min Qty: " +
                            TextMin.Text.ToString() + ", Max Qty: " + Textmax.Text.ToString() + ", Installer: " +
                            installersGUID + ", Expiry Date: " + txtExpiryDate.Text;
                    }
                }
                else
                {
                    // create new offer 

                    if (ddarc.SelectedValue == "-1" && ddpro.SelectedValue != "-1")
                    {
                        string prodid = ddpro.SelectedValue.ToString();

                        if (Textmax.Text != "0" && Textmax.Text != "0")
                        {
                            if (Convert.ToInt16(Textmax.Text) >= Convert.ToInt16(TextMin.Text))
                            {

                                var dofr = db.CreateDlvOffer(0, Convert.ToInt32(Session[enumSessions.DeliveryTypeId.ToString()].ToString()), Convert.ToDecimal(Textordervalue.Text.ToString()), -1, Convert.ToInt32(ddpro.SelectedValue.ToString()), Session[enumSessions.User_Id.ToString()].ToString(), Convert.ToInt16(TextMin.Text.ToString()), Convert.ToInt16(Textmax.Text.ToString()), installersGUID, Convert.ToDateTime(txtExpiryDate.Text)).SingleOrDefault();
                                if (dofr != null)
                                {
                                    Session[enumSessions.DeliveryOfferId.ToString()] = dofr.DeliveryOfferId;
                                    audit.Notes = "DeliveryOfferId: " + dofr.DeliveryOfferId.ToString() + ", DeliveryTypeId: " +
                           Session[enumSessions.DeliveryTypeId.ToString()].ToString() + ", Order Value: " + Textordervalue.Text.ToString() + ", ARC: " +
                            ddarc.SelectedValue.ToString() + ", Product: " +ddpro.SelectedValue.ToString() + ", Min Qty: " +
                           TextMin.Text.ToString() + ", Max Qty: " +Textmax.Text.ToString() + ", Installer: " +
                            installersGUID + ", Expiry Date: " + txtExpiryDate.Text;
                                }

                            }
                            else
                            {
                                string script = "alertify.alert('" + ltrMaxGreater.Text + "');";
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                return;
                            }
                        }
                        else
                        {
                            string script = "alertify.alert('" + ltrEnterMaxMin.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            return;
                        }

                        if (Session[enumSessions.DeliveryOfferId.ToString()] != null)
                        {
                            string script = "alertify.alert('" + ltrOfferCreated.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            pnlOfferDetails.Visible = false;
                            pnlOfferList.Visible = true;
                        }


                    }
                    else if (ddarc.SelectedValue != "-1" && ddpro.SelectedValue == "-1")
                    {
                        string arcid = ddarc.SelectedValue.ToString();
                        var dofr = db.CreateDlvOffer(0, Convert.ToInt32(Session[enumSessions.DeliveryTypeId.ToString()].ToString()), Convert.ToDecimal(Textordervalue.Text.ToString()), Convert.ToInt32(ddarc.SelectedValue.ToString()), -1, Session[enumSessions.User_Id.ToString()].ToString(), Convert.ToInt16(TextMin.Text.ToString()), Convert.ToInt16(Textmax.Text.ToString()), installersGUID, Convert.ToDateTime(txtExpiryDate.Text)).SingleOrDefault();
                        if (dofr != null)
                        {
                            Session[enumSessions.DeliveryOfferId.ToString()] = dofr.DeliveryOfferId;

                            audit.Notes = "DeliveryOfferId: " + dofr.DeliveryOfferId.ToString() + ", DeliveryTypeId: " +
                    Convert.ToInt32(Session[enumSessions.DeliveryTypeId.ToString()].ToString()) + ", Order Value: " + Convert.ToDecimal(Textordervalue.Text.ToString()) + ", ARC: " +
                    Convert.ToInt32(ddarc.SelectedValue.ToString()) + ", Product: " + Convert.ToInt32(ddpro.SelectedValue.ToString()) + ", Min Qty: " +
                    Convert.ToInt16(TextMin.Text.ToString()) + ", Max Qty: " + Convert.ToInt16(Textmax.Text.ToString()) + ", Installer: " +
                    installersGUID + ", Expiry Date: " + Convert.ToDateTime(txtExpiryDate.Text);
                        }

                    }

                    else if (ddarc.SelectedValue == "-1" && ddpro.SelectedValue == "-1")
                    {
                        if (Textordervalue.Text != "0")
                        {
                            var dofr = db.CreateDlvOffer(0, Convert.ToInt32(Session[enumSessions.DeliveryTypeId.ToString()].ToString()), Convert.ToDecimal(Textordervalue.Text.ToString()), -1, -1, Session[enumSessions.User_Id.ToString()].ToString(), 0, 0, installersGUID, Convert.ToDateTime(txtExpiryDate.Text)).SingleOrDefault();
                            if (dofr != null)
                            {
                                Session[enumSessions.DeliveryOfferId.ToString()] = dofr.DeliveryOfferId;
                                audit.Notes = "DeliveryOfferId: " + dofr.DeliveryOfferId.ToString() + ", DeliveryTypeId: " +
                        Convert.ToInt32(Session[enumSessions.DeliveryTypeId.ToString()].ToString()) + ", Order Value: " + Convert.ToDecimal(Textordervalue.Text.ToString()) + ", ARC: " +
                        Convert.ToInt32(ddarc.SelectedValue.ToString()) + ", Product: " + Convert.ToInt32(ddpro.SelectedValue.ToString()) + ", Min Qty: " +
                        Convert.ToInt16(TextMin.Text.ToString()) + ", Max Qty: " + Convert.ToInt16(Textmax.Text.ToString()) + ", Installer: " +
                        installersGUID + ", Expiry Date: " + Convert.ToDateTime(txtExpiryDate.Text);
                            }
                        }
                        else
                        {
                            string script = "alertify.alert('" + ltrOrderVal.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            return;
                        }

                    }

                    else if (ddarc.SelectedValue != "-1" && ddpro.SelectedValue != "-1")
                    {
                        if (Textmax.Text != "0" && Textmax.Text != "0")
                        {
                            if (Convert.ToInt16(Textmax.Text) >= Convert.ToInt16(TextMin.Text))
                            {
                                var dofr = db.CreateDlvOffer(0, Convert.ToInt32(Session[enumSessions.DeliveryTypeId.ToString()].ToString()), Convert.ToDecimal(Textordervalue.Text.ToString()), Convert.ToInt32(ddarc.SelectedValue.ToString()), Convert.ToInt32(ddpro.SelectedValue.ToString()), Session[enumSessions.User_Id.ToString()].ToString(), Convert.ToInt16(TextMin.Text.ToString()), Convert.ToInt16(Textmax.Text.ToString()), installersGUID, Convert.ToDateTime(txtExpiryDate.Text)).SingleOrDefault();
                                if (dofr != null)
                                {
                                    Session[enumSessions.DeliveryOfferId.ToString()] = dofr.DeliveryOfferId;

                                    audit.Notes = "DeliveryOfferId: " + dofr.DeliveryOfferId.ToString() + ", DeliveryTypeId: " +
                            Convert.ToInt32(Session[enumSessions.DeliveryTypeId.ToString()].ToString()) + ", Order Value: " + Convert.ToDecimal(Textordervalue.Text.ToString()) + ", ARC: " +
                            Convert.ToInt32(ddarc.SelectedValue.ToString()) + ", Product: " + Convert.ToInt32(ddpro.SelectedValue.ToString()) + ", Min Qty: " +
                            Convert.ToInt16(TextMin.Text.ToString()) + ", Max Qty: " + Convert.ToInt16(Textmax.Text.ToString()) + ", Installer: " +
                            installersGUID + ", Expiry Date: " + Convert.ToDateTime(txtExpiryDate.Text);
                                }
                            }
                            else
                            {
                                string script = "alertify.alert('" + ltrMaxGreater.Text + "');";
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                return;
                            }
                        }
                        else
                        {
                            string script = "alertify.alert('" + ltrEnterMaxMin.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            return;
                        }


                    }

                    if (Session[enumSessions.DeliveryOfferId.ToString()] != null)
                    {
                        string script = "alertify.alert('" + ltrOfferCreated.Text + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        pnlOfferList.Visible = true;
                        pnlOfferDetails.Visible = false;
                    }


                }
                var offerdata = db.GetOfferData(Convert.ToInt16(Session[enumSessions.DeliveryTypeId.ToString()].ToString()));
                if (offerdata.Any())
                {
                    Gvoffer.Visible = true;
                    Gvoffer.DataSource = db.GetOfferData(Convert.ToInt16(Session[enumSessions.DeliveryTypeId.ToString()].ToString()));
                    Gvoffer.DataBind();

                }
                pnlOfferList.Visible = true;
                pnlOfferDetails.Visible = false;

                audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
                audit.ChangeID = Convert.ToInt32(enumAudit.Manage_Delivery);
                audit.CreatedOn = DateTime.Now;
                if (Request.ServerVariables["LOGON_USER"] != null)
                {
                    audit.WindowsUser = Request.ServerVariables["LOGON_USER"];
                }
                audit.IPAddress = Request.UserHostAddress;
                db.Audits.InsertOnSubmit(audit);
                db.SubmitChanges();
            }

        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "SaveOfferbtn_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    protected void ddarc_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {

            if (ddarc.SelectedValue != "-1")
            {
                string arcid = ddarc.SelectedValue.ToString();
                db = new LinqToSqlDataContext();
                ddpro.Items.Clear();
                ddpro.DataSource = from prarcmap in db.Product_ARC_Maps
                                   join pr in db.Products
                                   on prarcmap.ProductId equals pr.ProductId
                                   where prarcmap.ARCId == Convert.ToInt32(arcid)
                                   select new { pr.ProductId, ProductDisp = "[" + pr.ProductCode + "] - " + pr.ProductName };
                ddpro.DataTextField = "ProductDisp";
                ddpro.DataValueField = "ProductId";
                ddpro.DataBind();
                ListItem li2 = new ListItem();
                li2.Text = "--Select--";
                li2.Value = "-1";
                ddpro.Items.Insert(0, li2);
                ddpro.SelectedValue = "-1";


            }
            else
            {
                db = new LinqToSqlDataContext();
                ddpro.DataSource = (from prod in db.Products
                                    where prod.IsDeleted == false &&
                                    prod.IsDependentProduct == false
                                    select new { prod.ProductId, ProductDisp = "[" + prod.ProductCode + "] - " + prod.ProductName });
                ddpro.DataTextField = "ProductDisp";
                ddpro.DataValueField = "ProductId";
                ddpro.DataBind();
                ListItem li2 = new ListItem();
                li2.Text = "--Select--";
                li2.Value = "-1";
                ddpro.Items.Insert(0, li2);
                ddpro.SelectedIndex = 0;
            }


        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "ddarc_SelectedIndexChanged", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    protected void OfferSiblingPopup(object sender, EventArgs e)
    {
        try
        {
            Session[enumSessions.DeliveryOfferId.ToString()] = ((LinkButton)sender).CommandArgument;
            db = new LinqToSqlDataContext();

            //bind all the products in the checkboxlist
            var prds = from pr in db.Products
                       where pr.IsDeleted == false && pr.IsDependentProduct == false
                       select new { pr.ProductId, ProductDisp = "[" + pr.ProductCode + "] - " + pr.ProductName };
            Chklistproducts.DataValueField = "ProductID";
            Chklistproducts.DataTextField = "ProductDisp";
            Chklistproducts.DataSource = prds;
            Chklistproducts.DataBind();
            foreach (ListItem itemchk in Chklistproducts.Items)
            {
                itemchk.Selected = false;
            }

            PopupControlExtender2.Show();
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "OfferSiblingPopup", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    protected void btnSaveSibblings_Click(object sender, EventArgs e)
    {
        try
        {
            db = new LinqToSqlDataContext();

            //enter all the new mappings
            var dlvofferprodid = (from dlv in db.DeliveryOffers
                                  where dlv.DeliveryOfferId == Convert.ToInt32(Session[enumSessions.DeliveryOfferId.ToString()])
                                  select new { dlv.ProductId }).Single();
            var Checkedprod = (from ListItem item in Chklistproducts.Items where item.Selected select int.Parse(item.Value)).ToList();
            if (Checkedprod.Any())
            {
                db = new LinqToSqlDataContext();
                Delivery_Product_Sibbling dps;
                foreach (int chkp in Checkedprod)
                {
                    dps = new Delivery_Product_Sibbling();
                    dps.DeliveryOfferId = Convert.ToInt32(Session[enumSessions.DeliveryOfferId.ToString()]);
                    dps.Sibbling_ProductId = Convert.ToInt32(chkp);
                    dps.DeliveryOfferProductId = dlvofferprodid.ProductId;
                    dps.CreatedBy = Session[enumSessions.User_Id.ToString()].ToString();
                    dps.CreatedOn = DateTime.Now;
                    dps.ModifiedBy = Session[enumSessions.User_Id.ToString()].ToString();
                    dps.ModifiedOn = DateTime.Now;
                    db.Delivery_Product_Sibblings.InsertOnSubmit(dps);
                    db.SubmitChanges();


                }
                var offerdata = db.GetOfferData(Convert.ToInt16(Session[enumSessions.DeliveryTypeId.ToString()].ToString()));
                if (offerdata.Any())
                {
                    Gvoffer.Visible = true;
                    Gvoffer.DataSource = db.GetOfferData(Convert.ToInt16(Session[enumSessions.DeliveryTypeId.ToString()].ToString()));
                    Gvoffer.DataBind();

                }
            }

        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSaveSibblings_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    #region gvDelivery Paging

    protected void gvDelivery_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            gvDelivery.PageIndex = e.NewPageIndex;
            LoadData();
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvDelivery_PageIndexChanging", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }

    }

    #endregion

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Session[enumSessions.DeliveryTypeId.ToString()] = null;
        pnlDeliverylist.Visible = true;
        pnlOfferDetails.Visible = false;
        pnlDeliveryDetails.Visible = false;
        divdlvoffer.Visible = false;
        divDlvPrice.Visible = false;
    }

    protected void btnCancelOffer_Click(object sender, EventArgs e)
    {
        Session[enumSessions.DeliveryOfferId.ToString()] = null;
        pnlOfferDetails.Visible = false;
        pnlOfferList.Visible = true;
    }

    protected void btnResetOffer_Click(object sender, EventArgs e)
    {
        if (Session[enumSessions.DeliveryOfferId.ToString()] != null)
        {
            LnkBtnupdateOffer_click(sender, e);
        }
        else
        {
            LnkBtnupdateOffer_click(sender, e);
        }

    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        if (Session[enumSessions.DeliveryTypeId.ToString()] != null)
        {
            LnkBtnupdateDeliverytype_click(sender, e);
        }
        else
        {
            btnNewDeliveryType_Click(sender, e);
        }

    }

    protected void btnNewDeliveryType_Click(object sender, EventArgs e)
    {
        pnlDeliveryDetails.Visible = true;
        pnlDeliverylist.Visible = false;
        litAction.Text = "You choose to <b>ADD NEW DELIVERY TYPE</b>";
        txtdlvName.Focus();
        LoadData();
    }

    protected void Gvoffer_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            GridView innergrid = e.Row.FindControl("gvSibblings") as GridView;
            int deliveryOfferId = int.Parse(Gvoffer.DataKeys[e.Row.RowIndex].Value.ToString());
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            var sibblingsOnOffer = (from sib in db.Delivery_Product_Sibblings
                                    join prodsib in db.Products on sib.Sibbling_ProductId equals prodsib.ProductId
                                    join prodlvofferprod in db.Products on sib.DeliveryOfferProductId equals prodlvofferprod.ProductId
                                    where sib.DeliveryOfferId == deliveryOfferId
                                    select new { sib.Delivery_Prod_SibblingId, sib.Sibbling_ProductId, sib.DeliveryOfferProductId, ProductCodeSib = prodsib.ProductCode, ProductCodeDlvOfferProd = prodlvofferprod.ProductCode });
            if (sibblingsOnOffer.Any(x => x != null))
            {
                innergrid.DataSource = sibblingsOnOffer;
                innergrid.DataBind();
            }

        }
    }

    protected void btnNewOffer_Click(object sender, EventArgs e)
    {
        Session[enumSessions.DeliveryOfferId.ToString()] = null;
        pnlOfferList.Visible = true;
        pnlOfferDetails.Visible = true;
        ddarc.SelectedValue = "-1";
        ddpro.SelectedValue = "-1";
        Textmax.Text = string.Empty;
        TextMin.Text = string.Empty;
        Textordervalue.Text = string.Empty;
        txtExpiryDate.Text = String.Empty;
        txtSearchInstaller.Text = String.Empty;
        ddlInstallers.Items.Clear();
        ddlInstallers.DataBind();
    }

    //Load Installers from DB
    protected void SelectHeadOffice_Click(object sender, EventArgs e)
    {
        //Clear current items
        ddlInstallers.Items.Clear();
        ddlInstallers.DataBind();

        string installerName = txtSearchInstaller.Text.Trim().ToLower();

        LinqToSqlDataContext dataCtxt = new LinqToSqlDataContext();
        try
        {
            var installerQry = dataCtxt.GetInstallersByNameCode(installerName, installerName, Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()]));
            foreach (var dbInstaller in installerQry)
            {
                ListItem item = new ListItem();
                item.Text = dbInstaller.CompanyName + " [ " + dbInstaller.Town + ", " + dbInstaller.PostCode + " ]";
                item.Value = dbInstaller.InstallerCompanyID.ToString();
                ddlInstallers.Items.Add(item);
            }
            ddlInstallers.DataBind();



        }
        catch (Exception exp)
        {
            ListItem item = new ListItem();
            item.Text = "Error Loading.. ";
            ddlInstallers.Items.Add(item);
            ddlInstallers.DataBind();

            ////Record on to DB
            //CSLLog.RecordException(exp.Message, exp.StackTrace, "", "", "", enumPriority.HIGH.ToString(), "", SiteUtility.GetIPAddress());
        }

    }

    protected void Clear_Click(object sender, EventArgs e)
    {
        //Clear current items

        txtSearchInstaller.Text = String.Empty;
        ddlInstallers.Items.Clear();
        ddlInstallers.DataBind();
    }

    protected void btnSaveDlvPrice_Click(object sender, EventArgs e)
    {
        if (ddlCurrency.SelectedIndex != 0 && !string.IsNullOrEmpty(txtDlvPrice.Text))
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            var exists = (from dps in db.DeliveryPrices
                          where dps.CurrencyId == ddlCurrency.SelectedIndex && dps.DeliveryTypeId == Convert.ToInt32(Session[enumSessions.DeliveryTypeId.ToString()].ToString())
                          select dps).Count();
            if (exists == 0)
            {
                DeliveryPrice dp = new DeliveryPrice();
                dp.DeliveryTypeId = Convert.ToInt16(Session[enumSessions.DeliveryTypeId.ToString()].ToString());
                dp.CurrencyId = ddlCurrency.SelectedIndex;
                dp.DeliveryPrice1 = Convert.ToDecimal(txtDlvPrice.Text);
                db.DeliveryPrices.InsertOnSubmit(dp);
                db.SubmitChanges();
                
                gvDlvPrices.DataBind();
                ddlCurrency.SelectedIndex = 0;
                
                Audit audit = new Audit();
                audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
                audit.ChangeID = Convert.ToInt32(enumAudit.Manage_Delivery);
                audit.CreatedOn = DateTime.Now;
                if (Request.ServerVariables["LOGON_USER"] != null)
                {
                    audit.WindowsUser = Request.ServerVariables["LOGON_USER"];
                }
                audit.IPAddress = Request.UserHostAddress;
                audit.Notes = "DeliveryTypeID : "+Session[enumSessions.DeliveryTypeId.ToString()].ToString() + ", CurrencyID : " + ddlCurrency.SelectedIndex + ", DeliveryPrice : " + txtDlvPrice.Text;
                db.Audits.InsertOnSubmit(audit);
                db.SubmitChanges();
                db.Dispose();
                txtDlvPrice.Text = "";
            }
            else
            {
                string script = "alertify.alert('" + ltrRecordExists.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
        }
    }
}