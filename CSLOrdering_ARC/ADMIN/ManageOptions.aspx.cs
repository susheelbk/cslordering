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


public partial class ADMIN_ManageOptions : System.Web.UI.Page
{
    LinqToSqlDataContext db;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                LoadData();
                Session[enumSessions.Option_Id.ToString()] = null;
            }
            catch (Exception objException)
            {
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.Option_Id.ToString()]));


            }
        }

    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {

            db = new LinqToSqlDataContext();
            var opt = (from op in db.Options
                       where op.OptionName.Contains(txtoptsrch.Text.Trim())
                       select op);
            gvOpt.DataSource = opt;
            gvOpt.DataBind();

            Session[enumSessions.Option_Id.ToString()] = null;

            if (opt.Count() == 0)
            {
                LoadData();
            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSearch_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }
    protected void btnShowAll_Click(object sender, EventArgs e)
    {
        try
        {
            txtoptsrch.Text = "";
            LoadData();
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnShowAll_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    public void LoadData()
    {
        try
        {
            txtdesc.Text = "";
            txtoptName.Text = "";
            Session[enumSessions.Option_Id.ToString()] = null;

            //binding all options in grid
            db = new LinqToSqlDataContext();
            var opt = (from op in db.Options
                       orderby op.OptionName ascending
                       where op.OptionName.Contains(txtoptsrch.Text.Trim())
                       select op);
            gvOpt.DataSource = opt;
            gvOpt.DataBind();
        }
        catch (Exception objException)
        {

            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LoadData", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }



    protected void Btnsave_Click(object sender, EventArgs e)
    {
        db = new LinqToSqlDataContext();
        string optName = "";
        //update options
        Audit audit = new Audit();
        if (Session[enumSessions.Option_Id.ToString()] != null)
        {
            int id = Convert.ToInt32(Session[enumSessions.Option_Id.ToString()].ToString());
            //update
            Option opp = (from x in db.Options
                          where x.OptID == id
                          select x).First();
            opp.OptionName = txtoptName.Text;
            optName = txtoptName.Text;
            opp.OptionDesc = txtdesc.Text;

            string script = "alertify.alert('" + ltrOptionUpdated.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            audit.Notes = "OptId: " + id + ", OptName: " + opp.OptionName + ", Description: " + opp.OptionDesc;
        }
        //create new option
        else
        {

            Option opt = new Option
            {

                OptionName = txtoptName.Text.ToString(),
                OptionDesc = txtdesc.Text.ToString()

            };

            optName = txtoptName.Text;
            db.Options.InsertOnSubmit(opt);
            string script = "alertify.alert('" + ltrOptionCreated.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            audit.Notes = "OptId: " + opt.OptID + ", OptName: " + opt.OptionName + ", Description: " + opt.OptionDesc;
        }
        pnlOptionDetails.Visible = false;
        pnlOptionList.Visible = true;
        db.SubmitChanges();
        LoadData();

        audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
        audit.ChangeID = Convert.ToInt32(enumAudit.Manage_Options);
        audit.CreatedOn = DateTime.Now;
        if (Request.ServerVariables["LOGON_USER"] != null)
        {
            audit.WindowsUser = Request.ServerVariables["LOGON_USER"];
        }
        audit.IPAddress = Request.UserHostAddress;
        db.Audits.InsertOnSubmit(audit);
        db.SubmitChanges();
    }

    protected void gvopt_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            gvOpt.PageIndex = e.NewPageIndex;
            LoadData();
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvopt_PageIndexChanging", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }

    }

    protected void LinkButtonupdate_click(object sender, System.EventArgs e)
    {
        try
        {
            pnlOptionDetails.Visible = true;
            pnlOptionList.Visible = false;
            litAction.Text = "You choose to <b>EDIT OPTION</b>";
            LinkButton lbopt = sender as LinkButton;
            if (lbopt != null)
            {
                GridViewRow gvr = (GridViewRow)lbopt.NamingContainer;
                Label lbl2 = gvr.Cells[1].FindControl("OptID") as Label;
                Session[enumSessions.Option_Id.ToString()] = lbl2.Text;
            }
            else
            {
                //Reset 
                if (Session[enumSessions.Option_Id.ToString()] != null)
                { }
                else
                {
                    //Do a cancel as no value in session
                    btnCancel_Click(sender, e);
                }

            }

            db = new LinqToSqlDataContext();
            var opt = (from op in db.Options
                       where op.OptID == Convert.ToInt32(Session[enumSessions.Option_Id.ToString()])
                       select op).FirstOrDefault();

            txtoptName.Text = opt.OptionName;
            txtdesc.Text = opt.OptionDesc;
        }
        catch (Exception objException)
        {

            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LinkButtonupdate_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    protected void LinkButtondelete_click(object sender, System.EventArgs e)
    {
        db = new LinqToSqlDataContext();
        try
        {
            Audit audit = new Audit();
            LinkButton lbopt = sender as LinkButton;
            GridViewRow gvr = (GridViewRow)lbopt.NamingContainer;
            Label lbl2 = gvr.Cells[1].FindControl("OptID") as Label;
            Session[enumSessions.Option_Id.ToString()] = lbl2.Text;
            //     delete mappings

            int id = Convert.ToInt32(Session[enumSessions.Option_Id.ToString()].ToString());
            var opts = db.Product_Option_Maps.Where(op => op.OptionId == id);
            db.Product_Option_Maps.DeleteAllOnSubmit(opts);


            //delete master
            Option opt = db.Options.Where(op => op.OptID == id).Single();
            db.Options.DeleteOnSubmit(opt);

            db.SubmitChanges();
            LoadData();
            string script = "alertify.alert('" + ltrOptionDeleted.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            audit.Notes = "Delete - Id: " + opts;
            audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
            audit.ChangeID = Convert.ToInt32(enumAudit.Manage_Options);
            audit.CreatedOn = DateTime.Now;
            if (Request.ServerVariables["LOGON_USER"] != null)
            {
                audit.WindowsUser = Request.ServerVariables["LOGON_USER"];
            }
            audit.IPAddress = Request.UserHostAddress;
            db.Audits.InsertOnSubmit(audit);
            db.SubmitChanges();
        }
        catch (Exception objException)
        {

            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LinkButtondelete_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }


    protected void btnReset_Click(object sender, EventArgs e)
    {
        if (Session[enumSessions.Option_Id.ToString()] != null)
        {
            LinkButtonupdate_click(sender, e);
        }
        else
        {
            btnNewOption_Click(sender, e);
        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Session[enumSessions.Option_Id.ToString()] = null;
        pnlOptionList.Visible = true;
        pnlOptionDetails.Visible = false;
    }
    protected void btnNewOption_Click(object sender, EventArgs e)
    {
        pnlOptionDetails.Visible = true;
        pnlOptionList.Visible = false;
        litAction.Text = "You choose to <b>ADD NEW OPTION</b>";
        txtoptName.Focus();
        LoadData();
    }
}