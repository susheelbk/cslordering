using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL.BAL;
using CSLOrderingARCBAL.Common;
using CSLOrderingARCBAL;

public partial class Categories : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Session[enumSessions.User_Id.ToString()] == null)
                Response.Redirect("Login.aspx");

            if (!Page.IsPostBack)
            {
                LoadCategories();
            }
        }
        catch (System.Threading.ThreadAbortException)
        {
            // ** Do Nothing 
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            db.Dispose();
        }
    }

    protected void LoadCategories()
    {
        ARC arc = ArcBAL.GetArcInfoByUserId(new Guid(Session[enumSessions.User_Id.ToString()].ToString()));

        if (arc == null)
        {
            string script = "alertify.alert('" + ltrUser.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            return;
        }

        List<CategoryDTO> categories = CategoryBAL.GetCategoriesByArcId(arc.ARCId);
        dtCategories.DataSource = categories;
        dtCategories.DataBind();
    }


    
}