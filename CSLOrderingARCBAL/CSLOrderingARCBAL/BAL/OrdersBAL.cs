using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CSLOrderingARCBAL.Common;
using System.Globalization;
using System.Web;
using CSLOrderingARCBAL.BAL;
using CSLOrderingARCBAL;
using CSLOrderingARCBAL.Common;
using System.Reflection;
using System.Data.Sql;
using System.Web.Security;

namespace CSLOrderingARCBAL.BAL
{
    public class OrdersBAL
    {
        public int orderId { get; set; }

        public static int CreateOrderForUser(int ArcId, string CreatedBy, string UserName, string UserEmail, string UserId)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            int orderId = 0;
            var ordr = db.USP_CreateOrderForUser(ArcId, CreatedBy, UserName, UserEmail, UserId).SingleOrDefault();
            if (ordr != null)
            {
                if (ordr.OrderId.HasValue)
                {
                    int.TryParse(ordr.OrderId.Value.ToString(), out orderId);
                }
            }
            db.Dispose();

            return orderId;
        }

        public static List<DeliveryType> GetDeliveryTypes()
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            List<DeliveryType> deliveryTypes = new List<DeliveryType>();

            deliveryTypes = (from DTypes in db.DeliveryTypes
                             select DTypes).ToList<DeliveryType>();

            db.Dispose();
            return deliveryTypes;
        }

        public static DeliveryType GetDeliveryType(int deliveryTypeID)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            var deliveryType = (from deliTypes in db.DeliveryTypes
                                where
                                (deliTypes.DeliveryTypeId != Convert.ToInt32((from app in db.ApplicationSettings where app.KeyName == enumApplicationSetting.MergeDeliveryTypeId.ToString() select app.KeyValue).SingleOrDefault()))
                                &&
                                (deliTypes.DeliveryTypeId == deliveryTypeID)
                                select deliTypes).SingleOrDefault();
            return deliveryType;
        }

        public static decimal CalculateOrderDeliverycharge(int deliveryTypeID)
        {
            decimal deliveryCharge = decimal.Zero;

            if (deliveryTypeID != null)
            {
                //Calculate delivery Charge
                LinqToSqlDataContext db = new LinqToSqlDataContext();
                DeliveryType delivery = (from deliveryTypes in db.DeliveryTypes
                                         where deliveryTypes.DeliveryTypeId == deliveryTypeID
                                         select deliveryTypes).SingleOrDefault();
                if (delivery != null)
                {
                    deliveryCharge = delivery.DeliveryPrice;
                }
            }

            return deliveryCharge;
        }

        public List<DeliveryType> GetShippingOptions()
        {
            List<DeliveryType> deliveryOptions = new List<DeliveryType>();

            LinqToSqlDataContext db = new LinqToSqlDataContext();
            Order order = new Order();
            order = (from odr in db.Orders
                     where odr.OrderId == orderId
                     select odr).SingleOrDefault();


            //Get list of Options with no Offers
            deliveryOptions = GetDeliveryTypesWithNoOffers();

            //Now Get Distinct list of DeliveryTypes with offers
            List<int> deliveryTypesWithOffers = new List<int>();
            deliveryTypesWithOffers = GetDistinctDeliveryTypesWithOffers();

            //Now Go through each and find out if the offer is valid for current order.
            foreach (int offerDeliveryTypeID in deliveryTypesWithOffers)
            {
                List<DeliveryOffer> offers = GetDeliveryOffersByTypeID(offerDeliveryTypeID);
                if (offers.Count == 0)
                {
                    continue;
                }

                //Read Each Offer for the current Delivery Type and perform validation checks for the current order.
                //PRIORITY --> ORDER_VALUE --> INSTALLER_COMPANY --> ENGINEER --> (PRODUCT --> MIN - MAX) --> (IF BASKET ITEMS >1 (PRODUCT --> PRODUCT_SIBLINGS _ELIGIBILITY))


                //OrderValue Validation
                #region ValueType Offer Validation and Addition
                bool valueTypeOfferAdded = false;
                List<DeliveryOffer> orderValueOffers = (from typeOffers in offers
                                                        where typeOffers.OrderValue > 0
                                                        select typeOffers).ToList<DeliveryOffer>();
                if (orderValueOffers.Count > 0)
                {
                    foreach (DeliveryOffer ValueOffer in orderValueOffers)
                    {
                        decimal orderTotalBeforeDiscounts = order.Amount;

                        if (orderTotalBeforeDiscounts >= ValueOffer.OrderValue)
                        {
                            DeliveryType deliveryType = GetDeliveryType(offerDeliveryTypeID);
                            if (deliveryType != null)
                            {
                                deliveryOptions.Add(deliveryType);
                                valueTypeOfferAdded = true;
                            }
                            break;
                        }
                    }
                }

                //As the current deliveryType is added proceed to next deliveryType
                if (valueTypeOfferAdded)
                {
                    continue;
                }
                #endregion


                //ARC Validation
                #region ARC Validation and Addition

                if (order.ARCId != 0)
                {
                    bool enggTypeOfferAdded = false;
                    List<DeliveryOffer> engineerOffers = (from typeOffers in offers
                                                          where typeOffers.ARCId != 0 && typeOffers.ARCId != -1
                                                          select typeOffers).ToList<DeliveryOffer>();

                    if (engineerOffers.Count > 0)
                    {
                        int currentEngineerCount = (from enggOffers in engineerOffers
                                                    where enggOffers.ARCId == order.ARCId
                                                    select enggOffers).Count();
                        if (currentEngineerCount > 0)
                        {
                            DeliveryType deliveryType = GetDeliveryType(offerDeliveryTypeID);
                            if (deliveryType != null)
                            {
                                deliveryOptions.Add(deliveryType);
                                enggTypeOfferAdded = true;
                            }
                        }
                    }
                    if (enggTypeOfferAdded)
                    {
                        continue;
                    }
                }
                #endregion



                //Installer  Validation
                #region Installer Validation and Addition

                if (order.InstallerId != null)
                {
                    bool enggTypeOfferAdded = false;
                    List<DeliveryOffer> engineerOffers = (from typeOffers in offers
                                                          where typeOffers.InstallerCompanyID != null
                                                          select typeOffers).ToList<DeliveryOffer>();

                    if (engineerOffers.Count > 0)
                    {
                        int currentEngineerCount = (from enggOffers in engineerOffers
                                                    where enggOffers.InstallerCompanyID == order.InstallerId
                                                    select enggOffers).Count();
                        if (currentEngineerCount > 0)
                        {
                            DeliveryType deliveryType = GetDeliveryType(offerDeliveryTypeID);
                            if (deliveryType != null)
                            {
                                deliveryOptions.Add(deliveryType);
                                enggTypeOfferAdded = true;
                            }
                        }
                    }
                    if (enggTypeOfferAdded)
                    {
                        continue;
                    }
                }
                #endregion


                //Product Validation
                #region Product Validation and Addition

                //Here we may have to perform several checks depending on no of basket Items.
                //IF the basket items are more than 1 then we may need to check with the existing offer product sibblings as if the two items in the basket
                //are still eligible for the offer and also the total Qty of the two items remain in the range.
                bool productTypeOfferAdded = false;
                List<DeliveryOffer> productOffers = (from pOffers in offers
                                                     where pOffers.ProductId != 0 && pOffers.ProductId != -1
                                                     select pOffers).ToList<DeliveryOffer>();
                if (productOffers.Count > 0)
                {

                    List<OrderItem> orderItems = GetOrderItems(orderId);
                    foreach (DeliveryOffer productOffer in productOffers)
                    {
                        int rangeMinQty = productOffer.MinQty.HasValue ? productOffer.MinQty.Value : 0;
                        int rangeMaxQty = productOffer.MaxQty.HasValue ? productOffer.MaxQty.Value : 0;

                        //Perform validation if basket has only one item
                        if (orderItems.Count == 1)
                        {
                            if (productOffer.ProductId == orderItems[0].ProductId)
                            {
                                if (orderItems[0].ProductQty >= rangeMinQty && orderItems[0].ProductQty <= rangeMaxQty)
                                {
                                    DeliveryType deliveryType = GetDeliveryType(offerDeliveryTypeID);
                                    if (deliveryType != null)
                                    {
                                        deliveryOptions.Add(deliveryType);
                                        productTypeOfferAdded = true;
                                    }
                                    break;
                                }
                            }
                        }



                        //Perform validation checks for basket items > 1
                        //This is where we check with the sibblings.
                        if (orderItems.Count > 1)
                        {
                            bool allItemsMatchWithSibling = true;
                            List<OrderItem> itemsMatchedwithProductOffer = (from oitems in orderItems
                                                                            where oitems.ProductId == productOffer.ProductId
                                                                            select oitems).ToList<OrderItem>();
                            if (itemsMatchedwithProductOffer.Count == 1)
                            {
                                //This is our ProductTypeDeliveryOffer Main product
                                //Now get list of siblings and compare with other items of the order.
                                List<Delivery_Product_Sibbling> productOfferSibling = GetProductSiblingsByDeliveryOffer(productOffer.DeliveryOfferId);
                                int totalBasketQuantity = 0;

                                foreach (OrderItem item in orderItems)
                                {
                                    totalBasketQuantity += item.ProductQty;
                                    if (item.ProductId == productOffer.ProductId) continue;
                                    List<Delivery_Product_Sibbling> existingInSibing = (from pSibling in productOfferSibling
                                                                                        where pSibling.Sibbling_ProductId == item.ProductId
                                                                                        select pSibling).ToList<Delivery_Product_Sibbling>();
                                    if (existingInSibing.Count == 0)
                                    {
                                        allItemsMatchWithSibling = false;
                                        break;
                                    }
                                }


                                //If all OrderItems exists in sibling records then check the range
                                if (allItemsMatchWithSibling)
                                {
                                    if (totalBasketQuantity >= rangeMinQty && totalBasketQuantity <= rangeMaxQty)
                                    {
                                        DeliveryType deliveryType = GetDeliveryType(offerDeliveryTypeID);
                                        if (deliveryType != null)
                                        {
                                            deliveryOptions.Add(deliveryType);
                                            productTypeOfferAdded = true;
                                        }
                                        break;
                                    }
                                }
                            }
                        }

                    }//foreach
                    if (productTypeOfferAdded)
                    {
                        continue;
                    }
                }


                #endregion

            }
            return deliveryOptions;
        }

        public static DeliveryOffer GetDeliveryOfferByID(int deliveryOfferID)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            DeliveryOffer offer = (from deliOffer in db.DeliveryOffers
                                   where deliOffer.DeliveryOfferId == deliveryOfferID && DateTime.Now < deliOffer.ExpiryDate
                                   select deliOffer).FirstOrDefault();
            db.Dispose();
            return offer;
        }

        public static List<DeliveryOffer> GetDeliveryOffersByTypeID(int deliveryTypeID)
        {
            List<DeliveryOffer> deliveryOffers = new List<DeliveryOffer>();
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            deliveryOffers = (from deliOffers in db.DeliveryOffers
                              where deliOffers.DeliveryTypeId == deliveryTypeID && DateTime.Now < deliOffers.ExpiryDate
                              select deliOffers).ToList<DeliveryOffer>();
            db.Dispose();
            return deliveryOffers;
        }

        public List<DeliveryType> GetDeliveryTypesWithNoOffers()
        {

            List<DeliveryType> deliveryTypes = new List<DeliveryType>();
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            deliveryTypes = (from deliTypes in db.DeliveryTypes
                             where
                              (deliTypes.DeliveryTypeId != Convert.ToInt32((from app in db.ApplicationSettings where app.KeyName == enumApplicationSetting.MergeDeliveryTypeId.ToString() select app.KeyValue).SingleOrDefault())) &&
                              (deliTypes.IsDeleted == false)
                              &&
                             (
                             !(from deliOffers in db.DeliveryOffers
                               where DateTime.Now < deliOffers.ExpiryDate
                               select deliOffers.DeliveryTypeId).Contains(deliTypes.DeliveryTypeId)
                             )
                             select deliTypes).ToList<DeliveryType>();
            return deliveryTypes;
        }

        private List<int> GetDistinctDeliveryTypesWithOffers()
        {
            List<int> deliveryTypesWithOffers = new List<int>();
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            deliveryTypesWithOffers = (
                                        from deliOffers in db.DeliveryOffers
                                        where DateTime.Now < deliOffers.ExpiryDate
                                        select deliOffers.DeliveryTypeId
                                       ).Distinct().ToList<int>();

            return deliveryTypesWithOffers;
        }

        public static List<OrderItem> GetOrderItems(int OrderId)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            List<OrderItem> orderItems = new List<OrderItem>();
            orderItems = (from oItems in db.OrderItems
                          where oItems.OrderId == OrderId
                          select oItems).ToList<OrderItem>();
            db.Dispose();
            return orderItems;
        }

        public static List<Delivery_Product_Sibbling> GetProductSiblingsByDeliveryOffer(int deliveryOfferID)
        {
            List<Delivery_Product_Sibbling> siblings = new List<Delivery_Product_Sibbling>();
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            siblings = (from offerSiblings in db.Delivery_Product_Sibblings
                        where offerSiblings.DeliveryOfferId == deliveryOfferID
                        select offerSiblings).ToList<Delivery_Product_Sibbling>();
            db.Dispose();
            return siblings;
        }

        public static string GetDeliveryAddressHTML2Line(int orderId)
        {
            string strAddress = string.Empty;

            try
            {
                LinqToSqlDataContext db = new LinqToSqlDataContext();
                Address address = new Address();
                address = (from add in db.Addresses
                           join order in db.Orders on add.AddressID equals order.DeliveryAddressId
                           where order.OrderId == orderId
                           select add).SingleOrDefault();

                string NOTSPECIFIED = " ";

                strAddress = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + address.ContactName + " <br /> ";
                strAddress += string.IsNullOrEmpty(address.CompanyName) ? NOTSPECIFIED.Trim() : "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + address.CompanyName + ", " + " <br /> ";
                strAddress += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + address.AddressOne + ", " + " <br /> ";
                strAddress += string.IsNullOrEmpty(address.AddressTwo) ? NOTSPECIFIED.Trim() : "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + address.AddressTwo + ", " + " <br /> ";
                strAddress += string.IsNullOrEmpty(address.Town) ? NOTSPECIFIED.Trim() : "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + address.Town + ", ";
                strAddress += string.IsNullOrEmpty(address.County) ? NOTSPECIFIED.Trim() : address.County + ", ";
                strAddress += string.IsNullOrEmpty(address.PostCode) ? NOTSPECIFIED.Trim() : "<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + address.PostCode + ", <br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                strAddress += string.IsNullOrEmpty(address.Fax) ? NOTSPECIFIED.Trim() : "Fax: " + address.Fax;
                strAddress += string.IsNullOrEmpty(address.Mobile) ? NOTSPECIFIED.Trim() : "Mob: " + address.Mobile;
                strAddress += string.IsNullOrEmpty(address.Telephone) ? NOTSPECIFIED.Trim() : "Tel: " + address.Telephone;
                if (strAddress.LastIndexOf(",") > 0)
                    strAddress = strAddress.Remove(strAddress.LastIndexOf(","));
            }
            catch (Exception objException)
            {
                CSLOrderingARCBAL.LinqToSqlDataContext db;
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails("ARC Ordering", "GetDeliveryAddressHTML2Line", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, null);
            }

            return strAddress;
        }

        public static OrderDTO GetOrderDetail(int orderId)         
        {
            OrderDTO orderDTO = new OrderDTO();

            try
            {
                System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-GB", false);
                LinqToSqlDataContext db = new LinqToSqlDataContext();

                var OrderDtls = (from order in db.Orders
                                 join dlvry in db.DeliveryTypes on order.DeliveryTypeId equals dlvry.DeliveryTypeId
                                 where order.OrderId == orderId
                                 select new
                                 {
                                     order.InstallerId,
                                     order.UserName,
                                     order.UserEmail,
                                     order.CreatedBy,
                                     order.OrderDate,
                                     order.OrderNo,
                                     order.OrderRefNo,
                                     order.SpecialInstructions,
                                     order.DeliveryCost,
                                     order.Amount,
                                     order.OrderTotalAmount,
                                     order.VATRate,
                                     dlvry.DeliveryCompanyName,
                                     dlvry.DeliveryShortDesc,
                                     dlvry.DeliveryPrice,
                                     order.UserId,
                                     order.InstallationAddressID
                                 }).SingleOrDefault();

                var orderItem = (from oi in db.OrderItems
                                 where oi.OrderId == orderId
                                 group oi by oi.OrderId into qty
                                 select new
                                 {
                                     ProductQty = qty.Sum(oi => oi.ProductQty)
                                 }
                                        ).FirstOrDefault();

                orderDTO.UserName = OrderDtls.UserName;
                orderDTO.UserEmail = OrderDtls.UserEmail;
                orderDTO.OrderDate = OrderDtls.OrderDate;
                orderDTO.CSLOrderNo = OrderDtls.OrderNo;
                orderDTO.ARCOrderRefNo = OrderDtls.OrderRefNo;
                orderDTO.CreatedBy = OrderDtls.CreatedBy;
                orderDTO.InstallerId = OrderDtls.InstallerId.ToString();
                orderDTO.SpecialInstructions = OrderDtls.SpecialInstructions;
                orderDTO.DeliveryCost = Math.Round(OrderDtls.DeliveryCost, 2).ToString();
                orderDTO.OrderTotal = Math.Round(OrderDtls.Amount, 2).ToString();
                orderDTO.DeliveryType = OrderDtls.DeliveryCompanyName + " - " + OrderDtls.DeliveryShortDesc + " - " + OrderDtls.DeliveryPrice.ToString("c");
                orderDTO.VATAmount = Math.Round((OrderDtls.Amount + OrderDtls.DeliveryCost) * OrderDtls.VATRate, 2).ToString();
                orderDTO.TotalAmountToPay = Math.Round(((OrderDtls.Amount + OrderDtls.DeliveryCost) + (OrderDtls.Amount + OrderDtls.DeliveryCost) * OrderDtls.VATRate), 2).ToString();
                orderDTO.UserId = (Guid)OrderDtls.UserId;
                orderDTO.InstallationAddressId = OrderDtls.InstallationAddressID;
                if (orderItem != null)
                    orderDTO.OrderQty = orderItem.ProductQty.ToString();
                else
                    orderDTO.OrderQty = "0.00";
            }
            catch (Exception objException)
            {
                CSLOrderingARCBAL.LinqToSqlDataContext db;
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails("ARC Ordering", "GetOrderDetail", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, null);
            }

            return orderDTO;
        }

        public static List<string> GetTrackingNoList(int OrderId)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            List<string> track = new List<string>();
            var trackdb = (from trk in db.OrderShippingTracks
                           where trk.OrderId == OrderId
                           select trk
                          ).ToList();
            foreach (var item in trackdb)
            {

                track.Add(item.TrackingNo.ToString());
            }

            return track;
        }

        public static List<string> GetDeliveryNoteList(int OrderId)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            List<string> Deliverynotes = new List<string>();
            var dlvnotes = (from o in db.Orders
                            join oi in db.OrderItems on o.OrderId equals oi.OrderId
                            join oid in db.OrderItemDetails on oi.OrderItemId equals oid.OrderItemId
                            where o.OrderId == OrderId
                            select oid
                          ).ToList();
            foreach (var note in dlvnotes)
            {
                if (!string.IsNullOrEmpty(note.ItemDlvNoteNo))
                    Deliverynotes.Add(note.ItemDlvNoteNo.ToString());
            }

            return Deliverynotes;
        }

        public static List<OrderDTO> GetPreviousOrders(String UserId)
        {
            List<OrderDTO> orderDTOList = new List<OrderDTO>();
            OrderDTO orderDTO;
            DateTime toDate = DateTime.Now;
            DateTime fromDate = DateTime.Now.AddDays(-1);
            try
            {
                Guid userID = new Guid(UserId);
                LinqToSqlDataContext db = new LinqToSqlDataContext();
                bool arc_Manager = false;
                if (Roles.GetRolesForUser().Contains("ARC_Manager"))
                {
                    arc_Manager = true;
                }
                int ARCID = (from arc in db.ARC_User_Maps
                             where arc.UserId == userID
                             select arc.ARCId).FirstOrDefault();

                var OrderDtls = (from order in db.Orders
                                 join Ins in db.Installers on order.InstallerId equals Ins.InstallerCompanyID

                                 where order.OrderStatusId != 1 &&
                                  order.UserId == (arc_Manager ? order.UserId : userID)
                                  && order.ARCId == ARCID
                                 select new
                                 {
                                     order.OrderId,
                                     order.OrderDate,
                                     order.OrderNo,
                                     order.OrderRefNo,
                                     order.DeliveryCost,
                                     order.Amount,
                                     order.OrderTotalAmount,
                                     order.VATRate,
                                     Ins.CompanyName,
                                 }).OrderByDescending(x => x.OrderDate).Take(200);

                foreach (var o in OrderDtls)
                {
                    orderDTO = new OrderDTO();
                    orderDTO.OrderId = o.OrderId;
                    orderDTO.OrderDate = o.OrderDate;
                    orderDTO.CSLOrderNo = o.OrderNo;
                    orderDTO.ARCOrderRefNo = o.OrderRefNo;
                    orderDTO.CompanyName = o.CompanyName.Length > 20 ? o.CompanyName.Substring(0, 17) + "..." : o.CompanyName;
                    orderDTO.TotalAmountToPay = Math.Round(((o.Amount + o.DeliveryCost) + (o.Amount + o.DeliveryCost) * o.VATRate), 2).ToString();
                    var orderItem = (from oi in db.OrderItems
                                     where oi.OrderId == o.OrderId
                                     group oi by oi.OrderId into qty
                                     select new
                                     {
                                         ProductQty = qty.Sum(oi => oi.ProductQty)
                                     }
                                        ).FirstOrDefault();

                    if (orderItem != null)
                        orderDTO.OrderQty = orderItem.ProductQty.ToString();
                    else
                        orderDTO.OrderQty = "0.00";

                    orderDTOList.Add(orderDTO);
                }
            }
            catch (Exception objException)
            {
                CSLOrderingARCBAL.LinqToSqlDataContext db;
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails("ARC Ordering", "GetPreviousOrders", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, null);
            }

            return orderDTOList;
        }

        public static List<OrderDTO> GetOrdersByDlvnoteNo(string deliverynoteno, int arc)
        {
            List<OrderDTO> orderDTOList = new List<OrderDTO>();
            OrderDTO orderDTO;
            try
            {
                //System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-GB", false);
                LinqToSqlDataContext db = new LinqToSqlDataContext();

                var OrderDtls = (from order in db.Orders
                                 join Ins in db.Installers on order.InstallerId equals Ins.InstallerCompanyID
                                 join oi in db.OrderItems on order.OrderId equals oi.OrderId
                                 join oid in db.OrderItemDetails on oi.OrderItemId equals oid.OrderItemId
                                 where order.OrderStatusId != 1 && order.ARCId == arc
                                 && oid.ItemDlvNoteNo.Contains(deliverynoteno)
                                 select new
                                 {
                                     order.OrderId,
                                     order.OrderDate,
                                     order.OrderNo,
                                     order.OrderRefNo,
                                     order.DeliveryCost,
                                     order.Amount,
                                     order.OrderTotalAmount,
                                     order.VATRate,
                                     Ins.CompanyName,
                                 }).OrderByDescending(x => x.OrderDate).Take(200);

                foreach (var o in OrderDtls)
                {
                    orderDTO = new OrderDTO();
                    orderDTO.OrderId = o.OrderId;
                    orderDTO.OrderDate = o.OrderDate;
                    orderDTO.CSLOrderNo = o.OrderNo;
                    orderDTO.ARCOrderRefNo = o.OrderRefNo;
                    orderDTO.CompanyName = o.CompanyName.Length > 20 ? o.CompanyName.Substring(0, 17) + "..." : o.CompanyName;
                    orderDTO.TotalAmountToPay = Math.Round(((o.Amount + o.DeliveryCost) + (o.Amount + o.DeliveryCost) * o.VATRate), 2).ToString();
                    var orderItem = (from oi in db.OrderItems
                                     where oi.OrderId == o.OrderId
                                     group oi by oi.OrderId into qty
                                     select new
                                     {
                                         ProductQty = qty.Sum(oi => oi.ProductQty)
                                     }
                                        ).FirstOrDefault();

                    if (orderItem != null)
                        orderDTO.OrderQty = orderItem.ProductQty.ToString();
                    else
                        orderDTO.OrderQty = "0.00";

                    orderDTOList.Add(orderDTO);
                }
            }
            catch (Exception objException)
            {
                CSLOrderingARCBAL.LinqToSqlDataContext db;
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails("ARC Ordering", "GetPreviousOrders", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, null);
            }

            return orderDTOList;
        }

        public static List<OrderDTO> GetOrdersByARCRef(string Arcref, int arc)
        {
            List<OrderDTO> orderDTOList = new List<OrderDTO>();
            OrderDTO orderDTO;
            try
            {
                //System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-GB", false);
                LinqToSqlDataContext db = new LinqToSqlDataContext();

                var OrderDtls = (from order in db.Orders
                                 join Ins in db.Installers on order.InstallerId equals Ins.InstallerCompanyID
                                 where order.OrderStatusId != 1 && order.ARCId == arc
                                 && order.OrderRefNo.Contains(Arcref)
                                 select new
                                 {
                                     order.OrderId,
                                     order.OrderDate,
                                     order.OrderNo,
                                     order.OrderRefNo,
                                     order.DeliveryCost,
                                     order.Amount,
                                     order.OrderTotalAmount,
                                     order.VATRate,
                                     Ins.CompanyName,
                                 }).OrderByDescending(x => x.OrderDate).Take(200);

                foreach (var o in OrderDtls)
                {
                    orderDTO = new OrderDTO();
                    orderDTO.OrderId = o.OrderId;
                    orderDTO.OrderDate = o.OrderDate;
                    orderDTO.CSLOrderNo = o.OrderNo;
                    orderDTO.ARCOrderRefNo = o.OrderRefNo;
                    orderDTO.CompanyName = o.CompanyName.Length > 20 ? o.CompanyName.Substring(0, 17) + "..." : o.CompanyName;
                    orderDTO.TotalAmountToPay = Math.Round(((o.Amount + o.DeliveryCost) + (o.Amount + o.DeliveryCost) * o.VATRate), 2).ToString();
                    var orderItem = (from oi in db.OrderItems
                                     where oi.OrderId == o.OrderId
                                     group oi by oi.OrderId into qty
                                     select new
                                     {
                                         ProductQty = qty.Sum(oi => oi.ProductQty)
                                     }
                                        ).FirstOrDefault();

                    if (orderItem != null)
                        orderDTO.OrderQty = orderItem.ProductQty.ToString();
                    else
                        orderDTO.OrderQty = "0.00";

                    orderDTOList.Add(orderDTO);
                }
            }
            catch (Exception objException)
            {
                CSLOrderingARCBAL.LinqToSqlDataContext db;
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails("ARC Ordering", "GetPreviousOrders", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, null);
            }

            return orderDTOList;
        }

        public static List<OrderDTO> GetPreviousOrdersByDate(string UserId, DateTime? fromDate, DateTime? toDate)
        {
            List<OrderDTO> orderDTOList = new List<OrderDTO>();
            OrderDTO orderDTO;

            try
            {
                //System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-GB", false);
                LinqToSqlDataContext db = new LinqToSqlDataContext();

                var OrderDtls = (from order in db.Orders
                                 join Ins in db.Installers on order.InstallerId equals Ins.InstallerCompanyID
                                 where
                                 ((fromDate == null || toDate == null) ||
                                  (order.OrderDate <= toDate) && (order.OrderDate >= fromDate)) &&
                                 order.OrderStatusId != 1 && order.UserId == new Guid(UserId)
                                 select new
                                 {
                                     order.OrderId,
                                     order.OrderDate,
                                     order.OrderNo,
                                     order.OrderRefNo,
                                     order.DeliveryCost,
                                     order.Amount,
                                     order.OrderTotalAmount,
                                     order.VATRate,
                                     Ins.CompanyName
                                 }).OrderByDescending(x => x.OrderDate).Take(200);

                foreach (var o in OrderDtls)
                {
                    orderDTO = new OrderDTO();
                    orderDTO.OrderId = o.OrderId;
                    orderDTO.OrderDate = o.OrderDate;
                    orderDTO.CSLOrderNo = o.OrderNo;
                    orderDTO.ARCOrderRefNo = o.OrderRefNo;
                    orderDTO.CompanyName = o.CompanyName.Length > 20 ? o.CompanyName.Substring(0, 17) + "..." : o.CompanyName;
                    orderDTO.TotalAmountToPay = Math.Round(((o.Amount + o.DeliveryCost) + (o.Amount + o.DeliveryCost) * o.VATRate), 2).ToString();

                    var orderItem = (from oi in db.OrderItems
                                     where oi.OrderId == o.OrderId
                                     group oi by oi.OrderId into qty
                                     select new
                                     {
                                         ProductQty = qty.Sum(oi => oi.ProductQty)
                                     }
                                        ).FirstOrDefault();

                    if (orderItem != null)
                        orderDTO.OrderQty = orderItem.ProductQty.ToString();
                    else
                        orderDTO.OrderQty = "0.00";

                    orderDTOList.Add(orderDTO);
                }
            }
            catch (Exception objException)
            {
                CSLOrderingARCBAL.LinqToSqlDataContext db;
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails("ARC Ordering", "GetPreviousOrdersByDate", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, null);
            }

            return orderDTOList;
        }

        public static List<OrderDTO> GetPreviousOrdersAdmin(OrderDTO orderdetinput)
        {
            List<OrderDTO> orderDTOList = new List<OrderDTO>();
            OrderDTO orderDTO;

            try
            {

                //System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-GB", false);
                LinqToSqlDataContext db = new LinqToSqlDataContext();
                // var OrderDtls ;


                var OrderDtls = (from order in db.Orders
                                 join orditem in db.OrderItems
                                  on order.OrderId equals orditem.OrderId
                                 join arc in db.ARCs
                                  on order.ARCId equals arc.ARCId
                                 join status in db.OrderStatusMasters
                                 on order.OrderStatusId equals status.OrderStatusId
                                 join oid in db.OrderItemDetails on orditem.OrderItemId equals oid.OrderItemId
                                 where order.OrderStatusId != 1 &&
                                 ((order.OrderDate.Date <= orderdetinput.ordertodate) && (order.OrderDate.Date >= orderdetinput.orderfromdate))
                                 && (orderdetinput.orderctgid == -1 || orditem.CategoryId == orderdetinput.orderctgid)
                                 && (orderdetinput.orderprodid == -1 || orditem.ProductId == orderdetinput.orderprodid)
                                 && (orderdetinput.orderarcid == -1 || order.ARCId == orderdetinput.orderarcid)
                                 && (orderdetinput.CSLOrderNo == string.Empty || order.OrderNo == orderdetinput.CSLOrderNo)
                                 && (orderdetinput.ChipNo == string.Empty || oid.GPRSNo == orderdetinput.ChipNo)
                                 select new
                                 {
                                     order.UserId,
                                     order.UserEmail,
                                     order.OrderId,
                                     order.OrderDate,
                                     order.OrderNo,
                                     order.OrderRefNo,
                                     order.DeliveryCost,
                                     order.Amount,
                                     order.OrderTotalAmount,
                                     order.VATRate,
                                     ARCDisp = arc.CompanyName + "[" + arc.ARC_Code + "] ",
                                     status.OrderStatus
                                 }).Distinct().OrderByDescending(x => x.OrderDate).Take(200);



                foreach (var o in OrderDtls)
                {
                    orderDTO = new OrderDTO();
                    orderDTO.OrderId = o.OrderId;
                    orderDTO.OrderDate = o.OrderDate;
                    orderDTO.CSLOrderNo = o.OrderNo;
                    orderDTO.ARCOrderRefNo = o.OrderRefNo;
                    orderDTO.ARCDisp = o.ARCDisp;
                    orderDTO.UserEmail = o.UserEmail;
                    orderDTO.TotalAmountToPay = Math.Round(((o.Amount + o.DeliveryCost) + (o.Amount + o.DeliveryCost) * o.VATRate), 2).ToString();
                    orderDTO.OrderStatus = o.OrderStatus;
                    var orderItem = (from oi in db.OrderItems
                                     where oi.OrderId == o.OrderId
                                     group oi by oi.OrderId into qty
                                     select new
                                     {
                                         ProductQty = qty.Sum(oi => oi.ProductQty)
                                     }
                                        ).FirstOrDefault();

                    if (orderItem != null)
                        orderDTO.OrderQty = orderItem.ProductQty.ToString();
                    else
                        orderDTO.OrderQty = "0.00";

                    orderDTOList.Add(orderDTO);
                }
            }
            catch (Exception objException)
            {
                CSLOrderingARCBAL.LinqToSqlDataContext db;
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails("ARC Ordering", "GetPreviousOrdersAdmin", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, null);
            }

            return orderDTOList;
        }

        public static int GetProductOptionCount(int productId)
        {
            try
            {
                LinqToSqlDataContext db = new LinqToSqlDataContext();

                int count = (from o in db.Product_Option_Maps
                             where o.ProductId == productId
                             select o
                               ).Count();

                return count;
            }
            catch (Exception objException)
            {
                CSLOrderingARCBAL.LinqToSqlDataContext db;
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails("ARC Ordering", "GetProductOptionCount", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, null);
                return -1;
            }

        }

        #region GetOrderDetailsforReport

        public static List<OrderItemDetailsDTO> GetOrderDetailsforReport(int orderID)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db = null;
            try
            {

                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                List<OrderItemDetailsDTO> orderItemDetails = new List<OrderItemDetailsDTO>();
                orderItemDetails =

                    (from o in db.Orders
                     join oi in db.OrderItems on o.OrderId equals oi.OrderId
                     join oid in db.OrderItemDetails on oi.OrderItemId equals oid.OrderItemId
                     join ois in db.OrderStatusMasters on oi.OrderItemStatusId equals ois.OrderStatusId
                     join op in db.Options on oid.OptionId equals op.OptID into x
                     from Y in x.DefaultIfEmpty()
                     select new OrderItemDetailsDTO
                     {
                         GPRSNo = oid.GPRSNo,
                         PSTNNo = oid.PSTNNo,
                         GSMNo = oid.GSMNo,
                         LANNo = oid.LANNo,
                         GPRSNoPostCode = oid.GPRSNoPostCode,
                         ICCID = oid.ICCID,
                         OrderItemStatus = ois.OrderStatus,
                         OptionName = (Y == null ? String.Empty : Y.OptionName)


                     }).ToList<OrderItemDetailsDTO>(); ;



                //    (from o in db.Orders
                //                    join oi in db.OrderItems on o.OrderId equals oi.OrderId
                //                    join oid in db.OrderItemDetails on oi.OrderItemId equals oid.OrderItemId 
                //                    join op in db.Options on oid.OptionId equals op.OptID
                //                    join ois in db.OrderStatusMasters on oi.OrderItemStatusId equals ois.OrderStatusId
                //                    where oi.OrderItemId == orderID && oid.GPRSNo !=String.Empty
                //                    select new OrderItemDetailsDTO
                //                    {

                //                        GPRSNo =   oid.GPRSNo,
                //                        PSTNNo = oid.PSTNNo,
                //                        GSMNo = oid.GSMNo,
                //                        LANNo = oid.LANNo,
                //                        GPRSNoPostCode = oid.GPRSNoPostCode,
                //                        ICCID = oid.ICCID,
                //                        OrderItemStatus = ois.OrderStatus,
                //                        OptionName = op.OptionName



                //                    }).ToList<OrderItemDetailsDTO>();
                db.Dispose();
                return orderItemDetails;
            }
            catch (Exception objException)
            {

                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails("ARC Ordering", "GetOrderDetailsforReport", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, null);
                return null;
            }
        }

        #endregion

        public static int GetDeliveryOffersByInstallerID(Guid installerId)
        {
            LinqToSqlDataContext db = null;
            try
            {
                db = new LinqToSqlDataContext();
                return (from dt in db.DeliveryTypes
                        join df in db.DeliveryOffers on dt.DeliveryTypeId equals df.DeliveryTypeId
                        where df.InstallerCompanyID == installerId && DateTime.Now < df.ExpiryDate
                        select dt).Count();

            }
            catch (Exception objException)
            {

                db = new LinqToSqlDataContext();
                db.USP_SaveErrorDetails("ARC Ordering", "GetProductOptionCount", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, null);
                return -1;
            }
        }
     //   public static bool GetIPDetails(int OrderID)
     //   {
//
     //   }


    }
}
