using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace CSLOrderingARCBAL.BAL
{
    public class UploadMultipleOrdersBAL
    {
        /// <summary>
        /// The purpose of this method to upload the excel data from excel to BulkUploadMultipleOrders table in database.
        /// It is also validating each records and get back as result set which are valid to upload and which are not valid to upload.
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="ARC_Id"></param>
        /// <param name="userName"></param>
        /// <param name="userEmail"></param>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public static DataTable UplaodMultipleOrderProduct(DataSet ds, int ARC_Id,string userName,string userEmail,string UserId)
        {
            DataTable dtUploadOrders = new DataTable();
            dtUploadOrders = ds.Tables[0];
            DataTable dtResult = new DataTable();
            try
            {
                
                dtUploadOrders.Columns.Add("ID").SetOrdinal(0);
                dtUploadOrders.Columns.Add("UploadedBy").DefaultValue=userName;
                dtUploadOrders.Columns.Add("UploadedOn");
                dtUploadOrders.Columns.Add("IsAnyDuplicate");
                dtUploadOrders.Columns.Add("IsValidGPRSChipPostCode");
                dtUploadOrders.Columns.Add("IsValidPostCode");
                dtUploadOrders.Columns.Add("OptionID"); //ord:47
                dtUploadOrders.Columns.Add("Result");
                foreach(DataRow drUploadOrders in dtUploadOrders.Rows)
	            {
                   drUploadOrders["UploadedBy"] = userName;
                   drUploadOrders["IsValidGPRSChipPostCode"] = true;
                   drUploadOrders["IsValidPostCode"] = true;                                
                   drUploadOrders["Result"] = string.Empty;
                   var regexItem = new System.Text.RegularExpressions.Regex("^[a-zA-Z0-9 ]*$");                   
                   if (!string.IsNullOrEmpty(Convert.ToString(drUploadOrders["PostalCode"])))
                   {
                       if (!regexItem.IsMatch(Convert.ToString(drUploadOrders["PostalCode"])))
                       {
                           drUploadOrders["IsValidGPRSChipPostCode"] = false;
                       }
                   } 

                   if (!string.IsNullOrEmpty(Convert.ToString(drUploadOrders["PostCode"])))
                   {
                       if (!regexItem.IsMatch(Convert.ToString(drUploadOrders["PostCode"])))
                       {
                           drUploadOrders["IsValidPostCode"] = false;
                       }
                   }

                   if (!string.IsNullOrEmpty(Convert.ToString(drUploadOrders["OptionName"])))
                   {
                       using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                       {

                          //ORD:47
                          var optionID = (from options in db.Options where options.OptionName == drUploadOrders["OptionName"] select options.OptID).SingleOrDefault();
                          drUploadOrders["OptionID"] = optionID;
                       }
                       
                   }

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
                        
                        var deleteUploaded = db.BulkUploadMultipleOrders.Where(c => c.UploadedBy == userName); 
                        db.BulkUploadMultipleOrders.DeleteAllOnSubmit(deleteUploaded);                       
                        // set the destination table name
                        bulkCopy.DestinationTableName = "BulkUploadMultipleOrders";                                               
                        // write the data in the "dataTable"
                        bulkCopy.WriteToServer(dtUploadOrders);
                        dtUploadOrders.Clear();
                        using (cmd = new SqlCommand("USP_BulkUploadMultipleOrderProducts"))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Connection = con;
                            cmd.Parameters.AddWithValue("@ARC_Id", ARC_Id);
                            cmd.Parameters.AddWithValue("@UserName", userName);
                            cmd.Parameters.AddWithValue("@UserEmail", userEmail);
                            cmd.Parameters.AddWithValue("@UserId", UserId);
                            cmd.CommandTimeout = 180;
                            cmd.ExecuteNonQuery();
                        }
                        using (cmd = new SqlCommand("USP_GetBulkUploadedMultipleOrderProducts"))
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
            catch(Exception objException)
            {
                using (LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext())
                {
                    db.USP_SaveErrorDetails("UploadMultipleOrdersBAL", "UplaodMultipleOrderProduct", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, UserId);
                }
                return dtResult;
            }
           

        }
        /// <summary>
        /// The purpose of this method to create the multiple orders and order items based on on excel valid data.
        /// </summary>
        /// <param name="ARC_Id"></param>
        /// <param name="userName"></param>
        /// <param name="userEmail"></param>
        /// <param name="UserId"></param>
        /// <param name="isDuplicatesAllowed"></param>
        /// <returns></returns>
        public static int CreateUplaodedMultipleOrders(int ARC_Id, string userName, string userEmail, string UserId, bool isDuplicatesAllowed)
        {
            try
            {
                int intVal = 0;
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {
                    string conString = db.Connection.ConnectionString;
                    using (SqlConnection con = new SqlConnection(conString))
                    {
                        con.Open();
                        SqlCommand cmd = null;
                        using (cmd = new SqlCommand("USP_BulkUploadMultipleOrders"))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Connection = con;
                            cmd.Parameters.AddWithValue("@ARC_Id", ARC_Id);
                            cmd.Parameters.AddWithValue("@UserName", userName);
                            cmd.Parameters.AddWithValue("@UserEmail", userEmail);
                            cmd.Parameters.AddWithValue("@UserId", UserId);
                            cmd.Parameters.AddWithValue("@HasUserAcceptedDuplicates", isDuplicatesAllowed);
                            cmd.CommandTimeout = 180;
                            intVal = cmd.ExecuteNonQuery();
                        }
                        con.Close();
                    }

                }
                return intVal;
            }
            catch (Exception objException)
            {
                using (LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext())
                {
                    db.USP_SaveErrorDetails("UploadMultipleOrdersBAL", "UplaodMultipleOrderProduct", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, UserId);
                }
                return 0;
                
            }
        }
        /// <summary>
        /// The purpose of this method to get order items with order their order No's.
        /// </summary>
        /// <param name="userName"></param>
        /// <returns></returns>
        public static DataSet GetBulkUploadOrderItems(string userName)
        {
            DataSet dsUploadedOrderItems = new DataSet();
            try
            {
                using (LinqToSqlDataContext db = new LinqToSqlDataContext())
                {
                    string conString = db.Connection.ConnectionString;
                    using (SqlConnection con = new SqlConnection(conString))
                    {

                        SqlCommand cmd = null;
                        using (cmd = new SqlCommand("USP_GetUploadedMultipleOrderItems"))
                        {
                            using (SqlDataAdapter da = new SqlDataAdapter())
                            {
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Connection = con;
                                cmd.Parameters.AddWithValue("@UserName", userName);
                                da.SelectCommand = cmd;
                                da.Fill(dsUploadedOrderItems);
                            }
                        }
                        con.Close();
                    }
                }
                return dsUploadedOrderItems;
            }
            catch (Exception objException)
            {
                using (LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext())
                {
                    db.USP_SaveErrorDetails("UploadMultipleOrdersBAL", "UplaodedMultipleOrderItems", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, userName);
                }
                return dsUploadedOrderItems;
            }


        }
        /// <summary>
        /// The purpose of this method to get the uploaded proudcts but their orders not yet created.
        /// </summary>
        /// <param name="userName"></param>
        /// <returns></returns>
        public static DataTable GetBulkUploadedMultipleOrderProudcts(string userName)
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
                            using (cmd = new SqlCommand("USP_GetBulkUploadedMultipleOrderProducts"))
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
                        db.USP_SaveErrorDetails("UploadMultipleOrdersBAL", "GetBulkUploadedMultipleOrderProudcts", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false,userName);
                    }
                    return dtResult;

                }
       }       

    }
}
