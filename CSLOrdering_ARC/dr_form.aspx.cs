using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;
using CSLOrderingARCBAL.BAL;
using CSLOrderingARCBAL.Common;
using System.Web.Mail;
using System.Configuration;
using System.Text;
using System.Web.UI.HtmlControls;
using MSMQSendEmailToQueueLibrary;


public partial class dr_form : System.Web.UI.Page
{
    #region Variable

    LinqToSqlDataContext db;
    string UserEmail = String.Empty;
    string CompanyName = String.Empty;
    string UserName = String.Empty;
    string smtphost = String.Empty;
    string mailFrom = String.Empty;
    string mailCC = String.Empty;
    string mailTO = String.Empty;
    String arcCC = String.Empty;
    bool enablePostCodeSearch;
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Session[enumSessions.User_Id.ToString()] == null || Session[enumSessions.User_Name.ToString()] == null 
                || Session[enumSessions.User_Email.ToString()] == null || Session[enumSessions.ARC_Id.ToString()] == null)
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
            db.Dispose();
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


        //if (string.IsNullOrEmpty((string)HttpRuntime.Cache["ARCCC"]))
        //{
        //    AppSettings appsett = new AppSettings();
        //    appdto = appsett.GetAppValues();
        //    arcCC = appdto.ARC_CC;
        //}
        //else
        //    arcCC = (string)HttpRuntime.Cache["ARCCC"];


        //---------------------------------------------------------------------------------------
        if (string.IsNullOrEmpty(Request["dr"]))
        {
            Response.Redirect("categories.aspx");
        }
        if (Request["dr"].ToString() == "r")
        {
            lblTitle.Text = "Reconnection Request Form";
            ddlTitle.Visible = false;
            ddlReason.Visible = false;
            disText.Visible = false;
            recText.Visible = true;
            chkConfirm.Visible = false;
            chkConfirm.Text = "By ticking this box you are instructing CSL to reactivate this unit";

        }
        else
        {
            lblTitle.Text = "Disconnection Request Form";
            ddlTitle.Visible = true;
            ddlReason.Visible = true;
            disText.Visible = true;
            recText.Visible = false;
            chkConfirm.Visible = true;
            chkConfirm.Text = "By ticking this box you are instructing CSL to remove this unit from all signalling";

        }
        if (!IsPostBack)
        {
            Button ucbtn = (Button)Installers.FindControl("btnSelect");
            ucbtn.Visible = false;
            //Button ucbtnPC = (Button)rptInstallerCompanies.FindControl("btnSelect");
            //ucbtnPC.Visible = false;
            btnSubmit.Visible = false;
            divuc1.Visible = true;
            divuc2.Visible = true;

            db = new LinqToSqlDataContext();
            var DltData = (from data in db.DRs
                           where data.UserId == Convert.ToString(Session[enumSessions.User_Id.ToString()]) && data.Emailed == false
                           && data.AwaitingtobeProcessed == false 
                           select data);
            db.DRs.DeleteAllOnSubmit(DltData);
            db.SubmitChanges();

            Session[enumSessions.SelectedInstaller.ToString()] = null;
            Session[enumSessions.InstallerCompanyID.ToString()] = null;

            PopulateAwaitingtoBeProcessedList();
        }

    }

    public void btnSubmit_Click(object sender, EventArgs e)
    {
        DropDownList ddlinstaller = (DropDownList)Installers.FindControl("ddlInstallers");
        if (enablePostCodeSearch == false)
        {
            Session[enumSessions.InstallerCompanyID.ToString()] = ddlinstaller.SelectedValue;
            Session[enumSessions.SelectedInstaller.ToString()] = ddlinstaller.SelectedItem;
        }
        string mycheck = "";
        if (Request["dr"].ToString() == "d")
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



            SendEmailConfirmation();
        }
        else
        {
            lblSubmitConfirm.Visible = true;
        }
        Session[enumSessions.InstallerCompanyID.ToString()] = null;
        Session[enumSessions.SelectedInstaller.ToString()] = null;
    }

    private void SendEmailConfirmation()
    {
        try
        {
            string dr = Request["dr"].ToString();

            if (dr == "d")
            {
                dr = "Disconnect";
            }
            else
            {
                dr = "Reconnect";
            }
            UserName = Session[enumSessions.User_Name.ToString()].ToString();
            UserEmail = Session[enumSessions.User_Email.ToString()].ToString();
            CompanyName = GetARCName(Session[enumSessions.ARC_Id.ToString()].ToString());

            using (db = new LinqToSqlDataContext())
            {
                // ** NOn-edited ones
                var DrData = from d in db.DRs
                             join ins in db.Installers on d.Installer equals ins.InstallerCompanyID.ToString()
                             where d.UserId == Session[enumSessions.User_Id.ToString()].ToString() && d.Emailed == false
                             && d.ISEmizonUnit == false && d.FreeTextEntry != true
                             orderby d.DrId
                             select new { d.Reason, d.Simno, d.Datano, d.Chipno, d.Installer, ins.CompanyName };
                if (DrData.Any())
                {
                    String EmailDevicelist = "<table cellspacing='1' cellpadding='1' border='1' Width=\"60%\"><tr ><td style=\"color: #888;\"><b>Request Type</b></td><td style=\"color: #888;\"><b>Reason</b></td><td style=\"color: #888;\"><b>ESN/SIM</b></td><td style=\"color: #888;\"><b>NUA/Data</b></td><td style=\"color: #888;\"><b>Chip Number</b></td><td style=\"color: #888;\"><b>Installer</b></td></tr>";
                    foreach (var d in DrData)
                    {
                        EmailDevicelist += "<tr>";
                        if (dr == "Reconnect")
                        {
                            EmailDevicelist += "<td td style=\"color: #45b010;\">" + dr + "</td>"; //green
                        }
                        else if (dr == "Disconnect")
                        {
                            EmailDevicelist += "<td td style=\"color: #f64114;\">" + dr + "</td>"; //red
                        }
                        string szReason = "";
                        if (Request["dr"].ToString() == "r")
                        {
                            szReason = "n/a";
                        }
                        else
                        {
                            szReason = d.Reason;
                        }
                        EmailDevicelist += "<td>" + szReason + "</td>";
                        EmailDevicelist += "<td>" + d.Simno + "</td>";
                        EmailDevicelist += "<td>" + d.Datano + "</td>";
                        EmailDevicelist += "<td>" + d.Chipno + "</td>";
                        EmailDevicelist += "<td>" + GetInstallerName(d.Installer) + "</td>";
                        EmailDevicelist += "</tr>";
                    }
                    EmailDevicelist += "</table>";
                    String mailHtml = ReadTemplates.ReadMailTemplate(Server.MapPath("Template"), "EmailGrade.html");
                    StringBuilder objBuilder = new StringBuilder();
                    objBuilder.Append(mailHtml);
                    objBuilder.Replace("{UserName}", UserName);
                    objBuilder.Replace("{ArcName}", CompanyName);
                    objBuilder.Replace("{UserEmail}", UserEmail);
                    objBuilder.Replace("{DateofRequest}", DateTime.Now.ToString());
                    objBuilder.Replace("{Devicelist}", EmailDevicelist);
                    string szMess = "";
                    if (Request["dr"].ToString() == "r")
                    {
                        szMess = "Reconnection Request";
                    }
                    else
                    {
                        szMess = "Disconnection Request";
                    }
                    SendEmailMessage sendEmail = new SendEmailMessage();
                    EmailMessage cslEmailMessage = new EmailMessage();
                    cslEmailMessage.From = mailFrom;
                    cslEmailMessage.To = UserEmail + ";" + (Request["dr"].ToString() == "r" ? mailTO : string.Empty); 
                    cslEmailMessage.CC = mailCC + ";" + GetArcCcEmail(Session[enumSessions.ARC_Id.ToString()].ToString());
                    cslEmailMessage.BCC = "";
                    cslEmailMessage.Subject = szMess;
                    cslEmailMessage.Message = Convert.ToString(objBuilder.ToString());
                    //adding emails to MSMQ 
                    sendEmail.SendEmailMessageToQueue(ConfigurationManager.AppSettings["QueueName"].ToString(), cslEmailMessage);
                }
                    // ** Free Text  ones

                    var DrDataFreeText = from d in db.DRs
                             join ins in db.Installers on d.Installer equals ins.InstallerCompanyID.ToString()
                             where d.UserId == Session[enumSessions.User_Id.ToString()].ToString() && d.Emailed == false
                             && d.ISEmizonUnit == false && d.FreeTextEntry == true
                             orderby d.DrId
                             select new { d.Reason, d.Simno, d.Datano, d.Chipno, d.Installer, ins.CompanyName };
                    if (DrDataFreeText.Any())
                    {
                        String EmailDevicelistFreeText = "<table cellspacing='1' cellpadding='1' border='1' Width=\"60%\"><tr ><td style=\"color: #888;\"><b>Request Type</b></td><td style=\"color: #888;\"><b>Reason</b></td><td style=\"color: #888;\"><b>ESN/SIM</b></td><td style=\"color: #888;\"><b>NUA/Data</b></td><td style=\"color: #888;\"><b>Chip Number</b></td><td style=\"color: #888;\"><b>Installer</b></td></tr>";
                        foreach (var d in DrDataFreeText)
                        {
                            EmailDevicelistFreeText += "<tr>";
                            if (dr == "Reconnect")
                            {
                                EmailDevicelistFreeText += "<td td style=\"color: #45b010;\">" + dr + "</td>"; //green
                            }
                            else if (dr == "Disconnect")
                            {
                                EmailDevicelistFreeText += "<td td style=\"color: #f64114;\">" + dr + "</td>"; //red
                            }
                            string szReason = "";
                            if (Request["dr"].ToString() == "r")
                            {
                                szReason = "n/a";
                            }
                            else
                            {
                                szReason = d.Reason;
                            }
                            EmailDevicelistFreeText += "<td>" + szReason + "</td>";
                            EmailDevicelistFreeText += "<td>" + d.Simno + "</td>";
                            EmailDevicelistFreeText += "<td>" + d.Datano + "</td>";
                            EmailDevicelistFreeText += "<td>" + d.Chipno + "</td>";
                            EmailDevicelistFreeText += "<td>" + GetInstallerName(d.Installer) + "</td>";
                            EmailDevicelistFreeText += "</tr>";
                        }
                        EmailDevicelistFreeText += "</table>";
                        String mailHtmlFreeText = ReadTemplates.ReadMailTemplate(Server.MapPath("Template"), "EmailGrade.html");
                        StringBuilder objBuilderFreeText = new StringBuilder();
                        objBuilderFreeText.Append(mailHtmlFreeText);
                        objBuilderFreeText.Replace("{UserName}", UserName);
                        objBuilderFreeText.Replace("{ArcName}", CompanyName);
                        objBuilderFreeText.Replace("{UserEmail}", UserEmail);
                        objBuilderFreeText.Replace("{DateofRequest}", DateTime.Now.ToString());
                        objBuilderFreeText.Replace("{Devicelist}", EmailDevicelistFreeText);
                        string szMessFreeText = "";
                        if (Request["dr"].ToString() == "r")
                        {
                            szMessFreeText = "Reconnection Request";
                        }
                        else
                        {
                            szMessFreeText = "Disconnection Request";
                        }
                        SendEmailMessage sendEmailFreeText = new SendEmailMessage();
                        EmailMessage cslEmailMessageFreeText = new EmailMessage();
                        cslEmailMessageFreeText.From = mailFrom;
                        cslEmailMessageFreeText.To = UserEmail;
                        cslEmailMessageFreeText.CC = mailTO + ";" + mailCC + ";" + GetArcCcEmail(Session[enumSessions.ARC_Id.ToString()].ToString());
                        cslEmailMessageFreeText.BCC = "";
                        cslEmailMessageFreeText.Subject = szMessFreeText;
                        cslEmailMessageFreeText.Message = Convert.ToString(objBuilderFreeText.ToString());
                        //adding emails to MSMQ 
                        sendEmailFreeText.SendEmailMessageToQueue(ConfigurationManager.AppSettings["QueueName"].ToString(), cslEmailMessageFreeText);
                    }


                    var upData = (from data in db.DRs
                                  where data.UserId == Session[enumSessions.User_Id.ToString()].ToString() && data.Emailed == false
                                  && data.ISEmizonUnit == false
                                  select data);
                    foreach (var r in upData)
                    {
                        r.Emailed = true;
                    }
                    db.SubmitChanges();

                // ** Flag Emizon units                   
                var EmizonUnits = (from data in db.DRs
                                   where data.UserId == Session[enumSessions.User_Id.ToString()].ToString()
                                   && data.ISEmizonUnit == true
                                   select data);

                if (EmizonUnits.Any())
                {
                    foreach (var r in EmizonUnits)
                    {
                        r.AwaitingtobeProcessed = true;
                    }
                    db.SubmitChanges();
                }
            }
            pnlForm.Visible = false;
            pnlConfirm.Visible = true;
            divuc1.Visible = false;
            divuc2.Visible = false;
            txtChipNo.Text = "";
        }
        catch (Exception objException)
        {
            using (db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSubmit_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
    }

    public void btnAdd_Click(object sender, EventArgs e)
    {
        DropDownList ddlinstaller = (DropDownList)Installers.FindControl("ddlInstallers");
        if (esn_sim.Text.Length == 0 && nua_data.Text.Length == 0 && chip.Text.Length == 0 && SelectedEMNo.Text.Length == 0)
        {
            lblValidation.Visible = true;
            lblDropValid.Visible = false;
            pnlConfirm.Visible = false;
        }
        else if ((Session[enumSessions.SelectedInstaller.ToString()] == null && enablePostCodeSearch == true) || (ddlinstaller.SelectedValue == "" && enablePostCodeSearch == false))
        {
            lblValidation.Visible = false;
            lblDropValid.Visible = true;
            pnlConfirm.Visible = false;
        }
        else
        {
            lblValidation.Visible = false;
            lblDropValid.Visible = false;

            if (Request.QueryString["dr"].ToString() == "d")
            {
                if (SelectedEMNo.Text.Length > 0 && SelectedEMNo.Text != "&nbsp;") // ** Emizon
                {
                    if (string.IsNullOrWhiteSpace(SelectedEMNo.Text))
                    {
                        string script = "alertify.alert('" + "Valid EMNo is required." + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        return;
                    }

                    if (IsInDisconnectionslist(SelectedEMNo.Text))
                    {
                        string script = "alertify.alert('" + "Unit on Disconnections list already" + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        return;
                    }

                    int RequestReference = EmizonService.AddtoEmizonRequestQueue(SelectedEMNo.Text, typeof(Emizon.APIModels.MSMQTypes.QueueReadytoCease).Name);
                    string emizonQueuePath = ConfigurationManager.AppSettings["EmizonQueue"].ToString();
                    EmizonOrderController.AddtoMSMQ(emizonQueuePath, new Emizon.APIModels.MSMQTypes.QueueReadytoCease()
                    {
                        em_no = SelectedEMNo.Text.Trim(),
                        arc_no = ArcBAL.GetEmizonArcNobyARCID(Session[enumSessions.ARC_Id.ToString()].ToString()),
                        CSLRefNo = RequestReference.ToString()
                    });

                    string ResponseMessage = string.Empty;
                    string ResponseVal = EmizonService.WaitandGetResponse(RequestReference, ref ResponseMessage);

                    if (string.IsNullOrEmpty(ResponseVal))
                    {
                        string script = "alertify.alert('" + "Unable to verify if unit can be disconnected, please try again later" + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);

                        return;
                    }
                    else if (ResponseVal != "0")
                    {
                        string script = "alertify.alert('" + "Unit not ready for disconnection due to : " + ResponseMessage + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);

                        return;
                    }
                    else
                    {
                        ProceedwithRequest(true);
                        return;
                    }
                }
                else // ** CSL Unit 
                {
                    if (!string.IsNullOrWhiteSpace(esn_sim.Text))
                    {
                        if (HighilghtRecentPolling(esn_sim.Text))
                        {
                            ProceedwithRequest();
                            string script = "alertify.alert('" + "Please note this Unit has been active in the last 7 days." + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            return;
                        }
                    }
                }
            }
            ProceedwithRequest();
        }

    }

    private bool HighilghtRecentPolling(string SIMNumber)
    {
        db = new LinqToSqlDataContext();
        bool HighilghtRecentPolling = db.USP_HighlightRecentPolling(SIMNumber).SingleOrDefault().PolledRecently.Value;
        return HighilghtRecentPolling; 
    }

    private bool IsInDisconnectionslist(string EMNo)
    {
        db = new LinqToSqlDataContext();
        var DrData = from data in db.DRs
                     where data.EMNo == EMNo
                     && data.AwaitingtobeProcessed == true 
                     select data;
        if (DrData.Any())
        { return true; }
        else { return false; }
    }

    public void ProceedwithRequest(bool isEmizonDevice = false)
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
                    //lblAddItem.Visible=true;
                    return;
                }
            }
        }

        string dr = "";
        if (Request.QueryString["dr"].ToString() == "d")
        {
            dr = "Disconnect";
        }
        else
        {
            dr = "Reconnect";
        }



        DR drdata = new DR();

        drdata.ArcId = Session[enumSessions.ARC_Id.ToString()].ToString();
        drdata.Chipno = chip.Text.ToString();
        drdata.Datano = nua_data.Text.ToString();
        drdata.date = DateTime.Now.ToString();
        if (enablePostCodeSearch == true)
        {
            drdata.Installer = Session[enumSessions.InstallerCompanyID.ToString()].ToString().ToLower();
        }
        else
        {
            drdata.Installer = ddlinstaller.SelectedValue.ToString().ToLower();
        }
        if (Request["dr"].ToString() == "r")
        {
            drdata.Reason = "";
        }
        else
        {
            drdata.Reason = ddlReason.SelectedValue.ToString();
        }
        drdata.Req_Type = dr;
        drdata.Simno = esn_sim.Text.ToString();
        drdata.Emailed = false;
        drdata.UserId = Session[enumSessions.User_Id.ToString()].ToString();
        drdata.EMNo = SelectedEMNo.Text.Trim(); 
        drdata.ISEmizonUnit = isEmizonDevice;
        drdata.UserName = Session[enumSessions.User_Name.ToString()].ToString();
        drdata.UserEmail = Session[enumSessions.User_Email.ToString()].ToString();
        drdata.TobeUpdatedOnBOS = false;
        drdata.UpdatedOnBOS = false;
        drdata.NoofAttempts = 0;
        drdata.FreeTextEntry = (esn_sim.Enabled ) ?  true : false ; 

        if (isEmizonDevice)
        {
            drdata.EM_Platform = ArcBAL.GetEmizonPlatformbyARCID(Session[enumSessions.ARC_Id.ToString()].ToString());
        }
        
        db.DRs.InsertOnSubmit(drdata);
        db.SubmitChanges();
        ClearSelection();
        PopulateList();
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

    public void PopulateList()
    {
        db = new LinqToSqlDataContext();
        var DrData = from data in db.DRs
                     where data.UserId == Session[enumSessions.User_Id.ToString()].ToString() && data.Emailed == false
                     && data.AwaitingtobeProcessed == false 

                     select data;
        rpList.DataSource = DrData;
        rpList.DataBind();
        if (DrData.Any())
        {
            btnSubmit.Visible = true;
        }
        else
        {
            btnSubmit.Visible = false;
        }
    }


    public void PopulateAwaitingtoBeProcessedList()
    {
        db = new LinqToSqlDataContext();
        var DrData = from data in db.DRs
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



    public void btnRemove_Click(object sender, CommandEventArgs e)
    {
        db = new LinqToSqlDataContext();
        int id = Convert.ToInt32(e.CommandArgument);
        var DltData = (from data in db.DRs
                       where data.DrId == id
                       select data).SingleOrDefault();
        db.DRs.DeleteOnSubmit(DltData);
        db.SubmitChanges();
        String Notes = "DRID:" + DltData.DrId.ToString() + ";EMNo:" + DltData.EMNo.ToString();
        AuditEntry(Notes);
        PopulateList();
        PopulateAwaitingtoBeProcessedList();
    }
    public string GetInstallerName()
    {
        return Session[enumSessions.SelectedInstaller.ToString()].ToString();
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


    public string GetInstallerName(string id)
    {
        db = new LinqToSqlDataContext();
        string returnstring = "";
        returnstring = (from inst in db.Installers
                        where inst.InstallerCompanyID == new Guid(id)
                        select inst.CompanyName).SingleOrDefault();
        return returnstring;
    }

    public string GetARCName(string id)
    {

        db = new LinqToSqlDataContext();
        string returnstring = "";
        returnstring = (from arc in db.ARCs
                        where arc.ARCId == Convert.ToInt32(id)
                        select arc.CompanyName).SingleOrDefault();

        return returnstring;
        // db.Dispose();

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
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                int id = Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()]);
                string chipNo = txtChipNo.Text.Trim();
                string dataNo = txtDatano.Text.Trim();
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
                    gvDevicelist.SelectedIndex = 0;
                    gvDevicelist_SelectedIndexChanged(sender, e);
                }
            }
        }
        catch (Exception objException)
        {
            string script = "alertify.alert('" + ltrDetails.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            esn_sim.Text = ""; nua_data.Text = ""; chip.Text = ""; SelectedEMNo.Text = "";
            using (LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "GetDevice_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Name.ToString()]));
            }
        }

    }

    protected void gvDevicelist_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            int selectedRow = gvDevicelist.SelectedIndex;
            if (gvDevicelist.Rows.Count > 0)
            {
                chip.Text = Server.HtmlDecode(gvDevicelist.Rows[selectedRow].Cells[1].Text).Trim();
                nua_data.Text = Server.HtmlDecode(gvDevicelist.Rows[selectedRow].Cells[2].Text).Trim();
                esn_sim.Text = Server.HtmlDecode(gvDevicelist.Rows[selectedRow].Cells[3].Text).Trim();
                SelectedEMNo.Text = Server.HtmlDecode(gvDevicelist.Rows[selectedRow].Cells[4].Text).Trim();
                int Dev_Inst_UnqCode = Convert.ToInt32(gvDevicelist.DataKeys[selectedRow].Values["Dev_Inst_UnqCode"].ToString());
                if (Dev_Inst_UnqCode != 0)
                {
                    VW_InstallerDetail installer = CSLOrderingARCBAL.BAL.InstallerBAL.GetInstaller(Dev_Inst_UnqCode.ToString());
                    if (installer != null)
                    {
                        TextBox txtInstaller;
                        if (enablePostCodeSearch)
                        {
                            txtInstaller = (TextBox)Installers.FindControl("installerCompanyName");
                        }
                        else
                        {
                            txtInstaller = (TextBox)Installers.FindControl("installerCompanyName");
                            Button btnSearch = (Button)Installers.FindControl("btnSearch");
                        }
                        txtInstaller.Text = installer.CompanyName;
                    }
                }
                LockSelection();

            }
        }
        catch (Exception objException)
        {

            using(LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext())
            {
              db.USP_SaveErrorDetails(Request.Url.ToString(), "gvDevicelist_SelectedIndexChanged", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Name.ToString()]));
            }
        }

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
}





