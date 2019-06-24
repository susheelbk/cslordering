using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using CSLOrderingARCBAL;

public partial class ADMIN_OverrideBillingCodes : System.Web.UI.Page
{
    LinqToSqlDataContext db;
    public static int id;
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
            var overrideData = from a in db.OverideBillingCodes
                               select a;
            if (overrideData != null)
            {
                gvBillingCodes.DataSource = overrideData;
                gvBillingCodes.DataBind();
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

    protected void btnAddNew_Click(object sender, EventArgs e)
    {
        try
        {
            db = new LinqToSqlDataContext();
            var overideBillingCode = from a in db.OverideBillingCodes
                                     select a;
            DataTable dt1 = new DataTable();
            dt1.Columns.Add("id");
            dt1.Columns.Add("CompanyName");
            dt1.Columns.Add("OriginalCode");
            dt1.Columns.Add("OverideCode");


            foreach (var item in overideBillingCode)
            {
                dt1.Rows.Add(item.id, item.CompanyName, item.OriginalCode, item.OverideCode);
            }
            DataRow dr = dt1.NewRow();
            dt1.Rows.InsertAt(dr, 0);
            gvBillingCodes.EditIndex = 0;
            gvBillingCodes.DataSource = dt1;
            gvBillingCodes.DataBind();
            LinkButton lkupdate = gvBillingCodes.Rows[0].FindControl("lnkUpdate") as LinkButton;
            lkupdate.Text = "Insert";
        }
        catch (Exception objException)
        {
            string script = "alertify.alert('" + objException.Message + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnAddNew_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }
    protected void gvBillingCodes_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        e.Cancel = true;
        gvBillingCodes.EditIndex = -1;
        BindGrid();

    }
    protected void gvBillingCodes_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            Label lblId = (Label)gvBillingCodes.Rows[e.RowIndex].FindControl("lblID");
            int idToDelete = Convert.ToInt32(lblId.Text);
            db = new LinqToSqlDataContext();
            var overrideCodeToDelete = db.OverideBillingCodes.Single(a => a.id == idToDelete);
            if (overrideCodeToDelete != null)
            {
                db.OverideBillingCodes.DeleteOnSubmit(overrideCodeToDelete);
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
        }
        catch (Exception objException)
        {
            string script = "alertify.alert('" + objException.Message + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvBillingCodes_RowDeleting", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }
    protected void gvBillingCodes_RowEditing(object sender, GridViewEditEventArgs e)
    {
        try
        {
            Label lblCompanyName = (Label)gvBillingCodes.Rows[e.NewEditIndex].FindControl("lblCompanyName");
            Label lblOriginalCode = (Label)gvBillingCodes.Rows[e.NewEditIndex].FindControl("lblOriginalCode");
            Label lblOverrideCode = (Label)gvBillingCodes.Rows[e.NewEditIndex].FindControl("lblOverrideCode");
            Label lblId = (Label)gvBillingCodes.Rows[e.NewEditIndex].FindControl("lblID");
            gvBillingCodes.EditIndex = e.NewEditIndex;
            id = Convert.ToInt32(lblId.Text);
            BindGrid();
            TextBox txtCompanyName = (TextBox)gvBillingCodes.Rows[gvBillingCodes.EditIndex].FindControl("txtCompanyName");
            txtCompanyName.Text = lblCompanyName.Text;
            TextBox txtOriginalcode = (TextBox)gvBillingCodes.Rows[gvBillingCodes.EditIndex].FindControl("txtOriginalCode");
            txtOriginalcode.Text = lblOriginalCode.Text;
            TextBox txtOverrideCode= (TextBox)gvBillingCodes.Rows[gvBillingCodes.EditIndex].FindControl("txtOverrideCode");
            txtOverrideCode.Text = lblOverrideCode.Text;
        }
        catch (Exception objException)
        {
            string script = "alertify.alert('" + objException.Message + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvBillingCodes_RowEditing", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }
    protected void gvBillingCodes_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            GridViewRow row = gvBillingCodes.Rows[e.RowIndex];
            LinkButton lkupdt = gvBillingCodes.Rows[e.RowIndex].FindControl("lnkUpdate") as LinkButton;
            TextBox txtCompanyName = (TextBox)row.FindControl("txtCompanyName");
            TextBox txtOriginalCode = (TextBox)row.FindControl("txtOriginalCode");
            TextBox txtOverrideCode = (TextBox)row.FindControl("txtOverrideCode");
            if (lkupdt.Text == "Insert")
            {

                db = new LinqToSqlDataContext();

                OverideBillingCode billingCode = new OverideBillingCode();

                billingCode.CompanyName = txtCompanyName.Text;
                billingCode.OriginalCode = Convert.ToInt32(txtOriginalCode.Text);
                billingCode.OverideCode = Convert.ToInt32(txtOverrideCode.Text);
                db.OverideBillingCodes.InsertOnSubmit(billingCode);
                db.SubmitChanges();
                string script = "alertify.alert('" + ltrInsertSuccess.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);

            }
            else
            {

                string companyName = txtCompanyName.Text;
                int originalCode = Convert.ToInt32(txtOriginalCode.Text);
                int overrideCode = Convert.ToInt32(txtOverrideCode.Text);

                db = new LinqToSqlDataContext();

                var overrideData = db.OverideBillingCodes.Single(a => a.id == id);
                overrideData.CompanyName = companyName;
                overrideData.OriginalCode = originalCode;
                overrideData.OverideCode = overrideCode;
                db.SubmitChanges();
                string script = "alertify.alert('" + ltrUpdateSuccess.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
            gvBillingCodes.EditIndex = -1;
            BindGrid();
        }
        catch (Exception objException)
        {
            string script = "alertify.alert('" + objException.Message + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvBillingCodes_RowUpdating", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }
}