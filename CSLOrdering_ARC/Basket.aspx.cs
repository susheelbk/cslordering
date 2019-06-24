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
using System.Web.UI.HtmlControls;
using System.Configuration;
using System.Data;
using System.Web.Services;
using System.Collections;

public partial class Basket : System.Web.UI.Page
{

    #region Page_Load

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Session[enumSessions.User_Id.ToString()] == null || Session[enumSessions.OrderId.ToString()] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                LoadBasketProducts();
                divDuplicatesAllowed.Visible = false;
                divDuplicatePanelIDAllowed.Visible = false;

                if (Convert.ToBoolean(Session[enumSessions.HasUserAcceptedDuplicates.ToString()]))
                {
                    chkDuplicatesAllowed.Checked = true;
                    divDuplicatesAllowed.Visible = true;
                }

                if (Convert.ToBoolean(Session[enumSessions.HasUserAcceptedDuplicatePanelID.ToString()]))
                {
                    chkDuplicatePanelIDAllowed.Checked = true;
                    divDuplicatePanelIDAllowed.Visible = true;
                }
            }
        }
        catch (System.Threading.ThreadAbortException ex)
        {
            //
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    #endregion


    #region LoadBasketProducts

    void LoadBasketProducts()
    {
        btnCheckout.Visible = true;
        LinqToSqlDataContext db = new LinqToSqlDataContext();

        // show arc description
        var arc = (from a in db.ARCs
                   where a.ARCId == Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString())
                   select a
                            ).SingleOrDefault();
        // show arc description
        ltrARCDescription.Text = arc.Description;
        hdnSafelinkbyIPSec.Value = arc.SafelinkbyIPSec.ToString();
        hdnLocktoDefaultOption.Value = arc.LocktoDefaultOption.ToString();
        hdnInstallID_Flag.Value = arc.EM_InstallID_Flag.ToString();
        hdnTCDStockCheck.Value = false.ToString();//JIRA: EMIZON-28 // string.IsNullOrEmpty(arc.EM_ARCNo) ? false.ToString() : true.ToString();//this needs changing, for now if ARC has EM ARcode then allow to fetch tcd stock.
        hdnInstallIDLen.Value = arc.EM_InstallIDLength;
        hdnInstallIDStrategy.Value = arc.EM_InstallIDStrategy.HasValue ? arc.EM_InstallIDStrategy.ToString() : "";
        HiddenFieldARCid.Value = arc.ARCId.ToString();
        hdnARCisCSD.Value = arc.IsAllowedCSD.HasValue ? arc.IsAllowedCSD.Value.ToString() : false.ToString();

        var BasketProducts = db.USP_GetBasketProducts(Convert.ToInt32(Session[enumSessions.OrderId.ToString()].ToString())).ToList();
        dlProducts.DataSource = BasketProducts;
        dlProducts.DataBind();
        db.Dispose();

        if (dlProducts.Items.Count == 0)
        {
            chkDuplicatesAllowed.Checked = false;
            divDuplicatesAllowed.Visible = false;
            //dupliacted PanelID
            chkDuplicatePanelIDAllowed.Checked = false;
            divDuplicatePanelIDAllowed.Visible = false;

            btnCheckout.Visible = false;
            lbClearBasket.Visible = false;
            LinqToSqlDataContext db1 = new LinqToSqlDataContext();
            db1.USP_ARCAcceptDuplicateChipNumbers(Convert.ToInt32(Session[enumSessions.OrderId.ToString()]), chkDuplicatesAllowed.Checked);
            db1.USP_ARCAcceptDuplicatePanelID(Convert.ToInt32(Session[enumSessions.OrderId.ToString()]), chkDuplicatePanelIDAllowed.Checked);
            db1.Dispose();

            Session[enumSessions.HasUserAcceptedDuplicates.ToString()] = chkDuplicatesAllowed.Checked;
            Session[enumSessions.HasUserAcceptedDuplicatePanelID.ToString()] = chkDuplicatePanelIDAllowed.Checked;
        }
    }

    #endregion

    #region ProductsRepeater_ItemCommand
    protected void ProductsRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        try
        {
            switch (e.CommandName)
            {
                case "RemoveFromBasket":
                    try
                    {
                        LinqToSqlDataContext db = new LinqToSqlDataContext();
                        db.USP_RemoveProductFromBasket(Convert.ToInt32(e.CommandArgument), Session[enumSessions.User_Name.ToString()].ToString());
                        LoadBasketProducts();
                    }
                    catch { }
                    break;

                default:
                    break;
            }
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "ProductsRepeater_ItemCommand", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException),
                Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    #endregion

    #region ProductsRepeater_ItemBound

    protected void ProductsRepeater_ItemBound(object sender, RepeaterItemEventArgs args)
    {
        try
        {
            bool installID_Flag = false;
            Boolean.TryParse(hdnInstallID_Flag.Value, out installID_Flag);

            if (args.Item.ItemType == ListItemType.Item || args.Item.ItemType == ListItemType.AlternatingItem || args.Item.ItemType == ListItemType.Header)
            {
                LinqToSqlDataContext db = new LinqToSqlDataContext();
                if (Session[enumSessions.User_Role.ToString()].ToString() != enumRoles.ARC_Admin.ToString())
                {
                    HtmlControl tdProductPrice = args.Item.FindControl("tdProductPrice") as HtmlControl;
                    tdProductPrice.Visible = false;

                    HtmlControl tdProductPriceTotal = args.Item.FindControl("tdProductPriceTotal") as HtmlControl;
                    tdProductPriceTotal.Visible = false;

                    tdHeaderPrice.Visible = false;
                    tdHeaderTotalAmount.Visible = false;
                }
                if (Session[enumSessions.User_Role.ToString()] != null && Session[enumSessions.User_Role.ToString()].ToString() == enumRoles.ARC_Admin.ToString())
                {
                    Label lblProductPrice = (Label)args.Item.FindControl("lblProductPrice");
                    if (lblProductPrice != null)
                        lblProductPrice.Text = "0.00";

                    Label lblProductPriceTotal = (Label)args.Item.FindControl("lblProductPriceTotal");
                    if (lblProductPriceTotal != null)
                        lblProductPriceTotal.Text = "0.00";
                }

                TextBox lblProductId = args.Item.FindControl("lblProductId") as TextBox;

                USP_GetBasketProductsResult product = (USP_GetBasketProductsResult)args.Item.DataItem;

                List<String> CategorieswithNoChipNo = (from app in db.ApplicationSettings
                                                       where app.KeyName == "CategorieswithNoChipNo"
                                                       select app.KeyValue).SingleOrDefault().Split(',').ToList();


                bool NeedChipNos = true;
                if (CategorieswithNoChipNo.Contains(product.CategoryId.ToString()))
                {
                    NeedChipNos = false;
                }

                if (product != null && product.ProductType == "Product" & NeedChipNos)
                {
                    Repeater rep = (Repeater)args.Item.FindControl("rptrChipNos");

                    //ghet IPAdres,.MAsk
                    var itemdetaillist = db.USP_GetBasketGPRSChipNumbersByProductId(Convert.ToInt32(Session[enumSessions.OrderId.ToString()].ToString()), product.ProductId, product.CategoryId).Select
                                                                                (x => new
                                                                                {
                                                                                    x.GPRSNo,
                                                                                    x.GPRSNoPostCode,
                                                                                    x.GSMNo,
                                                                                    x.OptionId,
                                                                                    x.OptionName,
                                                                                    x.OrderItemDetailId,
                                                                                    x.PSTNNo,
                                                                                    x.SiteName,
                                                                                    x.IPAddress, //ord-42
                                                                                    x.Mask,
                                                                                    x.Gateway,
                                                                                    product.CategoryId,
                                                                                    product.IsCSDUser,
                                                                                    product.ProductCode,
                                                                                    ChipNo_Flag = product.IsEmizonProduct.HasValue ? (product.IsEmizonProduct.Value ? false : true) : true,
                                                                                    InstallID_Flag = product.IsEmizonProduct.Value ? installID_Flag : false, // set to false if its not Em product, if EM then verify ARC flag
                                                                                    EM_TCD_SerialNo = x.EM_TCD_SerialNo,
                                                                                    TCD_Flag = product.IsReplenishmentUser ? false : (
                                                                                    (product.IsCSDUser && product.IsEmizonProduct.Value) ? true :
                                                                                    (product.IsEmizonProduct.Value ? (product.IsConnectionOnlyProduct.Value ? true : false) : false)
                                                                                    ),
                                                                                    ShowSitename = product.IsSiteName,
                                                                                    IsEmizonProduct = product.IsEmizonProduct,
                                                                                    IsConnectionOnly = product.IsConnectionOnlyProduct
                                                                                });

                    rep.DataSource = itemdetaillist;
                    rep.DataBind();
                }

                HtmlControl tdManufacturer = args.Item.FindControl("tdManufacturer") as HtmlControl;
                tdManufacturer.Visible = true;

                string name = (from dcc in db.DCCCompanies
                               where dcc.Productcode.Contains(product.ProductCode)
                               select dcc.company_name).FirstOrDefault();



                if (name != null)
                {
                    tdManufacturerHeader.Visible = true;

                    Label lblManufacturer = args.Item.FindControl("lblManufacturer") as Label;
                    lblManufacturer.Visible = true;
                    lblManufacturer.Text = name;
                }

                //ord-42


                //END: ord-42

                int arcID = Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()]);
                bool isCSDRestricted = db.Product_ARC_Maps.Where(x => x.ARCId == arcID && x.ProductId == product.ProductId).FirstOrDefault().CSDRestriction;

                if (product != null && product.IsCSDProd == true && isCSDRestricted == true)
                {
                    RadioButton rdbCSD = args.Item.FindControl("rdbCSD") as RadioButton;
                    if (isCSDRestricted == true)
                    {
                        rdbCSD.Visible = true;
                    }
                    tdCSDHeader.Visible = true;
                    replenishmentMsg.Visible = true;
                    HtmlControl tdCSDValue = args.Item.FindControl("tdCSDValue") as HtmlControl;
                    tdCSDValue.Visible = true;
                    if (product.IsCSDUser == true)
                    {
                        rdbCSD.Checked = true;
                    }
                    else if (product.IsReplenishmentUser == false)
                    {
                        string script = "alertify.alert('" + ltrReplenishment.Text + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    }

                }
                else
                {
                    replenishmentMsg.Visible = false;
                }

                //IsReplenishmentEnabled
                if (product.IsReplenishmentProd == true && isCSDRestricted == true)
                {
                    CheckBox rdbReplenishment = args.Item.FindControl("rdbReplenishment") as CheckBox;
                    TableCell tdReplenishment = args.Item.FindControl("tdReplenishment") as TableCell;
                    if (isCSDRestricted == true)
                    {
                        rdbReplenishment.Visible = true;
                    }
                    tdReplenishmentHeader.Visible = true;

                    if (product.IsReplenishmentUser == true)
                    {
                        rdbReplenishment.Checked = true;
                    }

                }
                if (tdReplenishmentHeader.Visible)
                {
                    HtmlControl tdReplenishment = args.Item.FindControl("tdReplenishment") as HtmlControl;
                    tdReplenishment.Visible = true;
                    HtmlControl tdReplenishmentFill = args.Item.FindControl("tdReplenishmentFill") as HtmlControl;
                    tdReplenishmentFill.Visible = false;
                    tdReplenishmentHeaderFill.Visible = false;
                }
            }
            if (args.Item.ItemType == ListItemType.Footer)
            {
                Label lblTotalPrice = (Label)args.Item.FindControl("lblTotalPrice");
                Label lblTotalQty = (Label)args.Item.FindControl("lblTotalQty");

                LinqToSqlDataContext db = new LinqToSqlDataContext();
                var OrderInfo = db.USP_CreateOrderForUser(Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString()), Session[enumSessions.User_Name.ToString()].ToString(), Session[enumSessions.User_Name.ToString()].ToString(), Session[enumSessions.User_Email.ToString()].ToString(), Session[enumSessions.User_Id.ToString()].ToString()).SingleOrDefault();
                if (OrderInfo != null)
                {
                    lblTotalPrice.Text = OrderInfo.Amount.ToString();
                    lblTotalQty.Text = OrderInfo.Quantity.ToString();
                }

                if (Session[enumSessions.User_Role.ToString()] != null && Session[enumSessions.User_Role.ToString()].ToString() == enumRoles.ARC_Admin.ToString())
                {
                    lblTotalPrice.Text = "0.00";
                }
                db.Dispose();
            }


        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "ProductsRepeater_ItemBound", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    #endregion

    #region rptrChipNos_ItemCommand
    protected void rptrChipNos_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        try
        {
            switch (e.CommandName)
            {
                case "RemoveFromBasket":
                    try
                    {
                        LinqToSqlDataContext db = new LinqToSqlDataContext();
                        db.USP_RemoveChipNumberFromBasket(Convert.ToInt32(e.CommandArgument), Session[enumSessions.User_Name.ToString()].ToString());
                        LoadBasketProducts();
                    }
                    catch { }
                    break;

                default:
                    break;
            }
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "rptrChipNos_ItemCommand", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    #endregion

    #region btnContinueShopping_Click

    protected void btnContinueShopping_Click(object sender, EventArgs e)
    {
        try
        {
            if (Page.IsValid)
            {

                if (dlProducts.Items.Count > 0)
                {
                    LinqToSqlDataContext db = new LinqToSqlDataContext();
                    int? replenishmentLimit = (from a in db.ARCs
                                               where a.ARCId == Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()])
                                               select a.ReplenishmentLimit).SingleOrDefault();
                    foreach (RepeaterItem item in dlProducts.Items)
                    {
                        RadioButton rdbCSD = item.FindControl("rdbCSD") as RadioButton;
                        RadioButton rdbReplenishment = item.FindControl("rdbReplenishment") as RadioButton;
                        if (rdbCSD.Visible == true && rdbCSD.Checked == false && rdbReplenishment.Checked == false)
                        {
                            string script = "alertify.alert('" + ltrCSD.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            return;
                        }
                        int orderid = Convert.ToInt32(Session[enumSessions.OrderId.ToString()]);
                        Label orderitemid = item.FindControl("lblOrderitemid") as Label;

                        OrderItem obj = (from o in db.OrderItems
                                         where o.OrderItemId == Convert.ToInt32(orderitemid.Text)
                                         select o).SingleOrDefault();

                        obj.IsCSD = rdbCSD.Checked;
                        obj.IsReplenishment = rdbReplenishment.Checked;
                        db.SubmitChanges();
                        int replenishmentCount = (from i in db.vw_IdentLists
                                                  where i.ARCID == Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()])
                                                  && i.ProductID == obj.ProductId
                                                  select i).Count();
                        if (replenishmentLimit != null && replenishmentCount >= replenishmentLimit && rdbReplenishment.Checked == true && rdbCSD.Checked == false)
                        {
                            divReplenishmentAllowed.Visible = true;
                            chkReplenishmentAllowed.Text = ltrReplenishmentCount1.Text + "<b style='font-size:1.3em;'>" + replenishmentCount + "</b>" + ltrReplenishmentCount2.Text;
                            if (chkReplenishmentAllowed.Checked == false)
                            {
                                return;
                            }
                        }
                    }


                    if (ValidateGPRSChipNumbers())
                    {
                        Response.RedirectPermanent("~/Categories.aspx");
                    }
                }
                else
                {
                    Response.RedirectPermanent("~/Categories.aspx");
                }
            }
        }
        catch (System.Threading.ThreadAbortException ex)
        {
            //
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnContinueShopping_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    #endregion

    #region btnCheckout_Click
    protected void btnCheckout_Click(object sender, EventArgs e)
    {
        try
        {
            MaintainScrollPositionOnPostBack = true;
            if (Page.IsValid)
            {

                if (dlProducts.Items.Count > 0)
                {
                    
                    //get the Pyronix product list from config.
                    List<string> lstPyronixProducts = new List<string>();

                    // lstPyronixProducts = CSLOrderingARCBAL.BAL.ProductBAL.GetPyronixProducts().Split(',').ToList();
                    lstPyronixProducts = CSLOrderingARCBAL.BAL.ProductBAL.GetPyronixProductsWith6DigitChipNo().Split(',').ToList();
                    foreach (RepeaterItem itemProduct in dlProducts.Items)
                    {
                        Label lblProductCode = itemProduct.FindControl("lblProductCode") as Label;

                        if (lstPyronixProducts.Exists((x => x.StartsWith(lblProductCode.Text))))
                        {
                            bool isPyronixSatisfied = true;
                            Repeater rpInner = itemProduct.FindControl("rptrChipNos") as Repeater;
                            foreach (RepeaterItem itemChip in rpInner.Items)
                            {
                                TextBox txtChips = itemChip.FindControl("txtChipNo") as TextBox;
                                DropDownList ddOptions = itemChip.FindControl("ddlOptions") as DropDownList;
                                if (txtChips.Text.Trim().Length < 6)
                                //&& ddOptions.SelectedItem != null && ddOptions.SelectedItem.Text.Trim() == "FastFormat") - not required as discussed with Andy
                                {
                                    isPyronixSatisfied = false;
                                    break;
                                }
                            }
                            if (!isPyronixSatisfied)
                            {
                                string script = "alertify.alert('" + ltrPyronixChipNos.Text + "');";
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                return;
                            }


                        }
                    }

                    //do Ip Address validation here

                    LinqToSqlDataContext db = new LinqToSqlDataContext();
                    int? replenishmentLimit = (from a in db.ARCs
                                               where a.ARCId == Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()])
                                               select a.ReplenishmentLimit).SingleOrDefault();

                    //Ravi - Noticed this change has improved performance on line 519. -- 03 Apr 2018
                    List<vw_IdentList> tblIdents = db.vw_IdentLists.ToList();

                    //sonam code to save chkbox csd in orderitem
                    foreach (RepeaterItem item in dlProducts.Items)
                    {
                        CheckBox rdbCSD = item.FindControl("rdbCSD") as CheckBox;
                        CheckBox rdbReplenishment = item.FindControl("rdbReplenishment") as CheckBox;
                        if (rdbCSD.Visible == true && rdbCSD.Checked == false && rdbReplenishment.Checked == false)
                        {
                            string script = "alertify.alert('" + ltrCSD.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            return;
                        }
                        int orderid = Convert.ToInt32(Session[enumSessions.OrderId.ToString()]);
                        Label orderitemid = item.FindControl("lblOrderitemid") as Label;

                        OrderItem obj = (from o in db.OrderItems
                                         where o.OrderItemId == Convert.ToInt32(orderitemid.Text)
                                         select o).SingleOrDefault();
                        obj.IsCSD = rdbCSD.Checked;
                        obj.IsReplenishment = rdbReplenishment.Checked;
                        db.SubmitChanges();



                        int replenishmentCount = (from i in tblIdents
                                                  where i.ARCID == Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()])
                                                  && i.ProductID == obj.ProductId
                                                  select i).Count();
                        if (replenishmentLimit != null && replenishmentCount >= replenishmentLimit && rdbReplenishment.Checked == true && rdbCSD.Checked == false)
                        {
                            divReplenishmentAllowed.Visible = true;
                            chkReplenishmentAllowed.Text = ltrReplenishmentCount1.Text + "<b style='font-size:1.3em;'>" + replenishmentCount + "</b>" + ltrReplenishmentCount2.Text;
                            if (chkReplenishmentAllowed.Checked == false)
                            {
                                return;
                            }
                        }
                    }

                    if (ValidateGPRSChipNumbers())
                    {
                        if (Session[enumSessions.InstallerCompanyID.ToString()] == null)
                            Response.Redirect("SelectInstaller.aspx");
                        else
                            Response.Redirect("Checkout.aspx");
                    }
                }
                else
                {
                    string script = "alertify.alert('" + ltrBasket.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                }
            }
        }
        catch (System.Threading.ThreadAbortException ex)
        {
        }
        
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnCheckout_Click", Convert.ToString(objException.Message),
                Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress,
                false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    #endregion

    #region ValidateGPRSChipNumbers

    bool ValidateGPRSChipNumbers()
    {
        bool isAllValuesValid = true;

        TextBox lblIsGPRSChipEmpty;
        TextBox lblProductType;
        TextBox txtChipNo;
        TextBox txtPostCode;
        TextBox txtSiteName;
        TextBox txtPSTNNo;
        TextBox txtPanelID;
        DropDownList ddlOptions = null;
        Repeater rptrChipNos;
        int prodId = 0, OrderItemDetailId = 0;

        TextBox txtIPAddress;
        TextBox txtMask;
        TextBox txtGateway;
        DropDownList ddlMainIPAddress = null;
        TextBox txtInstallID;
        TextBox txtSerialNo;
        TextBox lblProductCategoryID;

        LinqToSqlDataContext db = new LinqToSqlDataContext();
        if (divDuplicatesAllowed.Visible)
        {
            db.USP_ARCAcceptDuplicateChipNumbers(Convert.ToInt32(Session[enumSessions.OrderId.ToString()]), chkDuplicatesAllowed.Checked);
            Session[enumSessions.HasUserAcceptedDuplicates.ToString()] = chkDuplicatesAllowed.Checked;
        }

        if (divDuplicatePanelIDAllowed.Visible)
        {
            db.USP_ARCAcceptDuplicatePanelID(Convert.ToInt32(Session[enumSessions.OrderId.ToString()]), chkDuplicatePanelIDAllowed.Checked);
            Session[enumSessions.HasUserAcceptedDuplicatePanelID.ToString()] = chkDuplicatePanelIDAllowed.Checked;
        }

      


        List<String> IdentList = new List<String>();
        List<string> lstInstallID = new List<string>();

        foreach (RepeaterItem item in dlProducts.Items)
        {
            lblIsGPRSChipEmpty = (TextBox)item.FindControl("lblIsGPRSChipEmpty");
            lblProductType = (TextBox)item.FindControl("lblProductType");
            prodId = Convert.ToInt32(((TextBox)item.FindControl("lblProductId")).Text);
            RadioButton rdbCSD = item.FindControl("rdbCSD") as RadioButton;
            RadioButton rdbReplenishment = item.FindControl("rdbReplenishment") as RadioButton;
            Label lblProductCode = item.FindControl("lblProductCode") as Label;
            Label lblIsConnectionOnlyEM = item.FindControl("lblIsConnectionOnlyEM") as Label;
            lblProductCategoryID = (TextBox)item.FindControl("lblProductCategoryID");

            if (lblProductType.Text == "Product")
            {
               
                
                
                            
                
                rptrChipNos = (Repeater)item.FindControl("rptrChipNos");
                bool isEMConnectionOnlyProduct = false;
                if (lblIsConnectionOnlyEM != null)
                {
                    Boolean.TryParse(lblIsConnectionOnlyEM.Text, out isEMConnectionOnlyProduct);
                }

                foreach (RepeaterItem chipDtl in rptrChipNos.Items)
                {
                    txtChipNo = (TextBox)chipDtl.FindControl("txtChipNo");
                    txtPostCode = (TextBox)chipDtl.FindControl("txtPostCode");
                    txtSiteName = (TextBox)chipDtl.FindControl("txtSiteName");
                    txtPSTNNo = chipDtl.FindControl("txtPSTNNo") as TextBox;
                    ddlOptions = chipDtl.FindControl("ddlOptions") as DropDownList;
                    txtPanelID = chipDtl.FindControl("txtPanelID") as TextBox;
                    //ord:42
                    ddlMainIPAddress = chipDtl.FindControl("ddlMainIPAddress") as DropDownList;
                    txtIPAddress = chipDtl.FindControl("txtIPAddress") as TextBox;
                    txtMask = chipDtl.FindControl("txtMask") as TextBox;
                    txtGateway = chipDtl.FindControl("txtGateway") as TextBox;
                    txtInstallID = (TextBox)chipDtl.FindControl("txtInstallID");
                    txtSerialNo = (TextBox)chipDtl.FindControl("txtTCDSerialNo");

                    bool isEmizonProduct = false;
                    HiddenField hdnIsEmizonProduct = chipDtl.FindControl("hdnIsEmizonProduct") as HiddenField;
                    Boolean.TryParse(hdnIsEmizonProduct.Value, out isEmizonProduct);

                    bool sitenameEnabled = false;//option only available for Emizon products
                    HiddenField hdnSitenameEnabled = chipDtl.FindControl("hdnSitenameEnabled") as HiddenField;
                    Boolean.TryParse(hdnSitenameEnabled.Value, out sitenameEnabled);

                    bool blnInstallID_Flag = false;
                    HiddenField hdnInstallIDFlag = chipDtl.FindControl("hdnInstallIDFlag") as HiddenField;
                    bool.TryParse(hdnInstallIDFlag.Value, out blnInstallID_Flag);


                    bool blnconnectionOnly = false;
                    HiddenField hdnConnectionOnly = chipDtl.FindControl("hdnConnectionOnly") as HiddenField;
                    bool.TryParse(hdnConnectionOnly.Value, out blnconnectionOnly);


                    if (blnInstallID_Flag && //(rdbReplenishment.Checked == false) && 
                        txtInstallID.Text == "")
                    {
                        txtInstallID.BackColor = System.Drawing.Color.Yellow;
                        string script = "alertify.alert('" + ltrInstallIDMsg.Text + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        return false;
                    }

                    if (blnInstallID_Flag && //(rdbReplenishment.Checked == false) && 
                        lstInstallID.Contains(txtInstallID.Text))
                    {
                        txtInstallID.BackColor = System.Drawing.Color.Yellow;
                        string script = "alertify.alert('" + ltrDuplicateInstallIDMsg.Text + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        return false;
                    }

                    if (blnInstallID_Flag)
                    {
                        lstInstallID.Add(txtInstallID.Text);
                    }

                    if (ddlMainIPAddress.SelectedItem.Text == "Static")
                    {
                        if (!String.IsNullOrEmpty(txtIPAddress.Text.Trim()))
                        {
                            string[] ipMasks = txtIPAddress.Text.Trim().Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                            if (ipMasks.Length != 4)
                            {
                                string script = "alertify.alert('" + ltrIPAddress.Text + "');";
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                return false;
                            }
                            foreach (var ipMask in ipMasks)
                            {
                                if (ipMask.Length > 3)
                                {
                                    string script = "alertify.alert('" + ltrIPAddress.Text + "');";
                                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                    return false;
                                }
                            }
                        }
                        if (!String.IsNullOrEmpty(txtMask.Text.Trim()))
                        {
                            string[] ipMasks = txtMask.Text.Trim().Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                            if (ipMasks.Length != 4)
                            {
                                string script = "alertify.alert('" + ltrMask.Text + "');";
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                return false;
                            }
                            foreach (var ipMask in ipMasks)
                            {
                                if (ipMask.Length > 3)
                                {
                                    string script = "alertify.alert('" + ltrMask.Text + "');";
                                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                    return false;
                                }
                            }
                        }
                        if (!String.IsNullOrEmpty(txtGateway.Text.Trim()))
                        {
                            string[] ipMasks = txtGateway.Text.Trim().Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                            if (ipMasks.Length != 4)
                            {
                                string script = "alertify.alert('" + ltrGateway.Text + "');";
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                return false;
                            }
                            foreach (var ipMask in ipMasks)
                            {
                                if (ipMask.Length > 3)
                                {
                                    string script = "alertify.alert('" + ltrGateway.Text + "');";
                                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                    return false;
                                }
                            }
                        }
                    }
                    //End:ord-42

                    if (!isEmizonProduct && !String.IsNullOrEmpty(txtPSTNNo.Text.Trim()))
                    {
                        if (!IdentList.Contains(txtPSTNNo.Text.Trim()))
                        {
                            IdentList.Add(txtPSTNNo.Text.Trim());
                        }
                        else
                        {
                            string script = "alertify.alert('" + ltrIdentRpt.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            return false;
                        }
                    }

                    //check for Activation TCD on Emizon items
                    if (isEmizonProduct && !blnconnectionOnly && rdbCSD.Checked && string.IsNullOrEmpty(txtSerialNo.Text))
                    {
                        txtSerialNo.BackColor = System.Drawing.Color.Yellow;
                        string script = "alertify.alert('" + ltrTCDRequiredAlert.Text + "');";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                        return false;
                    }
                    else if (isEmizonProduct && rdbCSD.Checked && !blnconnectionOnly && !string.IsNullOrEmpty(txtSerialNo.Text))
                    {
                        if (!IdentList.Contains(txtPSTNNo.Text.Trim()))
                        {
                            IdentList.Add(txtPSTNNo.Text.Trim());
                        }
                        else
                        {
                            txtSerialNo.BackColor = System.Drawing.Color.Yellow;
                            string script = "alertify.alert('" + ltrTCDDuplicate.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            return false;
                        }
                    }

                    Int32 selectedOptionId = String.IsNullOrEmpty(ddlOptions.SelectedValue) == true ? 0 : Convert.ToInt32(ddlOptions.SelectedValue);
                    OrderItemDetailId = Convert.ToInt32(((HiddenField)chipDtl.FindControl("hdnOrderItemDetailId")).Value);

              
                    if (!isEmizonProduct && !Convert.ToBoolean(lblIsGPRSChipEmpty.Text) ||
                        (!isEmizonProduct && rdbReplenishment.Checked && txtChipNo.Text == "0000")) /* Chip Number can not be empty and should be Emizon (TCD_Flag)*/
                    {
                        if (txtPostCode.Text.Trim() != "" && (txtPostCode.Text.Trim().Length < 2 || txtPostCode.Text.Trim().Length > 10))
                        {
                            txtPostCode.BackColor = System.Drawing.Color.Yellow;
                            string script = "alertify.alert('" + ltrPostcode.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            isAllValuesValid = false;
                        }
                        if ((rdbReplenishment.Checked == false) && (txtChipNo.Text.Trim().Length < 4 || txtChipNo.Text.Trim().Length > 6))
                        {
                            
                                txtChipNo.BackColor = System.Drawing.Color.Yellow;
                                string script = "alertify.alert('" + ltrChpNoInvld.Text + "');";
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                isAllValuesValid = false;
                            
                        }

                        if (rdbCSD.Checked == true && txtPSTNNo.Text.Trim() == String.Empty)
                        {
                            txtPSTNNo.BackColor = System.Drawing.Color.Yellow;
                            string script = "alertify.alert('" + ltrIdentCSD.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            isAllValuesValid = false;
                        }

                        if (sitenameEnabled && String.IsNullOrEmpty(txtSiteName.Text.Trim()))
                        {
                            if (hdnSafelinkbyIPSec.Value.ToUpper() == "FALSE") // no need for sitename for IPSEC ARC's as SMS is not used
                            {
                                txtSiteName.BackColor = System.Drawing.Color.Yellow;
                                string script = "alertify.alert('" + ltrSiteName.Text + "');";
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                isAllValuesValid = false;
                            }
                        }

                        //else
                        //{
                        if (Session[enumSessions.IsARC_AllowReturns.ToString()] != null 
                            && !Convert.ToBoolean(Session[enumSessions.IsARC_AllowReturns.ToString()].ToString()))
                        {
                            //if (!isEmizonProduct){
                            var chipNoList = db.USP_IsGPRSChipNoExists(txtChipNo.Text.Trim(), OrderItemDetailId).ToList();
                            if ((rdbReplenishment.Checked == false)
                                && chipNoList != null && chipNoList.Count > 0)
                            {
                                chkDuplicatesAllowed.Checked = false;
                                divDuplicatesAllowed.Visible = false;
                                txtChipNo.BackColor = System.Drawing.Color.Yellow;
                                string script = "alertify.alert('" + ltrChpNoVal.Text + "');";
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                isAllValuesValid = false;
                            }
                            //}
                            else
                            {
                                db.USP_UpdateOrderItemDetailsToBasket(OrderItemDetailId, isEmizonProduct ? txtInstallID.Text : txtChipNo.Text, txtPostCode.Text.Trim(),
                                    Session[enumSessions.User_Name.ToString()].ToString(), txtPSTNNo.Text.Trim(), txtSiteName.Text,
                                    selectedOptionId, txtPanelID.Text, txtIPAddress.Text, txtMask.Text, txtGateway.Text, txtInstallID.Text, txtSerialNo.Text);
                            }
                        }
                        else
                        {
                            db.USP_UpdateOrderItemDetailsToBasket(OrderItemDetailId, isEmizonProduct ? txtInstallID.Text : txtChipNo.Text, txtPostCode.Text.Trim(),
                                Session[enumSessions.User_Name.ToString()].ToString(), txtPSTNNo.Text.Trim(), txtSiteName.Text,
                                selectedOptionId, txtPanelID.Text, txtIPAddress.Text, txtMask.Text, txtGateway.Text, txtInstallID.Text, txtSerialNo.Text);

                            if (!isEmizonProduct && rdbReplenishment.Checked == false && txtChipNo.Text.Trim() != "" && !chkDuplicatesAllowed.Checked)
                            {
                                var isValidChipNos = db.USP_IsGPRSChipNoExists(txtChipNo.Text.Trim(), OrderItemDetailId).ToList();
                                if (isValidChipNos != null && isValidChipNos.Count > 0)
                                {
                                    divDuplicatesAllowed.Visible = true;
                                    txtChipNo.BackColor = System.Drawing.Color.Yellow;
                                    isAllValuesValid = false;
                                }
                            }
                            //check if it ia Risco Product
                            if (txtPanelID.Text.Trim() != "" && !chkDuplicatePanelIDAllowed.Checked)
                            {
                                var isValidPanelID = db.USP_IsPanelIDExists(txtPanelID.Text.Trim(), OrderItemDetailId).ToList();
                                if (isValidPanelID != null && isValidPanelID.Count > 0)
                                {
                                    divDuplicatePanelIDAllowed.Visible = true;
                                    txtPanelID.BackColor = System.Drawing.Color.Yellow;
                                    isAllValuesValid = false;
                                }
                            }
                        }
                        //}
                    }
                    else /* Chip Number may be or may not be empty -- (User can enter the chip number) */
                    {
                        if (txtPostCode.Text.Trim() != "" && (txtPostCode.Text.Trim().Length < 2 || txtPostCode.Text.Trim().Length > 10))
                        {
                            txtPostCode.BackColor = System.Drawing.Color.Yellow;
                            string script = "alertify.alert('" + ltrPostcodeVal.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            isAllValuesValid = false;
                        }
                        if (!isEmizonProduct /*Non Emizon only*/ && rdbCSD.Checked == true && txtPSTNNo.Text.Trim() == String.Empty)
                        {
                            txtPSTNNo.BackColor = System.Drawing.Color.Yellow;
                            string script = "alertify.alert('" + ltrIdentMand.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            isAllValuesValid = false;
                        }

                        if (!isEmizonProduct && (rdbReplenishment.Checked == false) && (txtChipNo.Text.Trim() == "") && (txtChipNo.Text.Trim().Length < 4 || txtChipNo.Text.Trim().Length > 6))
                        {
                            txtChipNo.BackColor = System.Drawing.Color.Yellow;
                            string script = "alertify.alert('" + ltrChpNoInvld.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            isAllValuesValid = false;
                        }
                        else
                        {
                            if (!isEmizonProduct && Session[enumSessions.IsARC_AllowReturns.ToString()] != null &&
                                !Convert.ToBoolean(Session[enumSessions.IsARC_AllowReturns.ToString()].ToString()))
                            {
                                if (txtChipNo.Text.Trim() != "")
                                {
                                    var isValidChipNos = db.USP_IsGPRSChipNoExists(txtChipNo.Text.Trim(), OrderItemDetailId).ToList();
                                    if ((rdbReplenishment.Checked == false) && isValidChipNos != null && isValidChipNos.Count > 0)
                                    {
                                        txtChipNo.BackColor = System.Drawing.Color.Yellow;
                                        string script = "alertify.alert('" + ltrChpNoVal.Text + "');";
                                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                        isAllValuesValid = false;
                                    }
                                }
                                else
                                {
                                    db.USP_UpdateOrderItemDetailsToBasket(OrderItemDetailId, isEmizonProduct ? txtInstallID.Text : txtChipNo.Text, txtPostCode.Text.Trim(),
                                        Session[enumSessions.User_Name.ToString()].ToString(), txtPSTNNo.Text.Trim(), txtSiteName.Text,
                                        selectedOptionId, txtPanelID.Text, txtIPAddress.Text, txtMask.Text, txtGateway.Text, txtInstallID.Text, txtSerialNo.Text);
                                }
                            }
                            else
                            {
                                db.USP_UpdateOrderItemDetailsToBasket(OrderItemDetailId, isEmizonProduct ? txtInstallID.Text : txtChipNo.Text, txtPostCode.Text.Trim(),
                                    Session[enumSessions.User_Name.ToString()].ToString(), txtPSTNNo.Text.Trim(), txtSiteName.Text,
                                    selectedOptionId, txtPanelID.Text, txtIPAddress.Text, txtMask.Text, txtGateway.Text, txtInstallID.Text, txtSerialNo.Text);
                                if (txtChipNo.Text.Trim() != "" && !chkDuplicatesAllowed.Checked)
                                {
                                    var isValidChipNos = db.USP_IsGPRSChipNoExistsInOrder(txtChipNo.Text.Trim(), OrderItemDetailId,
                                        Convert.ToInt32(Session[enumSessions.OrderId.ToString()].ToString())).ToList();
                                    if (isValidChipNos != null && isValidChipNos.Count > 0)
                                    {
                                        divDuplicatesAllowed.Visible = true;
                                        return false;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }//foreach

        db.Dispose();
        return isAllValuesValid;
    }

    #endregion



    #region rptrChipNos_ItemBound

    protected void rptrChipNos_ItemBound(object sender, RepeaterItemEventArgs args)
    {
        LinqToSqlDataContext db = null;
        try
        {

            if (args.Item.ItemType == ListItemType.Item || args.Item.ItemType == ListItemType.AlternatingItem)
            {

                Repeater innerRepeater = (Repeater)sender;
                RepeaterItem outerItem = (RepeaterItem)innerRepeater.NamingContainer;
                Label rdbCSD = outerItem.FindControl("lblIsCSDProd") as Label;
                RadioButton rdbCSDAct = outerItem.FindControl("rdbCSD") as RadioButton;
                Label lblOptionsCount = outerItem.FindControl("lblProductOptionsCount") as Label;
                Label lblProductCode = outerItem.FindControl("lblProductCode") as Label; //ORD-42
                TextBox lblProductID = outerItem.FindControl("lblProductId") as TextBox;
                HtmlControl tdlblIdent = innerRepeater.Controls[0].Controls[0].FindControl("tdlblIdent") as HtmlControl;
                HtmlControl tdtxtPSTNNo = args.Item.FindControl("tdtxtPSTNNo") as HtmlControl;

                if (tdtxtPSTNNo != null && tdtxtPSTNNo.Visible == true)
                {
                    tdtxtPSTNNo.Visible = true;
                    tdlblIdent.Visible = true;
                }
                else
                {
                    tdlblIdent.Visible = false;
                }

                HtmlControl tdInstallID = args.Item.FindControl("tdInstallID") as HtmlControl;
                HtmlControl thInstallID = innerRepeater.Controls[0].Controls[0].FindControl("thInstallID") as HtmlControl;

                if (tdInstallID != null && tdInstallID.Visible == true)
                {
                    tdInstallID.Visible = true;
                    thInstallID.Visible = true;
                }
                else
                {
                    tdInstallID.Visible = false;
                }

                HtmlControl tdSerialNo = args.Item.FindControl("tdTCDSerialNo") as HtmlControl;
                HtmlControl thSerialNo = innerRepeater.Controls[0].Controls[0].FindControl("thTCDSerialNo") as HtmlControl;

                if (tdSerialNo != null && tdSerialNo.Visible == true)
                {
                    tdSerialNo.Visible = true;
                    thSerialNo.Visible = true;
                }
                else
                {
                    tdSerialNo.Visible = false;
                }

                HtmlControl tdChipNo = args.Item.FindControl("tdChipNo") as HtmlControl;
                HtmlControl thChipNo = innerRepeater.Controls[0].Controls[0].FindControl("thChipNo") as HtmlControl;
                if (tdChipNo != null && tdChipNo.Visible == true)
                {
                    thChipNo.Visible = true;
                    thChipNo.Visible = true;
                }
                else
                {
                    tdChipNo.Visible = false;
                    thChipNo.Visible = false;
                }


                HtmlControl tdSiteName = args.Item.FindControl("tdSiteName") as HtmlControl;
                HtmlControl thSiteName = innerRepeater.Controls[0].Controls[0].FindControl("thSiteName") as HtmlControl;
                if (tdSiteName != null && tdSiteName.Visible == true)
                {
                    thSiteName.Visible = true;
                }
                else
                {
                    thSiteName.Visible = false;
                }


                db = new LinqToSqlDataContext();
                //check if it a RISCO product
                int IsRiscoProduct = db.USP_IsRiscoProduct(Convert.ToInt32(lblProductID.Text));

                if (IsRiscoProduct > 0)
                {
                    //display the popup box
                    string script = "alertify.alert('" + ltdPanelIDMand.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);

                    divPanelIDNotEntered.Visible = true; //enable the label to be true

                    //    txtPanelID.BackColor = System.Drawing.Color.Yellow;
                    HtmlControl tdlblPanelID = innerRepeater.Controls[0].Controls[0].FindControl("thPanelID") as HtmlControl; //args.Item.FindControl("tdlblPanelID") as HtmlControl;
                    if (tdlblPanelID != null)
                        tdlblPanelID.Visible = true;

                    HtmlControl tdtxtPanelID = args.Item.FindControl("tdtxtPanelID") as HtmlControl;
                    if (tdtxtPanelID != null)
                        tdtxtPanelID.Visible = true;

                    HtmlControl tdlblWarnForPanelID = args.Item.FindControl("tdlblWarnForPanelID") as HtmlControl;
                    if (tdlblWarnForPanelID != null)
                        tdlblWarnForPanelID.Visible = true;
                }

                // //ord-42
                HtmlControl tdlblMainIPAddress = args.Item.FindControl("tdlblMainIPAddress") as HtmlControl;
                HtmlControl tdMainIPAddress = args.Item.FindControl("tdMainIPAddress") as HtmlControl;
                HtmlControl trStaticIPDetailsHeader = args.Item.FindControl("trStaticIPDetailsHeader") as HtmlControl;
                HtmlControl trStaticIPDetails = args.Item.FindControl("trStaticIPDetails") as HtmlControl;
                TextBox txtIPAddress = args.Item.FindControl("txtIPAddress") as TextBox;
                TextBox txtMask = args.Item.FindControl("txtMask") as TextBox;
                TextBox txtGateway = args.Item.FindControl("txtGateway") as TextBox;
                DropDownList ddlMainIPAddress = args.Item.FindControl("ddlMainIPAddress") as DropDownList;
                if (ConfigurationManager.AppSettings["LANProducts"].Contains(lblProductCode.Text))
                {
                    if (tdlblMainIPAddress != null)
                    {
                        tdlblMainIPAddress.Visible = true;
                    }
                    if (tdMainIPAddress != null)
                    {
                        tdMainIPAddress.Visible = true;
                    }

                }
                else
                {
                    if (tdlblMainIPAddress != null)
                    {
                        tdlblMainIPAddress.Visible = false;
                    }
                    if (tdMainIPAddress != null)
                    {
                        tdMainIPAddress.Visible = false;
                    }
                }
                //if there is already stored IP Address then display it
                if (txtIPAddress != null && txtMask != null && txtGateway != null)
                {
                    if ((!String.IsNullOrEmpty(txtIPAddress.Text)) || (!String.IsNullOrEmpty(txtMask.Text)) || (!String.IsNullOrEmpty(txtGateway.Text)))
                    {
                        trStaticIPDetailsHeader.Visible = true;
                        trStaticIPDetails.Visible = true;
                        ddlMainIPAddress.SelectedItem.Text = "Static";
                    }
                }


                if (lblOptionsCount != null && lblOptionsCount.Text == "0")
                {

                    HtmlControl tdOptions = innerRepeater.Controls[0].Controls[0].FindControl("thOptions") as HtmlControl;
                    if (tdOptions != null)
                        tdOptions.Visible = false;


                    HtmlControl tdOptionId = args.Item.FindControl("tdOptionId") as HtmlControl;
                    if (tdOptionId != null)
                        tdOptionId.Visible = false;
                }


                TextBox lblProductId = outerItem.FindControl("lblProductId") as TextBox;
                DropDownList ddlOptions = args.Item.FindControl("ddlOptions") as DropDownList;

                if (ddlOptions != null && lblOptionsCount != null && lblOptionsCount.Text != "0")
                {
                    ddlOptions.DataSource = ProductBAL.GetProductOption(Convert.ToInt32(lblProductId.Text));
                    ddlOptions.DataTextField = "OptionName";
                    ddlOptions.DataValueField = "OptID";
                    ddlOptions.DataBind();
                    try
                    {
                        db = new LinqToSqlDataContext();
                        var ArcOptionId = (from ac in db.ARCs
                                           where ac.ARCId == Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString())
                                           select new
                                           {
                                               ac.ProductOptionId

                                           }).FirstOrDefault();
                        if (ArcOptionId != null && ArcOptionId.ProductOptionId.HasValue && ArcOptionId.ProductOptionId.Value != 0)
                        {
                            ddlOptions.SelectedValue = ArcOptionId.ProductOptionId.ToString();
                            if (hdnLocktoDefaultOption.Value == "True")
                            {
                                ddlOptions.Enabled = false;
                            }
                        }
                        db.Dispose();
                    }
                    catch (Exception objException)
                    {

                        db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                        db.USP_SaveErrorDetails(Request.Url.ToString(), "rptrChipNos_ItemBound", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
                    }
                }

                Label lblOptionId = args.Item.FindControl("lblOptionId") as Label;
                if (lblOptionId != null && !String.IsNullOrEmpty(lblOptionId.Text))
                    ddlOptions.SelectedValue = lblOptionId.Text;
            }


        }
        catch (Exception objException)
        {

            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "rptrChipNos_ItemBound", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }


    }

    #endregion


    #region lbClearBasket_Click

    protected void lbClearBasket_Click(object sender, EventArgs e)
    {
        LinqToSqlDataContext db = new LinqToSqlDataContext();
        var data = db.OrderItems.Where(items => items.OrderId == Convert.ToInt32(Session[enumSessions.OrderId.ToString()]));
        if (data.Any(x => x != null))
        {
            foreach (var item in data)
            {
                db.USP_RemoveProductFromBasket(Convert.ToInt32(item.OrderItemId), Session[enumSessions.User_Name.ToString()].ToString());
            }
            LoadBasketProducts();
            Session[enumSessions.InstallerCompanyID.ToString()] = null;
        }

    }

    #endregion


    /// <summary>
    /// InstallID can be duplicate across ARC's so only retrun ARC specific data to validate
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    [WebMethod]
    public static string GetARCActiveInstallIDList(string id)
    {
        EmizonService service = new EmizonService();
        Newtonsoft.Json.JsonSerializer jsr = new Newtonsoft.Json.JsonSerializer();
        System.IO.StringWriter sw = new System.IO.StringWriter();
        Newtonsoft.Json.JsonTextWriter jtw = new Newtonsoft.Json.JsonTextWriter(sw);
        jsr.Serialize(jtw, service.GetARCInstallIDList(Convert.ToInt32(id)).Select(x => x.EM_InstallID).ToArray());
        string jsArrayJSON = sw.ToString();
        return jsArrayJSON;
    }


     [WebMethod]
    public static string GetReplenishmentStock(string arcid)
    {
        string data = "";
        try
        {
            int ARCId = 0;
            int.TryParse(arcid, out ARCId);
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                //var replenishmentStock = (
                //                          from i in db.vw_IdentLists
                //                          select new { IdentCategoryID = i.ICCID + i.CategoryID }
                //                          ).ToList();

                var replenishmentStock = db.vw_IdentLists.Where(a => a.ARCID == ARCId).Select(x => x.ICCID).ToArray();
                Newtonsoft.Json.JsonSerializer jsr = new Newtonsoft.Json.JsonSerializer();
                System.IO.StringWriter sw = new System.IO.StringWriter();
                Newtonsoft.Json.JsonTextWriter jtw = new Newtonsoft.Json.JsonTextWriter(sw);
                jsr.Serialize(jtw, replenishmentStock);
                data = sw.ToString();
            }
        }
        catch (Exception objException)
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {

                db.USP_SaveErrorDetails("", "GetReplenishmentDataWithARCID", Convert.ToString(objException.Message),
                    Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "",
                    HttpContext.Current.Request.UserHostAddress, false, "");
            }
        }
        return data;
    }


    [WebMethod]
    public static string GetReplenishmentStock()
    {
        string data = "";
        try
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                var replenishmentStock = db.vw_IdentLists.Select(x => x.ICCID).ToArray();
                Newtonsoft.Json.JsonSerializer jsr = new Newtonsoft.Json.JsonSerializer();
                System.IO.StringWriter sw = new System.IO.StringWriter();
                Newtonsoft.Json.JsonTextWriter jtw = new Newtonsoft.Json.JsonTextWriter(sw);
                jsr.Serialize(jtw, replenishmentStock);
                data = sw.ToString();
            }
        }
        catch (Exception objException)
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {

                db.USP_SaveErrorDetails("", "GetReplenishmentData", Convert.ToString(objException.Message),
                    Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "",
                    HttpContext.Current.Request.UserHostAddress, false, "");
            }
        }
        return data;
    }


    protected void rdbCSD_CheckedChanged(object sender, EventArgs e)
    {
        RadioButton rdbCSD = sender as RadioButton;
        RepeaterItem item = (rdbCSD.NamingContainer) as RepeaterItem;

        RadioButton rdbReplenishment = item.FindControl("rdbReplenishment") as RadioButton;
        Repeater rptrChipNos = item.FindControl("rptrChipNos") as Repeater;

        bool rdbActivationSelected = false;
        rdbActivationSelected = (item.FindControl("rdbCSD") as RadioButton).Checked;

        foreach (RepeaterItem itemList in rptrChipNos.Items)
        {
            Control headerTemplate = rptrChipNos.Controls[0].Controls[0];

            bool installID_Flag = false;
            HiddenField hdnInstallIDFlag = itemList.FindControl("hdnInstallIDFlag") as HiddenField;
            Boolean.TryParse(hdnInstallIDFlag.Value, out installID_Flag);

            bool isEmizonProduct = false;
            HiddenField hdnIsEmizonProduct = itemList.FindControl("hdnIsEmizonProduct") as HiddenField;
            Boolean.TryParse(hdnIsEmizonProduct.Value, out isEmizonProduct);

            if (rdbActivationSelected == true)
            {
                rdbReplenishment.Checked = false;

                if (installID_Flag)
                {
                    HtmlControl tdInstallID = itemList.FindControl("tdInstallID") as HtmlControl;
                    HtmlControl thInstallID = headerTemplate.FindControl("thInstallID") as HtmlControl;
                    if (tdInstallID != null)
                    {
                        tdInstallID.Visible = true;
                        thInstallID.Visible = true;
                    }
                }

                if (isEmizonProduct)
                {
                    HtmlControl tdSerialNo = itemList.FindControl("tdTCDSerialNo") as HtmlControl;
                    HtmlControl thSerialNo = headerTemplate.FindControl("thTCDSerialNo") as HtmlControl;
                    if (tdSerialNo != null)
                    {
                        tdSerialNo.Visible = true;
                        thSerialNo.Visible = true;
                    }

                    TextBox txtTCDSerialNo = (TextBox)itemList.FindControl("txtTCDSerialNo");
                    if (txtTCDSerialNo != null && (txtTCDSerialNo.Text == string.Empty))
                    {
                        txtTCDSerialNo.Visible = true;
                    }
                }
                else if (!isEmizonProduct)
                {
                    HtmlControl tdlblIdent = headerTemplate.FindControl("tdlblIdent") as HtmlControl;
                    tdlblIdent.Visible = true;

                    HtmlControl tdtxtPSTNNo = itemList.FindControl("tdtxtPSTNNo") as HtmlControl;
                    if (tdtxtPSTNNo != null)
                    {
                        tdtxtPSTNNo.Visible = true;
                    }

                    TextBox txtTCDSerialNo = (TextBox)itemList.FindControl("txtTCDSerialNo");
                    if (txtTCDSerialNo != null && (txtTCDSerialNo.Text == string.Empty))
                    {
                        txtTCDSerialNo.Visible = true;
                    }
                }

            }
            else //Replenishment Flag is set. Hide InstallID / TCD SerialNo / chipNo for CSL product
            {
                HtmlControl tdlblIdent = headerTemplate.FindControl("tdlblIdent") as HtmlControl;
                tdlblIdent.Visible = false;

                HtmlControl tdtxtPSTNNo = itemList.FindControl("tdtxtPSTNNo") as HtmlControl;
                if (tdtxtPSTNNo != null)
                    tdtxtPSTNNo.Visible = false;


                // I think we need installID as we will be pushing to fetch an EMNo
                /*
                if (installID_Flag) //InstallID is allowed but we dont need it on Replenishment Stock
                {
                    HtmlControl tdInstallID = itemList.FindControl("tdInstallID") as HtmlControl;
                    HtmlControl thInstallID = headerTemplate.FindControl("thInstallID") as HtmlControl;
                    if (tdInstallID != null)
                    {
                        tdInstallID.Visible = false;
                        thInstallID.Visible = false;
                    }
                }*/

                if (isEmizonProduct) //We do not need TCD displayed on REP check
                {
                    HtmlControl tdSerialNo = itemList.FindControl("tdTCDSerialNo") as HtmlControl;
                    HtmlControl thSerialNo = headerTemplate.FindControl("thTCDSerialNo") as HtmlControl;
                    if (tdSerialNo != null)
                    {
                        tdSerialNo.Visible = false;
                        thSerialNo.Visible = false;
                    }
                }
            }
        }
    }


    protected void rdbReplenishment_CheckedChanged(object sender, EventArgs e)
    {
        TextBox lblProductType;
        TextBox txtChipNo;
        TextBox txtTCDSerialNo;
        Repeater rptrChipNos;
        foreach (RepeaterItem item in dlProducts.Items)
        {
            lblProductType = (TextBox)item.FindControl("lblProductType");
            RadioButton rdbReplenishment = item.FindControl("rdbReplenishment") as RadioButton;
            if (lblProductType.Text == "Product")
            {
                rptrChipNos = (Repeater)item.FindControl("rptrChipNos");
                foreach (RepeaterItem chipDtl in rptrChipNos.Items)
                {
                    txtChipNo = (TextBox)chipDtl.FindControl("txtChipNo");
                    if (txtChipNo != null && (rdbReplenishment.Checked == true) && (txtChipNo.Text == string.Empty))
                    {
                        txtChipNo.Text = "0000";
                    }

                    txtTCDSerialNo = (TextBox)chipDtl.FindControl("txtTCDSerialNo");
                    if (txtTCDSerialNo != null && (rdbReplenishment.Checked == true))
                    {
                        txtTCDSerialNo.Visible = false;
                        txtTCDSerialNo.Text = ""; //erase any value as its replenishment stock
                    }
                }
            }

            RadioButton rdbCSD = item.FindControl("rdbCSD") as RadioButton;
            if (rdbReplenishment.Checked == true)
            {
                rdbCSD.Checked = false;
                rdbCSD_CheckedChanged(sender, e);
            }
        }
    }


    protected void ddlMainIPAddress_SelectedIndexChanged(object sender, EventArgs e)
    {
        DropDownList ddlMainIPAddress = (DropDownList)sender;
        int RepeaterItemIndex = ((RepeaterItem)ddlMainIPAddress.NamingContainer).ItemIndex;

        RepeaterItem ri = ddlMainIPAddress.NamingContainer as RepeaterItem;
        HtmlControl trStaticIPDetailsHeader = ri.FindControl("trStaticIPDetailsHeader") as HtmlControl;
        HtmlControl trStaticIPDetails = ri.FindControl("trStaticIPDetails") as HtmlControl;

        if (ddlMainIPAddress.SelectedItem.Text == "Static")
        {

            if (trStaticIPDetailsHeader != null)
            {
                trStaticIPDetailsHeader.Visible = true;
            }

            if (trStaticIPDetails != null)
            {
                trStaticIPDetails.Visible = true;
            }


        }
        else
        {
            if (trStaticIPDetailsHeader != null)
            {
                trStaticIPDetailsHeader.Visible = false;
            }

            if (trStaticIPDetails != null)
            {
                trStaticIPDetails.Visible = false;
            }
        }
    }

}
