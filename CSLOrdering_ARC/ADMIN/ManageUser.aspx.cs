using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Linq;
using System.Data.Linq.SqlClient;
using CSLOrderingARCBAL;
using CSLOrderingARCBAL.BAL;
using CSLOrderingARCBAL.Common;
using System.Reflection;
using System.Data.Sql;
using System.Web.Security;


public partial class ManageUser : System.Web.UI.Page
{
    LinqToSqlDataContext db;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                LoadData();
                Session[enumSessions.UserIdToUpdate.ToString()] = null;
            }
            catch (Exception objException)
            {
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }

        }

        trPass.Visible = false;
        trPassConf.Visible = false;
        trPassLnk.Visible = true;

    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        Page.Validate();
        if (Page.IsValid)
        {
            try
            {
                //creating user

                if (ddlARC.SelectedValue == "-1")
                {
                    string script = "alertify.alert('" + ltrSelectARC.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    MaintainScrollPositionOnPostBack = false;
                    return;
                }
                var checkedroles = (from ListItem item in Chkboxroles.Items where item.Selected select item.Value).ToList();
                if (!checkedroles.Any())
                {
                    string script = "alertify.alert('" + ltrSelectRole.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    MaintainScrollPositionOnPostBack = false;
                    return;
                }
                string username = "";
                if (Session[enumSessions.UserIdToUpdate.ToString()] == null)
                {
                    txtuname.Enabled = true;
                    if (!string.IsNullOrEmpty(txtpwd.Text.ToString().Trim()) && !string.IsNullOrEmpty(Txtuemail.Text.ToString().Trim()) && !string.IsNullOrEmpty(txtuname.Text.ToString().Trim()))
                    {
                        username = txtuname.Text.ToString().Trim();
                        string password = txtpwd.Text.ToString().Trim();
                        string Emailid = Txtuemail.Text.ToString().Trim();
                        string question = ddlSecurityQuestion.SelectedValue;
                        string answer = txtAnswer.Text.ToString().Trim();
                        MembershipCreateStatus res;
                        MembershipUser usr = Membership.CreateUser(username, password, Emailid, question, answer, ChkBoxIsapproved.Checked, out res);
                        if (usr == null)
                        {
                            string script = "alertify.alert('" + res.ToString() + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            return;
                        }
                        else
                        {
                            Session[enumSessions.UserIdToUpdate.ToString()] = new Guid(usr.ProviderUserKey.ToString());
                            string script = "alertify.alert('User " + txtuname.Text + " created successfully.');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            MaintainScrollPositionOnPostBack = false;
                        }
                    }
                }
                //updating user
                else
                {
                    if (!string.IsNullOrEmpty(Txtuemail.Text.ToString().Trim()) && !string.IsNullOrEmpty(txtuname.Text.ToString().Trim()))
                    {
                        txtuname.Enabled = false;
                        username = txtuname.Text.ToString().Trim();
                        string password = txtpwd.Text.ToString().Trim();
                        string Emailid = Txtuemail.Text.ToString().Trim();
                        string question = ddlSecurityQuestion.SelectedValue;
                        string answer = txtAnswer.Text.ToString().Trim();
                        MembershipUser user;
                        user = Membership.GetUser(new Guid(Session[enumSessions.UserIdToUpdate.ToString()].ToString()));
                        db = new LinqToSqlDataContext();
                        if (ChkBoxIsBlocked.Checked == false)
                        {
                            user.UnlockUser();
                        }
                        var usrDtls = db.USP_GetUserDetailsByUserId(Session[enumSessions.UserIdToUpdate.ToString()].ToString()).FirstOrDefault();
                       // string cur_pwd = user.GetPassword(usrDtls.PasswordAnswer);
                       // user.ChangePasswordQuestionAndAnswer(cur_pwd, question, answer);
                        if (!string.IsNullOrEmpty(txtpwd.Text.ToString()))
                        {
                            user.ChangePassword(Membership.Provider.ResetPassword(username, usrDtls.PasswordAnswer), txtpwd.Text);
                           // user.ChangePassword(cur_pwd, txtpwd.Text.ToString().Trim());
                        }

                        user.Email = Emailid.Trim();

                        Boolean approved = true;
                        if (ChkBoxIsapproved.Checked)
                        {
                            approved = true;
                        }
                        else
                        {
                            approved = false;
                        }


                        user.IsApproved = approved;
                        Membership.UpdateUser(user);

                        //deleting old existing roles of this user
                        string[] adminroles = (from a in db.ApplicationSettings
                                               where a.KeyName == enumApplicationSetting.WebsiteAdminRoles.ToString()
                                               select a.KeyValue).SingleOrDefault().Split(',');
                        var Rls = Roles.GetAllRoles().Except(adminroles).ToList();

                        foreach (string Urole in Rls)
                        {
                            if (Roles.IsUserInRole(txtuname.Text.ToString(), Urole))
                            {
                                Roles.RemoveUserFromRole(txtuname.Text.ToString(), Urole);
                            }
                        }

                        //deleting old existing arcs of this user

                        db = new LinqToSqlDataContext();
                        var delarc = db.ARC_User_Maps.Where(item => item.UserId == new Guid(Session[enumSessions.UserIdToUpdate.ToString()].ToString()));
                        db.ARC_User_Maps.DeleteAllOnSubmit(delarc);
                        db.SubmitChanges();

                        string script = "alertify.alert('User " + txtuname.Text + " updated successfully.');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        MaintainScrollPositionOnPostBack = false;
                    }


                }

                string roleslist = string.Empty;
                //inserting checked roles
                for (int i = 0; i <= Chkboxroles.Items.Count - 1; i++)
                {
                    if (Chkboxroles.Items[i].Selected == true)
                    {
                        Roles.AddUserToRole(txtuname.Text.ToString(), Chkboxroles.Items[i].Value.ToString());
                        roleslist += Chkboxroles.Items[i].Value.ToString() + ",";
                    }
                }


                //inserting checked arcs of this user

                ARC_User_Map acm;
                if (ddlARC.SelectedValue != "-1" && ddlARC.SelectedValue != null)
                {
                    db = new LinqToSqlDataContext();
                    acm = new ARC_User_Map();
                    acm.UserId = new Guid(Session[enumSessions.UserIdToUpdate.ToString()].ToString());
                    acm.ARCId = Convert.ToInt32(ddlARC.SelectedValue);
                    db.ARC_User_Maps.InsertOnSubmit(acm);
                    db.SubmitChanges();
                    int orderId = (from o in db.Orders
                                   where o.UserId == acm.UserId && o.ARCId != acm.ARCId && o.OrderStatusId == 1
                                   select o.OrderId).SingleOrDefault();
                    if (orderId > 0)
                    {
                        db.USP_DeleteOrderwithDetails(orderId);
                    }
                }


                pnluserdetails.Visible = false;
                pnluserlist.Visible = true;

                Audit audit = new Audit();
                audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
                audit.ChangeID = Convert.ToInt32(enumAudit.Manage_User);
                audit.CreatedOn = DateTime.Now;
                audit.Notes = "UserName: " + username + ", Email: " + Txtuemail.Text + ", ARC: " + ddlARC.SelectedItem + ", IsApproved: " + ChkBoxIsapproved.Checked +
                    ", IsBlocked:" + ChkBoxIsBlocked.Checked + ", Roles:" + roleslist;

                if (Request.ServerVariables["LOGON_USER"] != null)
                {
                    audit.WindowsUser = Request.ServerVariables["LOGON_USER"];
                }
                audit.IPAddress = Request.UserHostAddress;
                db.Audits.InsertOnSubmit(audit);
                db.SubmitChanges();

                LoadData();
                MaintainScrollPositionOnPostBack = false;

            }


            catch (Exception objException)
            {
                if (objException.Message.Trim() == "The E-mail supplied is invalid.")
                {
                    string script = "alertify.alert('" + ltrEmailExists.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                }
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSave_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
        else
        {
            string script = "alertify.alert('" + ltrFill.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            MaintainScrollPositionOnPostBack = false;
        }
    }

    public void LoadData()
    {
        try
        {

            Session[enumSessions.UserIdToUpdate.ToString()] = null;
            MaintainScrollPositionOnPostBack = true;
            txtuname.Text = "";
            Txtuemail.Text = "";
            txtpwd.Text = "";
            txtConfirmPwd.Text = "";
            txtuname.Enabled = true;
            ChkBoxIsapproved.Checked = false;
            ChkBoxIsBlocked.Checked = false;
            ChkBoxIsBlocked.Enabled = false;

            //binding griduser
            db = new LinqToSqlDataContext();
            var UserDetails = (from usrDtls in db.VW_GetActiveUsersDetails
                               orderby usrDtls.UserName ascending
                               where usrDtls.CompanyName.Contains(Txtuarcsrch.Text.Trim())
                               && usrDtls.Email.Contains(Txtuemailsrch.Text.Trim())
                               && usrDtls.ARC_Code.Contains(txtArcCodeSrch.Text.Trim())
                               && usrDtls.UserName.Contains(Txtunamesrch.Text.Trim())
                               select usrDtls);


            gvUsers.DataSource = UserDetails;
            gvUsers.DataBind();

            //binding Role DropDown.
            string[] adminroles = (from a in db.ApplicationSettings
                                   where a.KeyName == enumApplicationSetting.WebsiteAdminRoles.ToString()
                                   select a.KeyValue).SingleOrDefault().Split(',');
            var rol2 = Roles.GetAllRoles().Except(adminroles).ToList();

            ddrolesrch.DataSource = rol2;
            ddrolesrch.DataBind();
            ListItem li = new ListItem();
            li.Text = "All";
            li.Value = "-1";
            ddrolesrch.Items.Insert(0, li);
            ddrolesrch.SelectedIndex = 0;

            //binding roles
            var rol = Roles.GetAllRoles().Except(adminroles).ToList();
            Chkboxroles.DataSource = rol;
            Chkboxroles.DataBind();
            for (int i = 0; i <= Chkboxroles.Items.Count - 1; i++)
            {
                Chkboxroles.Items[i].Selected = false;
            }

            //binding arcs
            db = new LinqToSqlDataContext();
            var ARCdata = (from arc in db.ARCs
                           where arc.IsDeleted == false
                           orderby arc.CompanyName
                           select new { arc.ARCId, ARCDisp = arc.CompanyName + " - [" + arc.ARC_Code + "]" }
                           );

            ddlARC.DataValueField = "ARCId";
            ddlARC.DataTextField = "ARCDisp";
            ddlARC.DataSource = ARCdata;
            ddlARC.DataBind();
            ddlARC.Items.Insert(0, new ListItem("No ARC", "-1"));

        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LoadData", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    protected void LinkButtondelete_click(object sender, System.EventArgs e)
    {
        try
        {
            LinkButton lbdel = sender as LinkButton;
            GridViewRow gvr = (GridViewRow)lbdel.NamingContainer;
            db = new LinqToSqlDataContext();
            Label lbl2 = gvr.FindControl("UserKey") as Label;
            Session[enumSessions.UserIdToUpdate.ToString()] = lbl2.Text;
            var usr = Membership.GetUser(new Guid(Session[enumSessions.UserIdToUpdate.ToString()].ToString()));
            //delete user - deactivate user

            if (usr != null)
            {
                usr.IsApproved = false;
                Membership.UpdateUser(usr);
            }


            //delete this users arc's
            db = new LinqToSqlDataContext();

            var delarc = db.ARC_User_Maps.Where(item => item.UserId == new Guid(Session[enumSessions.UserIdToUpdate.ToString()].ToString()));
            db.ARC_User_Maps.DeleteAllOnSubmit(delarc);

            db.SubmitChanges();

            LoadData();
            string script = "alertify.alert('" + ltrDeleted.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LinkButtondelete_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    protected void LinkButtonupdate_click(object sender, System.EventArgs e)
    {
        try
        {
            pnluserdetails.Visible = true;
            pnluserlist.Visible = false;
            litAction.Text = "You choose to <b>EDIT USER</b>";
            ChkBoxIsapproved.Checked = false;
            LinkButton lbuser = sender as LinkButton;
            if (lbuser != null)
            {
                GridViewRow gvr = (GridViewRow)lbuser.NamingContainer;
                Label lbl1 = gvr.FindControl("UserKey") as Label;
                Session[enumSessions.UserIdToUpdate.ToString()] = lbl1.Text;
            }
            else
            {
                //Reset 
                if (Session[enumSessions.UserIdToUpdate.ToString()] != null)
                { }
                else
                {
                    //Do a cancel as no value in session
                    btnCancel_Click(sender, e);
                }

            }

            db = new LinqToSqlDataContext();
            var usrDtls = db.USP_GetUserDetailsByUserId(Session[enumSessions.UserIdToUpdate.ToString()].ToString()).FirstOrDefault();
            if (usrDtls.IsLockedOut)
            {
                ChkBoxIsBlocked.Enabled = true;
            }
            //new code for isapproved and locked out by sonam
            if (usrDtls.IsApproved == true)
                ChkBoxIsapproved.Checked = true;
            if (usrDtls.IsLockedOut == true)
                ChkBoxIsBlocked.Checked = true;
            txtuname.Text = usrDtls.UserName;
            txtuname.Enabled = false;
            txtpwd.Text = usrDtls.Password;
            ddlSecurityQuestion.SelectedValue = usrDtls.PasswordQuestion;
            txtAnswer.Text = usrDtls.PasswordAnswer;
            Txtuemail.Text = usrDtls.Email;

            foreach (ListItem itemchk in Chkboxroles.Items)
            {
                itemchk.Selected = false;
            }

            //bind user roles to checkboxroles
            string[] adminroles = (from a in db.ApplicationSettings
                                   where a.KeyName == enumApplicationSetting.WebsiteAdminRoles.ToString()
                                   select a.KeyValue).SingleOrDefault().Split(',');
            var Rls = Roles.GetAllRoles().Except(adminroles).ToList();

            foreach (string Urole in Rls)
            {
                if (Roles.IsUserInRole(txtuname.Text.ToString(), Urole))
                {
                    foreach (ListItem itemchk in Chkboxroles.Items)
                    {
                        if (itemchk.Value == Urole)
                        {
                            itemchk.Selected = true;
                        }
                    }
                }
            }


            //binding user  to radioarc
            CheckArc();
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LinkButtonupdate_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    protected void btnShowAll_Click(object sender, EventArgs e)
    {
        txtArcCodeSrch.Text = String.Empty;
        Txtuarcsrch.Text = String.Empty;
        Txtuemailsrch.Text = String.Empty;
        Txtunamesrch.Text = String.Empty;
        ddrolesrch.SelectedIndex = 0;
        LoadData();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            Session[enumSessions.UserIdToUpdate.ToString()] = null;
            ChkBoxIsapproved.Checked = false;
            ChkBoxIsBlocked.Checked = false;
            db = new LinqToSqlDataContext();
            var UserDetails = (from usrDtls in db.VW_GetActiveUsersDetails
                               orderby usrDtls.UserName ascending
                               where usrDtls.UserName.Contains(Txtunamesrch.Text.Trim())
                                      && usrDtls.RoleName.Contains(ddrolesrch.SelectedIndex == 0 ? "" : ddrolesrch.SelectedItem.ToString())
                                      && usrDtls.Email.Contains(Txtuemailsrch.Text.Trim())
                                      && usrDtls.ARC_Code.Contains(txtArcCodeSrch.Text.Trim())
                                      && usrDtls.CompanyName.Contains(Txtuarcsrch.Text.Trim())
                               select usrDtls);
            if (UserDetails.Any())
            {
                gvUsers.DataSource = UserDetails;
                gvUsers.DataBind();
            }

            if (UserDetails.Count() == 0)//&& txtArcCodeSrch.Text.Trim() && Txtuarcsrch.Text.Trim() && ))
            {
                if (string.IsNullOrEmpty(txtArcCodeSrch.Text.Trim()) && string.IsNullOrEmpty(Txtunamesrch.Text.Trim()) && string.IsNullOrEmpty(Txtuarcsrch.Text.Trim()) && (ddrolesrch.SelectedIndex == 0) && string.IsNullOrEmpty(Txtuemailsrch.Text.Trim()))
                {
                    LoadData();
                }

                else
                {
                    gvUsers.DataSource = null;
                    gvUsers.DataBind();

                }

            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSearch_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    public void CheckArc()
    {
        try
        {
            string Uid = Session[enumSessions.UserIdToUpdate.ToString()].ToString();
            db = new LinqToSqlDataContext();
            var user_arc = (from arc in db.ARC_User_Maps
                            where arc.UserId == new Guid(Uid)
                            select new { arc.ARCId }).SingleOrDefault();
            if (user_arc != null && user_arc.ARCId != -1)
                ddlARC.SelectedValue = user_arc.ARCId.ToString();
            else
                ddlARC.SelectedValue = "-1";


        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "CheckArc", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    #region gvUsers Paging

    protected void gvUsers_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            gvUsers.PageIndex = e.NewPageIndex;
            LoadData();
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvUsers_PageIndexChanging", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }

    }

    #endregion

    protected void btnnewuser_Click(object sender, EventArgs e)
    {
        pnluserdetails.Visible = true;
        pnluserlist.Visible = false;
        litAction.Text = "You choose to <b>ADD NEW USER</b>";
        LoadData();
        trPass.Visible = true;
        trPassConf.Visible = true;
        trPassLnk.Visible = false;
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Session[enumSessions.UserIdToUpdate.ToString()] = null;
        pnluserlist.Visible = true;
        pnluserdetails.Visible = false;

    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        if (Session[enumSessions.UserIdToUpdate.ToString()] != null)
        {
            LinkButtonupdate_click(sender, e);
        }
        else
        {
            btnnewuser_Click(sender, e);
        }
    }

    protected void lnkChangePassword_Click(object sender, EventArgs e)
    {
        trPass.Visible = true;
        trPassConf.Visible = true;
        trPassLnk.Visible = false;
    }
}


