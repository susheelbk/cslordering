<%@ Application Language="C#" %>
<script RunAt="server">

    void Application_Start(object sender, EventArgs e)
    {
        // Code that runs on application startup

    }

    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown

    }


    // Code that runs when an unhandled error occurs
    void Application_Error(object sender, EventArgs e)
    {
        try
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            // Code that runs when an unhandled error occurs
            System.Web.HttpContext objContext = HttpContext.Current;
            System.Exception objException = objContext.Server.GetLastError();
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            // db.USP_SaveErrorDetails(objContext.Request.Url.ToString(),Convert.ToString(objException.InnerException.TargetSite.Name), Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            if (objContext.Session == null)
            {
                db.USP_SaveErrorDetails(objContext.Request.Url.ToString(), Convert.ToString(((System.Reflection.MemberInfo)(objException.TargetSite)).Name), Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, String.Empty);
            }
            else
            {
                db.USP_SaveErrorDetails(objContext.Request.Url.ToString(), Convert.ToString(((System.Reflection.MemberInfo)(objException.TargetSite)).Name), Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, HttpContext.Current.Session[enumSessions.User_Id.ToString()] == null ? "" : Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
        catch (Exception ex)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "Application_Error", Convert.ToString(ex.Message), Convert.ToString(ex.InnerException),
                Convert.ToString(ex.StackTrace), "", HttpContext.Current.Request.UserHostAddress, 
                false, SiteUtility.GetUserName());
            Response.Redirect("~/ErrorPage.apsx");
        }
    }



    void Session_Start(object sender, EventArgs e)
    {
        // Code that runs when a new session is started
    }

    void Session_End(object sender, EventArgs e)
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }
       
</script>
