using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;

/// <summary>
/// Summary description for KCConfigs
/// </summary>
public class KCConfiguration
{
    //Admin URL
    public static readonly string KCAdminURL = ConfigurationManager.AppSettings["KCAdminURL"];

    public static readonly string KCAdminClientId = ConfigurationManager.AppSettings["KCAdminClientId"];

    public static readonly string KCUserName = ConfigurationManager.AppSettings["KCUserName"];

    public static readonly string KCPassword = ConfigurationManager.AppSettings["KCPassword"];

    public static readonly string KCCreateUserURL = ConfigurationManager.AppSettings["KCCreateUserURL"];

    public static readonly string KCUserIdSegmentNo = ConfigurationManager.AppSettings["KCUserIdSegmentNo"];


}