using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CSLOrderingARCBAL;
using CSLOrderingARCBAL.BAL;
using CSLOrderingARCBAL.Common;
using System.Text;
using System.Data.Sql;
using System.IO;
using System.Globalization;
using System.Web.Security;
using System.Net.Mail;
using System.Configuration;
using System.Text.RegularExpressions;
using MSMQSendEmailToQueueLibrary;




/// <summary>
/// Summary description for SendEmail
/// </summary>
public class SendEmail
{
    public SendEmail()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static void SendEmailWithoutPrice(string OrderNo, string mailTO, SendEmailDTO sendEmailDTO,
        string mailFrom, string mailCC, bool isEmailFromViewOrders, bool? hasEmizonProducts, int orderID)
    {
        try
        {
            String ProductsList = "";
            string subjectsuffix = string.Empty;
            string mailSubject = "Order Confirmation - Order Ref: " + OrderNo;
            string templatePath = "Template";
            string emizonQueuePath = ConfigurationManager.AppSettings["EmizonQueue"].ToString();

            if (isEmailFromViewOrders)
            {
                if (mailTO.EndsWith("@csldual.com")) { subjectsuffix = "; Email Resent"; }

                mailSubject = mailSubject + subjectsuffix;
                templatePath = "../Template";
            }
            String mailHtml = ReadTemplates.ReadMailTemplate(System.Web.HttpContext.Current.Server.MapPath(templatePath), "EmailTemplatewithoutprice.html");
            StringBuilder objBuilder = new StringBuilder();
            objBuilder.Append(mailHtml);
            objBuilder.Replace("{OrderNo}", OrderNo);
            objBuilder.Replace("{OrderDate}", string.IsNullOrEmpty(sendEmailDTO.orderDate) ? "." : sendEmailDTO.orderDate);
            objBuilder.Replace("{OrderRef}", string.IsNullOrEmpty(sendEmailDTO.ARCOrderRefNo) ? "." : sendEmailDTO.ARCOrderRefNo);

            ARC arc = ArcBAL.GetArcInfoByUserId(new Guid(sendEmailDTO.userID));
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


            objBuilder.Replace("{Username}", sendEmailDTO.userName);
            objBuilder.Replace("{UserEmail}", sendEmailDTO.userEmail);
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            var products = db.USP_GetBasketProducts(Convert.ToInt32(sendEmailDTO.orderID)).ToList();
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
                        var ChipNumbers = db.USP_GetBasketGPRSChipNumbersByProductId(Convert.ToInt32(sendEmailDTO.orderID), prod.ProductId, prod.CategoryId);

                        if (ChipNumbers != null)
                        {

                            foreach (var chipno in ChipNumbers)
                            {

                                chipNos += string.IsNullOrEmpty(chipno.GPRSNo) ? "" : chipno.GPRSNo + "-";
                                chipNos += string.IsNullOrEmpty(chipno.PSTNNo) ? "" : chipno.PSTNNo + "-";
                                chipNos += string.IsNullOrEmpty(chipno.PSTNNo) ? "" : chipno.GSMNo + "-";  //added GSM NO(PanelID) in email
                                chipNos += string.IsNullOrEmpty(chipno.OptionName) ? "" : chipno.OptionName;
                                chipNos += ",";

                                if (chipno.PSTNNo == "" &&
                                    chipno.OptionName == "" &&
                                    chipno.GSMNo == "" &&
                                    chipNos.Length > 0
                                    ) //added GSM NO(PanelID) in email
                                {
                                    chipNos = chipNos.Remove(chipNos.Length - 1, 1);
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
                        int rowCount = db.USP_GetBasketProductsOnCheckOut(Convert.ToInt32(sendEmailDTO.orderID)).Where(i => i.ProductCode == prod.ProductCode.Trim()).Count();

                        if (rowCount == 1)
                        {
                            var dependentproducts = db.USP_GetBasketDependentProductsByProductId(Convert.ToInt32(sendEmailDTO.orderID), prod.ProductId, prod.CategoryId).ToList();
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
                            var dependentproducts = db.USP_GetBasketDependentProductsByProductId(Convert.ToInt32(sendEmailDTO.orderID), prod.ProductId, prod.CategoryId).ToList();
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

            objBuilder.Replace("{DeliveryTypeName}", sendEmailDTO.DdeliveryType);
            objBuilder.Replace("{DeliveryTypePrice}", sendEmailDTO.deliveryCost);
            //updated the following after Ravi changed the method GetAddressHTML2LineForEmail
            //  objBuilder.Replace("{Installer}", InstallerBAL.GetAddressHTML2LineForEmail(new Guid(InstallerId)));
            objBuilder.Replace("{Installer}", InstallerBAL.GetAddressHTML2LineForEmail(new Guid(sendEmailDTO.installerID)));
            OrderDTO objorder = CSLOrderingARCBAL.BAL.OrdersBAL.GetOrderDetail(Convert.ToInt32(sendEmailDTO.orderID));
            bool instadd_differs = false;
            if (objorder.InstallationAddressId > 0)
            {
                instadd_differs = true;
            }
            else
            {
                instadd_differs = false;
            }
            if (instadd_differs)//|| sendEmailDTO.InstallationAddId!=0)
            {
                //string InsAdd = InstallerBAL.GetAddressHTML2LineForEmail(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString()));
                string InsAdd = objorder.InstallationAddressId.HasValue ? InstallerBAL.GetAddressHTML2LineForEmail(objorder.InstallationAddressId.Value) : "Not Available";
                objBuilder.Replace("{InstallerAddress}", "<td><div style=\"width: 100%; margin: 0; padding: 0;\"><table border=\"0\" cellpadding=\"5\" cellspacing=\"0\" width=\"100%\"><tr><td style=\"text-align: left\"> <font color=\"#888\" size=\"2\" face=\"Arial\">" + InsAdd + " </font></td></tr></table></div></td>");
                objBuilder.Replace("{HeadingInstallerAdd}", "<td><h3 style=\"font-size:11px; text-align: center; margin: 0; padding: 5px auto;\">Installation Address</h3></td>");
            }
            else
            {
                objBuilder.Replace("{InstallerAddress}", "");
                objBuilder.Replace("{HeadingInstallerAdd}", "");

            }
            objBuilder.Replace("{DeliveredTo}", OrdersBAL.GetDeliveryAddressHTML2Line(Convert.ToInt32(sendEmailDTO.orderID)));
            objBuilder.Replace("{SpecialInstructions}", sendEmailDTO.specialInstructions);
            var distinctProduct = products.Select(i => i.ProductCode).Distinct();
            foreach (var pro in distinctProduct)
            {
                products = db.USP_GetBasketProducts(Convert.ToInt32(sendEmailDTO.orderID)).Where(p => p.ProductCode == pro).Take(1).ToList();
                foreach (var prod in products)
                {
                    if (prod.IsCSDUser == true)
                    {
                        ProductsList += "<tr><td>" + prod.ProductCode + "</td><td>" + prod.Message + "</td></tr>";
                    }
                }

            }
            objBuilder.Replace("{ProductList}", ProductsList);

            if (mailTO != "" && mailTO.Trim() != "")
            {

                string emailCC = string.Empty;
                if (!string.IsNullOrEmpty(mailCC))
                {
                    string[] mailCCList = mailCC.Split(',');
                    foreach (string email in mailCCList)
                    {
                        emailCC += email + ",";
                    }
                }

                if (!string.IsNullOrEmpty(emailCC))
                    emailCC = emailCC.TrimEnd(',');

                //PUSH TO EMIZON QUEUE
                if (hasEmizonProducts.HasValue && hasEmizonProducts.Value)
                {
                    EmizonOrderController.AddAPIRequestToQueue(emizonQueuePath, new Emizon.APIModels.MSMQTypes.QueueOrderMessage()
                    {
                        From = mailFrom,
                        To = mailTO,
                        CC = mailCC,
                        BCC = mailCC,
                        Subject = mailSubject,
                        OrderHTMLBody = objBuilder.ToString(),
                        orderID = orderID
                    });
                }
                else
                {
                    //Add below code to send the email message via msmq not smtp by Atiq on 06-01-2016 

                    //Remove Emizon placeholder
                    objBuilder.Replace("{EmizonData}", "");

                    SendEmailMessage sendEmail = new SendEmailMessage();
                    EmailMessage cslEmailMessage = new EmailMessage();
                    cslEmailMessage.From = mailFrom;
                    cslEmailMessage.To = mailTO;
                    cslEmailMessage.CC = emailCC;
                    cslEmailMessage.BCC = emailCC;
                    cslEmailMessage.Subject = mailSubject;
                    cslEmailMessage.Message = objBuilder.ToString();

                    sendEmail.SendEmailMessageToQueue(ConfigurationManager.AppSettings["QueueName"].ToString(), cslEmailMessage);
                }
            }
            //Connection Only Email
            ApplicationDTO appSettings = new AppSettings().GetAppValues();
            List<string> lstProductCodes = new List<string>();
            lstProductCodes = appSettings.ConnectionOnlyCodes.Split(',').ToList();

            bool connectionProductCodeExist = false;
            foreach (var x in distinctProduct)
            {
                if (lstProductCodes.Exists(e => e.EndsWith(x)))
                    connectionProductCodeExist = true;
            }

            //   bool connectionProductCodeExist = false;
            foreach (var x in products)
            {
                if (lstProductCodes.Exists(m => m.EndsWith(x.ToString())))
                {
                    connectionProductCodeExist = true;
                    break;
                }

            }
            if (connectionProductCodeExist)
            {
                #region buildURLs

                List<DCCCompany> lstDCCCompany = db.DCCCompanies.ToList();
                StringBuilder strURL = new StringBuilder();
                foreach (DCCCompany company in lstDCCCompany)
                {
                    var tableCodes = company.Productcode.Split(',').ToList();

                    foreach (string s in tableCodes)
                    {
                        if (distinctProduct.Contains(s)) //only create a link if the product exist in the basket items.
                        {
                            //strURL.Append("please click " + company.company_name + " - <a href='" + company.InstructionsUrl + "'>link</a>, ");
                            strURL.Append("please <a href='" + company.InstructionsUrl + "'>Click here for " + company.company_name + "</a> or ");
                            break; // once we add
                        }
                    }
                }


                #endregion

                string mailSubjectConnectionOnly = "ARC Connection Only - Order Confirmation - Order Ref: " + OrderNo;
                if (isEmailFromViewOrders)
                {
                    if (mailTO.EndsWith("@csldual.com")) { subjectsuffix = "; Email Resent"; }

                    mailSubjectConnectionOnly = mailSubjectConnectionOnly + subjectsuffix;

                }

                // String mailHtmlConnectionOnly = ReadTemplates.ReadMailTemplate(System.Web.HttpContext.Current.Server.MapPath(templatePath), "EmailTemplate_v2_ConnectionOrders.html");
                String mailHtmlConnectionOnly = ReadTemplates.ReadMailTemplate(System.Web.HttpContext.Current.Server.MapPath(templatePath), "EmailTemplate_ConnectionOrders.html");
                StringBuilder objBuilderConnectionOnly = new StringBuilder();
                objBuilderConnectionOnly.Append(mailHtmlConnectionOnly);
                objBuilderConnectionOnly.Replace("{InstallationURL}", strURL.ToString().TrimEnd(' ', 'o', 'r') + '.');

                objBuilderConnectionOnly.Replace("{OrderNo}", OrderNo);
                objBuilderConnectionOnly.Replace("{OrderDate}", sendEmailDTO.orderDate);
                objBuilderConnectionOnly.Replace("{OrderRef}", string.IsNullOrEmpty(sendEmailDTO.ARCOrderRefNo) ? "." : sendEmailDTO.ARCOrderRefNo);
                if (arc != null)
                {
                    objBuilderConnectionOnly.Replace("{Fax}", string.IsNullOrEmpty(arc.Fax) ? "." : arc.Fax);
                    objBuilderConnectionOnly.Replace("{Tel}", string.IsNullOrEmpty(arc.Telephone) ? "." : arc.Telephone);
                    objBuilderConnectionOnly.Replace("{ARC}", arcAdd);
                }

                objBuilderConnectionOnly.Replace("{Username}", sendEmailDTO.userName);
                objBuilderConnectionOnly.Replace("{UserEmail}", sendEmailDTO.userEmail);
                objBuilderConnectionOnly.Replace("{DeliveryTypeName}", sendEmailDTO.DdeliveryType);
                objBuilderConnectionOnly.Replace("{DeliveryTypePrice}", sendEmailDTO.deliveryCost);
                objBuilderConnectionOnly.Replace("{Installer}", InstallerBAL.GetAddressHTML2LineForEmail(new Guid(sendEmailDTO.installerID)));

                //comment below lines if activation new template is approved.
                if (instadd_differs)
                {
                    //string InsAddConnection = InstallerBAL.GetInstallationAddressHTML2LineForEmail(Convert.ToInt32(Session[enumSessions.OrderId.ToString()].ToString()));
                    string InsAddConnection = objorder.InstallationAddressId.HasValue ? InstallerBAL.GetAddressHTML2LineForEmail(objorder.InstallationAddressId.Value) : "Not Available";
                    objBuilderConnectionOnly.Replace("{InstallerAddress}", "<td><div style=\"width: 100%; margin: 0; padding: 0;\"><table border=\"0\" cellpadding=\"5\" cellspacing=\"0\" width=\"100%\"><tr><td style=\"text-align: left\"> <font color=\"#888\" size=\"2\" face=\"Arial\">" + InsAddConnection + " </font></td></tr></table></div></td>");
                    objBuilderConnectionOnly.Replace("{HeadingInstallerAdd}", "<td><h3 style=\"font-size:11px; text-align: center; margin: 0; padding: 5px auto;\">Installation Address</h3></td>");

                }
                else
                {
                    objBuilderConnectionOnly.Replace("{InstallerAddress}", "");
                    objBuilderConnectionOnly.Replace("{HeadingInstallerAdd}", "");

                }

                //
                objBuilderConnectionOnly.Replace("{DeliveredTo}", OrdersBAL.GetDeliveryAddressHTML2Line(Convert.ToInt32(sendEmailDTO.orderID)));
                objBuilderConnectionOnly.Replace("{SpecialInstructions}", string.IsNullOrEmpty(sendEmailDTO.specialInstructions) ? "." : sendEmailDTO.specialInstructions);
                ProductsList = Regex.Replace(ProductsList, @"(?i)<(table|tr|td)(?:\s+(?:""[^""]*""|'[^']*'|[^""'>])*)?>", "&lt;$1>");
                objBuilderConnectionOnly.Replace("{ProductList}", ProductsList);
                LinqToSqlDataContext dbx = new LinqToSqlDataContext();
                var connInstallerEmail = (from o in dbx.Orders
                                          join i in dbx.Installers on o.InstallerUnqCode equals i.UniqueCode.ToString()
                                          join ia in dbx.InstallerAddresses on i.AddressID equals ia.AddressID
                                          where o.OrderNo == OrderNo
                                          select ia.Email).Single();
                if (string.IsNullOrEmpty(connInstallerEmail))
                    connInstallerEmail = ConfigurationManager.AppSettings["TeleSalesEmail"].ToString();

                SendEmailMessage sendEmail = new SendEmailMessage();
                EmailMessage cslEmailMessage = new EmailMessage();
                cslEmailMessage.From = mailFrom;
                cslEmailMessage.To = connInstallerEmail;
                cslEmailMessage.CC = mailCC;
                cslEmailMessage.BCC = mailCC;
                cslEmailMessage.Subject = mailSubjectConnectionOnly;
                cslEmailMessage.Message = Convert.ToString(objBuilderConnectionOnly.ToString());

                sendEmail.SendEmailMessageToQueue(ConfigurationManager.AppSettings["QueueName"].ToString(), cslEmailMessage);

            }

            db.Dispose();
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(System.Web.HttpContext.Current.Request.Url.ToString(), "SendEmailWithoutPrice", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

    public static void SendEmailWithPrice(string OrderNo, string mailTO, SendEmailDTO sendEmailDTO,
        string mailFrom, string mailCC, bool isEmailFromViewOrders, bool? hasEmizonProducts, int orderID)
    {
        try
        {
            String ProductsList = "";
            bool instadd_differs = false;
            string subjectsuffix = string.Empty;
            string templatePath = "Template";
            SendEmailMessage sendEmail = new SendEmailMessage();
            EmailMessage cslEmailMessage = new EmailMessage();
            string emizonQueuePath = ConfigurationManager.AppSettings["EmizonQueue"].ToString();//could have used AppSettings but no point as another one is using config

            string mailSubject = "Order Confirmation - Order Ref: " + OrderNo;
            if (isEmailFromViewOrders)
            {
                if (mailTO.EndsWith("@csldual.com")) { subjectsuffix = "; Email Resent"; }

                mailSubject = mailSubject + subjectsuffix;
                templatePath = "../Template";
            }

            String mailHtml = ReadTemplates.ReadMailTemplate(System.Web.HttpContext.Current.Server.MapPath(templatePath), "EmailTemplate.html");
            StringBuilder objBuilder = new StringBuilder();
            objBuilder.Append(mailHtml);
            objBuilder.Replace("{OrderNo}", OrderNo);
            objBuilder.Replace("{OrderDate}", string.IsNullOrEmpty(sendEmailDTO.orderDate) ? "." : sendEmailDTO.orderDate);
            objBuilder.Replace("{OrderRef}", string.IsNullOrEmpty(sendEmailDTO.ARCOrderRefNo) ? "." : sendEmailDTO.ARCOrderRefNo);

            ARC arc = ArcBAL.GetArcInfoByUserId(new Guid(sendEmailDTO.userID));
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

            objBuilder.Replace("{Username}", sendEmailDTO.userName);
            objBuilder.Replace("{UserEmail}", sendEmailDTO.userEmail);

            // OrderDetails
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            var products = db.USP_GetBasketProducts(Convert.ToInt32(sendEmailDTO.orderID)).ToList();

            if (products != null && products.Count > 0)
            {
                string chipNos = "";
                int countOption = 1;

                foreach (var prod in products)
                {
                    int rowCount = db.USP_GetBasketProductsOnCheckOut(Convert.ToInt32(sendEmailDTO.orderID)).Where(i => i.ProductCode == prod.ProductCode.Trim()).Count();
                    ProductsList += "<tr><td style=\"background: #FFF7F7\">" + prod.ProductCode + "</td><td>" + prod.ProductName + "</td> <td style=\"background: #FFF7F7\">" + prod.ProductQty + "</td><td>£" + prod.Price;

                    if (prod.ProductType == "Product")
                    {
                        chipNos = "";
                        var ChipNumbers = db.USP_GetBasketGPRSChipNumbersByProductId(Convert.ToInt32(sendEmailDTO.orderID), prod.ProductId, prod.CategoryId).ToList();

                        if (ChipNumbers != null)
                        {

                            foreach (var chipno in ChipNumbers)
                            {
                                chipNos += string.IsNullOrEmpty(chipno.GPRSNo) ? "" : chipno.GPRSNo + "-";
                                chipNos += string.IsNullOrEmpty(chipno.PSTNNo) ? "" : chipno.PSTNNo + "-";
                                chipNos += string.IsNullOrEmpty(chipno.GSMNo) ? "" : chipno.GSMNo + "-";  //added GSM NO(PanelID) in email
                                chipNos += string.IsNullOrEmpty(chipno.OptionName) ? "" : chipno.OptionName;
                                chipNos += ",";

                                if (chipno.PSTNNo == "" &&
                                    chipno.OptionName == "" &&
                                    chipno.GSMNo == "" &&
                                    chipNos.Length > 0
                                    )//added GSM NO(PanelID) in email
                                {
                                    chipNos = chipNos.Remove(chipNos.Length - 1, 1);
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
                            var dependentproducts = db.USP_GetBasketDependentProductsByProductId(Convert.ToInt32(sendEmailDTO.orderID), prod.ProductId, prod.CategoryId).ToList();
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
                            var dependentproducts = db.USP_GetBasketDependentProductsByProductId(Convert.ToInt32(sendEmailDTO.orderID), prod.ProductId, prod.CategoryId).ToList();
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

            OrderDTO objorder = CSLOrderingARCBAL.BAL.OrdersBAL.GetOrderDetail(Convert.ToInt32(sendEmailDTO.orderID));
            //objBuilder.Replace("{OrderTotal}", Convert.ToDecimal(lblDtlsOrderTotal.Text).ToString("c"));
            objBuilder.Replace("{OrderTotal}", "£" + Convert.ToDecimal(objorder.OrderTotal));
            //objBuilder.Replace("{DeliveryTotal}", Convert.ToDecimal(lblDtlsDeliveryTotal.Text).ToString("c"));
            objBuilder.Replace("{DeliveryTotal}", "£" + Convert.ToDecimal(objorder.DeliveryCost));
            //objBuilder.Replace("{VAT}", Convert.ToDecimal(lblDtlsVAT.Text).ToString("c"));
            objBuilder.Replace("{VAT}", "£" + Convert.ToDecimal(objorder.VATAmount));
            //objBuilder.Replace("{TotalToPay}", Convert.ToDecimal(lblDtlsTotalToPay.Text).ToString("c"));
            objBuilder.Replace("{TotalToPay}", "£" + Convert.ToDecimal(objorder.TotalAmountToPay));
            objBuilder.Replace("{DeliveryTypeName}", string.IsNullOrEmpty(sendEmailDTO.DdeliveryType) ? "" : sendEmailDTO.DdeliveryType);
            objBuilder.Replace("{DeliveryTypePrice}", "£" + sendEmailDTO.deliveryCost);
            objBuilder.Replace("{Installer}", InstallerBAL.GetAddressHTML2LineForEmail(new Guid(sendEmailDTO.installerID)));

            if (objorder.InstallationAddressId > 0)
            {
                instadd_differs = true;
            }
            else
            {
                instadd_differs = false;
            }
            if (instadd_differs)// || sendEmailDTO.InstallationAddId != 0)
            {
                //string InsAdd = InstallerBAL.GetAddressHTML2LineForEmail(Convert.ToInt32(Session[enumSessions.PreviousOrderId.ToString()].ToString()));
                string InsAdd = objorder.InstallationAddressId.HasValue ? InstallerBAL.GetAddressHTML2LineForEmail(objorder.InstallationAddressId.Value) : "Not Available";
                objBuilder.Replace("{InstallerAddress}", "<td><div style=\"width: 100%; margin: 0; padding: 0;\"><table border=\"0\" cellpadding=\"5\" cellspacing=\"0\" width=\"100%\"><tr><td style=\"text-align: left\"> <font color=\"#888\" size=\"2\" face=\"Arial\">" + InsAdd + " </font></td></tr></table></div></td>");
                objBuilder.Replace("{HeadingInstallerAdd}", "<td><h3 style=\"font-size:11px; text-align: center; margin: 0; padding: 5px auto;\">Installation Address</h3></td>");

            }
            else
            {
                objBuilder.Replace("{InstallerAddress}", "");
                objBuilder.Replace("{HeadingInstallerAdd}", "");

            }
            objBuilder.Replace("{DeliveredTo}", OrdersBAL.GetDeliveryAddressHTML2Line(Convert.ToInt32(sendEmailDTO.orderID)));
            objBuilder.Replace("{SpecialInstructions}", sendEmailDTO.specialInstructions);
            if (isEmailFromViewOrders)
            {
                objBuilder.Append("Email Resent");
            }
            var distinctProduct = products.Select(i => i.ProductCode).Distinct();

            foreach (var pro in distinctProduct)
            {
                products = db.USP_GetBasketProducts(Convert.ToInt32(sendEmailDTO.orderID)).Where(p => p.ProductCode == pro).Take(1).ToList();

                foreach (var prod in products)
                {
                    if (prod.IsCSDUser == true)
                    {
                        ProductsList += "<tr><td>" + prod.ProductCode + "</td><td>" + prod.Message + "</td></tr>";
                    }
                }

            }
            objBuilder.Replace("{ProductList}", ProductsList);
            if (mailTO != "" && mailTO.Trim() != "")
            {
                string[] mailFromList = mailFrom.Split(',');
                string[] mailCCList = mailCC.Split(',');
                string emailCC = string.Empty;

                foreach (string email in mailCCList)
                {
                    emailCC += email + ",";
                }
                if (!string.IsNullOrEmpty(emailCC))
                    emailCC = emailCC.TrimEnd(',');


                //PUSH TO EMIZON QUEUE
                if (hasEmizonProducts.HasValue && hasEmizonProducts.Value)
                {
                    EmizonOrderController.AddAPIRequestToQueue(emizonQueuePath, new Emizon.APIModels.MSMQTypes.QueueOrderMessage()
                    {
                        From = mailFrom,
                        To = mailTO,
                        CC = mailCC,
                        BCC = mailCC,
                        Subject = mailSubject,
                        OrderHTMLBody = objBuilder.ToString(),
                        orderID = orderID
                    });
                }
                else
                {
                    //Add below code to send the email message via msmq not smtp -Priya 15/06/2017
                    //Remove Emizon placeholder
                    objBuilder.Replace("{EmizonData}", "");

                    cslEmailMessage.From = mailFrom;
                    cslEmailMessage.To = mailTO;
                    cslEmailMessage.CC = emailCC;
                    cslEmailMessage.BCC = emailCC;
                    cslEmailMessage.Subject = mailSubject;
                    cslEmailMessage.Message = objBuilder.ToString();

                    sendEmail.SendEmailMessageToQueue(ConfigurationManager.AppSettings["QueueName"].ToString(), cslEmailMessage);
                }
                //End Code sending email  to msmq.                
            }
            ApplicationDTO appSettings = new AppSettings().GetAppValues();
            List<string> lstProductCodes = new List<string>();
            lstProductCodes = appSettings.ConnectionOnlyCodes.Split(',').ToList();

            bool connectionProductCodeExist = false;
            foreach (var x in distinctProduct)
            {
                if (lstProductCodes.Exists(e => e.EndsWith(x)))
                    connectionProductCodeExist = true;

            }
            StringBuilder strURL = new StringBuilder();

            if (connectionProductCodeExist)
            {
                #region buildURLs

                List<DCCCompany> lstDCCCompany = db.DCCCompanies.ToList();

                foreach (DCCCompany company in lstDCCCompany)
                {
                    var tableCodes = company.Productcode.Split(',').ToList();

                    foreach (string s in tableCodes)
                    {
                        if (distinctProduct.Contains(s)) //only create a link if the product exist in the basket items.
                        {
                            strURL.Append(" please <a href='" + company.InstructionsUrl + "'>Click here for " + company.company_name + "</a> or ");
                            break; // once we add
                        }
                    }
                }


                #endregion


                string mailSubjectConnectionOnly = "ARC Connection Only - Order Confirmation - Order Ref: " + OrderNo;
                if (isEmailFromViewOrders)
                {
                    if (mailTO.EndsWith("@csldual.com")) { subjectsuffix = "; Email Resent"; }

                    mailSubjectConnectionOnly = mailSubjectConnectionOnly + subjectsuffix;

                }

                String mailHtmlConnectionOnly = ReadTemplates.ReadMailTemplate(System.Web.HttpContext.Current.Server.MapPath(templatePath), "EmailTemplate_ConnectionOrders.html");
                //  String mailHtmlConnectionOnly = ReadTemplates.ReadMailTemplate(System.Web.HttpContext.Current.Server.MapPath(templatePath), "EmailTemplate_v2_ConnectionOrders.html");
                StringBuilder objBuilderConnectionOnly = new StringBuilder();
                objBuilderConnectionOnly.Append(mailHtmlConnectionOnly);

                objBuilderConnectionOnly.Replace("{InstallationURL}", strURL.ToString().TrimEnd(' ', 'o', 'r') + '.');
                objBuilderConnectionOnly.Replace("{OrderNo}", OrderNo);
                objBuilderConnectionOnly.Replace("{OrderDate}", sendEmailDTO.orderDate);
                objBuilderConnectionOnly.Replace("{OrderRef}", string.IsNullOrEmpty(sendEmailDTO.ARCOrderRefNo) ? "." : sendEmailDTO.ARCOrderRefNo);
                objBuilderConnectionOnly.Replace("{OrderTotal}", "£" + objorder.OrderTotal);
                objBuilderConnectionOnly.Replace("{DeliveryTotal}", "£" + objorder.DeliveryCost);
                objBuilderConnectionOnly.Replace("{VAT}", "£" + objorder.VATAmount);
                objBuilderConnectionOnly.Replace("{TotalToPay}", "£" + objorder.TotalAmountToPay);
                objBuilderConnectionOnly.Replace("{DeliveryTypeName}", sendEmailDTO.DdeliveryType.ToString().TrimEnd(' '));
                // objBuilderConnectionOnly.Replace("{DeliveryTypePrice}", "£" + sendEmailDTO.deliveryCost);
                objBuilderConnectionOnly.Replace("{Installer}", InstallerBAL.GetAddressHTML2LineForEmail(new Guid(sendEmailDTO.installerID)));


                if (arc != null)
                {
                    objBuilderConnectionOnly.Replace("{Fax}", string.IsNullOrEmpty(arc.Fax) ? "." : arc.Fax);
                    objBuilderConnectionOnly.Replace("{Tel}", string.IsNullOrEmpty(arc.Telephone) ? "." : arc.Telephone);
                    objBuilderConnectionOnly.Replace("{ARC}", arcAdd);
                }

                objBuilderConnectionOnly.Replace("{Username}", sendEmailDTO.userName);
                objBuilderConnectionOnly.Replace("{UserEmail}", sendEmailDTO.userEmail);

                //comment below line if new RAc connection only template is approved
                if (instadd_differs)
                {

                    string InsAddConnection = objorder.InstallationAddressId.HasValue ? InstallerBAL.GetAddressHTML2LineForEmail(objorder.InstallationAddressId.Value) : "Not Available";
                    //string InsAddConnection= InstallerBAL.GetInstallationAddressHTML2LineForEmail(Convert.ToInt32(Session[enumSessions.OrderId.ToString()].ToString()));
                    objBuilderConnectionOnly.Replace("{InstallerAddress}", "<td><div style=\"width: 100%; margin: 0; padding: 0;\"><table border=\"0\" cellpadding=\"5\" cellspacing=\"0\" width=\"100%\"><tr><td style=\"text-align: left\"> <font color=\"#888\" size=\"2\" face=\"Arial\">" + InsAddConnection + " </font></td></tr></table></div></td>");
                    objBuilderConnectionOnly.Replace("{HeadingInstallerAdd}", "<td><h3 style=\"font-size:11px; text-align: center; margin: 0; padding: 5px auto;\">Installation Address</h3></td>");
                }
                else
                {
                    //objBuilderConnectionOnly.Replace("{InstallerAddress}", "");
                    // objBuilderConnectionOnly.Replace("{HeadingInstallerAdd}", "");
                    objBuilderConnectionOnly.Replace("{InstallerAddress}", "");
                    objBuilderConnectionOnly.Replace("{HeadingInstallerAdd}", "");
                }

                //

                objBuilderConnectionOnly.Replace("{DeliveredTo}", OrdersBAL.GetDeliveryAddressHTML2Line(Convert.ToInt32(sendEmailDTO.orderID)));
                objBuilderConnectionOnly.Replace("{SpecialInstructions}", string.IsNullOrEmpty(sendEmailDTO.specialInstructions.Trim()) ? "." : sendEmailDTO.specialInstructions.Trim());

                ProductsList = Regex.Replace(ProductsList, @"(?i)<(table|tr|td)(?:\s+(?:""[^""]*""|'[^']*'|[^""'>])*)?>", "<$1>");
                objBuilderConnectionOnly.Replace("{ProductList}", ProductsList);

                LinqToSqlDataContext dbe = new LinqToSqlDataContext();
                var connInstallerEmail = (from o in dbe.Orders
                                          join i in dbe.Installers on o.InstallerUnqCode equals i.UniqueCode.ToString()
                                          join ia in dbe.InstallerAddresses on i.AddressID equals ia.AddressID
                                          where o.OrderNo == OrderNo
                                          select ia.Email).Single();

                if (string.IsNullOrEmpty(connInstallerEmail))
                    connInstallerEmail = ConfigurationManager.AppSettings["TeleSalesEmail"].ToString();
                cslEmailMessage.From = mailFrom;
                cslEmailMessage.To = connInstallerEmail;
                cslEmailMessage.CC = mailCC;
                cslEmailMessage.BCC = mailCC;
                cslEmailMessage.Subject = mailSubjectConnectionOnly;
                cslEmailMessage.Message = Convert.ToString(objBuilderConnectionOnly.ToString());

                sendEmail.SendEmailMessageToQueue(ConfigurationManager.AppSettings["QueueName"].ToString(), cslEmailMessage);

            }

            db.Dispose();
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(System.Web.HttpContext.Current.Request.Url.ToString(), "SendEmailWithPrice",
                Convert.ToString(objException.Message), Convert.ToString(objException.InnerException),
                Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false,
                Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }
    }

}