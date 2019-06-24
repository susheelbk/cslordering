using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Data.Linq;
using System.Data.Linq.SqlClient;
using CSLOrderingARCBAL;
using CSLOrderingARCBAL.BAL;
using CSLOrderingARCBAL.Common;
using System.Text;
using System.Web.Caching;
using System.Linq;

namespace CSLOrderingARCBAL.BAL
{

    public class AppSettings : System.Web.UI.Page
    {

        public ApplicationDTO GetAppValues()
        {
            ApplicationDTO app = new ApplicationDTO();

            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                var settingsKeyValuePairs = db.ApplicationSettings; // only one query to database to get all settings is better than quering multiples times for each key

                foreach (ApplicationSetting key in settingsKeyValuePairs)
                {
                    switch (key.KeyName)
                    {
                        case "VATRate":
                            app.VATRate = string.IsNullOrEmpty(key.KeyValue) ? 0 : Convert.ToDecimal(key.KeyValue);
                            break;
                        case "smtphost":
                            app.smtphost = key.KeyValue;
                            break;
                        case "OrdersEmailFrom":
                            app.mailFrom = key.KeyValue;
                            break;
                        case "EmailCC":
                            app.mailCC = key.KeyValue;
                            break;
                        case "LogisticsEmail":
                            app.mailTO = key.KeyValue;
                            break;
                        case "BillingEmail":
                            app.billingemail = key.KeyValue;
                            break;
                        case "FedexURL":
                            app.FedexURL = key.KeyValue;
                            break;
                        case "ConnectionOnlyCodes":
                            app.ConnectionOnlyCodes = key.KeyValue;
                            break;
                        default:
                            break;
                    }

                }//end foreach

            }


            //insert all the values in cache - Best to remove below and also the reference if the below cache keys are not used
            HttpRuntime.Cache.Insert("VATRate", app.VATRate);
            HttpRuntime.Cache.Insert("smtphost", app.smtphost);
            HttpRuntime.Cache.Insert("OrdersEmailFrom", app.mailFrom);
            HttpRuntime.Cache.Insert("EmailCC", app.mailCC);
            HttpRuntime.Cache.Insert("LogisticsEmail", app.mailTO);
            HttpRuntime.Cache.Insert("BillingEmail", app.billingemail);
            //HttpRuntime.Cache.Insert("ARCCC", app.ARC_CC);
            return app;
        }
    }
}



