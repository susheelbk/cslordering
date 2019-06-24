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



public partial class ADMIN_Managecategory : System.Web.UI.Page
{
    LinqToSqlDataContext db;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                LoadData();
                Session[enumSessions.CategoryId.ToString()] = null;
            }
            catch (Exception objException)
            {
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, SiteUtility.GetUserName());
            }
        }
    }

    protected void btnShowAll_Click(object sender, EventArgs e)
    {
        txtctgcodesrch.Text = "";
        txtctgnamesrch.Text = "";
        LoadData();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            db = new LinqToSqlDataContext();
            var searchbyname = (from cats in db.Categories
                                where cats.IsDeleted == false &&
                                   (cats.CategoryName.Contains(txtctgnamesrch.Text.Trim()) && cats.CategoryCode.Contains(txtctgcodesrch.Text.Trim()))
                                select cats);

            if (searchbyname.Count() != 0)
            {
                gvCategories.DataSource = searchbyname;
                gvCategories.DataBind();
            }
            else
            {
                LoadData();
            }

            ClearAllInputs();

            //uncheck arcs
            for (int i = 0; i <= CheckBoxARC.Items.Count - 1; i++)
            {
                CheckBoxARC.Items[i].Selected = false;
            }

        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSearch_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, SiteUtility.GetUserName());
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                Audit audit = new Audit();
                string ctgCode = "";
                if (!string.IsNullOrEmpty(txtctgCode.Text) && !string.IsNullOrEmpty(txtctgName.Text) 
                    && !string.IsNullOrEmpty(Txtlistorder.Text))
                {
                    int chkgprs = 0;
                    string defaultimg = "";
                    string largeimg = "";
                    string dbdefaultimg = "";
                    string dblargeimg = "";
                    ctgCode = txtctgCode.Text.ToString();
                    db = new LinqToSqlDataContext();

                    try
                    {
                        //if updating category and delete all the mapped arc's and products of this category.
                        #region existingCategory
                        if (Session[enumSessions.CategoryId.ToString()] != null)
                        {
                            var CatInfo = (from cat in db.Categories
                                           where cat.CategoryId == Convert.ToInt32(Session[enumSessions.CategoryId.ToString()])
                                           select cat).SingleOrDefault();
                            if (FileUpload1.HasFile)
                            {
                                string filenamewithoutext = System.IO.Path.GetFileNameWithoutExtension(FileUpload1.PostedFile.FileName);
                                string ext = System.IO.Path.GetExtension(FileUpload1.PostedFile.FileName);
                                string ff = filenamewithoutext + txtctgCode.Text.ToString() + ext;
                                defaultimg = "../images/" + ff;
                                FileUpload1.SaveAs(Server.MapPath(defaultimg));
                                dbdefaultimg = "images/" + ff;
                            }
                            else
                            {
                                dbdefaultimg = CatInfo.DefaultImage;

                            }


                            if (FileUpload2.HasFile)
                            {
                                string filenamewithoutext = System.IO.Path.GetFileNameWithoutExtension(FileUpload2.PostedFile.FileName);
                                string ext = System.IO.Path.GetExtension(FileUpload2.PostedFile.FileName);
                                string ff = filenamewithoutext + txtctgCode.Text.ToString() + ext;
                                largeimg = "../images/" + ff;
                                FileUpload2.SaveAs(Server.MapPath(largeimg));
                                dblargeimg = "images/" + ff;
                            }
                            else
                            {
                                dblargeimg = CatInfo.LargeImage;

                            }

                            if (CheckBoxgprschip.Checked == true)
                                chkgprs = 1;
                            else chkgprs = 0;


                            var catg = db.CreateCategory(Convert.ToInt32(Session[enumSessions.CategoryId.ToString()].ToString()),
                                txtctgCode.Text.ToString(), txtctgName.Text.ToString(), txtctgdesc.Text.ToString(),
                                dbdefaultimg, dblargeimg, SiteUtility.GetUserName(),
                                Convert.ToBoolean(chkgprs), Convert.ToInt32(Txtlistorder.Text.ToString()),
                                chkIsDeleted.Checked, txtSalesType.Text).SingleOrDefault();

                            if (catg != null)
                                Session[enumSessions.CategoryId.ToString()] = catg.CategoryId;
                            if (catg.CategoryId == 0)
                            {
                                string script = "alertify.alert('" + ltrDuplCat.Text + "');";
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                MaintainScrollPositionOnPostBack = false;
                            }
                            else
                            {
                                string script = "alertify.alert('Category [" + txtctgCode.Text + "] - " + txtctgName.Text + " updated successfully.');";
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                MaintainScrollPositionOnPostBack = false;
                            }

                            audit.Notes = "CategoryId: " + Convert.ToInt32(Session[enumSessions.CategoryId.ToString()].ToString()) + ", Code: " + txtctgCode.Text.ToString() + ", Name: " + txtctgName.Text.ToString() + ", Description: " + txtctgdesc.Text.ToString() + ", DefaultImg: " + dbdefaultimg + ", LargeImg: " + dblargeimg + ", Allow GPRS: " + Convert.ToBoolean(chkgprs) + ", List Order: " + Convert.ToInt32(Txtlistorder.Text.ToString()) + ", Is Deleted: " + chkIsDeleted.Checked + ", Sales Types: " + txtSalesType.Text;
                        }
                        #endregion
                        #region newCategory
                        else
                        {
                            string filenamewithoutext1 = System.IO.Path.GetFileNameWithoutExtension(FileUpload1.PostedFile.FileName);
                            string ext1 = System.IO.Path.GetExtension(FileUpload1.PostedFile.FileName);
                            string ff1 = filenamewithoutext1 + txtctgCode.Text.ToString() + ext1;

                            string filenamewithoutext2 = System.IO.Path.GetFileNameWithoutExtension(FileUpload2.PostedFile.FileName);
                            string ext2 = System.IO.Path.GetExtension(FileUpload2.PostedFile.FileName);
                            string ff2 = filenamewithoutext2 + txtctgCode.Text.ToString() + ext2;
                            defaultimg = ff1;
                            largeimg = ff2;
                            string defImgPath = "images/" + defaultimg;
                            string LImgPath = "images/" + largeimg;
                            if (FileUpload1.HasFile)
                                FileUpload1.SaveAs(Server.MapPath("../images/" + defaultimg));
                            if (FileUpload2.HasFile)
                                FileUpload2.SaveAs(Server.MapPath("../images/" + largeimg));
                            if (CheckBoxgprschip.Checked == true)
                                chkgprs = 1;
                            else chkgprs = 0;

                            var cats = db.CreateCategory(0, txtctgCode.Text.ToString().Trim(), txtctgName.Text.ToString().Trim(), txtctgdesc.Text.ToString().Trim(), defImgPath.ToString().Trim(), LImgPath.ToString().Trim(), SiteUtility.GetUserName(), Convert.ToBoolean(chkgprs), Convert.ToInt32(Txtlistorder.Text.ToString()), chkIsDeleted.Checked, txtSalesType.Text).Single();
                            if (cats != null)
                                Session[enumSessions.CategoryId.ToString()] = cats.CategoryId;
                            if (cats.CategoryId == 0)
                            {
                                string script = "alertify.alert('" + ltrDuplCat.Text + "');";
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                MaintainScrollPositionOnPostBack = false;
                            }
                            else
                            {
                                string script = "alertify.alert('Category [" + txtctgCode.Text + "] - " + txtctgName.Text + " created successfully.');";
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                MaintainScrollPositionOnPostBack = false;
                            }
                            audit.Notes = "CategoryId: " + cats.CategoryId.ToString() + ", Code: " + txtctgCode.Text.ToString() + ", Name: " + txtctgName.Text.ToString() + ", Description: " + txtctgdesc.Text.ToString() + ", DefaultImg: " + dbdefaultimg + ", LargeImg: " + dblargeimg + ", Allow GPRS: " + Convert.ToBoolean(chkgprs) + ", List Order: " + Convert.ToInt32(Txtlistorder.Text.ToString()) + ", Is Deleted: " + chkIsDeleted.Checked + ", Sales Types: " + txtSalesType.Text;
                        }
                        #endregion
                    }
                    catch (Exception exp)
                    {
                        db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                        db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSave_Click",
                            Convert.ToString(exp.Message), Convert.ToString(exp.InnerException),
                            Convert.ToString(exp.StackTrace), "",
                            HttpContext.Current.Request.UserHostAddress, false,
                            SiteUtility.GetUserName());
                    }

                    //enter all the checked products of this category
                    audit.Notes += "ProductID: ";
                    List<Category_Product_Map> categoryProductDbRows = new List<Category_Product_Map>();
                    foreach (GridViewRow ctgrow in gvctg.Rows)
                    {
                        if (ctgrow.RowType == DataControlRowType.DataRow)
                        {
                            GridView innergrid = ctgrow.FindControl("gvinner") as GridView;
                            foreach (GridViewRow prodrow in innergrid.Rows)
                            {
                                if (prodrow.RowType == DataControlRowType.DataRow)
                                {
                                    CheckBox chkpro = prodrow.FindControl("chkprod") as CheckBox;
                                    Category_Product_Map cmp;
                                    if (chkpro.Checked == true)
                                    {

                                        int Prodid = int.Parse(innergrid.DataKeys[prodrow.RowIndex].Value.ToString());
                                        cmp = new Category_Product_Map();
                                        cmp.CategoryId = Convert.ToInt32(Session[enumSessions.CategoryId.ToString()]);
                                        cmp.ProductId = Convert.ToInt32(Prodid);
                                        var count = categoryProductDbRows.Where(x => x.CategoryId == cmp.CategoryId && x.ProductId == cmp.ProductId).Count();
                                        if (count <= 0)
                                        {
                                            categoryProductDbRows.Add(cmp);
                                        }
                                        audit.Notes += Prodid + ", ";
                                    }
                                }
                            }
                        }
                    }
                    db.Category_Product_Maps.InsertAllOnSubmit(categoryProductDbRows);
                    db.SubmitChanges();
                                        

                    //enter all the checked Arc's of this category
                    audit.Notes += "ARCId: ";

                    var Checkedarc = (from ListItem item in CheckBoxARC.Items where item.Selected select item.Value).ToList();
                    if (Checkedarc.Any())
                    {
                        ARC_Category_Map acm;
                        int catid = Convert.ToInt32(Session[enumSessions.CategoryId.ToString()]);
                        List<int> arcs = new List<int>();
                        foreach (String chkarc in Checkedarc)
                        {
                            if (chkarc != "Select All")
                            {
                                acm = new ARC_Category_Map();
                                acm.CategoryId = catid;
                                acm.ARCId = Convert.ToInt32(chkarc);
                                if (arcs.IndexOf(acm.ARCId) < 0)
                                {
                                    db.ARC_Category_Maps.InsertOnSubmit(acm);
                                    db.SubmitChanges();
                                }
                                arcs.Add(acm.ARCId);
                                
                                audit.Notes += chkarc + ",";
                            }
                        }
                    }

                    pnlcategorydetail.Visible = false;
                    pnlcategorylist.Visible = true;
                    LoadData();
                }
                else
                {
                    string script = "alertify.alert('" + ltrRequired.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                }

                MaintainScrollPositionOnPostBack = false;


                audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
                audit.ChangeID = Convert.ToInt32(enumAudit.Manage_Category);
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
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSave_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
        else
        {
            string script = "alertify.alert('" + ltrRequired.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            MaintainScrollPositionOnPostBack = false;
        }
    }

    public void ClearAllInputs()
    {
        Imagectg.Visible = false;
        LImagectg.Visible = false;
        txtctgCode.Text = "";
        txtctgdesc.Text = "";
        txtctgName.Text = "";
        Txtlistorder.Text = "";
        txtSalesType.Text = "";
        CheckBoxgprschip.Checked = false;
        Imagectg.ImageUrl = "";
        LImagectg.ImageUrl = "";
        Session[enumSessions.CategoryId.ToString()] = null;
    }

    public void LoadData()
    {
        ClearAllInputs();
        try
        {
            //binding all categories in category grid

            db = new LinqToSqlDataContext();
            var ctgs = (from cats in db.Categories
                        orderby cats.CategoryName ascending
                        where cats.CategoryName.Contains(txtctgnamesrch.Text.Trim())
                        && cats.CategoryCode.Contains(txtctgcodesrch.Text.Trim())
                        select cats);
            gvCategories.DataSource = ctgs;
            gvCategories.DataBind();

            //binding gvctg in panel products

            db = new LinqToSqlDataContext();
            var ctgdata = (from ctg in db.Categories
                           where ctg.IsDeleted == false
                           orderby ctg.ListOrder
                           select new { ctg.CategoryId, CategoryDisp = ctg.CategoryName + " [" + ctg.CategoryCode + "]" });
            gvctg.DataSource = ctgdata;
            gvctg.DataBind();

            // binding all ARC's with checkboxes

            db = new LinqToSqlDataContext();
            var ARCdata = (from arc in db.ARCs
                           where arc.IsDeleted == false
                           orderby arc.CompanyName
                           select new { arc.ARCId, ARCDisp = arc.CompanyName + " - [" + arc.ARC_Code + "]  " });

            CheckBoxARC.DataValueField = "ARCId";
            CheckBoxARC.DataTextField = "ARCDisp";
            CheckBoxARC.DataSource = ARCdata;
            CheckBoxARC.DataBind();
            CheckBoxARC.Items.Insert(0, "Select All");
            for (int i = 0; i <= CheckBoxARC.Items.Count - 1; i++)
            {
                CheckBoxARC.Items[i].Selected = false;
            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LoadData", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    protected void LinkButtonupdate_click(object sender, System.EventArgs e)
    {
        try
        {
            litAction.Text = "You choose to <b>EDIT CATEGORY</b>";
            pnlcategorydetail.Visible = true;
            pnlcategorylist.Visible = false;
            txtctgName.Focus();
            LinkButton lbctg = sender as LinkButton;
            if (lbctg != null)
            {
                GridViewRow gvr = (GridViewRow)lbctg.NamingContainer;

                Label lbl2 = gvr.FindControl("CatID") as Label;
                Session[enumSessions.CategoryId.ToString()] = lbl2.Text;

            }
            else
            {
                //Reset 
                if (Session[enumSessions.CategoryId.ToString()] != null)
                { }
                else
                {
                    //Do a cancel as no value in session
                    btnCancel_Click(sender, e);
                }

            }

            db = new LinqToSqlDataContext();
            var cat = (from c in db.Categories
                       where c.CategoryId == Convert.ToInt32(Session[enumSessions.CategoryId.ToString()].ToString())
                       select c).FirstOrDefault();

            txtctgName.Text = cat.CategoryName;
            txtctgCode.Text = cat.CategoryCode;
            if (!string.IsNullOrEmpty(cat.CategoryDesc))
                txtctgdesc.Text = cat.CategoryDesc;
            else
                txtctgdesc.Text = "";

            txtSalesType.Text = cat.SalesType;
            Imagectg.Visible = true;
            Imagectg.ImageUrl = "~/" + cat.DefaultImage;

            LImagectg.Visible = true;
            LImagectg.ImageUrl = "~/" + cat.LargeImage;

            Txtlistorder.Text = cat.ListOrder.ToString();

            CheckBoxgprschip.Checked = Convert.ToBoolean(cat.IsGPRSChipEmpty);
            chkIsDeleted.Checked = cat.IsDeleted;
            CheckProd();
            CheckArc();
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LinkButtonupdate_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    protected void LinkButtondelete_click(object sender, System.EventArgs e)
    {
        try
        {
            LinkButton lbdel = sender as LinkButton;

            GridViewRow gvr = (GridViewRow)lbdel.NamingContainer;
            db = new LinqToSqlDataContext();
            Label lbl2 = gvr.FindControl("CatID") as Label;
            Session[enumSessions.CategoryId.ToString()] = lbl2.Text;
            //delete category
            var Catg = db.Categories.Single(delctg => delctg.CategoryId == Convert.ToInt32(Session[enumSessions.CategoryId.ToString()].ToString()));
            Catg.IsDeleted = true;
            db.SubmitChanges();

            //delete products of that category
            db = new LinqToSqlDataContext();

            var delprod = db.Category_Product_Maps.Where(item => item.CategoryId == Convert.ToInt32(Session[enumSessions.CategoryId.ToString()].ToString()));
            db.Category_Product_Maps.DeleteAllOnSubmit(delprod);

            db.SubmitChanges();


            //delete arc's of that category

            db = new LinqToSqlDataContext();

            var delarc = db.ARC_Category_Maps.Where(item => item.CategoryId == Convert.ToInt32(Session[enumSessions.CategoryId.ToString()].ToString()));
            db.ARC_Category_Maps.DeleteAllOnSubmit(delarc);
            db.SubmitChanges();
            string script = "alertify.alert('" + ltrCatDeleted.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            LoadData();
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LinkButtondelete_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }


    }

    public void CheckProd()
    {
        try
        {
            int CtgID = Convert.ToInt32(Session[enumSessions.CategoryId.ToString()]);
            //uncheck all first
            foreach (GridViewRow ctgrow in gvctg.Rows)
            {
                if (ctgrow.RowType == DataControlRowType.DataRow)
                {
                    CheckBox chkctg = ctgrow.FindControl("chkctg") as CheckBox;
                    chkctg.Checked = false;
                    GridView innergrid = ctgrow.FindControl("gvinner") as GridView;
                    foreach (GridViewRow prodrow in innergrid.Rows)
                    {
                        if (prodrow.RowType == DataControlRowType.DataRow)
                        {
                            CheckBox chkpro = prodrow.FindControl("chkprod") as CheckBox;
                            chkpro.Checked = false;
                        }

                    }
                }

            }

            int Prod_Id = 0;
            db = new LinqToSqlDataContext();
            var Ctg_prods = (from pr in db.Products
                             join ctg in db.Category_Product_Maps
                             on pr.ProductId equals ctg.ProductId
                             where ctg.CategoryId == CtgID
                             select new { pr.ProductName, pr.ProductCode, pr.ProductId });

            foreach (var objp in Ctg_prods)
            {

                Prod_Id = Convert.ToInt32(objp.ProductId);
                foreach (GridViewRow ctgrow in gvctg.Rows)
                {
                    GridView innergrid = ctgrow.FindControl("gvinner") as GridView;
                    foreach (GridViewRow prodrow in innergrid.Rows)
                    {
                        int chkProdid = int.Parse(innergrid.DataKeys[prodrow.RowIndex].Value.ToString());
                        if (chkProdid == Prod_Id)
                        {
                            CheckBox chkpro = prodrow.FindControl("chkprod") as CheckBox;
                            chkpro.Checked = true;
                            chkprod_CheckedChanged(chkpro, null);

                        }

                    }

                }
            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "CheckProd", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    public void CheckArc()
    {
        try
        {

            int CtgID = Convert.ToInt32(Session[enumSessions.CategoryId.ToString()]);
            foreach (ListItem itemchk in CheckBoxARC.Items)
            {
                itemchk.Selected = false;
            }
            int Arc_Id = 0;
            db = new LinqToSqlDataContext();
            var Ctg_prods = (from arc in db.ARCs
                             join ctg in db.ARC_Category_Maps
                             on arc.ARCId equals ctg.ARCId
                             where ctg.CategoryId == CtgID
                             select new { arc.ARCId, arc.ARC_Code, arc.CompanyName });

            foreach (var objarc in Ctg_prods)
            {

                Arc_Id = Convert.ToInt32(objarc.ARCId);
                foreach (ListItem itemchk in CheckBoxARC.Items)
                {
                    if (itemchk.Value != "Select All")
                    {
                        int Chkbox_arcid = Convert.ToInt32(itemchk.Value);
                        if (Chkbox_arcid == Arc_Id)
                        {
                            itemchk.Selected = true;
                        }
                    }
                }
            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "CheckArc", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    #region gvCategories Paging

    protected void gvCategories_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            gvCategories.PageIndex = e.NewPageIndex;
            LoadData();
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvCategories_PageIndexChanging", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }

    }

    #endregion

    static Boolean CheckBoxProdflag = false;
    //protected void CheckBoxProd_OnSelectedIndexChanged(object sender, EventArgs e)
    //{
    //    foreach (ListItem item in CheckBoxProd.Items)
    //    {
    //        if ((item.Text == "Select All") && (item.Selected == true) && (CheckBoxProdflag == false))
    //        {
    //            foreach (ListItem item1 in CheckBoxProd.Items)
    //            {
    //                item1.Selected = true;
    //                CheckBoxProdflag = true;
    //            }
    //        }
    //        else if ((item.Text == "Select All") && (item.Selected == false) && (CheckBoxProdflag == true))
    //        {
    //            foreach (ListItem item1 in CheckBoxProd.Items)
    //            {
    //                item1.Selected = false;
    //                CheckBoxProdflag = false;
    //            }

    //        }
    //        else if ((item.Text == "Select All") && (item.Selected == true) && (CheckBoxProdflag == true))
    //        {
    //            foreach (ListItem item2 in CheckBoxProd.Items)
    //            {
    //                if (item2.Selected == false)
    //                {
    //                    CheckBoxProd.Items[0].Selected = false;
    //                    CheckBoxProdflag = false;

    //                }
    //            }
    //        }
    //        else if ((item.Text == "Select All") && (item.Selected == false) && (CheckBoxProdflag == false) && (CheckBoxProd.SelectedItem != null))
    //        {
    //            CheckBoxProd.SelectedItem.Selected = true;

    //        }

    //    }
    //}


    protected void gvctg_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            GridView innergrid = e.Row.FindControl("gvinner") as GridView;
            int ctgid = int.Parse(gvctg.DataKeys[e.Row.RowIndex].Value.ToString());
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            var Productdata = (from prod in db.Products
                               join prodctg in db.Category_Product_Maps on prod.ProductId equals prodctg.ProductId
                               where prod.IsDeleted == false &&
                               prod.IsDependentProduct == false &&
                               prodctg.CategoryId == ctgid
                               orderby prod.ProductCode
                               select new { prod.ProductId, ProductDisp = prod.ProductName + " [" + prod.ProductCode + "]" });
            if (Productdata.Any(x => x != null))
            {
                innergrid.DataSource = Productdata;
                innergrid.DataBind();
            }

        }
    }


    protected void chkctg_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox chk = sender as CheckBox;
        GridViewRow Parentrow = chk.NamingContainer as GridViewRow;
        int ctgid = int.Parse(gvctg.DataKeys[Parentrow.RowIndex].Value.ToString());

        GridView innergrid = Parentrow.FindControl("gvinner") as GridView;
        if (chk.Checked == true)
        {
            foreach (GridViewRow childrow in innergrid.Rows)
            {
                CheckBox chkprod = childrow.FindControl("chkprod") as CheckBox;
                chkprod.Checked = true;

            }
        }
        else
        {
            foreach (GridViewRow childrow in innergrid.Rows)
            {
                CheckBox chkprod = childrow.FindControl("chkprod") as CheckBox;
                chkprod.Checked = false;

            }
        }

    }
    protected void chkprod_CheckedChanged(object sender, EventArgs e)
    {

        CheckBox chkprod = sender as CheckBox;
        //GridViewRow parentrow = chkprod.Parent.NamingContainer as GridViewRow;
        GridViewRow childrow = chkprod.NamingContainer as GridViewRow;
        GridViewRow parentrow = childrow.Parent.Parent.NamingContainer as GridViewRow;
        CheckBox chkctg = parentrow.FindControl("chkctg") as CheckBox;
        if (chkprod.Checked == false)
        {

            if (chkctg.Checked == true)
            {
                chkctg.Checked = false;
            }
        }
        else
        {
            //fetch how many of products are checked.counterchkprod=0, if items are 5 and checked
            // are 4(only 1 less) then on checking chkprod to true will set ctgchk to true else do nothing
            GridView gridproduct = parentrow.FindControl("gvinner") as GridView;
            int i = gridproduct.Rows.Count;
            int Countercheckedproducts = 0;
            foreach (GridViewRow childprodrow in gridproduct.Rows)
            {
                CheckBox chkpro = childprodrow.FindControl("chkprod") as CheckBox;
                if (chkpro.Checked)
                {
                    Countercheckedproducts += 1;
                }
            }

            if (i == Countercheckedproducts)
            {
                chkctg.Checked = true;
            }

        }

    }

    static Boolean CheckBoxARCflag = false;
    protected void CheckBoxARC_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        foreach (ListItem item in CheckBoxARC.Items)
        {
            if ((item.Text == "Select All") && (item.Selected == true) && (CheckBoxARCflag == false))
            {
                foreach (ListItem item1 in CheckBoxARC.Items)
                {
                    item1.Selected = true;
                    CheckBoxARCflag = true;
                }
            }
            else if ((item.Text == "Select All") && (item.Selected == false) && (CheckBoxARCflag == true))
            {
                foreach (ListItem item1 in CheckBoxARC.Items)
                {
                    item1.Selected = false;
                    CheckBoxARCflag = false;
                }

            }
            else if ((item.Text == "Select All") && (item.Selected == true) && (CheckBoxARCflag == true))
            {
                foreach (ListItem item2 in CheckBoxARC.Items)
                {
                    if (item2.Selected == false)
                    {
                        CheckBoxARC.Items[0].Selected = false;
                        CheckBoxARCflag = false;

                    }
                }
            }
            else if ((item.Text == "Select All") && (item.Selected == false) && (CheckBoxARCflag == false) && (CheckBoxARC.SelectedItem != null))
            {
                CheckBoxARC.SelectedItem.Selected = true;

            }

        }
    }

    protected void btnnewctg_Click(object sender, EventArgs e)
    {
        litAction.Text = "You choose to <b>ADD NEW CATEGORY</b>";
        pnlcategorydetail.Visible = true;
        pnlcategorylist.Visible = false;
        LoadData();
    }
    protected void btnReset_Click(object sender, EventArgs e)
    {
        if (Session[enumSessions.CategoryId.ToString()] != null)
        {
            LinkButtonupdate_click(sender, e);
        }
        else
        {
            btnnewctg_Click(sender, e);
        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Session[enumSessions.CategoryId.ToString()] = null;
        pnlcategorylist.Visible = true;
        pnlcategorydetail.Visible = false;

    }
}