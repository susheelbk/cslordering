using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;
using System.Web.Security;
using CSLOrderingARCBAL.Common;
public partial class ADMIN_ManageAppSetting : System.Web.UI.Page
{


    LinqToSqlDataContext db;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindControls();
        }
    }

    protected void BindControls()
    {
        db = new LinqToSqlDataContext();
        try
        {
            List<ApplicationSetting> appsettingList = new List<ApplicationSetting>();
            appsettingList = (from a in db.ApplicationSettings
                              select a
                                  ).ToList();

            ddlAppSetting.DataSource = appsettingList;
            ddlAppSetting.DataTextField = "KeyName";
            ddlAppSetting.DataValueField = "KeyName";
            ddlAppSetting.DataBind();
            foreach (var p in appsettingList)
            {
                if (p.KeyName == ddlAppSetting.SelectedValue)
                    txtAppSetting.Text = p.KeyValue;
            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "Manage AppSetting ->Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }
        finally
        {
            if (db != null)
            {
                db.Dispose();
            }


        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        db = new LinqToSqlDataContext();

        try
        {
            string script = "";
            if (ddlAppSetting.SelectedValue == enumApplicationSetting.smtphost.ToString())
            {
                var smtp = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.smtphost.ToString());
                smtp.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.LogisticsEmail.ToString())
            {
                var logisticsEmail = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.LogisticsEmail.ToString());
                logisticsEmail.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.OrdersEmailFrom.ToString())
            {
                var ordersEmailFrom = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.OrdersEmailFrom.ToString());
                ordersEmailFrom.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.EmailCC.ToString())
            {
                String[] emailId = txtAppSetting.Text.Split(',');

                for (int i = 0; i < emailId.Length; i++)
                {

                    if (!emailId[i].IsEmailValid())
                    {
                        script = "alertify.alert('" + emailId[i] + " is not Valid');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        return;
                    }
                }


                var emailCC = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.EmailCC.ToString());
                emailCC.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.VATRate.ToString())
            {
                var VATRate = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.VATRate.ToString());
                VATRate.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.PendingFileFailedEmailTo.ToString())
            {
                var PendingFileFailedEmailTo = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.PendingFileFailedEmailTo.ToString());
                PendingFileFailedEmailTo.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.DIProductId.ToString())
            {
                var DIProductId = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.DIProductId.ToString());
                DIProductId.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.BillingEmail.ToString())
            {
                var BillingEmail = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.BillingEmail.ToString());
                BillingEmail.KeyValue = txtAppSetting.Text;
            }
            if (ddlAppSetting.SelectedValue == enumApplicationSetting.DefaultARCReceiver.ToString())
            {
                var DefaultARCReceiver = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.DefaultARCReceiver.ToString());
                DefaultARCReceiver.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.G5CategoryCode.ToString())
            {
                var G5CategoryCode = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.G5CategoryCode.ToString());
                G5CategoryCode.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.DUALCOMInsideCategoryID.ToString())
            {
                var DUALCOMInsideCategoryID = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.DUALCOMInsideCategoryID.ToString());
                DUALCOMInsideCategoryID.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.MergeDeliveryTypeId.ToString())
            {
                var MergeDeliveryTypeId = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.MergeDeliveryTypeId.ToString());
                MergeDeliveryTypeId.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.FilteredARCIDs.ToString())
            {
                var FilteredARCIDs = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.FilteredARCIDs.ToString());
                FilteredARCIDs.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.APNServer.ToString())
            {
                var APNServer = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.APNServer.ToString());
                APNServer.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.APNServerIRE.ToString())
            {
                var APNServerIRE = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.APNServerIRE.ToString());
                APNServerIRE.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.APNServerUHS.ToString())
            {
                var APNServerUHS = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.APNServerUHS.ToString());
                APNServerUHS.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.FedexURL.ToString())
            {
                var FedexURL = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.FedexURL.ToString());
                FedexURL.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.InstId.ToString())
            {
                var InstId = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.InstId.ToString());
                InstId.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.M2MImagesPath.ToString())
            {
                var M2MImagesPath = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.M2MImagesPath.ToString());
                M2MImagesPath.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.WebsiteAdminRoles.ToString())
            {
                var WebsiteAdminRoles = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.WebsiteAdminRoles.ToString());
                WebsiteAdminRoles.KeyValue = txtAppSetting.Text;
            }

            if (ddlAppSetting.SelectedValue == enumApplicationSetting.TotalM2MApplications.ToString())
            {
                var TotalM2MApplications = db.ApplicationSettings.FirstOrDefault(c => c.KeyName == enumApplicationSetting.TotalM2MApplications.ToString());
                TotalM2MApplications.KeyValue = txtAppSetting.Text;
            }

            db.SubmitChanges();


            Audit audit = new Audit();
            audit.Notes = ddlAppSetting.SelectedValue.ToString() + ": " + txtAppSetting.Text;
            audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
            audit.ChangeID = Convert.ToInt32(enumAudit.Application_Setting);
            audit.CreatedOn = DateTime.Now;
            audit.IPAddress = Request.UserHostAddress;
            db.Audits.InsertOnSubmit(audit);
            db.SubmitChanges();
            // Load changed data
            BindControls();

            script = "alertify.alert('" + ltrAppSett.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);

        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "Manage AppSetting ->btnSave_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }
        finally
        {
            if (db != null)
            {
                db.Dispose();
            }


        }
    }

    protected void ddlAppSetting_SelectedIndexChanged(object sender, EventArgs e)
    {
        db = new LinqToSqlDataContext();
        List<ApplicationSetting> appsettingList = new List<ApplicationSetting>();
        appsettingList = (from a in db.ApplicationSettings
                          select a
                              ).ToList();

        foreach (var p in appsettingList)
        {
            if (p.KeyName == ddlAppSetting.SelectedValue)
                txtAppSetting.Text = p.KeyValue;
        }
    }
}