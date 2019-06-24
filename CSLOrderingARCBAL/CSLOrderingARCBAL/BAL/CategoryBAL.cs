using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CSLOrderingARCBAL.Common;

namespace CSLOrderingARCBAL.BAL
{
    public class CategoryBAL
    {

        public static string GetCategorySEOUrlByGUID(int CatId)
        {

            //load up the Category

            Category category = GetCategory(CatId);

            if (category == null)
            {
                return "category";
            }
            return category.SeoUrl;
        }

        public static Category GetCategory(int CatId)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            var category = db.Categories.Single(c => c.CategoryId == CatId);
            db.Dispose();
            return category;
        }

        public static List<CategoryDTO> GetCategories()
        {
            List<CategoryDTO> lstCategories = new List<CategoryDTO>();

            try
            {
                LinqToSqlDataContext db = new LinqToSqlDataContext();
                var cats = from categories in db.Categories
                           where
                           (
                               (categories.IsDeleted == false)
                           )
                           select new { Code = categories.CategoryCode, Title = categories.CategoryName, categories.CategoryId, categories.DefaultImage, categories.CategoryDesc };


                foreach (var category in cats)
                {
                    CategoryDTO cat = new CategoryDTO();
                    cat.CategoryCode = category.Code;
                    cat.CategoryID = category.CategoryId;
                    cat.CategoryName = category.Title;
                    cat.CategoryDefaultImage = category.DefaultImage;
                    cat.CategoryDesc = category.CategoryDesc;
                    lstCategories.Add(cat);
                }

                db.Dispose();
            }
            catch
            {
            
            }

            return lstCategories;
        }

        public static List<CategoryDTO> GetCategoriesByArcId(int ARCId)
        {
            List<CategoryDTO> lstCategories = new List<CategoryDTO>();

            try
            {
                LinqToSqlDataContext db = new LinqToSqlDataContext();
                var cats = from categories in db.Categories
                           join arcCat in db.ARC_Category_Maps on categories.CategoryId equals arcCat.CategoryId
                           where
                           (
                               (categories.IsDeleted == false)
                               &&
                               (arcCat.ARCId == ARCId)
                           )
                           orderby categories.ListOrder, categories.CategoryName
                           select new { Code = categories.CategoryCode, Title = categories.CategoryName, categories.CategoryId, categories.DefaultImage, categories.CategoryDesc
                               };


                foreach (var category in cats)
                {
                    var prods = db.USP_GetProductsByCategoryAndArc(category.CategoryId, ARCId);
                    if (prods != null && prods.Count() > 0)
                    {
                        CategoryDTO cat = new CategoryDTO();
                        cat.CategoryCode = category.Code;
                        cat.CategoryID = category.CategoryId;
                        cat.CategoryName = category.Title;
                        cat.CategoryDefaultImage = category.DefaultImage;
                        cat.CategoryDesc = category.CategoryDesc;
                        lstCategories.Add(cat);
                    }
                }

                db.Dispose();
            }
            catch (Exception objException)
            {
                CSLOrderingARCBAL.LinqToSqlDataContext db;
                db = new CSLOrderingARCBAL.LinqToSqlDataContext();
                db.USP_SaveErrorDetails("Category BAL", "GetCategoriesByArcId", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), String.Empty, String.Empty, false, null);
            }
            return lstCategories;
        }
    }
}
