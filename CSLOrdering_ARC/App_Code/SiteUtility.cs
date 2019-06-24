using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CSLOrderingARCBAL.BAL;
using System.Web.SessionState ;


/// <summary>
/// Summary description for SiteUtility
/// </summary>
public class SiteUtility 
{
    public SiteUtility()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    
    public static string GetSiteRoot()
    {

        string Port = System.Web.HttpContext.Current.Request.ServerVariables["SERVER_PORT"];
        if (Port == null || Port == "80" || Port == "443")
            Port = "";
        else
            Port = ":" + Port;

        string Protocol = System.Web.HttpContext.Current.Request.ServerVariables["SERVER_PORT_SECURE"];
        if (Protocol == null || Protocol == "0")
            Protocol = "http://";
        else
            Protocol = "https://";

        string appPath = System.Web.HttpContext.Current.Request.ApplicationPath;
        if (appPath == "/")
            appPath = "";

        string sOut = Protocol + System.Web.HttpContext.Current.Request.ServerVariables["SERVER_NAME"] + Port + appPath;
        return sOut;
    }


    public static string GetRewriterUrl(string pageTo, int paramValue, string extendedQString)
    {
        string sOut = "";
        try
        {
            if (extendedQString != string.Empty)
                extendedQString = "?" + extendedQString;

        }
        catch
        {

        }
        if (pageTo.ToLower().Contains("products"))
        {

            //string url = CategoryBAL.GetCategorySEOUrlByGUID(paramValue);

            ////for the catalog, the name is passed along as a page
            //if (!string.IsNullOrEmpty(url))
            //{
            //    sOut = GetSiteRoot() + "/" + url + "-c.aspx" + extendedQString;
            //}
            //else
            {
                sOut = GetSiteRoot() + "/products.aspx?CategoryID=" + paramValue;
            }
        }
        else if (pageTo.ToLower().Contains("productdetailview"))
        {

            //string url = ProductBAL.GetProductSEOUrlByGUID(paramValue);

            ////for the product, the sku is passed along
            //if (!string.IsNullOrEmpty(url))
            //{
            //    sOut = GetSiteRoot() + "/" + url + "-p.aspx" + extendedQString;
            //}
            //else
            {
                sOut = GetSiteRoot() + "/productdetailview.aspx?ProductID=" + paramValue;
            }

        }
        return sOut;
    }


    public static string GetUserName()
    {
        string username = "NA";
        try
        {
            if (HttpContext.Current.User.Identity.IsAuthenticated)
            {
                return HttpContext.Current.User.Identity.Name;
            }
            else
            {
                return HttpContext.Current.Profile.UserName;
            }
        }
        catch (Exception exp) { 

        }
        return username;
    }
}