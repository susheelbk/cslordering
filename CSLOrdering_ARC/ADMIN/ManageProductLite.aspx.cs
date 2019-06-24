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
using System.Collections;


public partial class ADMIN_ManageProductLite : System.Web.UI.Page
{


    LinqToSqlDataContext db;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                LoadData();
                Session[enumSessions.ProductId.ToString()] = null;
            }
            catch (Exception objException)
            {
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
    }

    protected void btnShowAll_Click(object sender, EventArgs e)
    {
        Session[enumSessions.ListedonCSLConnect.ToString()] = "0";
        txtprocodesrch.Text = String.Empty;
        txtpronamesrch.Text = String.Empty;
        chkM2MSearch.Checked = false;
        LoadData();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            Session[enumSessions.ListedonCSLConnect.ToString()] = "0";
            db = new LinqToSqlDataContext();
            var searchbyname = (from pro in db.Products
                                orderby pro.ProductCode ascending
                                where (pro.ProductName.Contains(txtpronamesrch.Text.Trim()) && pro.ProductCode.Contains(txtprocodesrch.Text.Trim()))
                                select pro);

            if (chkM2MSearch.Checked == true)
            {
                searchbyname = (from pro in db.Products
                                orderby pro.ProductCode ascending
                                where (pro.ProductName.Contains(txtpronamesrch.Text.Trim()) && pro.ProductCode.Contains(txtprocodesrch.Text.Trim()) && pro.ListedonCSLConnect == true)
                                select pro);
            }

            if (searchbyname.Any(x => x != null))
            {
                gvProducts.DataSource = null;
                gvProducts.DataSource = searchbyname;
                gvProducts.DataBind();
            }
            else
            {
                gvProducts.DataSource = null;
                gvProducts.DataSource = searchbyname;
                gvProducts.DataBind();
                string script = "alertify.alert('" + ltrNoMatch.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
            //ClearAllInputs();

            //uncheck arcs
            for (int i = 0; i <= lstboxARC.Items.Count - 1; i++)
            {
                lstboxARC.Items[i].Selected = false;
            }

            //uncheck arcs
            for (int i = 0; i <= lstboxInstaller.Items.Count - 1; i++)
            {
                lstboxInstaller.Items[i].Selected = false;
            }

        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSearch_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }
    //public String strProductCode = String.Empty;
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            Audit audit = new Audit();
            db = new LinqToSqlDataContext();

            string msg = String.Empty;


            //if updating product and delete all the mapped arc's,depprod,relatedprod and categories of this product.
            if (Session[enumSessions.ProductId.ToString()] != null)
            {
                var ProdInfo = (from pro in db.Products
                                where pro.ProductId == Convert.ToInt32(Session[enumSessions.ProductId.ToString()])
                                select pro).SingleOrDefault();

                //enter all the checked Arcs/Installers of this product

                audit.Notes = "ProductCode: " + hdnProductCode.Value.ToString();

                var arcsToDelete = (from pam in db.Product_ARC_Maps
                                    where pam.ProductId == Convert.ToInt32(Session[enumSessions.ProductId.ToString()])
                                    select pam).ToList();
                db.Product_ARC_Maps.DeleteAllOnSubmit(arcsToDelete);

                for (int i = 0; i <= lstSelectedARC.Items.Count - 1; i++)
                {
                    Product_ARC_Map pam;
                    pam = new Product_ARC_Map();
                    pam.ProductId = Convert.ToInt32(Session[enumSessions.ProductId.ToString()]);
                    pam.ARCId = Convert.ToInt32(lstSelectedARC.Items[i].Value);
                    bool isCSDRestricted = false;

                    for (int o = 0; o <= lstCSDRestrictedARC.Items.Count - 1; o++)
                    {
                        if (lstCSDRestrictedARC.Items[o].Value == lstSelectedARC.Items[i].Value)
                        {
                            isCSDRestricted = true;
                        }
                    }
                    pam.CSDRestriction = isCSDRestricted;
                    db.Product_ARC_Maps.InsertOnSubmit(pam);
                    db.SubmitChanges();
                    audit.Notes += ", ARCs: " + pam;
                }

                var installersToDelete = (from pam in db.Product_Installer_Maps
                                          where pam.ProductId == Convert.ToInt32(Session[enumSessions.ProductId.ToString()])
                                          select pam).ToList();
                db.Product_Installer_Maps.DeleteAllOnSubmit(installersToDelete);

                for (int i = 0; i <= lstSelectedInstaller.Items.Count - 1; i++)
                {
                    Product_Installer_Map pim;

                    pim = new Product_Installer_Map();
                    pim.ProductId = Convert.ToInt32(Session[enumSessions.ProductId.ToString()]);
                    pim.InstallerId = new Guid(lstSelectedInstaller.Items[i].Value);

                    db.Product_Installer_Maps.InsertOnSubmit(pim);
                    db.SubmitChanges();
                    audit.Notes += ", Installers: " + pim;
                }


                pnlproductdetails.Visible = false;
                pnlproductlist.Visible = true;
                ClearAllInputs();


                LoadData();
                string script = "alertify.alert('Product [" + ProdInfo.ProductCode + "] - " + ProdInfo.ProductName + " updated successfully.');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                MaintainScrollPositionOnPostBack = false;
            }
            audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
            audit.ChangeID = Convert.ToInt32(enumAudit.Manage_Products_Lite);
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

    protected void LinkButtonupdate_click(object sender, System.EventArgs e)
    {
        try
        {
            LoadData();
            pnlproductdetails.Visible = true;
            pnlproductlist.Visible = false;
            LinkButton lbpro = sender as LinkButton;

            if (lbpro != null)
            {
                GridViewRow gvr = (GridViewRow)lbpro.NamingContainer;
                Label lbl2 = gvr.FindControl("ProductId") as Label;
                Session[enumSessions.ProductId.ToString()] = lbl2.Text;
            }
            else
            {
                //Reset 
                if (Session[enumSessions.ProductId.ToString()] != null)
                { }
                else
                {
                    //Do a cancel as no value in session
                    btnCancel_Click(sender, e);
                }

            }
            db = new LinqToSqlDataContext();
            var prodDtls = (from p in db.Products
                            where p.ProductId == Convert.ToInt32(Session[enumSessions.ProductId.ToString()].ToString())
                            select p).FirstOrDefault();
            hdnProductCode.Value = prodDtls.ProductCode;
            lblSelectedProduct.Text = prodDtls.ProductName;
            divnotdependent.Visible = true;
            CheckArc();
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LinkButtonupdate_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    public void CheckArc()
    {
        try
        {
            int PrID = Convert.ToInt32(Session[enumSessions.ProductId.ToString()]);

            //int Arc_Id = 0;
            db = new LinqToSqlDataContext();
            var Arc_prods = (from pr in db.Products
                             join pam in db.Product_ARC_Maps on pr.ProductId equals pam.ProductId
                             join arc in db.ARCs on pam.ARCId equals arc.ARCId
                             where pr.ProductId == PrID
                             orderby arc.CompanyName
                             select new
                             {
                                 ARCId = pam.ARCId,
                                 ARCDisp = arc.CompanyName + "[" + arc.ARC_Code + "]  "
                             });


            lstSelectedARC.DataSource = Arc_prods;
            lstSelectedARC.DataTextField = "ARCDisp";
            lstSelectedARC.DataValueField = "ARCId";
            lstSelectedARC.DataBind();

            var Arc_CSD_prods = (from pr in db.Products
                                 join pam in db.Product_ARC_Maps on pr.ProductId equals pam.ProductId
                                 join arc in db.ARCs on pam.ARCId equals arc.ARCId
                                 where pr.ProductId == PrID && pam.CSDRestriction == true
                                 orderby arc.CompanyName
                                 select new
                                 {
                                     ARCId = pam.ARCId,
                                     ARCDisp = arc.CompanyName + "[" + arc.ARC_Code + "]  "
                                 });


            lstCSDRestrictedARC.DataSource = Arc_CSD_prods;
            lstCSDRestrictedARC.DataTextField = "ARCDisp";
            lstCSDRestrictedARC.DataValueField = "ARCId";
            lstCSDRestrictedARC.DataBind();


            var Installer_prods = (from pr in db.Products
                                   join pim in db.Product_Installer_Maps on pr.ProductId equals pim.ProductId
                                   join inst in db.Installers on pim.InstallerId equals inst.InstallerCompanyID
                                   where pr.ProductId == PrID
                                   orderby inst.CompanyName
                                   select new
                                   {
                                       InstallerId = pim.InstallerId,
                                       InstallerDisp = inst.CompanyName + " [" + inst.UniqueCode + "]  "
                                   });


            lstSelectedInstaller.DataSource = Installer_prods;
            lstSelectedInstaller.DataTextField = "InstallerDisp";
            lstSelectedInstaller.DataValueField = "InstallerId";
            lstSelectedInstaller.DataBind();

            arraylist2 = new ArrayList();

            foreach (var item in Arc_prods)
            {

                ListItem objListItem = new ListItem();
                objListItem.Text = item.ARCDisp;
                objListItem.Value = item.ARCId.ToString();

                arraylist2.Add(objListItem);

            }

            arraylist3 = new ArrayList();
            foreach (var item in Installer_prods)
            {

                ListItem objListItem = new ListItem();
                objListItem.Text = item.InstallerDisp;
                objListItem.Value = item.InstallerId.ToString();

                arraylist3.Add(objListItem);

            }


            // remove item from list if already selected
            for (int i = 0; i < arraylist2.Count; i++)
            {
                if (lstboxARC.Items.Contains(((ListItem)arraylist2[i])))
                {
                    lstboxARC.Items.Remove(((ListItem)arraylist2[i]));
                }
                // lstSelectedARC.Items.Remove(((ListItem)arraylist2[i]));
            }
            //lstboxARC.Items.Remove(((ListItem)arraylist2));


            // remove item from list if already selected
            for (int i = 0; i < arraylist3.Count; i++)
            {
                if (lstboxInstaller.Items.Contains(((ListItem)arraylist3[i])))
                {
                    lstboxInstaller.Items.Remove(((ListItem)arraylist3[i]));
                }
            }

        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "CheckArc", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
        finally
        {
            arraylist1 = null;
            arraylist2 = null;
        }

    }

    public void ClearAllInputs()
    {
        lstSelectedARC.Items.Clear();
        lstSelectedInstaller.Items.Clear();
    }

    public void LoadData()
    {

        ClearAllInputs();
        try
        {
            //binding all products in products grid
            db = new LinqToSqlDataContext();

            var Prod = (from pr in db.Products
                        orderby pr.ProductCode ascending
                        where pr.ProductName.Contains(txtpronamesrch.Text.Trim()) && pr.ProductCode.Contains(txtprocodesrch.Text.Trim()) && pr.IsDependentProduct == false
                        select pr);

            if (Session[enumSessions.ListedonCSLConnect.ToString()] == "1")
            {
                Prod = (from pro in db.Products
                        orderby pro.ProductCode ascending
                        where (pro.ListedonCSLConnect == true) && pro.IsDependentProduct == false
                        select pro);
            }

            if (Prod.Count() > 0)
            {
                gvProducts.DataSource = Prod;
                gvProducts.DataBind();
            }
            else
            {
                gvProducts.DataSource = null;
                gvProducts.DataBind();
            }


            // binding all ARC's with checkboxes

            db = new LinqToSqlDataContext();
            var ARCdata = (from arc in db.ARCs
                           where arc.IsDeleted == false
                           orderby arc.CompanyName
                           select new { arc.ARCId, ARCDisp = arc.CompanyName + "[" + arc.ARC_Code + "]  " });


            lstboxARC.DataSource = ARCdata;
            lstboxARC.DataValueField = "ARCId";
            lstboxARC.DataTextField = "ARCDisp";
            lstboxARC.DataBind();

            // binding all Installers with checkboxes

            var Installerdata = (from inst in db.Installers
                                 where inst.IsActive == true
                                 orderby inst.CompanyName
                                 select new { inst.InstallerCompanyID, InstallerDisp = inst.CompanyName + " [" + inst.UniqueCode + "]  " });


            lstboxInstaller.DataSource = Installerdata;
            lstboxInstaller.DataValueField = "InstallerCompanyID";
            lstboxInstaller.DataTextField = "InstallerDisp";
            lstboxInstaller.DataBind();

        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LoadData", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }



    #region gvProducts Paging

    protected void gvProducts_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            gvProducts.PageIndex = e.NewPageIndex;
            LoadData();
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvProducts_PageIndexChanging", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }

    }

    #endregion

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Session[enumSessions.ProductId.ToString()] = null;
        pnlproductlist.Visible = true;
        pnlproductdetails.Visible = false;
    }



    ArrayList arraylist1 = null;
    ArrayList arraylist2 = null;
    ArrayList arraylist3 = null;
    ArrayList arraylist4 = null;
    protected void btnAdd_Click(Object sender, EventArgs e)
    {
        try
        {
            arraylist1 = new ArrayList();
            arraylist2 = new ArrayList();
            //lbltxt.Visible = false;
            if (lstboxARC.SelectedIndex >= 0)
            {
                for (int i = 0; i < lstboxARC.Items.Count; i++)
                {
                    if (lstboxARC.Items[i].Selected)
                    {
                        if (!arraylist1.Contains(lstboxARC.Items[i]))
                        {
                            arraylist1.Add(lstboxARC.Items[i]);

                        }
                    }
                }
                for (int i = 0; i < arraylist1.Count; i++)
                {
                    if (!lstSelectedARC.Items.Contains(((ListItem)arraylist1[i])))
                    {
                        lstSelectedARC.Items.Add(((ListItem)arraylist1[i]));
                    }
                    lstboxARC.Items.Remove(((ListItem)arraylist1[i]));
                }
                lstSelectedARC.SelectedIndex = -1;
            }
            else
            {
                // lbltxt.Visible = true;
                // lbltxt.Text = "Please select atleast one in Listbox1 to move";
            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnAdd_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
        finally
        {
            arraylist1 = null;
            arraylist2 = null;
        }
    }

    protected void btnRemove_Click(Object sender, EventArgs e)
    {
        try
        {
            arraylist1 = new ArrayList();
            arraylist2 = new ArrayList();
            //lbltxt.Visible = false;
            if (lstSelectedARC.SelectedIndex >= 0)
            {
                for (int i = 0; i < lstSelectedARC.Items.Count; i++)
                {
                    if (lstSelectedARC.Items[i].Selected)
                    {
                        if (!arraylist2.Contains(lstSelectedARC.Items[i]))
                        {
                            arraylist2.Add(lstSelectedARC.Items[i]);
                        }
                    }
                }
                for (int i = 0; i < arraylist2.Count; i++)
                {
                    if (!lstboxARC.Items.Contains(((ListItem)arraylist2[i])))
                    {
                        lstboxARC.Items.Add(((ListItem)arraylist2[i]));
                    }
                    lstSelectedARC.Items.Remove(((ListItem)arraylist2[i]));
                }
                lstboxARC.SelectedIndex = -1;
            }
            else
            {
                // lbltxt.Visible = true;
                //  lbltxt.Text = "Please select atleast one in Listbox2 to move";
            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnAdd_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
        finally
        {
            arraylist1 = null;
            arraylist2 = null;
        }

    }

    protected void btnAddInst_Click(Object sender, EventArgs e)
    {
        try
        {
            arraylist3 = new ArrayList();
            arraylist4 = new ArrayList();
            //lbltxt.Visible = false;
            if (lstboxInstaller.SelectedIndex >= 0)
            {
                for (int i = 0; i < lstboxInstaller.Items.Count; i++)
                {
                    if (lstboxInstaller.Items[i].Selected)
                    {
                        if (!arraylist3.Contains(lstboxInstaller.Items[i]))
                        {
                            arraylist3.Add(lstboxInstaller.Items[i]);

                        }
                    }
                }
                for (int i = 0; i < arraylist3.Count; i++)
                {
                    if (!lstSelectedInstaller.Items.Contains(((ListItem)arraylist3[i])))
                    {
                        lstSelectedInstaller.Items.Add(((ListItem)arraylist3[i]));
                    }
                    lstboxInstaller.Items.Remove(((ListItem)arraylist3[i]));
                }
                lstSelectedInstaller.SelectedIndex = -1;
            }
            else
            {
                // lbltxt.Visible = true;
                // lbltxt.Text = "Please select atleast one in Listbox1 to move";
            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnAddInst_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
        finally
        {
            arraylist3 = null;
            arraylist4 = null;
        }
    }

    protected void btnRemoveInst_Click(Object sender, EventArgs e)
    {
        try
        {
            arraylist3 = new ArrayList();
            arraylist4 = new ArrayList();
            //lbltxt.Visible = false;
            if (lstSelectedInstaller.SelectedIndex >= 0)
            {
                for (int i = 0; i < lstSelectedInstaller.Items.Count; i++)
                {
                    if (lstSelectedInstaller.Items[i].Selected)
                    {
                        if (!arraylist4.Contains(lstSelectedInstaller.Items[i]))
                        {
                            arraylist4.Add(lstSelectedInstaller.Items[i]);
                        }
                    }
                }
                for (int i = 0; i < arraylist4.Count; i++)
                {
                    if (!lstboxInstaller.Items.Contains(((ListItem)arraylist4[i])))
                    {
                        lstboxInstaller.Items.Add(((ListItem)arraylist4[i]));
                    }
                    lstSelectedInstaller.Items.Remove(((ListItem)arraylist4[i]));
                }
                lstboxInstaller.SelectedIndex = -1;
            }
            else
            {
                // lbltxt.Visible = true;
                //  lbltxt.Text = "Please select atleast one in Listbox2 to move";
            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnRemoveInst_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
        finally
        {
            arraylist3 = null;
            arraylist4 = null;
        }

    }
    protected void btnCSLConnect_Click(object sender, EventArgs e)
    {
        try
        {
            txtpronamesrch.Text = "";
            txtprocodesrch.Text = "";
            db = new LinqToSqlDataContext();
            var cslConnectProducts = (from pro in db.Products
                                      orderby pro.ProductCode ascending
                                      where (pro.ListedonCSLConnect == true) && pro.IsDependentProduct == false
                                      select pro);

            if (cslConnectProducts.Any(x => x != null))
            {
                gvProducts.DataSource = null;
                gvProducts.DataSource = cslConnectProducts;
                gvProducts.DataBind();
                Session[enumSessions.ListedonCSLConnect.ToString()] = "1";
            }
            else
            {
                gvProducts.DataSource = null;
                gvProducts.DataSource = cslConnectProducts;
                gvProducts.DataBind();
                string script = "alertify.alert('" + ltrNoMatch.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnCSLConnect_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    ArrayList arraylistCSD1 = null;
    ArrayList arraylistCSD2 = null;
    protected void btnAddCSD_Click(Object sender, EventArgs e)
    {
        try
        {
            arraylistCSD1 = new ArrayList();
            arraylistCSD2 = new ArrayList();
            //lbltxt.Visible = false;
            if (lstSelectedARC.SelectedIndex >= 0)
            {
                for (int i = 0; i < lstSelectedARC.Items.Count; i++)
                {
                    if (lstSelectedARC.Items[i].Selected)
                    {
                        if (!arraylistCSD1.Contains(lstSelectedARC.Items[i]))
                        {
                            arraylistCSD1.Add(lstSelectedARC.Items[i]);

                        }
                    }
                }
                for (int i = 0; i < arraylistCSD1.Count; i++)
                {
                    if (!lstCSDRestrictedARC.Items.Contains(((ListItem)arraylistCSD1[i])))
                    {
                        lstCSDRestrictedARC.Items.Add(((ListItem)arraylistCSD1[i]));
                    }
                }
                lstCSDRestrictedARC.SelectedIndex = -1;
            }
            else
            {
                // lbltxt.Visible = true;
                // lbltxt.Text = "Please select atleast one in Listbox1 to move";
            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnAdd_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
        finally
        {
            arraylistCSD1 = null;
            arraylistCSD2 = null;
        }
    }

    protected void btnRemoveCSD_Click(Object sender, EventArgs e)
    {
        try
        {
            arraylistCSD1 = new ArrayList();
            arraylistCSD2 = new ArrayList();
            //lbltxt.Visible = false;
            if (lstCSDRestrictedARC.SelectedIndex >= 0)
            {
                for (int i = 0; i < lstCSDRestrictedARC.Items.Count; i++)
                {
                    if (lstCSDRestrictedARC.Items[i].Selected)
                    {
                        if (!arraylistCSD2.Contains(lstCSDRestrictedARC.Items[i]))
                        {
                            arraylistCSD2.Add(lstCSDRestrictedARC.Items[i]);
                        }
                    }
                }
                for (int i = 0; i < arraylistCSD2.Count; i++)
                {
                    if (!lstSelectedARC.Items.Contains(((ListItem)arraylistCSD2[i])))
                    {
                        lstSelectedARC.Items.Add(((ListItem)arraylistCSD2[i]));
                    }
                    lstCSDRestrictedARC.Items.Remove(((ListItem)arraylistCSD2[i]));
                }
                lstSelectedARC.SelectedIndex = -1;
            }
            else
            {
                // lbltxt.Visible = true;
                //  lbltxt.Text = "Please select atleast one in Listbox2 to move";
            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnAdd_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
        finally
        {
            arraylistCSD1 = null;
            arraylistCSD2 = null;
        }

    }
}
