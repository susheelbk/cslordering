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
using System.Configuration;
//using System.Net.Mail;
using System.Text;
using iTextSharp.text;
using System.Web.Caching;
using iTextSharp.text.pdf;
using iTextSharp.text.html;
using iTextSharp.text.html.simpleparser;
using System.Data;
using System.Web.UI.HtmlControls;
using MSMQSendEmailToQueueLibrary;

public partial class Checkout : System.Web.UI.Page
{
    decimal? VATRate = 0.0m;
    string smtphost = String.Empty;
    string mailFrom = String.Empty;
    string mailCC = String.Empty;
    string mailTO = String.Empty;
    bool instadd_differs = false;


    protected void Page_Load(object sender, EventArgs e)
    {

        try
        {
            if (Session[enumSessions.User_Id.ToString()] == null || Session[enumSessions.OrderId.ToString()] == null)
                Response.Redirect("Login.aspx");

            if (Session[enumSessions.InstallerCompanyID.ToString()] == null)
                Response.Redirect("Categories.aspx");

            ApplicationDTO appdto = null;
            //check values in cache,if null,then set them again else retrieve.
            if (!(VATRate > 0.0m))
            {
                AppSettings appsett = new AppSettings();
                appdto = appsett.GetAppValues();
                VATRate = appdto.VATRate;
            }
            else
                VATRate = (Decimal)HttpRuntime.Cache["VATRate"];

            if (string.IsNullOrEmpty((string)HttpRuntime.Cache["smtphost"]))
            {
                AppSettings appsett = new AppSettings();
                appdto = appsett.GetAppValues();
                smtphost = appdto.smtphost;
            }
            else
                smtphost = (string)HttpRuntime.Cache["smtphost"];


            if (string.IsNullOrEmpty((string)HttpRuntime.Cache["OrdersEmailFrom"]))
            {
                AppSettings appsett = new AppSettings();
                appdto = appsett.GetAppValues();
                mailFrom = appdto.mailFrom;
            }
            else
                mailFrom = (string)HttpRuntime.Cache["OrdersEmailFrom"];


            if (string.IsNullOrEmpty((string)HttpRuntime.Cache["EmailCC"]))
            {
                AppSettings appsett = new AppSettings();
                appdto = appsett.GetAppValues();
                mailCC = appdto.mailCC;
            }
            else
                mailCC = (string)HttpRuntime.Cache["EmailCC"];


            if (string.IsNullOrEmpty((string)HttpRuntime.Cache["LogisticsEmail"]))
            {
                AppSettings appsett = new AppSettings();
                appdto = appsett.GetAppValues();
                mailTO = appdto.mailTO;
            }
            else
                mailTO = (string)HttpRuntime.Cache["LogisticsEmail"];

            if (!IsPostBack)
            {
                lblCSLOrderNo.Text = "CSL" + Session[enumSessions.OrderNumber.ToString()].ToString();
                lblOrderDate.Text = DateTime.Now.ToString("dd-MMM-yyyy").ToUpper();

                LoadInstallerAddress();
                LoadCountries();
                LoadBasketProducts();
                LoadDeliveryTypes();
                LoadInstaller();
                ddlDeliveryTypes_SelectedIndexChanged(null, null);
                LoadARCDeliveryaddresses();
                BindARCBranchesDropdown();
                LoadTermsAndConditionsLinks();

            }
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

    }

    private void LoadTermsAndConditionsLinks()
    {
        string val = string.Empty;
        
        try
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
               USP_GetTermsAndConditionsResult result = db.USP_GetTermsAndConditions(Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString())).FirstOrDefault();
               if (result == null)
               {
                   return;
               }
               else {
                   lnkTerms.NavigateUrl = result.NavigateURL;
               }
            }
        }
        catch (Exception objException)
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "LoadARCEmailCC", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
    }

    private string LoadARCEmailCC()
    {
        string val = string.Empty;
        LinqToSqlDataContext db = new LinqToSqlDataContext();
        try
        {
            val = db.USP_GetARCEmailCC(Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString())).FirstOrDefault().ARC_CCEMAIL;
        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LoadARCEmailCC", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            db.Dispose();
        }
        finally
        {
            db.Dispose();
        }
        return val;
    }

    private void LoadInstaller()
    {
        try
        {
            if (Session[enumSessions.InstallerCompanyID.ToString()] != null && Session[enumSessions.OrderId.ToString()] != null)
            {
                LinqToSqlDataContext dataCtxt = new LinqToSqlDataContext();
                dataCtxt.USP_SaveInstallerDetailsInOrder(Session[enumSessions.InstallerCompanyID.ToString()].ToString(), Convert.ToInt32(Session[enumSessions.OrderId.ToString()]));
                dataCtxt.Dispose();
            }
            else
            {
                Response.Redirect("SelectInstaller.aspx");
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
            db.USP_SaveErrorDetails(Request.Url.ToString(), ((System.Reflection.MemberInfo)(objException.TargetSite)).Name, Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    void LoadInstallerAddress()
    {
        rdoInstallerAddress.Text = InstallerBAL.GetAddressHTML2Line(new Guid(Session[enumSessions.InstallerCompanyID.ToString()].ToString()));

    }

    void LoadCountries()
    {
        ddlCountry.DataSource = InstallerBAL.GetCountries();
        ddlCountry.DataValueField = "CountryId";
        ddlCountry.DataTextField = "CountryName";
        ddlCountry.DataBind();
        ddlCountry.SelectedIndex = 0;

        // ddlCountry.SelectedItem.Text = "UK"; //ddlCountry.Items.IndexOf(ddlCountry.Items.FindByText("UK"));
        ddlInstCountry.DataSource = InstallerBAL.GetCountries();
        ddlInstCountry.DataValueField = "CountryId";
        ddlInstCountry.DataTextField = "CountryName";
        ddlInstCountry.DataBind();
        ddlCountry.SelectedIndex = 0;
        //ddlInstCountry.SelectedItem.Text = "UK";//ddlInstCountry.Items.IndexOf(ddlInstCountry.Items.FindByText("UK"));
    }

    void LoadBasketProducts()
    {

        LinqToSqlDataContext db = new LinqToSqlDataContext();

        var BasketProducts = db.USP_GetBasketProductsOnCheckOut(Convert.ToInt32(Session[enumSessions.OrderId.ToString()].ToString())).ToList();

        //check the product code and change it to pyronix/risco as per code
        //foreach (var item in BasketProducts)
        //{
        //    string name = (from dcc in db.DCCCompanies
        //                   where dcc.Productcode.Contains(item.ProductCode)
        //                   select dcc.company_name).SingleOrDefault();
        //    if (name != null)
        //    {
        //        item.ProductCode = item.ProductCode.Replace(item.ProductCode.Substring(item.ProductCode.Length - 3), "-" + name);
        //    }

        //}

        dlProducts.DataSource = BasketProducts;

        dlProducts.DataBind();

        Boolean? isExcludeTerms = db.ARCs.Where(a => a.ARCId == Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString())).Select(a => a.ExcludeTerms).SingleOrDefault();
        if (isExcludeTerms == false)
        {
            pnlAccepted.Visible = true;
            btnConfirmOrder.OnClientClick = "javascript:return isvalid();";
        }
        db.Dispose();
    }
    void LoadARCDeliveryaddresses()
    {
        LinqToSqlDataContext db = new LinqToSqlDataContext();
        string postcode = txtPreviousPostcode.Text;
        var ARCAddresses = db.GetARCDeliveryAddresses(Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString()), postcode).ToList();
        ddlarcdeliveryaddresses.DataSource = ARCAddresses;
        ddlarcdeliveryaddresses.DataTextField = "Display";
        ddlarcdeliveryaddresses.DataValueField = "AddressID";
        ddlarcdeliveryaddresses.DataBind();
        if (ARCAddresses.Any(x => x != null))
        {

            ddlarcdeliveryaddresses.Items.Insert(0, new System.Web.UI.WebControls.ListItem("---------------------Select--------------------", "0"));
            if (ARCAddresses.Count == 1)
            {
                ddlarcdeliveryaddresses.SelectedIndex = 1;
            }
        }

        else
        {
            ddlarcdeliveryaddresses.Items.Insert(0, new System.Web.UI.WebControls.ListItem("---------------No Previous Address------------", "0"));

        }

        db.Dispose();
    }
    protected void LoadDeliveryTypes()
    {

        ddlDeliveryTypes.Items.Clear();

        //Calculating order total and other offers to populate delivery options
        OrdersBAL deliveryOptions = new OrdersBAL();
        deliveryOptions.orderId = Convert.ToInt32(Session[enumSessions.OrderId.ToString()].ToString());

        //Set the lowest priced as selected. 
        int i = 0; int selectedIndex = 0;
        decimal leastPriceItem = decimal.MaxValue;


        try
        {

            //List<DeliveryType> shippingOptions = deliveryOptions.GetShippingOptions();
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            List<USP_GetShippingOptionsResult> shippingOptions = new List<USP_GetShippingOptionsResult>();

            shippingOptions = db.USP_GetShippingOptions(Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString()), new Guid(Session[enumSessions.InstallerCompanyID.ToString()].ToString()), Convert.ToInt32(Session[enumSessions.OrderId.ToString()])).ToList();

            foreach (USP_GetShippingOptionsResult delivery in shippingOptions)
            {

                System.Web.UI.WebControls.ListItem item = new System.Web.UI.WebControls.ListItem();
                System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-GB", false);
                item.Text = delivery.DeliveryShortDesc + " - " + delivery.DeliveryPrice.Value.ToString("c");
                item.Value = delivery.DeliveryTypeId.ToString();

                if (leastPriceItem != decimal.Zero && delivery.DeliveryPrice < leastPriceItem)
                {
                    leastPriceItem = delivery.DeliveryPrice.Value;
                    ddlDeliveryTypes.ClearSelection();
                    ddlDeliveryTypes.SelectedIndex = i;
                    selectedIndex = i;
                }
                ddlDeliveryTypes.Items.Add(item);
                i++;
            }
            ddlDeliveryTypes.DataBind();
            ddlDeliveryTypes.SelectedIndex = selectedIndex;

            bool? isAncillary = false;
            db.USP_IsAncillaryOnlyOrders(Convert.ToInt32(Session[enumSessions.OrderId.ToString()]), ref isAncillary);
            if (isAncillary.Value == true)
            {
                lblIsAncillary.Visible = true;
            }
            else
            {
                lblIsAncillary.Visible = false;
            }

        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LoadDeliveryTypes", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            db.Dispose();
        }
    }
    public int count = 1;
    protected void ProductsRepeater_ItemBound(object sender, RepeaterItemEventArgs args)
    {
        try
        {

            if (args.Item.ItemType == ListItemType.Item || args.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinqToSqlDataContext db = new LinqToSqlDataContext();
                if (String.IsNullOrEmpty(hidProductCode.Value))
                {
                    hidProductCode.Value = (args.Item.FindControl("lblProductCode") as Label).Text;
                }

                else if (hidProductCode.Value.ToString() != (args.Item.FindControl("lblProductCode") as Label).Text)
                {
                    hidProductCode.Value = (args.Item.FindControl("lblProductCode") as Label).Text;
                    count = 1;
                }

                HtmlControl tdManufacturer = args.Item.FindControl("tdManufacturer") as HtmlControl;
                tdManufacturer.Visible = true;
                //
                string name = (from dcc in db.DCCCompanies
                               where dcc.Productcode.Contains(hidProductCode.Value)
                               select dcc.company_name).SingleOrDefault();
                if (name != null)
                {

                    Label lblManufacturer = args.Item.FindControl("lblManufacturer") as Label;
                    lblManufacturer.Visible = true;
                    lblManufacturer.Text = name;
                }


                if (Session[enumSessions.User_Role.ToString()] != null && Session[enumSessions.User_Role.ToString()].ToString() == enumRoles.ARC_Admin.ToString())
                {
                    Label lblProductPrice = (Label)args.Item.FindControl("lblProductPrice");
                    lblProductPrice.Text = String.Empty; //0.00

                    Label lblProductPriceTotal = (Label)args.Item.FindControl("lblProductPriceTotal");
                    lblProductPriceTotal.Text = String.Empty; //0.00
                }

                Label lblProductCode = (Label)args.Item.FindControl("lblProductCode");

                int rowCount = db.USP_GetBasketProductsOnCheckOut(Convert.ToInt32(Session[enumSessions.OrderId.ToString()].ToString())).Where(i => i.ProductCode == lblProductCode.Text.Trim()).Count();


                if (rowCount == count)
                {
                    USP_GetBasketProductsOnCheckOutResult product = (USP_GetBasketProductsOnCheckOutResult)args.Item.DataItem;
                    Repeater rep = (Repeater)args.Item.FindControl("rptrDependentProducts");


                    rep.DataSource = db.USP_GetBasketDependentProductsByProductId(Convert.ToInt32(Session[enumSessions.OrderId.ToString()].ToString()), product.ProductId, product.CategoryId);
                    rep.DataBind();

                    if (rep.Items.Count == 0)
                        rep.Visible = false;

                    db.Dispose();
                }

                count++;
            }
            if (args.Item.ItemType == ListItemType.Footer)
            {
                Label lblTotalPrice = (Label)args.Item.FindControl("lblTotalPrice");
                Label lblTotalQty = (Label)args.Item.FindControl("lblTotalQty");

                LinqToSqlDataContext db = new LinqToSqlDataContext();
                var OrderInfo = db.USP_CreateOrderForUser(Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString()), Session[enumSessions.User_Name.ToString()].ToString(), Session[enumSessions.User_Name.ToString()].ToString(), Session[enumSessions.User_Email.ToString()].ToString(), Session[enumSessions.User_Id.ToString()].ToString()).SingleOrDefault();
                if (OrderInfo != null)
                {
                    lblTotalPrice.Text = "£" + OrderInfo.Amount.ToString();
                    lblTotalQty.Text = OrderInfo.Quantity.ToString();
                    lblDtlsOrderTotal.Text = OrderInfo.Amount.ToString();
                    lblDtlsTotalToPay.Text = OrderInfo.Amount.ToString();
                }

                if (Session[enumSessions.User_Role.ToString()] != null && Session[enumSessions.User_Role.ToString()].ToString() == enumRoles.ARC_Admin.ToString())
                {
                    lblTotalPrice.Text = String.Empty; //£0.00
                    lblDtlsOrderTotal.Text = String.Empty;//0.00
                    lblDtlsTotalToPay.Text = String.Empty; //0.00
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

    protected void rptrDependentProducts_ItemBound(object sender, RepeaterItemEventArgs args)
    {
        try
        {
            if (args.Item.ItemType == ListItemType.Item || args.Item.ItemType == ListItemType.AlternatingItem)
            {
                if (Session[enumSessions.User_Role.ToString()] != null && Session[enumSessions.User_Role.ToString()].ToString() == enumRoles.ARC_Admin.ToString())
                {
                    Label lblProductPrice = (Label)args.Item.FindControl("lblProductPrice");
                    lblProductPrice.Text = String.Empty;//0.00

                    Label lblProductPriceTotal = (Label)args.Item.FindControl("lblProductPriceTotal");
                    lblProductPriceTotal.Text = String.Empty;//0.00
                }
            }
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "rptrDependentProducts_ItemBound", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            db.Dispose();
        }
    }

    protected void rdoNewAddress_CheckedChanged(object sender, EventArgs e)
    {
        divNewAddress.Visible = true;
    }

    protected void rdoInstallerAddress_CheckedChanged(object sender, EventArgs e)
    {
        divNewAddress.Visible = false;
        txtPreviousPostcode.Text = string.Empty;
        LoadARCDeliveryaddresses();
        chkEditAddress.Checked = false;
        ddlarcdeliveryaddresses.SelectedIndex = 0;
        ddlarcdeliveryaddresses_SelectedIndexChanged(sender, e);
    }

    protected void ddlDeliveryTypes_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            int deliTypeID = 0;
            int.TryParse(ddlDeliveryTypes.SelectedValue, out deliTypeID);
            if (deliTypeID != 0)
            {
                lblDeliveryTotal.Text = OrdersBAL.CalculateOrderDeliverycharge(deliTypeID).ToString();
                lblDtlsDeliveryTotal.Text = lblDeliveryTotal.Text;

                decimal amt = Convert.ToDecimal(String.IsNullOrEmpty(lblDtlsOrderTotal.Text) == true ? "0.00" : lblDtlsOrderTotal.Text) + Convert.ToDecimal(lblDtlsDeliveryTotal.Text);
                decimal? VAT = amt * VATRate;

                lblDtlsVAT.Text = Math.Round(Convert.ToDecimal(VAT), 2).ToString();
                lblDtlsTotalToPay.Text = (amt + Math.Round(Convert.ToDecimal(VAT), 2)).ToString();

            }
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "ddlDeliveryTypes_SelectedIndexChanged", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            db.Dispose();
        }
    }

    protected void btnConfirmOrder_Click(object sender, EventArgs e)
    {
        try
        {
            ltrMessage.Visible = false;

            if (Session[enumSessions.OrderId.ToString()] == null) /* If someone clicks on back button - when the confirmation message is shown.*/
                Response.Redirect("Login.aspx");
            else if (dlProducts.Items.Count == 0)
            {
                ltrMessage.Visible = true;
                ltrMessage.Text = "No item is added to confirm the order. Please add an item first to confirm the order.";
            }
            else
            {
                LinqToSqlDataContext db = new LinqToSqlDataContext();
                var orderStatus = (from o in db.Orders
                                   where o.OrderId == Convert.ToInt32(Session[enumSessions.OrderId.ToString()])
                                   select o.OrderStatusId).SingleOrDefault();
                if (orderStatus != 1)
                {
                    Response.Redirect("Categories.aspx");
                }
                this.MaintainScrollPositionOnPostBack = true;

                if (divNewAddress.Visible)
                {
                    Page.Validate("grpDeliveryAddress");
                }

                if (divInstallationAddress.Visible)
                {
                    Page.Validate("grpInstallationAddress");
                }

                if (String.IsNullOrEmpty(txtOrderRefNo.Text.Trim()) == true)
                {
                    ltrMessage.Text = "Please enter the ARC Order Reference number.";
                    txtOrderRefNo.BackColor = System.Drawing.Color.Yellow;
                    txtOrderRefNo.Focus();

                    return;
                }
                else
                {
                    Session[enumSessions.OrderRef.ToString()] = txtOrderRefNo.Text;
                }

                if (IsValid)
                {
                    btnConfirmOrder.Enabled = false;
                    int addressId = 0;
                    int installationAddressId = 0;
                    string contactno = txtDeliContactNo.Text.ToString().Trim();
                    string OrderNo = String.Empty;
                    if (rdoInstallerAddress.Checked)
                    {
                        addressId = InstallerBAL.SaveInstallerAddress(Session[enumSessions.InstallerCompanyID.ToString()].ToString(), txtInstContactName1.Text, contactno, 0, "", "", "", "", "", "", Session[enumSessions.User_Name.ToString()].ToString());
                    }
                    else if (ddlarcdeliveryaddresses.SelectedValue != "0" && (chkEditAddress.Checked == false) && !string.IsNullOrEmpty(ddlarcdeliveryaddresses.SelectedValue))
                    {
                        addressId = Convert.ToInt32(ddlarcdeliveryaddresses.SelectedValue);
                    }
                    else
                    {
                        int countryId = 0;
                        int.TryParse(ddlCountry.SelectedValue, out countryId);
                        addressId = InstallerBAL.SaveInstallerAddress("", txtDeliContactName.Text, contactno, countryId, txtDeliAddressOne.Text, txtDeliAddressTwo.Text, txtDeliTown.Text, txtDeliCounty.Text, txtDeliPostcode.Text, ddlCountry.SelectedItem.Text, Session[enumSessions.User_Name.ToString()].ToString());
                    }

                    if (chkInstallationAddress.Checked)
                    {
                        instadd_differs = true;
                        int countryId = 0;
                        int.TryParse(ddlInstCountry.SelectedValue, out countryId);
                        installationAddressId = InstallerBAL.SaveInstallerAddress("", txtInstContactName.Text, txtInstContactNumber.Text, countryId,
                            txtInstAddressOne.Text, txtInstAddressTwo.Text, txtInstTown.Text,
                            txtInstCounty.Text, txtInstPostCode.Text, ddlInstCountry.SelectedItem.Text, Session[enumSessions.User_Name.ToString()].ToString());
                    }
                    //Added below code by Atiq on 11-08-2016 for ESI changes
                    string alarmDelArcCode = string.Empty;
                    if (ddlArcBranches.SelectedIndex > 0)
                    {
                        var arcData = (from a in db.AlarmDeliveryARCMappings
                                       where a.ID == Convert.ToInt32(ddlArcBranches.SelectedValue)
                                       select a.Branch_ARC_Code).SingleOrDefault();
                        alarmDelArcCode = arcData;
                    }
                    int orderid = Convert.ToInt32(Session[enumSessions.OrderId.ToString()].ToString());
                    var ordrNo = db.USP_ConfirmOrderDetails(orderid, txtOrderRefNo.Text, Convert.ToDecimal(lblDeliveryTotal.Text), addressId,
                        ddlDeliveryTypes.SelectedValue == String.Empty ? 0 : Convert.ToInt32(ddlDeliveryTypes.SelectedValue), txtInstructions.Text,
                        VATRate, Session[enumSessions.User_Name.ToString()].ToString(), installationAddressId, txtInstContactName1.Text, 
                        alarmDelArcCode).SingleOrDefault();
                    if (ordrNo != null)
                        OrderNo = ordrNo.OrderNo;
                    db.SubmitChanges();

                    int orderHasEmizonProducts = (from O in db.Orders
                                                  join
                                                      oi in db.OrderItems on O.OrderId equals oi.OrderId
                                                  join
                                                  p in db.Products on oi.ProductId equals p.ProductId
                                                  where
                                                  O.OrderId == orderid
                                                  &&
                                                  p.IsEmizonProduct == true
                                                  && 
                                                  p.ProductType == "Product"
                                                  select p.EM_ProductCode).Count();

                    // ** Send to logistcs
                    SendEmailDTO sendEmaildto = new SendEmailDTO();
                    sendEmaildto.ARCOrderRefNo = txtOrderRefNo.Text;
                    sendEmaildto.orderDate = lblOrderDate.Text;
                    sendEmaildto.userID = Session[enumSessions.User_Id.ToString()].ToString();
                    sendEmaildto.userName = Session[enumSessions.User_Name.ToString()].ToString();
                    sendEmaildto.userEmail = Session[enumSessions.User_Email.ToString()].ToString();
                    sendEmaildto.orderID = Session[enumSessions.OrderId.ToString()].ToString();
                    sendEmaildto.DdeliveryType = ddlDeliveryTypes.SelectedItem.Text;
                    sendEmaildto.deliveryCost = lblDeliveryTotal.Text;
                    sendEmaildto.installerID = Session[enumSessions.InstallerCompanyID.ToString()].ToString();
                    sendEmaildto.specialInstructions = txtInstructions.Text;

                    //Send to CSL Orders INBOX // do not send to emizon queue as its internal email and EM is not mandatory
                    SendEmail.SendEmailWithPrice(OrderNo, mailTO, sendEmaildto, mailFrom, mailCC, false, false ,0);

                    // ** Send to customers
                    if (Session[enumSessions.User_Role.ToString()] != null && Session[enumSessions.User_Role.ToString()].ToString() == enumRoles.ARC_Admin.ToString())
                    {
                        SendEmail.SendEmailWithoutPrice(OrderNo, Session[enumSessions.User_Email.ToString()].ToString(), sendEmaildto,
                            mailFrom, mailCC + "," + LoadARCEmailCC(), false, (orderHasEmizonProducts > 0) ? true : false, orderid);
                    }
                    else
                    {
                        SendEmail.SendEmailWithPrice(OrderNo, Session[enumSessions.User_Email.ToString()].ToString(), sendEmaildto,
                            mailFrom, mailCC + "," + LoadARCEmailCC(), false, (orderHasEmizonProducts > 0) ? true : false, orderid);
                    }

                    db.Dispose();
                    Session[enumSessions.OrderId.ToString()] = null;
                    Session[enumSessions.OrderNumber.ToString()] = OrderNo;

                    //Add Emizon page redirection here
                    if (orderHasEmizonProducts > 0)
                    {
                        Response.Redirect("OrderConfirmationEM.aspx?id=" + orderid.ToString());
                    }
                    else
                    {
                        Response.Redirect("OrderConfirmation.aspx");
                    }
                }
                else
                {
                    btnConfirmOrder.Enabled = true;
                    txtDeliContactName.Focus();
                    this.MaintainScrollPositionOnPostBack = false;
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
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnConfirmOrder_Click", 
                Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), 
                Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, 
                false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }


    protected void btnAlertOrderConfirmation_Click(object sender, EventArgs e)
    {
        Response.Redirect("OrderConfirmation.aspx");
    }


    protected void chkInstallationAddress_CheckedChanged(object sender, EventArgs e)
    {
        divInstallationAddress.Visible = false;
        if (chkInstallationAddress.Checked)
            divInstallationAddress.Visible = true;
    }
    protected void ddlarcdeliveryaddresses_SelectedIndexChanged(object sender, EventArgs e)
    {
        LinqToSqlDataContext db = new LinqToSqlDataContext();
        int addid = Convert.ToInt32(ddlarcdeliveryaddresses.SelectedValue);
        if (addid != 0)
        {
            var data = (from addr in db.Addresses
                        where addr.AddressID == addid
                        select new
                        {
                            addr.PostCode,
                            addr.ContactName,
                            addr.AddressOne,
                            addr.AddressTwo,
                            addr.Town,
                            addr.County,
                            addr.Country,
                            addr.Mobile,
                            addr.CountryId
                        }
                         ).SingleOrDefault();

            txtDeliContactName.Text = string.IsNullOrEmpty(data.ContactName) ? "" : data.ContactName;
            txtDeliCounty.Text = string.IsNullOrEmpty(data.County) ? "" : data.County;
            txtDeliPostcode.Text = string.IsNullOrEmpty(data.PostCode) ? "" : data.PostCode;
            txtDeliTown.Text = string.IsNullOrEmpty(data.Town) ? "" : data.Town;
            txtDeliAddressOne.Text = string.IsNullOrEmpty(data.AddressOne) ? "" : data.AddressOne;
            txtDeliAddressTwo.Text = string.IsNullOrEmpty(data.AddressTwo) ? "" : data.AddressTwo;
            ddlCountry.SelectedIndex = string.IsNullOrEmpty(data.Country) ? 0 : (int)data.CountryId - 1; // AS THE DB ID STARTS WITH 1 , reduce it by 1 
            txtDeliContactNo.Text = string.IsNullOrEmpty(data.Mobile) ? "" : data.Mobile;
            pnlPrevAddress.Enabled = false;
            chkEditAddress.Visible = true;
        }
        else
        {
            chkEditAddress.Visible = false;
            pnlPrevAddress.Enabled = true;
            txtDeliContactName.Text = string.Empty;
            txtDeliCounty.Text = string.Empty;
            txtDeliPostcode.Text = string.Empty;
            txtDeliTown.Text = string.Empty;
            txtDeliAddressOne.Text = string.Empty;
            txtDeliAddressTwo.Text = string.Empty;
            txtDeliContactNo.Text = string.Empty;
        }
    }

    protected void chkEditAddress_CheckedChanged(object sender, EventArgs e)
    {
        if (chkEditAddress.Checked)
            pnlPrevAddress.Enabled = true;
        else
            pnlPrevAddress.Enabled = false;
    }

    protected void btnGo_Click(object sender, EventArgs e)
    {
        LoadARCDeliveryaddresses();
        ddlarcdeliveryaddresses_SelectedIndexChanged(sender, e);
        ddlarcdeliveryaddresses.Focus();
    }
    /// <summary>
    /// Bind All ARC's Branches with dropdown on page load  
    /// 
    /// </summary>
    private void BindARCBranchesDropdown()
    {
        CSLOrderingARCBAL.LinqToSqlDataContext db;
        try
        {

            using (db = new LinqToSqlDataContext())
            {
                var arcData = (from a in db.ARCs
                               where a.ARCId == Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString())
                               select a).SingleOrDefault();
                var ARCdata = (from alarmDelMap in db.AlarmDeliveryARCMappings
                               orderby alarmDelMap.Branch_ARC_Code ascending
                               where alarmDelMap.IsDeleted == false && alarmDelMap.ARCId == Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString())
                               select new { alarmDelMap.ID, ARCDisp = alarmDelMap.Branch_ARC_Name + " - [" + alarmDelMap.Branch_ARC_Code + "] " });

                ddlArcBranches.DataValueField = "ID";
                ddlArcBranches.DataTextField = "ARCDisp";
                ddlArcBranches.DataSource = ARCdata;
                ddlArcBranches.DataBind();
                ddlArcBranches.Items.Insert(0, new System.Web.UI.WebControls.ListItem(Convert.ToString(arcData.CompanyName) + " - [" + Convert.ToString(arcData.ARC_Code) + "] ", Convert.ToString(arcData.ARCId)));
                if (!arcData.IsARCAllowedForBranch)
                {
                    //ddlArcBranches.Enabled = false;
                    divARCBranches.Visible = false;
                }
                else
                {
                    //ddlArcBranches.Enabled = true;
                    divARCBranches.Visible = true;
                }
            }
        }
        catch (Exception objException)
        {

            using (db = new CSLOrderingARCBAL.LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "BindARCBranchesDropdown", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }

    }
}