using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;

public partial class SelectInstaller : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session[enumSessions.User_Id.ToString()] == null)
        {
            Response.Redirect("Login.aspx");
        }
        
        InstallersPC.Visible = false;
        Installers.Visible = false;
        int ARCId = Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()]);
        LinqToSqlDataContext db = new LinqToSqlDataContext();
        var enablePostCodeSearch = (from arc in db.ARCs
                                    where arc.ARCId == ARCId
                                    select arc.EnablePostCodeSearch).Single();
        if (enablePostCodeSearch == true)
        {
            InstallersPC.Visible = true;
        }
        else
        {
            Installers.Visible = true;
        }
    }
}