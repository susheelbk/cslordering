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
using System.Text;

public partial class ADMIN_ManageARC : System.Web.UI.Page
{
    LinqToSqlDataContext db;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                BindArcGrid();
                LoadData();
                Session[enumSessions.ARC_Id.ToString()] = null;
            }
            catch (Exception objException)
            {
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
    }

    protected void btnShowAll_Click(object sender, EventArgs e)
    {
        try
        {
            txtuniquecodesrch.Text = "";
            txtarccodesrch.Text = "";
            txtarcnamesrch.Text = "";
            BindArcGrid();
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnShowAll_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            db = new LinqToSqlDataContext();
            var arc = (from arcs in db.ARCs
                       where arcs.CompanyName.Contains(txtarcnamesrch.Text.Trim())
                        && arcs.ARC_Code.Contains(txtarccodesrch.Text.Trim())
                        && arcs.UNiqueCode.Contains(txtuniquecodesrch.Text.Trim())
                       select arcs);
            gvARC.DataSource = arc;
            gvARC.DataBind();

            Session[enumSessions.ARC_Id.ToString()] = null;

            if (arc.Count() == 0)
            {
                BindArcGrid();
                string script = "alertify.alert('" + ltrNoMatch.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
            MaintainScrollPositionOnPostBack = false;
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSearch_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }


    protected void BindArcGrid()
    {
        //binding all ARCs in ARC grid
        db = new LinqToSqlDataContext();
        var arc = (from arcs in db.ARCs
                   where arcs.CompanyName.Contains(txtarcnamesrch.Text.Trim())
                    && arcs.ARC_Code.Contains(txtarccodesrch.Text.Trim())
                    && arcs.UNiqueCode.Contains(txtuniquecodesrch.Text.Trim())
                   orderby arcs.CompanyName ascending
                   select arcs);
        gvARC.DataSource = arc;
        gvARC.DataBind();
    }

    // public String strArcCode = String.Empty;
    public void LoadData()
    {
        try
        {
            ChkAllowReturns.Checked = false;
            Chkannualbilling.Checked = false;
            Chkisbulkallow.Checked = false;
            Chkpostingopt.Checked = false;
            Chkisapi.Checked = false;
            chkPolltoEIRE.Checked = false;
            chkExcludeTerms.Checked = false;
            chkIsAllowedCSD.Checked = false;
            chkEnablePostCodeSearch.Checked = false;
            txtUniqCode.Text = String.Empty;
            Textcounty.Text = String.Empty;
            Textemail.Text = String.Empty;
            Textfax.Text = String.Empty;
            Textadd1.Text = String.Empty;
            Textadd2.Text = String.Empty;
            Textpostcode.Text = String.Empty;
            Textprimcontact.Text = String.Empty;
            Texttelphn.Text = String.Empty;
            Texttown.Text = String.Empty;
            txtarcCode.Text = String.Empty;
            txtarcName.Text = String.Empty;
            Textbillaccno.Text = String.Empty;
            Textsalesno.Text = String.Empty;
            txtARCEmailCC.Text = String.Empty;
            txtReplenishmentLimit.Text = "0";
            txt_SFObjectID.Text = String.Empty;
            txtEmizonARCNo.Text = string.Empty;
            txtEmizonPlatform.Text = string.Empty;
            txtInstallIDLength.Text = string.Empty;
            txtInstallIDStrategy.Text = string.Empty;
            chkInstallID_Flag.Checked = false;
            chkSafelinkOnIPSEC.Checked = false;
            chkisListedinRouterMonitor.Checked = false;

            Session[enumSessions.ARC_Id.ToString()] = null;

            db = new LinqToSqlDataContext();
            var cnt = (from country in db.CountryMasters
                       orderby country.CountryName descending
                       select country);
            Ddcountry.DataSource = cnt;
            Ddcountry.DataTextField = "CountryName";
            Ddcountry.DataValueField = "CountryName";
            Ddcountry.DataBind();

            DdcountryCode.DataSource = cnt;
            DdcountryCode.DataTextField = "CountryCode";
            DdcountryCode.DataValueField = "CountryCode";
            DdcountryCode.DataBind();

            // binding all categories with checkboxes

            db = new LinqToSqlDataContext();
            var ctgs = (from ctg in db.Categories
                        where ctg.IsDeleted == false
                        orderby ctg.ListOrder
                        select new { ctg.CategoryId, CategoryDisp = ctg.CategoryName + " [" + ctg.CategoryCode + "]" });

            CheckBoxCtg.DataValueField = "CategoryId";
            CheckBoxCtg.DataTextField = "CategoryDisp";
            CheckBoxCtg.DataSource = ctgs;
            CheckBoxCtg.DataBind();
            CheckBoxCtg.Items.Insert(0, "Select All");
            for (int i = 0; i <= CheckBoxCtg.Items.Count - 1; i++)
            {
                CheckBoxCtg.Items[i].Selected = false;
            }


            //binding Options in radiobuttonlist
            var opt = (from option in db.Options
                       orderby option.OptionName ascending
                       select option);
            rdbtnloptions.DataSource = opt;
            rdbtnloptions.DataTextField = "OptionName";
            rdbtnloptions.DataValueField = "OptID";
            rdbtnloptions.DataBind();
            rdbtnloptions.SelectedValue = "1";

            //binding gvctg in panel products
            db = new LinqToSqlDataContext();
            var ctgdata = (from ctg in db.Categories
                           where ctg.IsDeleted == false
                           orderby ctg.ListOrder
                           select new { ctg.CategoryId, CategoryDisp = ctg.CategoryName + " [" + ctg.CategoryCode + "]" });
            gvctg.DataSource = ctgdata;
            gvctg.DataBind();

            //if (String.IsNullOrEmpty(ddlArcTypes.SelectedValue))
            //{
            // Bind Arc Types
            ddlArcTypes.DataSource = (from at in db.ArcTypes
                                      where at.IsDeleted == false
                                      select at
                                         );
            ddlArcTypes.DataTextField = "Types";
            ddlArcTypes.DataValueField = "ARCTypeID";
            ddlArcTypes.DataBind();
            ddlArcTypes.Items.Insert(0, new ListItem("Select", "0"));
            //}

        }
        catch (Exception objException)
        {

            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LoadData", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }


    protected void LinkButtonupdate_click(object sender, System.EventArgs e)
    {
        try
        {
            pnlArcDetail.Visible = true;
            pnlARClist.Visible = false;
            ChkAllowReturns.Checked = false;
            Chkannualbilling.Checked = false;
            Chkisbulkallow.Checked = false;
            Chkpostingopt.Checked = false;
            Chkisapi.Checked = false;
            litAction.Text = "You choose to <b>EDIT ARC</b>";
            txtarcName.Focus();
            LinkButton lbarc = sender as LinkButton;
            if (lbarc != null)
            {
                GridViewRow gvr = (GridViewRow)lbarc.NamingContainer;
                Label lbl2 = gvr.Cells[3].FindControl("ARCId") as Label;
                Session[enumSessions.ARC_Id.ToString()] = lbl2.Text;
                txtARCID.Text = lbl2.Text;
            }
            else
            {
                //Reset 
                if (Session[enumSessions.ARC_Id.ToString()] != null)
                { }
                else
                {
                    //Do a cancel as no value in session
                    btnCancel_Click(sender, e);
                }

            }
            db = new LinqToSqlDataContext();
            var arc = (from arcs in db.ARCs
                       where arcs.ARCId == Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()])
                       select arcs).FirstOrDefault();

            lblUniqCode.Text = arc.UNiqueCode;
            txtarcName.Text = string.IsNullOrEmpty(arc.CompanyName) ? "" : arc.CompanyName;
            txtarcCode.Text = string.IsNullOrEmpty(arc.ARC_Code) ? "" : arc.ARC_Code;
            Textemail.Text = string.IsNullOrEmpty(arc.ARC_Email) ? "" : arc.ARC_Email;
            Textprimcontact.Text = string.IsNullOrEmpty(arc.PrimaryContact) ? "" : arc.PrimaryContact;
            Textbillaccno.Text = string.IsNullOrEmpty(arc.BillingAccountNo) ? "" : arc.BillingAccountNo;
            ChkAllowReturns.Checked = arc.AllowReturns;
            Chkisbulkallow.Checked = arc.IsBulkUploadAllowed;
            Chkannualbilling.Checked = arc.AnnualBilling;
            Chkpostingopt.Checked = arc.PostingOption;
            Chkisapi.Checked = Convert.ToBoolean(arc.IsAPIAccess);
            Texttelphn.Text = string.IsNullOrEmpty(arc.Telephone) ? "" : arc.Telephone;
            Textfax.Text = string.IsNullOrEmpty(arc.Fax) ? "" : arc.Fax;
            Textadd1.Text = string.IsNullOrEmpty(arc.AddressOne) ? "" : arc.AddressOne;
            Textadd2.Text = string.IsNullOrEmpty(arc.AddressTwo) ? "" : arc.AddressTwo;
            Texttown.Text = string.IsNullOrEmpty(arc.Town) ? "" : arc.Town;
            Textpostcode.Text = string.IsNullOrEmpty(arc.PostCode) ? "" : arc.PostCode;
            Textcounty.Text = string.IsNullOrEmpty(arc.County) ? "" : arc.County;
            Ddcountry.SelectedValue = string.IsNullOrEmpty(arc.Country) ? "UK" : arc.Country;
            DdcountryCode.SelectedValue = string.IsNullOrEmpty(arc.CountryCode) ? "UK" : arc.CountryCode;
            Textsalesno.Text = string.IsNullOrEmpty(arc.SalesLedgerNo) ? "" : arc.SalesLedgerNo;
            rdbtnloptions.SelectedValue = string.IsNullOrEmpty(arc.ProductOptionId.ToString()) ? "1" : arc.ProductOptionId.ToString();
            txtARCEmailCC.Text = string.IsNullOrEmpty(arc.ARC_CCEmail) ? "" : arc.ARC_CCEmail;
            txtDescription.Text = String.IsNullOrEmpty(arc.Description) ? String.Empty : arc.Description;
            txtLogisticDescription.Text = String.IsNullOrEmpty(arc.LogisticsDescription) ? String.Empty : arc.LogisticsDescription;
            txtReplenishmentLimit.Text = String.IsNullOrEmpty(arc.ReplenishmentLimit.ToString()) ? String.Empty : arc.ReplenishmentLimit.ToString();
            txt_SFObjectID.Text = String.IsNullOrEmpty(arc.SF_ObjectID) ? String.Empty : arc.SF_ObjectID.ToString();  //added by priya
            chkIsDeleted.Checked = arc.IsDeleted;
            chkPolltoEIRE.Checked = bool.Parse(arc.PolltoEIRE.ToString());
            chkExcludeTerms.Checked = bool.Parse(arc.ExcludeTerms.ToString());
            chkIsAllowedCSD.Checked = bool.Parse(arc.IsAllowedCSD.ToString());
            chkEnablePostCodeSearch.Checked = bool.Parse(arc.EnablePostCodeSearch.ToString());
            CheckProd();
            CheckCatg();
            ddlArcTypes.SelectedValue = arc.ArcTypeId.HasValue == false ? "0" : arc.ArcTypeId.Value.ToString();
            //Added belo code by Atiq on 12-08-2016 For ESI changes
            chkIsARCAllowedForBranch.Checked = arc.IsARCAllowedForBranch;
            chkInstallID_Flag.Checked = arc.EM_InstallID_Flag;
            chkSafelinkOnIPSEC.Checked = arc.SafelinkbyIPSec;
            chkisListedinRouterMonitor.Checked = bool.Parse(arc.isListedinRouterMonitor.ToString());
            txtEmizonARCNo.Text = arc.EM_ARCNo;
            txtEmizonPlatform.Text = arc.EM_Platform;
            txtInstallIDLength.Text = arc.EM_InstallIDLength;
            txtInstallIDStrategy.Text = arc.EM_InstallIDStrategy.HasValue ? arc.EM_InstallIDStrategy.Value.ToString() : "0";

        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LinkButtonupdate_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    protected void LinkButtondelete_click(object sender, System.EventArgs e)
    {
        try
        {
            LinkButton lbdel = sender as LinkButton;
            GridViewRow gvr = (GridViewRow)lbdel.NamingContainer;
            db = new LinqToSqlDataContext();
            Label lbl2 = gvr.Cells[3].FindControl("ARCId") as Label;
            Session[enumSessions.ARC_Id.ToString()] = lbl2.Text;

            //delete arc
            var arc = db.ARCs.Single(delarc => delarc.ARCId == Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString()));
            arc.IsDeleted = true;
            db.SubmitChanges();

            string script = "alertify.alert('" + ltrDeleted.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            MaintainScrollPositionOnPostBack = false;
            BindArcGrid();
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LinkButtondelete_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    protected void btnSaveUniqueCode_Click(object sender, EventArgs e)
    {
        try
        {
            db = new LinqToSqlDataContext();
            db.USP_SaveUniqueCode(txtUniqCode.Text, Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString()));
            lblUniqCode.Text = txtUniqCode.Text;
            var arc = (from arcs in db.ARCs
                       where arcs.ARCId == Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()])
                       select arcs).FirstOrDefault();
            Audit audit = new Audit();
            audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
            audit.ChangeID = Convert.ToInt32(enumAudit.Manage_ARC);
            audit.CreatedOn = DateTime.Now;
            audit.Notes = "UniqueCode updated for " + arc.ARC_Code + " from: " + lblUniqCode.Text + " to: " + txtUniqCode.Text;
            if (Request.ServerVariables["LOGON_USER"] != null)
            {
                audit.WindowsUser = Request.ServerVariables["LOGON_USER"];
            }
            audit.IPAddress = Request.UserHostAddress;
            db.Audits.InsertOnSubmit(audit);
            db.SubmitChanges();
            txtUniqCode.Text = String.Empty;
            string script = "alertify.alert('" + ltrUniqueCode.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            txtUniqCode.Visible = false;
            btnSaveUniqueCode.Visible = false;

        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSaveUniqueCode_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {

        if (Page.IsValid)
        {
            try
            {
                Audit audit = new Audit();
                if (!string.IsNullOrEmpty(txtarcCode.Text) && !string.IsNullOrEmpty(txtarcName.Text) 
                    && !string.IsNullOrEmpty(Textemail.Text))
                {
                    int chkallret = 0;
                    int chkannbill = 0;
                    int chkbulk = 0;
                    int chkpost = 0;
                    int chkapi = 0;

                    if (ChkAllowReturns.Checked == true)
                        chkallret = 1;
                    else chkallret = 0;

                    if (Chkannualbilling.Checked == true)
                        chkannbill = 1;
                    else chkannbill = 0;

                    if (Chkisbulkallow.Checked == true)
                        chkbulk = 1;
                    else chkbulk = 0;

                    if (Chkpostingopt.Checked == true)
                        chkpost = 1;
                    else chkpost = 0;

                    if (Chkisapi.Checked == true)
                        chkapi = 1;
                    else chkapi = 0;
                    //get Default Options

                    string opt = rdbtnloptions.SelectedValue;


                    db = new LinqToSqlDataContext();
                    //if updating arc,delete all the mapped ctg's and products of this arc.
                    if (!string.IsNullOrWhiteSpace(txtARCID.Text))
                    {
                        //added the column Sf_ObjectID to ARC
                        int ArcID = -1;
                        int.TryParse(txtARCID.Text, out ArcID);
                        ARC dbARC = db.ARCs.Where(x => x.ARCId == ArcID).FirstOrDefault();

                        if (dbARC != null)
                        {
                            if (dbARC.ARCId == 0)
                            {
                                string script = "alertify.alert('" + ltrDuplicate.Text + "');";
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                MaintainScrollPositionOnPostBack = false;
                                return;
                            }
                            else
                            {
                                dbARC.ARC_Code = txtarcCode.Text;
                                dbARC.CompanyName = txtarcName.Text;
                                dbARC.ARC_Email = Textemail.Text;
                                dbARC.Fax = Textfax.Text;
                                dbARC.PrimaryContact = Textprimcontact.Text;
                                dbARC.Telephone = Texttelphn.Text;
                                dbARC.AddressOne = Textadd1.Text.ToString();
                                dbARC.AddressTwo = Textadd2.Text.ToString();
                                dbARC.Town = Texttown.Text.ToString();
                                dbARC.PostCode = Textpostcode.Text.ToString();
                                dbARC.County = Textcounty.Text.ToString();
                                dbARC.Country = Ddcountry.SelectedValue.ToString();
                                dbARC.CountryCode = DdcountryCode.SelectedValue.ToString();
                                dbARC.BillingAccountNo = Textbillaccno.Text.ToString();
                                dbARC.AnnualBilling = Convert.ToBoolean(chkannbill);
                                dbARC.AllowReturns = Convert.ToBoolean(chkallret);
                                dbARC.PostingOption = Convert.ToBoolean(chkpost);
                                dbARC.IsBulkUploadAllowed = Convert.ToBoolean(chkbulk);
                                dbARC.IsAPIAccess = Convert.ToBoolean(chkapi);
                                dbARC.SalesLedgerNo = String.IsNullOrEmpty(Textsalesno.Text.ToString()) ? "" : Textsalesno.Text.ToString();
                                dbARC.ProductOptionId = Convert.ToInt16(opt);
                                dbARC.ARC_CCEmail = txtARCEmailCC.Text.ToString();
                                dbARC.ArcTypeId = Convert.ToInt32(ddlArcTypes.SelectedValue);
                                dbARC.Description = txtDescription.Text;
                                dbARC.LogisticsDescription = txtLogisticDescription.Text.Trim();
                                dbARC.IsDeleted = chkIsDeleted.Checked;
                                dbARC.PolltoEIRE = chkPolltoEIRE.Checked;
                                dbARC.ExcludeTerms = chkExcludeTerms.Checked;
                                dbARC.IsAllowedCSD = chkIsAllowedCSD.Checked;
                                dbARC.EnablePostCodeSearch = chkEnablePostCodeSearch.Checked;
                                dbARC.ReplenishmentLimit = Convert.ToInt32(txtReplenishmentLimit.Text);
                                dbARC.IsARCAllowedForBranch = chkIsARCAllowedForBranch.Checked;
                                dbARC.SF_ObjectID = txt_SFObjectID.Text;
                                dbARC.CreatedOn = DateTime.Now;
                                dbARC.SafelinkbyIPSec = chkSafelinkOnIPSEC.Checked;
                                dbARC.isListedinRouterMonitor = chkisListedinRouterMonitor.Checked;
                                dbARC.EM_ARCNo = txtEmizonARCNo.Text;
                                dbARC.EM_InstallID_Flag = chkInstallID_Flag.Checked;
                                dbARC.EM_InstallIDLength = txtInstallIDLength.Text;
                                dbARC.EM_InstallIDStrategy = string.IsNullOrEmpty(txtInstallIDStrategy.Text) ? '0' : Char.Parse(txtInstallIDStrategy.Text.Substring(0, 1));
                                dbARC.EM_Platform = txtEmizonPlatform.Text;
                                dbARC.IsVoiceSMSVisible = chkVoiceSMS.Checked;
                                dbARC.ModifiedBy = SiteUtility.GetUserName();
                                dbARC.ModifiedOn = DateTime.Now;

                                db.SubmitChanges();

                                var arcCats = db.ARC_Category_Maps.Where(x => x.ARCId == ArcID).ToList();
                                foreach (ARC_Category_Map arcMap in arcCats) {
                                    db.ARC_Category_Maps.DeleteOnSubmit(arcMap);
                                }
                                db.SubmitChanges();

                                var arcProds = db.Product_ARC_Maps.Where(x => x.ARCId == ArcID).ToList();
                                foreach (Product_ARC_Map arcProdMap in arcProds)
                                {
                                    db.Product_ARC_Maps.DeleteOnSubmit(arcProdMap);
                                }
                                db.SubmitChanges();

                                Session[enumSessions.ARC_Id.ToString()] = dbARC.ARCId;
                                string script = "alertify.alert('ARC [" + txtarcCode.Text + "] - " + txtarcName.Text + " updated successfully.');";
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                MaintainScrollPositionOnPostBack = false;
                                pnlArcDetail.Visible = false;
                                pnlARClist.Visible = true;
                            }
                        }
                        audit.Notes += "ARCId: " + Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString()) + ", ARC Code: " + txtarcCode.Text.ToString() + ", ARC Name: " + txtarcName.Text.ToString() + ", Email: " + Textemail.Text.ToString() + ", Fax: " + Textfax.Text.ToString() + ", Primary Contact: " + Textprimcontact.Text.ToString() + ", Phone: " + Texttelphn.Text.ToString() + ", Address 1:" + Textadd1.Text.ToString() + ", Address 2:" + Textadd2.Text.ToString() + ", Town: " + Texttown.Text.ToString() + ", Postcode: " + Textpostcode.Text.ToString() + ", County: " + Textcounty.Text.ToString() + ", Country: " + Ddcountry.SelectedValue.ToString() + ", Country Code: " + DdcountryCode.SelectedValue.ToString() + ", Billing Account No: " + Textbillaccno.Text.ToString() + ", Annual Billing: " + Convert.ToBoolean(chkannbill) + ", Allow Returns: " + Convert.ToBoolean(chkallret) + ", Posting Options: " + Convert.ToBoolean(chkpost) + ", Allow Bulk Upload: " + Convert.ToBoolean(chkbulk) + ", Allow API Access: " + Convert.ToBoolean(chkapi) + ", Sales Ledger No: " + (String.IsNullOrEmpty(Textsalesno.Text.ToString()) ? "" : Textsalesno.Text.ToString()) + ", Option: " + Convert.ToInt16(opt) + ", EmailCC: " + txtARCEmailCC.Text.ToString() + ", ARC Type: " + Convert.ToInt32(ddlArcTypes.SelectedValue) + ", Description: " + txtDescription.Text + ", Logistics Description: " + txtLogisticDescription.Text.Trim() + ", Is Deleted: " + chkIsDeleted.Checked + ", Poll To EIRE: " + chkPolltoEIRE.Checked + ", Exclude Terms: " + chkExcludeTerms.Checked + ", Allow CSD" + chkIsAllowedCSD.Checked + ", Enable Postcode Search: " + chkEnablePostCodeSearch.Checked + ", SF_Object_ID" + txt_SFObjectID.Text + ", ";
                    }
                    else
                    {
                        // create new ARC 
                        ARC newARC = new ARC()
                        {
                            ARC_Code = txtarcCode.Text,
                            CompanyName = txtarcName.Text,
                            ARC_Email = Textemail.Text,
                            Fax = Textfax.Text,
                            PrimaryContact = Textprimcontact.Text,
                            Telephone = Texttelphn.Text,
                            AddressOne = Textadd1.Text.ToString(),
                            AddressTwo = Textadd2.Text.ToString(),
                            Town = Texttown.Text.ToString(),
                            PostCode = Textpostcode.Text.ToString(),
                            County = Textcounty.Text.ToString(),
                            Country = Ddcountry.SelectedValue.ToString(),
                            CountryCode = DdcountryCode.SelectedValue.ToString(),
                            BillingAccountNo = Textbillaccno.Text.ToString(),
                            AnnualBilling = Convert.ToBoolean(chkannbill),
                            AllowReturns = Convert.ToBoolean(chkallret),
                            PostingOption = Convert.ToBoolean(chkpost),
                            IsBulkUploadAllowed = Convert.ToBoolean(chkbulk),
                            IsAPIAccess = Convert.ToBoolean(chkapi),
                            SalesLedgerNo = String.IsNullOrEmpty(Textsalesno.Text.ToString()) ? "" : Textsalesno.Text.ToString(),
                            ProductOptionId = Convert.ToInt16(opt),
                            ARC_CCEmail = txtARCEmailCC.Text.ToString(),
                            ArcTypeId = Convert.ToInt32(ddlArcTypes.SelectedValue),
                            Description = txtDescription.Text,
                            LogisticsDescription = txtLogisticDescription.Text.Trim(),
                            IsDeleted = chkIsDeleted.Checked,
                            PolltoEIRE = chkPolltoEIRE.Checked,
                            ExcludeTerms = chkExcludeTerms.Checked,
                            IsAllowedCSD = chkIsAllowedCSD.Checked,
                            EnablePostCodeSearch = chkEnablePostCodeSearch.Checked,
                            ReplenishmentLimit = Convert.ToInt32(txtReplenishmentLimit.Text),
                            IsARCAllowedForBranch = chkIsARCAllowedForBranch.Checked,
                            SF_ObjectID = txt_SFObjectID.Text,
                            CreatedOn = DateTime.Now,
                            SafelinkbyIPSec = chkSafelinkOnIPSEC.Checked,
                            isListedinRouterMonitor = chkisListedinRouterMonitor.Checked,
                            EM_ARCNo = txtEmizonARCNo.Text,
                            EM_InstallID_Flag = chkInstallID_Flag.Checked,
                            EM_InstallIDLength = txtInstallIDLength.Text,
                            EM_InstallIDStrategy = string.IsNullOrEmpty(txtInstallIDStrategy.Text)? '0' : Char.Parse(txtInstallIDStrategy.Text.Substring(0, 1)),
                            EM_Platform = txtEmizonPlatform.Text,
                            IsVoiceSMSVisible = chkVoiceSMS.Checked,
                            CreatedBy = SiteUtility.GetUserName()
                        };

                        var arc = ArcBAL.CreateARC(newARC);

                        if (arc != null)
                            Session[enumSessions.ARC_Id.ToString()] = arc.ARCId;
                        if (arc.ARCId == 0)
                        {
                            string script = "alertify.alert('" + ltrDuplicate.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            MaintainScrollPositionOnPostBack = false;
                        }
                        else
                        {
                            string script = "alertify.alert('ARC [" + txtarcCode.Text + "] - " + txtarcName.Text + " created successfully.');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            MaintainScrollPositionOnPostBack = false;
                            pnlArcDetail.Visible = false;
                            pnlARClist.Visible = true;
                        }
                        audit.Notes += "ARCId: " + arc.ARCId + ", ARC Code: " + txtarcCode.Text.ToString() + ", ARC Name: " + txtarcName.Text.ToString() + ", Email: " + Textemail.Text.ToString() + ", Fax: " + Textfax.Text.ToString() + ", Primary Contact: " + Textprimcontact.Text.ToString() + ", Phone: " + Texttelphn.Text.ToString() + ", Address 1:" + Textadd1.Text.ToString() + ", Address 2:" + Textadd2.Text.ToString() + ", Town: " + Texttown.Text.ToString() + ", Postcode: " + Textpostcode.Text.ToString() + ", County: " + Textcounty.Text.ToString() + ", Country: " + Ddcountry.SelectedValue.ToString() + ", Country Code: " + DdcountryCode.SelectedValue.ToString() + ", Billing Account No: " + Textbillaccno.Text.ToString() + ", Annual Billing: " + Convert.ToBoolean(chkannbill) + ", Allow Returns: " + Convert.ToBoolean(chkallret) + ", Posting Options: " + Convert.ToBoolean(chkpost) + ", Allow Bulk Upload: " + Convert.ToBoolean(chkbulk) + ", Allow API Access: " + Convert.ToBoolean(chkapi) + ", Sales Ledger No: " + (String.IsNullOrEmpty(Textsalesno.Text.ToString()) ? "" : Textsalesno.Text.ToString()) + ", Option: " + Convert.ToInt16(opt) + ", EmailCC: " + txtARCEmailCC.Text.ToString() + ", ARC Type: " + Convert.ToInt32(ddlArcTypes.SelectedValue) + ", Description: " + txtDescription.Text + ", Logistics Description: " + txtLogisticDescription.Text.Trim() + ", Is Deleted: " + chkIsDeleted.Checked + ", Poll To EIRE: " + chkPolltoEIRE.Checked + ", Exclude Terms: " + chkExcludeTerms.Checked + ", Allow CSD" + chkIsAllowedCSD.Checked + ", Enable Postcode Search: " + chkEnablePostCodeSearch.Checked + ",SF_Object_ID" + txt_SFObjectID.Text + ", ";
                    }
                }
                audit.Notes += "Options: " + rdbtnloptions.SelectedItem + ", ";

                //enter all the checked products of this ARC

                audit.Notes += "ProductID: ";
                List<Product_ARC_Map> arcProductsList = new List<Product_ARC_Map>(); 
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
                                    Product_ARC_Map cmp = new Product_ARC_Map();
                                    cmp.ARCId = Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()]);
                                    cmp.ProductId = Convert.ToInt32(Prodid);
                                    //added by priya 09/02/2016
                                    if (Csdrestricted_productcodes.Value.Contains(Prodid.ToString()))
                                    {
                                        cmp.CSDRestriction = true;
                                    }
                                    else
                                    {
                                        cmp.CSDRestriction = false;
                                    }
                                    var count = arcProductsList.Where(x => x.ProductId == cmp.ProductId && x.ARCId == cmp.ARCId && x.CSDRestriction == cmp.CSDRestriction).Count();
                                    if (count <= 0)
                                    {
                                        arcProductsList.Add(cmp);
                                    }
                                    
                                    audit.Notes += Prodid + ", ";
                                }
                            }

                        }
                    }

                }


                db.Product_ARC_Maps.InsertAllOnSubmit(arcProductsList);
                db.SubmitChanges();

                //enter all the checked catg's of this ARC
                audit.Notes += "CategoryID: ";
                var Checkedctg = (from ListItem item in CheckBoxCtg.Items where item.Selected select item.Value).ToList();
                if (Checkedctg.Any())
                {
                    ARC_Category_Map acm;
                    foreach (String chkctg in Checkedctg)
                    {
                        if (chkctg != "Select All")
                        {

                            acm = new ARC_Category_Map();
                            acm.ARCId = Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()]);
                            acm.CategoryId = Convert.ToInt32(chkctg);
                            db.ARC_Category_Maps.InsertOnSubmit(acm);
                            db.SubmitChanges();
                            audit.Notes += chkctg + ", ";
                        }
                    }
                }
                if (!String.IsNullOrEmpty(txtarcCode.Text))
                    BindArcGrid();

                audit.UserName = SiteUtility.GetUserName();
                audit.ChangeID = Convert.ToInt32(enumAudit.Manage_ARC);
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
                ltrDetails.Text = objException.Message;
                string script = "alertify.alert('" + ltrDetails.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                MaintainScrollPositionOnPostBack = false;
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSave_Click", Convert.ToString(objException.Message) + "ARCID : " + Session[enumSessions.ARC_Id.ToString()], Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
        else
        {
            string script = "alertify.alert('" + ltrDetails.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            MaintainScrollPositionOnPostBack = false;
        }

        MaintainScrollPositionOnPostBack = false;
    }

    public void CheckProd()
    {
        try
        {
            int ArcID = Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()]);
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
            int Prod_Id = 0;
            db = new LinqToSqlDataContext();
            var Arc_prods = (from ar in db.Product_ARC_Maps
                             join pr in db.Products
                             on ar.ProductId equals pr.ProductId
                             where ar.ARCId == ArcID
                             select new { ar.ProductId, pr.ProductName, ar.CSDRestriction });
            //added by priya 08/02/2016

            var Arc_prods_csdrestricted = from a in Arc_prods
                                          where a.CSDRestriction == true
                                          select a.ProductId;

            StringBuilder Arc_prods_csdrestricted_result = new StringBuilder();
            foreach (var productid in Arc_prods_csdrestricted)
            {
                Arc_prods_csdrestricted_result.Append(productid.ToString() + ',');
            }
            Csdrestricted_productcodes.Value = Arc_prods_csdrestricted_result.ToString();


            foreach (var objp in Arc_prods)
            {

                Prod_Id = Convert.ToInt32(objp.ProductId);
                foreach (GridViewRow ctgrow in gvctg.Rows)
                {
                    GridView innergrid = ctgrow.FindControl("gvinner") as GridView;
                    foreach (GridViewRow prodrow in innergrid.Rows)
                    {
                        int chkProdid = int.Parse(innergrid.DataKeys[prodrow.RowIndex].Value.ToString());
                        if (chkProdid == Prod_Id)
                        {
                            CheckBox chkpro = prodrow.FindControl("chkprod") as CheckBox;
                            chkpro.Checked = true;
                            chkprod_CheckedChanged(chkpro, null);

                        }

                    }

                }

            }
        }
        catch (Exception objException)
        {

            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "CheckProd", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    public void CheckCatg()
    {
        try
        {

            int ArcID = Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()]);
            foreach (ListItem itemchk in CheckBoxCtg.Items)
            {
                itemchk.Selected = false;
            }
            int Ctg_Id = 0;
            db = new LinqToSqlDataContext();
            var Arc_ctg = (from c in db.Categories
                           join arc in db.ARC_Category_Maps
                           on c.CategoryId equals arc.CategoryId
                           where arc.ARCId == ArcID
                           select new { c.CategoryName, c.CategoryCode, arc.CategoryId });

            foreach (var objp in Arc_ctg)
            {

                Ctg_Id = Convert.ToInt32(objp.CategoryId);
                foreach (ListItem itemchk in CheckBoxCtg.Items)
                {
                    if (itemchk.Value != "Select All")
                    {
                        int Chkbox_Cid = Convert.ToInt32(itemchk.Value);
                        if (Chkbox_Cid == Ctg_Id)
                        {
                            itemchk.Selected = true;
                        }
                    }
                }
            }

        }
        catch (Exception objException)
        {

            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "CheckCatg", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    #region gvARC Paging

    protected void gvARC_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            gvARC.PageIndex = e.NewPageIndex;
            LoadData();
            BindArcGrid();
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvARC_PageIndexChanging", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }

    }

    #endregion

    static Boolean CheckBoxProdflag = false;
    //protected void CheckBoxProd_OnSelectedIndexChanged(object sender, EventArgs e)
    //{


    //    foreach (ListItem item in CheckBoxProd.Items)
    //    {
    //        if ((item.Text == "Select All") && (item.Selected == true) && (CheckBoxProdflag == false))
    //        {
    //            foreach (ListItem item1 in CheckBoxProd.Items)
    //            {
    //                item1.Selected = true;
    //                CheckBoxProdflag = true;
    //            }
    //        }
    //        else if ((item.Text == "Select All") && (item.Selected == false) && (CheckBoxProdflag == true))
    //        {
    //            foreach (ListItem item1 in CheckBoxProd.Items)
    //            {
    //                item1.Selected = false;
    //                CheckBoxProdflag = false;
    //            }

    //        }
    //        else if ((item.Text == "Select All") && (item.Selected == true) && (CheckBoxProdflag == true))
    //        {
    //            foreach (ListItem item2 in CheckBoxProd.Items)
    //            {
    //                if (item2.Selected == false)
    //                {
    //                    CheckBoxProd.Items[0].Selected = false;
    //                    CheckBoxProdflag = false;

    //                }
    //            }
    //        }
    //        else if ((item.Text == "Select All") && (item.Selected == false) && (CheckBoxProdflag == false) && (CheckBoxProd.SelectedItem != null))
    //        {
    //            CheckBoxProd.SelectedItem.Selected = true;

    //        }


    //    }
    //}

    static Boolean CheckBoxCtgflag = false;
    protected void CheckBoxCtg_OnSelectedIndexChanged(object sender, EventArgs e)
    {

        foreach (ListItem item in CheckBoxCtg.Items)
        {
            if ((item.Text == "Select All") && (item.Selected == true) && (CheckBoxCtgflag == false))
            {
                foreach (ListItem item1 in CheckBoxCtg.Items)
                {
                    item1.Selected = true;
                    CheckBoxCtgflag = true;
                }
            }
            else if ((item.Text == "Select All") && (item.Selected == false) && (CheckBoxCtgflag == true))
            {
                foreach (ListItem item1 in CheckBoxCtg.Items)
                {
                    item1.Selected = false;
                    CheckBoxCtgflag = false;
                }

            }
            else if ((item.Text == "Select All") && (item.Selected == true) && (CheckBoxCtgflag == true))
            {
                foreach (ListItem item2 in CheckBoxCtg.Items)
                {
                    if (item2.Selected == false)
                    {
                        CheckBoxCtg.Items[0].Selected = false;
                        CheckBoxCtgflag = false;

                    }
                }
            }
            else if ((item.Text == "Select All") && (item.Selected == false) && (CheckBoxCtgflag == false) && (CheckBoxCtg.SelectedItem != null))
            {
                CheckBoxCtg.SelectedItem.Selected = true;

            }


        }
    }

    protected void lbnewarc_Click(object sender, EventArgs e)
    {
        pnlArcDetail.Visible = true;
        pnlARClist.Visible = false;
        litAction.Text = "You choose to <b>ADD NEW ARC</b>";
        txtarcName.Focus();
        LoadData();
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

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Session[enumSessions.ARC_Id.ToString()] = null;
        pnlARClist.Visible = true;
        pnlArcDetail.Visible = false;

    }
    protected void btnReset_Click(object sender, EventArgs e)
    {
        if (Session[enumSessions.ARC_Id.ToString()] != null)
        {
            LinkButtonupdate_click(sender, e);
        }
        else
        {
            lbnewarc_Click(sender, e);
        }
    }

    protected void btnUnique_Click(object sender, EventArgs e)
    {
        if (btnSaveUniqueCode.Visible == false)
        {
            txtUniqCode.Visible = true;
            btnSaveUniqueCode.Visible = true;
        }
        else
        {
            txtUniqCode.Visible = false;
            btnSaveUniqueCode.Visible = false;
        }
    }
}
