using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using CSLOrderingARCBAL;
using CSLOrderingARCBAL.Common;
using CSLOrderingARCBAL.BAL;
using System.Data.Sql;
using System.IO;
using System.Configuration;

public partial class ADMIN_AdministratorUI : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            LoadDistributerList();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        SearchDistributerUIByURLName(txtDName.Text);
    }

    protected void btnShowAll_Click(object sender, EventArgs e)
    {
        LoadDistributerList();
    }

    protected void btnnewdistributor_Click(object sender, EventArgs e)
    {
        ClearControls();
        btnConfirm.Visible = true;
        pnldistributordetails.Visible = true;
    }

    protected void gvDistributors_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            gvDistributors.PageIndex = e.NewPageIndex;
            LoadDistributerList();
            BindDistributerGrid();
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvDistributors_PageIndexChanging", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }
    }

    private void BindDistributerGrid()
    {
        //binding all ARCs in ARC grid
        LinqToSqlDataContext db = new LinqToSqlDataContext();
        var distributers = (from dt in db.DistributerUIDetails                   
                   orderby dt.UrlName ascending
                   select dt);
        gvDistributors.DataSource = distributers;
        gvDistributors.DataBind();
    }

    protected void LinkButtonupdate_Click(object sender, EventArgs e)
    {
        LinkButton lbdistributer = sender as LinkButton;

        if (lbdistributer != null)
        {
            GridViewRow gvr = (GridViewRow)lbdistributer.NamingContainer;
            Label lbl1 = gvr.FindControl("IDKey") as Label;
            Session[enumSessions.DistributerIdToUpdate.ToString()] = lbl1.Text;
        }
        try
        {
            btnConfirm.Visible = true;
            GetDistributorForId(Convert.ToInt32(Session[enumSessions.DistributerIdToUpdate.ToString()]));
            pnldistributordetails.Visible = true;
        }
        catch (Exception ex)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LinkbuttonUpdate_click", Convert.ToString(ex.Message), Convert.ToString(ex.InnerException), Convert.ToString(ex.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            string script = "alertify.alert('URLName " + txtUrlName.Text + " update failed.');";
        }

    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ClearControls();
        btnConfirm.Visible = false;
        pnldistributordetails.Visible = false;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {

        DistributerUIDetail distributer;
        try
        {
            distributer = new DistributerUIDetail();
            distributer = LoadDataFromForm();

            CSLOrderingARCBAL.BAL.DistributorBAL bal = new DistributorBAL();
            bal.SaveDistributor(distributer);
            LoadDistributerList();

            btnConfirm.Visible = true;
            
            string script = "alertify.alert('URLName " + txtUrlName.Text + " update successful.');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            MaintainScrollPositionOnPostBack = false;
            
        }

        catch (Exception ex)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnShowAll_Click", Convert.ToString(ex.Message), Convert.ToString(ex.InnerException), Convert.ToString(ex.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            string script = "alertify.alert('URLName " + txtUrlName.Text + " update failed.');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            MaintainScrollPositionOnPostBack = false;
        }
    }

    protected void btnPreview_Click(object sender, EventArgs e)
    {
        Session["PreviewData"] = LoadPreviewData();
        string applicationUrl = ConfigurationManager.AppSettings["ApplicationURL"].ToString();
       
       ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('Preview.aspx','mywindow','menubar=1,resizable=1');", true);
    }

    protected void btnConfirm_Click(object sender, EventArgs e)
    {
        DistributerUIDetail distributer = new DistributerUIDetail();
        DistributorBAL distributerBAL = new DistributorBAL();
        distributer = distributerBAL.GetDistributerUIByName(txtUrlName.Text);


        if (!string.IsNullOrEmpty(distributer.HeaderImage))
        {
            try
            {
                string sourceFileName = ConfigurationManager.AppSettings["ARCImagesPath"] + distributer.HeaderImage;
                string destinationFileName = ConfigurationManager.AppSettings["M2MImagesPath"] + distributer.HeaderImage;

                System.IO.File.Copy(sourceFileName, destinationFileName, true);

            }
            catch (Exception ex)
            {
                string script1 = "alertify.alert('Upload status for HeaderImage: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script1, true);
                MaintainScrollPositionOnPostBack = false;
            }
        }

        if (!string.IsNullOrEmpty(distributer.BannerImage))
        {
            try
            {
                string sourceFileName = ConfigurationManager.AppSettings["ARCImagesPath"] + distributer.BannerImage;
                string destinationFileName = ConfigurationManager.AppSettings["M2MImagesPath"] + distributer.BannerImage;

                System.IO.File.Copy(sourceFileName, destinationFileName, true);

            }
            catch (Exception ex)
            {
                string script1 = "alertify.alert('Upload status for BannerImage: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script1, true);
                MaintainScrollPositionOnPostBack = false;
            }
        }

        if (!string.IsNullOrEmpty(distributer.Footer4Image))
        {
            try
            {
                string sourceFileName = ConfigurationManager.AppSettings["ARCImagesPath"] + distributer.Footer4Image;
                string destinationFileName = ConfigurationManager.AppSettings["M2MImagesPath"] + distributer.Footer4Image;

                System.IO.File.Copy(sourceFileName, destinationFileName, true);

            }
            catch (Exception ex)
            {
                string script2 = "alertify.alert('Upload status for Footer4Image: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script2, true);
                MaintainScrollPositionOnPostBack = false;

            }
        }


        if (!string.IsNullOrEmpty(distributer.Footer3Image))
        {
            try
            {
                string sourceFileName = ConfigurationManager.AppSettings["ARCImagesPath"] + distributer.Footer3Image;
                string destinationFileName = ConfigurationManager.AppSettings["M2MImagesPath"] + distributer.Footer3Image;

                System.IO.File.Copy(sourceFileName, destinationFileName, true);

            }
            catch (Exception ex)
            {
                string script2 = "alertify.alert('Upload status for Footer3Image: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script2, true);
                MaintainScrollPositionOnPostBack = false;

            }
        }

        if (!string.IsNullOrEmpty(distributer.Footer2Image))
        {
            try
            {
                string sourceFileName = ConfigurationManager.AppSettings["ARCImagesPath"] + distributer.Footer2Image;
                string destinationFileName = ConfigurationManager.AppSettings["M2MImagesPath"] + distributer.Footer2Image;

                System.IO.File.Copy(sourceFileName, destinationFileName, true);

            }
            catch (Exception ex)
            {
                string script3 = "alertify.alert('Upload status for Footer2Image: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script3, true);
                MaintainScrollPositionOnPostBack = false;

            }
        }

        if (!string.IsNullOrEmpty(distributer.Footer1Image))
        {
            try
            {
                string sourceFileName = ConfigurationManager.AppSettings["ARCImagesPath"] + distributer.Footer1Image;
                string destinationFileName = ConfigurationManager.AppSettings["M2MImagesPath"] + distributer.Footer1Image;

                System.IO.File.Copy(sourceFileName, destinationFileName, true);
            }
            catch (Exception ex)
            {
                string script4 = "alertify.alert('Upload status for Footer1Image: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script4, true);
                MaintainScrollPositionOnPostBack = false;
            }
        }

        if (!string.IsNullOrEmpty(distributer.MainImage))
        {
            try
            {
                string sourceFileName = ConfigurationManager.AppSettings["ARCImagesPath"] + distributer.MainImage;
                string destinationFileName = ConfigurationManager.AppSettings["M2MImagesPath"] + distributer.MainImage;

                System.IO.File.Copy(sourceFileName, destinationFileName, true);

            }
            catch (Exception ex)
            {
                string script6 = "alertify.alert('Upload status for MainImage: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script6, true);
                MaintainScrollPositionOnPostBack = false;
            }
        }

        try
        {
            distributerBAL.UpdateForConfirmation(txtUrlName.Text);
        }
        catch (Exception ex)
        {
            string script5 = "alertify.alert('Failed to update the Active flag. The following error occured: '" + ex.Message + ")";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script5, true);
            MaintainScrollPositionOnPostBack = false;
        }
        string script = "alertify.alert('URLName " + txtUrlName.Text + " confirm successful.');";
        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
        MaintainScrollPositionOnPostBack = false;
    }

    protected void btnDeleteFooter1_Click(object sender, EventArgs e)
    {
        
      
        string footer1ImageFile = Path.GetFileName(Server.MapPath(imgFooter1Image.ImageUrl));
        DistributorBAL distributerBAL = new DistributorBAL();
        if (!string.IsNullOrEmpty(footer1ImageFile))
        {
            try
            {
                //Delete images from M2m and ArcOrdering
                DeleteFooterImagesFiles(footer1ImageFile);

                //delete from db
                distributerBAL.DeleteFooter(Footers.Footer1.ToString(), txtUrlName.Text);

                btnConfirm.Visible = true;
                GetDistributorForId(Convert.ToInt32(Session[enumSessions.DistributerIdToUpdate.ToString()]));
                pnldistributordetails.Visible = true;


                string script1 = "alertify.alert('Footer1 deleted succeussfully.')";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script1, true);
                MaintainScrollPositionOnPostBack = false;
            }
            catch (Exception ex)
            {

                CSLOrderingARCBAL.LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnDeleteFooter1_Click", Convert.ToString(ex.Message), Convert.ToString(ex.InnerException), Convert.ToString(ex.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

                string script1 = "alertify.alert('Upload status for HeaderImage: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script1, true);
                MaintainScrollPositionOnPostBack = false;
            }
        }

        
    }

    protected void btnDeleteFooter2_Click(object sender, EventArgs e)
    {
        string footer2ImageFile = Path.GetFileName(Server.MapPath(imgFooter2Image.ImageUrl));
        DistributorBAL distributerBAL = new DistributorBAL();
        if (!string.IsNullOrEmpty(footer2ImageFile))
        {
            try
            {

                //Delete image from M2m and ArcOrdering
                DeleteFooterImagesFiles(footer2ImageFile);

                //delete from db
                distributerBAL.DeleteFooter(Footers.Footer2.ToString(), txtUrlName.Text);

                btnConfirm.Visible = true;
                GetDistributorForId(Convert.ToInt32(Session[enumSessions.DistributerIdToUpdate.ToString()]));
                pnldistributordetails.Visible = true;

                string script1 = "alertify.alert('Footer2 deleted succeussfully.')";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script1, true);
                MaintainScrollPositionOnPostBack = false;
            }
            catch (Exception ex)
            {

                CSLOrderingARCBAL.LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnDeleteFooter2_Click", Convert.ToString(ex.Message), Convert.ToString(ex.InnerException), Convert.ToString(ex.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

                string script1 = "alertify.alert('Upload status for HeaderImage: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script1, true);
                MaintainScrollPositionOnPostBack = false;
            }
        }

    }

    protected void btnDeleteFooter3_Click(object sender, EventArgs e)
    {
        string footer3ImageFile = Path.GetFileName(Server.MapPath(imgFooter3Image.ImageUrl));
        DistributorBAL distributerBAL = new DistributorBAL();
        if (!string.IsNullOrEmpty(footer3ImageFile))
        {
            try
            {

                //Delete images from M2m and ArcOrdering
                DeleteFooterImagesFiles(footer3ImageFile);

                //delete from db
                distributerBAL.DeleteFooter(Footers.Footer3.ToString(), txtUrlName.Text);

                btnConfirm.Visible = true;
                GetDistributorForId(Convert.ToInt32(Session[enumSessions.DistributerIdToUpdate.ToString()]));
                pnldistributordetails.Visible = true;

                string script1 = "alertify.alert('Footer3 deleted succeussfully.')";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script1, true);
                MaintainScrollPositionOnPostBack = false;
            }
            catch (Exception ex)
            {

                CSLOrderingARCBAL.LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnDeleteFooter3_Click", Convert.ToString(ex.Message), Convert.ToString(ex.InnerException), Convert.ToString(ex.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

                string script1 = "alertify.alert('Upload status for HeaderImage: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script1, true);
                MaintainScrollPositionOnPostBack = false;
            }
        }

    }

    protected void btnDeleteFooter4_Click(object sender, EventArgs e)
    {
        string footer4ImageFile = Path.GetFileName(Server.MapPath(imgFooter4Image.ImageUrl));
        DistributorBAL distributerBAL = new DistributorBAL();
        if (!string.IsNullOrEmpty(footer4ImageFile))
        {
            try
            {

               
                //Delete from M2m and ArcOrdering
                DeleteFooterImagesFiles(footer4ImageFile);

                //delete from db 
                distributerBAL.DeleteFooter(Footers.Footer4.ToString(), txtUrlName.Text);

                btnConfirm.Visible = true;
                GetDistributorForId(Convert.ToInt32(Session[enumSessions.DistributerIdToUpdate.ToString()]));
                pnldistributordetails.Visible = true;

                string script1 = "alertify.alert('Footer4 deleted succeussfully.')";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script1, true);
                MaintainScrollPositionOnPostBack = false;
            }
            catch (Exception ex)
            {

                CSLOrderingARCBAL.LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnDeleteFooter4_Click", Convert.ToString(ex.Message), Convert.ToString(ex.InnerException), Convert.ToString(ex.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

                string script1 = "alertify.alert('Upload status for HeaderImage: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script1, true);
                MaintainScrollPositionOnPostBack = false;
            }
        }
    }


#region Private methods
    private void DeleteFooterImagesFiles(string footerImageFile)
    {
        //Delete from ArcOrdering
                  
            if (File.Exists(ConfigurationManager.AppSettings["ARCImagesPath"].ToString() + footerImageFile))
                File.Delete(ConfigurationManager.AppSettings["ARCImagesPath"].ToString() + footerImageFile);
      
        //Delete from M2m
           if (File.Exists(ConfigurationManager.AppSettings["M2MImagesPath"].ToString() + footerImageFile))
                File.Delete(ConfigurationManager.AppSettings["M2MImagesPath"].ToString() + footerImageFile);
        
    }

    private DistributerUIDetail LoadDataFromForm()
    {
        DistributerUIDetail distributer = new DistributerUIDetail();
        distributer.ID = Session[enumSessions.DistributerIdToUpdate.ToString()] != null ? Convert.ToInt32(Session[enumSessions.DistributerIdToUpdate.ToString()]) : -1;

        distributer.Footer1Text = txtFooter1Text.Text;
        distributer.Footer1URL = txtFooter1URL.Text;
        distributer.Footer2Text = txtFooter2Text.Text;
        distributer.Footer2URL = txtFooter2URL.Text;
        distributer.Footer3Text = txtFooter3Text.Text;
        distributer.Footer3URL = txtFooter3URL.Text;
        distributer.Footer4Text = txtFooter4Text.Text;
        distributer.Footer4URL = txtFooter4URL.Text;
        distributer.FooterBgColor = string.IsNullOrEmpty(txtFooterBgColor.Text)?ConfigurationManager.AppSettings["DefaultFooterBgColor"].ToString(): txtFooterBgColor.Text;
        distributer.FooterTextColor = string.IsNullOrEmpty(txtFooterTextColor.Text)?ConfigurationManager.AppSettings["DefaultFooterTextColor"].ToString(): txtFooterTextColor.Text;

        if (fuHeaderImage.HasFile)
        {
            try
            {
                string filename = txtUrlName.Text + "_" + "HeaderImage" + Path.GetExtension(fuHeaderImage.FileName);
                if (File.Exists(Server.MapPath("../DistributerImages/") + filename))
                    File.Delete(Server.MapPath("../DistributerImages/") + filename);

                fuHeaderImage.SaveAs(Server.MapPath("../DistributerImages/") + filename);
                distributer.HeaderImage = filename;
            }
            catch (Exception ex)
            {
                string script = "alertify.alert('Upload status for HeaderImage: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                MaintainScrollPositionOnPostBack = false;
            }
        }

        if (fuFooter4Image.HasFile)
        {
            try
            {
                string filename = txtUrlName.Text + "_" + "Footer4Image" + Path.GetExtension(fuFooter4Image.FileName);
                if (File.Exists(Server.MapPath("../DistributerImages/") + filename))
                    File.Delete(Server.MapPath("../DistributerImages/") + filename);
                fuFooter4Image.SaveAs(Server.MapPath("../DistributerImages/") + filename);
                distributer.Footer4Image = filename;
            }
            catch (Exception ex)
            {
                string script = "alertify.alert('Upload status for Footer1Image: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                MaintainScrollPositionOnPostBack = false;
            }
        }

        if (fuFooter3Image.HasFile)
        {
            try
            {
                string filename = txtUrlName.Text + "_" + "Footer3Image" + Path.GetExtension(fuFooter3Image.FileName);
                if (File.Exists(Server.MapPath("../DistributerImages/") + filename))
                    File.Delete(Server.MapPath("../DistributerImages/") + filename);
                fuFooter3Image.SaveAs(Server.MapPath("../DistributerImages/") + filename);
                distributer.Footer3Image = filename;
            }
            catch (Exception ex)
            {
                string script = "alertify.alert('Upload status for Footer3Image: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                MaintainScrollPositionOnPostBack = false;

            }
        }

        if (fuFooter2Image.HasFile)
        {
            try
            {
                string filename = txtUrlName.Text + "_" + "Footer2Image" + Path.GetExtension(fuFooter2Image.FileName);
                if (File.Exists(Server.MapPath("../DistributerImages/") + filename))
                    File.Delete(Server.MapPath("../DistributerImages/") + filename);
                fuFooter2Image.SaveAs(Server.MapPath("../DistributerImages/") + filename);
                distributer.Footer2Image = filename;
            }
            catch (Exception ex)
            {
                string script = "alertify.alert('Upload status for Footer2Image: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                MaintainScrollPositionOnPostBack = false;

            }
        }

        if (fuFooter1Image.HasFile)
        {
            try
            {
                string filename = txtUrlName.Text + "_" + "Footer1Image" + Path.GetExtension(fuFooter1Image.FileName);
                if (File.Exists(Server.MapPath("../DistributerImages/") + filename))
                    File.Delete(Server.MapPath("../DistributerImages/") + filename);
                fuFooter1Image.SaveAs(Server.MapPath("../DistributerImages/") + filename);
                distributer.Footer1Image = filename;
            }
            catch (Exception ex)
            {
                string script = "alertify.alert('Upload status for Footer1Image: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                MaintainScrollPositionOnPostBack = false;
            }
        }

        if (fuMainImage.HasFile)
        {
            try
            {
                string filename = txtUrlName.Text + "_" + "MainImage" + Path.GetExtension(fuMainImage.FileName);
                if (File.Exists(Server.MapPath("../DistributerImages/") + filename))
                    File.Delete(Server.MapPath("../DistributerImages/") + filename);
                fuMainImage.SaveAs(Server.MapPath("../DistributerImages/") + filename);
                distributer.MainImage = filename;
            }
            catch (Exception ex)
            {
                string script = "alertify.alert('Upload status for MainImage: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                MaintainScrollPositionOnPostBack = false;
            }
        }

        if (fuBannerImage.HasFile)
        {
            try
            {

                string filename = txtUrlName.Text + "_" + "BannerImage" + Path.GetExtension(fuBannerImage.FileName);
                if (File.Exists(Server.MapPath("../DistributerImages/") + filename))
                    File.Delete(Server.MapPath("../DistributerImages/") + filename);//delete if file exists
                fuBannerImage.SaveAs(Server.MapPath("../DistributerImages/") + filename);
                distributer.BannerImage = filename;
            }
            catch (Exception ex)
            {
                string script = "alertify.alert('Upload status for MainImage: The file could not be uploaded. The following error occured: '" + ex.Message + ")";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                MaintainScrollPositionOnPostBack = false;
            }
        }

        distributer.SignInButtoncolor = string.IsNullOrEmpty(txtSignInButtoncolor.Text)?ConfigurationManager.AppSettings["DefaultSignInButtonColor"].ToString(): txtSignInButtoncolor.Text;
        distributer.SignUpHyperlinkcolor = string.IsNullOrEmpty(txtSignUpHyperlinkcolor.Text)? ConfigurationManager.AppSettings["DefaultSignUpHyperlinkColor"].ToString() : txtSignUpHyperlinkcolor.Text;
        distributer.UrlName = txtUrlName.Text;

        return distributer;
    }

    private void LoadDistributerList()
    {
        DistributorBAL bal = new DistributorBAL();
        gvDistributors.DataSource = bal.LoadDistributerList();
        gvDistributors.DataBind();

    }

    private void GetDistributorForId(int id)
    {
        DistributerUIDetail distributer = new DistributerUIDetail();
        DistributorBAL bal = new DistributorBAL();
        distributer = bal.GetDistributerForId(id);

        //load the data to the textfield.
        txtUrlName.Text = distributer.UrlName;


        txtSignUpHyperlinkcolor.Text = distributer.SignUpHyperlinkcolor;

        txtSignInButtoncolor.Text = distributer.SignInButtoncolor;
        txtFooterTextColor.Text = distributer.FooterTextColor;
        txtFooterBgColor.Text = distributer.FooterBgColor;

        if(!string.IsNullOrEmpty(distributer.HeaderImage))
        imgHeaderImage.ImageUrl = ConfigurationManager.AppSettings["DistributerImages"].ToString() + distributer.HeaderImage;

        if(!string.IsNullOrEmpty(distributer.BannerImage))
        imgBannerImage.ImageUrl = ConfigurationManager.AppSettings["DistributerImages"].ToString() + distributer.BannerImage;

        if(!string.IsNullOrEmpty(distributer.Footer1Image))
        imgFooter1Image.ImageUrl = ConfigurationManager.AppSettings["DistributerImages"].ToString() + distributer.Footer1Image;
        txtFooter1Text.Text = distributer.Footer1Text;
        txtFooter1URL.Text = distributer.Footer1URL;

        if(!string.IsNullOrEmpty(distributer.Footer2Image))
        imgFooter2Image.ImageUrl = ConfigurationManager.AppSettings["DistributerImages"].ToString() + distributer.Footer2Image;
        txtFooter2Text.Text = distributer.Footer2Text;
        txtFooter2URL.Text = distributer.Footer2URL;

        if(!string.IsNullOrEmpty(distributer.Footer3Image))
        imgFooter3Image.ImageUrl = ConfigurationManager.AppSettings["DistributerImages"].ToString() + distributer.Footer3Image;
        txtFooter3Text.Text = distributer.Footer3Text;
        txtFooter3URL.Text = distributer.Footer3URL;

        if(!string.IsNullOrEmpty(distributer.Footer4Image))
        imgFooter4Image.ImageUrl = ConfigurationManager.AppSettings["DistributerImages"].ToString() + distributer.Footer4Image;
        txtFooter4Text.Text = distributer.Footer4Text;
        txtFooter4URL.Text = distributer.Footer4URL;
        
        if(!string.IsNullOrEmpty(distributer.MainImage))
        imgMainImage.ImageUrl = ConfigurationManager.AppSettings["DistributerImages"].ToString() + distributer.MainImage;
    }

    private void SearchDistributerUIByURLName(string urlName)
    {
        CSLOrderingARCBAL.BAL.DistributorBAL bal = new DistributorBAL();
        gvDistributors.DataSource = bal.SearchDistributer(urlName);
        gvDistributors.DataBind();
    }

    private void GetDistributerUIByURLName(string urlName)
    {
        CSLOrderingARCBAL.BAL.DistributorBAL bal = new DistributorBAL();
        gvDistributors.DataSource = bal.GetDistributerUIByName(urlName);
        gvDistributors.DataBind();
    }

    private void ClearControls()
    {

        imgFooter1Image.ImageUrl = string.Empty;
        txtFooter1Text.Text = string.Empty;
        txtFooter1URL.Text = string.Empty;
        imgFooter2Image.ImageUrl = string.Empty;
        txtFooter2Text.Text = string.Empty;
        txtFooter2URL.Text = string.Empty;
        imgFooter3Image.ImageUrl = string.Empty;
        txtFooter3Text.Text = string.Empty;
        txtFooter3URL.Text = string.Empty;
        imgFooter4Image.ImageUrl = string.Empty;
        txtFooter4Text.Text = string.Empty;
        txtFooter4URL.Text = string.Empty;
        txtFooterBgColor.Text = string.Empty;
        txtFooterTextColor.Text = string.Empty;
        txtHeaderImage.Text = string.Empty;
        imgMainImage.ImageUrl = string.Empty;
        imgHeaderImage.ImageUrl = string.Empty;
        imgBannerImage.ImageUrl = string.Empty;
        txtSignInButtoncolor.Text = string.Empty;
        txtSignUpHyperlinkcolor.Text = string.Empty;
        txtUrlName.Text = string.Empty;
        Session[enumSessions.DistributerIdToUpdate.ToString()] = null;
    }

    private string LoadPreviewData()
    {

        string TempPath = Server.MapPath("Template");
        string strPreview = CSLOrderingARCBAL.BAL.ReadTemplates.ReadMailTemplate(TempPath, "DistributerUI.txt");

        strPreview = strPreview.Replace("{SignInButtoncolor}", txtSignInButtoncolor.Text);
        strPreview = strPreview.Replace("{SignUpHyperLinkColor}", txtSignUpHyperlinkcolor.Text);
        strPreview = strPreview.Replace("{FooterTextColor}", txtFooterTextColor.Text);
        strPreview = strPreview.Replace("{FooterBGColor}", txtFooterBgColor.Text);
        
        strPreview = strPreview.Replace("{HeaderImage}", ConfigurationManager.AppSettings["ApplicationURL"] + Path.GetFileName(imgHeaderImage.ImageUrl));
        strPreview = strPreview.Replace("{MainImage}", ConfigurationManager.AppSettings["ApplicationURL"] + Path.GetFileName(imgMainImage.ImageUrl));
        strPreview = strPreview.Replace("{BannerImage}", ConfigurationManager.AppSettings["ApplicationURL"] + Path.GetFileName(imgBannerImage.ImageUrl));
        strPreview = strPreview.Replace("{Footer3Text}", txtFooter3Text.Text);
        strPreview = strPreview.Replace("{Footer3URL}", txtFooter3URL.Text);
        strPreview = strPreview.Replace("{Footer3Image}", ConfigurationManager.AppSettings["ApplicationURL"] + Path.GetFileName(imgFooter3Image.ImageUrl));
        strPreview = strPreview.Replace("{Footer2Text}", txtFooter2Text.Text);
        strPreview = strPreview.Replace("{Footer2URL}", txtFooter2URL.Text);
        strPreview = strPreview.Replace("{Footer2Image}", ConfigurationManager.AppSettings["ApplicationURL"] + Path.GetFileName(imgFooter2Image.ImageUrl));
        strPreview = strPreview.Replace("{Footer1Text}", txtFooter1Text.Text);
        strPreview = strPreview.Replace("{Footer1URL}", txtFooter1URL.Text);
        strPreview = strPreview.Replace("{Footer1Image}", ConfigurationManager.AppSettings["ApplicationURL"] + Path.GetFileName(imgFooter1Image.ImageUrl));

        return strPreview;
    }
    #endregion


}