using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;
using System.Web.Mail;
using System.Configuration;
using CSLOrderingARCBAL.BAL;
using System.Text;
using System.Web.UI.HtmlControls;
using MSMQSendEmailToQueueLibrary;
using CSLOrderingARCBAL.Common;


public partial class gradeform : System.Web.UI.Page
{
    LinqToSqlDataContext db;
    string smtphost = "";
    string mailFrom = "";
    string mailCC = "";
    string mailTO = "";
    bool enablePostCodeSearch;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Request.UrlReferrer == null || Session[enumSessions.User_Id.ToString()] == null)
                Response.Redirect("Login.aspx");

            if (Session[enumSessions.User_Name.ToString()] == null || Session[enumSessions.User_Email.ToString()] == null || Session[enumSessions.ARC_Id.ToString()] == null)
                Response.Redirect("Login.aspx");

            pnlInstallersPC.Visible = false;
            pnlInstallers.Visible = false;
            int ARCId = Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()]);
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            enablePostCodeSearch = (from arc in db.ARCs
                                    where arc.ARCId == ARCId
                                    select arc.EnablePostCodeSearch).Single();
            if (enablePostCodeSearch == true)
            {
                pnlInstallersPC.Visible = true;
            }
            else
            {
                pnlInstallers.Visible = true;
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

        ApplicationDTO appdto;
        //check values in cache,if null,then set them again else retrieve.

        if (string.IsNullOrEmpty((string)HttpRuntime.Cache["smtphost"]))
        {
            AppSettings appsett = new AppSettings();
            appdto = appsett.GetAppValues();
            smtphost = appdto.smtphost;
        }
        else
            smtphost = (string)HttpRuntime.Cache["smtphost"];



        if (string.IsNullOrEmpty((string)HttpRuntime.Cache["OrdersEmailFrom"]))
        {
            AppSettings appsett = new AppSettings();
            appdto = appsett.GetAppValues();
            mailFrom = appdto.mailFrom;
        }
        else
            mailFrom = (string)HttpRuntime.Cache["OrdersEmailFrom"];


        if (string.IsNullOrEmpty((string)HttpRuntime.Cache["EmailCC"]))
        {
            AppSettings appsett = new AppSettings();
            appdto = appsett.GetAppValues();
            mailCC = appdto.mailCC;
        }
        else
            mailCC = (string)HttpRuntime.Cache["EmailCC"];


        if (string.IsNullOrEmpty((string)HttpRuntime.Cache["BillingEmail"]))
        {
            AppSettings appsett = new AppSettings();
            appdto = appsett.GetAppValues();
            mailTO = appdto.mailTO;
        }
        else
            mailTO = (string)HttpRuntime.Cache["BillingEmail"];


        if (string.IsNullOrEmpty(Request["dr"]))
        {
            Response.Redirect("categories.aspx");
        }

        if (Request["dr"] == "u")
        {
            lblTitle.Text = "GradeShift Upgrade";
            ddlTitle.Visible = false;
            ddlReason.Visible = false;
            disText.Visible = false;
            recText.Visible = false;
            chkConfirm.Text = "By ticking this box you are instructing CSL to upgrade this unit. Upgrade change will take up to 24 hours.";
            txtRegradeDateTime.Visible = lblRegradeTime.Visible = false;
            SelectedEMNo.Visible = lblEMno.Visible  = false;
            divEmizonInstructions.Visible = false;
            divCSLInstructions.Visible = true; 
        }
        else if (Request["dr"] == "d")
        {
            lblTitle.Text = "GradeShift Downgrade";
            ddlTitle.Visible = true;
            ddlReason.Visible = true;
            disText.Visible = false;
            recText.Visible = false;
            chkConfirm.Text = "By ticking this box you are instructing CSL to downgrade this unit. Downgrade is only available after initial 12 month contract is completed. Please contact Accounts on +44 (0)1895 474 474.";
            txtRegradeDateTime.Visible = lblRegradeTime.Visible = false;
            SelectedEMNo.Visible = lblEMno.Visible = false;
            divEmizonInstructions.Visible = false;
            divCSLInstructions.Visible = true; 
        }
        else if (Request["dr"] == "r")
        {
            lblTitle.Text = "Regrade";
            ddlTitle.Visible = false;
            ddlReason.Visible = false;
            disText.Visible = false;
            recText.Visible = false;
            nua_data.Visible = false;
            lblDataNo.Visible = false;
            chkConfirm.Text = "By ticking this box you are instructing CSL to regrade this unit. ";
            txtRegradeDateTime.Visible = lblRegradeTime.Visible = true;
            SelectedEMNo.Visible = lblEMno.Visible =  true;
            divEmizonInstructions.Visible = true;
            divCSLInstructions.Visible = false;
            lblFrom.Visible = ddlFrom.Visible = false;
        }
        if (!IsPostBack)
        {
            try
            {
                PopulateDropDowns();
                btnSubmit.Visible = false;
                divuc1.Visible = true;
                divuc2.Visible = true;
                Button ucbtn = (Button)Installers.FindControl("btnSelect");
                if (ucbtn != null)
                {
                    ucbtn.Visible = false;
                }
                Button ucbtnPC = (Button)rptInstallerCompanies.FindControl("btnSelect");
                if (ucbtnPC != null)
                {
                    ucbtnPC.Visible = false;
                }
                db = new LinqToSqlDataContext();
                var DltData = (from data in db.UpDowngrades
                               where data.UserId == Session[enumSessions.User_Id.ToString()].ToString() && data.Emailed == false
                                && data.AwaitingtobeProcessed == false 
                               select data);
                db.UpDowngrades.DeleteAllOnSubmit(DltData);
                db.SubmitChanges();
            }
            catch (Exception objException)
            {
                CSLOrderingARCBAL.LinqToSqlDataContext db;
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "GradeForm_PageLoad", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
            Session[enumSessions.SelectedInstaller.ToString()] = null;
            Session[enumSessions.InstallerCompanyID.ToString()] = null;
            PopulateAwaitingtoBeProcessedList();
        }

        lblCurrentTime.Text = DateTime.Now.ToString("g");

    }

    public void PopulateDropDowns()
    {
        if (Request["dr"].ToString() == "u")
        {
            ddlFrom.Items.Insert(0, new ListItem("G4 IP", "401"));
            ddlFrom.Items.Insert(0, new ListItem("G3 IP", "301"));
            ddlFrom.Items.Insert(0, new ListItem("G2 IP", "202"));
            ddlFrom.Items.Insert(0, new ListItem("G2R", "201"));
            ddlFrom.Items.Insert(0, new ListItem("GPRS G4", "400"));
            ddlFrom.Items.Insert(0, new ListItem("GPRS G3", "300"));
            ddlFrom.Items.Insert(0, new ListItem("GPRS G2", "200"));
            ddlFrom.Items.Insert(0, new ListItem("Please Select", "0"));

            ddlTo.Items.Insert(0, new ListItem("G4 IP", "401"));
            ddlTo.Items.Insert(0, new ListItem("G3 IP", "302"));
            ddlTo.Items.Insert(0, new ListItem("G3R", "301"));
            ddlTo.Items.Insert(0, new ListItem("GPRS Fire", "500"));
            ddlTo.Items.Insert(0, new ListItem("GPRS G4", "400"));
            ddlTo.Items.Insert(0, new ListItem("GPRS G3", "300"));
            ddlTo.Items.Insert(0, new ListItem("GPRS G2", "200"));
            ddlTo.Items.Insert(0, new ListItem("Please Select", "0"));
        }
        else if (Request["dr"].ToString() == "d")
        {
            ddlTo.Items.Insert(0, new ListItem("G4 IP", "401"));
            ddlTo.Items.Insert(0, new ListItem("G3 IP", "301"));
            ddlTo.Items.Insert(0, new ListItem("G2 IP", "202"));
            ddlTo.Items.Insert(0, new ListItem("G2R", "201"));
            ddlTo.Items.Insert(0, new ListItem("G3R", "203"));
            ddlTo.Items.Insert(0, new ListItem("GPRS G4", "400"));
            ddlTo.Items.Insert(0, new ListItem("GPRS G3", "300"));
            ddlTo.Items.Insert(0, new ListItem("GPRS G2", "200"));
            ddlTo.Items.Insert(0, new ListItem("Please Select", "0"));

            ddlFrom.Items.Insert(0, new ListItem("G4 IP", "401"));
            ddlFrom.Items.Insert(0, new ListItem("G3 IP", "302"));
            ddlFrom.Items.Insert(0, new ListItem("G2 IP", "201"));
            ddlFrom.Items.Insert(0, new ListItem("G3R", "301"));
            ddlFrom.Items.Insert(0, new ListItem("GPRS Fire", "500"));
            ddlFrom.Items.Insert(0, new ListItem("GPRS G4", "400"));
            ddlFrom.Items.Insert(0, new ListItem("GPRS G3", "300"));
            ddlFrom.Items.Insert(0, new ListItem("GPRS G2", "200"));
            ddlFrom.Items.Insert(0, new ListItem("Please Select", "0"));
        }
        else if (Request["dr"].ToString() == "r")
        {
            ddlFrom.Items.Insert(0, new ListItem("N.A", "0"));

            int ARCId = Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()]);
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            ddlTo.DataSource = (from Prod in db.Products
                                    join ProductMap in db.Product_ARC_Maps on Prod.ProductId equals ProductMap.ProductId
                                    where ProductMap.ARCId == ARCId && Prod.ProductType == "Product" && Prod.IsEmizonProduct == true && Prod.IsConnectionOnlyProduct == true 
                                    select new
                                    {
                                        //ProductName = Prod.ProductCode ,
                                        ProductName = Prod.ProductName.Replace(" - Airtime Only", string.Empty).Replace(", no hardware supplied", string.Empty),
                                        ProductId = Prod.EM_ProductParamID
                                    });
            ddlTo.DataTextField = "ProductName";
            ddlTo.DataValueField = "ProductId";
            ddlTo.DataBind();
            ddlTo.Items.Insert(0, new ListItem("Please Select", "0"));

            ddlReason.Visible = false;
            ddlTitle.Visible = false;
            
        }
    }

    public string GetCode()
    {
        string rtString = "";
        if (Request["dr"].ToString() == "u")
        {
            rtString = "CS2300-UG";
        }
        else if (Request["dr"].ToString() == "u")
        {
            rtString = "CS2322-DG";
        }

        return rtString;
    }


    public void btnAdd_Click(object sender, EventArgs e)
    {
        db = new LinqToSqlDataContext();

        DropDownList ddlinstaller = (DropDownList)Installers.FindControl("ddlInstallers");
        string selectedTo = (Convert.ToInt32(ddlTo.SelectedValue) / 100).ToString();
        string selectedFrom = (Convert.ToInt32(ddlFrom.SelectedValue) / 100).ToString();

        if (esn_sim.Text.Length == 0 && nua_data.Text.Length == 0 && chip.Text.Length == 0 && SelectedEMNo.Text.Length == 0)
        {
            lblValidation.Visible = true;
            lblDropValid.Visible = false;
            pnlConfirm.Visible = false;
            lblUpValid.Visible = false;
            lblDownValid.Visible = false;
            lblFromToValid.Visible = false;
        }
        else if (Request["dr"].ToString() != "r" && (selectedTo == "0" || selectedFrom == "0"))
        {
            lblFromToValid.Visible = true;
            lblValidation.Visible = false;
            lblDropValid.Visible = false;
            lblUpValid.Visible = false;
            lblDownValid.Visible = false;
        }
        else if (Request["dr"].ToString() == "r" && ddlTo.SelectedValue == "0")
        {
            lblFromToValid.Visible = true;
            lblValidation.Visible = false;
            lblDropValid.Visible = false;
            lblUpValid.Visible = false;
            lblDownValid.Visible = false;
        }
        else if (Request["dr"].ToString() == "u" && Convert.ToInt32(selectedTo) < Convert.ToInt32(selectedFrom))
        {
            lblUpValid.Visible = true;
            lblValidation.Visible = false;
            lblDropValid.Visible = false;
            pnlConfirm.Visible = false;
            lblFromToValid.Visible = false;

        }
        else if (Request["dr"].ToString() == "d" && Convert.ToInt32(selectedTo) > Convert.ToInt32(selectedFrom))
        {
            lblDownValid.Visible = true;
            lblValidation.Visible = false;
            lblDropValid.Visible = false;
            pnlConfirm.Visible = false;
            lblFromToValid.Visible = false;
        }

        else if ((Session[enumSessions.SelectedInstaller.ToString()] == null && enablePostCodeSearch == true) || (ddlinstaller.SelectedValue == "" && enablePostCodeSearch == false))
        {
            lblUpValid.Visible = false;
            lblValidation.Visible = false;
            lblDropValid.Visible = true;
            pnlConfirm.Visible = false;
            lblFromToValid.Visible = false;
            lblDownValid.Visible = false;
        }
        else
        {

            lblValidation.Visible = false;
            lblDropValid.Visible = false;
            lblUpValid.Visible = false;
            lblDownValid.Visible = false;
            lblFromToValid.Visible = false;


            if (Request.QueryString["dr"].ToString() == "r")
            {

                if (string.IsNullOrWhiteSpace(SelectedEMNo.Text))
                {
                    string script = "alertify.alert('" + "Valid EMNo is required." + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    return;
                }
                DateTime RegradeDateTime ;
                if (DateTime.TryParse(txtRegradeDateTime.Text, out RegradeDateTime) == false)
                {
                    string script = "alertify.alert('" + "Regrade Time should be a valid future date and time " + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    return;
                }

                if (RegradeDateTime<=DateTime.Now.AddMinutes(-5))
                {
                    string script = "alertify.alert('" + "Regrade Time should be a valid future date and time " + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    return;
                }

                if (IsInRegradelist(SelectedEMNo.Text))
                {
                    string script = "alertify.alert('" + "Unit on Regrade list already" + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    return;
                }

                int RequestReference = EmizonService.AddtoEmizonRequestQueue(SelectedEMNo.Text, typeof(Emizon.APIModels.MSMQTypes.QueueRegradecheckprep).Name);

                EmizonOrderController.AddtoMSMQ(ConfigurationManager.AppSettings["EmizonQueue"].ToString(), new Emizon.APIModels.MSMQTypes.QueueRegradecheckprep()
                {
                    em_no = SelectedEMNo.Text.Trim(),
                    CSLRefNo = RequestReference.ToString(),
                    new_product = ddlTo.SelectedValue,
                    arc_no = ArcBAL.GetEmizonArcNobyARCID(Session[enumSessions.ARC_Id.ToString()].ToString())
                });
                string ResponseMessage = string.Empty;
                string ResponseVal = EmizonService.WaitandGetResponse(RequestReference, ref ResponseMessage);

                if (string.IsNullOrEmpty(ResponseVal))
                {
                    string script = "alertify.alert('" + "Unable to verify if unit can be regraded, please try again later" + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);

                    return;
                }
                else if (ResponseVal == "11") //** Engineer Required
                {
                    ProceedwithRequest(true, true);
                    string script = "alertify.alert('" + "An Engineer visit is required as operation cannot be completed remotely." + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                }
                else if (ResponseVal == "0")
                {
                    ProceedwithRequest(true,false);
                    return;
                }
                else
                {
                    string script = "alertify.alert('" + "This unit is not available for a Regrade due to : " + ResponseMessage + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);

                    return;
                }

            }
            else
            {
                ProceedwithRequest();
            }
            
            

        }

    }
    public void ProceedwithRequest(bool isEmizonDevice = false,bool NeedEngineerVisit = false)
    {
        db = new LinqToSqlDataContext();

        DropDownList ddlinstaller = (DropDownList)Installers.FindControl("ddlInstallers");

        if (rpList.Items.Count > 0)
        {
            foreach (RepeaterItem ri in rpList.Items)
            {
                HtmlTableCell tdsim = (HtmlTableCell)ri.FindControl("tdSim");
                string sim = tdsim.InnerText.Trim();
                if (esn_sim.Text == sim)
                {
                    return;
                }
            }
        }

        UpDowngrade uddata = new UpDowngrade();

        string dr = "";
        if (Request.QueryString["dr"].ToString() == "d")
        {
            uddata.Req_Type = "Downgrade";
            uddata.Reason = ddlReason.SelectedValue.ToString();
            uddata.ItemTo = ddlTo.SelectedItem.ToString();
            uddata.ItemToDescription = ddlTo.SelectedItem.ToString();
        }
        else if (Request.QueryString["dr"].ToString() == "u")
        {
            uddata.Req_Type = "Upgrade";
            uddata.Reason = "";
            uddata.ItemTo = ddlTo.SelectedItem.ToString();
            uddata.ItemToDescription = ddlTo.SelectedItem.ToString();
        }
        else
        {
            uddata.Req_Type = "Regrade";
            uddata.Reason = "";
            uddata.ItemTo = ddlTo.SelectedValue.ToString();
            uddata.ItemToDescription = ddlTo.SelectedItem.ToString();
        }
        
      
        uddata.ArcId = Session[enumSessions.ARC_Id.ToString()].ToString();
        uddata.Chipno = chip.Text.ToString();
        uddata.Datano = nua_data.Text.ToString();
        uddata.date = DateTime.Now.ToString();
        if (enablePostCodeSearch == true)
        {
            uddata.Installer = Session[enumSessions.InstallerCompanyID.ToString()].ToString().ToLower();
        }
        else
        {
            uddata.Installer = ddlinstaller.SelectedValue.ToString().ToLower();
        }
        
        uddata.Simno = esn_sim.Text.ToString();
        uddata.Emailed = false;
        uddata.UserId = Session[enumSessions.User_Id.ToString()].ToString();
        uddata.UserName = Session[enumSessions.User_Name.ToString()].ToString();
        uddata.UserEmail = Session[enumSessions.User_Email.ToString()].ToString();
        uddata.ItemFrom = ddlFrom.SelectedItem.ToString();
        uddata.ARCRef = ARCRef.Text.ToString();
        uddata.ISEmizonUnit = isEmizonDevice;
        uddata.NeedsEngineer = NeedEngineerVisit;
        if (isEmizonDevice)
        {
            uddata.RegradeDateTime = DateTime.Parse(txtRegradeDateTime.Text);
            uddata.EMNo = SelectedEMNo.Text.Trim();
            uddata.TobeUpdatedOnBOS = false;
            uddata.UpdatedOnBOS = false;
            uddata.NoofAttempts = 0;
            uddata.EM_Platform = ArcBAL.GetEmizonPlatformbyARCID(Session[enumSessions.ARC_Id.ToString()].ToString());
        }
        uddata.FreeTextEntry = (esn_sim.Enabled) ? true : false; 

        db.UpDowngrades.InsertOnSubmit(uddata);
        db.SubmitChanges();

        ClearSelection();
        ddlReason.SelectedIndex = 0;
        ddlFrom.SelectedIndex = 0;
        ddlTo.SelectedIndex = 0;
        PopulateList();
    }

    private bool IsInRegradelist(string EMNo)
    {
        db = new LinqToSqlDataContext();
        var DrData = from data in db.UpDowngrades
                     where data.EMNo == EMNo
                     && data.AwaitingtobeProcessed == true 
                     select data;
        if (DrData.Any())
        { return true; }
        else { return false; }
    }

    public void btnSubmit_Click(object sender, EventArgs e)
    {
        DropDownList ddlinstaller = (DropDownList)Installers.FindControl("ddlInstallers");
        if (enablePostCodeSearch == false)
        {
            Session[enumSessions.InstallerCompanyID.ToString()] = ddlinstaller.SelectedValue;
            Session[enumSessions.SelectedInstaller.ToString()] = ddlinstaller.SelectedItem;
        }
        db = new LinqToSqlDataContext();
        string mycheck = "";
        if (Request["dr"].ToString() == "d" || Request["dr"].ToString() == "u" || Request["dr"].ToString() == "r")
        {
            if (chkConfirm.Checked)
            {
                mycheck = "true";
            }
            else
            {
                mycheck = "false";
            }
        }
        else
        {
            mycheck = "true";
        }
        if (mycheck == "true")
        {
            lblSubmitConfirm.Visible = false;
            string UserEmail = "";
            string CompanyName = "";
            string UserName = "";
            string dr = Request["dr"].ToString();

            if (dr == "u")
            {

               
                dr = "Upgrade";
            }
            else if (dr == "u")
            {
                dr = "Downgrade";
            }
            else
            {
                dr = "Regrade";
            }

            UserName = Session[enumSessions.User_Name.ToString()].ToString();
            UserEmail = Session[enumSessions.User_Email.ToString()].ToString();
            CompanyName = CSLOrderingARCBAL.BAL.ArcBAL.GetARCName(Session[enumSessions.ARC_Id.ToString()].ToString());
            MailMessage Message = new MailMessage();
            if (UserName.Length == 0)
            {
                UserName = Session["UserId"].ToString();
            }


            
            string id = Session[enumSessions.User_Id.ToString()].ToString();
            var Data = (from d in db.UpDowngrades
                        where d.UserId == id && d.Emailed == false
                        && (d.ISEmizonUnit == false || (d.ISEmizonUnit == true && Convert.ToBoolean(d.NeedsEngineer) == true))
                        select d);
            db.SubmitChanges();
            if (Data.Any())
            {
                String EmailDevicelist = "<table cellspacing='1' cellpadding='1' border='1' width=\"100%\"><tr><td style=\"color: #888;\"><b>Request Type</b></td><td style=\"color: #888;\"><b>From</b></td><td style=\"color: #888;\"><b>To</b></td><td style=\"color: #888;\"><b>Reason</b></td><td style=\"color: #888;\"><b>ESN/SIM</b></td><td style=\"color: #888;\"><b>NUA/Data</b></td><td style=\"color: #888;\"><b>Chip Number</b></td><td style=\"color: #888;\"><b>EM No</b></td><td style=\"color: #888;\"><b>Installer</b></td><td style=\"color: #888;\"><b>ARC Ref</b></td></tr>";
                foreach (var ud in Data)
                {
                    EmailDevicelist += "<tr>";
                   // EmailDevicelist += "<td>" + dr + "</td>";
                     if(dr=="Upgrade")
                        {
                            EmailDevicelist += "<td td style=\"color: #0099cc;\">" + dr + "</td>"; //blue
                        }
                     else if (dr == "Downgrade")
                     {
                         EmailDevicelist += "<td td style=\"color: #000000;\">" + dr + "</td>"; //black
                     }
                     else {
                         EmailDevicelist += "<td>" + dr + "</td>"; //black
                     }
                    string szReason = "";
                    if (Request["dr"].ToString() == "u")
                    {
                        szReason = "n/a";
                    }
                    else
                    {
                        szReason = ud.Reason;
                    }
                    EmailDevicelist += "<td>" + ud.ItemFrom + "</td>";
                    EmailDevicelist += "<td>" + ud.ItemTo + "</td>";
                    EmailDevicelist += "<td>" + szReason + "</td>";
                    EmailDevicelist += "<td>" + ud.Simno + "</td>";
                    EmailDevicelist += "<td>" + ud.Datano + "</td>";
                    EmailDevicelist += "<td>" + ud.Chipno + "</td>";
                    EmailDevicelist += "<td>" + ud.EMNo + "</td>";
                    string selectedInstaller = GetInstallerName(ud.Installer);
                    if (string.IsNullOrEmpty(selectedInstaller))
                    {
                        EmailDevicelist += "<td>n/a</td>";
                    }
                    else
                    {
                        EmailDevicelist += "<td>" + selectedInstaller + "</td>";
                    }
                    EmailDevicelist += "<td>" + ud.ARCRef + "</td>";
                    EmailDevicelist += "</tr>";
                }

            EmailDevicelist += "</table>";
            //begin sonam
            String mailHtml = ReadTemplates.ReadMailTemplate(Server.MapPath("Template"), "EmailGrade.html");
            StringBuilder objBuilder = new StringBuilder();
            objBuilder.Append(mailHtml);
            objBuilder.Replace("{UserName}", UserName);
            objBuilder.Replace("{ArcName}", CompanyName);
            objBuilder.Replace("{UserEmail}", UserEmail);
            objBuilder.Replace("{DateofRequest}", DateTime.Now.ToString());
            objBuilder.Replace("{Devicelist}", EmailDevicelist);
            //end sonam
            if (string.IsNullOrEmpty((string)HttpRuntime.Cache["EmailCC"]))
            {
                ApplicationDTO appdto;
                AppSettings appsett = new AppSettings();
                appdto = appsett.GetAppValues();
                mailCC = appdto.mailCC;
            }
            else
                mailCC = (string)HttpRuntime.Cache["EmailCC"];

            string subjectMessage = "";
            if (Request["dr"].ToString() == "u")
            {
                subjectMessage = "Upgrade Request";
            }
            else if (Request["dr"].ToString() == "d")
            {
                subjectMessage = "Downgrade Request";
            }
                else
            {
                subjectMessage = "Regrade Request : Needs Engineer Visit";
            }

                 SendEmailMessage sendEmail = new SendEmailMessage();
                 EmailMessage cslEmailMessage = new EmailMessage();
                 cslEmailMessage.From = mailFrom;
                 cslEmailMessage.To = mailTO;
                 cslEmailMessage.CC = UserEmail + ";" + mailCC + ";" + GetArcCcEmail(Session[enumSessions.ARC_Id.ToString()].ToString());
                 cslEmailMessage.BCC = "";
                 cslEmailMessage.Subject = subjectMessage;
                 cslEmailMessage.Message = Convert.ToString(objBuilder.ToString());
                 sendEmail.SendEmailMessageToQueue(ConfigurationManager.AppSettings["QueueName"].ToString(), cslEmailMessage);
            //End Code sending email  to msmq.
            
            db = new LinqToSqlDataContext();
            var upData = (from data in db.UpDowngrades
                          where data.UserId == Session[enumSessions.User_Id.ToString()].ToString()
                          && (data.ISEmizonUnit == false || (data.ISEmizonUnit == true && Convert.ToBoolean(data.NeedsEngineer) == true))
                          select data);
            foreach (var d in upData)
            {
                d.Emailed = true;
            }
            db.SubmitChanges();

        }

            // ** Flag Emizon units                   
            var EmizonUnits = (from data in db.UpDowngrades
                               where data.UserId == Session[enumSessions.User_Id.ToString()].ToString()
                               && data.ISEmizonUnit == true && Convert.ToBoolean(data.NeedsEngineer) == false
                               select data);

            if (EmizonUnits.Any())
            {
                foreach (var r in EmizonUnits)
                {
                    r.AwaitingtobeProcessed = true;
                    

                }
                db.SubmitChanges();
            }


            pnlForm.Visible = false;
            divuc1.Visible = false;
            divuc2.Visible = false;
            pnlConfirm.Visible = true;
            PnlAwaitingtoBeProcessed.Visible = false;
        }
        else
        {
            lblSubmitConfirm.Visible = true;
        }

        Session[enumSessions.InstallerCompanyID.ToString()] = null;
        Session[enumSessions.SelectedInstaller.ToString()] = null;
    }

    public void PopulateList()
    {
        db = new LinqToSqlDataContext();
        var DrData = from data in db.UpDowngrades
                     where data.UserId == Session[enumSessions.User_Id.ToString()].ToString() && data.Emailed == false
                     && data.AwaitingtobeProcessed == false
                     select data;
        rpList.DataSource = DrData;
        rpList.DataBind();
        if (DrData.Any())
        {
            rpList.Visible = true;
            btnSubmit.Visible = true;
        }
        else
        {
            rpList.Visible = false;
            btnSubmit.Visible = false;
            
        }

    }


    public void btnRemove_Click(object sender, CommandEventArgs e)
    {
        db = new LinqToSqlDataContext();
        int id = Convert.ToInt32(e.CommandArgument);
        var DltData = (from data in db.UpDowngrades
                       where data.UD_Id == id
                       select data).SingleOrDefault();
        db.UpDowngrades.DeleteOnSubmit(DltData);
        db.SubmitChanges();
        String Notes = "UD_ID:" + DltData.UD_Id.ToString();
        AuditEntry(Notes);
        PopulateList();
        PopulateAwaitingtoBeProcessedList();
    }

    private void AuditEntry(String Notes)
    {
        try
        {
            db = new LinqToSqlDataContext();
            Audit audit = new Audit();
            audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
            audit.ChangeID = Convert.ToInt32(enumAudit.Manage_Disconnections_Regrade);
            audit.CreatedOn = DateTime.Now;
            audit.Notes = Notes;
            if (Request.ServerVariables["LOGON_USER"] != null)
            {
                audit.WindowsUser = Request.ServerVariables["LOGON_USER"];
            }
            audit.IPAddress = Request.UserHostAddress;
            db.Audits.InsertOnSubmit(audit);
            db.SubmitChanges();
        }
        catch (Exception Ex)
        {
            // Do Nothing for this 
        }
    }


    /// <summary>
    /// Fetch the Device details
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void GetDevice_Click(object sender, EventArgs e)
    {
        ClearSelection();
        if (Session[enumSessions.ARC_Id.ToString()] == null)
        {
            string script = "alertify.alert('" + ltrARCDetails.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            esn_sim.Text = ""; nua_data.Text = ""; chip.Text = "";
            return;
        }

        if ((String.IsNullOrEmpty(txtChipNo.Text.Trim())) && (String.IsNullOrEmpty(txtDatano.Text.Trim())) && (String.IsNullOrEmpty(txtEMNo.Text.Trim())) && (String.IsNullOrEmpty(txtInstallID.Text.Trim())))
        {
            string script = "alertify.alert('" + ltrEnterNo.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            esn_sim.Text = ""; nua_data.Text = ""; chip.Text = "";
            return;
        }

        try
        {
            if (!String.IsNullOrEmpty(txtChipNo.Text.Trim()))
            {
                if (txtChipNo.Text.Trim().Length < 4 || txtChipNo.Text.Trim().Length > 6)
                {
                    string script = "alertify.alert('" + ltrValidChpNo.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    esn_sim.Text = ""; nua_data.Text = ""; chip.Text = "";
                    return;
                }
            }
            int id = Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()]);
            string chipNo = txtChipNo.Text.Trim();
            string dataNo = txtDatano.Text.Trim();
            db = new LinqToSqlDataContext();
            string ARC_Code = (from arc in db.ARCs
                               where arc.ARCId == Convert.ToInt32(id)
                               select arc.ARC_Code).SingleOrDefault();
            string EMNo = txtEMNo.Text.Trim();
            string InstallID = txtInstallID.Text.Trim();


            List<BOSDeviceDTO> devicelist = CSLOrderingARCBAL.BAL.ArcBAL.GetDevice(chipNo, ARC_Code, dataNo, EMNo, InstallID);
            gvDevicelist.DataSource = devicelist;
            gvDevicelist.DataBind();
            if (devicelist != null && devicelist.Count > 0)
            {
                if (devicelist.Count == 1)
                {
                    gvDevicelist.SelectedIndex = 0;
                    gvDevicelist_SelectedIndexChanged(sender, e);
                }
            }
            else
            {
                string script = "alertify.alert('" + ltrAccount.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
        }
        catch (Exception objException)
        {
            string script = "alertify.alert('" + ltrDetails.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            esn_sim.Text = ""; nua_data.Text = ""; chip.Text = "";
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "GetDevice_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }
    public string GetArcCcEmail(string id)
    {

        db = new LinqToSqlDataContext();
        string returnstring = "";
        string arcemail = (from arc in db.ARCs
                           where arc.ARCId == Convert.ToInt32(id)
                           select arc.ARC_CCEmail).SingleOrDefault();
        if (returnstring != null)
        {
            returnstring = arcemail;
        }
        return returnstring;
        // db.Dispose();

    }
    protected void gvDevicelist_SelectedIndexChanged(object sender, EventArgs e)
    {
        int selectedRow = gvDevicelist.SelectedIndex;
        chip.Text = gvDevicelist.Rows[selectedRow].Cells[1].Text;
        nua_data.Text = gvDevicelist.Rows[selectedRow].Cells[2].Text;
        esn_sim.Text = gvDevicelist.Rows[selectedRow].Cells[3].Text;
        SelectedEMNo.Text = Server.HtmlDecode(gvDevicelist.Rows[selectedRow].Cells[4].Text).Trim();
        int Dev_Inst_UnqCode = Convert.ToInt32(gvDevicelist.DataKeys[selectedRow].Values["Dev_Inst_UnqCode"].ToString());
        if (Dev_Inst_UnqCode != 0)
        {
            VW_InstallerDetail installer = CSLOrderingARCBAL.BAL.InstallerBAL.GetInstaller(Dev_Inst_UnqCode.ToString());
            if (installer != null)
            {
                   TextBox txtInstaller = (TextBox)rptInstallerCompanies.FindControl("installerCompanyName");
                if (txtInstaller != null)
                {
                    txtInstaller.Text = Session[enumSessions.SelectedInstaller.ToString()].ToString();
                }
            }
        }
        LockSelection();

    }

    public string GetInstallerName()
    {
        return Session[enumSessions.SelectedInstaller.ToString()].ToString();
    }

    public string GetInstallerName(string id)
    {
        db = new LinqToSqlDataContext();
        string returnstring = "";
        returnstring = (from inst in db.Installers
                        where inst.InstallerCompanyID == new Guid(id)
                        select inst.CompanyName).SingleOrDefault();
        return returnstring;
    }

    #region btnShowSearch_Click

    protected void btnShowSearch_Click(Object sender, EventArgs e)
    {
        btnHideSearch.Visible = true;
        advancedSearch.Visible = true;
        buttonSearch.Visible = true;
        btnSearch.Visible = false;
        btnShowSearch.Visible = false;
        txtPostCode.Text = string.Empty;
        txtPostCode.Enabled = false;
    }

    #endregion

    #region btnHideSearch_Click

    protected void btnHideSearch_Click(Object sender, EventArgs e)
    {
        advancedSearch.Visible = false;
        buttonSearch.Visible = false;
        btnSearch.Visible = true;
        btnShowSearch.Visible = true;
        btnHideSearch.Visible = false;
        installerCompanyName.Text = string.Empty;
        txtPostCode.Enabled = true;
    }

    #endregion

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            lblInstaller.Text = string.Empty;
            LinqToSqlDataContext dataCtxt = new LinqToSqlDataContext();
            string installerName = installerCompanyName.Text.Trim().ToLower();
            string postCode = txtPostCode.Text.Trim().ToLower();
            List<GetInstallersByNameOrPostCodeResult> installerQry = dataCtxt.GetInstallersByNameOrPostCode(installerName, postCode, Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()])).ToList();
            var listCount = installerQry.Count();
            if (listCount > 0)
            {
                rptInstallerCompanies.DataSource = installerQry;
                rptInstallerCompanies.DataBind();
                lblErrorMessage.Text = string.Empty;
            }
            else
            {
                rptInstallerCompanies.DataSource = null;
                rptInstallerCompanies.DataBind();
                lblErrorMessage.Text = "No Installers match your search criteria, please try again.";
            }
        }
        catch (Exception exp)
        {
            ListItem item = new ListItem();
            item.Text = "Error Loading.. ";
        }
    }

    protected void Clear_Click(object sender, EventArgs e)
    {
        Clear();
        Session[enumSessions.SelectedInstaller.ToString()] = null;
        Session[enumSessions.InstallerCompanyID.ToString()] = null;
    }

    public void Clear()
    {
        //Clear current items
        installerCompanyName.Text = string.Empty;
        txtPostCode.Text = string.Empty;
        rptInstallerCompanies.DataSource = null;
        rptInstallerCompanies.DataBind();
        lblErrorMessage.Text = string.Empty;
        lblInstaller.Text = string.Empty;
    }

    public void PopulateAwaitingtoBeProcessedList()
    {
        db = new LinqToSqlDataContext();
        var DrData = from data in db.UpDowngrades
                     where data.UserId == Session[enumSessions.User_Id.ToString()].ToString() && data.Emailed == false
                     && data.AwaitingtobeProcessed == true

                     select data;
        rptAwaitingtobeProcessed.DataSource = DrData;
        rptAwaitingtobeProcessed.DataBind();
        if (DrData.Any())
        {
            PnlAwaitingtoBeProcessed.Visible = true;
        }
        else
        {
            PnlAwaitingtoBeProcessed.Visible = false;
        }
    }


    protected void rptInstallerCompanies_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        try
        {
            db = new LinqToSqlDataContext();
            Session[enumSessions.SelectedInstaller.ToString()] = e.CommandName;
            Session[enumSessions.InstallerCompanyID.ToString()] = e.CommandArgument;
            Guid instCompId = new Guid(e.CommandArgument.ToString());

            var installerDetail = (from inst in db.Installers
                                   where inst.InstallerCompanyID == instCompId
                                   select inst).FirstOrDefault();
            var installerAddress = (from addr in db.InstallerAddresses
                                    where addr.AddressID == installerDetail.AddressID
                                    select addr).FirstOrDefault();
            string installer = "<br/><strong>" + installerDetail.CompanyName.ToString() + "</strong><br/>" + installerDetail.Accreditation + ", CSL Code: " + installerDetail.UniqueCode + "<br/>" +
                installerAddress.AddressOne + ", " + installerAddress.AddressTwo + "<br/>" + installerAddress.Town + ", " + installerAddress.County + "<br/>" +
                installerAddress.PostCode + "<br/>" + installerAddress.Country;
            Clear();
            lblInstaller.Text = "Selected Installer: " + installer;
        }
        catch (System.Threading.ThreadAbortException ex)
        {
            //
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), ((System.Reflection.MemberInfo)(objException.TargetSite)).Name, Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }
    private void ClearSelection()
    {
        esn_sim.Text = "";
        nua_data.Text = "";
        chip.Text = "";
        SelectedEMNo.Text = "";
        ddlReason.SelectedIndex = 0;
        UnlockSelection();
    }

    private void LockSelection()
    {
        esn_sim.Enabled = false;
        nua_data.Enabled = false;
        chip.Enabled = false;
        SelectedEMNo.Enabled = false;
    }

    private void UnlockSelection()
    {
        esn_sim.Enabled = true;
        nua_data.Enabled = true;
        chip.Enabled = true;
        SelectedEMNo.Enabled = true;
    }

}