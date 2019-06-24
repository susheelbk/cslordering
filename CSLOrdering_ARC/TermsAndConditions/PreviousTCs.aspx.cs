using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TermsAndConditions_PreviousTCs : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.UrlReferrer == null || Session[enumSessions.User_Id.ToString()] == null)
            Response.Redirect("~/Login.aspx");
    }
}