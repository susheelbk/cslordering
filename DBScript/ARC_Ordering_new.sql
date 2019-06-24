
ALTER TABLE ORDERS
ADD SalesReply varchar(50) null

alter table orderitemdetails
add IsDelivered bit null
--update orderitemdetails set isdelivered = 0
delete from orders
delete from dbo.OrderDependentItems
delete from dbo.OrderItemDetails
delete from dbo.OrderItems 
delete from dbo.Order_FailedDevices
delete from dbo.OrderShippingTrack

    
alter PROCEDURE [dbo].[USP_SaveInstallerAddress]     
(    
    @InstallerId    NVARCHAR(256),    
    @ContactName    NVARCHAR(256),    
    @ContactNumber  NVARCHAR(256),    
    @CountryId      INT,    
    @AddressOne     NVARCHAR(100),    
    @AddressTwo     NVARCHAR(100),    
    @Town           NVARCHAR(100),    
    @County         NVARCHAR(100),    
    @PostCode       NVARCHAR(50),    
    @Country        NVARCHAR(256),    
    @CreatedBy      NVARCHAR(256)    
)    
AS    
BEGIN TRY    
    BEGIN    
        IF @InstallerId = ''    
        BEGIN    
            INSERT INTO ADDRESS    
              (    
                ContactName,    
                AddressOne,    
                AddressTwo,    
                Town,    
                County,    
                PostCode,    
                Mobile,    
                Country,    
                CountryId,    
                CreatedBy,    
                CreatedOn,    
                ModifiedBy,    
                ModifiedOn    
              )    
            VALUES    
              (    
                @ContactName,    
                @AddressOne,    
                @AddressTwo,    
                @Town,    
                @County,    
                @PostCode,    
                @ContactNumber,    
                @Country,    
                @CountryId,    
                @CreatedBy,    
                GETDATE(),    
                @CreatedBy,    
                GETDATE()    
              )      
                
            SELECT CAST(SCOPE_IDENTITY() AS INT) AS AddressId    
        END    
        ELSE    
        BEGIN    
            INSERT INTO ADDRESS    
              (    
                CompanyName,    
                ContactName,    
                AddressOne,    
                AddressTwo,    
                Town,    
                County,    
                PostCode,    
                Email,    
                Fax,    
                Telephone,    
                Mobile,    
                Country,    
                CountryId,    
                CreatedBy,    
                CreatedOn,    
                ModifiedBy,    
                ModifiedOn    
              )(    
                   SELECT CompanyName,    
                          @ContactName,    
                          AddressOne,    
                          AddressTwo,    
                          Town,    
                          County,    
                          PostCode,    
                          Email,    
                          Fax,    
                          Telephone,    
                          Mobile,    
                          Country,    
                          @CountryId,    
                          @CreatedBy,    
                          GETDATE(),    
                          @CreatedBy,    
                          GETDATE()    
                   FROM   InstallerAddress    
                          INNER JOIN Installer    
                               ON  InstallerAddress.AddressID = Installer.AddressID    
                               AND InstallerCompanyID = @InstallerId    
               )    
            SELECT CAST(SCOPE_IDENTITY() AS INT) AS AddressId    
        END    
    END    
END TRY       
BEGIN CATCH    
    EXEC USP_SaveSPErrorDetails     
    RETURN -1    
END CATCH   
  


INSERT INTO ApplicationSetting
select * from ARC_Ordering_test.dbo.ApplicationSetting



ALTER TABLE [ORDERs]
ADD ProcessedBy varchar(256) null,
 ProcessedOn datetime null


ALTER TABLE COUNTRYMASTER
ADD CountryCode VARCHAR(10) NULL


/****** Object:  Table [dbo].[Order_FailedDevices]    Script Date: 04/23/2013 12:39:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Order_FailedDevices](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[OrderItemID] [int] NOT NULL,
	[OrderItemDetailId] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[Dev_ARCCode] [varchar](10) NULL,
	[Dev_Code] [nvarchar](22) NULL,
	[Dev_Connect_Number] [nvarchar](20) NULL,
	[Dev_IPAddress] [nvarchar](20) NULL,
	[Dev_PSTN_Number] [nvarchar](20) NULL,
	[Dev_PrimaryPS] [varchar](10) NULL,
	[Dev_SecondaryPS] [varchar](10) NULL,
	[Dev_Type] [varchar](10) NULL,
	[Dev_CTN_Number] [varchar](30) NULL,
	[Dev_IMSINumber] [varchar](30) NULL,
	[Dev_DataBundle] [varchar](30) NULL,
	[Dev_Sim_Supplier] [varchar](30) NULL,
	[Dev_Hardware] [varchar](30) NULL,
	[Dev_TariffCode] [varchar](30) NULL,
	[Dev_TariffType] [varchar](30) NULL,
	[FailReason] [varchar](200) NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Order_FailedDevices] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Order_FailedDevices] ADD  CONSTRAINT [DF_Order_FailedDevices_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO





/****** Object:  Table [dbo].[DR]    Script Date: 04/29/2013 17:34:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
if not exists (select 1 from sys.tables where name like 'DR')
CREATE TABLE [dbo].[DR](
	[DrId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](50) NOT NULL,
	[ArcId] [nvarchar](50) NOT NULL,
	[date] [nvarchar](50) NOT NULL,
	[Req_Type] [nvarchar](15) NULL,
	[Simno] [nvarchar](50) NULL,
	[Datano] [nvarchar](50) NULL,
	[Chipno] [nvarchar](50) NULL,
	[Installer] [nvarchar](50) NULL,
	[Reason] [nvarchar](max) NOT NULL,
	[Emailed] [bit] NULL,
 CONSTRAINT [PK_DR] PRIMARY KEY CLUSTERED 
(
	[DrId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


/****** Object:  Table [dbo].[UpDowngrade]    Script Date: 04/30/2013 15:26:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
if not exists (select 1 from sys.tables where name like 'UpDowngrade')
CREATE TABLE [dbo].[UpDowngrade](
	[UD_Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](50) NOT NULL,
	[ArcId] [nvarchar](50) NOT NULL,
	[date] [nvarchar](50) NULL,
	[Req_Type] [nvarchar](15) NOT NULL,
	[Simno] [nvarchar](50) NOT NULL,
	[Datano] [nvarchar](50) NOT NULL,
	[Chipno] [nvarchar](50) NOT NULL,
	[Installer] [nvarchar](50) NOT NULL,
	[Reason] [nvarchar](max) NULL,
	[Emailed] [bit] NULL,
	[ItemFrom] [nvarchar](50) NOT NULL,
	[ItemTo] [nvarchar](50) NOT NULL,
	[ARCRef] [nvarchar](50) NULL,
 CONSTRAINT [PK_UpDowngrade] PRIMARY KEY CLUSTERED 
(
	[UD_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO




/****** Object:  StoredProcedure [dbo].[GetOrderDetailsInvoice]    Script Date: 05/03/2013 11:50:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
if exists (select 1 from sys.procedures where name like 'GetOrderDetailsInvoice')
 drop procedure [dbo]. [GetOrderDetailsInvoice]   
go
Create PROCEDURE [dbo].[GetOrderDetailsInvoice](@orderno NVARCHAR(256))      
AS      
 SELECT DISTINCT convert(varchar,convert(datetime,o.OrderDate,3),106) as OrderDate,    
        arc.ARC_Code,      
        arc.Country,      
        o.OrderNo,      
        o.Amount,      
        o.DeliveryCost,      
        o.OrderTotalAmount,     
        o.ProcessedBy,    
        arc.CompanyName,      
        arc.AddressOne,      
        arc.AddressTwo,      
        arc.PostCode,      
        arc.Telephone,      
        arc.Fax,      
        arc.ARC_Email,      
        dlvadr.AddressOne AS dlvaddres,      
        dlvadr.AddressTwo AS dlvaddres2,      
        dlvadr.CompanyName AS dlvcompanyname,      
        dlvadr.PostCode AS dlvpostcode,      
        dlvadr.ContactName AS dlvContactName,  
        dlvadr.Telephone AS dlvTelephone,  
        dlvadr.Town AS dlvTown,   
        insadr.AddressOne AS insaddres,      
        insadr.CompanyName AS inscompantname,      
        insadr.AddressTwo AS insaddres2,      
        insadr.PostCode AS inspostcode,
        insadr.Town AS insTown,      
        dt.DeliveryCompanyName,      
        dt.DeliveryShortDesc,      
        cm.CountryCode  ,    
        o.OrderRefNo   
           
 FROM   OrderItems oi      
        LEFT JOIN Products p      
             ON  oi.ProductId = p.ProductId      
        LEFT JOIN Orders o      
             ON  oi.OrderId = o.OrderId      
        LEFT JOIN DeliveryType dt      
             ON  dt.DeliveryTypeId = o.DeliveryTypeId      
        LEFT JOIN [Address] dlvadr      
             ON  dlvadr.AddressID = o.DeliveryAddressId      
        LEFT JOIN [Address] insadr      
             ON  insadr.AddressID = o.InstallationAddressID      
        LEFT JOIN ARC arc      
             ON  arc.ARCId = o.ARCId      
        LEFT JOIN CountryMaster cm      
             ON  cm.CountryId = dlvadr.CountryId      
 WHERE  (o.OrderNo = @orderno)   
  






CREATE TABLE [dbo].[BOS_Device](
	[Dev_Code] [varchar](20) NOT NULL,
	[Dev_Type] [nvarchar](10) NOT NULL,
	[Dev_Account_Code] [varchar](15) NOT NULL,
	[Dev_Account_Code_GSM] [nvarchar](15) NOT NULL,
	[Dev_Account_Code_PSTN] [nvarchar](15) NOT NULL,
	[Dev_Account_Code_LAN] [nvarchar](15) NOT NULL,
	[Dev_Connect_Number] [nvarchar](20) NOT NULL,
	[Dev_Inst_Code] [nvarchar](50) NOT NULL,
	[Dev_Inst_UnqCode] [int] NOT NULL,
	[Dev_PS_Primary] [nvarchar](15) NOT NULL,
	[Dev_PS_Secondary] [nvarchar](15) NOT NULL,
	[Dev_Active] [bit] NOT NULL,
	[Dev_Arc_Primary] [varchar](15) NOT NULL,
	[Dev_Poll_Color] [nvarchar](15) NOT NULL,
	[Dev_ModifiedBy] [nvarchar](100) NOT NULL,
	[Dev_First_Poll_DateTime] [datetime] NOT NULL,
	[Dev_LastModified] [datetime] NOT NULL,
	[Dev_UpdatedBy] [nvarchar](100) NOT NULL,
	[Dev_LastUpdated] [datetime] NOT NULL,
	[Dev_Delete_Flag] [bit] NOT NULL
 CONSTRAINT [PK_Device] PRIMARY KEY CLUSTERED 
(
	[Dev_Code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 
) ON [PRIMARY]


IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'UserId' AND Object_ID = Object_ID(N'Orders'))    
BEGIN
ALTER TABLE Orders ADD UserId UNIQUEIDENTIFIER null
END
GO


/****** Object:  StoredProcedure [dbo].[USP_CreateOrderForUser]    Script Date: 05/15/2013 12:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[USP_CreateOrderForUser]
(
@ARC_Id int,
@CreatedBy nvarchar(256),
@UserName varchar(256),
@UserEmail varchar(256),
@UserId nvarchar(256)
)
As

BEGIN TRY 
Begin 

 SET NOCOUNT ON;

 Declare @OrderNo int
 Declare @ARC_Code varchar(256)
 Declare @ARC_Email varchar(256)
 Declare @ARC_BillingAccountNo varchar(256)
 Declare @HasUserAcceptedDuplicates bit
 
 If Not Exists (Select OrderId from Orders Where OrderStatusId = 1 And CreatedBy = @CreatedBy And ARCId = @ARC_Id)
  Begin
   Select @ARC_Code = ARC_Code, @ARC_Email = ARC_Email, @ARC_BillingAccountNo = BillingAccountNo from ARC Where ARCId = @ARC_Id   
   Select @OrderNo = IsNull(MAX(IsNull(Cast(OrderNo as Int), 1000)) + 1, 1001) from Orders -- Where ARCId = @ARC_Id
   
   If @OrderNo Is Null
    Set @OrderNo = 1001
   
   Insert into Orders
    (OrderNo, OrderDate, Amount, DeliveryCost, OrderStatusId, DeliveryAddressId,
    BillingAddressId, OrderTotalAmount, DeliveryTypeId, ARCId, ARC_Code, ARC_EmailId, 
    ARC_BillingAccountNo, UserName, UserEmail, 
    CreatedBy, CreatedOn, ModifiedBy, ModifiedOn,UserId)
   Values (@OrderNo, GETDATE(), 0, 0, 1, 0, 
     0, 0, 0, @ARC_Id, @ARC_Code, @ARC_Email, 
     @ARC_BillingAccountNo, @UserName, @UserEmail,
     @CreatedBy, GETDATE(), @CreatedBy, GETDATE(),@UserId)
     
   Select Cast(SCOPE_IDENTITY() as int) as [OrderId], 0.0 as [Amount], 0 as [Quantity], 
     '0' as [InstallerId],
     '' as [SelectedInstaller],
     Cast(@OrderNo as NVarchar(256))as [OrderNo],
     Cast(0 as bit) as [HasUserAcceptedDuplicates]
  End
 Else
  Begin
   Select O.OrderId as [OrderId], IsNull(O.Amount, 0.0) as Amount, IsNull(Sum(IsNull(OI.ProductQty,0)),0) as Quantity, 
    ISNULL(Cast(O.InstallerId as NVarchar(256)), '0') as [InstallerId],
    ISNULL(Installer.CompanyName, '') as [SelectedInstaller],
    Cast(O.OrderNo as NVarchar(256)) as [OrderNo],
    HasUserAcceptedDuplicates
    From Orders O
    Left Join
    OrderItems OI on O.OrderId = OI.OrderId
    Left Join
    Installer on Installer.InstallerCompanyID = O.InstallerId
    Where O.OrderStatusId = 1 And O.CreatedBy = @CreatedBy And O.ARCId = @ARC_Id
    Group by O.OrderId, O.Amount, O.InstallerId, Installer.CompanyName, O.OrderNo, O.HasUserAcceptedDuplicates
   
   -- Select OrderId as [OrderId], 0 as [Amount], 0 as [Quantity] from Orders Where OrderStatusId = 1 And CreatedBy = @CreatedBy And ARCId = @ARC_Id
  End
End

END TRY 
BEGIN CATCH 
EXEC USP_SaveSPErrorDetails
RETURN -1 
END CATCH


