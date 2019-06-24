using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class OrderConfirmation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Session[enumSessions.OrderNumber.ToString()] != null)
            {
                lblOrderNumber.Text = "CSL" + Session[enumSessions.OrderNumber.ToString()].ToString();
                Session[enumSessions.OrderNumber.ToString()] = null;
                Session.Remove(enumSessions.OrderNumber.ToString());
            }

            if (Session[enumSessions.OrderRef.ToString()] != null)
            {
                lblOrderRef.Text = Session[enumSessions.OrderRef.ToString()].ToString();
                Session[enumSessions.OrderRef.ToString()] = null;
                Session.Remove(enumSessions.OrderRef.ToString());
            }

            if (Session[enumSessions.SelectedInstaller.ToString()] != null)
            {
                Session[enumSessions.SelectedInstaller.ToString()] = null;
                Session.Remove(enumSessions.SelectedInstaller.ToString());
            }

            if (Session[enumSessions.InstallerCompanyID.ToString()] != null)
            {
                Session[enumSessions.InstallerCompanyID.ToString()] = null;
                Session.Remove(enumSessions.InstallerCompanyID.ToString());
            }
        }
    }

    protected void btnAlertOrderConfirmation_Click(object sender, EventArgs e)
    {
        Response.Redirect(lnkRedirectURL.Value);
    }
}