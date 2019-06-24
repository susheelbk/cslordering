using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CSLOrderingARCBAL.Common;

namespace CSLOrderingARCBAL.BAL
{
    public class InstallerBAL
    {
        /// <summary>
        ///   The purpose of this method to get the installer adddress by installer id.
        /// </summary>
        /// <param name="InstallerId"></param>
        /// <returns></returns>
        public static string GetAddressHTML2Line(Guid InstallerId)
        {
            StringBuilder strAddress = new StringBuilder();
            try
            {
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {
                    /* This change is made to get the company name */
                    USP_GetInstallerAddressByInstallerIdResult address = db.USP_GetInstallerAddressByInstallerId(InstallerId.ToString()).SingleOrDefault();
                    if (address == null) return "";
                    strAddress.AppendLine("<p style='padding-left:15px;'><b>" + address.CompanyName + "</b><br/>");
                    strAddress.Append(address.AddressOne + ", ");
                    if (!string.IsNullOrEmpty(address.AddressTwo))
                    {
                        strAddress.Append(address.AddressTwo + ", ");
                    }
                    if (!string.IsNullOrEmpty(address.Town))
                    {
                        strAddress.Append(address.Town + ", ");
                    }
                    if (!string.IsNullOrEmpty(address.County))
                    {
                        strAddress.Append(address.County + "<br/>");
                    }
                    else
                    {
                        strAddress.Append("<br/>");
                    }
                    if (!string.IsNullOrEmpty(address.PostCode))
                    {
                        strAddress.Append(address.PostCode + "<br/>");
                    }
                    if (!string.IsNullOrEmpty(address.Mobile))
                    {
                        strAddress.Append(address.Mobile + ", ");
                    }
                    if (!string.IsNullOrEmpty(address.Telephone))
                    {
                        strAddress.Append(address.Telephone + ", ");
                    }
                    if (!string.IsNullOrEmpty(address.Fax))
                    {
                        strAddress.Append(address.Fax);
                    }
                    strAddress.Append("<br/></p>");
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return strAddress.ToString();
        }

        /// <summary>
        /// The purpose of this method to get the installer adddress for email by installer id.
        /// </summary>
        /// <param name="InstallerId"></param>
        /// <returns></returns>
        public static string GetAddressHTML2LineForEmail(Guid InstallerId)
        {
            string strAddress = string.Empty;
            try
            {
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {
                    /* This change is made to get the company name */
                    USP_GetInstallerAddressByInstallerIdResult address = db.USP_GetInstallerAddressByInstallerId(InstallerId.ToString()).SingleOrDefault();
                    if (address == null) return " ";
                    string NOTSPECIFIED = " ";
                    strAddress += string.IsNullOrEmpty(address.CompanyName) ? NOTSPECIFIED.Trim() : "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + address.CompanyName + ", " + " <br /> ";
                    strAddress += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + address.AddressOne + ", " + " <br /> ";
                    strAddress += string.IsNullOrEmpty(address.AddressTwo) ? NOTSPECIFIED.Trim() : "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + address.AddressTwo + ", " + " <br /> ";
                    strAddress += string.IsNullOrEmpty(address.Town) ? NOTSPECIFIED.Trim() : "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + address.Town + ", ";
                    strAddress += string.IsNullOrEmpty(address.County) ? NOTSPECIFIED.Trim() : address.County + ", ";
                    strAddress += string.IsNullOrEmpty(address.PostCode) ? NOTSPECIFIED.Trim() : "<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + address.PostCode + ", <br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    strAddress += string.IsNullOrEmpty(address.Fax) ? NOTSPECIFIED.Trim() : " Fax: " + address.Fax;
                    strAddress += string.IsNullOrEmpty(address.Mobile) ? NOTSPECIFIED.Trim() : ", Mob: " + address.Mobile;
                    strAddress += string.IsNullOrEmpty(address.Telephone) ? NOTSPECIFIED.Trim() : " Tel: " + address.Telephone;
                    if (strAddress.LastIndexOf(",") > 0)
                        strAddress = strAddress.Remove(strAddress.LastIndexOf(","));
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return strAddress;
        }



        /// <summary>
        /// The purpose of this method to get installation address details using Address ID.
        /// </summary>
        /// <param name="AddressID"></param>
        /// <returns></returns>
        public static string GetAddressHTML2LineForEmail(int AddressID)
        {
            if (AddressID == 0) {
                return "";
            }

            string strAddress = string.Empty;
            try
            {
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {
                    Address address = new Address();
                    address = (from add in db.Addresses
                               where add.AddressID == AddressID
                               select add).SingleOrDefault();
                    if (address == null) return "";

                    string NOTSPECIFIED = " ";
                    strAddress = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + address.ContactName + " <br /> ";
                    strAddress += string.IsNullOrEmpty(address.CompanyName) ? NOTSPECIFIED.Trim() : "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + address.CompanyName + ", " + " <br /> ";
                    strAddress += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + address.AddressOne + ", " + " <br /> ";
                    strAddress += string.IsNullOrEmpty(address.AddressTwo) ? NOTSPECIFIED.Trim() : "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + address.AddressTwo + ", " + " <br /> ";
                    strAddress += string.IsNullOrEmpty(address.Town) ? NOTSPECIFIED.Trim() : "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + address.Town + ", ";
                    strAddress += string.IsNullOrEmpty(address.County) ? NOTSPECIFIED : address.County + ", ";
                    strAddress += string.IsNullOrEmpty(address.PostCode) ? NOTSPECIFIED.Trim() : " <br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + address.PostCode + ", <br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    strAddress += string.IsNullOrEmpty(address.Fax) ? NOTSPECIFIED.Trim() : " Fax: " + address.Fax;
                    strAddress += string.IsNullOrEmpty(address.Mobile) ? NOTSPECIFIED.Trim() : "Mob: " + address.Mobile;
                    strAddress += string.IsNullOrEmpty(address.Telephone) ? NOTSPECIFIED.Trim() : ", Tel: " + address.Telephone;
                    if (strAddress.LastIndexOf(",") > 0)
                        strAddress = strAddress.Remove(strAddress.LastIndexOf(","));

                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return strAddress;
        }


        /// <summary>
        /// The purpose of this method to get country list.
        /// </summary>
        /// <returns></returns>
        public static List<CountryMaster> GetCountries()
        {
            List<CountryMaster> countryList = new List<CountryMaster>();
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                countryList = (from countries in db.CountryMasters
                               select countries).ToList();
            }
            return countryList;
        }
        /// <summary>
        /// The purpose of this to save new installer address.
        /// </summary>
        /// <param name="InstallerId"></param>
        /// <param name="ContactName"></param>
        /// <param name="contactno"></param>
        /// <param name="CountryId"></param>
        /// <param name="AddressOne"></param>
        /// <param name="AddressTwo"></param>
        /// <param name="Town"></param>
        /// <param name="County"></param>
        /// <param name="PostCode"></param>
        /// <param name="Country"></param>
        /// <param name="CreatedBy"></param>
        /// <returns></returns>
        public static int SaveInstallerAddress(string InstallerId, string ContactName, string contactno, int CountryId, string AddressOne, string AddressTwo, string Town, string County, string PostCode, string Country, string CreatedBy)
        {
            int AddressId = 0;
            try
            {
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {

                    var address = db.USP_SaveInstallerAddress(InstallerId, ContactName, contactno, CountryId, AddressOne, AddressTwo, Town, County, PostCode, Country, CreatedBy).SingleOrDefault();
                    if (address != null)
                    {
                        if (address.AddressId.HasValue)
                        {
                            int.TryParse(address.AddressId.Value.ToString(), out AddressId);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return AddressId;
        }
        /// <summary>
        /// The purpose of this adddress to get the installer details for passing installer unique code.
        /// </summary>
        /// <param name="uniquecode"></param>
        /// <returns></returns>
        public static VW_InstallerDetail GetInstaller(string uniquecode)
        {
            VW_InstallerDetail installer = null;
            try
            {
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {

                    installer = (from installers in db.VW_InstallerDetails
                                 where installers.UniqueCode == Convert.ToInt32(uniquecode)
                                 select installers).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return installer;
        }
        /// <summary>
        /// The purpose of this method to get installer address for the passing installer id.
        /// </summary>
        /// <param name="InstallerId"></param>
        /// <returns></returns>
        public static string GetInstallerAddress(Guid InstallerId)
        {
            StringBuilder strAddress = new StringBuilder();
            try
            {
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {
                    USP_GetInstallerAddressByInstallerIdResult address = db.USP_GetInstallerAddressByInstallerId(InstallerId.ToString()).SingleOrDefault();
                    if (address == null) return " ";
                    strAddress.AppendLine(address.CompanyName);
                    strAddress.Append(address.AddressOne + ", ");
                    if (!string.IsNullOrEmpty(address.AddressTwo))
                    {
                        strAddress.Append(address.AddressTwo + ", ");
                    }
                    if (!string.IsNullOrEmpty(address.Town))
                    {
                        strAddress.Append(address.Town + ", ");
                    }
                    if (!string.IsNullOrEmpty(address.County))
                    {
                        strAddress.Append(address.County);
                    }
                    else
                    {
                        strAddress.Append(" ");
                    }

                    if (!string.IsNullOrEmpty(address.PostCode))
                    {
                        strAddress.Append(address.PostCode + " ");
                    }

                    if (!string.IsNullOrEmpty(address.Mobile))
                    {
                        strAddress.Append(address.Mobile + ", ");
                    }
                    if (!string.IsNullOrEmpty(address.Telephone))
                    {
                        strAddress.Append(address.Telephone + ", ");
                    }
                    if (!string.IsNullOrEmpty(address.Fax))
                    {
                        strAddress.Append(address.Fax);
                    }
                    strAddress.Append(" ");
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return strAddress.ToString();
        }
        /// <summary>
        /// The purpose of this method to get full delivery address for the passing address id.
        /// </summary>
        /// <param name="addressId"></param>
        /// <returns></returns>
        public static string GetDeliveryAddressByAddressId(int addressId)
        {
            StringBuilder strAddress = new StringBuilder();
            try
            {
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {
                    /* This change is made to get the company name */
                    var address = db.Addresses.Where(x => x.AddressID == addressId).SingleOrDefault();
                    if (address != null)
                    {
                        strAddress.AppendLine(address.ContactName + ",");
                        strAddress.Append(address.AddressOne + ", ");
                        if (!string.IsNullOrEmpty(address.AddressTwo))
                        {
                            strAddress.Append(address.AddressTwo + ", ");
                        }
                        if (!string.IsNullOrEmpty(address.Town))
                        {
                            strAddress.Append(address.Town + ", ");
                        }
                        if (!string.IsNullOrEmpty(address.County))
                        {
                            strAddress.Append(address.County);
                        }
                        else
                        {
                            strAddress.Append(" ");
                        }
                        if (!string.IsNullOrEmpty(address.PostCode))
                        {
                            strAddress.Append(address.PostCode + " ");
                        }
                        if (!string.IsNullOrEmpty(address.Mobile))
                        {
                            strAddress.Append(address.Mobile + ", ");
                        }
                        if (!string.IsNullOrEmpty(address.Telephone))
                        {
                            strAddress.Append(address.Telephone + ", ");
                        }
                        if (!string.IsNullOrEmpty(address.Fax))
                        {
                            strAddress.Append(address.Fax);
                        }
                        strAddress.Append(" ");
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return strAddress.ToString();
        }
        /// <summary>
        /// The purpose of this method to get the delivery address with contact name,town and zip code for the paasing address id.
        /// </summary>
        /// <param name="addressId"></param>
        /// <returns></returns>
        public static string GetShortDeliveryAddressByAddressId(int addressId)
        {
            StringBuilder strAddress = new StringBuilder();
            try
            {
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {
                    var address = db.Addresses.Where(x => x.AddressID == addressId).SingleOrDefault();
                    if (address != null)
                    {
                        if (!string.IsNullOrEmpty(address.FirstName) && !string.IsNullOrEmpty(address.Lastname))
                        {
                            strAddress.AppendLine(address.FirstName + " " + address.Lastname);
                        }
                        else
                        {
                            strAddress.AppendLine(address.ContactName + ",");
                        }
                        if (!string.IsNullOrEmpty(address.Town))
                        {
                            strAddress.Append(address.Town + ", ");
                        }
                        if (!string.IsNullOrEmpty(address.PostCode))
                        {
                            strAddress.Append(address.PostCode);
                        }
                        strAddress.Append(" ");
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return strAddress.ToString();
        }

    }
}
