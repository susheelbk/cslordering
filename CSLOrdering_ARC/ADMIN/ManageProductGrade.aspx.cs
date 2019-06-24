using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;
using CSLOrderingARCBAL.BAL;
using CSLOrderingARCBAL.Common;
using System.Data;


public partial class ADMIN_ManageProductGrade : System.Web.UI.Page
{
    public string listProductCode = null;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadData();
        }
    }

    [System.Web.Services.WebMethod]
    [System.Web.Script.Services.ScriptMethod]
    public static string[] GetCompletionList(string prefixText)
    {

        String[] dt = ProductBAL.GetProductCodeList(prefixText);

        return dt.ToArray();
    }

    public void LoadData()
    {
        CSLOrderingARCBAL.LinqToSqlDataContext db = null;
        try
        {

            ddlGrade.DataSource = ProductBAL.GradeList();
            ddlGrade.DataTextField = "Grade";
            ddlGrade.DataValueField = "Grade";
            ddlGrade.DataBind();

            gvGrade.DataSource = ProductBAL.GetProductGrade();
            gvGrade.DataBind();

        }

        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LoadData", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            db.Dispose();
        }
    }


    protected void btnSave_Click(object sender, EventArgs e)
    {
        string productCode = "";
        if (!String.IsNullOrEmpty(txtProductCode.Text.Trim()))
        {

            ProductCode_Grade_Map objGrade = new ProductCode_Grade_Map();

            objGrade.ProductCode = txtProductCode.Text.Trim();
            productCode = txtProductCode.Text.Trim();
            objGrade.Grade = ddlGrade.SelectedValue.ToString();
            objGrade.CreatedOn = DateTime.Now;
            objGrade.CreatedBy = Session[enumSessions.User_Name.ToString()].ToString();
            objGrade.IsDeleted = false;
            Boolean flag = false;
            if (ViewState["ProductGradeID"] != null)
            {
                objGrade.ProductGradeID = Convert.ToInt32(ViewState["ProductGradeID"]);
                flag = ProductBAL.UpdateProductGrade(objGrade);
            }
            else
            {
                flag = ProductBAL.InsertProductGrade(objGrade);
            }
            if (flag == false)
            {
                string script = "alertify.alert('" + ltrDuplicate.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
            else
            {
                string script = "alertify.alert('" + ltrSaved.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }

            LoadData();
            ClearControl();
            ViewState["ProductGradeID"] = null;
        }
        pnlGradeDetails.Visible = false;
        pnlGradeList.Visible = true;

        LinqToSqlDataContext db = new LinqToSqlDataContext();
        Audit audit = new Audit();
        audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
        audit.ChangeID = Convert.ToInt32(enumAudit.Manage_Products_Grade);
        audit.CreatedOn = DateTime.Now;
        audit.Notes = "Grade: " + ddlGrade.SelectedValue.ToString() + ", Product Code: " + productCode;
        if (Request.ServerVariables["LOGON_USER"] != null)
        {
            audit.WindowsUser = Request.ServerVariables["LOGON_USER"];
        }
        audit.IPAddress = Request.UserHostAddress;
        db.Audits.InsertOnSubmit(audit);
        db.SubmitChanges();
    }



    private void ClearControl()
    {
        txtProductCode.Text = String.Empty;
    }

    protected void LinkButtonupdate_click(object sender, System.EventArgs e)
    {
        CSLOrderingARCBAL.LinqToSqlDataContext db = null;
        try
        {
            pnlGradeDetails.Visible = true;
            pnlGradeList.Visible = false;
            litAction.Text = "You choose to <b>EDIT GRADE MAPPING</b>";
            LinkButton lbctg = sender as LinkButton;
            if (lbctg != null)
            {
                GridViewRow gvr = (GridViewRow)lbctg.NamingContainer;
                Label lbl1 = gvr.FindControl("lblProductGradeID") as Label;
                ViewState["ProductGradeID"] = lbl1.Text;
            }

            db = new LinqToSqlDataContext();
            var usrDtls = ProductBAL.GetProductGradeById(Convert.ToInt32(ViewState["ProductGradeID"].ToString()));


            if (usrDtls != null)
            {
                txtProductCode.Text = usrDtls.ProductCode;
                ddlGrade.SelectedValue = usrDtls.Grade.ToString();
            }

            db.Dispose();

        }
        catch (Exception objException)
        {

            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LinkButtonupdate_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            db.Dispose();
        }
    }

    protected void LinkButtondelete_click(object sender, System.EventArgs e)
    {
        CSLOrderingARCBAL.LinqToSqlDataContext db = null;
        try
        {
            LinkButton lbdel = sender as LinkButton;
            if (lbdel != null)
            {
                GridViewRow gvr = (GridViewRow)lbdel.NamingContainer;
                Label lbl2 = gvr.FindControl("lblProductGradeID") as Label;
                ViewState["ProductGradeID"] = lbl2.Text;
            }
            else
            {
                //Reset 
                if (ViewState["ProductGradeID"] != null)
                { }
                else
                {
                    //Do a cancel as no value in ViewState
                    btnCancel_Click(sender, e);
                }
            }
            db = new LinqToSqlDataContext();
            Boolean retunStatus = ProductBAL.DeleteProductGrade(Convert.ToInt32(ViewState["ProductGradeID"].ToString()));
            if (retunStatus == true)
            {
                LoadData();
                string script = "alertify.alert('" + ltrGrade.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }

        }
        catch (Exception objException)
        {

            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LinkButtondelete_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            db.Dispose();
        }

    }


    protected void btnNewGrade_Click(object sender, EventArgs e)
    {

        pnlGradeDetails.Visible = true;
        pnlGradeList.Visible = false;
        litAction.Text = "You choose to <b>ADD NEW GRADE MAPPING</b>";
        txtProductCode.Focus();
        LoadData();
        ClearControl();


    }
    protected void btnReset_Click(object sender, EventArgs e)
    {
        if (ViewState["ProductGradeID"] != null)
        {
            LinkButtonupdate_click(sender, e);
        }
        else
        {
            btnNewGrade_Click(sender, e);
        }


    }


    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ViewState["ProductGradeID"] = null;
        pnlGradeList.Visible = true;
        pnlGradeDetails.Visible = false;

    }
}