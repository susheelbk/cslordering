using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for enums
/// </summary>

public enum enumRoles
{
    ARC_Admin,
    ARC_Manager,
    ARCWebSite_Admin,
    ARCWebSite_SuperAdmin,
    Admin
}

public enum enumSessions
{
    User_Id,
    User_Name,
    User_Email,
    User_Role,
    OrderId,
    PreviousOrderId,
    OrderNumber,
    ARC_Id,
    IsARC_AllowReturns,
    InstallerCompanyID,
    SelectedInstaller,
    HasUserAcceptedDuplicates,
    UserIdToUpdate,
    ProductId,
    DeliveryOfferId,
    DeliveryTypeId,
    CategoryId,
    Option_Id,
    ListedonCSLConnect,
    IsUserSuperAdmin,
    OrderRef,
    HasUserAcceptedDuplicatePanelID,
    BulkUploadMultipleOrderId,
    DistributerIdToUpdate
}

public enum enumAudit
{
    Manage_User = 1,
    Manage_ARC = 2,
    Manage_Products = 3,
    Manage_Related_Products = 4,
    Manage_Delivery = 5,
    Manage_Category = 6,
    Manage_ARC_Product_Price = 7,
    Manage_Options = 8,
    Manage_Products_Grade = 9,
    Application_Setting = 10,
    Manage_ARC_AccessCode = 11,
    Update_User_Info = 12,
    Manage_Products_Lite = 13,
    Manage_Disconnections_Regrade = 14
}