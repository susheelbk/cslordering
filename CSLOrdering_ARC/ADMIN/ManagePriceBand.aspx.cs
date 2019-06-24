using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;

public partial class ADMIN_ManagePriceBand : System.Web.UI.Page
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
                BindInstallerDropdown();
            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    #endregion

    #region Bind Installer DropDown


    /// <summary>
    /// Bind All Installer's with dropdown on page load  
    /// 
    /// </summary>
    private void BindInstallerDropdown()
    {
        db = new LinqToSqlDataContext();
        var Installerdata = (from inst in db.Installers
                             orderby inst.CompanyName ascending
                             where inst.IsActive == true
                             select new { inst.InstallerCompanyID, InstallerDisp = inst.CompanyName + " - [" + inst.UniqueCode + "] " });

        ddlInstaller.DataValueField = "InstallerCompanyID";
        ddlInstaller.DataTextField = "InstallerDisp";
        ddlInstaller.DataSource = Installerdata;
        ddlInstaller.DataBind();
        ddlInstaller.Items.Insert(0, new ListItem("-----------------------------------Select-----------------------------------", "0"));

        var priceBand = (from pbn in db.BandNameMasters
                         orderby pbn.BandName ascending
                         select pbn);

        ddlPriceBandMaster.DataValueField = "ID";
        ddlPriceBandMaster.DataTextField = "BandName";
        ddlPriceBandMaster.DataSource = priceBand;
        ddlPriceBandMaster.DataBind();
        ddlPriceBandMaster.Items.Insert(0, new ListItem("Select", "0"));
    }


    #endregion

    #region Bind selected Installer's Products

    /// <summary>
    /// Get product details of selected Installer 
    /// </summary>
    /// <param name="InstallerCompanyId"></param>
    #endregion

    #region Save ARC price

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                Audit audit = new Audit();
                string notes = null;
                if (ddlInstaller.SelectedIndex > 0)
                {
                    if (ddlPriceBandMaster.SelectedIndex > 0)
                    {
                        db = new LinqToSqlDataContext();
                        int retrun = -1;
                        var CompanyPriceBandMaps = (from cpb in db.CompanyPriceBandMaps
                                      where cpb.CompanyID == new Guid(ddlInstaller.SelectedValue)
                                      select cpb).SingleOrDefault();
                        if (CompanyPriceBandMaps != null)
                        {
                            CompanyPriceBandMaps.BandMasterID = Convert.ToInt32(ddlPriceBandMaster.SelectedValue); 
                             db.SubmitChanges();
                             string script = "alertify.alert('Price Band successfully updated');";
                             ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        }
                        else
                        {
                            CompanyPriceBandMap cpbm =  new CompanyPriceBandMap(); 
                            cpbm.CompanyID = new Guid(ddlInstaller.SelectedValue);
                            cpbm.BandMasterID = Convert.ToInt32(ddlPriceBandMaster.SelectedValue); 
                            db.CompanyPriceBandMaps.InsertOnSubmit(cpbm); 
                            db.SubmitChanges();
                            
                            string script = "alertify.alert('Price Band successfully assigned');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        }

                        audit.Notes = "ARC: " + ddlInstaller.SelectedItem.ToString() + ", " + notes;
                        audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
                        audit.ChangeID = Convert.ToInt32(enumAudit.Manage_ARC_Product_Price);
                        audit.CreatedOn = DateTime.Now;
                        if (Request.ServerVariables["LOGON_USER"] != null)
                        {
                            audit.WindowsUser = Request.ServerVariables["LOGON_USER"];
                        }
                        audit.IPAddress = Request.UserHostAddress;
                        db.Audits.InsertOnSubmit(audit);
                        db.SubmitChanges();
                        ddlInstaller_SelectedIndexChanges(sender, e);
                    }

                }
                else
                {
                    string script = "alertify.alert('" + ltrSelectInstaller.Text + "');";
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


    #region Get Products by selected Installer

    protected void ddlInstaller_SelectedIndexChanges(object sender, EventArgs e)
    {
        try
        {
            if (ddlInstaller.SelectedIndex > 0)
            {
                LinqToSqlDataContext db = new LinqToSqlDataContext();
                var BandName = (from c in db.CompanyPriceBandMaps
                              join bn in db.BandNameMasters on c.BandMasterID equals bn.ID
                              where c.CompanyID == new Guid(ddlInstaller.SelectedValue)
                              select bn.BandName).FirstOrDefault();

               if (!string.IsNullOrWhiteSpace(BandName))
               { lblCurrentPriceBand.Text = BandName; }

               trCurrentBand.Visible = true;
               trUpdatePriceBand.Visible = true;
               ddlPriceBandMaster.SelectedIndex = 0;
            }
            else
            {
                string script = "alertify.alert('" + ltrSelectInstaller.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                btnSave.Visible = false;
                return;
            }
        }
        catch (Exception objException)
        {

            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "ddlArc_SelectedIndexChanges", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
        finally
        {
            if (db != null)
                db.Dispose();
        }


    }

    #endregion
   
}