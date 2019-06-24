using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Data.Linq;
using System.Data.Linq.SqlClient;
using CSLOrderingARCBAL;
using CSLOrderingARCBAL.BAL;
using CSLOrderingARCBAL.Common;
using System.Configuration;
using System.Globalization;
using System.Text;
using System.Data;

public partial class ViewPreviousOrders : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Session[enumSessions.User_Id.ToString()] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
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
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "Page_Load", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }
    }

    void LoadPreviousOrders()
    {

        List<OrderDTO> orderDTOList = new List<OrderDTO>();
        orderDTOList = OrdersBAL.GetPreviousOrders(Session[enumSessions.User_Id.ToString()].ToString());
        gvOrders.DataSource = orderDTOList;
        gvOrders.DataBind();
    }

    protected void gvOrders_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            gvOrders.PageIndex = e.NewPageIndex;

            if ((!string.IsNullOrEmpty(txtfromDate.Text) && !string.IsNullOrEmpty(txtfromDate.Text)))
            {

                DateTime? fromDate = null;
                DateTime? toDate = null;
                List<OrderDTO> orderDTOList = new List<OrderDTO>();

                if (!string.IsNullOrEmpty(txtfromDate.Text))
                {
                    fromDate = Convert.ToDateTime(txtfromDate.Text);
                }

                if (!string.IsNullOrEmpty(txttoDate.Text))
                {

                    toDate = Convert.ToDateTime(txttoDate.Text);
                }

                orderDTOList = OrdersBAL.GetPreviousOrdersByDate(Convert.ToString(Session[enumSessions.User_Id.ToString()]), fromDate, toDate);
                gvOrders.DataSource = orderDTOList;
                gvOrders.DataBind();
            }

            else
            {
                LoadPreviousOrders();
            }

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
            e.Row.Attributes.Add("onmouseover", "this.style.background = '#cccccc'");
            e.Row.Attributes.Add("onmouseout", "this.style.background = 'none'");
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
                hdnSelectedOrderID.Value = OrderId.ToString();
                LoadOrderDetails(OrderId);
                LoadBasketProducts(OrderId);
            }
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "gvOrders_RowCommand", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }
    }

    public String strURLTracking;
    public String strURLDeliveyNotes;

    void LoadOrderDetails(int orderID)
    {
        int? installationAddressID = 0;
        divDetails.Visible = true;
      //  lblInstAddress.Text = InstallerBAL.GetAddressHTML2LineForEmail(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString()));
        lblDelAddress.Text = OrdersBAL.GetDeliveryAddressHTML2Line(orderID);

        OrderDTO dto = new OrderDTO();
        dto = OrdersBAL.GetOrderDetail(orderID);

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
            lblUserName.Text = dto.UserName;
            installationAddressID = dto.InstallationAddressId;
        }
        lblInstAddress.Text = installationAddressID.HasValue?InstallerBAL.GetAddressHTML2LineForEmail(installationAddressID.Value):"Not Available";
        List<string> tracknos = OrdersBAL.GetTrackingNoList(orderID);

        //STArt:ORD:31 getting the fex url from appsetting
        ApplicationDTO appdto;
        AppSettings appsett = new AppSettings();
        appdto = appsett.GetAppValues();
        foreach (string str in tracknos)
        {
            string fedexURL = appdto.FedexURL.Replace("@@trkno@@", str.Replace(" ", ""));            
            strURLTracking += "<a href=" + fedexURL + " target=_blank >" + str.Replace(" ", "") + "</a>" + " &nbsp;&nbsp;  ";
            //strURLTracking += "<a href=https://www.fedex.com/fedextrack/?tracknumbers=" + str + "&locale=en_GB&cntry_code=gb target=_blank >" + str + "</a>" + "  &nbsp;&nbsp;&nbsp;  ";

        }
        //END-ORD:31
        if (strURLTracking != null || !(string.IsNullOrEmpty(strURLTracking)))
            strURLTracking.Substring(0, strURLTracking.Length - 2);
        else
            strURLTracking = "No Tracks";

        // deliverynotes
        List<string> Deliverynotes = OrdersBAL.GetDeliveryNoteList(orderID);

        foreach (string note in Deliverynotes)
        {
            strURLDeliveyNotes = strURLDeliveyNotes + "<a >" + note + "</a>" + "  &nbsp;&nbsp;&nbsp;  ";
        }
        if (strURLDeliveyNotes != null || !(string.IsNullOrEmpty(strURLDeliveyNotes)))
            strURLDeliveyNotes.Substring(0, strURLDeliveyNotes.Length - 2);
        else
            strURLDeliveyNotes = "NA";

        if (Session[enumSessions.User_Role.ToString()] != null && Session[enumSessions.User_Role.ToString()].ToString() == enumRoles.ARC_Admin.ToString())
        {
            lblDeliveryTotal.Text = "0.00";
            lblDtlsOrderTotal.Text = "0.00";
            lblDtlsDeliveryTotal.Text = "0.00";
            lblDtlsVAT.Text = "0.00";
            lblDtlsTotalToPay.Text = "0.00";

        }
    }

    void LoadBasketProducts(int orderID)
    {
        LinqToSqlDataContext db = new LinqToSqlDataContext();
        dlProducts.DataSource = db.USP_GetBasketProductsOnPreviousOrders(orderID);
        dlProducts.DataBind();
        db.Dispose();
    }
    public int count = 1;
    protected void ProductsRepeater_ItemBound(object sender, RepeaterItemEventArgs args)
    {
        try
        {
            Session[enumSessions.PreviousOrderId.ToString()] = gvOrders.SelectedDataKey;

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
                int rowCount = db.USP_GetBasketProductsOnCheckOut(Convert.ToInt32(hdnSelectedOrderID.Value)).Where(i => i.ProductCode == lblProductCode.Text.Trim()).Count();
                if (rowCount == count)
                {
                    USP_GetBasketProductsOnPreviousOrdersResult product = (USP_GetBasketProductsOnPreviousOrdersResult)args.Item.DataItem;
                    Repeater rep = (Repeater)args.Item.FindControl("rptrDependentProducts");

                    rep.DataSource = db.USP_GetBasketDependentProductsByProductId(Convert.ToInt32(hdnSelectedOrderID.Value), product.ProductId, product.CategoryId);
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
            db.USP_SaveErrorDetails(Request.Url.ToString(), "ProductsRepeater_ItemBound", Convert.ToString(objException.Message), 
                Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "",
                HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

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
        try
        {
            if ((!string.IsNullOrEmpty(txtfromDate.Text) && !string.IsNullOrEmpty(txtfromDate.Text)))
            {

                DateTime? fromDate = null;
                DateTime? toDate = null;
                List<OrderDTO> orderDTOList = new List<OrderDTO>();

                if (!string.IsNullOrEmpty(txtfromDate.Text))
                {
                    fromDate = Convert.ToDateTime(txtfromDate.Text);
                    //  order.orderfromdate = fromDate;
                }

                if (!string.IsNullOrEmpty(txttoDate.Text))
                {

                    toDate = Convert.ToDateTime(txttoDate.Text);
                    // order.ordertodate = toDate;
                }


                orderDTOList = OrdersBAL.GetPreviousOrdersByDate(Convert.ToString(Session[enumSessions.User_Id.ToString()]), fromDate, toDate);
                gvOrders.DataSource = orderDTOList;
                gvOrders.DataBind();
            }
            else
            {
                LoadPreviousOrders();
            }

        }
        catch (Exception)
        {
        }



    }
    protected void btnsearch_Click(object sender, EventArgs e)
    {
        List<OrderDTO> orderfilterlist = new List<OrderDTO>();
        //List<OrderDTO> orderDTOList = gvOrders.DataSource as List<OrderDTO>;
        if (!string.IsNullOrEmpty(txtdlvnoteno.Text))
        {
            orderfilterlist = OrdersBAL.GetOrdersByDlvnoteNo(txtdlvnoteno.Text.Trim(), Convert.ToInt16(Session[enumSessions.ARC_Id.ToString()]));

        }

        else if (!string.IsNullOrEmpty(txtarcref.Text))
        {
            //  orderfilterlist = orderDTOList.FindAll(x => x.ARCOrderRefNo == txtarcref.Text);
            orderfilterlist = OrdersBAL.GetOrdersByARCRef(txtarcref.Text.Trim(), Convert.ToInt16(Session[enumSessions.ARC_Id.ToString()]));

        }

        if (orderfilterlist.Any())
        {
            gvOrders.DataSource = null;
            gvOrders.DataSource = orderfilterlist;
            gvOrders.DataBind();
        }
        else if (string.IsNullOrEmpty(txtdlvnoteno.Text) && string.IsNullOrEmpty(txtarcref.Text))
        {
            //gvOrders.DataSource = null;
            //gvOrders.DataBind();
            LoadPreviousOrders();


        }
        else
        {
            gvOrders.DataSource = null;
            gvOrders.DataBind();
        }

        //ClearAllInputs();
    }
}