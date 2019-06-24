using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ADMIN_AdminMaster : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    { }

    protected void btnLogOut_Click(object sender, EventArgs e)
    {
        try
        {
            Response.Cache.SetExpires(DateTime.UtcNow.AddMilliseconds(-1));
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();

            Session[enumSessions.IsUserSuperAdmin.ToString()] = null;
            Session[enumSessions.User_Id.ToString()] = null;
            Session.Clear();

            System.Web.Security.FormsAuthentication.SignOut();
            Response.Redirect("~/Login.aspx", false);
        }
        catch (System.Threading.ThreadAbortException ex)
        {
            //
        }
        catch (Exception objException)
        {

            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnLogOut_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    public void LoadUserInfo()
    {
        btnLogOut.Visible = false;
        if (Session[enumSessions.User_Id.ToString()] != null 
            && Session[enumSessions.User_Id.ToString()].ToString() != null
            || HttpContext.Current.User.Identity.IsAuthenticated)
        {
            lblUsername.Text = Session[enumSessions.User_Name.ToString()] != null ? Session[enumSessions.User_Name.ToString()].ToString() : HttpContext.Current.User.Identity.Name;
            btnLogOut.Visible = true;
        }
        else
            lblUsername.Text = "Guest";
    }

    protected override void OnPreRender(EventArgs e)
    {
        try
        {
            base.OnPreRender(e);
            LoadUserInfo();
        }
        catch (Exception objException)
        {

            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "OnPreRender", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }
}
