using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;
using System.Data;


public partial class ADMIN_ManageARC_AccessCode : System.Web.UI.Page
{
    LinqToSqlDataContext db;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGrid();
        }

    }

    private void BindGrid()
    {
        try
        {
            db = new LinqToSqlDataContext();
            var data = (from dt in db.ARC_AccessCodes
                        join arc in db.ARCs on dt.ARCID equals arc.ARCId
                        join ins in db.Installers on dt.InstallerUniqueCode equals ins.UniqueCode into insleftouter
                        from ins in insleftouter.DefaultIfEmpty()
                        select new { ARCDisp = arc.CompanyName + " [" + arc.ARC_Code + "]", ins.UniqueCode, ins.CompanyName, dt.Accesscode, arc.ARCId, dt.ID }).OrderBy(x => x.ARCDisp);
            if (data != null)
            {
                gvARCIns.DataSource = data;
                gvARCIns.DataBind();
            }
        }
        catch (Exception objException)
        {
            string script = "alertify.alert('" + objException.Message + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "BindGrid", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }


    protected void btnAdd_Click(object sender, EventArgs e)
    {
        try
        {
            db = new LinqToSqlDataContext();
            var data = from dt in db.ARC_AccessCodes
                       join arc in db.ARCs on dt.ARCID equals arc.ARCId
                       join ins in db.Installers on dt.InstallerUniqueCode equals ins.UniqueCode
                       select new { ARCDisp = arc.CompanyName + " - [" + arc.ARC_Code + "] ", ins.UniqueCode,ins.CompanyName, dt.Accesscode, arc.ARCId, ins.InstallerCompanyID, dt.ID };
            DataTable dt1 = new DataTable();
            dt1.Columns.Add("ARCDisp");
            dt1.Columns.Add("Accesscode");
            dt1.Columns.Add("InstallerCompanyID");
            dt1.Columns.Add("ID");
            dt1.Columns.Add("ARCId");
            dt1.Columns.Add("CompanyName");
            dt1.Columns.Add("UniqueCode");

            foreach (var item in data)
            {
                dt1.Rows.Add(item.ARCDisp, item.Accesscode, item.InstallerCompanyID, item.ID, item.ARCId, item.UniqueCode);
            }
            DataRow dr = dt1.NewRow();
            dt1.Rows.InsertAt(dr, 0);
            gvARCIns.EditIndex = 0;
            gvARCIns.DataSource = dt1;
            gvARCIns.DataBind();
            LinkButton lkupdate = gvARCIns.Rows[0].FindControl("lnkUpdate") as LinkButton;
            lkupdate.Text = "Insert";
        }
        catch (Exception objException)
        {
            string script = "alertify.alert('" + objException.Message + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnAdd_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }


    protected void gvARCIns_RowEditing(object sender, GridViewEditEventArgs e)
    {
        try
        {
            Label lblInstallerUnqCode = gvARCIns.Rows[e.NewEditIndex].FindControl("lblInstallerUnqCode") as Label;
            Label lblAccessCode = gvARCIns.Rows[e.NewEditIndex].FindControl("lblAccessCode") as Label;
            int ARCID = Convert.ToInt16(gvARCIns.DataKeys[e.NewEditIndex].Value);
            gvARCIns.EditIndex = e.NewEditIndex;
            BindGrid();
            DropDownList DdlArc = gvARCIns.Rows[gvARCIns.EditIndex].FindControl("ddlArc") as DropDownList;
            DdlArc.SelectedValue = ARCID.ToString();
            DropDownList ddlInstallerUnqCode = gvARCIns.Rows[gvARCIns.EditIndex].FindControl("ddlInstallerUnqCode") as DropDownList;
            ddlInstallerUnqCode.SelectedValue = lblInstallerUnqCode.Text;
            TextBox txtAccessCode = gvARCIns.Rows[gvARCIns.EditIndex].FindControl("txtAccessCode") as TextBox;
            txtAccessCode.Text = lblAccessCode.Text;

            Audit audit = new Audit();
            audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
            audit.ChangeID = Convert.ToInt32(enumAudit.Manage_ARC_AccessCode);
            audit.CreatedOn = DateTime.Now;
            audit.Notes = "Edit - ARC: " + DdlArc.SelectedItem.ToString() + ", Installer: " + ddlInstallerUnqCode.ToString() + ", Access Code: " + txtAccessCode.Text;
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
            string script = "alertify.alert('" + objException.Message + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvARCIns_RowEditing", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    protected void gvARCIns_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvARCIns.EditIndex = -1;
        BindGrid();
    }

    protected void gvARCIns_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            if ((e.Row.RowType == DataControlRowType.DataRow) && ((e.Row.RowState & DataControlRowState.Edit) > 0))
            {
                DropDownList ddlarcdrop = e.Row.FindControl("ddlArc") as DropDownList;
                DropDownList ddlinstallerdrop = e.Row.FindControl("ddlInstallerUnqCode") as DropDownList;
                db = new LinqToSqlDataContext();
                var ARCdata = (from arc in db.ARCs
                               orderby arc.CompanyName ascending
                               where arc.IsDeleted == false
                               select new { arc.ARCId, ARCDisp = arc.CompanyName + " - [" + arc.ARC_Code + "] " });

                ddlarcdrop.DataValueField = "ARCId";
                ddlarcdrop.DataTextField = "ARCDisp";
                ddlarcdrop.DataSource = ARCdata;
                ddlarcdrop.DataBind();
                ddlarcdrop.Items.Insert(0, new ListItem("-----------------Select--------------", "0"));

                var INSdata = (from inst in db.Installers
                               orderby inst.CompanyName ascending
                               where inst.IsActive == true
                               select new { inst.InstallerCompanyID, inst.UniqueCode, INSDisp = inst.CompanyName });

                ddlinstallerdrop.DataValueField = "UniqueCode";
                ddlinstallerdrop.DataTextField = "INSDisp";
                ddlinstallerdrop.DataSource = INSdata;
                ddlinstallerdrop.DataBind();
                ddlinstallerdrop.Items.Insert(0, new ListItem("---------------Select---------------", "0"));

            }
        }
        catch (Exception objException)
        {
            string script = "alertify.alert('" + objException.Message + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvARCIns_RowDataBound", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    protected void gvARCIns_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            DropDownList ddlArc = gvARCIns.Rows[e.RowIndex].FindControl("ddlArc") as DropDownList;
            DropDownList ddlInstallerUnqCode = gvARCIns.Rows[e.RowIndex].FindControl("ddlInstallerUnqCode") as DropDownList;
            LinkButton lkupdt = gvARCIns.Rows[e.RowIndex].FindControl("lnkUpdate") as LinkButton;
            TextBox txtaccesscode = gvARCIns.Rows[e.RowIndex].FindControl("txtAccessCode") as TextBox;
            if (lkupdt.Text == "Insert")
            {
                db = new LinqToSqlDataContext();
                ARC_AccessCode obj = new ARC_AccessCode();
                if ((ddlArc.SelectedValue != null && ddlArc.SelectedValue != "0") && (!String.IsNullOrEmpty(txtaccesscode.Text)))
                {
                    obj.ARCID = Convert.ToInt16(ddlArc.SelectedValue);
                    if (ddlInstallerUnqCode.SelectedValue!="0")
                    obj.InstallerUniqueCode = Convert.ToInt16(ddlInstallerUnqCode.SelectedValue);
                    obj.Accesscode =   txtaccesscode.Text;

                    db.ARC_AccessCodes.InsertOnSubmit(obj);
                    db.SubmitChanges();
                    string script = "alertify.alert('" + ltrInsertSuccess.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);

                }
                else
                {
                    string script = "alertify.alert('" + ltrInsertFail.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    return;
                }
            }
            else
            {

                db = new LinqToSqlDataContext();
                ARC_AccessCode obj2 = db.ARC_AccessCodes.Single(data => data.ID == Convert.ToInt16(lkupdt.CommandArgument));
                if (obj2 != null)
                {
                    if ((ddlArc.SelectedValue != null && ddlArc.SelectedValue != "0") && (!String.IsNullOrEmpty(txtaccesscode.Text)))
                    {
                        obj2.ARCID = Convert.ToInt16(ddlArc.SelectedValue);
                        if (ddlInstallerUnqCode.SelectedValue!="0")
                        if (ddlInstallerUnqCode.SelectedValue != string.Empty)
                        {
                            obj2.InstallerUniqueCode = Convert.ToInt16(ddlInstallerUnqCode.SelectedValue);
                        }
                        obj2.Accesscode = txtaccesscode.Text;
                        db.SubmitChanges();
                        string script = "alertify.alert('" + ltrUpdateSuccess.Text + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    }
                    else
                    {
                        string script = "alertify.alert('" + ltrUpdateFail.Text + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        return;
                    }
                }
            }
            gvARCIns.EditIndex = -1;
            BindGrid();

            Audit audit = new Audit();
            audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
            audit.ChangeID = Convert.ToInt32(enumAudit.Manage_ARC_AccessCode);
            audit.CreatedOn = DateTime.Now;
            audit.Notes = "Insert - ARC: " + ddlArc.SelectedItem.ToString() + ", Installer: " + ddlInstallerUnqCode.ToString() + ", Access Code: " + txtaccesscode.Text;
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
            string script = "alertify.alert('" + objException.Message + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvARCIns_RowUpdating", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }


    protected void gvARCIns_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            LinkButton lkedit = gvARCIns.Rows[e.RowIndex].FindControl("lnkEdit") as LinkButton;
            int Id = Convert.ToInt16(lkedit.CommandArgument);
            db = new LinqToSqlDataContext();
            var rowtoDelete = (from data in db.ARC_AccessCodes.Where(d => d.ID == Id)
                               select data).SingleOrDefault();
            if (rowtoDelete != null)
            {
                db.ARC_AccessCodes.DeleteOnSubmit(rowtoDelete);
                db.SubmitChanges();
                string script = "alertify.alert('" + ltrDeleteSuccess.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
            else
            {
                string script = "alertify.alert('" + ltrDeleteFail.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
            BindGrid();

            Audit audit = new Audit();
            audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
            audit.ChangeID = Convert.ToInt32(enumAudit.Manage_ARC_AccessCode);
            audit.CreatedOn = DateTime.Now;
            audit.Notes = "Delete - " + rowtoDelete;
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
            string script = "alertify.alert('" + objException.Message + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvARCIns_RowDeleting", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }
}