using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace CSLOrderingARCBAL.BAL
{
    public class UploadOrderBAL
    {
        public static DataTable BulkUploadOrderProducts(DataSet ds, int ARC_Id, int OrderId, bool IsARC_AllowReturns,string userName, string UserId)
        {
            DataTable dtUploadOrders = new DataTable();
            DataTable dtResult = new DataTable();            
            try
            {
                dtUploadOrders.Columns.Add("ID");
                dtUploadOrders.Columns.Add("ProductCode");
                dtUploadOrders.Columns.Add("GPRSChipNo");
                dtUploadOrders.Columns.Add("GPRSChippostCode");
                dtUploadOrders.Columns.Add("ARC_Id");
                dtUploadOrders.Columns.Add("OrderId");
                dtUploadOrders.Columns.Add("IsARC_AllowReturns");
                dtUploadOrders.Columns.Add("UserId");
                dtUploadOrders.Columns.Add("Ident");
                dtUploadOrders.Columns.Add("OptionId");
                dtUploadOrders.Columns.Add("isCSD");
                dtUploadOrders.Columns.Add("IsReplenishment");
                dtUploadOrders.Columns.Add("SiteName");
                dtUploadOrders.Columns.Add("IsValidGPRSChipPostCode");
                dtUploadOrders.Columns.Add("UploadedBy");
                dtUploadOrders.Columns.Add("UploadedOn");
                dtUploadOrders.Columns.Add("Result");
                dtUploadOrders.Columns.Add("IsAnyDuplicate");
                dtUploadOrders.Columns.Add("GSMNo");
                String Ident = String.Empty;
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    bool IsValidGPRSChipPostCode = true;                   
                    var regexItem = new System.Text.RegularExpressions.Regex("^[a-zA-Z0-9 ]*$");
                    if (!regexItem.IsMatch(dr["PostCode"].ToString()))
                    {
                        IsValidGPRSChipPostCode = false;
                    }
                    DataRow drUploadOrders = dtUploadOrders.NewRow();
                    //drUploadOrders["ID"] = id;
                    drUploadOrders["ProductCode"] = dr["ProductCode"].ToString();
                    // GPRS field name changed to GPRSChipNo in template as per suggested by Ravi
                    //on 19-jan-2017.
                    //drUploadOrders["GPRSChipNo"] = dr["GPRS"].ToString().Trim();
                    drUploadOrders["GPRSChipNo"] = dr["GPRSChipNo"].ToString().Trim();
                    drUploadOrders["GPRSChippostCode"] = dr["PostCode"].ToString().Trim();
                    drUploadOrders["ARC_Id"] = ARC_Id;
                    drUploadOrders["OrderId"] = OrderId;
                    drUploadOrders["IsARC_AllowReturns"] = IsARC_AllowReturns;
                    drUploadOrders["UserId"] = UserId;
                    // Ident field name changed to ActivatingICCID in template as per suggested by Ravi
                    //on 19-jan-2017.
                    //drUploadOrders["Ident"] = dr["Ident"].ToString().Trim();
                    drUploadOrders["Ident"] = dr["ActivatingICCID"].ToString().Trim();

                    drUploadOrders["OptionId"] = 0;
                    if (!String.IsNullOrEmpty(dr["ActivatingICCID"].ToString()))
                    {
                        drUploadOrders["isCSD"] = true;
                    }
                    else
                    {
                        drUploadOrders["isCSD"] = false;
                    }
                    drUploadOrders["IsReplenishment"] = false;
                    drUploadOrders["SiteName"] = dr["Sitename"].ToString().Trim();
                    drUploadOrders["IsValidGPRSChipPostCode"] = IsValidGPRSChipPostCode;
                    drUploadOrders["UploadedBy"] = userName;
                    drUploadOrders["UploadedOn"] = DateTime.Now;
                    drUploadOrders["Result"] = "Error - some logic is missing";
                    drUploadOrders["IsAnyDuplicate"] =false;
                    //GSMNo field name changed to PanelID in template as per suggested by Ravi
                    //on 19-jan-2017.
                    //drUploadOrders["GSMNo"] = dr["GSMNo"].ToString().Trim();
                    drUploadOrders["GSMNo"] = dr["PanelID"].ToString().Trim();
                    dtUploadOrders.Rows.Add(drUploadOrders);

                }
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {
                    string conString = db.Connection.ConnectionString;
                    using (SqlConnection con = new SqlConnection(conString))
                    {

                        SqlCommand cmd = null;
                        SqlBulkCopy bulkCopy = new SqlBulkCopy(con, SqlBulkCopyOptions.TableLock | SqlBulkCopyOptions.FireTriggers | SqlBulkCopyOptions.UseInternalTransaction,
                        null
                        );
                        con.Open();
                        var deleteUploaded = db.BulkUploadOrders.Where(c => c.UploadedBy == userName);
                        db.BulkUploadOrders.DeleteAllOnSubmit(deleteUploaded);
                        db.SubmitChanges();
                        // set the destination table name
                        bulkCopy.DestinationTableName = "BulkUploadOrders";                        
                        // write the data in the "dataTable"
                        bulkCopy.WriteToServer(dtUploadOrders);
                        dtUploadOrders.Clear();
                        using (cmd = new SqlCommand("USP_BulkUploadOrderProducts"))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Connection = con;
                            cmd.Parameters.AddWithValue("@ARC_Id", ARC_Id);
                            cmd.Parameters.AddWithValue("@OrderId", OrderId);                           
                            cmd.CommandTimeout = 300;
                            var testval = cmd.ExecuteNonQuery();
                        }
                        using (cmd = new SqlCommand("USP_BulkUploadOrderResults"))
                        {
                            using (SqlDataAdapter da = new SqlDataAdapter())
                            {
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Connection = con;
                                cmd.Parameters.AddWithValue("@UserName",userName);
                                da.SelectCommand = cmd;
                                da.Fill(dtResult);                                 
                            }

                        }
                        con.Close();
                    }
                }
                return dtResult;
            }
            catch(Exception objException)
            {
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {
                    db.USP_SaveErrorDetails("UploadOrderBAL", "UplaodOrderProduct", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, UserId);
                    return dtResult;
                }
            }
        }
        public static int UploadOrderItems(int ARC_Id, int OrderId, bool IsARC_AllowReturns, string userName, string UserId)
        {
            int resultVal = 0;
            try
            {
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {
                    string conString = db.Connection.ConnectionString;
                    using (SqlConnection con = new SqlConnection(conString))
                    {  
                        SqlCommand cmd = null;
                        SqlBulkCopy bulkCopy = new SqlBulkCopy(con, SqlBulkCopyOptions.TableLock | SqlBulkCopyOptions.FireTriggers | SqlBulkCopyOptions.UseInternalTransaction,
                        null
                        );
                        con.Open();                        
                        using (cmd = new SqlCommand("USP_UploadOrderProduct"))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Connection = con;
                            cmd.Parameters.AddWithValue("@ARC_Id", ARC_Id);
                            cmd.Parameters.AddWithValue("@OrderId", OrderId);
                            cmd.Parameters.AddWithValue("@IsARC_AllowReturns", IsARC_AllowReturns);
                            cmd.Parameters.AddWithValue("@UserId", UserId);
                            cmd.Parameters.AddWithValue("@OptionId", 0);
                            cmd.Parameters.AddWithValue("@IsReplenishment", false);
                            cmd.Parameters.AddWithValue("@UserName", userName);
                            cmd.CommandTimeout = 300;
                            resultVal = cmd.ExecuteNonQuery();
                        }                        
                        con.Close();
                    }
                }
                return resultVal;
            }
            catch (Exception objException)
            {
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {
                    db.USP_SaveErrorDetails("UploadOrderBAL", "UploadOrderItems", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, UserId);
                    return -1;
                }
            }
        }
        public static List<string> GetProductsByARCId(int arcid)
        {
            List<string> products = new List<string>();
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            var prods = (from arc in db.Product_ARC_Maps
                         join prod in db.Products on arc.ProductId equals prod.ProductId
                         where arc.ARCId == arcid
                         orderby prod.ProductCode
                         select prod
                            ).ToList();
            foreach (var item in prods)
            {
                products.Add(item.ProductCode.ToString().ToUpper() + " - " + item.ProductName);
            }

            return products;

        }
        /// <summary>
        /// The purpose of this method to get the uploaded proudcts but the order is not yet created.
        /// </summary>
        /// <param name="userName"></param>
        /// <returns></returns>
        public static DataTable GetBulkUploadedOrderProudcts(string userName)
        {

            DataTable dtResult = new DataTable();
            try
            {
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {
                    string conString = db.Connection.ConnectionString;
                    using (SqlConnection con = new SqlConnection(conString))
                    {
                        SqlCommand cmd = null;
                        con.Open();
                        using (cmd = new SqlCommand("USP_BulkUploadOrderResults"))
                        {
                            using (SqlDataAdapter da = new SqlDataAdapter())
                            {
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Connection = con;
                                cmd.Parameters.AddWithValue("@UserName", userName);
                                da.SelectCommand = cmd;
                                da.Fill(dtResult);
                            }
                        }
                        con.Close();
                    }

                }
                return dtResult;
            }
            catch (Exception objException)
            {
                using (LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext())
                {
                    db.USP_SaveErrorDetails("UploadOrderBAL", "GetBulkUploadedOrderProudcts", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, userName);
                }
                return dtResult;

            }
        }       
    }
}
