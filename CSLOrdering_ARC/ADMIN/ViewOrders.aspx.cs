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
using System.Text;
using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;
using System.Net.Mail;
using System.IO;
using System.Globalization;
using System.Web.Security;

public partial class ADMIN_ViewOrders : System.Web.UI.Page
{
    LinqToSqlDataContext db;
    static String Useremail = "";
    static string OrderNO = "";
    static Guid CreatedBy = Guid.Empty;
    static string UserName = "";
    static string smtphost = "";
    static string mailFrom = "";
    static string mailCC = "";
    static string mailTO = "";
    static int? InstallationAddId = 0;
    static string InstallerId = "";
    bool instadd_differs = false;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                Session[enumSessions.PreviousOrderId.ToString()] = null;
                LoadData();
                LoadPreviousOrders();
            }
            divDetails.Visible = false;
        }
        catch (System.Threading.ThreadAbortException ex)
        {
            //
        }
        catch (Exception objException)
        {
            LinqToSqlDataContext db;
            db = new LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }
    }

    void LoadPreviousOrders()
    {
        LoadOrders();
    }

    void LoadData()
    {


        //binding arc in dropdown

        db = new LinqToSqlDataContext();
        ddlarc.DataSource = (from arc in db.ARCs
                             where arc.IsDeleted == false
                             orderby arc.CompanyName
                             select new { arc.ARCId, ARCDisp = arc.CompanyName + " - [" + arc.ARC_Code + "]" });
        ddlarc.DataTextField = "ARCDisp";
        ddlarc.DataValueField = "ARCId";
        ddlarc.DataBind();
        System.Web.UI.WebControls.ListItem li = new System.Web.UI.WebControls.ListItem();
        li.Text = "--Select--";
        li.Value = "-1";
        ddlarc.Items.Insert(0, li);
        ddlarc.SelectedIndex = 0;

        //binding products to dropdown

        db = new LinqToSqlDataContext();
        ddlpro.DataSource = (from prod in db.Products
                             where prod.IsDeleted == false &&
                             prod.IsDependentProduct == false
                             orderby prod.ListOrder
                             select new { prod.ProductId, ProductDisp = prod.ProductName + " - [" + prod.ProductCode + "]" });
        ddlpro.DataTextField = "ProductDisp";
        ddlpro.DataValueField = "ProductId";
        ddlpro.DataBind();
        System.Web.UI.WebControls.ListItem li2 = new System.Web.UI.WebControls.ListItem();
        li2.Text = "--Select--";
        li2.Value = "-1";
        ddlpro.Items.Insert(0, li2);
        ddlpro.SelectedIndex = 0;

        //binding Categories to dropdown

        db = new LinqToSqlDataContext();
        ddlctg.DataSource = (from ctg in db.Categories
                             where ctg.IsDeleted == false
                             orderby ctg.ListOrder
                             select new { ctg.CategoryId, CtgDisp = ctg.CategoryName + "- [" + ctg.CategoryCode + "] " });
        ddlctg.DataTextField = "CtgDisp";
        ddlctg.DataValueField = "CategoryId";
        ddlctg.DataBind();
        System.Web.UI.WebControls.ListItem li3 = new System.Web.UI.WebControls.ListItem();
        li3.Text = "--Select--";
        li3.Value = "-1";
        ddlctg.Items.Insert(0, li3);
        ddlctg.SelectedIndex = 0;

    }

    protected void gvOrders_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            gvOrders.PageIndex = e.NewPageIndex;
            LoadPreviousOrders();
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvOrders_PageIndexChanging", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }

    }

    protected void gvOrders_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            e.Row.Attributes.Add("onclick", ClientScript.GetPostBackClientHyperlink(this.gvOrders, "Select$" + e.Row.RowIndex.ToString()));
            //  e.Row.Attributes.Add("onmouseover", "this.style.background = '#cccccc'");
            // e.Row.Attributes.Add("onmouseout", "this.style.background = 'none'");
        }
    }

    protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            int OrderId = 0;
            string sortingCommand = Convert.ToString(e.CommandArgument);
            if (e.CommandName == "Select")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = gvOrders.Rows[index];

                OrderId = Convert.ToInt32(gvOrders.DataKeys[index].Value.ToString());

                Session[enumSessions.PreviousOrderId.ToString()] = OrderId;
                LoadOrderDetails();
                LoadBasketProducts();
            }
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvOrders_RowCommand", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }
    }

    void LoadOrderDetails()
    {
        divDetails.Visible = true;
      //  lblInstAddress.Text = InstallerBAL.GetAddressHTML2LineForEmail(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString()));
        lblDelAddress.Text = OrdersBAL.GetDeliveryAddressHTML2Line(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString()));

        OrderDTO dto = new OrderDTO();
        dto = OrdersBAL.GetOrderDetail(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()]));

        if (dto != null)
        {
            lblSpecialInst.Text = dto.SpecialInstructions;
            lblOrderDate.Text = dto.OrderDate.ToString("dd-MMM-yyyy").ToUpper();
            lblCSLOrderNo.Text = dto.CSLOrderNo;
            lblARCOrderRefNo.Text = dto.ARCOrderRefNo;
            lblDelType.Text = dto.DeliveryType;
            lblDeliveryTotal.Text = dto.DeliveryCost;
            lblOrderQty.Text = dto.OrderQty;
            lblDtlsOrderTotal.Text = dto.OrderTotal;
            lblDtlsDeliveryTotal.Text = dto.DeliveryCost;
            lblDtlsVAT.Text = dto.VATAmount;
            lblDtlsTotalToPay.Text = dto.TotalAmountToPay;
            Useremail = dto.UserEmail.ToString();
            txtNewMail.Text = Useremail.Trim();
            hidUserEmail.Value = Useremail.Trim();  
            OrderNO = dto.CSLOrderNo;
            CreatedBy = dto.UserId;
            hidUserID.Value = dto.UserId.ToString();
            UserName = dto.UserName;
            hidUserName.Value = dto.UserName;
            InstallerId = dto.InstallerId;
            InstallationAddId = dto.InstallationAddressId;


        }

        lblInstAddress.Text =InstallationAddId.HasValue? InstallerBAL.GetAddressHTML2LineForEmail(InstallationAddId.Value):"Not Available"; //Priya
        if (Session[enumSessions.User_Role.ToString()] != null && Session[enumSessions.User_Role.ToString()].ToString() == enumRoles.ARC_Admin.ToString())
        {
            lblDeliveryTotal.Text = "0.00";
            lblDtlsOrderTotal.Text = "0.00";
            lblDtlsDeliveryTotal.Text = "0.00";
            lblDtlsVAT.Text = "0.00";
            lblDtlsTotalToPay.Text = "0.00";

        }
        //check role of the user
        if (Roles.IsUserInRole(UserName, enumRoles.ARC_Admin.ToString()))
        {
            rbtnwithoutprice.Checked = true;
            rbtnwithprice.Checked = false;

        }

    }


    void LoadBasketProducts()
    {
        LinqToSqlDataContext db = new LinqToSqlDataContext();
        dlProducts.DataSource = db.USP_GetBasketProductsOnPreviousOrders_Ordering(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString()));
        dlProducts.DataBind();
        db.Dispose();
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
                if (Session[enumSessions.User_Role.ToString()] != null && Session[enumSessions.User_Role.ToString()].ToString() == enumRoles.ARC_Admin.ToString())
                {
                    Label lblProductPrice = (Label)args.Item.FindControl("lblProductPrice");
                    lblProductPrice.Text = "0.00";

                    Label lblProductPriceTotal = (Label)args.Item.FindControl("lblProductPriceTotal");
                    lblProductPriceTotal.Text = "0.00";
                }

                Label lblProductCode = (Label)args.Item.FindControl("lblProductCode");
                int rowCount = db.USP_GetBasketProductsOnCheckOut(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString())).Where(i => i.ProductCode == lblProductCode.Text.Trim()).Count();
                if (rowCount == count)
                {
                    USP_GetBasketProductsOnPreviousOrders_OrderingResult product = (USP_GetBasketProductsOnPreviousOrders_OrderingResult)args.Item.DataItem;
                    Repeater rep = (Repeater)args.Item.FindControl("rptrDependentProducts");

                    rep.DataSource = db.USP_GetPreviousOrdersDependentProductsByProductId(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString()), product.ProductId, product.CategoryId);
                    rep.DataBind();

                    if (rep.Items.Count == 0)
                        rep.Visible = false;
                    db.Dispose();
                }
                count++;

                Repeater dlProducts = (Repeater)args.Item.FindControl("rptrItemDetails");

                HiddenField hdnOrderItemId = args.Item.FindControl("hdnOrderItemId") as HiddenField;
                db = new LinqToSqlDataContext();
                //List<OrderItemDetailsDTO> objItemDetails = new List<OrderItemDetailsDTO>();
                //objItemDetails = CSLOrderingARCBAL.BAL.OrdersBAL.GetOrderDetailsforReport(Convert.ToInt32(hdnOrderItemId.Value));
                if (db.USP_GetOrderDetailsforReport( Convert.ToInt32(hdnOrderItemId.Value)).Count() > 0)
                {
                    dlProducts.DataSource = db.USP_GetOrderDetailsforReport(Convert.ToInt32(hdnOrderItemId.Value));
                    dlProducts.DataBind();
                }
                else
                {

                    // HtmlControl trrptrItemDetails = args.Item.FindControl("trrptrItemDetails") as HtmlControl;
                    // trrptrItemDetails.Visible = false;
                }
            }

            if (args.Item.ItemType == ListItemType.Footer)
            {
                Label lblTotalPrice = (Label)args.Item.FindControl("lblTotalPrice");
                Label lblTotalQty = (Label)args.Item.FindControl("lblTotalQty");

                lblTotalPrice.Text = lblDtlsOrderTotal.Text;
                lblTotalQty.Text = lblOrderQty.Text;

                if (Session[enumSessions.User_Role.ToString()] != null && Session[enumSessions.User_Role.ToString()].ToString() == enumRoles.ARC_Admin.ToString())
                {
                    lblTotalPrice.Text = "0.00";
                    lblDtlsOrderTotal.Text = "0.00";
                    lblDtlsTotalToPay.Text = "0.00";
                }
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
                    lblProductPrice.Text = "0.00";

                    Label lblProductPriceTotal = (Label)args.Item.FindControl("lblProductPriceTotal");
                    lblProductPriceTotal.Text = "0.00";
                }
            }
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "rptrDependentProducts_ItemBound", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }
    }


    protected void btnShow_Click(object sender, EventArgs e)
    {
        Page.Validate();
        if (Page.IsValid)
        {
            LoadOrders();
        }


    }

    public void LoadOrders()
    {


        DateTime? fromDate = DateTime.Now.AddDays(-365);
        DateTime? toDate = DateTime.Now;
        List<OrderDTO> orderDTOList = new List<OrderDTO>();
        OrderDTO order = new OrderDTO();


        if (!string.IsNullOrEmpty(txtfromDate.Text.Trim()))
        {
            fromDate = Convert.ToDateTime(txtfromDate.Text.Trim());

        }

        if (!string.IsNullOrEmpty(txttoDate.Text.Trim()))
        {
            toDate = Convert.ToDateTime(txttoDate.Text.Trim());

        }
        order.orderfromdate = fromDate;
        order.ordertodate = toDate;
        order.orderprodid = Convert.ToInt32(ddlpro.SelectedValue);
        order.orderctgid = Convert.ToInt32(ddlctg.SelectedValue);
        order.orderarcid = Convert.ToInt32(ddlarc.SelectedValue);
        order.CSLOrderNo = txtOrderNO.Text.Trim();
        order.ChipNo = txtChipNo.Text.Trim();
        orderDTOList = OrdersBAL.GetPreviousOrdersAdmin(order);
        gvOrders.DataSource = orderDTOList;
        gvOrders.DataBind();

    }

    protected void Btnemail_Click(object sender, EventArgs e)
    {
        try
        {
            /////
            SendEmailDTO sendEmaildto = new SendEmailDTO();

            sendEmaildto.ARCOrderRefNo = lblARCOrderRefNo.Text;
            sendEmaildto.orderDate = lblOrderDate.Text;
            sendEmaildto.userID = hidUserID.Value;
            sendEmaildto.userName = hidUserName.Value;
            sendEmaildto.userEmail = hidUserEmail.Value;
            sendEmaildto.orderID = Session[enumSessions.PreviousOrderId.ToString()].ToString();
            sendEmaildto.DdeliveryType = lblDelType.Text;
            sendEmaildto.deliveryCost = lblDeliveryTotal.Text;
            sendEmaildto.installerID = InstallerId;
           // sendEmaildto.InstallationAddId = InstallationAddId;
            sendEmaildto.specialInstructions = lblSpecialInst.Text;
            
          //  if(InstallationAddId!=0)
           // {
             //   sendEmaildto.instadd_differs = true;
            //}
            ////


            ApplicationDTO appdto;
            // Session[enumSessions.PreviousOrderId.ToString()] 

                //commented as we are enetring it in cslorderingmeailtable
            //if (string.IsNullOrEmpty((string)HttpRuntime.Cache["smtphost"]))
            //{
            //    AppSettings appsett = new AppSettings();
            //    appdto = appsett.GetAppValues();
            //    smtphost = appdto.smtphost;
            //}
            //else
            //    smtphost = (string)HttpRuntime.Cache["smtphost"];


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


             SendEmail.SendEmailWithPrice(OrderNO, mailTO,sendEmaildto,mailFrom,mailCC,true,false ,0);

            if (rbtnwithoutprice.Checked == true)
            {
                SendEmail.SendEmailWithoutPrice(OrderNO, txtNewMail.Text.ToString(),sendEmaildto,mailFrom,mailCC,true,false,0);
            }
            else
            {
                 SendEmail.SendEmailWithPrice(OrderNO, txtNewMail.Text.ToString(),sendEmaildto,mailFrom,mailCC,true,false,0);
            }


        }
        catch (Exception objException)
        {
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "Btnemail_Click", Convert.ToString(objException.Message), 
                Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", 
                HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }


    /*  public void SendEmailWithoutPrice(string OrderNo, string mailTO)
      {
          try
          {
              String ProductsList = "";
              string subjectsuffix = string.Empty;
              if (mailTO.EndsWith("@csldual.com")) { subjectsuffix = "; Email Resent"; }

              string mailSubject = "Order Confirmation - Order Ref: " + OrderNo + subjectsuffix;
              String mailHtml = ReadTemplates.ReadMailTemplate(Server.MapPath("../Template"), "EmailTemplatewithoutprice.html");
              StringBuilder objBuilder = new StringBuilder();
              objBuilder.Append(mailHtml);
              objBuilder.Replace("{OrderNo}", OrderNo);
              objBuilder.Replace("{OrderDate}", DateTime.Now.ToString("dd-MMM-yyyy").ToUpper());
              objBuilder.Replace("{OrderRef}", string.IsNullOrEmpty(lblARCOrderRefNo.Text) ? "." : lblARCOrderRefNo.Text);

              ARC arc = ArcBAL.GetArcInfoByUserId(new Guid(hidUserID.Value));
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


              objBuilder.Replace("{Username}", hidUserName.Value);
              objBuilder.Replace("{UserEmail}", hidUserEmail.Value);
              LinqToSqlDataContext db = new LinqToSqlDataContext();
              var products = db.USP_GetBasketProducts(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString())).ToList();
              if (products != null && products.Count > 0)
              {
                  string chipNos = "";
                  int countOption = 1;

                  foreach (var prod in products)
                  {
                      int rowCount = db.USP_GetBasketProductsOnCheckOut(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString())).Where(i => i.ProductCode == prod.ProductCode.Trim()).Count();

                      ProductsList += "<tr><td style=\"background: #FFF7F7\">" + prod.ProductCode + "</td><td>" + prod.ProductName + "</td> <td style=\"background: #FFF7F7\">" + prod.ProductQty + "</td>";

                      if (prod.ProductType == "Product")
                      {
                          chipNos = "";
                          var ChipNumbers = db.USP_GetBasketGPRSChipNumbersByProductId(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString()), prod.ProductId, prod.CategoryId).ToList();

                          if (ChipNumbers != null && ChipNumbers.Count > 0)
                          {
                              foreach (var chipno in ChipNumbers)
                              {
                                  if (String.IsNullOrEmpty(chipno.PSTNNo))
                                  {
                                      chipNos += string.IsNullOrEmpty(chipno.GPRSNo) ? "" : chipno.GPRSNo;
                                      chipNos += string.IsNullOrEmpty(chipno.PSTNNo) ? "" : chipno.PSTNNo;
                                      chipNos += string.IsNullOrEmpty(chipno.OptionName) ? "" : chipno.OptionName;
                                      chipNos += ",";
                                  }

                                  else if (String.IsNullOrEmpty(chipno.OptionName))
                                  {
                                      chipNos += string.IsNullOrEmpty(chipno.GPRSNo) ? "" : chipno.GPRSNo + "-";
                                      chipNos += string.IsNullOrEmpty(chipno.PSTNNo) ? "" : chipno.PSTNNo;
                                      chipNos += string.IsNullOrEmpty(chipno.OptionName) ? "" : chipno.OptionName;
                                      chipNos += ",";
                                  }

                                  else if (!String.IsNullOrEmpty(chipno.OptionName))
                                  {
                                      chipNos += string.IsNullOrEmpty(chipno.GPRSNo) ? "" : chipno.GPRSNo + "-";
                                      chipNos += string.IsNullOrEmpty(chipno.PSTNNo) ? "" : chipno.PSTNNo + "-";
                                      chipNos += string.IsNullOrEmpty(chipno.OptionName) ? "" : chipno.OptionName;
                                      chipNos += ",";
                                  }

                              }

                              if (chipNos != "")
                              {
                                  chipNos = chipNos.Substring(0, chipNos.Length - 2);
                                  ProductsList += "</td> <td style=\"background: #FFF7F7\">" + chipNos + "</td></tr>";
                              }
                              else
                              {
                                  ProductsList += "</td> <td style=\"background: #FFF7F7\">Chip Numbers : Not Provided</td></tr>";
                              }
                          }


                          if (rowCount == 1)
                          {
                              var dependentproducts = db.USP_GetBasketDependentProductsByProductId(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString()), prod.ProductId, prod.CategoryId).ToList();
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

                              var dependentproducts = db.USP_GetBasketDependentProductsByProductId(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString()), prod.ProductId, prod.CategoryId).ToList();
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

              objBuilder.Replace("{DeliveryTypeName}", lblDelType.Text);
              objBuilder.Replace("{DeliveryTypePrice}", lblDeliveryTotal.Text);
              //updated the following after Ravi changed the method GetAddressHTML2LineForEmail
            //  objBuilder.Replace("{Installer}", InstallerBAL.GetAddressHTML2LineForEmail(new Guid(InstallerId)));
              objBuilder.Replace("{Installer}", InstallerBAL.GetAddressHTML2LineForEmail(new Guid(InstallerId)));
              OrderDTO objorder = CSLOrderingARCBAL.BAL.OrdersBAL.GetOrderDetail(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString()));
              if (InstallationAddId != 0)
              {
                  //string InsAdd = InstallerBAL.GetAddressHTML2LineForEmail(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString()));
                  string InsAdd = objorder.InstallationAddressId.HasValue?InstallerBAL.GetAddressHTML2LineForEmail(objorder.InstallationAddressId.Value):"Not Available";
                  objBuilder.Replace("{InstallerAddress}", "<td><div style=\"width: 100%; margin: 0; padding: 0;\"><table border=\"0\" cellpadding=\"5\" cellspacing=\"0\" width=\"100%\"><tr><td style=\"text-align: left\">" + InsAdd + "</td></tr></table></div></td>");
                  objBuilder.Replace("{HeadingInstallerAdd}", "<td><h3 style=\"text-align: center; margin: 0; padding: 5px auto;\">Installer Address</h3></td>");

              }
              else
              {
                  objBuilder.Replace("{InstallerAddress}", "");
                  objBuilder.Replace("{HeadingInstallerAdd}", "");

              }
              objBuilder.Replace("{DeliveredTo}", OrdersBAL.GetDeliveryAddressHTML2Line(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString())));
              objBuilder.Replace("{SpecialInstructions}", lblSpecialInst.Text);
              var distinctProduct = products.Select(i => i.ProductCode).Distinct();
              foreach (var pro in distinctProduct)
              {
                  products = db.USP_GetBasketProducts(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString())).Where(p => p.ProductCode == pro).Take(1).ToList();
                  foreach (var prod in products)
                  {
                      if (prod.IsCSDUser == true)
                      {
                          ProductsList += "<tr><td>" + prod.ProductCode + "</td><td>" + prod.Message + "</td></tr>";
                      }
                  }

              }
              objBuilder.Replace("{ProductList}", ProductsList);
              db.Dispose();
              if (mailTO != "" && mailTO.Trim() != "")
              {
                  //Below is un commented by Atiq on 23-01-2017 because we have to live it existing email functionality.
                
                  MailMessage message = new MailMessage();
                  string[] mailFromList = mailFrom.Split(',');
                  //only if mailCC from Applicationsetting is not empty. 
                  //Change made:priya- requested by Ravi
                  if (!string.IsNullOrEmpty(mailCC))
                  {
                      string[] mailCCList = mailCC.Split(',');
                      foreach (string email in mailCCList)
                      {
                          message.CC.Add(new MailAddress(email));
                      }
                  }
                  if (mailFromList.Length > 1)
                      return; // email From should be single only
                  else
                      message.From = new MailAddress(mailFrom);
                  message.To.Add(new MailAddress(mailTO));
                  message.Subject = mailSubject;
                  message.Body = Convert.ToString(objBuilder.ToString());
                  message.IsBodyHtml = true;
                  SmtpClient smtp = new SmtpClient(smtphost);
                  smtp.EnableSsl = false;
                  smtp.Send(message);

                  //Commented below code by Atiq on 23-01-2017 because will be used when implment msmq on live.
                  //
                  //Add below code to send the email message via msmq not smtp by Atiq on 06-01-2016 
                 // string emailCC = string.Empty;
                 // if (!string.IsNullOrEmpty(mailCC))
                 // {
                  //    string[] mailCCList = mailCC.Split(',');
                 //     foreach (string email in mailCCList)
                  //    {
                   //       emailCC = emailCC + ",";
                   //   }
                 // }
                
                //  if (!string.IsNullOrEmpty(emailCC))
                 //     emailCC = emailCC.TrimEnd(',');
                //  CSLOrderingEmail objEmailMessage = new CSLOrderingEmail();
                //  objEmailMessage.MailFrom = mailFrom;
                //  objEmailMessage.MailTo = mailTO;
                //  objEmailMessage.MailCC = emailCC;
                //  objEmailMessage.Subject = mailSubject;
                //  objEmailMessage.Body = objBuilder.ToString();
                //  SendEmailMessageToMSMQ.SendEmailToCustomer(objEmailMessage);
               //   //End Code sending email  to msmq.
                
              }
              HttpContext.Current.ApplicationInstance.CompleteRequest();
          }
          catch (Exception objException)
          {
              CSLOrderingARCBAL.LinqToSqlDataContext db;
              db = new CSLOrderingARCBAL.LinqToSqlDataContext();
              db.USP_SaveErrorDetails(Request.Url.ToString(), "SendEmailWithoutPrice", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
          }
      }


      public void SendEmailWithPrice(string OrderNo, string mailTO)
      {
          try
          {
              String ProductsList = "";
              string subjectsuffix = string.Empty; 
              if (mailTO.EndsWith("@csldual.com")){subjectsuffix = "; Email Resent";}
              string mailSubject = "Order Confirmation - Order Ref: " + OrderNo + subjectsuffix;
              String mailHtml = ReadTemplates.ReadMailTemplate(Server.MapPath("../Template"), "EmailTemplate.html");
              StringBuilder objBuilder = new StringBuilder();
              objBuilder.Append(mailHtml);
              objBuilder.Replace("{OrderNo}", OrderNo);
            //  objBuilder.Replace("{OrderDate}", DateTime.Now.ToString("dd-MMM-yyyy").ToUpper());
              objBuilder.Replace("{OrderDate}", string.IsNullOrEmpty(lblOrderDate.Text) ? "." : lblOrderDate.Text);
              objBuilder.Replace("{OrderRef}", string.IsNullOrEmpty(lblARCOrderRefNo.Text) ? "." : lblARCOrderRefNo.Text);

              ARC arc = ArcBAL.GetArcInfoByUserId(new Guid(hidUserID.Value));
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

              objBuilder.Replace("{Username}", hidUserName.Value);
              objBuilder.Replace("{UserEmail}", hidUserEmail.Value);

              // OrderDetails
              LinqToSqlDataContext db = new LinqToSqlDataContext();
              var products = db.USP_GetBasketProducts(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()])).ToList();

              if (products != null && products.Count > 0)
              {
                  string chipNos = "";
                  int countOption = 1;

                  foreach (var prod in products)
                  {
                      int rowCount = db.USP_GetBasketProductsOnCheckOut(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString())).Where(i => i.ProductCode == prod.ProductCode.Trim()).Count();

                      ProductsList += "<tr><td style=\"background: #FFF7F7\">" + prod.ProductCode + "</td><td>" + prod.ProductName + "</td> <td style=\"background: #FFF7F7\">" + prod.ProductQty + "</td><td>£" + prod.Price;

                      if (prod.ProductType == "Product")
                      {
                          chipNos = "";
                          var ChipNumbers = db.USP_GetBasketGPRSChipNumbersByProductId(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString()), prod.ProductId, prod.CategoryId).ToList();

                          if (ChipNumbers != null && ChipNumbers.Count > 0)
                          {
                              foreach (var chipno in ChipNumbers)
                              {
                                  if (String.IsNullOrEmpty(chipno.PSTNNo))
                                  {
                                      chipNos += string.IsNullOrEmpty(chipno.GPRSNo) ? "" : chipno.GPRSNo;
                                      chipNos += string.IsNullOrEmpty(chipno.PSTNNo) ? "" : chipno.PSTNNo;
                                      chipNos += string.IsNullOrEmpty(chipno.OptionName) ? "" : chipno.OptionName;
                                      chipNos += ",";
                                  }

                                  else if (String.IsNullOrEmpty(chipno.OptionName))
                                  {
                                      chipNos += string.IsNullOrEmpty(chipno.GPRSNo) ? "" : chipno.GPRSNo + "-";
                                      chipNos += string.IsNullOrEmpty(chipno.PSTNNo) ? "" : chipno.PSTNNo;
                                      chipNos += string.IsNullOrEmpty(chipno.OptionName) ? "" : chipno.OptionName;
                                      chipNos += ",";
                                  }

                                  else if (!String.IsNullOrEmpty(chipno.OptionName))
                                  {
                                      chipNos += string.IsNullOrEmpty(chipno.GPRSNo) ? "" : chipno.GPRSNo + "-";
                                      chipNos += string.IsNullOrEmpty(chipno.PSTNNo) ? "" : chipno.PSTNNo + "-";
                                      chipNos += string.IsNullOrEmpty(chipno.OptionName) ? "" : chipno.OptionName;
                                      chipNos += ",";
                                  }
                              }

                              if (chipNos.Replace(",", "") != "") 
                              {
                                  chipNos = chipNos.Substring(0, chipNos.Length - 2);
                                  ProductsList += "</td> <td style=\"background: #FFF7F7\">" + chipNos + "</td></tr>";
                              }
                              else
                              {
                                  ProductsList += "</td> <td style=\"background: #FFF7F7\">Chip Numbers : Not Provided</td></tr>";
                              }
                          }

                          if (rowCount == 1)
                          {
                              var dependentproducts = db.USP_GetBasketDependentProductsByProductId(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString()), prod.ProductId, prod.CategoryId).ToList();
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
                              var dependentproducts = db.USP_GetBasketDependentProductsByProductId(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString()), prod.ProductId, prod.CategoryId).ToList();
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

             OrderDTO objorder = CSLOrderingARCBAL.BAL.OrdersBAL.GetOrderDetail(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString()));
              //objBuilder.Replace("{OrderTotal}", Convert.ToDecimal(lblDtlsOrderTotal.Text).ToString("c"));
              objBuilder.Replace("{OrderTotal}", "£" + objorder.OrderTotal);
              //objBuilder.Replace("{DeliveryTotal}", Convert.ToDecimal(lblDtlsDeliveryTotal.Text).ToString("c"));
              objBuilder.Replace("{DeliveryTotal}", "£" + objorder.DeliveryCost);
              //objBuilder.Replace("{VAT}", Convert.ToDecimal(lblDtlsVAT.Text).ToString("c"));
              objBuilder.Replace("{VAT}", "£" + objorder.VATAmount);
              //objBuilder.Replace("{TotalToPay}", Convert.ToDecimal(lblDtlsTotalToPay.Text).ToString("c"));
              objBuilder.Replace("{TotalToPay}", "£" + objorder.TotalAmountToPay);
              objBuilder.Replace("{DeliveryTypeName}", string.IsNullOrEmpty(lblDelType.Text) ? "" : lblDelType.Text);
              objBuilder.Replace("{DeliveryTypePrice}", "£" + lblDeliveryTotal.Text);
              objBuilder.Replace("{Installer}", InstallerBAL.GetAddressHTML2LineForEmail(new Guid(InstallerId)));
              if (InstallationAddId != 0)
              {
                  //string InsAdd = InstallerBAL.GetAddressHTML2LineForEmail(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString()));
                  string InsAdd = objorder.InstallationAddressId.HasValue?InstallerBAL.GetAddressHTML2LineForEmail(objorder.InstallationAddressId.Value):"Not Available";
                  objBuilder.Replace("{InstallerAddress}", "<td><div style=\"width: 100%; margin: 0; padding: 0;\"><table border=\"0\" cellpadding=\"5\" cellspacing=\"0\" width=\"100%\"><tr><td style=\"text-align: left\">" + InsAdd + "</td></tr></table></div></td>");
                  objBuilder.Replace("{HeadingInstallerAdd}", "<td><h3 style=\"color: #f00; text-align: center; margin: 0; padding: 5px auto;\">Installer Address</h3></td>");

              }
              else
              {
                  objBuilder.Replace("{InstallerAddress}", "");
                  objBuilder.Replace("{HeadingInstallerAdd}", "");

              }
              objBuilder.Replace("{DeliveredTo}", OrdersBAL.GetDeliveryAddressHTML2Line(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString())));
              objBuilder.Replace("{SpecialInstructions}", lblSpecialInst.Text);
              objBuilder.Append("Email Resent");
              var distinctProduct = products.Select(i => i.ProductCode).Distinct();

              foreach (var pro in distinctProduct)
              {
                  products = db.USP_GetBasketProducts(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString())).Where(p => p.ProductCode == pro).Take(1).ToList();

                  foreach (var prod in products)
                  {
                      if (prod.IsCSDUser == true)
                      {
                          ProductsList += "<tr><td>" + prod.ProductCode + "</td><td>" + prod.Message + "</td></tr>";
                      }
                  }

              }
              objBuilder.Replace("{ProductList}", ProductsList);
              db.Dispose();
              if (mailTO != "" && mailTO.Trim() != "")
              {
                  MailMessage message = new MailMessage();
                  string[] mailFromList = mailFrom.Split(',');
                  string[] mailCCList = mailCC.Split(',');
                  string emailCC = string.Empty;
                  //Below is un commented by Atiq on 23-01-2017 because we have to live it existing email functionality.
                
                  if (mailFromList.Length > 1)
                      return; // email From should be single only
                  else
                      message.From = new MailAddress(mailFrom);
                  foreach (string email in mailCCList)
                  {
                      message.CC.Add(new MailAddress(email));
                  }

                  message.To.Add(new MailAddress(mailTO));
                  message.Subject = mailSubject;
                  message.Body = Convert.ToString(objBuilder.ToString());
                  message.IsBodyHtml = true;
                  //string smtphost = ConfigurationManager.AppSettings["smtphost"].ToString();
                  SmtpClient smtp = new SmtpClient(smtphost);
                  smtp.EnableSsl = false;
                  smtp.Send(message);

                  //Commented below code by Atiq on 23-01-2017 because will be used when implment msmq on live.
                  /*
                  //Add below code to send the email message via msmq not smtp by Atiq on 06-01-2016 
                  foreach (string email in mailCCList)
                  {
                      emailCC = emailCC + ",";
                  }
                  if (!string.IsNullOrEmpty(emailCC))
                      emailCC = emailCC.TrimEnd(',');
                  CSLOrderingEmail objEmailMessage = new CSLOrderingEmail();
                  objEmailMessage.MailFrom = mailFrom;
                  objEmailMessage.MailTo = mailTO;
                  objEmailMessage.MailCC = emailCC;
                  objEmailMessage.Subject = mailSubject;
                  objEmailMessage.Body = objBuilder.ToString();
                  SendEmailMessageToMSMQ.SendEmailToCustomer(objEmailMessage);
                  //End Code sending email  to msmq.
                  //
              }

              HttpContext.Current.ApplicationInstance.CompleteRequest();

          }
          catch (Exception objException)
          {
              CSLOrderingARCBAL.LinqToSqlDataContext db;
              db = new CSLOrderingARCBAL.LinqToSqlDataContext();
              db.USP_SaveErrorDetails(Request.Url.ToString(), "SendEmailWithPrice", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
          }
      }

  */
}