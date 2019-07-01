using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Sql;

namespace CSLOrderingARCBAL.BAL
{
    public  class DistributorBAL
    {
        #region LoadDistributerList
        public  List<DistributerUIDetail> LoadDistributerList()
        {
            List<DistributerUIDetail> lstDistributer = new List<DistributerUIDetail>();
            CSLOrderingARCBAL.LinqToSqlDataContext db = new LinqToSqlDataContext();
            lstDistributer = (from x in db.DistributerUIDetails
                              select x).ToList();
            return lstDistributer;
        }
        #endregion

        #region GetDistributerForId
        public  DistributerUIDetail GetDistributerForId(int id)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db = new LinqToSqlDataContext();
            DistributerUIDetail distributer = new DistributerUIDetail();
            distributer = (from x in db.DistributerUIDetails
                           where x.ID == id
                           select x).SingleOrDefault();
            return distributer;
        }
        #endregion

        public void SaveDistributor(DistributerUIDetail distributer)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            DistributerUIDetail distributerObject = new DistributerUIDetail();
            if (distributer.ID != -1)
            {
                distributerObject = db.DistributerUIDetails.Where(x => x.ID == distributer.ID).FirstOrDefault();

                if (distributerObject != null)
                {
                    // distributerObject = new DistributerUIDetail();
                    if (!string.IsNullOrEmpty(distributer.Footer1Image))
                        distributerObject.Footer1Image = distributer.Footer1Image;

                    distributerObject.Footer1Text = distributer.Footer1Text;
                    distributerObject.Footer1URL = distributer.Footer1URL;

                    if (!string.IsNullOrEmpty(distributer.Footer2Image))
                        distributerObject.Footer2Image = distributer.Footer2Image;

                    distributerObject.Footer2Text = distributer.Footer2Text;
                    distributerObject.Footer2URL = distributer.Footer2URL;

                    if (!string.IsNullOrEmpty(distributer.Footer3Image))
                        distributerObject.Footer3Image = distributer.Footer3Image;

                    distributerObject.Footer3Text = distributer.Footer3Text;
                    distributerObject.Footer3URL = distributer.Footer3URL;

                    if (!string.IsNullOrEmpty(distributer.Footer4Image))
                        distributerObject.Footer4Image = distributer.Footer4Image;

                    distributerObject.Footer4Text = distributer.Footer4Text;
                    distributerObject.Footer4URL = distributer.Footer4URL;
                    distributerObject.FooterBgColor = distributer.FooterBgColor;
                    distributerObject.FooterTextColor = distributer.FooterTextColor;

                    if (!string.IsNullOrEmpty(distributer.HeaderImage))
                        distributerObject.HeaderImage = distributer.HeaderImage;

                    if (!string.IsNullOrEmpty(distributer.MainImage))
                        distributerObject.MainImage = distributer.MainImage;

                    if (!string.IsNullOrEmpty(distributer.BannerImage))
                        distributerObject.BannerImage = distributer.BannerImage;

                    if (!string.IsNullOrEmpty(distributer.PagetoNavigateafterSignin))
                        distributerObject.PagetoNavigateafterSignin = distributer.PagetoNavigateafterSignin;

                    distributerObject.SignInButtoncolor = distributer.SignInButtoncolor;
                    distributerObject.SignUpHyperlinkcolor = distributer.SignUpHyperlinkcolor;
                    distributerObject.UrlName = distributer.UrlName;
                    distributer.Active = false;
                    db.SubmitChanges();
                }
            }
            else
            {

                distributerObject.Footer1Image = distributer.Footer1Image;
                distributerObject.Footer1Text = distributer.Footer1Text;
                distributerObject.Footer1URL = distributer.Footer1URL;
                distributerObject.Footer2Image = distributer.Footer2Image;
                distributerObject.Footer2Text = distributer.Footer2Text;
                distributerObject.Footer2URL = distributer.Footer2URL;
                distributerObject.Footer3Image = distributer.Footer3Image;
                distributerObject.Footer3Text = distributer.Footer3Text;
                distributerObject.Footer3URL = distributer.Footer3URL;
                distributerObject.Footer4Image = distributer.Footer4Image;
                distributerObject.Footer4Text = distributer.Footer4Text;
                distributerObject.Footer4URL = distributer.Footer4URL;
                distributerObject.FooterBgColor = distributer.FooterBgColor;
                distributerObject.FooterTextColor = distributer.FooterTextColor;
                distributerObject.HeaderImage = distributer.HeaderImage;
                distributerObject.MainImage = distributer.MainImage;
                distributerObject.BannerImage = distributer.BannerImage;
                distributerObject.SignInButtoncolor = distributer.SignInButtoncolor;
                distributerObject.SignUpHyperlinkcolor = distributer.SignUpHyperlinkcolor;
                distributerObject.UrlName = distributer.UrlName;
                distributerObject.PagetoNavigateafterSignin = distributer.PagetoNavigateafterSignin;
                distributer.Active = false;

                db.DistributerUIDetails.InsertOnSubmit(distributerObject);
                db.SubmitChanges();
            }
        }

        public List<SP_GetDistributerUIResult> SearchDistributer(string urlName)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext();            
            return db.SP_GetDistributerUI(urlName).ToList();
        }

        public DistributerUIDetail GetDistributerUIByName(string urlName)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            DistributerUIDetail distributer = new DistributerUIDetail();
            distributer = (from x in db.DistributerUIDetails
                   where x.UrlName == urlName
                   select x).SingleOrDefault();

            return distributer;
        }

        public void UpdateForConfirmation(string urlName)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            DistributerUIDetail distributerObject = new DistributerUIDetail();
            distributerObject = (from x in db.DistributerUIDetails
                                 where x.UrlName == urlName
                                 select x).SingleOrDefault();

            distributerObject.Active = true;
            db.SubmitChanges();

        }

        public void DeleteFooter(string footer,string urlName)
        {
            switch (footer)
            {
                case "Footer1":
                    DeleteFooter1(urlName);
                    break;

                case "Footer2":
                    DeleteFooter2(urlName);
                    break;

                case "Footer3":
                    DeleteFooter3(urlName);
                    break;

                case "Footer4":
                    DeleteFooter4(urlName);
                    break;
            }
        }

        private void DeleteFooter1(string urlName)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            DistributerUIDetail distributer = new DistributerUIDetail();
            distributer = (from x in db.DistributerUIDetails
                           where x.UrlName == urlName
                           select x).SingleOrDefault();
            distributer.Footer1Image = string.Empty;
            distributer.Footer1Text = string.Empty;
            distributer.Footer1URL = string.Empty;
            db.SubmitChanges();
            
        }

        private void DeleteFooter2(string urlName)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            DistributerUIDetail distributer = new DistributerUIDetail();
            distributer = (from x in db.DistributerUIDetails
                           where x.UrlName == urlName
                           select x).SingleOrDefault();
            distributer.Footer2Image = string.Empty;
            distributer.Footer2Text = string.Empty;
            distributer.Footer2URL = string.Empty;
            db.SubmitChanges();

        }

        private void DeleteFooter3(string urlName)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            DistributerUIDetail distributer = new DistributerUIDetail();
            distributer = (from x in db.DistributerUIDetails
                           where x.UrlName == urlName
                           select x).SingleOrDefault();
            distributer.Footer3Image = string.Empty;
            distributer.Footer3Text = string.Empty;
            distributer.Footer3URL = string.Empty;
            db.SubmitChanges();

        }

        private void DeleteFooter4(string urlName)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            DistributerUIDetail distributer = new DistributerUIDetail();
            distributer = (from x in db.DistributerUIDetails
                           where x.UrlName == urlName
                           select x).SingleOrDefault();
            distributer.Footer4Image = string.Empty;
            distributer.Footer4Text = string.Empty;
            distributer.Footer4URL = string.Empty;
            db.SubmitChanges();

        }

       
    }        
    
}


