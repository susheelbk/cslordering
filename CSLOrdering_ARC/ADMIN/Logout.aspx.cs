using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ADMIN_Logout : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Cache.SetExpires(DateTime.UtcNow.AddMilliseconds(-1));
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetNoStore();

        Session[enumSessions.IsUserSuperAdmin.ToString()] = null;
        Session[enumSessions.User_Id.ToString()] = null;
        Session.Clear();
        Session.Abandon();
        System.Web.Security.FormsAuthentication.SignOut();
        //Response.Redirect("~/Login.aspx", false);
    }
}