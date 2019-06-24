using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;
using System.Web.Security;
using CSLOrderingARCBAL.Common;

public partial class ADMIN_MapInstallerARCToProducts : System.Web.UI.Page
{

    LinqToSqlDataContext db;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindControls();
        }
    }
    protected void BindControls()
    {
        db = new LinqToSqlDataContext();
        try
        {
            var arcProductIds = (from pam in db.Product_ARC_Maps select pam.ProductId).Distinct();
            var installerProductIds = (from pam in db.Product_ARC_Maps select pam.ProductId).Distinct();
            var productCodesFrom = (from product in db.Products
                                    where product.IsDeleted == false && product.ProductCode != null && (arcProductIds.Contains(product.ProductId) || installerProductIds.Contains(product.ProductId))
                                    orderby product.ProductCode ascending
                                    select new
                                    {
                                        productID = product.ProductId,
                                        productName = product.ProductName,
                                        productDisp = product.ProductCode

                                    }).ToList();

            lstProductsFrom.DataSource = productCodesFrom;
            lstProductsFrom.DataTextField = "productDisp";
            lstProductsFrom.DataValueField = "productName";
            lstProductsFrom.DataBind();

            var productCodesTo = (from product in db.Products
                                  where product.IsDeleted == false && product.ProductCode != null
                                  orderby product.ProductCode ascending
                                  select new
                                  {
                                      productID = product.ProductId,
                                      productName = product.ProductName,
                                      productDisp = product.ProductCode

                                  }).ToList();
            lstProductsTo.DataSource = productCodesTo;
            lstProductsTo.DataTextField = "productDisp";
            lstProductsTo.DataValueField = "productName";
            lstProductsTo.DataBind();
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "MappingInstallerARCToProducts-->PageLoad", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
        finally
        {
            if (db != null)
            {
                db.Dispose();
            }


        }
    }

    protected void ddlInstallersfromProduct_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (lstProductsFrom.SelectedIndex > 0 && lstProductsTo.SelectedIndex > 0)
        {

            lblProductWarn.Visible = false;
        }
    }
    protected void ddlInstallersToProduct_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (lstProductsFrom.SelectedIndex > 0 && lstProductsTo.SelectedIndex > 0)
        {

            lblProductWarn.Visible = false;
        }

    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        Audit auditNotes = new Audit();
        List<Guid> listInstallersMapped = new List<Guid>(); ;
        List<int> listArcsMapped = new List<int>();

        db = new LinqToSqlDataContext();
        try
        {
            if (lstProductsFrom.SelectedIndex > 0 && lstProductsTo.SelectedIndex > 0)
            {

                int productIdFrom = db.Products.Where(x => x.ProductCode == lstProductsFrom.SelectedItem.Text).Select(x => x.ProductId).FirstOrDefault();


                int productIdTo = db.Products.Where(x => x.ProductCode == lstProductsTo.SelectedItem.Text).Select(x => x.ProductId).FirstOrDefault();


                auditNotes.Notes += "product id:" + productIdTo;

                if (chkArcs.Checked || chkInstallers.Checked)
                {

                    if (chkInstallers.Checked)
                    {
                        //Deleting the previous mappings of the Installers with the productTo 

                        var prodInstallers = db.Product_Installer_Maps.Where(x => x.ProductId == productIdTo).ToList();
                        foreach (Product_Installer_Map installerMapRecord in prodInstallers)
                        {
                            db.Product_Installer_Maps.DeleteOnSubmit(installerMapRecord);
                        }
                        db.SubmitChanges();

                        //get the list of installers mapped with the productIDFrom

                        listInstallersMapped = (from pim in db.Product_Installer_Maps
                                                where pim.ProductId == productIdFrom
                                                select pim.InstallerId).ToList();


                    }
                    if (chkArcs.Checked)
                    {

                        //Deleting the previous mappings of the ARcs with the productTo 

                        var arcProds = db.Product_ARC_Maps.Where(x => x.ProductId == productIdTo).ToList();
                        foreach (Product_ARC_Map arcProdMap in arcProds)
                        {
                            db.Product_ARC_Maps.DeleteOnSubmit(arcProdMap);
                        }
                        db.SubmitChanges();

                        //get the list of ARCs mapped with productIDFrom
                        listArcsMapped = (from pam in db.Product_ARC_Maps
                                          where pam.ProductId == productIdFrom
                                          select pam.ARCId).ToList();

                    }
                }
                else
                {
                    string scripts = "alertify.alert('No Arcs or Installers Selected');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", scripts, true);
                }


                //insert into product_Arc_map for the new product selected -ProductIDTo

                //string csdrestrictedARC = string.Empty;
                auditNotes.Notes += "ARCsmapped: ";
                List<Product_ARC_Map> selectedARCList = new List<Product_ARC_Map>();
                if (listArcsMapped.Count > 0)
                {
                    for (int i = 0; i <= listArcsMapped.Count - 1; i++)
                    {
                        Product_ARC_Map pam = new Product_ARC_Map();
                        pam.ProductId = productIdTo;
                        pam.ARCId = Convert.ToInt32(listArcsMapped[i]);

                        // CSD Restrictions not included
                        bool isCSDRestricted = false;

                        //for (int o = 0; o <= lstCSDRestrictedARC.Items.Count - 1; o++)
                        //{
                        //    if (lstCSDRestrictedARC.Items[o].Value == lstSelectedARC.Items[i].Value)
                        //    {
                        //        isCSDRestricted = true;
                        //        csdrestrictedARC += lstSelectedARC.Items[i].Value + ", ";
                        //    }
                        //}

                        pam.CSDRestriction = isCSDRestricted;
                        var count = selectedARCList.Where(x => x.ARCId == pam.ARCId && x.ProductId == pam.ProductId && x.CSDRestriction == pam.CSDRestriction).Count();
                        if (count <= 0)
                        {
                            selectedARCList.Add(pam);
                        }

                        auditNotes.Notes += listArcsMapped[i] + ", ";  //add list of selected arcs to Notes.
                    }


                    db.Product_ARC_Maps.InsertAllOnSubmit(selectedARCList);
                    db.SubmitChanges();
                }

                //insert into product_Installer_map

                if (listInstallersMapped.Count > 0)
                {
                    List<Product_Installer_Map> installerMapList = new List<Product_Installer_Map>();
                    auditNotes.Notes += "Installers Mapped: ";
                    for (int i = 0; i <= listInstallersMapped.Count - 1; i++)
                    {
                        Product_Installer_Map pim;

                        pim = new Product_Installer_Map();
                        pim.ProductId = productIdTo;
                        pim.InstallerId = listInstallersMapped[i];
                        var count = installerMapList.Where(x => x.InstallerId == pim.InstallerId
                            && x.ProductId == pim.ProductId).Count();
                        if (count <= 0)
                        {
                            installerMapList.Add(pim);
                        }
                        auditNotes.Notes += listInstallersMapped[i] + ", ";
                    }
                    db.Product_Installer_Maps.InsertAllOnSubmit(installerMapList);
                    db.SubmitChanges();

                }
                string script = "alertify.alert(' " + listInstallersMapped.Count + " Installers and " + listArcsMapped.Count + " ARCs mapped  from [" + lstProductsFrom.SelectedItem.Text + "]  to [ " + lstProductsTo.SelectedItem.Text + "] successfully.');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);

            }
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "MappingInstallerARCToProducts-->btnSave", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
        finally
        {
            if (db != null)
            {
                db.Dispose();
            }


        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        // ddlInstallersfromProduct.SelectedValue = "-1";
        //ddlInstallersToProduct.SelectedValue = "-1";
        chkInstallers.Checked = false;
        chkArcs.Checked = false;
        lblProductWarn.Visible = false;
        lblChkARCs.Visible = false;
        lblChkInstallers.Visible = false;

    }
    protected void chkInstallers_CheckedChanged(object sender, EventArgs e)
    {
        if (chkInstallers.Checked)
        {

            if (lstProductsFrom.SelectedIndex > 0 && lstProductsTo.SelectedIndex > 0)
            {
                string script = "alertify.alert(' All previous Installer Mappings will be deleted for product " + lstProductsTo.SelectedItem.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
            else
            {
                lblProductWarn.Visible = true;
                chkInstallers.Checked = false;
            }

        }
        else
        {
            lblChkInstallers.Visible = false;
        }
    }
    protected void chkArcs_CheckedChanged(object sender, EventArgs e)
    {
        if (chkArcs.Checked)
        {

            if (lstProductsFrom.SelectedIndex > 0 && lstProductsTo.SelectedIndex > 0)
            {
                string script = "alertify.alert(' All previous ARC Mappings will be deleted for product " + lstProductsTo.SelectedItem.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
            else
            {

                lblProductWarn.Visible = true;
                chkArcs.Checked = false;
            }

        }
        else
        {
            lblChkARCs.Visible = false;
        }

    }
}