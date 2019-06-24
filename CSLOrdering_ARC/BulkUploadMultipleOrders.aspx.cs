using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Odbc;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL.BAL;
using System.Text;
using System.Threading;
using CSLOrderingARCBAL;

public partial class BulkUploadMultipleOrders : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session[enumSessions.User_Id.ToString()] == null)
            Response.Redirect("Login.aspx");
        if (!IsPostBack)
        {
            GetBulkUploadedMultipleOrderProudcts();
            GetBulkUploadOrderedItems();
            
        }
    } 
    protected void btnUpload_Click(object sender, EventArgs e)
    {
        try
        {
            //divLoader.Style.Add("display","block");
            DataSet ds = new DataSet();
            String fileNameToUpload = String.Empty;
            if (fileUploadCon.HasFile)
            {
               // ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", "showProgressBar(1);", true);
                string fileExt = Path.GetExtension(fileUploadCon.FileName);
                if (fileExt == ".xls" || fileExt == ".xlsx" || fileExt == ".txt" || fileExt == ".csv")
                {
                    string fileNameWithoutExt = System.IO.Path.GetFileNameWithoutExtension(fileUploadCon.PostedFile.FileName);
                    fileNameToUpload = fileNameWithoutExt + Session[enumSessions.User_Name.ToString()].ToString() + DateTime.Now.Ticks + fileExt;
                    string dirfileNameWithPath = Server.MapPath("UploadedOrders") + "\\";
                    bool dirExisting = Directory.Exists(dirfileNameWithPath);
                    if (!dirExisting)
                    {
                        Directory.CreateDirectory(dirfileNameWithPath);
                    }
                    string fileNameWithPath = dirfileNameWithPath + fileNameToUpload;
                    fileUploadCon.SaveAs(fileNameWithPath);
                    if (fileExt == ".xls" || fileExt == ".xlsx")
                    {
                        ds = ReadExcel(fileNameToUpload);
                        if (ds.Tables[0].Rows.Count > 250)
                        {
                            string script = "alertify.alert('" + ltrUploadLimit.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            return;
                        }
                    }
                    else if (fileExt == ".txt" || fileExt == ".csv")
                    {
                        ds = ReadCSV(fileNameToUpload);
                        if (ds.Tables[0].Rows.Count > 250)
                        {
                            string script = "alertify.alert('" + ltrUploadLimit.Text + "');";
                            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                            return;
                        }
                    }

                    if (File.Exists(fileNameWithPath))
                    {
                        File.Delete(fileNameWithPath);
                    }
                }
                else
                {
                    string script = "alertify.alert('" + ltrFileType.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                }
            }
            else
            {
                string script = "alertify.alert('" + ltrSelectFile.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                
            }

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
               
                int ARC_Id = Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString());
                bool IsARC_AllowReturns = Convert.ToBoolean(Session[enumSessions.IsARC_AllowReturns.ToString()].ToString());
                string UserId = Convert.ToString(Session[enumSessions.User_Id.ToString()].ToString());
                DataTable dtResult = UploadMultipleOrdersBAL.UplaodMultipleOrderProduct(ds, ARC_Id, Session[enumSessions.User_Name.ToString()].ToString(), Session[enumSessions.User_Email.ToString()].ToString(), UserId);
                dtResult.DefaultView.RowFilter = "Result = 'Success'";
                if (dtResult.DefaultView.Count > 0)
                {
                    divValidProducts.Visible = true;
                    rptUploadedProducts.DataSource = dtResult.DefaultView;
                    rptUploadedProducts.DataBind();
                    trUploadedProducts.Visible = true;
                    btnProceed.Visible = true;
                    
                }

                dtResult.DefaultView.RowFilter = "";
                dtResult.DefaultView.RowFilter = "Result <> 'Success'";
                if (dtResult.DefaultView.Count > 0)
                {
                    divNotValidProducts.Visible = true;
                    rptErrorProducts.DataSource = dtResult.DefaultView;
                    rptErrorProducts.DataBind();
                    trCouldNotUpload.Visible = true;
                }

                dtResult.DefaultView.RowFilter = "";
                dtResult.DefaultView.RowFilter = "IsAnyDuplicate = true"; 
                if (dtResult.DefaultView.Count > 0)
                {
                    string script = "alertify.alert('" + ltrDuplicate.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    divDuplicatesAllowed.Visible = true;
                }        
               
            }
           
        }
        catch (Exception objException)
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnUpload_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            }
        }
    }
    protected void lnkbtndownload_Click(object sender, EventArgs e)
    {

        DirectoryInfo thisFolder = new DirectoryInfo(Server.MapPath("Template"));
        if (!thisFolder.Exists)
        {
            thisFolder.Create();
        }
        string filepath = Server.MapPath("Template/CSLMultipleOrdersTemplate.xls");
        FileInfo file = new FileInfo(filepath);
        if (file.Exists)
        {
            Response.Clear();
            Response.ClearHeaders();
            Response.ClearContent();
            Response.AddHeader("content-disposition", "attachment; filename=" + file.Name);
            Response.AddHeader("Content-Type", "application/Excel");
            Response.ContentType = "application/vnd.xls";
            Response.AddHeader("Content-Length", file.Length.ToString());
            Response.WriteFile(file.FullName);
            Response.End();
        }
        else
        {
            lbltemplatemsg.Text = "The file does not exists";
        }
    }
    protected void lnkbtnProduclist_Click(object sender, EventArgs e)
    {
        //birng products of users ARC
        List<string> ArcProducts = UploadOrderBAL.GetProductsByARCId(Convert.ToInt16(Session[enumSessions.ARC_Id.ToString()]));
        string Products = "PRODUCT NAMES";
        DataTable table = new DataTable();
        DataRow row;
        table.Columns.Add(Products);
        foreach (string item in ArcProducts)
        {
            row = table.NewRow();
            row[Products] = item;
            table.Rows.Add(row);
        }
        StringBuilder csv = new StringBuilder(10 * table.Rows.Count * table.Columns.Count);
        for (int c = 0; c < table.Columns.Count; c++)
        {
            if (c > 0)
                csv.Append(",");
            DataColumn dc = table.Columns[c];
            string columnTitleCleaned = CleanCSVString(dc.ColumnName);
            csv.Append(columnTitleCleaned);
        }
        csv.Append(Environment.NewLine);
        foreach (DataRow dr in table.Rows)
        {
            StringBuilder csvRow = new StringBuilder();
            for (int c = 0; c < table.Columns.Count; c++)
            {
                if (c != 0)
                    csvRow.Append(",");

                object columnValue = dr[c];
                if (columnValue == null)
                    csvRow.Append("");
                else
                {
                    string columnStringValue = columnValue.ToString();
                    string cleanedColumnValue = CleanCSVString(columnStringValue);
                    if (columnValue.GetType() == typeof(string) && !columnStringValue.Contains(","))
                    {
                        cleanedColumnValue = "=" + cleanedColumnValue; // Prevents a number stored in a string from being shown as 8888E+24 in Excel. Example use is the AccountNum field in CI that looks like a number but is really a string.
                    }
                    csvRow.Append(cleanedColumnValue);
                }
            }
            csv.AppendLine(csvRow.ToString());
        }
        Response.ContentEncoding = Encoding.Default;
        Response.ContentType = "text/csv";
        Response.AppendHeader("Content-Disposition", "attachment;filename=CSL_DualCom_ProductCodes.csv");
        Response.Write(csv.ToString());
        Response.End();


    }  
    protected void btnProceed_Click(object sender, EventArgs e)
    {
        try
        {
            
            if (rptUploadedProducts.Items.Count > 0 && rptBasketItems.Items.Count >0)
            {
                int resultVal = 0;
                int ARC_Id = Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString());
                string UserId = Convert.ToString(Session[enumSessions.User_Id.ToString()].ToString());
                resultVal = UploadMultipleOrdersBAL.CreateUplaodedMultipleOrders(ARC_Id, Session[enumSessions.User_Name.ToString()].ToString(), Session[enumSessions.User_Email.ToString()].ToString(), UserId, chkDuplicatesAllowed.Checked);
                Response.Redirect("UploadMultipleOrdersCheckout.aspx");
            }
            else if(rptUploadedProducts.Items.Count > 0)
            {
                LinqToSqlDataContext db=new LinqToSqlDataContext();
                var data = db.BulkUploadMultipleOrders.Where(items => items.IsAnyDuplicate == false && items.Result == "Success");
                if(!chkDuplicatesAllowed.Checked && data.ToList().Count==0)
                {
                    string script = "alertify.alert('" + ltrAllItemsDuplicated.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    return;
                }
                int resultVal = 0;
                int ARC_Id = Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString());
                string UserId = Convert.ToString(Session[enumSessions.User_Id.ToString()].ToString());
                resultVal = UploadMultipleOrdersBAL.CreateUplaodedMultipleOrders(ARC_Id, Session[enumSessions.User_Name.ToString()].ToString(), Session[enumSessions.User_Email.ToString()].ToString(), UserId, chkDuplicatesAllowed.Checked);
                Response.Redirect("UploadMultipleOrdersCheckout.aspx",false);
            }
            else if(rptBasketItems.Items.Count >0)
            {
                Response.Redirect("UploadMultipleOrdersCheckout.aspx",false);
            }
            else
            {
                string script = "alertify.alert('" + ltrUpload.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
        }
        catch (Exception objException)
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "btnProceed_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Name.ToString()]));
            }
        }
    } 
    DataSet ReadExcel(string fileNameToUpload)
    {
        DataSet ds = new DataSet();

        string fileExt = Path.GetExtension(fileUploadCon.FileName);

        string connString = "";

        if (fileExt == ".xls")
            connString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + Server.MapPath("UploadedOrders") + "\\" + fileNameToUpload + ";Extended Properties=Excel 8.0;";
        else
            connString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("UploadedOrders") + "\\" + fileNameToUpload + ";Extended Properties=Excel 12.0;";
        System.Data.OleDb.OleDbConnection oledbConn = new System.Data.OleDb.OleDbConnection(connString);
        try
        {
            oledbConn.Open();
            System.Data.OleDb.OleDbCommand cmd = new System.Data.OleDb.OleDbCommand("SELECT * FROM [Sheet1$]", oledbConn);
            System.Data.OleDb.OleDbDataAdapter oleda = new System.Data.OleDb.OleDbDataAdapter();
            oleda.SelectCommand = cmd;
            oleda.Fill(ds);
        }
        catch (Exception objException)
        {
            if (objException != null && objException.Message != null)
            {
                string script = "alertify.alert('" + objException.Message + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "ReadExcel", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
        }

        finally
        {
            oledbConn.Close();
        }
        return ds;
    }      
    DataSet ReadCSV(string fileNameToUpload)
    {
        DataSet ds = new DataSet();
        System.Data.OleDb.OleDbConnection excelConnection = new System.Data.OleDb.OleDbConnection(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + Server.MapPath("UploadedOrders") + ";Extended Properties=Text;");
        try
        {
            System.Data.OleDb.OleDbCommand excelCommand = new System.Data.OleDb.OleDbCommand(@"SELECT * FROM " + fileNameToUpload, excelConnection);
            System.Data.OleDb.OleDbDataAdapter excelAdapter = new System.Data.OleDb.OleDbDataAdapter(excelCommand);
            excelConnection.Open();
            excelAdapter.Fill(ds);
            excelConnection.Close();
        }
        catch (Exception objException)
        {
            if (objException != null && objException.Message != null)
            {
                string script = "alertify.alert('" + objException.Message + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
            }

            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "ReadCSV", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));

        }
        finally
        {
            excelConnection.Close();
        }
        return ds;

    }
    private void GetBulkUploadOrderedItems()
    {
        try
        {
            DataSet dsResult = UploadMultipleOrdersBAL.GetBulkUploadOrderItems(Session[enumSessions.User_Name.ToString()].ToString());
            if (dsResult.Tables.Count > 1)
            {
                if (dsResult.Tables[0].Rows.Count > 0)
                {
                    rptBasketItems.DataSource = dsResult.Tables[0];
                    rptBasketItems.DataBind();
                    divBasketItems.Visible = true;
                    btnProceed.Visible = true;

                }
                else
                {
                    divBasketItems.Visible = false;
                }
            }
        }
        catch (Exception objException)
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "GetBulkUploadOrderedItems", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Name.ToString()]));
            }
        }

    }

    private void GetBulkUploadedMultipleOrderProudcts()
    {
        try
        {
            divDuplicatesAllowed.Visible = false;
            DataTable dtResult = UploadMultipleOrdersBAL.GetBulkUploadedMultipleOrderProudcts(Session[enumSessions.User_Name.ToString()].ToString());
            dtResult.DefaultView.RowFilter = "Result = 'Success'";
            if (dtResult.DefaultView.Count > 0)
            {
                divValidProducts.Visible = true;
                rptUploadedProducts.DataSource = dtResult.DefaultView;
                rptUploadedProducts.DataBind();
                trUploadedProducts.Visible = true;
                btnProceed.Visible = true;
            }

            dtResult.DefaultView.RowFilter = "";
            dtResult.DefaultView.RowFilter = "Result <> 'Success'";
            if (dtResult.DefaultView.Count > 0)
            {
                divNotValidProducts.Visible = true;
                rptErrorProducts.DataSource = dtResult.DefaultView;
                rptErrorProducts.DataBind();
                trCouldNotUpload.Visible = true;
            }

            dtResult.DefaultView.RowFilter = "";
            dtResult.DefaultView.RowFilter = "IsAnyDuplicate = true";
            if (dtResult.DefaultView.Count > 0)
            {
                string script = "alertify.alert('" + ltrDuplicate.Text + "');";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                divDuplicatesAllowed.Visible = true;
            }        
        }
        catch (Exception objException)
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                db.USP_SaveErrorDetails(Request.Url.ToString(), "GetBulkUploadedMultipleOrderProudcts", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Name.ToString()]));
            }
        }

    }        
    protected string CleanCSVString(string input)
    {
        string output = "\"" + input.Replace("\"", "\"\"").Replace("\r\n", " ").Replace("\r", " ").Replace("\n", "") + "\"";
        return output;
    }
}