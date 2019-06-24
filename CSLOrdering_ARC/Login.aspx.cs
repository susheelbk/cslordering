using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using CSLOrderingARCBAL.BAL;
using CSLOrderingARCBAL;

public partial class Login : MainPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Response.Cache.SetExpires(DateTime.UtcNow.AddMilliseconds(-1));
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();


            cslLogin.Focus();
            lblMsg.Text = "";

        }
        catch (System.Threading.ThreadAbortException ex)
        {
            //
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

        cslLogin.LoggedIn += cslLogin_LoggedIn;
    }

    void cslLogin_LoggedIn(object sender, EventArgs e)
    {
        //if (Request.UrlReferrer != null && Request.QueryString.Keys.Count > 0)
           // Response.Redirect(Request.QueryString[0]);
        
        if (Session[enumSessions.User_Role.ToString()] == enumRoles.ARCWebSite_Admin.ToString())
            Response.Redirect("Admin");

        Response.Redirect("Categories.aspx");
    }




    private void AutoLoginUser()
    {
        try
        {
            string username = Request.QueryString["User"];
            string CatId = Request.QueryString["CatId"];

            string userEmail = "";
            if (!string.IsNullOrEmpty(username))
            {
                if (Roles.IsUserInRole(username, enumRoles.ARCWebSite_Admin.ToString()))
                {
                    Session[enumSessions.User_Role.ToString()] = enumRoles.ARCWebSite_Admin.ToString();
                    if (Roles.IsUserInRole(username, enumRoles.ARCWebSite_SuperAdmin.ToString()))
                    {
                        Session[enumSessions.IsUserSuperAdmin.ToString()] = enumRoles.ARCWebSite_SuperAdmin.ToString();
                    }
                }
                else
                {
                    if (Roles.IsUserInRole(username, enumRoles.ARC_Manager.ToString()))
                        Session[enumSessions.User_Role.ToString()] = enumRoles.ARC_Manager.ToString();
                    else if (Roles.IsUserInRole(username, enumRoles.ARC_Admin.ToString()))
                        Session[enumSessions.User_Role.ToString()] = enumRoles.ARC_Admin.ToString();
                    else
                    {
                        lblMsg.Text = "Login unsuccessful. Please check your username and password";
                        System.Web.Security.FormsAuthentication.SignOut();
                        return;
                    }
                }

                MembershipUser userInfo = Membership.GetUser(username);
                Guid UserID = new Guid(userInfo.ProviderUserKey.ToString());
                userEmail = userInfo.Email;
                Session[enumSessions.User_Id.ToString()] = UserID;
                Session[enumSessions.User_Name.ToString()] = username;
                Session[enumSessions.User_Email.ToString()] = userEmail;

                // if (Session[enumSessions.User_Role.ToString()] == enumRoles.ARCWebSite_Admin.ToString())
                // Response.Redirect("ADMIN/AdminDefault.aspx");

                ARC arc = ArcBAL.GetArcInfoByUserId(new Guid(Session[enumSessions.User_Id.ToString()].ToString()));
                if (arc == null)
                {
                    lblMsg.Text = "Login denied! Your account is not related to any ARC. Please contact CSL DualCom.";
                    System.Web.Security.FormsAuthentication.SignOut();
                    return;
                }
                Session[enumSessions.ARC_Id.ToString()] = arc.ARCId;
                Session[enumSessions.IsARC_AllowReturns.ToString()] = arc.AllowReturns;

                LinqToSqlDataContext db = new LinqToSqlDataContext();
                var OrderInfo = db.USP_CreateOrderForUser(arc.ARCId, Session[enumSessions.User_Name.ToString()].ToString(), Session[enumSessions.User_Name.ToString()].ToString(), Session[enumSessions.User_Email.ToString()].ToString(), Session[enumSessions.User_Id.ToString()].ToString()).SingleOrDefault();
                if (OrderInfo != null)
                {
                    Session[enumSessions.OrderId.ToString()] = OrderInfo.OrderId;
                    Session[enumSessions.OrderNumber.ToString()] = OrderInfo.OrderNo.ToString();
                    Session[enumSessions.HasUserAcceptedDuplicates.ToString()] = OrderInfo.HasUserAcceptedDuplicates;

                    if (OrderInfo.InstallerId != "0")
                    {
                        Session[enumSessions.InstallerCompanyID.ToString()] = OrderInfo.InstallerId;
                        Session[enumSessions.SelectedInstaller.ToString()] = OrderInfo.SelectedInstaller;
                    }
                }
                db.Dispose();

                FormsAuthentication.SetAuthCookie(username, false);

                //if (Session[enumSessions.IsARC_AllowReturns.ToString()] != null && Convert.ToBoolean(Session[enumSessions.IsARC_AllowReturns.ToString()]))
                //    Response.Redirect("UploadOrder.aspx");
                //else
                if (string.IsNullOrEmpty(CatId) || CatId.Trim() == "")
                    Response.Redirect("Categories.aspx");
                else
                    Response.Redirect("ProductList.aspx?CategoryId=" + CatId);
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
            db.USP_SaveErrorDetails(Request.Url.ToString(), "AutoLoginUser", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }


    protected void MyLogin_Authenticate(object sender, AuthenticateEventArgs e)
    {


        try
        {
            lblMsg.Text = "";
            string username = cslLogin.UserName;
            string userEmail = "";

            if (AuthenticateUser(username, cslLogin.Password))
            {
                
                if (Roles.IsUserInRole(username, enumRoles.ARCWebSite_Admin.ToString()))
                {
                    Session[enumSessions.User_Role.ToString()] = enumRoles.ARCWebSite_Admin.ToString();
                    if (Roles.IsUserInRole(username, enumRoles.ARCWebSite_SuperAdmin.ToString()))
                    {
                        Session[enumSessions.IsUserSuperAdmin.ToString()] = enumRoles.ARCWebSite_SuperAdmin.ToString();
                    }
                }
                else
                {
                    if (Roles.IsUserInRole(username, enumRoles.ARC_Manager.ToString()))
                        Session[enumSessions.User_Role.ToString()] = enumRoles.ARC_Manager.ToString();
                    else if (Roles.IsUserInRole(username, enumRoles.ARC_Admin.ToString()))
                        Session[enumSessions.User_Role.ToString()] = enumRoles.ARC_Admin.ToString();
                    else
                    {
                        e.Authenticated = false;
                        lblMsg.Text = "Login unsuccessful. Please check your username and password";
                        System.Web.Security.FormsAuthentication.SignOut();
                       // e.Cancel = true;
                        return;
                    }
                }

                MembershipUser userInfo = Membership.GetUser(username);
                Guid UserID = new Guid(userInfo.ProviderUserKey.ToString());
                userEmail = userInfo.Email;
                Session[enumSessions.User_Id.ToString()] = UserID;
                Session[enumSessions.User_Name.ToString()] = username;
                Session[enumSessions.User_Email.ToString()] = userEmail;



                ARC arc = ArcBAL.GetArcInfoByUserId(new Guid(Session[enumSessions.User_Id.ToString()].ToString()));
                if (arc == null)
                {
                    e.Authenticated = false;
                    lblMsg.Text = "Login denied! Your account is not related to any ARC. Please contact CSL DualCom.";
                    System.Web.Security.FormsAuthentication.SignOut();
                  //  e.Cancel = true;
                    Session[enumSessions.User_Id.ToString()] = null;
                    return;
                }
                Session[enumSessions.ARC_Id.ToString()] = arc.ARCId;
                Session[enumSessions.IsARC_AllowReturns.ToString()] = arc.AllowReturns;

                LinqToSqlDataContext db = new LinqToSqlDataContext();
                var OrderInfo = db.USP_CreateOrderForUser(arc.ARCId, Session[enumSessions.User_Name.ToString()].ToString(), Session[enumSessions.User_Name.ToString()].ToString(), Session[enumSessions.User_Email.ToString()].ToString(), Session[enumSessions.User_Id.ToString()].ToString()).SingleOrDefault();
                if (OrderInfo != null)
                {
                    Session[enumSessions.OrderId.ToString()] = OrderInfo.OrderId;
                    Session[enumSessions.OrderNumber.ToString()] = OrderInfo.OrderNo.ToString();
                    Session[enumSessions.HasUserAcceptedDuplicates.ToString()] = OrderInfo.HasUserAcceptedDuplicates;

                    if (OrderInfo.InstallerId != "0")
                    {
                        Session[enumSessions.InstallerCompanyID.ToString()] = OrderInfo.InstallerId;
                        Session[enumSessions.SelectedInstaller.ToString()] = OrderInfo.SelectedInstaller;
                    }
                }

                e.Authenticated = true;

                db.Dispose();

                

            }
            else
            {
                e.Authenticated = false;
                lblMsg.Text = "Login unsuccessful ! unable to find your details";
                System.Web.Security.FormsAuthentication.SignOut();
            //    e.Cancel = true;
                return;
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
            db.USP_SaveErrorDetails(Request.Url.ToString(), "cslLogin_LoggingIn", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
        
        
       

    }
    private bool AuthenticateUser(string UserName, string Password)
    {
        bool bresponse = false;
        bresponse = Membership.ValidateUser(UserName, Password);
        if (bresponse)
        {
            MembershipUser userInfo = Membership.GetUser(UserName);
            Guid UserID = new Guid(userInfo.ProviderUserKey.ToString());
            string useremail = userInfo.Email;
            
            AuthenticationService _Auth = new AuthenticationService();
            _Auth.MigratetoKeyCloak(UserName, Password, useremail, string.Empty, string.Empty, UserID, userInfo.LastPasswordChangedDate);
            //var x = _Auth.MigratetoKeyCloak(UserName, Password, useremail, string.Empty, string.Empty, UserID).Result;
        }
        return bresponse; 
       
     //AuthenticationService _Auth = new AuthenticationService(); 
      // return _Auth.ValidateUser(UserName,Password).Result; 
        
        

        
    }

}
