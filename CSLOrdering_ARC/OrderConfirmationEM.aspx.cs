using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;
using System.Configuration;

using System.Web.Services;

public partial class OrderConfirmationEM : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session[enumSessions.User_Id.ToString()] == null)
            Response.Redirect("Login.aspx");

        if (!Page.IsPostBack)
        {
            hdnOrderID.Value = Request.QueryString.Count > 0 ? Request.QueryString[0] : "";

            if (Session[enumSessions.OrderNumber.ToString()] != null)
            {
                lblOrderNumber.Text = "CSL" + Session[enumSessions.OrderNumber.ToString()].ToString();
                Session[enumSessions.OrderNumber.ToString()] = null;
                Session.Remove(enumSessions.OrderNumber.ToString());
            }

            if (Session[enumSessions.OrderRef.ToString()] != null)
            {
                lblOrderRef.Text = Session[enumSessions.OrderRef.ToString()].ToString();
                Session[enumSessions.OrderRef.ToString()] = null;
                Session.Remove(enumSessions.OrderRef.ToString());
            }

            if (Session[enumSessions.SelectedInstaller.ToString()] != null)
            {
                Session[enumSessions.SelectedInstaller.ToString()] = null;
                Session.Remove(enumSessions.SelectedInstaller.ToString());
            }

            if (Session[enumSessions.InstallerCompanyID.ToString()] != null)
            {
                Session[enumSessions.InstallerCompanyID.ToString()] = null;
                Session.Remove(enumSessions.InstallerCompanyID.ToString());
            }

            LoadOrderData();
        }
        
    }

    private void LoadOrderData()
    {
        try
        {
            int orderid = 0;
            int.TryParse(hdnOrderID.Value, out orderid);

            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {

                var order = db.Orders.Where(x => x.OrderId == orderid).FirstOrDefault();
                if (order != null) {
                    lblOrderNumber.Text = "CSL" + order.OrderNo;
                    lblOrderRef.Text = order.OrderRefNo;
                }

                //var orderItemsWithEM = db.USP_GetEmizonOrderItems(orderid);
                //var data = orderItemsWithEM.Select(x =>
                //    new
                //    {
                //        ProductCode = x.ProductCode,
                //        ProductDesc = x.ProductName,
                //        EMNO = "EMNo: " + x.EM_No + (string.IsNullOrEmpty(x.GPRSNo) ? "" : ", InstallID: " + x.GPRSNo), //only show installid if available as not all ARC's has this feature
                //        SerialNo = string.IsNullOrEmpty(x.EM_TCD_SerialNo) ? "N/A" : x.EM_TCD_SerialNo,
                //    }
                //    );
                //gvOrderItems.DataSource = data;
                //gvOrderItems.DataBind();
            }
        }
        catch (Exception objException)
        {
            try
            {
                CSLOrderingARCBAL.LinqToSqlDataContext db;
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails(Request.Url.ToString(), "LoadEmizonOrderData", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException),
                    Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, SiteUtility.GetUserName());
            }
            catch { }
        }
    }


    [WebMethod]
    public static string GetOrderInfo(int orderid)
    {
        string orderData = "";
        try
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                var orderItemsWithEM = db.USP_GetEmizonOrderItems(orderid);
                var data = orderItemsWithEM.Select(x =>
                    new
                    {
                        ProductCode = x.ProductCode,
                        ProductDesc = x.ProductName,
                        EMNO = string.IsNullOrEmpty(x.EM_No) ? "" : x.EM_No,
                        InstallID = x.GPRSNo,
                        //EMNo = "EMNo: " + x.EM_No + (string.IsNullOrEmpty(x.GPRSNo) ? "" : ", InstallID: " + x.GPRSNo), //only show installid if available as not all ARC's has this feature
                        SerialNo = string.IsNullOrEmpty(x.EM_TCD_SerialNo) ? "N/A" : x.EM_TCD_SerialNo,
                        EM_APIMsg = string.IsNullOrEmpty(x.EM_APIMsg) ? "" :  x.EM_APIMsg,
                        EM_APIStatusID = x.EM_APIStatusID.HasValue ? x.EM_APIStatusID.ToString() : "",
                        OrderItemDetailId  = x.OrderItemDetailId,
                    }
                    ).ToList();

                Newtonsoft.Json.JsonSerializer jsr = new Newtonsoft.Json.JsonSerializer();
                System.IO.StringWriter sw = new System.IO.StringWriter();
                Newtonsoft.Json.JsonTextWriter jtw = new Newtonsoft.Json.JsonTextWriter(sw);
                jsr.Serialize(jtw, data.ToArray());
                orderData = sw.ToString();
            }
        }
        catch (Exception objException)
        {
            try
            {
                CSLOrderingARCBAL.LinqToSqlDataContext db;
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails("OrderconfirmationEmizon", "LoadEmizonOrderData", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException),
                    Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, SiteUtility.GetUserName());
            }
            catch { }
        }
        return orderData;
    }

    [WebMethod(EnableSession = true)]
    public static int UpdateInstallID(string InstallID, string OrderItemDetailID, string OrderID)
    {
         try
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                string emizonQueuePath = ConfigurationManager.AppSettings["EmizonQueue"].ToString();
                
                var OrderItemDetails = db.OrderItemDetails.Where(i => i.OrderItemDetailId == Convert.ToInt32(OrderItemDetailID)).SingleOrDefault();

                OrderItemDetails.GPRSNo = InstallID;
                db.SubmitChanges();

                EmizonOrderController.AddAPIRequestToQueue(emizonQueuePath, new Emizon.APIModels.MSMQTypes.QueueOrderMessage()
                {
                    orderID = Convert.ToInt32(OrderID)
                });

                return 0;
            }
        }
         catch (Exception objException)
         {
             try
             {
                 CSLOrderingARCBAL.LinqToSqlDataContext db;
                 db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                 db.USP_SaveErrorDetails("UpdateInstallID", "UpdateInstallID", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException),
                     Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, SiteUtility.GetUserName());
                 return -1;
             }
             catch {
                 return -1;
             }
         }
              
    }
}