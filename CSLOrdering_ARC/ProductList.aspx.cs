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
using System.Configuration;

public partial class ProductList : System.Web.UI.Page
{
    #region Properties
    public int CategoryID { get; set; }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Session[enumSessions.User_Id.ToString()] == null)
                Response.Redirect("Login.aspx");

            if (Request.QueryString["CategoryId"] != null)
            {
                this.CategoryID = Convert.ToInt32(Request.QueryString["CategoryId"]);
                if (CategoryID == 0)
                {
                    Response.Redirect("Categories.aspx"); 
                }
            }

            if (!Page.IsPostBack)
            {
                if (Request.QueryString["CategoryId"] != null)
                {
                    this.CategoryID = Convert.ToInt32(Request.QueryString["CategoryId"]);
                    if (CategoryID == 0)
                    {
                        Response.Redirect("Categories.aspx"); 
                    }

                    LoadProductDetails();

                    Category objCategory = CategoryBAL.GetCategory(CategoryID);
                    Page.Title = objCategory.CategoryName;
                    Page.MetaDescription = objCategory.CategoryDesc;


                }
            }
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

    public String arcDescription = String.Empty;
    private void LoadProductDetails()
    {
        LinqToSqlDataContext db = new LinqToSqlDataContext();
        if (this.CategoryID == 0)
        {
            return;
        }

        // show arc description
        arcDescription = (from a in db.ARCs

                          where a.ARCId == Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString())
                          select a.Description
                              ).SingleOrDefault();

        var products = db.USP_GetProductsByCategoryAndArc(CategoryID, Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString()));
        var uniqueProducts = products.GroupBy(x => x.ProductCode).Select(g => g.First());  // product name should be same- so grouping the product by using product names and selecting only one.
        dlProducts.DataSource = uniqueProducts;

        // dlProducts.DataSource =  db.USP_GetProductsByCategoryAndArc(CategoryID, Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString()));
        dlProducts.DataBind();


        var categoryName = (from cats in db.Categories
                            where cats.CategoryId == CategoryID
                            select cats.CategoryName).Single<string>();
        lblCategoryName.Text = categoryName.ToString();


        db.Dispose();
    }

    protected void ProductsRepeater_ItemBound(object sender, RepeaterItemEventArgs args)
    {

        try
        {
            if (args.Item.ItemType == ListItemType.Item || args.Item.ItemType == ListItemType.AlternatingItem)
            {
                USP_GetProductsByCategoryAndArcResult product = (USP_GetProductsByCategoryAndArcResult)args.Item.DataItem;

                TextBox txtProductQty = args.Item.FindControl("txtProductQty") as TextBox;
                RadioButtonList rdbCompanies = args.Item.FindControl("rdbCompanies") as RadioButtonList;
                HiddenField hdnIsDCC = null;
                hdnIsDCC = (HiddenField)args.Item.FindControl("hdnIsDCC");

                LinqToSqlDataContext db = new LinqToSqlDataContext();

                // using the truncated product code get the full product codes eligible for that ARc and displying radio button accordingly
                if (Convert.ToBoolean(hdnIsDCC.Value) == true)
                {
                  //displayManufacturerRadioButtons(rdbCompanies, product.ProductId);
                   // displayManufacturerRadioButtons(rdbCompanies);
                    displayManufacturerRadioButtons(rdbCompanies, product.ProductCode);
                }

                if (Session[enumSessions.User_Role.ToString()] != null && Session[enumSessions.User_Role.ToString()].ToString() == enumRoles.ARC_Admin.ToString())
                {
                    Label lblProductPrice = args.Item.FindControl("lblProductPrice") as Label;
                    lblProductPrice.Text = String.Empty;  // 0.00 for ARC_admin roles 
                }
            }
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "ProductsRepeater_ItemBound", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            db.Dispose();
        }
    }

    protected void btnProceed_Click(object sender, EventArgs e)
    {
        try
        {
            Page.Validate();

            if (Page.IsValid)
            {

                bool isQtyEntered = false;
                TextBox txtProductQty = null;
                TextBox lblProductType = null;
                TextBox lblProductId = null;
                RadioButtonList rdbCompanies = null;
                Label lblProductCode = null;
                HiddenField hdnIsDCC = null;

                LinqToSqlDataContext db = new LinqToSqlDataContext();
                int OrderItemId = 0;
                int qtyCounter = 0;

                foreach (RepeaterItem item in dlProducts.Items)
                {
                    txtProductQty = (TextBox)item.FindControl("txtProductQty");
                    lblProductType = (TextBox)item.FindControl("lblProductType");
                    lblProductId = (TextBox)item.FindControl("lblProductId");
                    rdbCompanies = (RadioButtonList)item.FindControl("rdbCompanies");
                    lblProductCode = (Label)item.FindControl("lblProductCode");
                    hdnIsDCC = (HiddenField)item.FindControl("hdnIsDCC");

                    //only display radio for ISDCC is true
                    if (Convert.ToBoolean(hdnIsDCC.Value) == true)
                    {
                       // displayManufacturerRadioButtons(rdbCompanies);
                         displayManufacturerRadioButtons(rdbCompanies, lblProductCode.Text);
                        //displayManufacturerRadioButtons(rdbCompanies, Convert.ToInt32(lblProductId.Text));
                    }

                    if (!string.IsNullOrEmpty(txtProductQty.Text) && Convert.ToInt32(txtProductQty.Text) > 0)
                    {
                        if (rdbCompanies.Visible == true && (Convert.ToBoolean(hdnIsDCC.Value) == true ))
                        {
                            if (rdbCompanies.SelectedItem.Text != rdbCompanies.Items[0].Text)//added by priya
                            {
                                string companyId = (from dcc in db.DCCCompanies
                                                    where dcc.company_name == rdbCompanies.SelectedItem.Text
                                                    select dcc.company_id).SingleOrDefault();
                                if (companyId != null)
                                {
                                    string productCode = lblProductCode.Text + companyId;


                                    int productid = (from p in db.Products
                                                     where p.ProductCode == productCode
                                                     select p.ProductId).SingleOrDefault();

                                    //validation to check if the productid exists needed
                                    if (productid != 0)
                                    {
                                        lblProductId.Text = productid.ToString();

                                    }
                                    else
                                    {
                                        string script = "alertify.alert('" + ltrNotaValidProduct + "');";
                                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                        return;
                                    }

                                }
                            }
                            else
                            {
                                string script = "alertify.alert('" + ltrSelectManufacturer.Text + "');";
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                                return;

                            }
                        }

                        int CategoryID = Convert.ToInt32(Request.QueryString["CategoryId"]); 

                        //update product code and product id
                        var orderitem = db.USP_SaveOrderItems(Convert.ToInt32(Session[enumSessions.OrderId.ToString()].ToString()), Convert.ToInt32(lblProductId.Text), Convert.ToInt32(txtProductQty.Text), new Guid(Session[enumSessions.User_Id.ToString()].ToString()), Session[enumSessions.User_Name.ToString()].ToString(), Convert.ToInt32(Request.QueryString["CategoryId"])).SingleOrDefault();
                        if (orderitem != null)
                        {
                            if (orderitem.OrderItemId.HasValue)
                            {
                                int.TryParse(orderitem.OrderItemId.Value.ToString(), out OrderItemId);
                            }
                        }

                        

                        if (OrderItemId != 0)
                        {
                            /* by ajitender
                             * db.USP_DeleteOrderItemDetailsByOrderItemId(OrderItemId);*/

                            List<String> CategorieswithNoChipNo = (from app in db.ApplicationSettings
                                                                   where app.KeyName == "CategorieswithNoChipNo"
                                                                   select app.KeyValue).SingleOrDefault().Split(',').ToList();


                            string GPRSNo = string.Empty; 
                            if (CategorieswithNoChipNo.Contains(CategoryID.ToString()))
                            {
                                GPRSNo = "0000";
                            }

                            for (qtyCounter = 0; qtyCounter < Convert.ToInt32(txtProductQty.Text); qtyCounter++)
                            {

                                db.USP_AddOrderItemDetailsToBasket(OrderItemId, GPRSNo, "", Session[enumSessions.User_Name.ToString()].ToString());
                            }
                        }


                        isQtyEntered = true;
                    }
                }


                db.Dispose();

                if (isQtyEntered)
                {
                    Response.Redirect("Basket.aspx");
                }
                else
                {
                    string script = "alertify.alert('" + ltrEnterQntty.Text + "');";
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", script, true);
                    return;

                }
            }
        }
        catch (System.Threading.ThreadAbortException ex)
        {
            //
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails(Request.Url.ToString(), "btnProceed_Click", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", HttpContext.Current.Request.UserHostAddress, false, Convert.ToString(HttpContext.Current.Session[enumSessions.User_Id.ToString()]));
            db.Dispose();
        }
    }

  // void displayManufacturerRadioButtons(RadioButtonList rdbCompanies, int productID)
   //  void displayManufacturerRadioButtons(RadioButtonList rdbCompanies)
   void displayManufacturerRadioButtons(RadioButtonList rdbCompanies, string productCode)
    {
        LinqToSqlDataContext db = new LinqToSqlDataContext();
       
        var Products = db.USP_GetProductsByCategoryAndArc(CategoryID, Convert.ToInt32(Session[enumSessions.ARC_Id.ToString()].ToString())).ToList();
        var dccProducts = Products.Where(d => d.IsDCC == true).ToList(); //get only DCC Products


        if (dccProducts != null && dccProducts.Count > 0)
        {
          
            rdbCompanies.Visible = true;

            for (int i = 0; i < rdbCompanies.Items.Count; i++)
            {
                rdbCompanies.Items[i].Attributes.Add("style", "visibility:hidden");//change made by Priya
            }

            foreach (var dccProduct in dccProducts)
            {
               
                if (dccProduct.IsDCC == true && dccProduct.ProductCode==productCode)
               // if (dccProduct.IsDCC == true)
                {

                    string dccProductCode = (from p in db.Products
                                             where p.ProductId == dccProduct.ProductId
                                             select p.ProductCode).SingleOrDefault();

                    string DCC_Companyname = (from dcc in db.DCCCompanies
                                              where dcc.Productcode.Contains(dccProductCode)
                                              select dcc.company_name).SingleOrDefault();


                    for (int i = 0; i < rdbCompanies.Items.Count; i++)
                    {
                        if (String.Equals(rdbCompanies.Items[i].Text, rdbCompanies.Items[0].Text))
                        {
                            rdbCompanies.Items[i].Attributes.Add("style", "visibility:visible");
                        }
                        else if (String.Equals(rdbCompanies.Items[i].Text, DCC_Companyname))
                        {
                            rdbCompanies.Items[i].Attributes.Add("style", "visibility:visible");
                        }

                    }
                }

            }
        }
        db.Dispose();
    }
    string GetBasketQtyByProductId(int ProductId)
    {
        LinqToSqlDataContext db = new LinqToSqlDataContext();
        string Qty = "";
        var ordr = db.USP_GetBasketQtyByProductId(Convert.ToInt32(Session[enumSessions.OrderId.ToString()]), ProductId, Convert.ToInt32(Request.QueryString["CategoryId"])).SingleOrDefault();
        if (ordr != null)
            Qty = ordr.ProductQty.ToString();
        db.Dispose();

        return Qty;
    }

    string GetBasketGPRSChipNumbersByProductId(int ProductId)
    {
        LinqToSqlDataContext db = new LinqToSqlDataContext();
        string ChipNos = "";
        var chipnumbers = db.USP_GetBasketGPRSChipNumbersByProductId(Convert.ToInt32(Session[enumSessions.OrderId.ToString()]), ProductId, Convert.ToInt32(Request.QueryString["CategoryId"])).ToList();
        if (chipnumbers != null)
        {
            foreach (var chipno in chipnumbers)
                ChipNos += chipno.GPRSNo + "\n";
        }
        db.Dispose();

        return ChipNos;
    }

    bool ContainsDuplicates(string[] arrayToCheck)
    {
        var duplicates = arrayToCheck
         .GroupBy(s => s)
         .Where(g => g.Count() > 1)
         .Select(g => g.Key);

        return (duplicates.Count() > 0);
    }


    
}