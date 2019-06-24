using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CSLOrderingARCBAL.Common;

namespace CSLOrderingARCBAL.BAL
{
    public class ProductBAL
    {
        public static List<DCCCompany> GetUrlsForCompanies()
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            var lstDCC = (from x in db.DCCCompanies
                          select x);
            return lstDCC.ToList();

        }

        public static string GetProductSEOUrlByGUID(int ProductId)
        {

            //load up the product
            Product product = GetProduct(ProductId);
            if (product == null)
            {
                return "product";
            }
            string url = product.SeoUrl;
            return url;
        }

        public static Product GetProduct(int ProductId)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            var product = (from products in db.Products
                           where
                           (
                            (products.ProductId == ProductId)
                           )
                           select products
                           ).SingleOrDefault();

            db.Dispose();
            return product;
        }

        public static List<Option> GetProductOption(int ProductId)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();

            List<Option> optionList = new List<Option>();
            optionList = (from pom in db.Product_Option_Maps
                          join op in db.Options on pom.OptionId equals op.OptID
                         orderby op.OptionName descending
                          where
                          pom.ProductId == ProductId
                          select op
                         ).ToList();

            db.Dispose();
            return optionList;
        }

        public static Boolean IsAncillary(String productCode)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            var productType = (from pt in db.Products
                               where pt.ProductCode == productCode
                               select pt
                       ).SingleOrDefault();
            if ((productType != null ) && (productType.ProductType == "Ancillary"))
            {
                return true;
            }
            else
            {
                return false;
            }



        }

        public static List<GradeDTO> GradeList()
        {
            List<GradeDTO> lstGrade = new List<GradeDTO>();

            LinqToSqlDataContext db = new LinqToSqlDataContext();

            var Grades = (from dg in db.Device_Grades
                          where
                              dg.Dev_Active == true
                          orderby dg.Dev_Grade ascending
                          select new { Grade = dg.Dev_Grade }).Distinct();


            foreach (var grade in Grades)
            {
                GradeDTO gra = new GradeDTO();
                gra.Grade = grade.Grade;
                lstGrade.Add(gra);
            }

            db.Dispose();


            return lstGrade;



        }

        public static Boolean InsertProductGrade(ProductCode_Grade_Map productGrade)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();

            int count = (from gp in db.ProductCode_Grade_Maps
                         where gp.ProductCode == productGrade.ProductCode
                         select gp
                          ).Count();



            if (count > 0)
            {
                return false;
            }
            else
            {
                ProductCode_Grade_Map objProductGrade = new ProductCode_Grade_Map();

                objProductGrade.ProductCode = productGrade.ProductCode;
                objProductGrade.Grade = productGrade.Grade;
                objProductGrade.CreatedOn = productGrade.CreatedOn;
                objProductGrade.CreatedBy = productGrade.CreatedBy;
                objProductGrade.IsDeleted = productGrade.IsDeleted;
                db.ProductCode_Grade_Maps.InsertOnSubmit(objProductGrade); // insert
                db.SubmitChanges();

                return true;

            }


        }

        // Get product Grade list
        public static List<ProductGradeDTO> GetProductGrade()
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();


            List<ProductGradeDTO> lstProductGrade = new List<ProductGradeDTO>();


            var productGrade = (from pg in db.ProductCode_Grade_Maps

                                where pg.IsDeleted == false
                                orderby pg.ProductCode ascending
                                select new
                                  {
                                      productCode = pg.ProductCode,
                                      ProductGradeID = pg.ProductGradeID,
                                      Grade = pg.Grade
                                  }
                        );


            foreach (var grade in productGrade)
            {
                ProductGradeDTO gra = new ProductGradeDTO();
                gra.ProductGradeID = grade.ProductGradeID;
                gra.ProductCode = grade.productCode;
                gra.Grade = grade.Grade;
                lstProductGrade.Add(gra);
            }

            db.Dispose();



            return lstProductGrade;


        }

        // Get all unmapped product code list 
        public static String[] GetProductCodeList(String code)
        {

            LinqToSqlDataContext db = new LinqToSqlDataContext();

            var list = (from p in db.Products
                        where p.IsDeleted == false &&
                           !(from pg in db.ProductCode_Grade_Maps
                             where pg.IsDeleted == false
                             select pg.ProductCode
                                  ).Contains(p.ProductCode)
                        && p.ProductCode.Contains(code)
                        select p.ProductCode).Take(10);


            List<string> items = new List<string>();
            foreach (var item in list)
            {
                items.Add(item.ToString());
            }

            return items.ToArray();

        }

        //Get Product Grade details by ID
        public static ProductCode_Grade_Map GetProductGradeById(int productGradeID)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();


            ProductCode_Grade_Map productGrade = (from pg in db.ProductCode_Grade_Maps

                                                  where pg.IsDeleted == false
                                                   && pg.ProductGradeID == productGradeID
                                                  select pg

                        ).SingleOrDefault();

            db.Dispose();

            return productGrade;

        }

        //Delete product's Grade
        public static Boolean DeleteProductGrade(int productGradeID)
        {
            LinqToSqlDataContext db = null;

            try
            {
                db = new LinqToSqlDataContext();
                ProductCode_Grade_Map productGrade = db.ProductCode_Grade_Maps.Where(i => i.ProductGradeID == productGradeID).Single();
                db.ProductCode_Grade_Maps.DeleteOnSubmit(productGrade);
                db.SubmitChanges();


                db.Dispose();

                return true;
            }
            catch (Exception objException)
            {
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails("ProductBAL", "DeleteProductGrade", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", null, false, null);
                return false;
            }
        }

        public static Boolean UpdateProductGrade(ProductCode_Grade_Map productGrade)
        {
            LinqToSqlDataContext db = null;

            try
            {
                db = new LinqToSqlDataContext();
                ProductCode_Grade_Map  objGrade = db.ProductCode_Grade_Maps.Single(i => i.ProductGradeID == productGrade.ProductGradeID);
                objGrade.ProductCode = productGrade.ProductCode;
                objGrade.Grade = productGrade.Grade;
                objGrade.CreatedOn = productGrade.CreatedOn;
                objGrade.CreatedBy = productGrade.CreatedBy;
                objGrade.IsDeleted = productGrade.IsDeleted; 
                db.SubmitChanges();


                db.Dispose();

                return true;
            }
            catch (Exception objException)
            {
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails("ProductBAL", "UpdateProductGrade", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", null, false, null);
                return false;
            }
        }

        //ORD-41
        public static string GetPyronixProducts()
        {

            LinqToSqlDataContext db = new LinqToSqlDataContext();

            string strPyronixProducts = string.Empty;
            strPyronixProducts = (from x in db.DCCCompanies
                                  where x.company_name=="Pyronix"
                                  select x.Productcode
                         ).SingleOrDefault();

            db.Dispose();
            return strPyronixProducts;
        }

        public static string GetPyronixProductsWith6DigitChipNo()
        {

            LinqToSqlDataContext db = new LinqToSqlDataContext();

            string strPyronixProducts = string.Empty;
            strPyronixProducts = (from x in db.ApplicationSettings
                                  where x.KeyName == "PyronixProductsMandatory6digitChipNos"
                                  select x.KeyValue
                         ).SingleOrDefault();

            db.Dispose();
            return strPyronixProducts;
        }



        public static Product CreateProduct(Product product) {

            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                db.Products.InsertOnSubmit(product);
                db.SubmitChanges();
            }

            return product;
        }

    }
}
