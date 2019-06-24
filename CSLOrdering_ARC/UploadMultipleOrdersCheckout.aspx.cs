using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Odbc;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;
using CSLOrderingARCBAL.BAL;
using CSLOrderingARCBAL.Common;
using System.Text;
using System.Threading;
using System.Web.UI.HtmlControls;
using MSMQSendEmailToQueueLibrary;

public partial class UploadMultipleOrdersCheckout : System.Web.UI.Page
{
    string mailFrom = String.Empty;
    string mailCC = String.Empty;
    string mailTO = String.Empty;
    bool instadd_differs = false;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session[enumSessions.User_Id.ToString()] == null)
            Response.Redirect("Login.aspx");

        ltrConfirmTermsAndConds.Visible = false;
        InstallersPC.getBulkuploadOrderItems += new Modules_InstallersPC.customHandler(GetBulkUploadOrderedItemsInstallerSelection);
        InstallersUC.getBulkuploadOrderItems += new Modules_Installers.customHandler(GetBulkUploadOrderedItemsInstallerSelection);
        if (!Page.IsPostBack)
        {
            GetBulkUploadOrderedItems();
            ltrConfirmTermsAndConds.Visible = false;
            Session[enumSessions.BulkUploadMultipleOrderId.ToString()] = null;
            InstallersPC.Visible = false;
            InstallersUC.Visible = false;
            int ARCId = Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()]);
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            var enablePostCodeSearch = (from arc in db.ARCs
                                        where arc.ARCId == ARCId
                                        select arc.EnablePostCodeSearch).Single();
            if (enablePostCodeSearch == true)
            {
                InstallersPC.Visible = true;
            }
            else
            {
                InstallersUC.Visible = true;
            }
            LoadCountries();
            LoadARCDeliveryaddresses();
        }       
               
    }
    public void GetBulkUploadOrderedItemsInstallerSelection(object sender)
    {
        GetBulkUploadOrderedItems();
    }
    /// <summary>
    /// The purpose of this method to get uploaded and created order items from database.
    /// </summary>
    private void GetBulkUploadOrderedItems()
    {
        DataSet dsResult = UploadMultipleOrdersBAL.GetBulkUploadOrderItems(Session[enumSessions.User_Name.ToString()].ToString());
        if (dsResult.Tables.Count > 1)
        {   
            if(dsResult.Tables[0].Rows.Count>0)
            {
                btnConfirmOrder.Visible = true;
                pnlAccepted.Visible = true;
                lbClearBasket.Visible = true;
                lblClearItems.Visible = false;

            }
            else
            {
                btnConfirmOrder.Visible = false;
                pnlAccepted.Visible = false;
                lbClearBasket.Visible = false;
                lblClearItems.Visible = true;
            }
            ViewState["OrderItems"] = dsResult.Tables[1];
            ViewState["ConfirmOrders"] = dsResult.Tables[2];
            gvOrders.DataSource = dsResult.Tables[0];
            gvOrders.DataBind();   
        }
    }
    protected void lbClearBasket_Click(object sender, EventArgs e)
    {
        try
        {
            foreach (GridViewRow row in gvOrders.Rows)
            {
                int orderId = 0;
                orderId = Convert.ToInt32(gvOrders.DataKeys[row.RowIndex].Value);
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {
                   db.USP_RemoveBulkMultipleOrderItemsFromBasket(orderId,Session[enumSessions.User_Name.ToString()].ToString());              
                }
            }
            GetBulkUploadOrderedItems();
        }
        catch (Exception objException)
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "lbClearBasket_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

            }
        }
        

    }

    protected void gvOrders_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string orderId = gvOrders.DataKeys[e.Row.RowIndex].Value.ToString();
            GridView gvOrderProducts = e.Row.FindControl("gvOrderProducts") as GridView;
            DropDownList ddlDeliveryType = e.Row.FindControl("ddlDeliveryTypes") as DropDownList;
            ddlDeliveryType.Attributes.Add("onchange", "return ConfirmToSetDeliveryTypes(this)");
            Label lblCompanyId = (Label)e.Row.FindControl("lblCompanyId");
            Label lblInstallerAddress = (Label)e.Row.FindControl("lblInstallerAddress");
            LinkButton lnkSameAddress = (LinkButton)e.Row.FindControl("lnkSameAddress");
            Panel pnlOrders = (Panel)e.Row.FindControl("pnlOrders");
            HtmlAnchor lnkShowHide = e.Row.FindControl("lnkShowHide") as HtmlAnchor;
            Label lblDeliveryAddressId = (Label)e.Row.FindControl("lblDeliveryAddressId");
            Label lblDeliveryAddress = (Label)e.Row.FindControl("lblDeliveryAddress");
            LinkButton lnkNewAddress = (LinkButton)e.Row.FindControl("lnkNewAddress");
            if (!string.IsNullOrEmpty(lblCompanyId.Text))
            {
                lblInstallerAddress.ToolTip = InstallerBAL.GetInstallerAddress(new Guid(lblCompanyId.Text));
                lnkSameAddress.Visible = true;
            }
            else
            {
                lnkSameAddress.Visible = false;
            }
            if (!string.IsNullOrEmpty(lblDeliveryAddressId.Text) && lblDeliveryAddressId.Text!="0")
            {
                lblDeliveryAddress.Text = InstallerBAL.GetShortDeliveryAddressByAddressId(Convert.ToInt32(lblDeliveryAddressId.Text));
                lblDeliveryAddress.ToolTip = InstallerBAL.GetDeliveryAddressByAddressId(Convert.ToInt32(lblDeliveryAddressId.Text));
                lnkNewAddress.Text = "Change";
            }
            int ARCId = Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()]);         
            if (ddlDeliveryType != null && !string.IsNullOrEmpty(lblCompanyId.Text))
            {
                LoadDeliveryTypes(ddlDeliveryType, ARCId, new Guid(lblCompanyId.Text), Convert.ToInt32(orderId));
            }
               DataTable dtResult = null;
               if (ViewState["OrderItems"]!=null)
                {
                    dtResult = (DataTable)ViewState["OrderItems"];
                    DataView dataView = new DataView(dtResult);
                    dataView.RowFilter = "OrderId=" + orderId; 
                    if (dataView.Table.Rows.Count>0)
                    {
                        gvOrderProducts.DataSource = dataView;
                        gvOrderProducts.DataBind();
                    }
                }
        }
              
    }

    protected void LoadDeliveryTypes(DropDownList ddlDeliveryTypes,int arcId,Guid installerCompanyId,int orderId)
    {

        ddlDeliveryTypes.Items.Clear();
        //Set the lowest priced as selected. 
        int i = 0; int selectedIndex = 0;        
        decimal leastPriceItem = decimal.MaxValue;
        try
        {        
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            List<USP_GetShippingOptionsResult> shippingOptions = new List<USP_GetShippingOptionsResult>();
            shippingOptions = db.USP_GetShippingOptions(arcId,installerCompanyId,orderId).ToList();
            foreach (USP_GetShippingOptionsResult delivery in shippingOptions)
            {
                System.Web.UI.WebControls.ListItem item = new System.Web.UI.WebControls.ListItem();
                System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-GB", false);
                item.Text = delivery.DeliveryShortDesc + " - " + delivery.DeliveryPrice.Value.ToString("c");
                item.Value = delivery.DeliveryTypeId.ToString();
                ddlDeliveryTypes.Items.Add(item);
                if (leastPriceItem != decimal.Zero && delivery.DeliveryPrice < leastPriceItem)
                {
                    leastPriceItem = delivery.DeliveryPrice.Value;
                    ddlDeliveryTypes.ClearSelection();
                    ddlDeliveryTypes.SelectedIndex = i;
                    selectedIndex = i;
                }
                
                i++;
            }
            ddlDeliveryTypes.DataBind();
            ddlDeliveryTypes.SelectedIndex = selectedIndex;

        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "LoadDeliveryTypes", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            db.Dispose();
        }
    }
    protected void btnConfirmOrder_Click(object sender, EventArgs e)
    {
        try
        {
            ltrConfirmTermsAndConds.Visible = false;
            Session[enumSessions.BulkUploadMultipleOrderId.ToString()] = null;
            if(!IsCompanyNameAvailable())
            {
                ltrConfirmTermsAndConds.Text = "Installer Company Name should not be blank for any Order No";
                ltrConfirmTermsAndConds.Visible = true;
                return;
            }
            if (!IsDeliveryAddressAvailable())
            {
                ltrConfirmTermsAndConds.Text = "Delivery address should not be blank for any Order No";
                ltrConfirmTermsAndConds.Visible = true;
                return;
            }

            if (!chkTermsAndConds.Checked)
            {
                ltrConfirmTermsAndConds.Visible = true;
                return;
            }
            decimal? VATRate = 0.0m;
            ApplicationDTO appdto = null;
            AppSettings appsett = null;
            if (!(VATRate > 0.0m))
            {
                appsett = new AppSettings();
                appdto = appsett.GetAppValues();
                VATRate = appdto.VATRate;
            }
            appsett = new AppSettings();
            appdto = appsett.GetAppValues();
            mailTO = appdto.mailTO;
            mailCC = appdto.mailCC;
            mailFrom = appdto.mailFrom;
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                string OrderNo = String.Empty;
                string orderRefNo = String.Empty;
                decimal deliveryCost = 0.0m;
                int deliveryAddressId = 0;
                int deliveryTypeId = 0;
                string specialtxtInstructions = String.Empty;
                foreach (GridViewRow row in gvOrders.Rows)
                {
                    int orderId = 0;
                    orderId = Convert.ToInt32(gvOrders.DataKeys[row.RowIndex].Value);
                    DropDownList ddlDeliveryType = row.FindControl("ddlDeliveryTypes") as DropDownList;
                    Label lblDeliveryCostTotal = (Label)row.FindControl("lblDeliveryCostTotal");
                    deliveryCost = Convert.ToDecimal(lblDeliveryCostTotal.Text);
                    deliveryTypeId = Convert.ToInt32(ddlDeliveryType.SelectedValue);
                    Label lblCompanyId = (Label)row.FindControl("lblCompanyId");
                    Label lblOrderRefNo = (Label)row.FindControl("lblOrderRefNo");
                    orderRefNo = lblOrderRefNo.Text;
                    var ordrNo = db.USP_ConfirmBulkUploadMultipleOrders(orderId,deliveryCost, deliveryAddressId, deliveryTypeId, specialtxtInstructions, VATRate, Session[enumSessions.User_Name.ToString()].ToString()).SingleOrDefault();
                    OrderNo = ordrNo.OrderNo; 
                   
                     SendEmailDTO sendEmaildto = new SendEmailDTO();
                    sendEmaildto.orderID = orderId.ToString();
                    sendEmaildto.ARCOrderRefNo = orderRefNo;
                    sendEmaildto.orderDate = DateTime.Now.ToString();
                    sendEmaildto.userID = Session[enumSessions.User_Id.ToString()].ToString();
                    sendEmaildto.userName = Session[enumSessions.User_Name.ToString()].ToString();
                    sendEmaildto.userEmail = Session[enumSessions.User_Email.ToString()].ToString();                 
                    sendEmaildto.DdeliveryType = ddlDeliveryType.SelectedItem.Text;
                    sendEmaildto.deliveryCost = Convert.ToString(deliveryCost);
                    sendEmaildto.installerID = lblCompanyId.Text;
                  
                    sendEmaildto.specialInstructions = string.Empty;
                  

                    // ** Send to logistcs
                    SendEmail.SendEmailWithPrice(OrderNo, mailTO, sendEmaildto, mailFrom, mailCC, false,false,0);

                    // ** Send to customers
                    if (Session[enumSessions.User_Role.ToString()] != null && Session[enumSessions.User_Role.ToString()].ToString() == enumRoles.ARC_Admin.ToString())
                    {
                        SendEmail.SendEmailWithoutPrice(OrderNo, Session[enumSessions.User_Email.ToString()].ToString(), sendEmaildto, mailFrom, mailCC, false,false,0);
                    }
                    else
                    {
                        SendEmail.SendEmailWithPrice(OrderNo, Session[enumSessions.User_Email.ToString()].ToString(), sendEmaildto, mailFrom, mailCC, false,false,0);
                    }
                   
                }
                DataSet dsResult = UploadMultipleOrdersBAL.GetBulkUploadOrderItems(Session[enumSessions.User_Name.ToString()].ToString());
                if (dsResult.Tables.Count > 1)
                {
                    if (dsResult.Tables[0].Rows.Count > 0)
                    {
                        gvOrders.DataSource = dsResult.Tables[0];
                        gvOrders.DataBind();
                        gvOrders.Visible = true;
                    }
                    else
                    {
                        gvOrders.Visible = false;
                    }
                }
                if (ViewState["ConfirmOrders"] != null)
                {
                    tdOrderSummary.Visible = true;
                    rptUploadedProducts.Visible = true;
                    rptUploadedProducts.DataSource = (DataTable)ViewState["ConfirmOrders"];
                    rptUploadedProducts.DataBind();
                }                
                ltrOrderConfirmMessage.Visible = true;
                btnConfirmOrder.Visible = false;
                pnlAccepted.Visible = false;
                lbClearBasket.Visible = false;
            }
        }
        catch (Exception objException)
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnConfirmOrder_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
                
            }
        }
    }
    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox chkSelectAllHeader = (CheckBox)gvOrders.HeaderRow.FindControl("chkSelectAll");
        int orderId = 0;
        int arc_Id = 0;
        foreach (GridViewRow row in gvOrders.Rows)
        {
            
            DropDownList ddlDeliveryType = row.FindControl("ddlDeliveryTypes") as DropDownList;
            Label lblDeliveryCostTotal = (Label)row.FindControl("lblDeliveryCostTotal");            
            Label lblCompanyId = (Label)row.FindControl("lblCompanyId");
            arc_Id = Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString());
            orderId = Convert.ToInt32(gvOrders.DataKeys[row.RowIndex].Value);

            if (ddlDeliveryType.Items.Count == 0 && chkSelectAllHeader.Checked)
            {
                string script = "alertify.alert('" + ltrDeliverTypeNoItems.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                break;
            }
            if (ddlDeliveryType != null && !string.IsNullOrEmpty(lblCompanyId.Text))
            {
                if (chkSelectAllHeader.Checked)
                {
                    
                    ddlDeliveryType.Enabled = false;
                    LoadDeliveryTypes(ddlDeliveryType,arc_Id,new Guid(lblCompanyId.Text),orderId);
                    lblDeliveryCostTotal.Text = "0";
                }
                else
                {
                    LoadDeliveryTypes(ddlDeliveryType, arc_Id, new Guid(lblCompanyId.Text), orderId);
                    ddlDeliveryType.Enabled = true;
                }
                
            }
        }
    }

    protected void ddlDeliveryTypes_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            int deliveryTypeID = 0;
            DropDownList ddlType = (DropDownList)sender;
            GridViewRow gvRow = (GridViewRow)ddlType.NamingContainer;
            DropDownList ddlDeliveryTypes = (DropDownList)gvRow.FindControl("ddlDeliveryTypes");
            Label lblDeliveryCostTotal = (Label)gvRow.FindControl("lblDeliveryCostTotal");
            lblDeliveryCostTotal.Text = "0";
            int.TryParse(ddlDeliveryTypes.SelectedValue, out deliveryTypeID);
            if (deliveryTypeID != 0)
            {
                lblDeliveryCostTotal.Text = OrdersBAL.CalculateOrderDeliverycharge(deliveryTypeID).ToString();
            }
        }
        catch (Exception objException)
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "ddlDeliveryTypes_SelectedIndexChanged", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
    }

    
    protected void lnkInstaller_Click(object sender, EventArgs e)
    {
        LinkButton lnkbtnIns = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lnkbtnIns.NamingContainer;
        Session[enumSessions.BulkUploadMultipleOrderId.ToString()] = gvOrders.DataKeys[gvRow.RowIndex].Value.ToString();
        mpInstaller.Show();
       
      
    }
    
    protected void ddlarcdeliveryaddresses_SelectedIndexChanged(object sender, EventArgs e)
    {
       
        try
        {
            int addid = Convert.ToInt32(ddlarcdeliveryaddresses.SelectedValue);
            if (addid != 0)
            {
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
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
                    //chkEditAddress.Visible = true;
                    trEditAddress.Visible = true;
                }
            }
            else
            {
                //chkEditAddress.Visible = false;
                trEditAddress.Visible = false;
                pnlPrevAddress.Enabled = true;
                txtDeliContactName.Text = string.Empty;
                txtDeliCounty.Text = string.Empty;
                txtDeliPostcode.Text = string.Empty;
                txtDeliTown.Text = string.Empty;
                txtDeliAddressOne.Text = string.Empty;
                txtDeliAddressTwo.Text = string.Empty;
                txtDeliContactNo.Text = string.Empty;
            }
            mpDeliveryAddress.Show();
        }
        catch (Exception objException)
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "ddlarcdeliveryaddresses_SelectedIndexChanged", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
    }

    
    protected void btnGo_Click(object sender, EventArgs e)
    {
        LoadARCDeliveryaddresses();
        ddlarcdeliveryaddresses_SelectedIndexChanged(sender, e);
        ddlarcdeliveryaddresses.Focus();
        mpDeliveryAddress.Show();
    }
    private void LoadARCDeliveryaddresses()
    {
        
        try
        {
            string postcode = txtPreviousPostcode.Text;
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
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
            }
        }
        catch (Exception objException)
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "LoadARCDeliveryaddresses", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
    } 
    protected void chkEditAddress_CheckedChanged(object sender, EventArgs e)
    {
        if (chkEditAddress.Checked)
            pnlPrevAddress.Enabled = true;
        else
            pnlPrevAddress.Enabled = false;
        mpDeliveryAddress.Show();
    }
    void LoadCountries()
    {
        try
        {
            ddlCountry.DataSource = InstallerBAL.GetCountries();
            ddlCountry.DataValueField = "CountryId";
            ddlCountry.DataTextField = "CountryName";
            ddlCountry.DataBind();
            ddlCountry.SelectedIndex = 0;
        }
        catch (Exception objException)
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "LoadCountries", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
        
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        int addressId = 0;
        try
        {
            string contactno = txtDeliContactNo.Text.ToString().Trim();
            if (divNewAddress.Visible)
            {
                Page.Validate("grpDeliveryAddress");
            }
            if (IsValid)
            {
                if (ddlarcdeliveryaddresses.SelectedValue != "0" && (chkEditAddress.Checked == false) && !string.IsNullOrEmpty(ddlarcdeliveryaddresses.SelectedValue))
                {
                    addressId = Convert.ToInt32(ddlarcdeliveryaddresses.SelectedValue);
                }
                else
                {
                    int countryId = 0;
                    int.TryParse(ddlCountry.SelectedValue, out countryId);
                    addressId = InstallerBAL.SaveInstallerAddress("", txtDeliContactName.Text, contactno, countryId, txtDeliAddressOne.Text, txtDeliAddressTwo.Text, txtDeliTown.Text, txtDeliCounty.Text, txtDeliPostcode.Text, ddlCountry.SelectedItem.Text, Session[enumSessions.User_Name.ToString()].ToString());
                }
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {
                    if (Session[enumSessions.BulkUploadMultipleOrderId.ToString()] != null)
                    {
                        var orderDetail = db.Orders.Single(x => x.OrderId == Convert.ToInt32(Session[enumSessions.BulkUploadMultipleOrderId.ToString()]));
                        orderDetail.DeliveryAddressId = addressId;
                        orderDetail.ModifiedBy = Session[enumSessions.User_Name.ToString()].ToString();
                        orderDetail.ModifiedOn = DateTime.Now;
                        db.SubmitChanges();
                    }
                    GetBulkUploadOrderedItems();

                }

            }
            else
            {
                mpDeliveryAddress.Show();
            }
        }
        catch (Exception objException)
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSave_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
    }     
    protected void lnkSameAddress_Click(object sender, EventArgs e)
    {
        try
        {
            LinkButton lnkSameAddress = (LinkButton)sender;
            GridViewRow gvRow = (GridViewRow)lnkSameAddress.NamingContainer;
            Label lblDeliveryAddressId = (Label)gvRow.FindControl("lblDeliveryAddressId");
            Label lblCompanyId = (Label)gvRow.FindControl("lblCompanyId");
            int orderId = 0;
            int addressId = 0;
            if (!string.IsNullOrEmpty(lblDeliveryAddressId.Text))
            {
                   foreach (GridViewRow row in gvOrders.Rows)
                   {
                        using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                        {
                            
                            var insContactName = (from insAdd in db.InstallerAddresses
                                                  join ins in db.Installers on insAdd.AddressID equals ins.AddressID
                                                  where ins.InstallerCompanyID == new Guid(lblCompanyId.Text)
                                                  select insAdd.ContactName).Single();
                            if (insContactName != null)
                                addressId = InstallerBAL.SaveInstallerAddress(lblCompanyId.Text, insContactName, "", 0, "", "", "", "", "", "", Session[enumSessions.User_Name.ToString()].ToString());
                            orderId = Convert.ToInt32(gvOrders.DataKeys[row.RowIndex].Value.ToString());
                            var orderDetail = db.Orders.Single(x => x.OrderId == orderId);
                            if (orderDetail.DeliveryAddressId == 0)
                            {
                                orderDetail.DeliveryAddressId = addressId;
                            }
                            orderDetail.ModifiedBy = Session[enumSessions.User_Name.ToString()].ToString();
                            orderDetail.ModifiedOn = DateTime.Now;
                            db.SubmitChanges();
                            db.USP_SaveInstallerDetailsInOrder(lblCompanyId.Text, orderId);
                        }
                    }
                    
               
            }
            GetBulkUploadOrderedItems();
        }
        catch (Exception objException)
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSameAddress_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
    } 
    private bool IsCompanyNameAvailable()
    {
        bool isCompAvailable=true;
        foreach (GridViewRow row in gvOrders.Rows)
        {

            Label lblCompanyId = (Label)row.FindControl("lblCompanyId");
            if (string.IsNullOrEmpty(lblCompanyId.Text))
            {
                isCompAvailable = false;
                break;
            }
        }
        return isCompAvailable;
    }
    private bool IsDeliveryAddressAvailable()
    {
        bool isDelAddress = true;
        foreach (GridViewRow row in gvOrders.Rows)
        {

            Label lblDeliveryAddressId = (Label)row.FindControl("lblDeliveryAddressId");
            if (string.IsNullOrEmpty(lblDeliveryAddressId.Text))
            {
                isDelAddress = false;
                break;
            }
        }
        return isDelAddress;
    }
    protected void lnkNewAddress_Click(object sender, EventArgs e)
    {
        LinkButton lnkNewAddress = (LinkButton)sender;
        GridViewRow gvRow = (GridViewRow)lnkNewAddress.NamingContainer;
        Session[enumSessions.BulkUploadMultipleOrderId.ToString()] = gvOrders.DataKeys[gvRow.RowIndex].Value.ToString();
        mpDeliveryAddress.Show();
    }
    protected void btnSaveforAllOrders_Click(object sender, EventArgs e)
    {
        int addressId = 0;
        try
        {
            string confirmValue = Request.Form["confirm_value"];
            if (confirmValue != "Ok")
            {
                return;
            }
            string contactno = txtDeliContactNo.Text.ToString().Trim();
            if (divNewAddress.Visible)
            {
                Page.Validate("grpDeliveryAddress");
            }
            if (IsValid)
            {
                if (ddlarcdeliveryaddresses.SelectedValue != "0" && (chkEditAddress.Checked == false) && !string.IsNullOrEmpty(ddlarcdeliveryaddresses.SelectedValue))
                {
                    addressId = Convert.ToInt32(ddlarcdeliveryaddresses.SelectedValue);
                }
                else
                {
                    int countryId = 0;
                    int.TryParse(ddlCountry.SelectedValue, out countryId);
                    addressId = InstallerBAL.SaveInstallerAddress("", txtDeliContactName.Text, contactno, countryId, txtDeliAddressOne.Text, txtDeliAddressTwo.Text, txtDeliTown.Text, txtDeliCounty.Text, txtDeliPostcode.Text, ddlCountry.SelectedItem.Text, Session[enumSessions.User_Name.ToString()].ToString());
                }
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {
                    for (int i = 0; i < gvOrders.Rows.Count; i++)
                    {
                        int orderId = 0;
                        orderId = Convert.ToInt32(gvOrders.DataKeys[i].Value);
                        var orderDetail = db.Orders.Single(x => x.OrderId == orderId);
                        orderDetail.DeliveryAddressId = addressId;
                        orderDetail.ModifiedBy = Session[enumSessions.User_Name.ToString()].ToString();
                        orderDetail.ModifiedOn = DateTime.Now;
                        db.SubmitChanges();
                    }                    
                    GetBulkUploadOrderedItems();
                }

            }
            else
            {
                mpDeliveryAddress.Show();
            }
        }
        catch (Exception objException)
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnSaveforAllOrders_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
    }
    /*
    public void SendEmailWithPrice(string OrderNo, string mailTO, string _mailCC, string orderRefNo, string deliveryTypes, string deliveryCostTotal, int orderId, Guid installerCompanyId)
    {
        try
        {
            String ProductsList = "";
            string mailSubject = "Order Confirmation - Order Ref: " + OrderNo;
            String mailHtml = ReadTemplates.ReadMailTemplate(Server.MapPath("Template"), "EmailTemplate.html");
            StringBuilder objBuilder = new StringBuilder();
            objBuilder.Append(mailHtml);
            objBuilder.Replace("{OrderNo}", OrderNo);
            objBuilder.Replace("{OrderDate}", DateTime.Now.ToString("dd-MMM-yyyy").ToUpper());
            objBuilder.Replace("{OrderRef}", string.IsNullOrEmpty(orderRefNo) ? "." : orderRefNo);

            ARC arc = ArcBAL.GetArcInfoByUserId(new Guid(Session[enumSessions.User_Id.ToString()].ToString()));
            string arcAdd = String.Empty;

            if (arc != null)
            {
                arcAdd = arc.CompanyName == null ? "" : arc.CompanyName + ",&nbsp;";
                arcAdd += arc.AddressOne + ", <br /> ";
                arcAdd += string.IsNullOrEmpty(arc.AddressTwo) ? "" : arc.AddressTwo + ",&nbsp;";
                arcAdd += string.IsNullOrEmpty(arc.Town) ? "" : arc.Town + ",<br /> ";
                arcAdd += string.IsNullOrEmpty(arc.County) ? "" : arc.County + ", ";
                arcAdd += string.IsNullOrEmpty(arc.PostCode) ? "" : arc.PostCode + " <br />";
                objBuilder.Replace("{Fax}", string.IsNullOrEmpty(arc.Fax) ? "." : arc.Fax);
                objBuilder.Replace("{Tel}", string.IsNullOrEmpty(arc.Telephone) ? "." : arc.Telephone);
                objBuilder.Replace("{ARC}", arcAdd);
            }

            objBuilder.Replace("{Username}", Session[enumSessions.User_Name.ToString()].ToString());
            objBuilder.Replace("{UserEmail}", Session[enumSessions.User_Email.ToString()].ToString());
            // OrderDetails
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            var products = db.USP_GetBasketProductsOnCheckOut(orderId).ToList();
            if (products != null && products.Count > 0)
            {
                string chipNos = String.Empty;
                //String PSTNNo = String.Empty;  
                int countOption = 1;
                // Count if product have any options
                foreach (var prod in products)
                {
                    int rowCount = db.USP_GetBasketProductsOnCheckOut(orderId).Where(i => i.ProductCode == prod.ProductCode.Trim()).Count();
                    ProductsList += "<tr><td style=\"background: #FFF7F7\">" + prod.ProductCode + "</td><td>" + prod.ProductName + "</td> <td style=\"background: #FFF7F7\">" + prod.ProductQty + "</td><td>£" + prod.Price;
                    if (prod.ProductType == "Product")
                    {

                        chipNos = "";
                        var ChipNumbers = db.USP_GetBasketGPRSChipNumbersByProductId(orderId, prod.ProductId, prod.CategoryId).Where(o => o.OptionId == prod.OptionId);
                        if (ChipNumbers != null)
                        {
                            foreach (var chipno in ChipNumbers)
                            {
                                chipNos += string.IsNullOrEmpty(chipno.GPRSNo) ? "" : chipno.GPRSNo + "-";
                                chipNos += string.IsNullOrEmpty(chipno.PSTNNo) ? "" : chipno.PSTNNo + "-";
                                chipNos += string.IsNullOrEmpty(chipno.GSMNo) ? "" : chipno.GSMNo + "-";  //added GSM NO(PanelID) in email
                                chipNos += string.IsNullOrEmpty(chipno.OptionName) ? "" : chipno.OptionName;
                                chipNos += ",";

                                if (chipno.PSTNNo == "" && chipno.OptionName == "" && chipno.GSMNo == "")//added GSM NO(PanelID) in email
                                {
                                    chipNos = chipNos.Remove(chipNos.Length - 2, 1);
                                }

                            }
                            if (chipNos != "")
                            {
                                chipNos = chipNos.Substring(0, chipNos.Length - 1);
                                ProductsList += "</td> <td style=\"background: #FFF7F7\">" + chipNos + "</td> </td></tr>";
                            }
                            else
                            {
                                ProductsList += "</td> <td style=\"background: #FFF7F7\">Chip Numbers : Not Provided</td></tr>";
                            }

                        }

                        if (rowCount == 1)
                        {
                            var dependentproducts = db.USP_GetBasketDependentProductsByProductId(orderId, prod.ProductId, prod.CategoryId).ToList();
                            if (dependentproducts != null && dependentproducts.Count > 0)
                            {
                                foreach (var dp in dependentproducts)
                                {
                                    ProductsList += "<tr><td>" + dp.ProductCode + "</td><td>" + dp.ProductName + "</td><td>" + dp.ProductQty + "</td><td>£" + dp.Price + "</tr>";

                                }
                            }
                            countOption = 0;
                        }
                        else if (rowCount == countOption)
                        {
                            var dependentproducts = db.USP_GetBasketDependentProductsByProductId(orderId, prod.ProductId, prod.CategoryId).ToList();
                            if (dependentproducts != null && dependentproducts.Count > 0)
                            {
                                foreach (var dp in dependentproducts)
                                {
                                    ProductsList += "<tr><td>" + dp.ProductCode + "</td><td>" + dp.ProductName + "</td><td>" + dp.ProductQty + "</td><td>£" + dp.Price + "</tr>";
                                }
                            }
                        }
                    }
                    countOption++;
                }
            }

            OrderDTO objorder = CSLOrderingARCBAL.BAL.OrdersBAL.GetOrderDetail(orderId);
            objBuilder.Replace("{OrderTotal}", "£" + (string.IsNullOrEmpty(objorder.OrderTotal) ? "0" : objorder.OrderTotal));
            objBuilder.Replace("{DeliveryTotal}", "£" + (string.IsNullOrEmpty(objorder.DeliveryCost) ? "0" : objorder.DeliveryCost));
            objBuilder.Replace("{VAT}", "£" + (string.IsNullOrEmpty(objorder.VATAmount) ? "0" : objorder.VATAmount));
            objBuilder.Replace("{TotalToPay}", "£" + (string.IsNullOrEmpty(objorder.TotalAmountToPay) ? "0" : objorder.TotalAmountToPay));
            objBuilder.Replace("{DeliveryTypeName}", deliveryTypes);
            objBuilder.Replace("{DeliveryTypePrice}", "£" + (string.IsNullOrEmpty(deliveryCostTotal) ? "0" : deliveryCostTotal));
            objBuilder.Replace("{Installer}", InstallerBAL.GetAddressHTML2LineForEmail(installerCompanyId));
            if (objorder.InstallationAddressId>0)
            {
                instadd_differs = true;
            }
            else
            {
                instadd_differs = false;
            }
            if (instadd_differs)
            {
               // string InsAdd = InstallerBAL.GetAddressHTML2LineForEmail(orderId);
                string InsAdd = objorder.InstallationAddressId.HasValue?InstallerBAL.GetAddressHTML2LineForEmail(objorder.InstallationAddressId.Value):"Not Available";
                objBuilder.Replace("{InstallerAddress}", "<td><div style=\"width: 100%; margin: 0; padding: 0;\"><table border=\"0\" cellpadding=\"5\" cellspacing=\"0\" width=\"100%\"><tr><td style=\"text-align: left\"> <font color=\"#888\" size=\"2\" face=\"Arial\">" + InsAdd + " </font></td></tr></table></div></td>");
                objBuilder.Replace("{HeadingInstallerAdd}", "<td><h3 style=\"font-size:11px; text-align: center; margin: 0; padding: 5px auto;\">Installation Address</h3></td>");
            }
            else
            {
                objBuilder.Replace("{InstallerAddress}", "");
                objBuilder.Replace("{HeadingInstallerAdd}", "");
            }
            objBuilder.Replace("{DeliveredTo}", OrdersBAL.GetDeliveryAddressHTML2Line(orderId));
            objBuilder.Replace("{SpecialInstructions}", string.Empty);

            var distinctProduct = products.Select(i => i.ProductCode).Distinct();

            foreach (var pro in distinctProduct)
            {
                products = db.USP_GetBasketProductsOnCheckOut(orderId).Where(p => p.ProductCode == pro).Take(1).ToList();

                foreach (var prod in products)
                {
                    if (prod.IsCSDUser == true)
                    {
                        ProductsList += "<tr><td>" + prod.ProductCode + "</td><td>" + prod.Message + "</td></tr>";
                    }
                }
            }

            objBuilder.Replace("{ProductList}", ProductsList);

            CSLOrderingEmail CSLorderingemail = new CSLOrderingEmail();
            CSLorderingemail.OrderNo = OrderNo;
            CSLorderingemail.Subject = mailSubject;
            CSLorderingemail.MailFrom = mailFrom;
            CSLorderingemail.MailTo = mailTO;
            CSLorderingemail.MailCC = _mailCC;
            CSLorderingemail.Body = Convert.ToString(objBuilder.ToString());
            CSLorderingemail.MsgType = "SendEmailwithPrice";
            CSLorderingemail.InsertedOn = System.DateTime.Now;
            CSLorderingemail.Sync_Status = Convert.ToChar("A");

            //Below is un commented by Atiq on 23-01-2017 because we have to live it existing email functionality.
            db.CSLOrderingEmails.InsertOnSubmit(CSLorderingemail);
            db.SubmitChanges();
            db.Dispose();

            //Commented below code by Atiq on 23-01-2017 because it will be used when implment msmq on live.
            //SendEmailMessageToMSMQ.SendEmailToCustomer(CSLorderingemail);
            //HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "SendEmailWithoutPrice", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }
    public void SendEmailWithoutPrice(string OrderNo, string mailTO, string _mailCC, string orderRefNo, string deliveryTypes, string deliveryCostTotal, int orderId, Guid installerCompanyId)
    {
        try
        {
            String ProductsList = "";
            string mailSubject = "Order Confirmation - Order Ref: " + OrderNo;
            String mailHtml = ReadTemplates.ReadMailTemplate(Server.MapPath("Template"), "EmailTemplatewithoutprice.html");
            StringBuilder objBuilder = new StringBuilder();
            objBuilder.Append(mailHtml);
            objBuilder.Replace("{OrderNo}", OrderNo);
            objBuilder.Replace("{OrderDate}", DateTime.Now.ToString("dd-MMM-yyyy").ToUpper());
            objBuilder.Replace("{OrderRef}", string.IsNullOrEmpty(orderRefNo) ? "." : orderRefNo);

            ARC arc = ArcBAL.GetArcInfoByUserId(new Guid(Session[enumSessions.User_Id.ToString()].ToString()));
            string arcAdd = "";

            if (arc != null)
            {
                arcAdd = arc.CompanyName == null ? "" : arc.CompanyName + ",&nbsp;";
                arcAdd += arc.AddressOne + ", <br /> ";
                arcAdd += string.IsNullOrEmpty(arc.AddressTwo) ? "" : arc.AddressTwo + ",&nbsp;";
                arcAdd += string.IsNullOrEmpty(arc.Town) ? "" : arc.Town + ",<br /> ";
                arcAdd += string.IsNullOrEmpty(arc.County) ? "" : arc.County + ", ";
                arcAdd += string.IsNullOrEmpty(arc.PostCode) ? "" : arc.PostCode + " <br />";
                objBuilder.Replace("{Fax}", string.IsNullOrEmpty(arc.Fax) ? "." : arc.Fax);
                objBuilder.Replace("{Tel}", string.IsNullOrEmpty(arc.Telephone) ? "." : arc.Telephone);
                objBuilder.Replace("{ARC}", arcAdd);
            }

            objBuilder.Replace("{Username}", Session[enumSessions.User_Name.ToString()].ToString());
            objBuilder.Replace("{UserEmail}", Session[enumSessions.User_Email.ToString()].ToString());

            // OrderDetails
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            var products = db.USP_GetBasketProducts(orderId).ToList();
            if (products != null && products.Count > 0)
            {
                string chipNos = "";
                int countOption = 1;
                int tempProductId = 0;
                int count = 1;
                foreach (var prod in products)
                {
                    ProductsList += "<tr><td style=\"background: #FFF7F7\">" + prod.ProductCode + "</td><td>" + prod.ProductName + "</td> <td style=\"background: #FFF7F7\">" + prod.ProductQty + "</td>";

                    if (count == 1)
                    {
                        tempProductId = prod.ProductId;
                    }

                    if (tempProductId != prod.ProductId)
                    {
                        count = 1;
                        tempProductId = prod.ProductId;
                    }
                    if (prod.ProductType == "Product")
                    {
                        chipNos = "";
                        var ChipNumbers = db.USP_GetBasketGPRSChipNumbersByProductId(orderId, prod.ProductId, prod.CategoryId);

                        if (ChipNumbers != null)
                        {

                            foreach (var chipno in ChipNumbers)
                            {

                                chipNos += string.IsNullOrEmpty(chipno.GPRSNo) ? "" : chipno.GPRSNo + "-";
                                chipNos += string.IsNullOrEmpty(chipno.PSTNNo) ? "" : chipno.PSTNNo + "-";
                                chipNos += string.IsNullOrEmpty(chipno.PSTNNo) ? "" : chipno.GSMNo + "-";  //added GSM NO(PanelID) in email
                                chipNos += string.IsNullOrEmpty(chipno.OptionName) ? "" : chipno.OptionName;
                                chipNos += ",";

                                if (chipno.PSTNNo == "" && chipno.OptionName == "" && chipno.GSMNo == "") //added GSM NO(PanelID) in email
                                {
                                    chipNos = chipNos.Remove(chipNos.Length - 2, 1);
                                }
                            }

                            if (chipNos != "")
                            {
                                chipNos = chipNos.Substring(0, chipNos.Length - 1);
                                ProductsList += "</td> <td style=\"background: #FFF7F7\">" + chipNos + "</td> </td></tr>";
                            }
                            else
                            {
                                ProductsList += "</td> <td style=\"background: #FFF7F7\">Chip Numbers : Not Provided</td></tr>";
                            }


                        }

                        // Count if product have any options 
                        int rowCount = db.USP_GetBasketProductsOnCheckOut(orderId).Where(i => i.ProductCode == prod.ProductCode.Trim()).Count();

                        if (rowCount == 1)
                        {
                            var dependentproducts = db.USP_GetBasketDependentProductsByProductId(orderId, prod.ProductId, prod.CategoryId).ToList();
                            if (dependentproducts != null && dependentproducts.Count > 0)
                            {
                                foreach (var dp in dependentproducts)
                                {
                                    ProductsList += "<tr><td>" + dp.ProductCode + "</td><td>" + dp.ProductName + "</td><td>" + dp.ProductQty + "</td><td> N.A </tr>";
                                }
                            }
                            countOption = 0;
                        }
                        else if (rowCount == countOption)
                        {
                            var dependentproducts = db.USP_GetBasketDependentProductsByProductId(orderId, prod.ProductId, prod.CategoryId).ToList();
                            if (dependentproducts != null && dependentproducts.Count > 0)
                            {
                                foreach (var dp in dependentproducts)
                                {
                                    ProductsList += "<tr><td>" + dp.ProductCode + "</td><td>" + dp.ProductName + "</td><td>" + dp.ProductQty + "</td><td> N.A </tr>";
                                }
                            }

                        }

                        if (tempProductId == prod.ProductId)
                        {
                            count++;
                        }

                    }
                    else
                    {
                        ProductsList += "</td> <td style=\"background: #FFF7F7\">N.A</td></tr>";
                    }

                    countOption++;
                }
            }
            objBuilder.Replace("{DeliveryTypeName}", deliveryTypes);
            objBuilder.Replace("{DeliveryTypePrice}", deliveryCostTotal);
            objBuilder.Replace("{Installer}", InstallerBAL.GetAddressHTML2LineForEmail(installerCompanyId));
            OrderDTO objorder = CSLOrderingARCBAL.BAL.OrdersBAL.GetOrderDetail(orderId);
            if (instadd_differs)
            {
               // string InsAdd = InstallerBAL.GetAddressHTML2LineForEmail(orderId);   
                string InsAdd = objorder.InstallationAddressId.HasValue?InstallerBAL.GetAddressHTML2LineForEmail(objorder.InstallationAddressId.Value):"Not Available";  
                objBuilder.Replace("{InstallerAddress}", "<td><div style=\"width: 100%; margin: 0; padding: 0;\"><table border=\"0\" cellpadding=\"5\" cellspacing=\"0\" width=\"100%\"><tr><td style=\"text-align: left\"> <font color=\"#888\" size=\"2\" face=\"Arial\">" + InsAdd + " </font></td></tr></table></div></td>");
                objBuilder.Replace("{HeadingInstallerAdd}", "<td><h3 style=\"font-size:13px; text-align: center; margin: 0; padding: 5px auto;\">Installation Address</h3></td>");

            }
            else
            {
                objBuilder.Replace("{InstallerAddress}", "");
                objBuilder.Replace("{HeadingInstallerAdd}", "");

            }
            objBuilder.Replace("{DeliveredTo}", OrdersBAL.GetDeliveryAddressHTML2Line(orderId));
            objBuilder.Replace("{SpecialInstructions}", "");


            var distinctProduct = products.Select(i => i.ProductCode).Distinct();

            foreach (var pro in distinctProduct)
            {
                products = db.USP_GetBasketProducts(orderId).Where(p => p.ProductCode == pro).Take(1).ToList();

                foreach (var prod in products)
                {
                    if (prod.IsCSDUser == true)
                    {
                        ProductsList += "<tr><td>" + prod.ProductCode + "</td><td>" + prod.Message + "</td></tr>";
                    }
                }
            }

            objBuilder.Replace("{ProductList}", ProductsList);

            CSLOrderingEmail CSLorderingemail = new CSLOrderingEmail();
            CSLorderingemail.OrderNo = OrderNo;
            CSLorderingemail.Subject = mailSubject;
            CSLorderingemail.MailFrom = mailFrom;
            CSLorderingemail.MailTo = mailTO;
            CSLorderingemail.MailCC = _mailCC;
            CSLorderingemail.Body = Convert.ToString(objBuilder.ToString());
            CSLorderingemail.MsgType = "SendEmailwithoutPrice";
            CSLorderingemail.InsertedOn = System.DateTime.Now;
            CSLorderingemail.Sync_Status = Convert.ToChar("A");

            //Below is un commented by Atiq on 23-01-2017 because we have to live it existing email functionality.
            db.CSLOrderingEmails.InsertOnSubmit(CSLorderingemail);
            db.SubmitChanges();
            db.Dispose();

            //Commented below code by Atiq on 23-01-2017 because it will be used when implment msmq on live.
            //SendEmailMessageToMSMQ.SendEmailToCustomer(CSLorderingemail);
            //HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            using (db = new CSLOrderingARCBAL.LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "SendEmailWithoutPrice", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
    }
    */
}