using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;
using CSLOrderingARCBAL.BAL;



public partial class Modules_Installers : System.Web.UI.UserControl
{

    string alertMsg = "";
    public delegate void customHandler(object sender);
    public event customHandler getBulkuploadOrderItems;
    public string SelectedInstallerCompanyName
    {
        get
        {
            if (ddlInstallers.SelectedItem != null)
            {
                return ddlInstallers.SelectedItem.Text;
            }
            else
            {
                return null;
            }
        }
    }

    public string SelectedInstallerCompanyID
    {
        get
        {
            if (ddlInstallers.SelectedItem != null)
            {
                return ddlInstallers.SelectedValue;
            }
            else
            {
                return null;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void Clear_Click(object sender, EventArgs e)
    {
        //Clear current items
        ltrCompanyInfo.Text = "";
        installerCompanyName.Text = "";
        ddlInstallers.Items.Clear();
        ddlInstallers.DataBind();
        AjaxControlToolkit.ModalPopupExtender mpInstaller = Parent.FindControl("mpInstaller") as AjaxControlToolkit.ModalPopupExtender;
        if (mpInstaller != null)
            mpInstaller.Show();
    }

    //Load Installers from DB
    protected void SelectHeadOffice_Click(object sender, EventArgs e)
    {
        //Clear current items
        ddlInstallers.Items.Clear();
        ddlInstallers.DataBind();
        AjaxControlToolkit.ModalPopupExtender mpInstaller = Parent.FindControl("mpInstaller") as AjaxControlToolkit.ModalPopupExtender;
        if (mpInstaller != null)
            mpInstaller.Show();
        string installerName = installerCompanyName.Text.Trim().ToLower();
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

            if (ddlInstallers != null && ddlInstallers.Items.Count > 0)
                ddlInstallers_SelectedIndexChanged(null, null);
            else
                ltrCompanyInfo.Text = "";

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

    public void SetSelectedInstaller(string installerName, string installerID)
    {
        ListItem item = new ListItem(installerName, installerID);
        ddlInstallers.SelectedIndex = ddlInstallers.Items.IndexOf(item);
        AjaxControlToolkit.ModalPopupExtender mpInstaller = Parent.FindControl("mpInstaller") as AjaxControlToolkit.ModalPopupExtender;
        if (mpInstaller != null)
            mpInstaller.Show();
    }


    protected void ddlInstallers_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            if (ddlInstallers.SelectedIndex > -1)
            {
                Guid InstallerID = new Guid(ddlInstallers.SelectedValue);
                LinqToSqlDataContext dataCtxt = new LinqToSqlDataContext();

                var InstallerDetails = (from instDtls in dataCtxt.VW_InstallerDetails
                                        where instDtls.InstallerCompanyID == InstallerID
                                        select instDtls).FirstOrDefault();

                //var Installer = (from installers in dataCtxt.Installers
                //                 where
                //                 installers.InstallerCompanyID == InstallerID
                //                 select installers).FirstOrDefault();
                //var address = (from add in dataCtxt.InstallerAddresses
                //               where add.AddressID == Installer.AddressID
                //               select add).FirstOrDefault();

                string strCompanyInfo = "";
                strCompanyInfo = "<br/><b>" + strCompanyInfo + InstallerDetails.CompanyName + "</b><br/>";
                strCompanyInfo = strCompanyInfo + (String.IsNullOrEmpty(InstallerDetails.Accreditation) ? ("Acc: " + InstallerDetails.Accreditation + "<br/>") : "");
                strCompanyInfo = strCompanyInfo + "CSL Code: " + InstallerDetails.UniqueCode + "<br/>";
                strCompanyInfo = strCompanyInfo + InstallerDetails.AddressOne + ", " + InstallerDetails.AddressTwo + "<br/>";
                strCompanyInfo = strCompanyInfo + InstallerDetails.Town + ", " + InstallerDetails.County + "<br/>";
                strCompanyInfo = strCompanyInfo + InstallerDetails.PostCode + "<br/>";
                strCompanyInfo = strCompanyInfo + InstallerDetails.Country + "<br/>";

                ltrCompanyInfo.Text = strCompanyInfo;
                Session[enumSessions.SelectedInstaller.ToString()] = ddlInstallers.SelectedItem.Text;
                Session[enumSessions.InstallerCompanyID.ToString()] = ddlInstallers.SelectedValue.ToString();
                AjaxControlToolkit.ModalPopupExtender mpInstaller = Parent.FindControl("mpInstaller") as AjaxControlToolkit.ModalPopupExtender;
                if (mpInstaller != null)
                    mpInstaller.Show();
            }
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), ((System.Reflection.MemberInfo)(objException.TargetSite)).Name, Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    protected void Select_Click(object sender, EventArgs e)
    {

        try
        {
            if (ddlInstallers.SelectedIndex > -1)
            {
                Session[enumSessions.SelectedInstaller.ToString()] = ddlInstallers.SelectedItem.Text;
                Session[enumSessions.InstallerCompanyID.ToString()] = ddlInstallers.SelectedValue.ToString();
                LinqToSqlDataContext dataCtxt = new LinqToSqlDataContext();
                if (Session[enumSessions.BulkUploadMultipleOrderId.ToString()] != null)
                {
                    int addressId = 0;
                    dataCtxt.USP_SaveInstallerDetailsInOrder(Session[enumSessions.InstallerCompanyID.ToString()].ToString(), Convert.ToInt32(Session[enumSessions.BulkUploadMultipleOrderId.ToString()]));
                    var insContactName = (from insAdd in dataCtxt.InstallerAddresses
                                          join ins in dataCtxt.Installers on insAdd.AddressID equals ins.AddressID
                                          where ins.InstallerCompanyID == new Guid(Session[enumSessions.InstallerCompanyID.ToString()].ToString())
                                          select insAdd.ContactName).Single();
                    if (insContactName != null)
                        addressId = InstallerBAL.SaveInstallerAddress(Session[enumSessions.InstallerCompanyID.ToString()].ToString(), insContactName, "", 0, "", "", "", "", "", "", Session[enumSessions.User_Name.ToString()].ToString());
                    var orderDetail = dataCtxt.Orders.Single(x => x.OrderId == Convert.ToInt32(Session[enumSessions.BulkUploadMultipleOrderId.ToString()]));
                    if (orderDetail.DeliveryAddressId == 0)
                    {
                        orderDetail.DeliveryAddressId = addressId;
                    }
                    orderDetail.ModifiedBy = Session[enumSessions.User_Name.ToString()].ToString();
                    orderDetail.ModifiedOn = DateTime.Now;
                    dataCtxt.SubmitChanges();
                    getBulkuploadOrderItems(e);
                    // Session[enumSessions.BulkUploadMultipleOrderId.ToString()] = null;
                    AjaxControlToolkit.ModalPopupExtender mpInstaller = Parent.FindControl("mpInstaller") as AjaxControlToolkit.ModalPopupExtender;
                    mpInstaller.Hide();
                   
                }
                else
                {
                    dataCtxt.USP_SaveInstallerDetailsInOrder(Session[enumSessions.InstallerCompanyID.ToString()].ToString(), Convert.ToInt32(Session[enumSessions.OrderId.ToString()]));
                    dataCtxt.Dispose();
                    Response.Redirect("Checkout.aspx");
                }
            }
            else
            {
                string script = "alertify.alert('" + ltrSelect.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
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
            db.USP_SaveErrorDetails(Request.Url.ToString(), ((System.Reflection.MemberInfo)(objException.TargetSite)).Name, Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }
}
