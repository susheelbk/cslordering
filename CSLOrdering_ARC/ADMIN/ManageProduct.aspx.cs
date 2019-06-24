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
using System.Web.UI.HtmlControls;


public partial class ADMIN_ManageProduct : System.Web.UI.Page
{


    LinqToSqlDataContext db;
    protected void Page_Load(object sender, EventArgs e)
    {
        CreateDynamicTableCellForPriceBands();

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

            //uncheck ctgs
            for (int i = 0; i <= CheckBoxctg.Items.Count - 1; i++)
            {
                CheckBoxctg.Items[i].Selected = false;
            }
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

            //uncheck deppro
            for (int i = 0; i <= ChkboxDepprod.Items.Count - 1; i++)
            {
                ChkboxDepprod.Items[i].Selected = false;
            }
            //uncheck Options
            for (int i = 0; i <= CheckBoxListOptions.Items.Count - 1; i++)
            {
                CheckBoxListOptions.Items[i].Selected = false;
            }

        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSearch_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    public void InsertPriceBandsForM2M()
    {
        //ORD:25
        try
        {
            string m2mCategoryId = (from app in db.ApplicationSettings
                                    where app.KeyName == "M2MCategoryID"
                                    select app.KeyValue).SingleOrDefault();

            //get all the bandname id from BandNamemaster
            List<int> bandNames = (from bnm in db.BandNameMasters
                                   select bnm.ID).ToList();
            PriceBand pb;
            int currencyid = 0;
            for (int i = 0; i <= CheckBoxctg.Items.Count - 1; i++)
            {
                if (CheckBoxctg.Items[i].Value != "Select All")
                {
                    if (CheckBoxctg.Items[i].Value == m2mCategoryId)
                    {
                        TextBox txtPrice = null;
                        TextBox txtAnnualPrice = null;
                        for (int j = 0; j <= cblCurrency.Items.Count - 1; j++) //get the currency id only if the corresponding currency is selected
                        {
                            if (cblCurrency.Items[j].Selected)
                            {
                                string currency = cblCurrency.Items[j].Value;
                                currencyid = (from c in db.Currencies
                                              where c.CurrencyCode == currency
                                              select c.CurrencyID).SingleOrDefault();
                                //retrieving the value ofthe dynamically created textbox value
                                txtPrice = Master.FindControl("contentWrapper").FindControl("txt" + cblCurrency.Items[j].Value) as TextBox;
                                txtAnnualPrice = Master.FindControl("contentWrapper").FindControl("txtAnnual" + cblCurrency.Items[j].Value) as TextBox;

                                //foreach of the bandnameid, create an entry in priceband table with the price nad then annual price
                                foreach (var bandNameid in bandNames)
                                {
                                    pb = new PriceBand();
                                    pb.BandNameId = bandNameid;
                                    pb.ProductId = Convert.ToInt32(Session[enumSessions.ProductId.ToString()]);
                                    pb.CurrencyID = currencyid;
                                    pb.Price = Convert.ToDecimal(txtPrice.Text.ToString().Trim());
                                    pb.AnnualPrice = Convert.ToDecimal(txtAnnualPrice.Text.ToString().Trim());
                                    db.PriceBands.InsertOnSubmit(pb);
                                    db.SubmitChanges();

                                }
                            }//only if the currency is selected, then add a priceband
                        }
                    }

                }
            }

        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "InsertpriceBndsForM2M", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }


    //public String strProductCode = String.Empty;
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            Audit audit = new Audit();
            if (!string.IsNullOrEmpty(txtproCode.Text) && !string.IsNullOrEmpty(txtproName.Text)
                && !string.IsNullOrEmpty(Txtlistorder.Text) && !string.IsNullOrEmpty(Txtprice.Text))
            {


                int chkdep = 0;
                string defaultimg = "";
                string largeimg = "";
                string dbdefaultimg = "";
                string dblargeimg = "";
                string producttype = "";
                db = new LinqToSqlDataContext();

                string msg = String.Empty;


                if (chkIsCSD.Checked)
                {
                    msg = txtMsg.Text.Trim();
                }



                //if updating product and delete all the mapped arc's,depprod,relatedprod and categories of this product.
                #region UpdateProduct
                if (Session[enumSessions.ProductId.ToString()] != null)
                {
                    int productID = Convert.ToInt32(Session[enumSessions.ProductId.ToString()]);
                    try
                    {
                        var ProdInfo = (from pro in db.Products
                                        where pro.ProductId == productID
                                        select pro).SingleOrDefault();
                        string m2mImagesPath = (from app in db.ApplicationSettings
                                                where app.KeyName == "M2MImagesPath"
                                                select app.KeyValue).SingleOrDefault();

                        if (FileUpload1.HasFile)
                        {
                            string filenamewithoutext = System.IO.Path.GetFileNameWithoutExtension(FileUpload1.PostedFile.FileName);
                            string ext = System.IO.Path.GetExtension(FileUpload1.PostedFile.FileName);
                            string ff = txtproCode.Text.ToString() + ext;
                            defaultimg = "../images/" + ff;
                            var m2mpath = m2mImagesPath + ff;
                            FileUpload1.SaveAs(Server.MapPath(defaultimg));
                            FileUpload1.SaveAs(m2mpath);
                            dbdefaultimg = "images/" + ff;
                        }
                        else
                        {
                            dbdefaultimg = ProdInfo.DefaultImage;

                        }


                        if (FileUpload2.HasFile)
                        {
                            string filenamewithoutext = System.IO.Path.GetFileNameWithoutExtension(FileUpload2.PostedFile.FileName);
                            string ext = System.IO.Path.GetExtension(FileUpload2.PostedFile.FileName);
                            string ff = txtproCode.Text.ToString() + "LG" + ext;
                            largeimg = "../images/" + ff;
                            var m2mpath = m2mImagesPath + ff;
                            FileUpload2.SaveAs(Server.MapPath(largeimg));
                            FileUpload1.SaveAs(m2mpath);
                            dblargeimg = "images/" + ff;
                        }
                        else
                        {
                            dblargeimg = ProdInfo.LargeImage;

                        }

                        if (CheckBoxIsDep.Checked == true)
                            chkdep = 1;
                        else chkdep = 0;
                        audit.Notes += " ProductType : ";
                        if (RadioBtnProd.Checked == true)
                            producttype = "Product";
                        else producttype = "Ancillary";
                        audit.Notes += producttype + ", ";

                        var prod = db.Products.Where(x => x.ProductId == Convert.ToInt32(Session[enumSessions.ProductId.ToString()])).FirstOrDefault();
                        if (prod == null)
                        {
                            string script = "alertify.alert('Product not found in DB');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            MaintainScrollPositionOnPostBack = false;
                        }

                        prod.ProductCode = txtproCode.Text.ToString().Trim();
                        prod.ProductName = txtproName.Text.ToString().Trim();
                        prod.ProductDesc = txtprodesc.Text.ToString().Trim();
                        prod.Price = Convert.ToDecimal(Txtprice.Text.ToString().Trim());
                        prod.AnnualPrice = Convert.ToDecimal(TxtAnnualprice.Text.ToString().Trim());
                        prod.DefaultImage = dbdefaultimg;
                        prod.LargeImage = dblargeimg;
                        prod.ModifiedBy = SiteUtility.GetUserName();
                        prod.ModifiedOn = DateTime.Now;
                        prod.IsDependentProduct = Convert.ToBoolean(chkdep);
                        prod.ListOrder = Convert.ToInt32(Txtlistorder.Text.ToString().Trim());
                        prod.ProductType = producttype.ToString().Trim();
                        prod.IsCSD = chkIsCSD.Checked;
                        prod.Message = msg.Trim();
                        prod.CSL_Grade = txtprograde.Text.ToString();
                        prod.IsSiteName = chkSiteName.Checked;
                        prod.IsReplenishment = chkReplenishment.Checked;
                        prod.CSLDescription = txtCSLDescription.Text.Trim();
                        prod.IsDeleted = chkisDeleted.Checked;
                        prod.ListedonCSLConnect = chkListedonCSLConnect.Checked;
                        prod.CSLConnectVoice = chkCSLConnectVoice.Checked;
                        prod.CSLConnectSMS = chkCSLConnectSMS.Checked;
                        prod.Allowance = Convert.ToDouble(txtAllowance.Text);
                        prod.IsHardwareType = chkIsHardwareType.Checked;
                        prod.IsVoiceSMSVisible = chkIsVoiceSMSVisible.Checked;
                        prod.IsOEMProduct = chkIsOEMProduct.Checked;
                        prod.IsDCC = chkIsDCC.Checked;
                        prod.isRouter = chkIsRouter.Checked;
                        prod.isArcMonitoredRouter = chkisArcMonitoredRouter.Checked;
                        prod.UseCountryCodeonPrefix = chkUseCountryCodeonPrefix.Checked;


                        prod.EM_ProductCode = txtEmProductCode.Text.Trim();
                        prod.EM_ProductParamID = string.IsNullOrEmpty(txtInstType_TypeID.Text) ? 0 : Convert.ToInt32(txtInstType_TypeID.Text);
                        prod.PrServerUK = txtUKServer.Text.ToUpper().Trim();
                        prod.PrServerIRE = txtIREServer.Text.ToUpper().Trim();
                        prod.IsEmizonProduct = chkIsEmizonProduct.Checked;
                        prod.IsConnectionOnlyProduct = chkConnectionOnlyEM.Checked;
                        prod.InfoforLogistics = txtlogisticsDesc.Text;

                        prod.AutoGenerateICCID = chkAutoGenerateICCID.Checked;
                        prod.AutoGenerateICCIDonOrderProcess = chkAutoGenerateICCIDonOrderProcess.Checked;
                        prod.AutoGenerateICCIDPrefix = txtAutoGenerateICCIDPrefix.Text;

                        db.SubmitChanges();

                        if (prod != null)
                            Session[enumSessions.ProductId.ToString()] = prod.ProductId;
                        if (prod.ProductId == 0)
                        {
                            string script = "alertify.alert('" + ltrDupProd.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            MaintainScrollPositionOnPostBack = false;
                        }
                        else
                        {
                            InsertPriceBandsForM2M();
                            string script = "alertify.alert('Product [" + txtproCode.Text + "] - " + txtproName.Text + " updated successfully.');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            MaintainScrollPositionOnPostBack = false;
                        }
                        audit.Notes = "ProductId: " + Convert.ToInt32(Session[enumSessions.ProductId.ToString()].ToString()) + ", Code: " + txtproCode.Text.ToString().Trim() + ", Name: " +
                            txtproName.Text.ToString().Trim() + ", Description: " + txtprodesc.Text.ToString().Trim() + ", Price: " + Convert.ToDecimal(Txtprice.Text.ToString().Trim()) + ", Annual Price: " +
                            Convert.ToDecimal(TxtAnnualprice.Text.ToString().Trim()) + ", DefaultImg: " + dbdefaultimg + ", LargeImg: " + dblargeimg + ", Is Dependent: " + Convert.ToBoolean(chkdep) + ", List Order: " +
                            Convert.ToInt32(Txtlistorder.Text.ToString().Trim()) + ", Type: " + producttype.ToString().Trim() + ", Is CSD " + chkIsCSD.Checked + txtprograde.Text.ToString() + ", Site Name: " +
                            chkSiteName.Checked + ", Is Replenishment: " + chkReplenishment.Checked + ", CSL Description: " + txtCSLDescription.Text.Trim() + ", Is Deleted: " + chkisDeleted.Checked + ", Listed On CSL Connect: " +
                            chkListedonCSLConnect.Checked + ", CSL Connect Voice: " + chkCSLConnectVoice.Checked + ", CSL Connect SMS: " + chkCSLConnectSMS.Checked + ", Allowance: " + Convert.ToDouble(txtAllowance.Text) +
                            ", IsHardwareType: " + chkIsHardwareType.Checked + ", IsVoiceSMSVisible: " + chkIsVoiceSMSVisible.Checked + ", IsOEMProduct: " + chkIsOEMProduct.Checked + ", IsDCC: " + chkIsDCC.Checked + ", PrUK: " + txtUKServer.Text
                            + ", PrIRE: " + txtIREServer.Text + ", EM Code: " + txtEmProductCode.Text + ",isRouter :" + chkIsRouter.Checked + ",isArcMonitoredRouter  :" + chkisArcMonitoredRouter.Checked + ",UseCountryCodeonPrefix  :" + chkUseCountryCodeonPrefix.Checked;
                    }
                    catch (Exception prodExcep)
                    {
                        string script = "alertify.alert('Server Error: " + prodExcep.Message + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);

                        db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                        db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSave_Click", Convert.ToString(prodExcep.Message),
                            Convert.ToString(prodExcep.InnerException), Convert.ToString(prodExcep.StackTrace), "",
                            HttpContext.Current.Request.UserHostAddress, false,
                            SiteUtility.GetUserName());
                    }

                    try
                    {
                        var prodCats = db.Category_Product_Maps.Where(x => x.ProductId == productID).ToList();
                        foreach (Category_Product_Map prodMap in prodCats)
                        {
                            db.Category_Product_Maps.DeleteOnSubmit(prodMap);
                        }
                        db.SubmitChanges();

                        var arcProds = db.Product_ARC_Maps.Where(x => x.ProductId == productID).ToList();
                        foreach (Product_ARC_Map arcProdMap in arcProds)
                        {
                            db.Product_ARC_Maps.DeleteOnSubmit(arcProdMap);
                        }
                        db.SubmitChanges();

                        var prodDependents = db.Product_Dependent_Maps.Where(x => x.ProductId == productID).ToList();
                        foreach (Product_Dependent_Map prodMap in prodDependents)
                        {
                            db.Product_Dependent_Maps.DeleteOnSubmit(prodMap);
                        }
                        db.SubmitChanges();

                        var prodoptions = db.Product_Option_Maps.Where(x => x.ProductId == productID).ToList();
                        foreach (Product_Option_Map optionMap in prodoptions)
                        {
                            db.Product_Option_Maps.DeleteOnSubmit(optionMap);
                        }
                        db.SubmitChanges();

                        var prodInstallers = db.Product_Installer_Maps.Where(x => x.ProductId == productID).ToList();
                        foreach (Product_Installer_Map installerMapRecord in prodInstallers)
                        {
                            db.Product_Installer_Maps.DeleteOnSubmit(installerMapRecord);
                        }
                        db.SubmitChanges();
                    }
                    catch (Exception prodExcep)
                    {
                        string script = "alertify.alert('Server Error: " + prodExcep.Message + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);

                        db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                        db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSave_Click", Convert.ToString(prodExcep.Message),
                            Convert.ToString(prodExcep.InnerException), Convert.ToString(prodExcep.StackTrace), "",
                            HttpContext.Current.Request.UserHostAddress, false,
                            SiteUtility.GetUserName());
                    }


                }
                #endregion
                #region NewProduct
                else
                {
                    // create new product 
                    String defImgPath = "";
                    string LImgPath = "";
                    if (FileUpload1.HasFile && FileUpload2.HasFile)
                    {
                        string filenamewithoutext1 = System.IO.Path.GetFileNameWithoutExtension(FileUpload1.PostedFile.FileName);
                        string ext1 = System.IO.Path.GetExtension(FileUpload1.PostedFile.FileName);
                        string ff1 = filenamewithoutext1 + txtproCode.Text.ToString() + ext1;
                        defaultimg = ff1;
                        string filenamewithoutext2 = System.IO.Path.GetFileNameWithoutExtension(FileUpload2.PostedFile.FileName);
                        string ext2 = System.IO.Path.GetExtension(FileUpload2.PostedFile.FileName);
                        string ff2 = filenamewithoutext2 + txtproCode.Text.ToString() + ext2;
                        largeimg = ff2;
                        defImgPath = "images/" + defaultimg;
                        LImgPath = "images/" + largeimg;
                        FileUpload1.SaveAs(Server.MapPath("../images/" + defaultimg));
                        FileUpload2.SaveAs(Server.MapPath("../images/" + largeimg));

                    }
                    if (CheckBoxIsDep.Checked == true)
                        chkdep = 1;
                    else chkdep = 0;

                    audit.Notes += " ProductType : ";
                    if (RadioBtnProd.Checked == true)
                        producttype = "Product";
                    else producttype = "Ancillary";

                    audit.Notes += producttype + ", ";

                    Product newProduct = new Product()
                    {
                        ProductCode = txtproCode.Text.ToString().Trim(),
                        ProductName = txtproName.Text.ToString().Trim(),
                        ProductDesc = txtprodesc.Text.ToString().Trim(),
                        Price = Convert.ToDecimal(Txtprice.Text.ToString().Trim()),
                        AnnualPrice = Convert.ToDecimal(TxtAnnualprice.Text.ToString().Trim()),
                        DefaultImage = defImgPath.ToString().Trim(),
                        LargeImage = LImgPath.ToString().Trim(),
                        IsDependentProduct = Convert.ToBoolean(chkdep),
                        ListOrder = Convert.ToInt32(Txtlistorder.Text.ToString().Trim()),
                        ProductType = producttype.ToString().Trim(),
                        IsCSD = chkIsCSD.Checked,
                        Message = msg.Trim(),
                        CSL_Grade = txtprograde.Text.ToString(),
                        IsSiteName = chkSiteName.Checked,
                        IsReplenishment = chkReplenishment.Checked,
                        CSLDescription = txtCSLDescription.Text.Trim(),
                        IsDeleted = chkisDeleted.Checked,
                        ListedonCSLConnect = chkListedonCSLConnect.Checked,
                        CSLConnectVoice = chkCSLConnectVoice.Checked,
                        CSLConnectSMS = chkCSLConnectSMS.Checked,
                        Allowance = Convert.ToDouble(txtAllowance.Text),
                        IsHardwareType = chkIsHardwareType.Checked,
                        IsVoiceSMSVisible = chkIsVoiceSMSVisible.Checked,
                        IsOEMProduct = chkIsOEMProduct.Checked,
                        IsDCC = chkIsDCC.Checked,
                        isRouter = chkIsRouter.Checked,
                        isArcMonitoredRouter = chkisArcMonitoredRouter.Checked,
                        UseCountryCodeonPrefix = chkUseCountryCodeonPrefix.Checked,

                        EM_ProductCode = txtEmProductCode.Text.Trim(),
                        EM_ProductParamID = string.IsNullOrEmpty(txtInstType_TypeID.Text) ? 0 : int.Parse(txtInstType_TypeID.Text),
                        CreatedBy = SiteUtility.GetUserName(),
                        CreatedOn = DateTime.Now,
                        ModifiedOn = DateTime.Now,
                        PrServerUK = txtUKServer.Text.ToUpper().Trim(),
                        PrServerIRE = txtIREServer.Text.ToUpper().Trim(),
                        IsConnectionOnlyProduct = chkConnectionOnlyEM.Checked,
                        IsEmizonProduct = chkIsEmizonProduct.Checked,
                        InfoforLogistics = txtlogisticsDesc.Text,
                        AutoGenerateICCID = chkAutoGenerateICCID.Checked,
                        AutoGenerateICCIDonOrderProcess = chkAutoGenerateICCIDonOrderProcess.Checked,
                        AutoGenerateICCIDPrefix = txtAutoGenerateICCIDPrefix.Text
                    };

                    var pro = ProductBAL.CreateProduct(newProduct);

                    if (pro != null)
                        Session[enumSessions.ProductId.ToString()] = pro.ProductId;
                    if (pro.ProductId == 0)
                    {
                        string script = "alertify.alert('" + ltrDupProd.Text + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        MaintainScrollPositionOnPostBack = false;
                    }
                    else
                    {
                        //if it belongs to M2M category then, Insert the priceband(A,B,C,D) for the product. the price can be changed in admin section
                        InsertPriceBandsForM2M();

                        string script = "alertify.alert('Product [" + txtproCode.Text + "] - " + txtproName.Text + " created successfully.');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        MaintainScrollPositionOnPostBack = false;
                    }
                    audit.Notes = "ProductId: " + pro.ProductId.ToString() + ", Code: " + txtproCode.Text.ToString().Trim() + ", Name: " +
                        txtproName.Text.ToString().Trim() + ", Description: " + txtprodesc.Text.ToString().Trim() + ", Price: " + Convert.ToDecimal(Txtprice.Text.ToString().Trim()) + ", Annual Price: " +
                        Convert.ToDecimal(TxtAnnualprice.Text.ToString().Trim()) + ", DefaultImg: " + dbdefaultimg + ", LargeImg: " + dblargeimg + ", Is Dependent: " + Convert.ToBoolean(chkdep) + ", List Order: " +
                        Convert.ToInt32(Txtlistorder.Text.ToString().Trim()) + ", Type: " + producttype.ToString().Trim() + ", Is CSD " + chkIsCSD.Checked + txtprograde.Text.ToString() + ", Site Name: " +
                        chkSiteName.Checked + ", Is Replenishment: " + chkReplenishment.Checked + ", CSL Description: " + txtCSLDescription.Text.Trim() + ", Is Deleted: " + chkisDeleted.Checked + ", Listed On CSL Connect: " +
                        chkListedonCSLConnect.Checked + ", CSL Connect Voice: " + chkCSLConnectVoice.Checked + ", CSL Connect SMS: " + chkCSLConnectSMS.Checked + ", Allowance: " + Convert.ToDouble(txtAllowance.Text) +
                        ", IsHardwareType: " + chkIsHardwareType.Checked + ", IsVoiceSMSVisible: " + chkIsVoiceSMSVisible.Checked + ", IsOEMProduct: " + chkIsOEMProduct.Checked + ", IsDCC: " + chkIsDCC.Checked + ", PrUK: " + txtUKServer.Text
                        + ", PrIRE: " + txtIREServer.Text + ", EM Code: " + txtEmProductCode.Text; ;
                    ;
                }
                #endregion




                if (chkdep == 0) //if product is not dependent
                {
                    // 1.enter all the checked categories of this product
                    audit.Notes += " CategoryID : ";
                    int productID = Convert.ToInt32(Session[enumSessions.ProductId.ToString()]);
                    List<int> prodCats = new List<int>();
                    for (int i = 0; i <= CheckBoxctg.Items.Count - 1; i++)
                    {
                        Category_Product_Map cmp;

                        if (CheckBoxctg.Items[i].Value != "Select All")
                        {
                            if (CheckBoxctg.Items[i].Selected == true)
                            {
                                cmp = new Category_Product_Map();
                                cmp.ProductId = productID;
                                cmp.CategoryId = Convert.ToInt32(CheckBoxctg.Items[i].Value);
                                if (prodCats.IndexOf(cmp.CategoryId) < 0)
                                {
                                    db.Category_Product_Maps.InsertOnSubmit(cmp);
                                    db.SubmitChanges();
                                    prodCats.Add(cmp.CategoryId);
                                }
                                audit.Notes += CheckBoxctg.Items[i].Value + ", ";
                            }
                        }
                    }


                    // 2.enter all the checked Related products of this product
                    //removed in website
                    RelatedProduct rp;
                    audit.Notes += " Related Products : ";
                    foreach (GridViewRow ctgrow in gvctgRelated.Rows)
                    {
                        if (ctgrow.RowType == DataControlRowType.DataRow)
                        {
                            GridView innergrid = ctgrow.FindControl("gvinnerRelated") as GridView;
                            List<int> relatedProds = new List<int>();
                            foreach (GridViewRow prodrow in innergrid.Rows)
                            {
                                if (prodrow.RowType == DataControlRowType.DataRow)
                                {
                                    CheckBox chkpro = prodrow.FindControl("chkprod") as CheckBox;
                                    if (chkpro.Checked == true)
                                    {

                                        int Prodid = int.Parse(innergrid.DataKeys[prodrow.RowIndex].Value.ToString());
                                        rp = new RelatedProduct();
                                        rp.ProductId = productID;
                                        rp.RelatedProductId = Convert.ToInt32(Prodid);
                                        if (relatedProds.IndexOf(rp.RelatedProductId) < 0)
                                        {
                                            db.RelatedProducts.InsertOnSubmit(rp);
                                            db.SubmitChanges();
                                            relatedProds.Add(rp.RelatedProductId);
                                        }
                                        audit.Notes += Prodid + ", ";
                                    }
                                }

                            }
                        }

                    }


                    // 3.enter all the checked Arcs/Installers of this product
                    audit.Notes += " Selected ARCs ID: ";
                    string csdrestrictedARC = string.Empty;
                    List<Product_ARC_Map> selectedARCList = new List<Product_ARC_Map>();
                    for (int i = 0; i <= lstSelectedARC.Items.Count - 1; i++)
                    {
                        Product_ARC_Map pam = new Product_ARC_Map();
                        pam.ProductId = productID;
                        pam.ARCId = Convert.ToInt32(lstSelectedARC.Items[i].Value);

                        bool isCSDRestricted = false;

                        for (int o = 0; o <= lstCSDRestrictedARC.Items.Count - 1; o++)
                        {
                            if (lstCSDRestrictedARC.Items[o].Value == lstSelectedARC.Items[i].Value)
                            {
                                isCSDRestricted = true;
                                csdrestrictedARC += lstSelectedARC.Items[i].Value + ", ";
                            }
                        }
                        pam.CSDRestriction = isCSDRestricted;
                        var count = selectedARCList.Where(x => x.ARCId == pam.ARCId && x.ProductId == pam.ProductId && x.CSDRestriction == pam.CSDRestriction).Count();
                        if (count <= 0)
                        {
                            selectedARCList.Add(pam);
                        }
                        else
                        {
                            pam.CSDRestriction = isCSDRestricted;
                        }
                        audit.Notes += lstSelectedARC.Items[i].Value + ", ";  //add list of selected arcs to Notes.
                    }

                    db.Product_ARC_Maps.InsertAllOnSubmit(selectedARCList);
                    db.SubmitChanges();

                    audit.Notes += " Selected CSD only ARCs ID : ";
                    audit.Notes += csdrestrictedARC + ", ";
                    audit.Notes += " InstallerID : ";
                    List<Product_Installer_Map> installerMapList = new List<Product_Installer_Map>();
                    for (int i = 0; i <= lstSelectedInstaller.Items.Count - 1; i++)
                    {
                        Product_Installer_Map pim;

                        pim = new Product_Installer_Map();
                        pim.ProductId = productID;
                        pim.InstallerId = new Guid(lstSelectedInstaller.Items[i].Value);
                        var count = installerMapList.Where(x => x.InstallerId == pim.InstallerId
                            && x.ProductId == pim.ProductId).Count();
                        if (count <= 0)
                        {
                            installerMapList.Add(pim);
                        }
                        audit.Notes += lstSelectedInstaller.Items[i].Value + ", ";
                    }
                    db.Product_Installer_Maps.InsertAllOnSubmit(installerMapList);
                    db.SubmitChanges();

                    // 4.enter dependent checked products  
                    audit.Notes += "Dependent Product ID : ";
                    List<Product_Dependent_Map> prodDependentMapList = new List<Product_Dependent_Map>();
                    for (int i = 0; i <= ChkboxDepprod.Items.Count - 1; i++)
                    {
                        Product_Dependent_Map pam;
                        if (ChkboxDepprod.Items[i].Value != "Select All")
                        {
                            if (ChkboxDepprod.Items[i].Selected == true)
                            {
                                pam = new Product_Dependent_Map();
                                pam.ProductId = productID;
                                pam.DependentProductId = Convert.ToInt32(ChkboxDepprod.Items[i].Value);
                                var count = prodDependentMapList.Where(x => x.DependentProductId == pam.DependentProductId
                                    && x.ProductId == pam.ProductId).Count();
                                if (count <= 0)
                                {
                                    prodDependentMapList.Add(pam);
                                }

                                audit.Notes += ChkboxDepprod.Items[i].Value + ", ";
                            }
                        }
                    }
                    db.Product_Dependent_Maps.InsertAllOnSubmit(prodDependentMapList);
                    db.SubmitChanges();

                    audit.Notes += "Dependent ProductSMS ID : ";
                    for (int i = 0; i <= rdbSMS.Items.Count - 1; i++)
                    {
                        M2MProductDefaultVoiceSM sms;
                        if (rdbSMS.Items[i].Selected == true)
                        {
                            var exists = (from m in db.M2MProductDefaultVoiceSMs
                                          where m.ProductId == productID
                                          select m).SingleOrDefault();
                            if (exists != null)
                            {
                                exists.DefaultSMSID = Convert.ToInt32(rdbSMS.Items[i].Value);
                                db.SubmitChanges();
                            }
                            else
                            {
                                sms = new M2MProductDefaultVoiceSM();
                                sms.ProductId = productID;
                                sms.DefaultSMSID = Convert.ToInt32(rdbSMS.Items[i].Value);
                                db.M2MProductDefaultVoiceSMs.InsertOnSubmit(sms);
                                db.SubmitChanges();
                                audit.Notes += rdbSMS.Items[i].Value + ", ";
                            }
                        }
                    }
                    audit.Notes += "Dependent ProductVoice ID : ";
                    for (int i = 0; i <= rdbVoice.Items.Count - 1; i++)
                    {
                        M2MProductDefaultVoiceSM sms;
                        if (rdbVoice.Items[i].Selected == true)
                        {
                            var exists = (from m in db.M2MProductDefaultVoiceSMs
                                          where m.ProductId == productID
                                          select m).SingleOrDefault();
                            if (exists != null)
                            {
                                exists.DefaultVoiceID = Convert.ToInt32(rdbVoice.Items[i].Value);
                                db.SubmitChanges();
                                audit.Notes += rdbVoice.Items[i].Value + ", ";
                            }
                            else
                            {
                                sms = new M2MProductDefaultVoiceSM();
                                sms.ProductId = productID;
                                sms.DefaultVoiceID = Convert.ToInt32(rdbVoice.Items[i].Value);
                                db.M2MProductDefaultVoiceSMs.InsertOnSubmit(sms);
                                db.SubmitChanges();
                                audit.Notes += rdbVoice.Items[i].Value + ", ";
                            }
                        }
                    }


                }
                else // if product is Dependent only enter its parent (dep)products.
                {
                    audit.Notes += "Dependent Product ID : ";
                    IEnumerable<Product_Dependent_Map> todelete_Product_dependant_maplist = db.Product_Dependent_Maps.Where(x => x.DependentProductId == Convert.ToInt32(Session[enumSessions.ProductId.ToString()])).ToList();
                    db.Product_Dependent_Maps.DeleteAllOnSubmit(todelete_Product_dependant_maplist);

                    //enter parent checked products 
                    foreach (GridViewRow ctgrow in gvctgParent.Rows)
                    {
                        if (ctgrow.RowType == DataControlRowType.DataRow)
                        {
                            GridView innergrid = ctgrow.FindControl("gvinnerParent") as GridView;
                            foreach (GridViewRow prodrow in innergrid.Rows)
                            {
                                if (prodrow.RowType == DataControlRowType.DataRow)
                                {
                                    CheckBox chkpro = prodrow.FindControl("chkprod") as CheckBox;
                                    Product_Dependent_Map rp;

                                    if (chkpro.Checked == true)
                                    {
                                        rp = new Product_Dependent_Map();
                                        int Prodid = int.Parse(innergrid.DataKeys[prodrow.RowIndex].Value.ToString());
                                        rp.ProductId = Convert.ToInt32(Prodid);
                                        rp.DependentProductId = Convert.ToInt32(Session[enumSessions.ProductId.ToString()]);
                                        db.Product_Dependent_Maps.InsertOnSubmit(rp);
                                        db.SubmitChanges();
                                        audit.Notes += Session[enumSessions.ProductId.ToString()] + ", ";

                                    }
                                }

                            }
                        }

                    }


                }

                audit.Notes += "Options : ";
                List<Product_Option_Map> listProdOptions = new List<Product_Option_Map>();

                for (int i = 0; i <= CheckBoxListOptions.Items.Count - 1; i++)
                {
                    Product_Option_Map pom;
                    if (CheckBoxListOptions.Items[i].Value != "Select All")
                    {
                        if (CheckBoxListOptions.Items[i].Selected == true)
                        {
                            pom = new Product_Option_Map();
                            pom.ProductId = Convert.ToInt32(Session[enumSessions.ProductId.ToString()]);
                            pom.OptionId = Convert.ToInt32(CheckBoxListOptions.Items[i].Value);
                            var count = listProdOptions.Where(x => x.OptionId == pom.OptionId && x.ProductId == pom.ProductId).Count();
                            if (count <= 0)
                            {
                                listProdOptions.Add(pom);
                            }
                            audit.Notes += CheckBoxListOptions.Items[i].Text + ", ";
                        }
                    }
                }
                db.Product_Option_Maps.InsertAllOnSubmit(listProdOptions);
                db.SubmitChanges();

                pnlproductdetails.Visible = false;
                pnlproductlist.Visible = true;
                ClearAllInputs();


                LoadData();
            }


            else
            {
                MaintainScrollPositionOnPostBack = false;
                if (string.IsNullOrEmpty(txtproCode.Text))
                {
                    string script = "alertify.alert('" + ltrFillProdCode.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                }
                else if (string.IsNullOrEmpty(txtproName.Text))
                {
                    string script = "alertify.alert('" + ltrFillProdName.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                }
                else if (string.IsNullOrEmpty(Txtlistorder.Text))
                {
                    string script = "alertify.alert('" + ltrFillLstOrdr.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                }
                else if (string.IsNullOrEmpty(Txtprice.Text))
                {
                    string script = "alertify.alert('" + ltrFillPrice.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                }
            }

            audit.UserName = Session[enumSessions.User_Name.ToString()].ToString();
            audit.ChangeID = Convert.ToInt32(enumAudit.Manage_Products);
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
            string script = "alertify.alert('Server Error: " + objException.Message + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);

            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSave_Click", Convert.ToString(objException.Message),
                Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "",
                HttpContext.Current.Request.UserHostAddress, false,
                SiteUtility.GetUserName());
        }
    }

    protected void LinkButtonupdate_click(object sender, System.EventArgs e)
    {
        try
        {
            CreateDynamicTableCellForPriceBands();
            LoadData();
            litAction.Text = "You choose to <b>EDIT PRODUCT</b>";
            pnlproductdetails.Visible = true;
            pnlproductlist.Visible = false;
            lblEditNote.Visible = true;
            lblCreateProductNote.Visible = false;
            //  upPriceband.Visible = false; // Editing the priceband currency is done at create priceband table

            txtproName.Focus();
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
            if (prodDtls.ListedonCSLConnect == true && prodDtls.CSLConnectSMS == false && prodDtls.CSLConnectVoice == false)
            {
                trDefaultSMS.Visible = true;
                trDefaultVoice.Visible = true;
            }
            else
            {
                trDefaultSMS.Visible = false;
                trDefaultVoice.Visible = false;
            }
            if (prodDtls.IsDeleted)
            { litAction.Text += "<br/><span style='Color:Red;font-weight:bold;width:100%'> Note : This Product is flagged as Deleted </span>"; }
            txtproName.Text = prodDtls.ProductName;
            txtproCode.Text = prodDtls.ProductCode;
            Txtprice.Text = prodDtls.Price.ToString();
            TxtAnnualprice.Text = prodDtls.AnnualPrice.ToString();
            chkIsCSD.Checked = Convert.ToBoolean(prodDtls.IsCSD);
            txtprograde.Text = prodDtls.CSL_Grade.ToString();
            txtCSLDescription.Text = prodDtls.CSLDescription;
            chkSiteName.Checked = Convert.ToBoolean(prodDtls.IsSiteName);
            chkReplenishment.Checked = Convert.ToBoolean(prodDtls.IsReplenishment);
            chkisDeleted.Checked = prodDtls.IsDeleted;
            chkListedonCSLConnect.Checked = prodDtls.ListedonCSLConnect;
            chkCSLConnectVoice.Checked = prodDtls.CSLConnectVoice;
            chkCSLConnectSMS.Checked = prodDtls.CSLConnectSMS;
            chkIsHardwareType.Checked = prodDtls.IsHardwareType;
            chkIsVoiceSMSVisible.Checked = prodDtls.IsVoiceSMSVisible;
            chkIsOEMProduct.Checked = prodDtls.IsOEMProduct;
            chkIsDCC.Checked = Convert.ToBoolean(prodDtls.IsDCC); //added by priya
            chkIsRouter.Checked = Convert.ToBoolean(prodDtls.isRouter);
            chkisArcMonitoredRouter.Checked = Convert.ToBoolean(prodDtls.isArcMonitoredRouter);
            chkUseCountryCodeonPrefix.Checked = Convert.ToBoolean(prodDtls.UseCountryCodeonPrefix);
            txtAllowance.Text = prodDtls.Allowance.ToString();
            txtEmProductCode.Text = prodDtls.EM_ProductCode;
            txtIREServer.Text = prodDtls.PrServerIRE;
            txtUKServer.Text = prodDtls.PrServerUK;
            chkConnectionOnlyEM.Checked = prodDtls.IsConnectionOnlyProduct.HasValue ? prodDtls.IsConnectionOnlyProduct.Value : false;
            chkIsEmizonProduct.Checked = prodDtls.IsEmizonProduct.HasValue ? prodDtls.IsEmizonProduct.Value : false;
            txtInstType_TypeID.Text = prodDtls.EM_ProductParamID.ToString();
            txtlogisticsDesc.Text = prodDtls.InfoforLogistics;

            chkAutoGenerateICCID.Checked = string.IsNullOrEmpty(prodDtls.AutoGenerateICCID.ToString()) ? false: prodDtls.AutoGenerateICCID;
            chkAutoGenerateICCIDonOrderProcess.Checked = string.IsNullOrEmpty(prodDtls.AutoGenerateICCIDonOrderProcess.ToString()) ? false:Convert.ToBoolean(prodDtls.AutoGenerateICCIDonOrderProcess) ;
            txtAutoGenerateICCIDPrefix.Text = prodDtls.AutoGenerateICCIDPrefix;


            if (chkIsCSD.Checked)
            {
                txtMsg.Visible = true;
                trMessage.Visible = true;
                txtMsg.Text = prodDtls.Message.ToString();
            }
            else
            {
                txtMsg.Visible = false;
                trMessage.Visible = false;
            }

            if (string.IsNullOrEmpty(prodDtls.ProductDesc))
                txtprodesc.Text = "";
            else txtprodesc.Text = prodDtls.ProductDesc;

            Imagectg.Visible = true;
            Imagectg.ImageUrl = "~/" + prodDtls.DefaultImage;


            LImagectg.Visible = true;
            LImagectg.ImageUrl = "~/" + prodDtls.LargeImage;

            Txtlistorder.Text = prodDtls.ListOrder.ToString();
            CheckProductsOptions();
            if ((prodDtls.IsDependentProduct == false))
            {
                CheckBoxIsDep.Checked = false;
                divdependent.Visible = false;
                divnotdependent.Visible = true;
                CheckCatg();
                CheckArc();
                CheckRelatedProducts();
                CheckDependentProducts();
                CheckDefaultSMS();
                CheckDefaultVoice();


            }
            else
            {
                CheckBoxIsDep.Checked = true;
                divdependent.Visible = true;
                divnotdependent.Visible = false;
                CheckParentProducts();
            }

            if ((prodDtls.ProductType == "Product"))
            {
                RadioBtnProd.Checked = true;
                RadioBtnAnc.Checked = false;
            }
            else
            {
                RadioBtnProd.Checked = false;
                RadioBtnAnc.Checked = true;
            }

            //check if Listed on CSlConnect

            if (prodDtls.ListedonCSLConnect == true)
            {

                // if any other priceband need to be created for a product use edit product ORD:25
                var currenciesInPricebandTable = (from pb in db.PriceBands
                                                  where pb.ProductId == Convert.ToInt32(Session[enumSessions.ProductId.ToString()].ToString())
                                                  select pb.CurrencyID
                                                        );
                if (currenciesInPricebandTable != null || currenciesInPricebandTable.Count() > 0)
                {
                    currenciesInPricebandTable = currenciesInPricebandTable.Distinct();
                }

                var currenciesAvailable = (from c in db.Currencies
                                           select c.CurrencyID).ToList();


                // var x= currenciesAvailable.Intersect(currenciesInPricebandTable);
                var currenciesWithPriceBand = currenciesAvailable.Intersect(currenciesInPricebandTable).ToList();
                if (currenciesWithPriceBand.Count() > 0)
                {
                    foreach (var currency in currenciesWithPriceBand)
                    {
                        string currencyCode = (from c in db.Currencies
                                               where c.CurrencyID == currency
                                               select c.CurrencyCode).SingleOrDefault();
                        upPriceband.Visible = true;

                        for (int j = 0; j <= cblCurrency.Items.Count - 1; j++)
                        {
                            if (cblCurrency.Items[j].Text == currencyCode)
                            {
                                cblCurrency.Items[j].Enabled = false;
                            }
                        }
                    }
                }

                //END ORD:25
            }

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
            Label lbl2 = gvr.FindControl("ProductId") as Label;
            Session[enumSessions.ProductId.ToString()] = lbl2.Text;

            //delete product

            var Prod = db.Products.Single(delpro => delpro.ProductId == Convert.ToInt32(Session[enumSessions.ProductId.ToString()].ToString()));

            Prod.IsDeleted = true;
            db.SubmitChanges();

            string script = "alertify.alert('" + ltrProdDel.Text + "');";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            MaintainScrollPositionOnPostBack = false;
            LoadData();

        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LinkButtondelete_click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    public void CheckCatg()
    {
        try
        {
            int ProdID = Convert.ToInt32(Session[enumSessions.ProductId.ToString()]);
            foreach (ListItem itemchk in CheckBoxctg.Items)
            {
                itemchk.Selected = false;
            }
            int Ctg_Id = 0;
            db = new LinqToSqlDataContext();
            var Prod_ctg = (from c in db.Categories
                            join cpm in db.Category_Product_Maps
                            on c.CategoryId equals cpm.CategoryId
                            where cpm.ProductId == ProdID
                            select new { c.CategoryName, c.CategoryCode, c.CategoryId });

            foreach (var objp in Prod_ctg)
            {

                Ctg_Id = Convert.ToInt32(objp.CategoryId);
                foreach (ListItem itemchk in CheckBoxctg.Items)
                {
                    if (itemchk.Value != "Select All")
                    {
                        int Chkbox_Cid = Convert.ToInt32(itemchk.Value);
                        if (Chkbox_Cid == Ctg_Id)
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
            db.USP_SaveErrorDetails(Request.Url.ToString(), "CheckCatg", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
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
                             join pam in db.Product_ARC_Maps
                             on pr.ProductId equals pam.ProductId
                             join arc in db.ARCs
                             on pam.ARCId equals arc.ARCId
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
                                 join pam in db.Product_ARC_Maps
                                 on pr.ProductId equals pam.ProductId
                                 join arc in db.ARCs
                                 on pam.ARCId equals arc.ARCId
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

    public void CheckParentProducts()
    {
        try
        {
            int PID = Convert.ToInt32(Session[enumSessions.ProductId.ToString()]);
            foreach (GridViewRow ctgrow in gvctgParent.Rows)
            {
                if (ctgrow.RowType == DataControlRowType.DataRow)
                {
                    CheckBox chkctg = ctgrow.FindControl("chkctg") as CheckBox;
                    chkctg.Checked = false;
                    GridView innergrid = ctgrow.FindControl("gvinnerParent") as GridView;
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
            int DepProd_Id = 0;
            db = new LinqToSqlDataContext();
            var dep_pro_id = (from dp in db.Product_Dependent_Maps
                              where dp.DependentProductId == PID
                              select new { dp.ProductId });

            foreach (var objp in dep_pro_id)
            {

                DepProd_Id = Convert.ToInt32(objp.ProductId);
                foreach (GridViewRow ctgrow in gvctgParent.Rows)
                {
                    GridView innergrid = ctgrow.FindControl("gvinnerParent") as GridView;
                    foreach (GridViewRow prodrow in innergrid.Rows)
                    {
                        int chkProdid = int.Parse(innergrid.DataKeys[prodrow.RowIndex].Value.ToString());
                        if (chkProdid == DepProd_Id)
                        {
                            CheckBox chkpro = prodrow.FindControl("chkprod") as CheckBox;
                            chkpro.Checked = true;
                            chkprodParent_CheckedChanged(chkpro, null);

                        }

                    }

                }


            }

            //foreach (var objp in dep_pro_id)
            //{

            //    DepProd_Id = Convert.ToInt32(objp.ProductId);
            //    foreach (ListItem itemchk in Chkboxparentprod.Items)
            //    {
            //        if (itemchk.Value != "Select All")
            //        {
            //            int Chkbox_Pid = Convert.ToInt32(itemchk.Value);
            //            if (Chkbox_Pid == DepProd_Id)
            //            {
            //                itemchk.Selected = true;
            //            }
            //        }
            //    }
            //}
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "CheckParentProducts", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }


    }

    public void CheckProductsOptions()
    {
        try
        {
            int PID = Convert.ToInt32(Session[enumSessions.ProductId.ToString()]);
            foreach (ListItem itemchk in CheckBoxListOptions.Items)
            {
                itemchk.Selected = false;
            }
            int OptId = 0;
            db = new LinqToSqlDataContext();
            var pro_Opt = (from dp in db.Product_Option_Maps
                           where dp.ProductId == PID
                           select new { dp.OptionId });


            foreach (var objp in pro_Opt)
            {

                OptId = Convert.ToInt32(objp.OptionId);
                foreach (ListItem itemchk in CheckBoxListOptions.Items)
                {
                    if (itemchk.Value != "Select All")
                    {
                        int Chkbox_Optid = Convert.ToInt32(itemchk.Value);
                        if (Chkbox_Optid == OptId)
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
            db.USP_SaveErrorDetails(Request.Url.ToString(), "CheckProductsOptions", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }


    }

    public void CheckDependentProducts()
    {
        try
        {
            int PID = Convert.ToInt32(Session[enumSessions.ProductId.ToString()]);
            // uncheck all Products first
            for (int i = 0; i <= ChkboxDepprod.Items.Count - 1; i++)
            {
                ChkboxDepprod.Items[i].Selected = false;
            }

            int DepProd_Id = 0;
            db = new LinqToSqlDataContext();
            var dep_pro_id = (from dp in db.Product_Dependent_Maps
                              where dp.ProductId == PID
                              select new { dp.DependentProductId });


            foreach (var objp in dep_pro_id)
            {

                DepProd_Id = Convert.ToInt32(objp.DependentProductId);
                foreach (ListItem itemchk in ChkboxDepprod.Items)
                {
                    if (itemchk.Value != "Select All")
                    {
                        int Chkbox_Pid = Convert.ToInt32(itemchk.Value);
                        if (Chkbox_Pid == DepProd_Id)
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
            db.USP_SaveErrorDetails(Request.Url.ToString(), "CheckDependentProducts", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }


    public void CheckDefaultSMS()
    {
        try
        {
            int PID = Convert.ToInt32(Session[enumSessions.ProductId.ToString()]);
            // uncheck all Products first
            for (int i = 0; i <= rdbSMS.Items.Count - 1; i++)
            {
                rdbSMS.Items[i].Selected = false;
            }

            int DepProd_Id = 0;
            db = new LinqToSqlDataContext();
            var dep_pro_id = (from dp in db.M2MProductDefaultVoiceSMs
                              where dp.ProductId == PID
                              select new { dp.DefaultSMSID });


            foreach (var objp in dep_pro_id)
            {

                DepProd_Id = Convert.ToInt32(objp.DefaultSMSID);
                foreach (ListItem itemchk in rdbSMS.Items)
                {
                    if (itemchk.Value != "Select All")
                    {
                        int Chkbox_Pid = Convert.ToInt32(itemchk.Value);
                        if (Chkbox_Pid == DepProd_Id)
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
            db.USP_SaveErrorDetails(Request.Url.ToString(), "CheckDependentProducts", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    public void CheckDefaultVoice()
    {
        try
        {
            int PID = Convert.ToInt32(Session[enumSessions.ProductId.ToString()]);
            // uncheck all Products first
            for (int i = 0; i <= rdbVoice.Items.Count - 1; i++)
            {
                rdbVoice.Items[i].Selected = false;
            }

            int DepProd_Id = 0;
            db = new LinqToSqlDataContext();
            var dep_pro_id = (from dp in db.M2MProductDefaultVoiceSMs
                              where dp.ProductId == PID
                              select new { dp.DefaultVoiceID });


            foreach (var objp in dep_pro_id)
            {

                DepProd_Id = Convert.ToInt32(objp.DefaultVoiceID);
                foreach (ListItem itemchk in rdbVoice.Items)
                {
                    if (itemchk.Value != "Select All")
                    {
                        int Chkbox_Pid = Convert.ToInt32(itemchk.Value);
                        if (Chkbox_Pid == DepProd_Id)
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
            db.USP_SaveErrorDetails(Request.Url.ToString(), "CheckDependentProducts", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    public void CheckRelatedProducts()
    {
        try
        {
            int PID = Convert.ToInt32(Session[enumSessions.ProductId.ToString()]);
            // uncheck all Products first
            foreach (GridViewRow ctgrow in gvctgRelated.Rows)
            {
                if (ctgrow.RowType == DataControlRowType.DataRow)
                {
                    CheckBox chkctg = ctgrow.FindControl("chkctg") as CheckBox;
                    chkctg.Checked = false;
                    GridView innergrid = ctgrow.FindControl("gvinnerRelated") as GridView;
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
            int RelProd_Id = 0;
            db = new LinqToSqlDataContext();
            var rel_pro_id = (from rp in db.RelatedProducts
                              where rp.ProductId == PID
                              select new { rp.RelatedProductId, rp.ProductId });


            foreach (var objp in rel_pro_id)
            {

                RelProd_Id = Convert.ToInt32(objp.RelatedProductId);
                foreach (GridViewRow ctgrow in gvctgRelated.Rows)
                {
                    GridView innergrid = ctgrow.FindControl("gvinnerRelated") as GridView;
                    foreach (GridViewRow prodrow in innergrid.Rows)
                    {
                        int chkProdid = int.Parse(innergrid.DataKeys[prodrow.RowIndex].Value.ToString());
                        if (chkProdid == RelProd_Id)
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
            db.USP_SaveErrorDetails(Request.Url.ToString(), "CheckRelatedProducts", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    public void ClearAllInputs()
    {

        txtproCode.Text = String.Empty;
        // txtprocodesrch.Text = "";
        txtprodesc.Text = String.Empty;
        txtproName.Text = String.Empty;
        // txtpronamesrch.Text = "";
        Txtlistorder.Text = String.Empty;
        Txtprice.Text = String.Empty;
        TxtAnnualprice.Text = "0.00";
        txtAllowance.Text = "0";
        RadioBtnProd.Checked = true;
        RadioBtnAnc.Checked = false;
        CheckBoxIsDep.Checked = false;
        Imagectg.ImageUrl = String.Empty;
        LImagectg.ImageUrl = String.Empty;
        Imagectg.Visible = false;
        LImagectg.Visible = false;
        divnotdependent.Visible = true;
        divdependent.Visible = false;
        // MaintainScrollPositionOnPostBack = true;
        chkIsCSD.Checked = false;
        chkListedonCSLConnect.Checked = false;
        Session[enumSessions.ProductId.ToString()] = null;
        txtMsg.Text = String.Empty;
        txtprograde.Text = String.Empty;
        lstSelectedARC.Items.Clear();
        lstSelectedInstaller.Items.Clear();
        chkAutoGenerateICCID.Checked = false;
        chkAutoGenerateICCIDonOrderProcess.Checked = false;
        txtAutoGenerateICCIDPrefix.Text = string.Empty;
    }

    public void LoadData()
    {

        ClearAllInputs();
        try
        {

            //binding checkboxlist currency
            db = new LinqToSqlDataContext();

            var currencies = (from c in db.Currencies
                              select new { c.CurrencyCode }).ToList();
            cblCurrency.DataTextField = "CurrencyCode";
            cblCurrency.DataValueField = "CurrencyCode";

            cblCurrency.DataSource = currencies;
            cblCurrency.DataBind();

            //binding all products in products grid
            db = new LinqToSqlDataContext();

            var Prod = (from pr in db.Products
                        orderby pr.ProductCode ascending
                        where pr.ProductName.Contains(txtpronamesrch.Text.Trim()) && pr.ProductCode.Contains(txtprocodesrch.Text.Trim())
                        select pr);

            if (Session[enumSessions.ListedonCSLConnect.ToString()] == "1")
            {
                Prod = (from pro in db.Products
                        orderby pro.ProductCode ascending
                        where (pro.ListedonCSLConnect == true)
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




            //binding all categories with checkboxes

            db = new LinqToSqlDataContext();
            var CTG = (from ctg in db.Categories
                       where ctg.IsDeleted == false
                       orderby ctg.ListOrder, ctg.CategoryName
                       select new { ctg.CategoryId, CategoryDisp = ctg.CategoryName + "[" + ctg.CategoryCode + "]" });

            CheckBoxctg.DataValueField = "CategoryID";
            CheckBoxctg.DataTextField = "CategoryDisp";
            CheckBoxctg.DataSource = CTG;
            CheckBoxctg.DataBind();
            CheckBoxctg.Items.Insert(0, "Select All");
            for (int i = 0; i <= CheckBoxctg.Items.Count - 1; i++)
            {
                CheckBoxctg.Items[i].Selected = false;
            }

            //binding all products in Parent Products
            db = new LinqToSqlDataContext();
            var ctgdataParent = (from ctg in db.Categories
                                 where ctg.IsDeleted == false
                                 orderby ctg.ListOrder
                                 select new { ctg.CategoryId, CategoryDisp = ctg.CategoryName + " [" + ctg.CategoryCode + "]" });
            gvctgParent.DataSource = ctgdataParent;
            gvctgParent.DataBind();



            //binding all products in Related Products

            //binding gvctgRelated in panel products
            db = new LinqToSqlDataContext();
            var ctgdata = (from ctg in db.Categories
                           where ctg.IsDeleted == false
                           orderby ctg.ListOrder
                           select new { ctg.CategoryId, CategoryDisp = ctg.CategoryName + " [" + ctg.CategoryCode + "]" });
            gvctgRelated.DataSource = ctgdata;
            gvctgRelated.DataBind();


            db = new LinqToSqlDataContext();
            var Pro = (from prod in db.Products
                       where prod.IsDeleted == false &&
                       prod.IsDependentProduct == true
                       orderby prod.ListOrder, prod.ProductCode
                       select new { prod.ProductId, ProductDisp = "[" + prod.ProductCode + "] - " + prod.ProductName });

            ChkboxDepprod.DataValueField = "ProductID";
            ChkboxDepprod.DataTextField = "ProductDisp";
            ChkboxDepprod.DataSource = Pro;
            ChkboxDepprod.DataBind();
            ChkboxDepprod.Items.Insert(0, "Select All");

            for (int i = 0; i <= ChkboxDepprod.Items.Count - 1; i++)
            {
                ChkboxDepprod.Items[i].Selected = false;
            }


            var defSMS = (from prod in db.Products
                          where prod.IsDeleted == false &&
                          prod.CSLConnectSMS == true
                          orderby prod.ListOrder, prod.ProductCode
                          select new { prod.ProductId, ProductDisp = "[" + prod.ProductCode + "] - " + prod.ProductName });

            rdbSMS.DataValueField = "ProductID";
            rdbSMS.DataTextField = "ProductDisp";
            rdbSMS.DataSource = defSMS;
            rdbSMS.DataBind();

            var defVoice = (from prod in db.Products
                            where prod.IsDeleted == false &&
                            prod.CSLConnectVoice == true
                            orderby prod.ListOrder, prod.ProductCode
                            select new { prod.ProductId, ProductDisp = "[" + prod.ProductCode + "] - " + prod.ProductName });

            rdbVoice.DataValueField = "ProductID";
            rdbVoice.DataTextField = "ProductDisp";
            rdbVoice.DataSource = defVoice;
            rdbVoice.DataBind();

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

            //CheckBoxARC.Items.Insert(0, "Select All");

            //for (int i = 0; i <= CheckBoxARC.Items.Count - 1; i++)
            //{
            //    CheckBoxARC.Items[i].Selected = false;
            //}


            // binding all options in CheckBoxListOptions
            db = new LinqToSqlDataContext();
            var Options = (from opt in db.Options
                           orderby opt.OptionName
                           select new { opt.OptID, opt.OptionName });

            CheckBoxListOptions.DataValueField = "OptID";
            CheckBoxListOptions.DataTextField = "OptionName";
            CheckBoxListOptions.DataSource = Options;
            CheckBoxListOptions.DataBind();
            CheckBoxListOptions.Items.Insert(0, "Select All");
            for (int i = 0; i <= CheckBoxListOptions.Items.Count - 1; i++)
            {
                CheckBoxListOptions.Items[i].Selected = false;
            }




        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LoadData", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    protected void CheckBoxIsDep_CheckedChanged(object sender, EventArgs e)
    {

        if (CheckBoxIsDep.Checked)
        {
            divdependent.Visible = true;
            divnotdependent.Visible = false;

        }
        else
        {
            txtMsg.Text = String.Empty;
            divdependent.Visible = false;
            divnotdependent.Visible = true;

        }
    }
    //Order:25
    public void CreateDynamicTableCellForPriceBands()
    {
        for (int i = 0; i <= cblCurrency.Items.Count - 1; i++)
        {
            //check if the product has a priceband already
            db = new LinqToSqlDataContext();
            //   int id = Convert.ToInt32(Session[enumSessions.ProductId.ToString()].ToString());
            if (cblCurrency.Items[i].Selected)
            {

                TableCell tclblPrice = new TableCell();
                tclblPrice.ID = "tclblPrice" + cblCurrency.Items[i].Value;
                tclblPrice.Width = 50;
                // hfManu.Value = cblManufacturer.Items[I].Value;
                Label lblprice = new Label();
                lblprice.ID = "lbl" + cblCurrency.Items[i].Value;
                lblprice.Text = cblCurrency.Items[i].Value + " Price *";
                lblprice.Width = 50;
                lblprice.Attributes.Add("style", "display:inline");
                //lblprice.Attributes.Add("style", "width:30px");
                tclblPrice.Controls.Add(lblprice);
                trprice.Cells.Add(tclblPrice);

                TableCell tctxtPrice = new TableCell();
                tctxtPrice.ID = "tctxtPrice" + cblCurrency.Items[i].Value;

                TextBox txtPrice = new TextBox();
                txtPrice.ID = "txt" + cblCurrency.Items[i].Value;
                txtPrice.Width = 100;
                txtPrice.Attributes.Add("onkeypress", "return isValidPrice(event);");

                tctxtPrice.Controls.Add(txtPrice);
                trprice.Cells.Add(tctxtPrice);

                TableCell tclblAnnualPrice = new TableCell();
                tclblAnnualPrice.ID = "tclblAnnualPrice" + cblCurrency.Items[i].Value;
                tclblAnnualPrice.Width = 50;

                Label lblAnnualprice = new Label();
                lblAnnualprice.ID = "lblAnnual" + cblCurrency.Items[i].Value;
                lblAnnualprice.Text = cblCurrency.Items[i].Value + "Annual Price *";
                lblAnnualprice.Width = 50;
                lblAnnualprice.Attributes.Add("style", "display:inline");
                tclblAnnualPrice.Controls.Add(lblAnnualprice);
                trAnnualprice.Cells.Add(tclblAnnualPrice);

                TableCell tctxtAnnualPrice = new TableCell();
                tctxtAnnualPrice.ID = "tctxtAnnualPrice" + cblCurrency.Items[i].Value;

                TextBox txtAnnualPrice = new TextBox();
                txtAnnualPrice.ID = "txtAnnual" + cblCurrency.Items[i].Value;

                txtAnnualPrice.Width = 100;
                txtAnnualPrice.Attributes.Add("onkeypress", "return isValidPrice(event);");

                tctxtAnnualPrice.Controls.Add(txtAnnualPrice);

                trAnnualprice.Cells.Add(tctxtAnnualPrice);


            }
        }
    }
    //END ORD:25
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

    protected void chkIsCSD_CheckedChanged(object sender, EventArgs e)
    {
        if (chkIsCSD.Checked)
        {
            txtMsg.Visible = true;
            trMessage.Visible = true;

        }
        else
        {
            chkIsCSD.Checked = false;
            trMessage.Visible = false;

        }
    }



    static Boolean CheckBoxctgflag = false;
    protected void CheckBoxctg_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        foreach (ListItem item in CheckBoxctg.Items)
        {
            if ((item.Text == "Select All") && (item.Selected == true) && (CheckBoxctgflag == false))
            {
                foreach (ListItem item1 in CheckBoxctg.Items)
                {
                    item1.Selected = true;
                    CheckBoxctgflag = true;
                }
            }
            else if ((item.Text == "Select All") && (item.Selected == false) && (CheckBoxctgflag == true))
            {
                foreach (ListItem item1 in CheckBoxctg.Items)
                {
                    item1.Selected = false;
                    CheckBoxctgflag = false;
                }

            }
            else if ((item.Text == "Select All") && (item.Selected == true) && (CheckBoxctgflag == true))
            {
                foreach (ListItem item2 in CheckBoxctg.Items)
                {
                    if (item2.Selected == false)
                    {
                        CheckBoxctg.Items[0].Selected = false;
                        CheckBoxctgflag = false;

                    }
                }
            }
            else if ((item.Text == "Select All") && (item.Selected == false) && (CheckBoxctgflag == false) && (CheckBoxctg.SelectedItem != null))
            {
                CheckBoxctg.SelectedItem.Selected = true;

            }
        }

    }


    static Boolean ChkboxDepprodflag = false;
    protected void ChkboxDepprod_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        foreach (ListItem item in ChkboxDepprod.Items)
        {
            if ((item.Text == "Select All") && (item.Selected == true) && (ChkboxDepprodflag == false))
            {
                foreach (ListItem item1 in ChkboxDepprod.Items)
                {
                    item1.Selected = true;
                    ChkboxDepprodflag = true;
                }
            }
            else if ((item.Text == "Select All") && (item.Selected == false) && (ChkboxDepprodflag == true))
            {
                foreach (ListItem item1 in ChkboxDepprod.Items)
                {
                    item1.Selected = false;
                    ChkboxDepprodflag = false;
                }

            }
            else if ((item.Text == "Select All") && (item.Selected == true) && (ChkboxDepprodflag == true))
            {
                foreach (ListItem item2 in ChkboxDepprod.Items)
                {
                    if (item2.Selected == false)
                    {
                        ChkboxDepprod.Items[0].Selected = false;
                        ChkboxDepprodflag = false;

                    }
                }
            }
            else if ((item.Text == "Select All") && (item.Selected == false) && (ChkboxDepprodflag == false) && (ChkboxDepprod.SelectedItem != null))
            {
                ChkboxDepprod.SelectedItem.Selected = true;

            }

        }
    }



    static Boolean CheckBoxOPTflag = false;
    protected void CheckBoxOpt_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        foreach (ListItem item in CheckBoxListOptions.Items)
        {
            if ((item.Text == "Select All") && (item.Selected == true) && (CheckBoxOPTflag == false))
            {
                foreach (ListItem item1 in CheckBoxListOptions.Items)
                {
                    item1.Selected = true;
                    CheckBoxOPTflag = true;
                }
            }
            else if ((item.Text == "Select All") && (item.Selected == false) && (CheckBoxOPTflag == true))
            {
                foreach (ListItem item1 in CheckBoxListOptions.Items)
                {
                    item1.Selected = false;
                    CheckBoxOPTflag = false;
                }

            }
            else if ((item.Text == "Select All") && (item.Selected == true) && (CheckBoxOPTflag == true))
            {
                foreach (ListItem item2 in CheckBoxListOptions.Items)
                {
                    if (item2.Selected == false)
                    {
                        CheckBoxListOptions.Items[0].Selected = false;
                        CheckBoxOPTflag = false;

                    }
                }
            }
            else if ((item.Text == "Select All") && (item.Selected == false) && (CheckBoxOPTflag == false) && (CheckBoxListOptions.SelectedItem != null))
            {
                CheckBoxListOptions.SelectedItem.Selected = true;

            }

        }
    }

    protected void btnnewproduct_Click(object sender, EventArgs e)
    {
        litAction.Text = "You choose to <b>ADD NEW PRODUCT </b>";
        pnlproductdetails.Visible = true;
        pnlproductlist.Visible = false;
        lblCreateProductNote.Visible = true;
        lblEditNote.Visible = false;
        LoadData();
    }
    protected void btnReset_Click(object sender, EventArgs e)
    {
        if (Session[enumSessions.ProductId.ToString()] != null)
        {
            LinkButtonupdate_click(sender, e);
        }
        else
        {
            btnnewproduct_Click(sender, e);
        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Session[enumSessions.ProductId.ToString()] = null;
        pnlproductlist.Visible = true;
        pnlproductdetails.Visible = false;
    }

    protected void gvctgRelated_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            GridView innergrid = e.Row.FindControl("gvinnerRelated") as GridView;
            int ctgid = int.Parse(gvctgRelated.DataKeys[e.Row.RowIndex].Value.ToString());
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


    protected void gvctgParent_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            GridView innergrid = e.Row.FindControl("gvinnerParent") as GridView;
            int ctgid = int.Parse(gvctgParent.DataKeys[e.Row.RowIndex].Value.ToString());
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
        int ctgid = int.Parse(gvctgRelated.DataKeys[Parentrow.RowIndex].Value.ToString());

        GridView innergrid = Parentrow.FindControl("gvinnerRelated") as GridView;
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
            GridView gridproduct = parentrow.FindControl("gvinnerRelated") as GridView;
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



    protected void chkctgParent_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox chk = sender as CheckBox;
        GridViewRow Parentrow = chk.NamingContainer as GridViewRow;
        int ctgid = int.Parse(gvctgParent.DataKeys[Parentrow.RowIndex].Value.ToString());

        GridView innergrid = Parentrow.FindControl("gvinnerParent") as GridView;
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

    protected void chkprodParent_CheckedChanged(object sender, EventArgs e)
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
            GridView gridproduct = parentrow.FindControl("gvinnerParent") as GridView;
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
                                      where (pro.ListedonCSLConnect == true)
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

    protected void chkListedonCSLConnect_CheckedChanged(object sender, EventArgs e)
    {
        if (chkListedonCSLConnect.Checked)
        {
            upPriceband.Visible = true;
        }
        else
        {
            upPriceband.Visible = false;
        }
    }
    protected void cblCurrency_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
}
