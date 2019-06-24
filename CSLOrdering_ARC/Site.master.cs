using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;
using CSLOrderingARCBAL.BAL;

public partial class SiteMaster : System.Web.UI.MasterPage
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            ltrErrorMsg.Text = "";
            Response.Cache.SetExpires(DateTime.UtcNow.AddMilliseconds(-1));
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            Response.AppendHeader("Pragma", "no-cache");
            Page.Header.DataBind();

        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    public String basketProducts = string.Empty;
    public void LoadUserInfo()
    {
        if (Session[enumSessions.User_Id.ToString()] != null)
        {
            ARC arc = ArcBAL.GetArcInfoByUserId(new Guid(Session[enumSessions.User_Id.ToString()].ToString()));

            if (arc == null)
            {
                ltrErrorMsg.Text = "User does not belong to any ARC.";
                return;
            }

            if (arc.IsBulkUploadAllowed)
                hyprLnkBulkUpload.Visible = true;

            Session[enumSessions.ARC_Id.ToString()] = arc.ARCId;
            Session[enumSessions.IsARC_AllowReturns.ToString()] = arc.AllowReturns;

            lblUsername.Text = Session[enumSessions.User_Name.ToString()].ToString();

            if (arc.CompanyName.Length > 30)
                lblARCCompany.Text = arc.CompanyName.Substring(0, 30) + "...";
            else
                lblARCCompany.Text = arc.CompanyName;

            LinqToSqlDataContext db = new LinqToSqlDataContext();
            var OrderInfo = db.USP_CreateOrderForUser(arc.ARCId, Session[enumSessions.User_Name.ToString()].ToString(), Session[enumSessions.User_Name.ToString()].ToString(), Session[enumSessions.User_Email.ToString()].ToString(),Session[enumSessions.User_Id.ToString()].ToString()).SingleOrDefault();
            if (OrderInfo != null)
            {
                Session[enumSessions.OrderId.ToString()] = OrderInfo.OrderId;
                lblOrderTotal.Text = OrderInfo.Amount.ToString();
                Session[enumSessions.HasUserAcceptedDuplicates.ToString()] = OrderInfo.HasUserAcceptedDuplicates;
                lblBasket.Text = OrderInfo.Quantity.ToString();
                Session[enumSessions.OrderNumber.ToString()] = OrderInfo.OrderNo.ToString();
                basketProducts = db.OrderItems.Where(num => num.OrderId == Convert.ToInt32(Session[enumSessions.OrderId.ToString()])).Count().ToString();
                if (basketProducts == "0")
                {
                    basketProducts = string.Empty;
                }
                
                
                if (OrderInfo.InstallerId != "0")
                {
                    Session[enumSessions.InstallerCompanyID.ToString()] = OrderInfo.InstallerId;
                    Session[enumSessions.SelectedInstaller.ToString()] = OrderInfo.SelectedInstaller;
                }
            }
            db.Dispose();

            if (Session[enumSessions.User_Role.ToString()] != null && Session[enumSessions.User_Role.ToString()].ToString() == enumRoles.ARC_Admin.ToString())
            {
                lblOrderTotal.Text = "0.00";
                
               // AarcadminMenu.Style.Add("visibility", "visible");
               
            }
            Amyacc.Style.Add("visibility", "visible"); // Visible for all 

            if (Session[enumSessions.SelectedInstaller.ToString()] != null)
                if (Session[enumSessions.SelectedInstaller.ToString()].ToString().Length > 30)
                    lblInstallerName.Text = Session[enumSessions.SelectedInstaller.ToString()].ToString().Substring(0, 30) + "...";
                else
                    lblInstallerName.Text = Session[enumSessions.SelectedInstaller.ToString()].ToString();

            if (Session[enumSessions.InstallerCompanyID.ToString()] != null)
            {
                HyperLink1.Enabled = true;
            }
            btnLogOut.Visible = true;
        }
        else
        {
            lblUsername.Text = "Guest";
            lblARCCompany.Text = "Guest";
            lblBasket.Text = "0";
            lblOrderTotal.Text = "0.00";
            lblInstallerName.Text = "";

        }
    }

    protected override void OnPreRender(EventArgs e)
    {
        try
        {
            if (HttpContext.Current.User.Identity.IsAuthenticated)
            {
               //upnlUserInfo.Visible = true;//commented by atiq on 28-mar-2016
               divTopMenu.Visible = true;
               divLoginInfo.Visible = true;
               LoadUserInfo();
            }
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "OnPreRender", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    protected void btnLogOut_Click(object sender, EventArgs e)
    {
        Response.Cache.SetExpires(DateTime.UtcNow.AddMilliseconds(-1));
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetNoStore();
        Session[enumSessions.User_Id.ToString()] = null;
        System.Web.Security.FormsAuthentication.SignOut();
        Session.Abandon();
        Response.Redirect("~/Login.aspx");
    }
    
    public string GetBasketQty()
    {
        return lblBasket.Text;
    }

    public string GetBasketAmount()
    {
        return lblOrderTotal.Text;
    }

  
}
