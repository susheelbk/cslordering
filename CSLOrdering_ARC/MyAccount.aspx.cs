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

public partial class MyAccount : System.Web.UI.Page
{
    LinqToSqlDataContext db;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session[enumSessions.User_Id.ToString()] == null)
            Response.Redirect("~/Login.aspx");

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
                if (!string.IsNullOrEmpty(txtpwd.Text) && txtpwd.Text.Length < 6)
                {
                    string script = "alertify.alert('" + ltrSixChars.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    return;
                }

                var checkedroles = (from ListItem item in Chkboxroles.Items where item.Selected select item.Text).ToList();
                if (!checkedroles.Any())
                {
                    string script = "alertify.alert('" + ltrSelectRole.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    MaintainScrollPositionOnPostBack = false;
                    return;
                }
                if (Session[enumSessions.UserIdToUpdate.ToString()] == null)
                {
                    txtuname.Enabled = true;
                    if (!string.IsNullOrEmpty(txtpwd.Text.ToString().Trim()) && !string.IsNullOrEmpty(Txtuemail.Text.ToString().Trim()) && !string.IsNullOrEmpty(txtuname.Text.ToString().Trim()) && !string.IsNullOrEmpty(txtAnswer.Text.ToString().Trim()))
                    {
                        string username = txtuname.Text.ToString().Trim();
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
                        string username = txtuname.Text.ToString().Trim();
                        string password = txtpwd.Text.ToString().Trim();
                        string Emailid = Txtuemail.Text.ToString().Trim();
                        string question = ddlSecurityQuestion.SelectedValue;
                        string answer = txtAnswer.Text.ToString().Trim();
                        MembershipUser user;
                        user = Membership.GetUser(new Guid(Session[enumSessions.UserIdToUpdate.ToString()].ToString()));
                        db = new LinqToSqlDataContext();
                        var usrDtls = db.USP_GetUserDetailsByUserId(Session[enumSessions.UserIdToUpdate.ToString()].ToString()).FirstOrDefault();
                      //  string cur_pwd = user.GetPassword(usrDtls.PasswordAnswer);
                      //  user.ChangePasswordQuestionAndAnswer(cur_pwd, question, answer);//unable to retriee the password as password is hashed.

                        if (ChkBoxIsBlocked.Checked == false)
                        {
                            user.UnlockUser();
                        }
                        if (!string.IsNullOrEmpty(txtpwd.Text.ToString()))
                        {
                            user.ChangePassword(Membership.Provider.ResetPassword(username, usrDtls.PasswordAnswer), txtpwd.Text.ToString().Trim());//changed by Priya.
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
                        string[] Rls = {"ARC_Manager","ARC_Admin"};

                        foreach (string Urole in Rls)
                        {
                            if (Roles.IsUserInRole(txtuname.Text.ToString(), Urole))
                            {
                                Roles.RemoveUserFromRole(txtuname.Text.ToString(), Urole);
                            }
                        }
                        
                        string script = "alertify.alert('User " + txtuname.Text + " updated successfully.');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        MaintainScrollPositionOnPostBack = false;

                    }

                }

                //inserting checked roles
                for (int i = 0; i <= Chkboxroles.Items.Count - 1; i++)
                {
                    if (Chkboxroles.Items[i].Selected == true)
                    {
                        Roles.AddUserToRole(txtuname.Text.ToString(), Chkboxroles.Items[i].Text.ToString());
                    }
                }


                LoadData();
                MaintainScrollPositionOnPostBack = false;

                Audit audit = new Audit();
                audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
                audit.ChangeID = Convert.ToInt32(enumAudit.Update_User_Info);
                audit.CreatedOn = DateTime.Now;
                audit.IPAddress = Request.UserHostAddress;
                db.Audits.InsertOnSubmit(audit);
                db.SubmitChanges();
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
            btnSave.Visible = false;
            divcreateuser.Visible = false;
            Session[enumSessions.UserIdToUpdate.ToString()] = null;
            MaintainScrollPositionOnPostBack = true;
            txtuname.Text = "";
            Txtunamesrch.Text = "";
            Txtuemail.Text = "";
            txtpwd.Text = "";
            txtConfirmPwd.Text = "";
            txtAnswer.Text = "";
            ddrolesrch.SelectedIndex = 0;
            txtuname.Enabled = true;
            ChkBoxIsapproved.Checked = false;
            ChkBoxIsBlocked.Checked = false;
            ChkBoxIsBlocked.Enabled = false;

            //binding griduser
            db = new LinqToSqlDataContext();

            var UserDetails = (from usrDtls in db.VW_GetActiveUsersDetails
                               where usrDtls.UserId == Guid.Parse(Session[enumSessions.User_Id.ToString()].ToString())
                               orderby usrDtls.CompanyName ascending
                               select usrDtls);
            pnlManager.Visible = pnlSearch.Visible = false;

            if (Session[enumSessions.User_Role.ToString()].ToString() == enumRoles.ARC_Manager.ToString())
            {

                UserDetails = (from usrDtls in db.VW_GetActiveUsersDetails
                               where usrDtls.ARCId == Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()])
                               orderby usrDtls.CompanyName ascending
                               select usrDtls);
                pnlManager.Visible = pnlSearch.Visible = true;
            }


            gvUsers.DataSource = UserDetails;
            gvUsers.DataBind();

            ListItem li = new ListItem();
            li.Text = "All";
            li.Value = "-1";
            ddrolesrch.Items.Insert(0, li);
            ddrolesrch.SelectedIndex = 0;

            for (int i = 0; i <= Chkboxroles.Items.Count - 1; i++)
            {
                Chkboxroles.Items[i].Selected = false;
            }
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
            Label lbl2 = gvr.Cells[5].FindControl("UserKey") as Label;
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
            string script = "alertify.alert('" + ltrUserDeleted.Text + "');";
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
            btnSave.Visible = true;
            divcreateuser.Visible = true;
            LinkButton lbctg = sender as LinkButton;
            GridViewRow gvr = (GridViewRow)lbctg.NamingContainer;
            Label lbl1 = gvr.Cells[5].FindControl("UserKey") as Label;
            Session[enumSessions.UserIdToUpdate.ToString()] = lbl1.Text;
            db = new LinqToSqlDataContext();
            var usrDtls = db.USP_GetUserDetailsByUserId(lbl1.Text).FirstOrDefault();
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
            string[] Rls = { "ARC_Admin", "ARC_Manager" };

            foreach (string Urole in Rls)
            {
                if (Roles.IsUserInRole(txtuname.Text.ToString(), Urole))
                {
                    foreach (ListItem itemchk in Chkboxroles.Items)
                    {
                        if (itemchk.Text == Urole)
                        {
                            itemchk.Selected = true;
                        }
                    }
                }
            }


            //binding user  to radioarc

        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LinkButtonupdate_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    protected void btnShowAll_Click(object sender, EventArgs e)
    {
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
                               where usrDtls.UserName.Contains(Txtunamesrch.Text)
                                      && usrDtls.RoleName.Contains(ddrolesrch.SelectedIndex == 0 ? "" : ddrolesrch.SelectedItem.ToString())
                                      && usrDtls.Email.Contains(Txtuemailsrch.Text)
                                      && usrDtls.ARCId == Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()])
                               select usrDtls);

            gvUsers.DataSource = UserDetails;
            gvUsers.DataBind();

            if (UserDetails.Count() == 0)
            {
                LoadData();
                string script = "alertify.alert('" + ltrNoMatch.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSearch_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
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


    protected void lnkChangePassword_Click(object sender, EventArgs e)
    {
        trPass.Visible = true;
        trPassConf.Visible = true;
        trPassLnk.Visible = false;
    }
}