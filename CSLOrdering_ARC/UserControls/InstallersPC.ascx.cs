using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;
using CSLOrderingARCBAL.BAL;



public partial class Modules_InstallersPC : System.Web.UI.UserControl
{

    string alertMsg = "";

    public delegate void customHandler(object sender);
    public event customHandler getBulkuploadOrderItems;
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void Clear_Click(object sender, EventArgs e)
    {
        //Clear current items
        installerCompanyName.Text = "";
        txtPostCode.Text = "";
        rptInstallerCompanies.DataSource = null;
        rptInstallerCompanies.DataBind();
        lblErrorMessage.Text = string.Empty;
        AjaxControlToolkit.ModalPopupExtender mpInstaller = Parent.FindControl("mpInstaller") as AjaxControlToolkit.ModalPopupExtender;
        if (mpInstaller != null)
            mpInstaller.Show();
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
        AjaxControlToolkit.ModalPopupExtender mpInstaller = Parent.FindControl("mpInstaller") as AjaxControlToolkit.ModalPopupExtender;
        if (mpInstaller != null)
            mpInstaller.Show();

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
        AjaxControlToolkit.ModalPopupExtender mpInstaller = Parent.FindControl("mpInstaller") as AjaxControlToolkit.ModalPopupExtender;
        if (mpInstaller != null)
            mpInstaller.Show();
    }

    #endregion

    protected void rptInstallerCompanies_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        try
        {
            Session[enumSessions.SelectedInstaller.ToString()] = e.CommandName;
            Session[enumSessions.InstallerCompanyID.ToString()] = e.CommandArgument;
            Session["selectInstaller"] = "selected";
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

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {

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
                string script = "alertify.alert('" + ltrNoMatch.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
            AjaxControlToolkit.ModalPopupExtender mpInstaller = Parent.FindControl("mpInstaller") as AjaxControlToolkit.ModalPopupExtender;
            if (mpInstaller != null)
                mpInstaller.Show();

        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), ((System.Reflection.MemberInfo)(objException.TargetSite)).Name, Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }
}
