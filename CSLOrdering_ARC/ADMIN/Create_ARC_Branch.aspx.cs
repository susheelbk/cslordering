using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;

public partial class ADMIN_Create_ARC_Branch : System.Web.UI.Page
{
    #region Variable
    LinqToSqlDataContext db; 
    #endregion

    #region Page Load

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                BindARCDropdown();
            }
        }
        catch (Exception objException)
        {
            using (db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }

    }

    #endregion

    #region Bind ARC DropDown


    /// <summary>
    /// Bind All ARC's with dropdown on page load  
    /// 
    /// </summary>
    private void BindARCDropdown()
    {

        try
        {
            using(db = new LinqToSqlDataContext())
            {
                var ARCdata = (from arc in db.ARCs
                               orderby arc.CompanyName ascending
                               where arc.IsDeleted == false && arc.IsARCAllowedForBranch==true
                               select new { arc.ARCId, ARCDisp = arc.CompanyName + " - [" + arc.ARC_Code + "] " });
                if (ARCdata.Count() > 0)
                {
                    ddlArc.DataValueField = "ARCId";
                    ddlArc.DataTextField = "ARCDisp";
                    ddlArc.DataSource = ARCdata;
                    ddlArc.DataBind();
                    ddlArc.Enabled = true;
                    ddlArc.Items.Insert(0, new ListItem("-----------------------------------Select-----------------------------------", "0"));
                    lblNOARCsAvailable.Visible = false;
                    ddlArc.Visible = true;
                }
                else
                {
                    lblNOARCsAvailable.Visible = true;
                    ddlArc.Visible = false;
                }
                
                //if(ARCdata.Count==0)
            }
        }
        catch(Exception objException)
        {
              using (db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "BindARCDropdown", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }



    }


    #endregion

    #region Bind ARC Branches for selected ARC
    /// <summary>
    /// Get ARC Branches for selected ARC 
    /// </summary>
    /// <param name="arcId"></param>
    private void BindArcBranches(int arcId)
    {
        try
        {
            using (db = new LinqToSqlDataContext())
            {
                var arcBranchData = db.AlarmDeliveryARCMappings.Where(x => x.ARCId == arcId); // call sp
                gvArcBranches.DataSource = arcBranchData;
                gvArcBranches.DataBind();
                if (gvArcBranches.Rows.Count == 0)
                {
                    //btnDeleted.Visible = false;
                    string script = "alertify.alert('" + ltrNoMap.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);

                }
                else
                {
                    //btnDeleted.Visible = true;
                }
            }
        }
        catch(Exception objException)
        {
            using (db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "BindArcBranches", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
       
    }


    #endregion

    #region Save ARC Branch
    protected void btnSave_Click(object sender, EventArgs e)
    {
        Page.Validate();
        if (Page.IsValid)
        {
            try
            {
                AlarmDeliveryARCMapping adArcMapping = new AlarmDeliveryARCMapping();
                if (ddlArc.SelectedIndex > 0)
                {
                    using (db = new LinqToSqlDataContext())
                    {
                        if (db.AlarmDeliveryARCMappings.Where(a => a.ARCId == Convert.ToInt32(ddlArc.SelectedValue) && a.Branch_ARC_Code == txtBranchArcCode.Text || a.Branch_ARC_Name == txtBranchArcName.Text).Any() && Convert.ToInt32(hdnAlarmDelARCMapId.Value)==0)
                        {
                            string script = "alertify.alert('" + ltrAlreadyExits.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            return;
                        }
                        else if (Convert.ToInt32(hdnAlarmDelARCMapId.Value) > 0)
                        {
                            var alarmDelARCMapping = (from p in db.AlarmDeliveryARCMappings where p.ID == Convert.ToInt32(hdnAlarmDelARCMapId.Value) && p.ARCId == Convert.ToInt32(ddlArc.SelectedValue.ToString()) select p).Single();
                            alarmDelARCMapping.Branch_ARC_Code = txtBranchArcCode.Text;
                            alarmDelARCMapping.Branch_ARC_Name = txtBranchArcName.Text;
                            adArcMapping.Branch_ARC_Identifier = txtBranchArcIdentifier.Text;
                            alarmDelARCMapping.ModifiedOn = DateTime.Now;
                            alarmDelARCMapping.ModifiedBy = Session[enumSessions.User_Id.ToString()].ToString();
                            alarmDelARCMapping.IsDeleted = chkIsDeleted.Checked;
                            db.SubmitChanges();
                            string script = "alertify.alert('" + ltrUpdateArcBranch.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            ClearData();
                        }
                        else
                        {
                            adArcMapping.ARCId = Convert.ToInt32(ddlArc.SelectedValue);
                            adArcMapping.Branch_ARC_Code = txtBranchArcCode.Text;
                            adArcMapping.Branch_ARC_Name = txtBranchArcName.Text;
                            adArcMapping.Branch_ARC_Identifier = txtBranchArcIdentifier.Text;
                            adArcMapping.IsDeleted = false;
                            adArcMapping.CreatedOn = DateTime.Now;
                            adArcMapping.CreatedBy = Session[enumSessions.User_Id.ToString()].ToString();
                            db.AlarmDeliveryARCMappings.InsertOnSubmit(adArcMapping);
                            db.SubmitChanges();
                            
                            
                            string script = "alertify.alert('" + ltrCreateArc.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            ClearData();
                        }
                        chkIsDeleted.Visible = false;
                        
                    }
                    BindArcBranches(Convert.ToInt32(ddlArc.SelectedValue));
                    
                }
                else
                {
                    string script = "alertify.alert('" + ltrSelectARC.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                }                 
                
            }
            catch (Exception objException)
            {

                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSave_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
            finally
            {
                if (db != null)
                    db.Dispose();
            }
        }
    }

    #endregion

    #region Clear Data
    private void ClearData()
    {
        txtBranchArcCode.Text="";
        txtBranchArcName.Text="";
        txtBranchArcIdentifier.Text="";
        hdnAlarmDelARCMapId.Value="0";
    }
    #endregion
    #region Get Branaches by selected ARC

    protected void ddlArc_SelectedIndexChanges(object sender, EventArgs e)
    {

        try
        {
            hdnAlarmDelARCMapId.Value = "0";
            if (ddlArc.SelectedIndex > 0)
            {
                BindArcBranches(Convert.ToInt32(ddlArc.SelectedValue.ToString()));
                btnSave.Visible = true;

            }
            else
            {
                string script = "alertify.alert('" + ltrSelectARC.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                btnSave.Visible = false;
                //btnDeleted.Visible = false;
                gvArcBranches.DataSource = null;
                gvArcBranches.DataBind();
                return;
            }
            if (gvArcBranches.Rows.Count > 0)
            {
                btnSave.Visible = true;
                //btnDeleted.Visible = true;
            }
            else
            {
                //btnSave.Visible = false;
                //btnDeleted.Visible = false;
            }
        }
        catch (Exception objException)
        {
            using (db = new CSLOrderingARCBAL.LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "ddlArc_SelectedIndexChanges", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
        finally
        {
            if (db != null)
                db.Dispose();
        }


    }

    #endregion
    /// <summary>
    /// The purpose of this method to delete the selected ARC branches.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnDeleted_Click(object sender, EventArgs e)
    {
        try
        {
            db = new LinqToSqlDataContext();
            int alarmDelArcId=0;
            bool isDeletedRecords = false;
            foreach (GridViewRow row in gvArcBranches.Rows)
            {
                alarmDelArcId=Convert.ToInt32(gvArcBranches.DataKeys[row.RowIndex].Value.ToString());
                if (!String.IsNullOrEmpty((row.FindControl("ARCId") as Label).Text))
                {
                    Int32 arcId = Convert.ToInt32((row.FindControl("ARCId") as Label).Text);
                    Boolean isDeleted = (row.FindControl("chkDelete") as CheckBox).Checked;
                    if (isDeleted == true)
                    {
                        var alarmDelARCMapping = (from p in db.AlarmDeliveryARCMappings where p.ID == alarmDelArcId && p.ARCId == Convert.ToInt32(ddlArc.SelectedValue.ToString()) select p).Single();
                        alarmDelARCMapping.IsDeleted = true;
                        alarmDelARCMapping.ModifiedOn = DateTime.Now;
                        alarmDelARCMapping.ModifiedBy = Session[enumSessions.User_Id.ToString()].ToString();
                        db.SubmitChanges();
                        isDeletedRecords = true;
                    }

                    
                }
            }
            if (isDeletedRecords)
            {
                string script = "alertify.alert('" + ltrArcBranchDeleted.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
            else
            {
                string script = "alertify.alert('" + ltrNoSelectedToDelete.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
            BindArcBranches(Convert.ToInt32(ddlArc.SelectedValue.ToString())); // bind grid after delete ARC price 
            
        }
        catch (Exception objException)
        {

            using (db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnDeleted_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
        finally
        {
            if (db != null)
                db.Dispose();
        }


    }

    #region gvArcBranches Paging

    protected void gvArcBranches_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            gvArcBranches.PageIndex = e.NewPageIndex;
            BindArcBranches(Convert.ToInt32(ddlArc.SelectedValue.ToString()));
        }
        catch (Exception objException)
        {
            
            using (db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "gvArcBranches_PageIndexChanging", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }

        }

    }

    #endregion
    /// <summary>
    /// The purpose of this method to edit the ARC branches details
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void lnkEdit_Click(object sender, EventArgs e)
    {
        try
        {
            LinkButton lnkbtn = (LinkButton)sender;
            GridViewRow gvRow = (GridViewRow)lnkbtn.NamingContainer;
            int alarmDelArcId = 0;
            alarmDelArcId = Convert.ToInt32(gvArcBranches.DataKeys[gvRow.RowIndex].Value.ToString());
            if (alarmDelArcId > 0)
            {
                hdnAlarmDelARCMapId.Value = Convert.ToString(alarmDelArcId);
                using (db = new LinqToSqlDataContext())
                {
                    var alarmDelARCMap = db.AlarmDeliveryARCMappings.Where(x => x.ID == alarmDelArcId).Single();
                    if (alarmDelARCMap != null)
                    {
                        txtBranchArcCode.Text = alarmDelARCMap.Branch_ARC_Code;
                        txtBranchArcName.Text = alarmDelARCMap.Branch_ARC_Name;
                        txtBranchArcIdentifier.Text = alarmDelARCMap.Branch_ARC_Identifier;
                        chkIsDeleted.Checked = alarmDelARCMap.IsDeleted;
                        chkIsDeleted.Visible = true;
                    }
                }
            }
        }
        catch (Exception objException)
        {

            using (db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "lnkEdit_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }

        }

    }
}