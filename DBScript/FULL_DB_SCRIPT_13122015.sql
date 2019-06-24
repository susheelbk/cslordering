USE [ARC_Ordering]
GO
/****** Object:  User [Vincenzo.Stramaglia]    Script Date: 12/14/2015 17:06:24 ******/
CREATE USER [Vincenzo.Stramaglia] FOR LOGIN [Vincenzo.Stramaglia] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [siva.s]    Script Date: 12/14/2015 17:06:24 ******/
CREATE USER [siva.s] FOR LOGIN [siva.s] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [Priya.Subramaniam]    Script Date: 12/14/2015 17:06:24 ******/
CREATE USER [Priya.Subramaniam] FOR LOGIN [Priya.Subramaniam] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [Prasad.Venkatakrishnan]    Script Date: 12/14/2015 17:06:24 ******/
CREATE USER [Prasad.Venkatakrishnan] FOR LOGIN [Prasad.Venkatakrishnan] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [paul.hardwick]    Script Date: 12/14/2015 17:06:24 ******/
CREATE USER [paul.hardwick] FOR LOGIN [paul.hardwick] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [paul.hardwich]    Script Date: 12/14/2015 17:06:24 ******/
CREATE USER [paul.hardwich] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [John.Humphires]    Script Date: 12/14/2015 17:06:24 ******/
CREATE USER [John.Humphires] FOR LOGIN [John.Humphires] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [atiq]    Script Date: 12/14/2015 17:06:24 ******/
CREATE USER [atiq] FOR LOGIN [atiq] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [Alex.Papayianni]    Script Date: 12/14/2015 17:06:24 ******/
CREATE USER [Alex.Papayianni] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[ProductCodeMapping]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductCodeMapping](
	[MapId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductCode] [nvarchar](256) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[CategoryName] [nvarchar](256) NULL,
	[SalesType] [nvarchar](256) NOT NULL,
	[PRM_ProgrammerCode] [nvarchar](256) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_ProductCodeMapping] PRIMARY KEY CLUSTERED 
(
	[MapId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique Key to hold product code to Category to Sales Type relation. the relation will be used to auto populate Sales monthly figures' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductCodeMapping', @level2type=N'COLUMN',@level2name=N'MapId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ProductID as defined on ARC Ordering Database Product Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductCodeMapping', @level2type=N'COLUMN',@level2name=N'ProductId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Product Code as defined on ARC Ordering Database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductCodeMapping', @level2type=N'COLUMN',@level2name=N'ProductCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CategoryID as defined on ARC Ordering Database Category table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductCodeMapping', @level2type=N'COLUMN',@level2name=N'CategoryId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Category name as defined on ARC Ordering Database Category table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductCodeMapping', @level2type=N'COLUMN',@level2name=N'CategoryName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type as defined in Intranet Sales database - SalesAccountUnits' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductCodeMapping', @level2type=N'COLUMN',@level2name=N'SalesType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Future use for CSL Programmer from CLS to auto load the relevant programmer for a PRM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductCodeMapping', @level2type=N'COLUMN',@level2name=N'PRM_ProgrammerCode'
GO
/****** Object:  Table [dbo].[ProductCode_Grade_Map]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductCode_Grade_Map](
	[ProductGradeID] [int] IDENTITY(1,1) NOT NULL,
	[ProductCode] [nvarchar](20) NULL,
	[Grade] [nvarchar](20) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedOn] [datetime] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_ProductCode_Grade_Map] PRIMARY KEY CLUSTERED 
(
	[ProductGradeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product_Tag_Map]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_Tag_Map](
	[Product_Tag_MapId] [int] IDENTITY(1,1) NOT NULL,
	[TagsId] [int] NULL,
	[ProductId] [int] NULL,
 CONSTRAINT [PK_Product_Tag_Map] PRIMARY KEY CLUSTERED 
(
	[Product_Tag_MapId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product_RatePlan_Mapping]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_RatePlan_Mapping](
	[ProductID] [int] NULL,
	[Tele2RatePlan] [nvarchar](100) NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_Product_RatePlan_Mapping] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product_Option_Map]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_Option_Map](
	[Prod_Opt_MapId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[OptionId] [int] NOT NULL,
 CONSTRAINT [PK_Product_Option_Map] PRIMARY KEY CLUSTERED 
(
	[Prod_Opt_MapId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product_Installer_Map_04082015]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_Installer_Map_04082015](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[InstallerId] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product_Installer_Map]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_Installer_Map](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[InstallerId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Product_Installer_Map] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product_Dependent_Map]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_Dependent_Map](
	[Product_Dependent_MapId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[DependentProductId] [int] NOT NULL,
 CONSTRAINT [PK_Product_Dependent_Map] PRIMARY KEY CLUSTERED 
(
	[Product_Dependent_MapId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product_Bundle_Map]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_Bundle_Map](
	[Product_Bundle_MapId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NULL,
	[BundleProductId] [int] NULL,
 CONSTRAINT [PK_Product_Bundle_Map] PRIMARY KEY CLUSTERED 
(
	[Product_Bundle_MapId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product_ARC_Map]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_ARC_Map](
	[Product_ARC_MapId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[ARCId] [int] NOT NULL,
	[CSDRestriction] [bit] NOT NULL,
 CONSTRAINT [PK_Product_ARC_Map] PRIMARY KEY CLUSTERED 
(
	[Product_ARC_MapId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PriceBandV2]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PriceBandV2](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BandNameID] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[CurrencyID] [int] NOT NULL,
	[Price] [decimal](6, 2) NOT NULL,
	[AnnualPrice] [decimal](6, 2) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PriceBand]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PriceBand](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BandNameID] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[CurrencyID] [int] NOT NULL,
	[Price] [decimal](6, 2) NOT NULL,
	[AnnualPrice] [decimal](6, 2) NOT NULL,
 CONSTRAINT [PK_PriceBrand] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PortalPages]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PortalPages](
	[PageName] [nvarchar](50) NOT NULL,
	[PageURL] [nvarchar](200) NULL,
	[ImgSrc] [nvarchar](200) NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SortOrder] [int] NULL,
	[Active] [bit] NULL,
	[Roles] [int] NULL,
 CONSTRAINT [PK_PortalPages_ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Portal_Roles]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Portal_Roles](
	[RoleID] [int] NOT NULL,
	[Rolename] [nvarchar](512) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Polling_Server]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Polling_Server](
	[PS_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[PS_Code] [nvarchar](15) NOT NULL,
 CONSTRAINT [PK_Polling_Server] PRIMARY KEY CLUSTERED 
(
	[PS_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PaymentType]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentType](
	[PaymentTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](50) NULL,
 CONSTRAINT [PK_PaymentType] PRIMARY KEY CLUSTERED 
(
	[PaymentTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PaymentTransaction]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentTransaction](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[AuthCode] [nvarchar](50) NULL,
	[Amount] [float] NULL,
	[TransactionTime] [nvarchar](20) NULL,
	[TransactionCode] [nvarchar](20) NULL,
	[CreatedOn] [datetime] NULL,
	[futurePayId] [nvarchar](50) NULL,
 CONSTRAINT [PK_PaymentTransaction] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PaymentNotes]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentNotes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_PaymentNotes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OverideBillingCodes]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OverideBillingCodes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [varchar](2000) NULL,
	[OriginalCode] [int] NULL,
	[OverideCode] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'6 digit unique codes have been overridden to match billing records. when pushed to eclipse it will use the overide code to the original unique code.
mainly used view - vw_BillingOrdersList' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OverideBillingCodes', @level2type=N'COLUMN',@level2name=N'id'
GO
/****** Object:  Table [dbo].[OrderStatusMaster]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderStatusMaster](
	[OrderStatusId] [int] IDENTITY(1,1) NOT NULL,
	[OrderStatus] [nvarchar](100) NOT NULL,
	[ListOrder] [int] NULL,
	[AvailableforOrder] [bit] NULL,
	[AvailableforOrderItems] [bit] NULL,
 CONSTRAINT [PK_OrderStatusMaster] PRIMARY KEY CLUSTERED 
(
	[OrderStatusId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdersHistory]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OrdersHistory](
	[OrderId] [int] NOT NULL,
	[OrderNo] [nvarchar](256) NULL,
	[OrderRefNo] [nvarchar](256) NULL,
	[OrderDate] [datetime] NULL,
	[Amount] [decimal](9, 2) NULL,
	[DeliveryCost] [decimal](6, 2) NULL,
	[OrderStatusId] [int] NULL,
	[DeliveryAddressId] [int] NULL,
	[InstallationAddressID] [int] NULL,
	[BillingAddressId] [int] NULL,
	[OrderTotalAmount] [decimal](9, 2) NULL,
	[DeliveryTypeId] [int] NULL,
	[UserIPAddress] [nvarchar](20) NULL,
	[SpecialInstructions] [text] NULL,
	[ARCId] [int] NULL,
	[ARC_Code] [nvarchar](256) NULL,
	[ARC_EmailId] [nvarchar](256) NULL,
	[ARC_BillingAccountNo] [nvarchar](50) NULL,
	[InstallerId] [uniqueidentifier] NULL,
	[InstallerCode] [nvarchar](100) NULL,
	[InstallerUnqCode] [nvarchar](50) NULL,
	[UserName] [nvarchar](256) NULL,
	[UserEmail] [nvarchar](256) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[ModifiedOn] [datetime] NULL,
	[HasUserAcceptedDuplicates] [bit] NULL,
	[VATRate] [decimal](6, 3) NULL,
	[InstallerContactName] [nvarchar](256) NULL,
	[SalesReply] [varchar](50) NULL,
	[ProcessedBy] [varchar](256) NULL,
	[ProcessedON] [datetime] NULL,
	[UserId] [uniqueidentifier] NULL,
	[DlvNoteVol] [int] NULL,
	[InsertOn] [datetime] NULL,
	[Emailsent] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OrderShippingTrack]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderShippingTrack](
	[OrderShippingTrackID] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NULL,
	[TrackingNo] [nvarchar](max) NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_OrderShippingTrack] PRIMARY KEY CLUSTERED 
(
	[OrderShippingTrackID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CountryMaster]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CountryMaster](
	[CountryId] [int] IDENTITY(1,1) NOT NULL,
	[CountryName] [varchar](256) NOT NULL,
	[CountryCode] [varchar](10) NULL,
 CONSTRAINT [PK_CountryMaster] PRIMARY KEY CLUSTERED 
(
	[CountryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CompanyPriceMap_05102015]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyPriceMap_05102015](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyID] [uniqueidentifier] NOT NULL,
	[PriceBandId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyPriceMap_050820151639]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyPriceMap_050820151639](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyID] [uniqueidentifier] NOT NULL,
	[PriceBandId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyPriceMap_05082015]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyPriceMap_05082015](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyID] [uniqueidentifier] NOT NULL,
	[PriceBandId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyPriceMap]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyPriceMap](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyID] [uniqueidentifier] NOT NULL,
	[PriceBandId] [int] NOT NULL,
 CONSTRAINT [PK_CompanyPriceMap] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CategoryRelatedProducts]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CategoryRelatedProducts](
	[CategoryRelatedProductId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NULL,
	[CategoryId] [int] NULL,
 CONSTRAINT [PK_CategoryRelatedProducts] PRIMARY KEY CLUSTERED 
(
	[CategoryRelatedProductId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CategoryId]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CategoryId](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Category_Product_Map]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category_Product_Map](
	[Cat_Prod_MapId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
 CONSTRAINT [PK_Category_Product_Map] PRIMARY KEY CLUSTERED 
(
	[Cat_Prod_MapId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryCode] [nvarchar](256) NOT NULL,
	[CategoryName] [nvarchar](256) NOT NULL,
	[CategoryDesc] [text] NULL,
	[DefaultImage] [nvarchar](512) NULL,
	[LargeImage] [nvarchar](512) NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[ModifiedOn] [datetime] NULL,
	[ListOrder] [int] NULL,
	[SeoUrl] [nvarchar](256) NULL,
	[IsGPRSChipEmpty] [bit] NULL,
	[ArcBasedPRMPath] [nvarchar](2000) NULL,
	[GenericPRMPath] [nvarchar](2000) NULL,
	[PendingFilePath] [nvarchar](2000) NULL,
	[SalesType] [nvarchar](256) NULL,
	[ArcBasedPRMPathO2] [nvarchar](2000) NULL,
	[ArcBasedPRMPathWorldSim] [nvarchar](2000) NULL,
	[ArcBasedPRMPathGDSP] [nvarchar](2000) NULL,
	[ArcBasedPRMPathTele2] [nvarchar](2000) NULL,
	[GenericPRMPathO2] [nvarchar](2000) NULL,
	[GenericPRMPathWorldSim] [nvarchar](2000) NULL,
	[GenericPRMPathGDSP] [nvarchar](2000) NULL,
	[GenericPRMPathTele2] [nvarchar](2000) NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BOS_Device]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
	[Dev_Delete_Flag] [bit] NOT NULL,
 CONSTRAINT [PK_Device] PRIMARY KEY CLUSTERED 
(
	[Dev_Code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BillingOrdersList_sent]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BillingOrdersList_sent](
	[Account_Number] [nvarchar](256) NULL,
	[Order_Number] [nvarchar](50) NULL,
	[CSL_Unique_Order_Number] [nvarchar](256) NOT NULL,
	[Package_Code] [nvarchar](20) NOT NULL,
	[Delivery_Product_Code] [nvarchar](256) NULL,
	[Delivery_Charge] [decimal](6, 2) NOT NULL,
	[Order_Date] [datetime] NOT NULL,
	[Del_Note_Number] [varchar](256) NULL,
	[Charge_Qty] [int] NOT NULL,
	[Phone_Number] [varchar](3) NOT NULL,
	[IMSI] [varchar](30) NOT NULL,
	[Data_Number] [nvarchar](256) NOT NULL,
	[SIM_Number] [nvarchar](4000) NOT NULL,
	[IP_Address] [varchar](30) NOT NULL,
	[Username_Description] [nvarchar](50) NOT NULL,
	[Installer_Code] [nvarchar](50) NULL,
	[Old_Installer_Code] [nvarchar](100) NOT NULL,
	[Data_Provider] [varchar](50) NOT NULL,
	[Supplier_Network] [varchar](50) NOT NULL,
	[Original_StartDate] [datetime] NULL,
	[Number_Start_Date] [datetime] NULL,
	[Product_Start_Dates] [datetime] NULL,
	[Order_Special_Inst] [varchar](50) NULL,
	[Ancillary] [int] NOT NULL,
	[Rep_code] [varchar](50) NULL,
	[rep_unit] [bit] NULL,
	[foc] [bit] NULL,
	[con_stk] [bit] NULL,
	[OrderItemDetailId] [int] NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[Swap_Out] [bit] NULL,
	[OrderID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20150724-172206] ON [dbo].[BillingOrdersList_sent] 
(
	[Order_Date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BillingCycle]    Script Date: 12/14/2015 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BillingCycle](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](256) NULL,
 CONSTRAINT [PK_BillingCycle] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[base64_encode]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[base64_encode] 
(@data VARBINARY(max)) 
RETURNS VARCHAR(max)

WITH SCHEMABINDING, RETURNS NULL ON NULL INPUT

BEGIN

RETURN (

SELECT [text()] = @data 
FOR XML PATH('')

) 
END
GO
/****** Object:  Table [dbo].[BandNameMaster]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BandNameMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BandName] [nvarchar](50) NULL,
	[IsDefault] [bit] NOT NULL,
 CONSTRAINT [PK_BandNameMaster] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditM2M]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditM2M](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[LoginDate] [datetime] NULL,
	[LogoutDate] [datetime] NULL,
 CONSTRAINT [PK_AuditM2M] PRIMARY KEY CLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditChanges]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditChanges](
	[ChangeID] [int] NOT NULL,
	[Change] [nvarchar](255) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Audit]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Audit](
	[AuditID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](255) NOT NULL,
	[ChangeID] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[Notes] [nvarchar](2000) NULL,
	[IPAddress] [nvarchar](50) NULL,
	[WindowsUser] [nvarchar](510) NULL,
 CONSTRAINT [PK_Audit] PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ArcTypes]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArcTypes](
	[ARCTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Types] [nvarchar](50) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_ArcTypes] PRIMARY KEY CLUSTERED 
(
	[ARCTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ARC_User_Map]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARC_User_Map](
	[ARC_User_MapId] [int] IDENTITY(1,1) NOT NULL,
	[ARCId] [int] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ARC_User_Map] PRIMARY KEY CLUSTERED 
(
	[ARC_User_MapId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ARC_Reports]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ARC_Reports](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ARC_Code] [varchar](20) NULL,
	[ARC_Email] [varchar](200) NULL,
	[Arc_Description] [varchar](500) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__ARC_Repo__3214EC27542C7691] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ARC_Product_Price_Map]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARC_Product_Price_Map](
	[ARC_Product_Price_MapId] [int] IDENTITY(1,1) NOT NULL,
	[ARCId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Price] [decimal](6, 2) NOT NULL,
	[ExpiryDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedBy] [nvarchar](255) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [nvarchar](250) NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_ARC_Product_Price_Map] PRIMARY KEY CLUSTERED 
(
	[ARC_Product_Price_MapId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ARC_Category_Map]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARC_Category_Map](
	[ARC_Cat_MapId] [int] IDENTITY(1,1) NOT NULL,
	[ARCId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
 CONSTRAINT [PK_ARC_Category_Map] PRIMARY KEY CLUSTERED 
(
	[ARC_Cat_MapId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fedex_Import]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fedex_Import](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrderNo] [nvarchar](50) NULL,
	[TrackingNO] [nvarchar](500) NULL,
	[UpdatedOnOrder] [bit] NOT NULL,
 CONSTRAINT [PK_Fedex_Import] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ErrorlogArchive]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorlogArchive](
	[ExceptionID] [int] IDENTITY(1,1) NOT NULL,
	[PageName] [nvarchar](200) NULL,
	[MethodName] [nvarchar](200) NULL,
	[ErrorMessage] [nvarchar](200) NULL,
	[InnerMessage] [text] NULL,
	[StackTrace] [text] NULL,
	[Notes] [nvarchar](500) NULL,
	[UserIPAddress] [nvarchar](200) NULL,
	[Status] [bit] NULL,
	[ClosedBy] [nvarchar](200) NULL,
	[ClosedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ErrorLog]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorLog](
	[ExceptionID] [int] IDENTITY(1,1) NOT NULL,
	[PageName] [nvarchar](200) NULL,
	[MethodName] [nvarchar](200) NULL,
	[ErrorMessage] [nvarchar](200) NULL,
	[InnerMessage] [text] NULL,
	[StackTrace] [text] NULL,
	[Notes] [nvarchar](500) NULL,
	[UserIPAddress] [nvarchar](200) NULL,
	[Status] [bit] NULL,
	[ClosedBy] [nvarchar](200) NULL,
	[ClosedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED 
(
	[ExceptionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Eclipse_UniqueCode_Mapping]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Eclipse_UniqueCode_Mapping](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CSL_UniqueCode] [int] NOT NULL,
	[Eclipse_UniqueCode] [int] NOT NULL,
	[Productcode] [nvarchar](40) NOT NULL,
 CONSTRAINT [PK_Eclipse_UniqueCode_Mapping] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DR]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  Table [dbo].[DeviceSMS]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeviceSMS](
	[DeviceSMSId] [int] IDENTITY(1,1) NOT NULL,
	[DateAdded] [datetime] NULL,
	[MessageTypeId] [int] NULL,
	[ProcessedTime] [datetime] NULL,
	[Text] [nvarchar](500) NULL,
	[DeviceID] [int] NULL,
	[Isprocessed] [bit] NULL,
 CONSTRAINT [PK_DeviceSMS] PRIMARY KEY CLUSTERED 
(
	[DeviceSMSId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Device_Grade]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Device_Grade](
	[Dev_GradeId] [int] IDENTITY(1,1) NOT NULL,
	[Product_Code] [nvarchar](256) NULL,
	[Dev_PS_Code] [nvarchar](10) NULL,
	[Dev_Grade] [nvarchar](10) NULL,
	[Dev_Active] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Device_API]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Device_API](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Dev_Code] [varchar](20) NOT NULL,
	[Dev_IMSINumber] [varchar](30) NULL,
	[Dev_IP_Address] [varchar](30) NULL,
	[blnFetched] [bit] NULL,
	[CreatedBy] [varchar](100) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [varchar](100) NULL,
	[ModifiedOn] [datetime] NULL,
	[Data_Number] [varchar](20) NOT NULL,
	[Dev_MSISDN] [varchar](30) NULL,
	[Dev_usage] [decimal](30, 3) NULL,
	[Dev_Usage_StartDate] [datetime] NULL,
	[Dev_Usage_EndDate] [datetime] NULL,
	[Dev_UsageLimitReached] [bit] NULL,
	[dev_voiceusage] [int] NULL,
	[dev_smsusage] [int] NULL,
	[Poll_Status] [bit] NULL,
	[RAG_Status] [varchar](1) NULL,
	[InSession] [bit] NULL,
	[Date_activated] [datetime] NULL,
	[Sim_Status] [varchar](50) NULL,
	[SIMColor] [varchar](50) NULL,
	[CustomerID] [bigint] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE CLUSTERED INDEX [ClusteredIndex-20150123-125251] ON [dbo].[Device_API] 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DevCode] ON [dbo].[Device_API] 
(
	[Dev_Code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_NC_IPaddress] ON [dbo].[Device_API] 
(
	[Dev_IP_Address] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeliveryType]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DeliveryType](
	[DeliveryTypeId] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryCompanyName] [nvarchar](256) NOT NULL,
	[DeliveryCompanyDesc] [text] NULL,
	[DeliveryShortDesc] [nvarchar](500) NULL,
	[DeliveryPrice] [decimal](6, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[DeliveryCode] [nvarchar](256) NULL,
	[CreatedBy] [nvarchar](256) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](256) NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[DisplayonDeliveryNote] [varchar](60) NULL,
	[IsTimedDelivery] [bit] NULL,
	[TimedDeliveryOption] [varchar](5) NULL,
	[CountryCode] [varchar](10) NULL,
	[EachProductPrice] [bit] NULL,
 CONSTRAINT [PK_DeliveryType] PRIMARY KEY CLUSTERED 
(
	[DeliveryTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DeliveryPrices]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryPrices](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryPrice] [decimal](6, 2) NOT NULL,
	[DeliveryTypeId] [int] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[IsFreeDelivery] [bit] NOT NULL,
 CONSTRAINT [PK_DeliveryPrices_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_DeliveryPrices] UNIQUE NONCLUSTERED 
(
	[CurrencyId] ASC,
	[DeliveryTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeliveryOffers_06082015]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryOffers_06082015](
	[DeliveryOfferId] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryTypeId] [int] NOT NULL,
	[OrderValue] [decimal](6, 2) NOT NULL,
	[ARCId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[MinQty] [int] NULL,
	[MaxQty] [int] NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[InstallerCompanyID] [uniqueidentifier] NULL,
	[ISActivation] [bit] NULL,
	[CategoryID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeliveryOffers_05082015]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryOffers_05082015](
	[DeliveryOfferId] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryTypeId] [int] NOT NULL,
	[OrderValue] [decimal](6, 2) NOT NULL,
	[ARCId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[MinQty] [int] NULL,
	[MaxQty] [int] NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[InstallerCompanyID] [uniqueidentifier] NULL,
	[ISActivation] [bit] NULL,
	[CategoryID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeliveryOffers]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryOffers](
	[DeliveryOfferId] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryTypeId] [int] NOT NULL,
	[OrderValue] [decimal](6, 2) NOT NULL,
	[ARCId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[MinQty] [int] NULL,
	[MaxQty] [int] NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[InstallerCompanyID] [uniqueidentifier] NULL,
	[ISActivation] [bit] NULL,
	[CategoryID] [int] NULL,
 CONSTRAINT [PK_DeliveryOffers] PRIMARY KEY CLUSTERED 
(
	[DeliveryOfferId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Delivery_Product_Sibblings_06_08_2015]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Delivery_Product_Sibblings_06_08_2015](
	[Delivery_Prod_SibblingId] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryOfferId] [int] NOT NULL,
	[DeliveryOfferProductId] [int] NOT NULL,
	[Sibbling_ProductId] [int] NOT NULL,
	[CreatedBy] [nvarchar](256) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](256) NOT NULL,
	[ModifiedOn] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Delivery_Product_Sibblings_04082015]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Delivery_Product_Sibblings_04082015](
	[Delivery_Prod_SibblingId] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryOfferId] [int] NOT NULL,
	[DeliveryOfferProductId] [int] NOT NULL,
	[Sibbling_ProductId] [int] NOT NULL,
	[CreatedBy] [nvarchar](256) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](256) NOT NULL,
	[ModifiedOn] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Delivery_Product_Sibblings]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Delivery_Product_Sibblings](
	[Delivery_Prod_SibblingId] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryOfferId] [int] NOT NULL,
	[DeliveryOfferProductId] [int] NOT NULL,
	[Sibbling_ProductId] [int] NOT NULL,
	[CreatedBy] [nvarchar](256) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](256) NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_Delivery_Product_Sibblings] PRIMARY KEY CLUSTERED 
(
	[Delivery_Prod_SibblingId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Currency]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Currency](
	[CurrencyID] [int] IDENTITY(1,1) NOT NULL,
	[CurrencyCode] [nvarchar](50) NULL,
	[Country] [nvarchar](50) NULL,
	[CurrencySymbol] [nvarchar](5) NULL,
	[HTMLCurrencySymbol] [nvarchar](20) NULL,
 CONSTRAINT [PK_Currency] PRIMARY KEY CLUSTERED 
(
	[CurrencyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CSLOrderingEmail]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CSLOrderingEmail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrderNo] [varchar](256) NULL,
	[Subject] [varchar](2000) NULL,
	[Body] [varchar](max) NULL,
	[MailFrom] [varchar](100) NULL,
	[MailTo] [varchar](2000) NULL,
	[MailCC] [varchar](2000) NULL,
	[MailBCC] [varchar](2000) NULL,
	[MsgType] [varchar](50) NULL,
	[SentMail] [int] NULL,
	[mailitem_id] [int] NULL,
	[InsertedOn] [datetime] NULL,
	[NumberOfAttempts] [int] NULL,
	[AttemptedTime] [varchar](2000) NULL,
	[Sync_Status] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OrderDIConfirmed]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDIConfirmed](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[DateCSVGenerated] [datetime] NULL,
	[Qty] [int] NULL,
	[DateGenerated] [datetime] NULL,
 CONSTRAINT [PK_OrderDIConfirmed] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDependentItems]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDependentItems](
	[OrderDependentId] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[OrderItemId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductQty] [int] NOT NULL,
	[Price] [decimal](6, 2) NOT NULL,
	[QntyDelivered] [int] NULL,
 CONSTRAINT [PK_orderDependentItems] PRIMARY KEY CLUSTERED 
(
	[OrderDependentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_NC_OrderItemID] ON [dbo].[OrderDependentItems] 
(
	[OrderItemId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_NC_Price] ON [dbo].[OrderDependentItems] 
(
	[Price] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_NC_ProductId] ON [dbo].[OrderDependentItems] 
(
	[ProductId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDeliveryNotes]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDeliveryNotes](
	[OrderDeliveryNotesId] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NULL,
	[DispatchedDate] [datetime] NULL,
	[OrderItemId] [int] NULL,
	[DeliveryNoteNo] [nvarchar](250) NULL,
 CONSTRAINT [PK_OrderDeliveryNotes] PRIMARY KEY CLUSTERED 
(
	[OrderDeliveryNotesId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order_SIM_Map]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Order_SIM_Map](
	[RefId] [int] IDENTITY(1,1) NOT NULL,
	[Old_Orderno] [nvarchar](256) NULL,
	[Old_dev_Account_code] [varchar](20) NULL,
	[Old_Orderdate] [date] NULL,
	[New_Orderno] [nvarchar](256) NULL,
	[New_orderdate] [datetime] NULL,
	[New_dev_Account_code] [varchar](20) NULL,
	[OrderReplacementDate] [datetime] NULL,
 CONSTRAINT [PK_Order_SIM_Map] PRIMARY KEY CLUSTERED 
(
	[RefId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Order_FailedDevices]    Script Date: 12/14/2015 17:06:31 ******/
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
/****** Object:  Table [dbo].[Options]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Options](
	[OptID] [int] IDENTITY(1,1) NOT NULL,
	[OptionName] [nvarchar](50) NOT NULL,
	[OptionDesc] [nvarchar](250) NULL,
 CONSTRAINT [PK_Options] PRIMARY KEY CLUSTERED 
(
	[OptID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OldLoginUsers]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OldLoginUsers](
	[Id] [float] NULL,
	[UserName] [nvarchar](255) NULL,
	[Password] [nvarchar](255) NULL,
	[PermissionId] [float] NULL,
	[ArcId] [float] NULL,
	[Name] [nvarchar](255) NULL,
	[Email] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Network_Operators]    Script Date: 12/14/2015 17:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Network_Operators](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NetworkName] [varchar](50) NOT NULL,
	[ICCIDPrefix] [varchar](10) NULL,
 CONSTRAINT [PK_Network_Operators] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[msp_CrossTab]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  

-- Author:  SRI  

-- Description: Returns result set in matrix   

-- =============================================  

CREATE PROCEDURE [dbo].[msp_CrossTab] -- Add the parameters for the stored procedure here  

@select Nvarchar(MAX),  

@sumfunc Nvarchar(500),   

@pivot Nvarchar(500),   

@table Nvarchar(500) ,  

@WHERE Nvarchar(500) = null  

AS  

BEGIN  

 -- SET NOCOUNT ON added to prevent extra result sets from  

 -- interfering with SELECT statements.  

 SET NOCOUNT ON;  

  

   DECLARE @sql Nvarchar(MAX), @delim Nvarchar(5)  

   SET ANSI_WARNINGS OFF  

 BEGIN TRY   

  

  EXEC ('SELECT ' + @pivot + ' AS [pivot] INTO ##pivot FROM ' + @table + ' WHERE 1=2')  

  EXEC ('INSERT INTO ##pivot SELECT DISTINCT ' + @pivot + ' FROM ' + @table + ' WHERE '   

  + @pivot + ' Is Not Null' + @WHERE )  

  

  SELECT @sql='',  @sumfunc=stuff(@sumfunc, len(@sumfunc), 1, ' END)' )  

  

  

  SELECT @delim=CASE Sign( CharIndex('char', data_type)+CharIndex('date', data_type) )   

  WHEN 0 THEN '' ELSE '''' END   

  --SELECT *   

  FROM tempdb.information_schema.columns   

  WHERE table_name='##pivot' AND column_name='pivot'  

  

  Print @delim  

  

  SELECT @sql=@sql + '''' + convert(Nvarchar(500), replace([pivot],'''','''''')) + ''' = '   

  + stuff(@sumfunc,charindex( '(', @sumfunc )+1, 0, ' CASE ' +  @pivot + ' WHEN '   

  + @delim + convert(Nvarchar(500), replace([pivot],'''','''''')) + @delim + ' THEN ' ) + ', '   

  FROM ##pivot  

  

  

  

  DROP TABLE ##pivot  

  

  SELECT @sql=left(@sql, len(@sql)-1)  

  SELECT @select=stuff(@select, charindex(' FROM ', @select)+1, 0, ', ' + @sql + ' ')  

  

  PRINT 'SQL -' + @sql  

  Print 'SELECT - ' +  @select  

  

  EXEC (@select)  

  

  SET ANSI_WARNINGS ON  

 END TRY   

 BEGIN CATCH   

  SELECT null  

 END CATCH   

   

 END
GO
/****** Object:  Table [dbo].[MSA_Products]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MSA_Products](
	[Id] [int] NULL,
	[Code] [nvarchar](50) NULL,
	[Title] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[PriceA] [decimal](18, 2) NULL,
	[PriceB] [decimal](18, 2) NULL,
	[PriceC] [decimal](18, 2) NULL,
	[PriceD] [decimal](18, 2) NULL,
	[PriceE] [decimal](18, 2) NULL,
	[PriceF] [decimal](18, 2) NULL,
	[PriceSpecial] [decimal](18, 2) NULL,
	[Telephone] [bit] NOT NULL,
	[Order] [int] NULL,
	[pageorder] [int] NULL,
	[Deleted] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MessageType]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MessageType](
	[MessageTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](20) NULL,
 CONSTRAINT [PK_MessageType] PRIMARY KEY CLUSTERED 
(
	[MessageTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[M2MProductDefaultVoiceSMS]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[M2MProductDefaultVoiceSMS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[DefaultSMSID] [int] NOT NULL,
	[DefaultVoiceID] [int] NOT NULL,
 CONSTRAINT [PK_M2MProductDefaultVoiceSMS] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[M2MCompany]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[M2MCompany](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[M2MCompanyID] [uniqueidentifier] NULL,
	[CompanyName] [nvarchar](256) NULL,
	[AddressId] [int] NULL,
	[UniqueCode] [nvarchar](256) NULL,
	[IsCreditAllowed] [bit] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedOn] [datetime] NULL,
	[CurrencyID] [int] NULL,
 CONSTRAINT [PK_M2MCompany] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LogisticsMessageRule]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LogisticsMessageRule](
	[Ruleid] [int] IDENTITY(1,1) NOT NULL,
	[SP_Name] [varchar](2000) NULL,
PRIMARY KEY CLUSTERED 
(
	[Ruleid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LogisticsEmail]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LogisticsEmail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrderNo] [varchar](256) NULL,
	[Subject] [varchar](2000) NULL,
	[Body] [varchar](max) NULL,
	[MailFrom] [varchar](100) NULL,
	[MailTo] [varchar](2000) NULL,
	[MailCC] [varchar](2000) NULL,
	[MailBCC] [varchar](2000) NULL,
	[MsgType] [varchar](50) NULL,
	[SentMail] [int] NULL,
	[mailitem_id] [int] NULL,
	[InsertedOn] [datetime] NULL,
	[NumberOfAttempts] [int] NULL,
	[AttemptedTime] [varchar](2000) NULL,
	[Sync_Status] [char](1) NULL,
 CONSTRAINT [PK_LogisticsEmail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InstallerUserAddress]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InstallerUserAddress](
	[InstallerUserAddressID] [uniqueidentifier] NOT NULL,
	[FirstName] [nvarchar](256) NOT NULL,
	[LastName] [nvarchar](256) NULL,
	[AddressOne] [nvarchar](100) NOT NULL,
	[AddressTwo] [nvarchar](100) NULL,
	[Town] [nvarchar](100) NULL,
	[County] [nvarchar](100) NULL,
	[PostCode] [nvarchar](50) NULL,
	[Email] [nvarchar](256) NULL,
	[Fax] [nvarchar](50) NULL,
	[Telephone] [nvarchar](50) NULL,
	[Mobile] [nvarchar](50) NULL,
	[Country] [nvarchar](256) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_InstallerUserAddress] PRIMARY KEY CLUSTERED 
(
	[InstallerUserAddressID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InstallerAddress]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InstallerAddress](
	[AddressID] [uniqueidentifier] NOT NULL,
	[ContactName] [nvarchar](256) NOT NULL,
	[AddressOne] [nvarchar](100) NOT NULL,
	[AddressTwo] [nvarchar](100) NULL,
	[Town] [nvarchar](100) NULL,
	[County] [nvarchar](100) NULL,
	[PostCode] [nvarchar](50) NULL,
	[Email] [nvarchar](256) NULL,
	[Fax] [nvarchar](50) NULL,
	[Telephone] [nvarchar](50) NULL,
	[Mobile] [nvarchar](50) NULL,
	[Country] [nvarchar](256) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[ModifiedOn] [datetime] NULL,
	[CountryId] [int] NULL,
 CONSTRAINT [PK_InstallerAddress] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Installer_User_Map_08112015]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Installer_User_Map_08112015](
	[Installer_user_id] [int] IDENTITY(1,1) NOT NULL,
	[InstallerCompanyID] [uniqueidentifier] NOT NULL,
	[UserID] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](250) NULL,
	[InstallerUserAddressID] [uniqueidentifier] NULL,
	[HomeCountryId] [int] NULL,
	[HomeCurrencyId] [int] NULL,
	[CurrencyId] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Installer_User_Map]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Installer_User_Map](
	[Installer_user_id] [int] IDENTITY(1,1) NOT NULL,
	[InstallerCompanyID] [uniqueidentifier] NOT NULL,
	[UserID] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](250) NULL,
	[InstallerUserAddressID] [uniqueidentifier] NULL,
	[HomeCountryId] [int] NULL,
	[HomeCurrencyId] [int] NULL,
	[CurrencyId] [int] NULL,
 CONSTRAINT [PK_Installer_User_Map] PRIMARY KEY CLUSTERED 
(
	[Installer_user_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[installer_05102015]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[installer_05102015](
	[InstallerCompanyID] [uniqueidentifier] NOT NULL,
	[CompanyName] [nvarchar](256) NOT NULL,
	[Accreditation] [nvarchar](50) NOT NULL,
	[Type] [nvarchar](256) NULL,
	[Roll_Sales] [nvarchar](50) NULL,
	[AddressID] [uniqueidentifier] NOT NULL,
	[HeadOfficeID] [uniqueidentifier] NULL,
	[InstallerCode] [nvarchar](100) NULL,
	[WebSiteUrl] [nvarchar](256) NULL,
	[RegistrationNumber] [nvarchar](256) NULL,
	[VATNumber] [nvarchar](256) NULL,
	[UniqueCode] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[IsEIRE] [bit] NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[ModifiedOn] [datetime] NULL,
	[SalesRep] [varchar](10) NULL,
	[IsExdirectory] [bit] NOT NULL,
	[IsCreditAllowed] [bit] NULL,
	[CurrencyID] [int] NULL,
	[IsVoiceSMSVisible] [bit] NOT NULL,
	[VATPercentage] [decimal](6, 2) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Installer]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Installer](
	[InstallerCompanyID] [uniqueidentifier] NOT NULL,
	[CompanyName] [nvarchar](256) NOT NULL,
	[Accreditation] [nvarchar](50) NOT NULL,
	[Type] [nvarchar](256) NULL,
	[Roll_Sales] [nvarchar](50) NULL,
	[AddressID] [uniqueidentifier] NOT NULL,
	[HeadOfficeID] [uniqueidentifier] NULL,
	[InstallerCode] [nvarchar](100) NULL,
	[WebSiteUrl] [nvarchar](256) NULL,
	[RegistrationNumber] [nvarchar](256) NULL,
	[VATNumber] [nvarchar](256) NULL,
	[UniqueCode] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[IsEIRE] [bit] NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[ModifiedOn] [datetime] NULL,
	[SalesRep] [varchar](10) NULL,
	[IsExdirectory] [bit] NOT NULL,
	[IsCreditAllowed] [bit] NULL,
	[CurrencyID] [int] NULL,
	[IsVoiceSMSVisible] [bit] NOT NULL,
	[VATPercentage] [decimal](6, 2) NULL,
 CONSTRAINT [PK_Installer_1] PRIMARY KEY CLUSTERED 
(
	[InstallerCompanyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IDX_NC_UniqueCode] ON [dbo].[Installer] 
(
	[UniqueCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GradeMap2Master]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GradeMap2Master](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[MasterGrade] [varchar](20) NULL,
	[BOSGrade] [varchar](20) NULL,
	[createdby] [varchar](100) NULL,
	[Createdon] [datetime] NULL,
	[modifiedby] [varchar](100) NULL,
	[modifiedon] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ARC_ACCESS]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARC_ACCESS](
	[Id] [int] NOT NULL,
	[CompanyName] [nvarchar](max) NULL,
	[PostCode] [nvarchar](10) NULL,
	[PriceBand] [nvarchar](10) NULL,
	[ProductPermission] [nvarchar](255) NULL,
	[PrimaryContact] [nvarchar](255) NULL,
	[Telephone] [nvarchar](50) NULL,
	[Fax] [nvarchar](50) NULL,
	[AddressOne] [nvarchar](50) NULL,
	[AddressTwo] [nvarchar](50) NULL,
	[Town] [nvarchar](50) NULL,
	[County] [nvarchar](50) NULL,
	[Country] [nvarchar](50) NULL,
	[AccountNumber] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[AnnualBilling] [bit] NOT NULL,
	[AllowReturns] [bit] NOT NULL,
	[postingoption] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Address]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Address](
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [nvarchar](256) NULL,
	[ContactName] [nvarchar](256) NOT NULL,
	[AddressOne] [nvarchar](100) NOT NULL,
	[AddressTwo] [nvarchar](100) NULL,
	[Town] [nvarchar](100) NULL,
	[County] [nvarchar](100) NULL,
	[PostCode] [nvarchar](50) NULL,
	[Email] [nvarchar](256) NULL,
	[Fax] [nvarchar](50) NULL,
	[Telephone] [nvarchar](50) NULL,
	[Mobile] [nvarchar](50) NULL,
	[Country] [nvarchar](256) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[ModifiedOn] [datetime] NULL,
	[CountryId] [int] NULL,
	[FirstName] [nvarchar](512) NULL,
	[Lastname] [nvarchar](512) NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ActiveConsignmentOldUnits]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActiveConsignmentOldUnits](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ICCID] [nvarchar](20) NULL,
 CONSTRAINT [PK_ActiveConsignmentOldUnits] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccessCode]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccessCode](
	[ARCID] [float] NULL,
	[InstallerCode] [nvarchar](255) NULL,
	[AccessCode] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sectorAlarmsIssueOID]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[sectorAlarmsIssueOID](
	[OrderItemDetailId] [int] IDENTITY(1,1) NOT NULL,
	[OrderItemId] [int] NOT NULL,
	[GPRSNo] [nvarchar](50) NULL,
	[PSTNNo] [nvarchar](50) NULL,
	[GSMNo] [nvarchar](50) NULL,
	[LANNo] [nvarchar](50) NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](256) NOT NULL,
	[GPRSNoPostCode] [nvarchar](50) NULL,
	[ICCID] [nvarchar](256) NULL,
	[DataNo] [nvarchar](256) NULL,
	[PrServerDetails] [nvarchar](200) NULL,
	[IsBosInserted] [bit] NULL,
	[IsPendingFileCreated] [bit] NULL,
	[FileName] [varchar](200) NULL,
	[OptionId] [int] NULL,
	[Quantity] [int] NULL,
	[IsDlvNoteGenerated] [bit] NULL,
	[ItemDlvNoteNo] [varchar](250) NULL,
	[Isprocessed] [bit] NULL,
	[ProcessAttempts] [int] NULL,
	[LastProcessedTime] [datetime] NULL,
	[PendingFileErrorMessage] [varchar](max) NULL,
	[BOSErrorMessage] [varchar](max) NULL,
	[isBillingInserted] [bit] NOT NULL,
	[ReplacementProduct] [bit] NULL,
	[SiteName] [nvarchar](256) NULL,
	[IsFOC] [bit] NULL,
	[IsReplacement] [bit] NULL,
	[RatePlanUpdatedonAPI] [bit] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RelatedProducts]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RelatedProducts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[RelatedProductId] [int] NOT NULL,
 CONSTRAINT [PK_RelatedProducts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PushApi_SimStateChange]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PushApi_SimStateChange](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ICCID] [varchar](25) NULL,
	[previousstate] [varchar](256) NULL,
	[currentState] [varchar](256) NULL,
	[dateChanged] [datetime] NULL,
	[createdon] [datetime] NULL,
	[createdby] [varchar](256) NULL,
 CONSTRAINT [PK_PushApi_SimStateChange] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[products_06082015]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[products_06082015](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[ProductCode] [nvarchar](20) NOT NULL,
	[ProductName] [nvarchar](512) NOT NULL,
	[ProductDesc] [nvarchar](max) NULL,
	[Price] [decimal](6, 2) NOT NULL,
	[ListOrder] [int] NOT NULL,
	[DefaultImage] [nvarchar](256) NULL,
	[LargeImage] [nvarchar](256) NULL,
	[IsDeleted] [bit] NOT NULL,
	[ProductType] [nvarchar](10) NOT NULL,
	[IsDependentProduct] [bit] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](256) NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[SeoUrl] [nvarchar](512) NULL,
	[IsCSD] [bit] NULL,
	[Message] [nvarchar](256) NULL,
	[CSL_Grade] [nvarchar](50) NULL,
	[IsSiteName] [bit] NULL,
	[IsReplenishment] [bit] NULL,
	[CSLDescription] [text] NULL,
	[AnnualPrice] [decimal](10, 2) NULL,
	[ListedonCSLConnect] [bit] NOT NULL,
	[CSLConnectVoice] [bit] NOT NULL,
	[CSLConnectSMS] [bit] NOT NULL,
	[Allowance] [float] NULL,
	[IsHardwareType] [bit] NOT NULL,
	[IsOEMProduct] [bit] NOT NULL,
	[IsVoiceSMSVisible] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usersims230920151225]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usersims230920151225](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [uniqueidentifier] NULL,
	[DeviceID] [int] NULL,
	[Status] [nvarchar](256) NULL,
	[BillingCycleID] [int] NULL,
	[OverUsageAlert] [bit] NULL,
	[ProductId] [int] NULL,
	[OrderID] [int] NULL,
	[ACTIVE] [bit] NULL,
	[SIMReference] [nvarchar](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usersims211020151420]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usersims211020151420](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [uniqueidentifier] NULL,
	[DeviceID] [int] NULL,
	[Status] [nvarchar](256) NULL,
	[BillingCycleID] [int] NULL,
	[OverUsageAlert] [bit] NULL,
	[ProductId] [int] NULL,
	[OrderID] [int] NULL,
	[ACTIVE] [bit] NULL,
	[SIMReference] [nvarchar](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usersims101120151500]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usersims101120151500](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [uniqueidentifier] NULL,
	[DeviceID] [int] NULL,
	[Status] [nvarchar](256) NULL,
	[BillingCycleID] [int] NULL,
	[OverUsageAlert] [bit] NULL,
	[ProductId] [int] NULL,
	[OrderID] [int] NULL,
	[ACTIVE] [bit] NULL,
	[SIMReference] [nvarchar](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserSIMS]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserSIMS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [uniqueidentifier] NULL,
	[DeviceID] [int] NULL,
	[Status] [nvarchar](256) NULL,
	[BillingCycleID] [int] NULL,
	[OverUsageAlert] [bit] NULL,
	[ProductId] [int] NULL,
	[OrderID] [int] NULL,
	[ACTIVE] [bit] NULL,
	[SIMReference] [nvarchar](500) NULL,
 CONSTRAINT [PK_UserSIMS] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_NC_BillingCycleID] ON [dbo].[UserSIMS] 
(
	[BillingCycleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_NC_DeviceID] ON [dbo].[UserSIMS] 
(
	[DeviceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_NC_ProductID] ON [dbo].[UserSIMS] 
(
	[ProductId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_NC_UserID] ON [dbo].[UserSIMS] 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRequestMaster]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRequestMaster](
	[UserRequestId] [int] IDENTITY(1,1) NOT NULL,
	[Status] [nvarchar](200) NULL,
 CONSTRAINT [PK_UserRequestMaster] PRIMARY KEY CLUSTERED 
(
	[UserRequestId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRequest_Status_Map]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRequest_Status_Map](
	[UserRequestStatusMapId] [int] IDENTITY(1,1) NOT NULL,
	[UserRequestId] [int] NULL,
	[UserSIMSId] [int] NULL,
	[IsProcessed] [bit] NULL,
	[IsCancelled] [bit] NULL,
	[EffectiveDate] [date] NULL,
	[UpgradePlanId] [int] NULL,
	[ProcessedTime] [datetime] NULL,
	[Comments] [nvarchar](256) NULL,
	[AddressId] [int] NULL,
 CONSTRAINT [PK_UserRequest_Status_Map] PRIMARY KEY CLUSTERED 
(
	[UserRequestStatusMapId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserMapping]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserMapping](
	[UserMappingId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NULL,
	[UserCategoryId] [uniqueidentifier] NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[AddressId] [int] NULL,
	[HomeCountryId] [int] NULL,
	[CurrencyId] [int] NULL,
	[UniqueCode] [int] NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[IsCreditAllowed] [bit] NULL,
 CONSTRAINT [PK_UserMapping] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_NC_UniqueCode] ON [dbo].[UserMapping] 
(
	[UniqueCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20150108-140558] ON [dbo].[UserMapping] 
(
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UserID] ON [dbo].[UserMapping] 
(
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserCategory]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserCategory](
	[UserCategoryId] [uniqueidentifier] NOT NULL,
	[Category] [nvarchar](200) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_UserCategory] PRIMARY KEY CLUSTERED 
(
	[UserCategoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User_Address_Map]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_Address_Map](
	[User_Address_MapId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NULL,
	[AddressId] [int] NULL,
 CONSTRAINT [PK_User_Address_Map] PRIMARY KEY CLUSTERED 
(
	[User_Address_MapId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User_Access]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_Access](
	[Id] [int] NOT NULL,
	[UserName] [nvarchar](50) NULL,
	[Password] [nvarchar](50) NULL,
	[PermissionId] [int] NULL,
	[ArcId] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Upgrade_Product_Map]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Upgrade_Product_Map](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[UpgradeProductID] [int] NULL,
 CONSTRAINT [PK_Upgrade_Product_Map] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UpDowngrade]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  UserDefinedFunction [dbo].[udf_FormatBytes]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[udf_FormatBytes]
(
   @InputNumber   DECIMAL(38,7),
   @InputUOM      VARCHAR(5) = 'Bytes'
)
RETURNS VARCHAR(20)
WITH SCHEMABINDING
AS
BEGIN
   -- Declare the return variable here
   DECLARE @Output VARCHAR(48)
   DECLARE @Prefix MONEY
   DECLARE @Suffix VARCHAR(6)
   DECLARE @Multiplier DECIMAL(38,2)
   DECLARE @Bytes  DECIMAL(38,2)

   SELECT @Multiplier =
      CASE @InputUOM
         WHEN 'Bytes'         THEN 1
         WHEN 'Byte'          THEN 1
         WHEN 'B'             THEN 1
         WHEN 'Kilobytes'     THEN 1024
         WHEN 'Kilobyte'      THEN 1024
         WHEN 'KB'            THEN 1024
         WHEN 'Megabytes'     THEN 1048576
         WHEN 'Megabyte'      THEN 1048576
         WHEN 'MB'            THEN 1048576
         WHEN 'Gigabytes'     THEN 1073741824
         WHEN 'Gigabyte'      THEN 1073741824
         WHEN 'GB'            THEN 1073741824
         WHEN 'Terabytes'     THEN 1099511627776
         WHEN 'Terabyte'      THEN 1099511627776
         WHEN 'TB'            THEN 1099511627776
         WHEN 'Petabytes'     THEN 1125899906842624
         WHEN 'Petabyte'      THEN 1125899906842624
         WHEN 'PB'            THEN 1125899906842624
         WHEN 'Exabytes'      THEN 1152921504606846976
         WHEN 'Exabyte'       THEN 1152921504606846976
         WHEN 'EB'            THEN 1152921504606846976
         WHEN 'Zettabytes'    THEN 1180591620717411303424
         WHEN 'Zettabyte'     THEN 1180591620717411303424
         WHEN 'ZB'            THEN 1180591620717411303424
         WHEN 'Yottabytes'    THEN 1208925819614629174706176
         WHEN 'Yottabyte'     THEN 1208925819614629174706176
         WHEN 'YB'            THEN 1208925819614629174706176
         WHEN 'Brontobytes'   THEN 1237940039285380274899124224
         WHEN 'Brontobyte'    THEN 1237940039285380274899124224
         WHEN 'BB'            THEN 1237940039285380274899124224
         WHEN 'Geopbytes'     THEN 1267650600228229401496703205376
         WHEN 'Geopbyte'      THEN 1267650600228229401496703205376
      END

   SELECT @Bytes = @InputNumber*@Multiplier

   SELECT @Prefix =
      CASE
         WHEN ABS(@Bytes) < 1024 THEN @Bytes --bytes
         WHEN ABS(@Bytes) < 1048576 THEN (@Bytes/1024) --kb
         WHEN ABS(@Bytes) < 1073741824 THEN (@Bytes/1048576) --mb  
         WHEN ABS(@Bytes) < 1099511627776 THEN (@Bytes/1073741824) --gb
         WHEN ABS(@Bytes) < 1125899906842624 THEN (@Bytes/1099511627776) --tb
         WHEN ABS(@Bytes) < 1152921504606846976 THEN (@Bytes/1125899906842624) --pb
         WHEN ABS(@Bytes) < 1180591620717411303424 THEN (@Bytes/1152921504606846976) --eb
         WHEN ABS(@Bytes) < 1208925819614629174706176 THEN (@Bytes/1180591620717411303424) --zb
         WHEN ABS(@Bytes) < 1237940039285380274899124224 THEN (@Bytes/1208925819614629174706176) --yb
         WHEN ABS(@Bytes) < 1267650600228229401496703205376 THEN (@Bytes/1237940039285380274899124224) --bb
         ELSE (@Bytes/1267650600228229401496703205376) --geopbytes
      END,
          @Suffix =
     CASE
         WHEN ABS(@Bytes) < 1024 THEN ' Bytes'
         WHEN ABS(@Bytes) < 1048576 THEN ' KB'
         WHEN ABS(@Bytes) < 1073741824 THEN ' MB'
         WHEN ABS(@Bytes) < 1099511627776 THEN ' GB'
         WHEN ABS(@Bytes) < 1125899906842624 THEN ' TB'
         WHEN ABS(@Bytes) < 1152921504606846976 THEN ' PB'
         WHEN ABS(@Bytes) < 1180591620717411303424 THEN ' EB'         
         WHEN ABS(@Bytes) < 1208925819614629174706176 THEN ' ZB'         
         WHEN ABS(@Bytes) < 1237940039285380274899124224 THEN ' YB'         
         WHEN ABS(@Bytes) < 1267650600228229401496703205376 THEN ' BB'         
         ELSE ' Geopbytes'
      END

   -- Return the result of the function
   SELECT @Output = CAST(@Prefix AS VARCHAR(39)) + @Suffix
   RETURN @Output

END
GO
/****** Object:  UserDefinedFunction [dbo].[TRIM]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sri
-- Create date: 15 July 2013
-- Description:	Removes all spaces in a string 
-- =============================================
CREATE FUNCTION [dbo].[TRIM]
(
    @InputStr varchar(8000)
)
RETURNS varchar(8000)
AS
BEGIN
declare @ResultStr varchar(8000)
set @ResultStr = @InputStr
while charindex(' ', @ResultStr) > 0
    set @ResultStr = replace(@InputStr, ' ', '')

return @ResultStr
END
GO
/****** Object:  Table [dbo].[TempM2MOrders]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TempM2MOrders](
	[OrderId] [int] NOT NULL,
	[OrderNo] [nvarchar](256) NOT NULL,
	[OrderRefNo] [nvarchar](256) NULL,
	[OrderDate] [datetime] NOT NULL,
	[Amount] [decimal](9, 2) NOT NULL,
	[DeliveryCost] [decimal](6, 2) NOT NULL,
	[OrderStatusId] [int] NOT NULL,
	[DeliveryAddressId] [int] NOT NULL,
	[InstallationAddressID] [int] NULL,
	[BillingAddressId] [int] NOT NULL,
	[OrderTotalAmount] [decimal](9, 2) NOT NULL,
	[DeliveryTypeId] [int] NOT NULL,
	[UserIPAddress] [nvarchar](20) NULL,
	[SpecialInstructions] [text] NULL,
	[ARCId] [int] NOT NULL,
	[ARC_Code] [nvarchar](256) NOT NULL,
	[ARC_EmailId] [nvarchar](256) NOT NULL,
	[ARC_BillingAccountNo] [nvarchar](50) NULL,
	[InstallerId] [uniqueidentifier] NULL,
	[InstallerCode] [nvarchar](100) NULL,
	[InstallerUnqCode] [nvarchar](50) NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[UserEmail] [nvarchar](256) NOT NULL,
	[CreatedBy] [nvarchar](256) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](256) NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[HasUserAcceptedDuplicates] [bit] NOT NULL,
	[VATRate] [decimal](6, 3) NOT NULL,
	[InstallerContactName] [varchar](256) NULL,
	[ProcessedBy] [varchar](256) NULL,
	[ProcessedOn] [datetime] NULL,
	[UserId] [uniqueidentifier] NULL,
	[SalesReply] [varchar](50) NULL,
	[DlvNoteVol] [int] NULL,
	[MergedOrderID] [int] NULL,
	[DeliveryNoteNo] [varchar](256) NULL,
	[IsShipped] [bit] NULL,
	[EmailSent] [bit] NULL,
	[OverriddenDeliveryCost] [decimal](6, 2) NULL,
	[PaymentType] [int] NULL,
	[BillingCycleID] [int] NULL,
	[InitialPayment] [decimal](9, 2) NULL,
	[MonthlyPayment] [decimal](9, 2) NULL,
	[OrderType] [int] NULL,
	[M2MReplacementOrderNo] [nvarchar](512) NULL,
	[ID] [int] NULL,
	[Description] [nvarchar](256) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Tele2_Communication]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tele2_Communication](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NacId] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[IsVoiceIncluded] [bit] NOT NULL,
 CONSTRAINT [PK_Tele2_Communication] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tags]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tags](
	[TagsId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NULL,
	[ParentId] [int] NULL,
	[Code] [nvarchar](200) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_Tag] PRIMARY KEY CLUSTERED 
(
	[TagsId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sync_BOS2Ordering]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sync_BOS2Ordering](
	[Sync_Code] [int] IDENTITY(1,1) NOT NULL,
	[Sync_Tablename] [varchar](100) NOT NULL,
	[Sync_Operation] [char](1) NOT NULL,
	[Sync_Server] [varchar](15) NOT NULL,
	[Sync_Status] [char](1) NOT NULL,
	[Sync_Err_Description] [varchar](100) NOT NULL,
	[Sync_DateTime] [datetime] NOT NULL,
	[RecordsEffected] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Sync_Code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SwapOut]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SwapOut](
	[SwapOutId] [int] IDENTITY(1,1) NOT NULL,
	[OrderItemId] [int] NULL,
	[BundleProductId] [int] NULL,
	[SwapWithProductId] [int] NULL,
	[ProductQty] [int] NULL,
 CONSTRAINT [PK_SwapOut] PRIMARY KEY CLUSTERED 
(
	[SwapOutId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 12/14/2015 17:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Split](@String varchar(8000), @Delimiter char(1))       
returns @temptable TABLE (items varchar(8000))       
as       
begin       
declare @idx int       
declare @slice varchar(8000)       
  
select @idx = 1       
    if len(@String)<1 or @String is null  return       
  
while @idx!= 0       
begin       
    set @idx = charindex(@Delimiter,@String)       
    if @idx!=0       
        set @slice = left(@String,@idx - 1)       
    else       
        set @slice = @String       
  
    if(len(@slice)>0)  
        insert into @temptable(Items) values(@slice)       
  
    set @String = right(@String,len(@String) - @idx)       
    if len(@String) = 0 break       
end   
return       
end
GO
/****** Object:  View [dbo].[getNewID]    Script Date: 12/14/2015 17:06:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[getNewID] as select newid() as new_id
GO
/****** Object:  StoredProcedure [dbo].[GetOrderDepProductsinvoice]    Script Date: 12/14/2015 17:06:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetOrderDepProductsinvoice] (@orderno NVARCHAR(256))
AS
	--select p.ProductCode,
 --      p.ProductName,
	--   CONVERT(VARCHAR, odi.QntyDelivered) AS ProductQty from Orders o
 --      INNER JOIN OrderItems oi on oi.OrderId=o.OrderId
 --      INNER JOIN OrderItemDetails oid on oid.OrderItemId=oi.OrderItemId
 --      INNER JOIN OrderDependentItems odi on odi.OrderItemId=oid.OrderItemId
 --      INNER JOIN Products p on p.ProductId=odi.ProductId 
 --       WHERE  (o.OrderNo = @orderno
	--       --AND oid.IsDelivered = 1
	--      -- AND oid.IsDlvnotegenerated=0
	--       AND odi.QntyDelivered != 0)
	--       GROUP BY
	--       p.ProductCode,
	--       p.ProductName,
	--       odi.QntyDelivered
GO
/****** Object:  StoredProcedure [dbo].[SP_ShrinkDatabaseLogFile]    Script Date: 12/14/2015 17:06:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*CreatedBy: Shyam Gaddam    
CreatedOn: 25th July 2012    
Purpose: To Shrink the database , set the recovery mode to Simple and revert back to full    
*/    
    
CREATE Procedure [dbo].[SP_ShrinkDatabaseLogFile](@ShrinkMB varchar(20)=null)    
as begin    
if(@ShrinkMB is null)    
begin    
set @ShrinkMB = '100'    
end    
    
Declare @Databasename varchar(200)    
Declare @logFileName varchar(200)    
declare @max int    
Declare @sql varchar(MAX)    
Declare @min int = 1    
    
Create table #Temp (Sno int identity(1,1),DatabaseName varchar(200),LogFileName varchar(200))    
    
insert into #Temp     
select databaseName,File_LogicalName    
from    
(    
SELECT    
DB_NAME(mf.database_id) AS databaseName,    
name as File_LogicalName,    
case    
when type_desc = 'LOG' then 'Log File'    
when type_desc = 'ROWS' then 'Data File'    
Else type_desc    
end as File_type_desc    
,mf.physical_name    
,size_on_disk_bytes/ 1024 as size_on_disk_KB    
,size_on_disk_bytes/ 1024 / 1024 as size_on_disk_MB    
,size_on_disk_bytes/ 1024 / 1024 / 1024 as size_on_disk_GB    
FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS divfs    
JOIN sys.master_files AS mf ON mf.database_id = divfs.database_id    
AND mf.file_id = divfs.file_id where type_desc = 'LOG'    
and DB_NAME(mf.database_id) not in ('master','tempdb','model','msdb')    
) a    
    
select  @max= MAX(SNo) from #Temp    
    
while(@min<=@max)    
begin    
select @Databasename=DatabaseName ,@logFileName = LogFileName from #Temp where Sno = @min    
set @sql = ' alter database ' +@Databasename+ ' set recovery simple'    
exec (@sql)    
set @sql= 'use '+@Databasename+ ' ;  '    
set @sql = @sql + ' dbcc shrinkfile('+ @logFileName +', '+@ShrinkMB+')'    
exec (@sql)    
set @sql = ' alter database ' +@Databasename+ ' set recovery FULL'    
exec (@sql)    
set @min = @min+1    
end    
    
drop table #Temp    
    
end
GO
/****** Object:  Table [dbo].[vw_OrderDataWithDetails24082015]    Script Date: 12/14/2015 17:06:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[vw_OrderDataWithDetails24082015](
	[OrderId] [int] NOT NULL,
	[OrderNo] [nvarchar](256) NOT NULL,
	[OrderRefNo] [nvarchar](256) NULL,
	[OrderDate] [datetime] NOT NULL,
	[Amount] [decimal](9, 2) NOT NULL,
	[DeliveryCost] [decimal](6, 2) NOT NULL,
	[OrderStatusId] [int] NOT NULL,
	[DeliveryAddressId] [int] NOT NULL,
	[InstallationAddressID] [int] NULL,
	[BillingAddressId] [int] NOT NULL,
	[OrderTotalAmount] [decimal](9, 2) NOT NULL,
	[DeliveryTypeId] [int] NOT NULL,
	[UserIPAddress] [nvarchar](20) NULL,
	[SpecialInstructions] [text] NULL,
	[ARCId] [int] NOT NULL,
	[ARC_Code] [nvarchar](256) NOT NULL,
	[ARC_EmailId] [nvarchar](256) NOT NULL,
	[ARC_BillingAccountNo] [nvarchar](50) NULL,
	[InstallerId] [uniqueidentifier] NULL,
	[InstallerCode] [nvarchar](100) NULL,
	[InstallerUnqCode] [nvarchar](50) NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[UserEmail] [nvarchar](256) NOT NULL,
	[OrderCreatedBy] [nvarchar](256) NOT NULL,
	[OrderCreatedOn] [datetime] NOT NULL,
	[OrderModifiedBy] [nvarchar](256) NOT NULL,
	[OrderModifiedOn] [datetime] NOT NULL,
	[HasUserAcceptedDuplicates] [bit] NOT NULL,
	[VATRate] [decimal](6, 3) NOT NULL,
	[InstallerContactName] [varchar](256) NULL,
	[OrderProcessedBy] [varchar](256) NULL,
	[OrderProcessedOn] [datetime] NULL,
	[UserId] [uniqueidentifier] NULL,
	[SalesReply] [varchar](50) NULL,
	[DlvNoteVol] [int] NULL,
	[MergedOrderID] [int] NULL,
	[DeliveryNoteNo] [varchar](256) NULL,
	[IsShipped] [bit] NULL,
	[EmailSent] [bit] NULL,
	[OverriddenDeliveryCost] [decimal](6, 2) NULL,
	[PaymentType] [int] NULL,
	[BillingCycleID] [int] NULL,
	[InitialPayment] [decimal](9, 2) NULL,
	[MonthlyPayment] [decimal](9, 2) NULL,
	[OrderType] [int] NULL,
	[M2MReplacementOrderNo] [nvarchar](512) NULL,
	[OrderItemId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductQty] [int] NOT NULL,
	[Price] [decimal](9, 2) NOT NULL,
	[OrderItemStatusId] [int] NOT NULL,
	[OrderItemCreatedOn] [datetime] NOT NULL,
	[OrderItemCreatedBy] [nvarchar](256) NOT NULL,
	[OrderItemModifiedOn] [datetime] NOT NULL,
	[OrderItemModifiedBy] [nvarchar](256) NOT NULL,
	[CategoryId] [int] NULL,
	[IsCSD] [bit] NULL,
	[OrderItemProcessedBy] [varchar](256) NULL,
	[OrderItemProcessedOn] [datetime] NULL,
	[QntyDelivered] [int] NULL,
	[IsReplenishment] [bit] NULL,
	[IsNewItem] [bit] NULL,
	[CSLConnectCodePrefix] [nvarchar](80) NULL,
	[OrderItemDetailId] [int] NOT NULL,
	[GPRSNo] [nvarchar](50) NULL,
	[PSTNNo] [nvarchar](50) NULL,
	[GSMNo] [nvarchar](50) NULL,
	[LANNo] [nvarchar](50) NULL,
	[OrderItemDetailModifiedOn] [datetime] NOT NULL,
	[OrderItemDetailModifiedBy] [nvarchar](256) NOT NULL,
	[GPRSNoPostCode] [nvarchar](50) NULL,
	[ICCID] [nvarchar](256) NULL,
	[DataNo] [nvarchar](256) NULL,
	[PrServerDetails] [nvarchar](200) NULL,
	[IsBosInserted] [bit] NULL,
	[IsPendingFileCreated] [bit] NULL,
	[FileName] [varchar](200) NULL,
	[OptionId] [int] NULL,
	[Quantity] [int] NULL,
	[IsDlvNoteGenerated] [bit] NULL,
	[ItemDlvNoteNo] [varchar](250) NULL,
	[Isprocessed] [bit] NULL,
	[ProcessAttempts] [int] NULL,
	[LastProcessedTime] [datetime] NULL,
	[PendingFileErrorMessage] [varchar](max) NULL,
	[BOSErrorMessage] [varchar](max) NULL,
	[isBillingInserted] [bit] NOT NULL,
	[ReplacementProduct] [bit] NULL,
	[SiteName] [nvarchar](256) NULL,
	[IsFOC] [bit] NULL,
	[IsReplacement] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_m2mUserLogin]    Script Date: 12/14/2015 17:06:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/

Create view [dbo].[vw_m2mUserLogin]
AS 
SELECT 
I.CompanyName ,I.UniqueCode,I.IsCreditAllowed as CreditAllowed,
UserName ,[LoweredEmail] as Email ,[IsApproved] as Allowed,[IsLockedOut] as Locked,[LastLoginDate] as LastLoginOn,CreateDate as AddedOn
  FROM [CSLOrdering].[dbo].[aspnet_Membership] M inner join [CSLOrdering].[dbo].aspnet_Users A on M.UserId = A.UserId 
  inner join ARC_Ordering.dbo.UserMapping U on A.UserId = U.UserId 
  inner join  ARC_Ordering.dbo.Installer I on U.CompanyId = I.InstallerCompanyID
GO
/****** Object:  View [dbo].[VW_M2MUsageAlert]    Script Date: 12/14/2015 17:06:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_M2MUsageAlert] 
AS  

SELECT usersims.ID,
	aspnet_users.UserName,
	  aspnet_membership.Email,
	  userSIMS.DeviceID,
	  device_Api.Dev_Code,
	  device_Api.Dev_Usage
FROM usersims 
INNER JOIN device_Api ON  userSIMS.DeviceID = Device_API.ID
INNER JOIN CSLOrdering.DBO.aspnet_users ON usersims.UserID = aspnet_users.UserID
INNER JOIN CSLOrdering.DBO.aspnet_membership ON usersims.UserID = aspnet_membership.UserID
WHERE ISNULL(Dev_UsageLimitReached,0) =1
AND isnull(usersims.OverUsageAlert,0) = 1
GO
/****** Object:  View [dbo].[vw_TagList]    Script Date: 12/14/2015 17:06:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_TagList] 

AS
 
	 SELECT t.TagsId,t.Name,ISNULL(t.ParentId,0)ParentId ,ISNULL(t2.Name,'')  ParentTag,t.Code  
	 FROM Tags t 
		 LEFT  JOIN  tags t2 on t.ParentId=t2.TagsId
GO
/****** Object:  View [dbo].[VW_InstallerDetails]    Script Date: 12/14/2015 17:06:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_InstallerDetails]
AS
SELECT     inst.InstallerCompanyID, inst.CompanyName, inst.Accreditation, inst.UniqueCode, instAdd.AddressOne, instAdd.AddressTwo, instAdd.Town, instAdd.County, 
                      instAdd.PostCode, instAdd.Country, inst.SalesRep
FROM         dbo.Installer AS inst INNER JOIN
                      dbo.InstallerAddress AS instAdd ON inst.AddressID = instAdd.AddressID
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "inst"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 339
               Right = 222
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "instAdd"
            Begin Extent = 
               Top = 6
               Left = 260
               Bottom = 125
               Right = 420
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_InstallerDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_InstallerDetails'
GO
/****** Object:  View [dbo].[VW_M2MGetuserRequests]    Script Date: 12/14/2015 17:06:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE VIEW [dbo].[VW_M2MGetuserRequests]
AS
	SELECT [UserRequest_Status_Map].UserRequestStatusMapId,Device_API.Dev_Code,Dev_IMSINumber,[UserRequest_Status_Map].IsProcessed,EffectiveDate,[UserRequest_Status_Map].ProcessedTime
	FROM [UserRequest_Status_Map]
	INNER JOIN USERSIMS on USERSIMS.ID = [UserRequest_Status_Map].UserSIMSId
	inner JOIN Device_API on USERSIMS.DeviceID = Device_API.ID
	WHERE [UserRequest_Status_Map].ISProcessed=0 AND [UserRequest_Status_Map].IsCancelled = 0 
	AND [UserRequest_Status_Map].UserRequestId = 1
	AND EFFECTIVEDATE between dateadd(dd,-1,getdate()) and dateadd(dd,1,getdate())
GO
/****** Object:  View [dbo].[VW_GetSMSlisttoSend]    Script Date: 12/14/2015 17:06:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE VIEW [dbo].[VW_GetSMSlisttoSend]
AS
	SELECT DeviceSMSID,Dev_Code,Dev_IMSINumber,Dev_MSISDN,[Text] as MessageText,IsProcessed,ProcessedTime,CustomerID from DeviceSMS
	inner JOIN Device_API on DeviceSMS.DeviceID = Device_API.ID
	WHERE ISProcessed=0 AND MessageTypeID = 1
GO
/****** Object:  View [dbo].[VW_GetM2MConnectUsersDetail]    Script Date: 12/14/2015 17:06:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_GetM2MConnectUsersDetail] 
 
AS  
    

SELECT DISTINCT  
       usrs.UserId,
       usrs.UserName,
       ISNULL(memship.Email, '') AS Email,c.CurrencyCode,cm.CountryName HomeCountry,
	   memship.IsApproved ,
	   CompanyName ,
	   um.UniqueCode,
	   um.IsCreditAllowed,
	    ROL.RoleName
FROM  UserMapping um    
	  INNER JOIN CSLOrdering.dbo.aspnet_Users AS usrs on um.UserId=usrs.UserId
	  INNER JOIN CountryMaster cm on cm.CountryId=um.HomeCountryId
      INNER JOIN Currency c on c.CurrencyID=um.CurrencyId
	  LEFT JOIN Installer on um.UniqueCode = Installer.UniqueCode

       LEFT  JOIN CSLOrdering.dbo.aspnet_Membership AS memship
            ON  memship.UserId = usrs.UserId and memship.IsLockedOut=0
       LEFT  JOIN CSLOrdering.dbo.aspnet_UsersInRoles AS UsrRoles
            ON  UsrRoles.UserId = usrs.UserId
			 LEFT JOIN CSLOrdering.dbo.aspnet_Roles As ROL on 
     ROL.RoleId=UsrRoles.Roleid

WHERE  usrs.UserId IS NOT NULL
GO
/****** Object:  View [dbo].[vw_DeliveryPrices]    Script Date: 12/14/2015 17:06:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_DeliveryPrices]
AS
SELECT      dp.ID, dp.DeliveryTypeId, c.CurrencyCode, dp.DeliveryPrice
FROM            dbo.DeliveryPrices AS dp INNER JOIN
                         dbo.Currency AS c ON dp.CurrencyId = c.CurrencyID
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 248
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dp"
            Begin Extent = 
               Top = 6
               Left = 286
               Bottom = 135
               Right = 456
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_DeliveryPrices'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_DeliveryPrices'
GO
/****** Object:  View [dbo].[vw_Audit]    Script Date: 12/14/2015 17:06:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Audit]
AS
SELECT     dbo.Audit.UserName, dbo.Audit.CreatedOn, dbo.Audit.Notes, dbo.Audit.IPAddress, dbo.Audit.WindowsUser, dbo.AuditChanges.Change
FROM         dbo.Audit INNER JOIN
                      dbo.AuditChanges ON dbo.Audit.ChangeID = dbo.AuditChanges.ChangeID
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Audit"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 283
               Right = 193
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AuditChanges"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 323
               Right = 396
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 4815
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Audit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Audit'
GO
/****** Object:  StoredProcedure [dbo].[USP_SyncInstallerUserAddressToArcOrdering]    Script Date: 12/14/2015 17:06:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
CreatedBy: ShyamGaddam
CreatedOn: 17/10/2014
Purpose: To sync the installer shop user address ID to arc ordering users addressID
*/

CREATE Procedure [dbo].[USP_SyncInstallerUserAddressToArcOrdering]
as begin

begin try

Merge Arc_Ordering.dbo.InstallerUserAddress as AOIUP
using
(
select  AddressID,
FirstName,
LastName,
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
CreatedBy,
CreatedOn,
ModifiedBy,
ModifiedOn from [CSLOrdering].[dbo].[UserAddress]
) ISIUP
on AOIUP.InstallerUserAddressID = ISIUP.AddressID 
when matched then

update
set 

AOIUP.InstallerUserAddressID=ISIUP.AddressID,
AOIUP.FirstName=ISIUP.FirstName,
AOIUP.LastName=ISIUP.LastName,
AOIUP.AddressOne=ISIUP.AddressOne,
AOIUP.AddressTwo=ISIUP.AddressTwo,
AOIUP.Town=ISIUP.Town,
AOIUP.County=ISIUP.County,
AOIUP.PostCode=ISIUP.PostCode,
AOIUP.Email=ISIUP.Email,
AOIUP.Fax=ISIUP.Fax,
AOIUP.Telephone=ISIUP.Telephone,
AOIUP.Mobile=ISIUP.Mobile,
AOIUP.Country=ISIUP.Country,
AOIUP.CreatedBy=ISIUP.CreatedBy,
AOIUP.CreatedOn=ISIUP.CreatedOn,
AOIUP.ModifiedBy=ISIUP.ModifiedBy,
AOIUP.ModifiedOn=ISIUP.ModifiedOn


when not matched then

insert
(InstallerUserAddressID,
FirstName,
LastName,
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
CreatedBy,
CreatedOn,
ModifiedBy,
ModifiedOn
)
values
(
ISIUP.AddressId,
ISIUP.FirstName,
ISIUP.LastName,
ISIUP.AddressOne,
ISIUP.AddressTwo,
ISIUP.Town,
ISIUP.County,
ISIUP.PostCode,
ISIUP.Email,
ISIUP.Fax,
ISIUP.Telephone,
ISIUP.Mobile,
ISIUP.Country,
ISIUP.CreatedBy,
ISIUP.CreatedOn,
ISIUP.ModifiedBy,
ISIUP.ModifiedOn
);

end try

begin catch

return error_message()
end catch

end
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertProductPermission]    Script Date: 12/14/2015 17:06:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[SP_InsertProductPermission]
as begin


declare @i int = 4
while (@i<=139)
begin

declare @id int
declare @ProductPermission varchar(20)

select @id = id,@ProductPermission = ProductPermission  from Sheet1 where id= @i



if not exists(
select  * from  #Temp  where ARCId = @id and ProductId in ( select items from dbo.Split(@ProductPermission,',')))

begin



select ROW_NUMBER()over ( order by Items) RowNum,items into #Temp1
from
(
select distinct  items from dbo.Split(@ProductPermission,',') 
) a

declare @j int = (Select COUNT(*) from #Temp1)
declare @k int = 1
declare @productID int

while (@k < = @j)
begin

select @productID = Items from #Temp1 where RowNum = @k

select @productID, @id

insert into #Temp select @productID, @id

set @k = @k+ 1





end

drop table #Temp1
end

set @id = 0
set @ProductPermission =''
set @i = @i+ 1


end

end
GO
/****** Object:  StoredProcedure [dbo].[SP_SendMail_ARCOrdering]    Script Date: 12/14/2015 17:06:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*  
CreatedBy: ShyamGaddam  
CreatedOn: 17Th July 2013
Purpose: To Send the Email to the Customers for Online Ordering

@SentMailStatus = 1 -->Success 0 -->False
*/  
Create Procedure [dbo].[SP_SendMail_ARCOrdering] (@OrderID int)

as begin  
  
DECLARE @body  NVARCHAR(MAX)  
Declare @FromMail varchar(500)
Declare @ToMail varchar(500)  
Declare @CCMail varchar(500)
Declare @BCC  varchar(500)  
Declare @SubjectDetails varchar(2000)   
Declare @mailitem_id int  
Declare @SentMailStatus int  
Declare @Attempts int = 0
Declare @AttemptedTime varchar(200)



select ROW_NUMBER()over(order by ID) RowNum,* into #Temp from  [dbo].[CSLOrderingEmail] where sentMail = 0  and OrderID = @OrderID

Declare @MaxCount int
Declare @Counter int = 1
select @MaxCount = COUNT(*) from #Temp
  if(@MaxCount=0)
  begin 
  
  
  
while(  @Counter <= @MaxCount)
begin

select @FromMail=MailFrom,@ToMail =MailTo,@CCMail=MailCC,@BCC= MailBCC, @body = Body,@SubjectDetails = [Subject] from #Temp where RowNum = @Counter

 EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'ExternalOrdering',  
    @recipients= @ToMail,  
    @copy_recipients = @CCMail,  
    @blind_copy_recipients= @BCC,  
    @body = @body,   
    @subject = @SubjectDetails,     
    @body_format = 'HTML',  
     @from_address  = @FromMail,
    @mailitem_id = @mailitem_id   output     
     waitfor delay '00:00:10'

select @SentMailStatus =  sent_status ,@AttemptedTime = CONVERT(varchar(10),coalesce(send_request_date,''),105) + ' '+ CONVERT(varchar(10),coalesce(send_request_date,''),108)  from msdb.dbo.sysmail_mailitems  where mailitem_id = @mailitem_id 

set   @Attempts = 1

if(@SentMailStatus =0)
begin
EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'ExternalOrdering',  
    @recipients= @ToMail,  
    @copy_recipients = @CCMail,  
    @blind_copy_recipients= @BCC,  
    @body = @body,   
    @subject = @SubjectDetails,     
    @body_format = 'HTML', 
    @from_address  = @FromMail, 
    @mailitem_id = @mailitem_id   output   
    
   set @Attempts = @Attempts + 1
    waitfor Delay '00:00:10'  
    
select @SentMailStatus =  sent_status ,@AttemptedTime = CONVERT(varchar(10),coalesce(send_request_date,''),105) + ' '+ CONVERT(varchar(10),coalesce(send_request_date,''),108)  from msdb.dbo.sysmail_mailitems  where mailitem_id = @mailitem_id   
  
end

Update [CSLOrderingEmail] set SentMail = @SentMailStatus,NumberOfAttempts = @Attempts,AttemptedTime =  @AttemptedTime from [CSLOrderingEmail] a inner join #Temp b on a.ID = b.ID where b.RowNum = @Counter
    
set @Counter = @Counter + 1
 end
  
drop table #Temp

end  
end
GO
/****** Object:  UserDefinedFunction [dbo].[GetHOUniqueCode]    Script Date: 12/14/2015 17:06:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sri
-- Create date: 17 SEpt 2013
-- Description:	Returns UNIQUE CODE OF HO IF PRESENT 
-- =============================================
CREATE FUNCTION [dbo].[GetHOUniqueCode]
(
	@UniqueCode INT
)
RETURNS INT
AS
BEGIN
declare @Result INT 

	SELECT @Result = Headoffice.UniqueCode FROM Installer HEADOFFICE
	INNER JOIN Installer BRANCH ON HEADOFFICE.InstallerCompanyID = Branch.HeadOfficeID AND Branch.UniqueCode = @UniqueCode

return ISNULL(@Result,@UniqueCode)
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SaveSPErrorDetails]    Script Date: 12/14/2015 17:06:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_SaveSPErrorDetails]


As
 
	BEGIN
	  
	  INSERT INTO ERRORLOG(PageName,MethodName,ErrorMessage,CreatedOn,Notes) VALUES('Stored Procedure',ERROR_PROCEDURE(),ERROR_MESSAGE(),GETDATE(),'ERRORNUMBER='+ convert(varchar(100),ERROR_NUMBER() )+ '  ERRORLINE='+CONVERT(varchar(100),ERROR_LINE()))
	  
    END
GO
/****** Object:  StoredProcedure [dbo].[SP_SyncOrderingEmailToBOS]    Script Date: 12/14/2015 17:06:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_SyncOrderingEmailToBOS]    
as begin    
    
    
     
select ROW_NUMBER() over(order by ID ) RowNum,* into #Temp from CSLOrderingEmail  where Sync_Status = 'A'    
      
      
      
Declare @i int = 1      
Declare @j int = (Select MAX(RowNum) from #Temp  )      
    
    
      
while(@i < = @j)      
begin      
    
    
 insert into [BOS].Dualcom_Reports.dbo.CSLOrderingEmail(OrderNo,    
Subject,    
Body,    
MailFrom,    
MailTo,    
MailCC,    
MailBCC,SentMail) Select  OrderNo, Subject,Body,MailFrom, MailTo, MailCC , MailBCC,0  from #Temp where RowNum = @i    
    
Update CSLOrderingEmail set Sync_Status = 'P' from CSLOrderingEmail a inner join #Temp b on a.ID = b.ID where RowNum = @i    
       
set @i = @i+1    
       
   end    
       
   end
GO
/****** Object:  StoredProcedure [dbo].[SP_SyncBOSDevice2ARC_Device]    Script Date: 12/14/2015 17:06:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*CreatedBy: Shyam Gaddam
CreatedOn: 30th May 2013
Purpose: To Sync the Device details from BOS to Arc Ordering*/

  
CREATE Procedure [dbo].[SP_SyncBOSDevice2ARC_Device]  
as begin 

    
begin try     
   begin transaction  

select [Dev_Code],[Dev_Type], case when isnull([Dev_Account_Code],'')<> '' then [Dev_Account_Code] else [Dev_Account_Code_PSTN] end as [Dev_Account_Code],[Dev_Account_Code_GSM],[Dev_Account_Code_PSTN],[Dev_Account_Code_LAN],[Dev_Connect_Number],[Dev_Inst_Code]
		,[Dev_Inst_UnqCode],[Dev_PS_Primary],[Dev_PS_Secondary],[Dev_Active],Replace([Dev_Arc_Primary],'G5','') [Dev_Arc_Primary],[Dev_Poll_Color],[Dev_ModifiedBy],[Dev_First_Poll_DateTime],[Dev_LastModified]
		,[Dev_UpdatedBy],[Dev_LastUpdated],[Dev_Delete_Flag] into #Temp
		FROM BOS.Dualcom_Final.dbo.Device 
    


Merge [ARC_Ordering].dbo.BOS_Device as Live_Device  
using 
(select  [Dev_Code] collate Latin1_General_CI_AS [Dev_Code],[Dev_Type] collate Latin1_General_CI_AS [Dev_Type],[Dev_Account_Code] collate Latin1_General_CI_AS [Dev_Account_Code]
      ,[Dev_Account_Code_GSM] collate Latin1_General_CI_AS [Dev_Account_Code_GSM],[Dev_Account_Code_PSTN] collate Latin1_General_CI_AS [Dev_Account_Code_PSTN]
      ,[Dev_Account_Code_LAN] collate Latin1_General_CI_AS [Dev_Account_Code_LAN],[Dev_Connect_Number] collate Latin1_General_CI_AS [Dev_Connect_Number],[Dev_Inst_Code] collate Latin1_General_CI_AS [Dev_Inst_Code]
      ,[Dev_Inst_UnqCode] ,[Dev_PS_Primary] collate Latin1_General_CI_AS [Dev_PS_Primary],[Dev_PS_Secondary] collate Latin1_General_CI_AS [Dev_PS_Secondary],[Dev_Active] 
      ,[Dev_Arc_Primary] collate Latin1_General_CI_AS [Dev_Arc_Primary],[Dev_Poll_Color] collate Latin1_General_CI_AS [Dev_Poll_Color],[Dev_ModifiedBy] collate Latin1_General_CI_AS [Dev_ModifiedBy]
      ,[Dev_First_Poll_DateTime] ,[Dev_LastModified] ,[Dev_UpdatedBy] collate Latin1_General_CI_AS [Dev_UpdatedBy],[Dev_LastUpdated] ,[Dev_Delete_Flag] 
  FROM #Temp
) Final_Device  
on Live_Device.Dev_Code = Final_Device.Dev_Code
when  Matched then  Update Set 
Live_Device.Dev_Type  = Final_Device.Dev_Type,
Live_Device.Dev_Account_Code  = Final_Device.Dev_Account_Code,
Live_Device.Dev_Account_Code_GSM  = Final_Device.Dev_Account_Code_GSM,
Live_Device.Dev_Account_Code_PSTN  = Final_Device.Dev_Account_Code_PSTN,
Live_Device.Dev_Account_Code_LAN  = Final_Device.Dev_Account_Code_LAN,
Live_Device.Dev_Connect_Number  = Final_Device.Dev_Connect_Number,
Live_Device.Dev_Inst_Code  = Final_Device.Dev_Inst_Code,
Live_Device.Dev_Inst_UnqCode  = Final_Device.Dev_Inst_UnqCode,
Live_Device.Dev_PS_Primary  = Final_Device.Dev_PS_Primary,
Live_Device.Dev_PS_Secondary  = Final_Device.Dev_PS_Secondary,
Live_Device.Dev_Active  = Final_Device.Dev_Active,
Live_Device.Dev_Arc_Primary  = Final_Device.Dev_Arc_Primary,
Live_Device.Dev_Poll_Color  = Final_Device.Dev_Poll_Color,
Live_Device.Dev_ModifiedBy  = Final_Device.Dev_ModifiedBy,
Live_Device.Dev_First_Poll_DateTime  = Final_Device.Dev_First_Poll_DateTime,
Live_Device.Dev_LastModified  = Final_Device.Dev_LastModified,
Live_Device.Dev_UpdatedBy  = Final_Device.Dev_UpdatedBy,
Live_Device.Dev_LastUpdated  = Final_Device.Dev_LastUpdated,
Live_Device.Dev_Delete_Flag  = Final_Device.Dev_Delete_Flag 


when Not Matched then   
insert ([Dev_Code]
      ,[Dev_Type]
      ,[Dev_Account_Code]
      ,[Dev_Account_Code_GSM]
      ,[Dev_Account_Code_PSTN]
      ,[Dev_Account_Code_LAN]
      ,[Dev_Connect_Number]
      ,[Dev_Inst_Code]
      ,[Dev_Inst_UnqCode]
      ,[Dev_PS_Primary]
      ,[Dev_PS_Secondary]
      ,[Dev_Active]
      ,[Dev_Arc_Primary]
      ,[Dev_Poll_Color]
      ,[Dev_ModifiedBy]
      ,[Dev_First_Poll_DateTime]
      ,[Dev_LastModified]
      ,[Dev_UpdatedBy]
      ,[Dev_LastUpdated]
      ,[Dev_Delete_Flag])
           values (
Final_Device.Dev_Code,
Final_Device.Dev_Type,
Final_Device.Dev_Account_Code,
Final_Device.Dev_Account_Code_GSM,
Final_Device.Dev_Account_Code_PSTN,
Final_Device.Dev_Account_Code_LAN,
Final_Device.Dev_Connect_Number,
Final_Device.Dev_Inst_Code,
Final_Device.Dev_Inst_UnqCode,
Final_Device.Dev_PS_Primary,
Final_Device.Dev_PS_Secondary,
Final_Device.Dev_Active,
Final_Device.Dev_Arc_Primary,
Final_Device.Dev_Poll_Color,
Final_Device.Dev_ModifiedBy,
Final_Device.Dev_First_Poll_DateTime,
Final_Device.Dev_LastModified,
Final_Device.Dev_UpdatedBy,
Final_Device.Dev_LastUpdated,
Final_Device.Dev_Delete_Flag
) ;  
      
      drop table #Temp
      
   commit transaction    
 end try     
 begin catch     
   if @@TRANCOUNT > 0     

   rollback tran    
   
 end catch     
 
 
 
end
GO
/****** Object:  StoredProcedure [dbo].[SP_SyncBOS2Ordering_GradeMap2Master]    Script Date: 12/14/2015 17:06:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
CreatedBy: ShyamGaddam
CreatedOn: 01st Oct 2013
Purpose: To sync the GradeMap2Maser from BOS to Ordering
*/
  
CREATE Procedure [dbo].[SP_SyncBOS2Ordering_GradeMap2Master]  
as begin 

declare @ErrorMessage nvarchar(100)    
declare @UpdateCount int    
    
begin try     
   begin transaction  

Merge ARC_Ordering.dbo.GradeMap2Master as Live_DeviceGrade 
using
(
select MasterGrade,
BOSGrade,
createdby,
Createdon,
modifiedby,
modifiedon,
IsActive
from [BOS].Dualcom_Final.dbo.GradeMap2Master
) Final_DeviceGrade
on Live_DeviceGrade.MasterGrade collate SQL_Latin1_General_CP1_CI_AS = Final_DeviceGrade.MasterGrade collate SQL_Latin1_General_CP1_CI_AS 

and Live_DeviceGrade.BOSGrade collate SQL_Latin1_General_CP1_CI_AS = Final_DeviceGrade.BOSGrade collate SQL_Latin1_General_CP1_CI_AS
when not matched then 
insert(MasterGrade,
BOSGrade,
createdby,
Createdon,
modifiedby,
modifiedon,
IsActive)
           values
           (
           Final_DeviceGrade.MasterGrade,
Final_DeviceGrade.BOSGrade,
Final_DeviceGrade.createdby,
Final_DeviceGrade.Createdon,
Final_DeviceGrade.modifiedby,
Final_DeviceGrade.modifiedon,
Final_DeviceGrade.IsActive
)

when  Matched then  Update Set 
 Live_DeviceGrade.MasterGrade  =  Final_DeviceGrade.MasterGrade, 
  Live_DeviceGrade.BOSGrade  =  Final_DeviceGrade.BOSGrade,
   Live_DeviceGrade.createdby  =  Final_DeviceGrade.createdby,
 Live_DeviceGrade.Createdon  =  Final_DeviceGrade.Createdon,
  Live_DeviceGrade.modifiedby  =  Final_DeviceGrade.modifiedby,
   Live_DeviceGrade.modifiedon  =  Final_DeviceGrade.modifiedon,
      Live_DeviceGrade.IsActive  =  Final_DeviceGrade.IsActive
 ;
set @UpdateCount = @@ROWCOUNT 
Insert into [Sync_BOS2Ordering] 
([Sync_Tablename],[Sync_Operation],[Sync_Server],[Sync_Status],[Sync_Err_Description],[Sync_DateTime],RecordsEffected)    
values ('GradeMap2Master','U','DualcomBOS01','S','Success',GETDATE(),@UpdateCount) 
commit transaction    
 end try  
begin catch     
   if @@TRANCOUNT > 0     
   set @ErrorMessage =  ERROR_MESSAGE()    
   rollback tran 
   insert into [Sync_BOS2Ordering] ([Sync_Tablename],[Sync_Operation],[Sync_Server],[Sync_Status],[Sync_Err_Description],[Sync_DateTime],RecordsEffected)    
   values ('GradeMap2Master','U','DualcomBOS01','F',@ErrorMessage,GETDATE(),0)
end catch
end
GO
/****** Object:  StoredProcedure [dbo].[SP_SyncBOS2Ordering_DeviceGrade]    Script Date: 12/14/2015 17:06:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_SyncBOS2Ordering_DeviceGrade]    
as begin   
  
declare @ErrorMessage nvarchar(100)      
declare @UpdateCount int      
      
begin try       
  
Merge ARC_Ordering.dbo.Device_Grade as Live_DeviceGrade   
using  
(  
select Product_Code collate  Latin1_General_CI_AS Product_Code,  
Dev_PS_Code collate  Latin1_General_CI_AS Dev_PS_Code,  
Dev_Grade collate  Latin1_General_CI_AS Dev_Grade,  
Dev_Active  
from [BOS].Dualcom_Final.dbo.Device_Grade  
) Final_DeviceGrade  
on Live_DeviceGrade.Dev_PS_Code = Final_DeviceGrade.Dev_PS_Code and Live_DeviceGrade.Dev_Grade = Final_DeviceGrade.Dev_Grade   
when not matched then   
insert(Product_Code,  
Dev_PS_Code,  
Dev_Grade,  
Dev_Active)  
           values  
           (  
           Final_DeviceGrade.Product_Code,  
Final_DeviceGrade.Dev_PS_Code,  
Final_DeviceGrade.Dev_Grade,  
Final_DeviceGrade.Dev_Active)  
  
when  Matched then  Update Set   
 Live_DeviceGrade.Product_Code  =  Final_DeviceGrade.Product_Code,   
  Live_DeviceGrade.Dev_PS_Code  =  Final_DeviceGrade.Dev_PS_Code,  
   Live_DeviceGrade.Dev_Grade  =  Final_DeviceGrade.Dev_Grade,  
 Live_DeviceGrade.Dev_Active  =  Final_DeviceGrade.Dev_Active  
 ;  
set @UpdateCount = @@ROWCOUNT   
Insert into [Sync_BOS2Ordering]   
([Sync_Tablename],[Sync_Operation],[Sync_Server],[Sync_Status],[Sync_Err_Description],[Sync_DateTime],RecordsEffected)      
values ('Device_Grade','U','DualcomBOS01','S','Success',GETDATE(),@UpdateCount)   
    
 end try    
begin catch       
   if @@TRANCOUNT > 0       
   set @ErrorMessage =  ERROR_MESSAGE()      
 
   insert into [Sync_BOS2Ordering] ([Sync_Tablename],[Sync_Operation],[Sync_Server],[Sync_Status],[Sync_Err_Description],[Sync_DateTime],RecordsEffected)      
   values ('Device_Grade','U','DualcomBOS01','F',@ErrorMessage,GETDATE(),0)  
end catch  
end
GO
/****** Object:  StoredProcedure [dbo].[SP_SyncBOS2Ordering_Device_API]    Script Date: 12/14/2015 17:06:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*CreateBy: ShyamGaddam   
  CreatedOn:20th Sep 2011   
  Purpose: To get the device API details from Final to Live      
    
  UpdatedBy: ShyamGaddam  
  UpdatedOn 18/11/2014  
  Purpose: Removed '000' prefix before MSISDN number    
    
  select * from Device_API where Dev_Code = '89462046001000894444'  
  */      
    
        
    
CREATE Procedure [dbo].[SP_SyncBOS2Ordering_Device_API]      
    
as begin      
    
        
    
declare @ErrorMessage nvarchar(100)      
    
declare @UpdateCount int      
    
begin try        
    
     
    
      
    
  select case when len(Dev_Code) = 19 then 'E'+Dev_Code else Dev_Code  end as Dev_Code,Dev_IMSINumber,Dev_IP_Address,blnFetched,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn,'' Data_Number,  
  case when Dev_Code like '8946%' then  MSISDN else MSISDN end as MSISDN,SIMColor into  #Temp     
    
from  BOS.Dualcom_M2M.dbo.Device_API   where isnull(Dev_IP_Address,'')<>'' and blnFetched = 1    
    
      
    
  union all    
    
      
    
   select case when len(Dev_Code) = 19 then 'E'+Dev_Code else Dev_Code  end as Dev_Code,'','',1,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn,    
    
  case when ltrim(rtrim(Data_Number)) like '0%' and Dev_Code not like '8944%' and Data_Number not like '00353%' then    
    
  '00353'+RIGHT(Data_Number, LEN(ltrim(rtrim(Data_Number))) - 1)  when Dev_Code not like '8944%' and Data_Number not like '00353%' then    
    
  '00353'+RIGHT(Data_Number, LEN(ltrim(rtrim(Data_Number))) )  else Data_Number end as Data_Number,''MSISDN ,''   
    
   from BOS.Dualcom_M2M.dbo.CSL_WorldSims where isnull(Data_Number,'')<>''   
     
     
  
select Dev_Code , DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) StartDate,   
GETDATE() EndDate,  
case when Dev_Code like '8931%' then  CONVERT(decimal(30,2), CONVERT(decimal(30,2), DataUsage) /1024/1024) else DataUsage end as  
 DataUsage,  
 VoiceUsage,  
 SMSUsage,UsageLimitReached into #TempSimUsage  
 from BOS.Dualcom_M2M.dbo.Device_API_Polling a with (nolock)  where   
 Poll_Date= cast(CONVERT(varchar(8),GETDATE()-1,112) as int)  
    
  ;  
with CTE as  
(  
select ROW_NUMBER() over(Partition by  Dev_Code order by ID Desc ) RowNum, Dev_Code,ID,Poll_Date, Poll_Status,RAG_Status,InSession,Date_activated,Sim_Status from BOS.Dualcom_M2M.dbo.Device_API_Polling  a with (nolock) where   
 Poll_Date>= cast(CONVERT(varchar(8),DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0),112) as int) --and Dev_Code = '89314404000027206029' --order by Dev_Code,ID desc  
 ) select * into #TempStatus from CTE where RowNum = 1  
     
    
 delete from #Temp where Dev_Code in    
    
 (    
    
 select Dev_Code from #Temp group by Dev_Code having COUNT(*)>1    
    
 )   
   
   
    
      
    
Merge Device_API as Live_DeviceAPI      
    
using (      
    
select Dev_Code collate Latin1_General_CI_AS Dev_Code,    
    
Dev_IMSINumber collate Latin1_General_CI_AS Dev_IMSINumber,    
    
Dev_IP_Address collate Latin1_General_CI_AS Dev_IP_Address,    
    
blnFetched ,    
    
CreatedBy collate Latin1_General_CI_AS CreatedBy,    
    
CreatedOn ,    
    
ModifiedBy collate Latin1_General_CI_AS ModifiedBy,    
    
ModifiedOn  ,Data_Number,MSISDN ,SIMColor  
    
from #Temp ) Final_DeviceAPI      
    
on Live_DeviceAPI.Dev_Code = Final_DeviceAPI.Dev_Code      
    
when matched then  Update Set       
    
Live_DeviceAPI.Dev_Code  =Final_DeviceAPI.Dev_Code,      
    
Live_DeviceAPI.Dev_IMSINumber=Final_DeviceAPI.Dev_IMSINumber,      
    
Live_DeviceAPI.Dev_IP_Address=Final_DeviceAPI.Dev_IP_Address,      
    
Live_DeviceAPI.blnFetched=Final_DeviceAPI.blnFetched,      
    
Live_DeviceAPI.CreatedBy=Final_DeviceAPI.CreatedBy,      
    
Live_DeviceAPI.CreatedOn=Final_DeviceAPI.CreatedOn,      
    
Live_DeviceAPI.ModifiedBy=Final_DeviceAPI.ModifiedBy,      
    
Live_DeviceAPI.ModifiedOn=Final_DeviceAPI.ModifiedOn ,     
    
Live_DeviceAPI.Data_Number=Final_DeviceAPI.Data_Number  ,    
Live_DeviceAPI.Dev_MSISDN = Final_DeviceAPI.MSISDN,  
    
  Live_DeviceAPI.SIMColor = Final_DeviceAPI.SIMColor  
    
when not matched then       
    
insert     
    
 ([Dev_Code],Dev_IMSINumber,Dev_IP_Address,blnFetched,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn,Data_Number,Dev_MSISDN,SIMColor) values  (Final_DeviceAPI.Dev_Code,Final_DeviceAPI.Dev_IMSINumber,      
    
 Final_DeviceAPI.Dev_IP_Address,      
    
 Final_DeviceAPI.blnFetched,      
    
 Final_DeviceAPI.CreatedBy,      
    
 Final_DeviceAPI.CreatedOn,      
    
 Final_DeviceAPI.ModifiedBy,      
    
 Final_DeviceAPI.ModifiedOn ,    
    
  Final_DeviceAPI.Data_Number   ,    
Final_DeviceAPI.MSISDN,SIMColor    
 );    
    
  
   
Update   Device_API set Dev_Usage = b.DataUsage,dev_voiceusage=VoiceUsage,dev_smsusage=SMSUsage,Dev_Usage_StartDate=StartDate,Dev_Usage_EndDate=EndDate ,Dev_UsageLimitReached = UsageLimitReached  
   
from Device_API a inner join #TempSimUsage b on a.Dev_Code collate Latin1_General_CI_AS = b.Dev_Code collate Latin1_General_CI_AS   
  
  
Update   Device_API set Poll_Status = b.Poll_Status,RAG_Status=b.RAG_Status,InSession=b.InSession,Date_activated=b.Date_activated,Sim_Status=b.Sim_Status   
   
from Device_API a inner join #TempStatus b on a.Dev_Code collate Latin1_General_CI_AS = b.Dev_Code collate Latin1_General_CI_AS   
  
  
  
   
drop table #TempSimUsage  
    
 drop table #Temp      
   
 drop table #TempStatus  
    
    
    
    
    
end try           
    
 begin catch           
    
   if @@TRANCOUNT > 0           
    
   set @ErrorMessage =  ERROR_MESSAGE()          
    
               
    
 end catch      
    
end
GO
/****** Object:  StoredProcedure [dbo].[USP_FedexImport]    Script Date: 12/14/2015 17:06:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_FedexImport]
as begin

CREATE TABLE #files (name varchar(200) NULL, sql varchar(5000)  NULL)

create table #temp1(orderno varchar(200),trackingnumber varchar(200))

DECLARE @sql varchar(8000)
Declare @name varchar(500)
declare @inpath varchar(100)
declare @filestatus int

set @name = 'Fedexexport.csv'
set @name ='export280314161443-0937.csv'

SET   @sql  = 'BULK INSERT #temp1 FROM ''C:\FedExport\' + @name + ''' WITH (' +
             'FIELDTERMINATOR = '','',  ' +
             'ROWTERMINATOR = ''\n'')'


EXEC(@sql)





insert into Fedex_Import(OrderNo,TrackingNO)
select REPLACE(OrderNo,'"',''),REPLACE(trackingnumber,'"','') from #temp1



--SET @inpath = 'move "C:\\FedExport\Fedexexport.csv" "C:\\FedExport\Fedexexport_archive.csv"'
--EXEC @filestatus = master..xp_cmdshell @inpath



drop table #files
drop table #temp1

end
GO
/****** Object:  StoredProcedure [dbo].[USP_GetInstallerList]    Script Date: 12/14/2015 17:06:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alex Papayianni
-- Create date: 04/04/2014
-- Description:	Generates list of installer addresses
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetInstallerList]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select UniqueCode,Installer.CompanyName,Addressone,AddressTwo,Town,County,Country,Postcode,[Installer].CreatedOn,[Installer].CreatedBy,[Installer].ModifiedOn 
	from [dbo].[Installer]
	inner join [dbo].[InstallerAddress] on [InstallerAddress].AddressId = [Installer].AddressId
	order by createdon desc

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetUserCredibility]    Script Date: 12/14/2015 17:06:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetUserCredibility]
	-- Add the parameters for the stored procedure here
 
 @userId uniqueidentifier

AS
BEGIN
	 
	  SELECT ISNULL(IsCreditAllowed,0) AS IsCreditAllowed FROM USERMAPPING WHERE USERID = @userId
	 --DECLARE @companyId UNIQUEIDENTIFIER
 


		--SELECT @companyId=um.CompanyId FROM UserMapping um
		--									INNER JOIN  UserCategory uc on um.UserCategoryId=uc.UserCategoryId
		--								WHERE um.UserId =@userId
 
		-- IF (@companyId IS NOT NULL)
		--	 BEGIN 
		--		  SELECT ISNULL(IsCreditAllowed,0)IsCreditAllowed  FROM M2MCompany WHERE M2MCompanyID=@companyId
		--	 END 
		-- ELSE
		--	 BEGIN

		--			DECLARE @userCategoryId UNIQUEIDENTIFIER
		--			DECLARE @userType NVARCHAR(250)
		--		    SELECT @userCategoryId=um.UserCategoryId FROM UserMapping um
		--													 INNER JOIN  UserCategory uc ON um.UserCategoryId=uc.UserCategoryId
		--													 WHERE um.UserId =@userId
 
		--			SELECT @userType=Category FROM UserCategory where UserCategoryId=@userCategoryId
   
		--			   IF (@userType='Installer')
		--			   BEGIN 
		--			   SELECT ISNULL(i.IsCreditAllowed,0) IsCreditAllowed FROM installer i 
		--																 INNER JOIN Installer_User_Map iu ON i.InstallerCompanyID=iu.InstallerCompanyID AND iu.UserID = @userId
		--			   END
		--			   ELSE
		--			   BEGIN
		--			    SELECT cast(0 as BIT) AS  IsCreditAllowed
		--			   END 
		--		END


END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetPriceBandTableViewPerProduct]    Script Date: 12/14/2015 17:06:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alex Papayianni
-- Create date: 17/04/2015
-- Description:	Displays price bands per products as a table
--[USP_GetPriceBandTableViewPerProduct] 1
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetPriceBandTableViewPerProduct]

@ProductId int = 0
AS
BEGIN
declare @sqlSelect varchar(max)

Declare @column  varchar(500)

select @column = (
select ('[' + BandName + '],')  from BandNameMaster for xml path('')
)
select @column = LEFT(RTRIM(@column),(LEN(RTRIM(@column)))-1)


Declare @column1  varchar(500)

select @column1 = (
select ('[' + BandName + '] as ' + BandName + '1,')  from BandNameMaster for xml path('')
)


select @column1 = LEFT(RTRIM(@column1),(LEN(RTRIM(@column1)))-1)



Declare @prices  varchar(max)

select @prices = (
select distinct ('isnull(cast([' + bnm.BandName + '] as varchar) + '' | '' + cast([' + bnm.BandName + '1] as varchar),'''') [' + bnm.BandName + '],')  from PriceBand pb
join BandNameMaster bnm on pb.BandNameId = bnm.ID where pb.productid = @ProductId for xml path('')
)
select @prices = LEFT(RTRIM(@prices),(LEN(RTRIM(@prices)))-1)

set @sqlSelect = '
select a.[CurrencyCode],' + @prices + '
from
(
select [CurrencyCode],' + @column + '
from
(
SELECT [BandName]
      ,[CurrencyCode] + '' '' + [CurrencySymbol] CurrencyCode
      ,[ProductName]
      ,pb.[Price]
  FROM [Arc_Ordering_Copy].[dbo].[PriceBand] pb
  join [BandNameMaster] bnm on pb.BandNameID = bnm.ID
  join Products p on pb.ProductId = p.ProductId
  join Currency c on pb.CurrencyID = c.CurrencyID
  where pb.productid = ' + cast(@ProductId as varchar)  + '
  )a pivot ( sum(Price) for BandName in ( ' + @column + ') ) as pvt  
  )a inner join
  (
  select [CurrencyCode],' + @column1 + '
from
(
SELECT [BandName]
      ,[CurrencyCode] + '' '' + [CurrencySymbol] CurrencyCode
      ,[ProductName]
      ,pb.[AnnualPrice]
  FROM [Arc_Ordering_Copy].[dbo].[PriceBand] pb
  join [BandNameMaster] bnm on pb.BandNameID = bnm.ID
  join Products p on pb.ProductId = p.ProductId
  join Currency c on pb.CurrencyID = c.CurrencyID
  where pb.productid = ' + cast(@ProductId as varchar)  + '
  )a pivot ( sum(AnnualPrice) for BandName in ( ' + @column + ') ) as pvt  
  )b on a.CurrencyCode = b.CurrencyCode'

exec (@sqlSelect)



END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetUserSMS]    Script Date: 12/14/2015 17:06:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Mohd Atiq
-- Create date: 28-Sep-2015
-- Description:	Added DateAdded in where clause to fetch current date sms for device
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetUserSMS]	
@iccid NVARCHAR(256)
AS

BEGIN
		
		SELECT d.DeviceSMSId,d.[Text],d.DateAdded,m.[Type] MessageType,
		d.Isprocessed Processed,d.ProcessedTime,
		       dm.Dev_Code as ICCID,dm.Dev_usage as Usage,
		       dm.Dev_IMSINumber as IMSI,dm.Dev_MSISDN as MSISDN 
		FROM DeviceSMS d
		INNER JOIN MessageType m  ON d.MessageTypeId=m.MessageTypeId
        INNER JOIN Device_API dm  ON d.DeviceID=dm.ID and dm.Dev_Code=@iccid
        where CONVERT(VARCHAR(25),d.DateAdded,102)=CONVERT(VARCHAR(25),GETDATE(),102)
		order by d.DateAdded desc

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetPortalMenulinks]    Script Date: 12/14/2015 17:06:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Description:	Get menu link detail for the logged on user role 
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetPortalMenulinks]
	@userID uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 --   -- Insert statements for procedure here
	Declare @roleName varchar(100);

	select Top 1 @roleName = portal_roles.RoleName from cslordering.[dbo].[aspnet_UsersInRoles]
	inner join cslordering.[dbo].[aspnet_Roles] on [aspnet_Roles].RoleID = [aspnet_UsersInRoles].RoleID 
	inner join portal_roles on portal_roles.roleName = [aspnet_Roles].roleName
	Where USERID = @userID
	Order by portal_roles.RoleID Desc 


	SELECT PortalPages.* from PortalPages
	cross join portal_roles 
	Where   portal_roles.rolename = @rolename
	AND portalpages.Roles & RoleID <> 0 

	Order by SortOrder 

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetM2MUserDetails]    Script Date: 12/14/2015 17:06:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetM2MUserDetails]
	-- Add the parameters for the stored procedure here
	 @userId UNIQUEIDENTIFIER 
AS
BEGIN
			SELECT DISTINCT
			   usrs.UserId,
			   usrs.UserName,
			   ISNULL(memship.Email, '') AS Email,c.CurrencyCode,um.CurrencyId,cm.CountryName HomeCountry,HomeCountryId HomeCountryId,
			   Convert(BIT,coalesce(memship.IsApproved,0)) IsApproved,
			   um.UserCategoryId,
			   um.CompanyId,
			   uc.Category,
			   mc.CompanyName ,
			   um.IsCreditAllowed
		FROM  UserMapping um    
			  INNER JOIN CSLOrdering.dbo.aspnet_Users AS usrs on um.UserId=usrs.UserId
			  INNER JOIN CountryMaster cm on cm.CountryId=um.HomeCountryId
			  INNER JOIN Currency c on c.CurrencyID=um.CurrencyId
			  LEFT JOIN  UserCategory uc on um.UserCategoryId=uc.UserCategoryId
			  LEFT JOIN M2MCompany mc on um.CompanyId=mc.M2MCompanyID
			  LEFT  JOIN CSLOrdering.dbo.aspnet_Membership AS memship
					ON  memship.UserId = usrs.UserId and memship.IsLockedOut=0
			  LEFT  JOIN CSLOrdering.dbo.aspnet_UsersInRoles AS UsrRoles
					ON  UsrRoles.UserId = usrs.UserId
		WHERE  usrs.UserId =@userId
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertOrderSIMMapForM2M]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =====================================================================================
-- Created by:Atiq 
-- Created Date:06/10/2015
-- =======================================================================================
CREATE PROCEDURE [dbo].[USP_InsertOrderSIMMapForM2M]
	@Old_Orderno INT,
	@Old_dev_Account_code NVARCHAR(20),
	@Old_Orderdate DATETIME, 
	@New_Orderno INT, 	
	@New_dev_Account_code NVARCHAR(20)	
AS
BEGIN
  
      INSERT INTO dbo.Order_SIM_Map
				(
				Old_Orderno,
				Old_dev_Account_code,
				Old_Orderdate, 
				New_Orderno, 	
				New_orderdate,
				New_dev_Account_code,
				OrderReplacementDate
                )
                Values
                (
				@Old_Orderno,
				@Old_dev_Account_code,
				@Old_Orderdate,
				@New_Orderno,
				GETDATE(),
				@New_dev_Account_code,
				GETDATE()
                )
     
			
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SaveErrorDetails]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_SaveErrorDetails]    
@PageName NVARCHAR(200)='',    
@MethodName NVARCHAR(200)='',    
@ErrorMessage NVARCHAR(200)='',    
@InnerMessage TEXT='',    
@StackTrace TEXT='',    
@Notes NVARCHAR(500),
@UserIPAddress NVARCHAR(200)='',    
@Status BIT=0,    
@CreatedBy NVARCHAR(200)=''    
    
As    
BEGIN TRY    
 BEGIN    
       
   INSERT INTO ERRORLOG(PageName,MethodName,ErrorMessage,InnerMessage,StackTrace,Notes,UserIPAddress,[Status],CreatedBy,CreatedOn)    
    VALUES(@PageName,@MethodName,@ErrorMessage,@InnerMessage,@StackTrace,@Notes,@UserIPAddress,@Status,@CreatedBy,GETDATE())    
       
    END    
  RETURN 0        
END TRY    
BEGIN CATCH    
  --EXEC USP_SaveSPErrorDetails    
  RETURN -1     
END CATCH
GO
/****** Object:  UserDefinedFunction [dbo].[fn_IsM2MAdminUser]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [dbo].[fn_IsM2MAdminUser]
(
	@UserId NVarchar(256)
)
RETURNS NVarchar(Max)
AS
BEGIN
	Declare @return bit
	If Exists (Select 
	aspnet_UsersInRoles.UserId
	FROM
	CSLOrdering.dbo.aspnet_UsersInRoles 
	Inner Join
	CSLOrdering.dbo.aspnet_Roles  on aspnet_Roles.RoleId = aspnet_UsersInRoles.RoleId
	Where aspnet_UsersInRoles.UserId = @UserId AND LoweredRoleName='m2muser_admin' 
	)
	BEGIN 
	SET @return= 1 
	END 
	Else 
		BEGIN 
		SET @return= 0
		END 

	Return @return
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetUserRoles]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[fn_GetUserRoles]
(
	@UserId NVarchar(256)
)
RETURNS NVarchar(Max)
AS
BEGIN
	Declare @UserRoles NVarchar(Max)
	Select @UserRoles = COALESCE(@UserRoles + ', ', '') + roles.RoleName
	FROM
	CSLOrdering.dbo.aspnet_UsersInRoles UsrRoles
	Inner Join
	CSLOrdering.dbo.aspnet_Roles roles on roles.RoleId = UsrRoles.RoleId
	Where UsrRoles.UserId = @UserId
	RETURN @UserRoles
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetProductPrice]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Created  by:Atiq 
-- Date:04/08/2015
-- It will return price from priceband table for passing company id and product id.
-- =============================================
CREATE FUNCTION [dbo].[fn_GetProductPrice]
(
	@CompanyId NVarchar(256),
	@ProductId int
	
)
RETURNS NVarchar(Max)
AS
BEGIN
Declare @Price Decimal(6,2)
Set @Price=0
Select @Price=pb.Price from PriceBand pb
inner join dbo.CompanyPriceMap cpm
on pb.ID=cpm.PriceBandId
where CompanyId=@CompanyId and pb.ProductId=@ProductId	
RETURN @Price
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetCurrencyId]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Created  by:Atiq 
-- Date:04/08/2015
-- It will return currency id for passing company id.
-- =============================================
CREATE FUNCTION [dbo].[fn_GetCurrencyId]
(
	@CompanyId NVarchar(256)
)
RETURNS NVarchar(Max)
AS
BEGIN
Declare @CurrencyId INT
Set @CurrencyId=0
select distinct @CurrencyId=c.CurrencyId from currency c
inner join priceband pb
on c.CurrencyId=pb.CurrencyId
inner join dbo.CompanyPriceMap cpm
on pb.Id=cpm.PriceBandId
where cpm.CompanyID=@CompanyId	
RETURN @CurrencyId
END
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderId] [int] IDENTITY(1,1) NOT NULL,
	[OrderNo] [nvarchar](256) NOT NULL,
	[OrderRefNo] [nvarchar](256) NULL,
	[OrderDate] [datetime] NOT NULL,
	[Amount] [decimal](9, 2) NOT NULL,
	[DeliveryCost] [decimal](6, 2) NOT NULL,
	[OrderStatusId] [int] NOT NULL,
	[DeliveryAddressId] [int] NOT NULL,
	[InstallationAddressID] [int] NULL,
	[BillingAddressId] [int] NOT NULL,
	[OrderTotalAmount] [decimal](9, 2) NOT NULL,
	[DeliveryTypeId] [int] NOT NULL,
	[UserIPAddress] [nvarchar](20) NULL,
	[SpecialInstructions] [text] NULL,
	[ARCId] [int] NOT NULL,
	[ARC_Code] [nvarchar](256) NOT NULL,
	[ARC_EmailId] [nvarchar](256) NOT NULL,
	[ARC_BillingAccountNo] [nvarchar](50) NULL,
	[InstallerId] [uniqueidentifier] NULL,
	[InstallerCode] [nvarchar](100) NULL,
	[InstallerUnqCode] [nvarchar](50) NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[UserEmail] [nvarchar](256) NOT NULL,
	[CreatedBy] [nvarchar](256) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](256) NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[HasUserAcceptedDuplicates] [bit] NOT NULL,
	[VATRate] [decimal](6, 3) NOT NULL,
	[InstallerContactName] [varchar](256) NULL,
	[ProcessedBy] [varchar](256) NULL,
	[ProcessedOn] [datetime] NULL,
	[UserId] [uniqueidentifier] NULL,
	[SalesReply] [varchar](50) NULL,
	[DlvNoteVol] [int] NULL,
	[MergedOrderID] [int] NULL,
	[DeliveryNoteNo] [varchar](256) NULL,
	[IsShipped] [bit] NULL,
	[EmailSent] [bit] NULL,
	[OverriddenDeliveryCost] [decimal](6, 2) NULL,
	[PaymentType] [int] NULL,
	[BillingCycleID] [int] NULL,
	[InitialPayment] [decimal](9, 2) NULL,
	[MonthlyPayment] [decimal](9, 2) NULL,
	[OrderType] [int] NULL,
	[M2MReplacementOrderNo] [nvarchar](512) NULL,
	[CurrencyID] [int] NOT NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [orderno_unq_key] UNIQUE NONCLUSTERED 
(
	[OrderNo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IDX_NCD_Orders_ProcessedON] ON [dbo].[Orders] 
(
	[ProcessedOn] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderItems]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OrderItems](
	[OrderItemId] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductQty] [int] NOT NULL,
	[Price] [decimal](9, 2) NOT NULL,
	[OrderItemStatusId] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](256) NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](256) NOT NULL,
	[CategoryId] [int] NULL,
	[IsCSD] [bit] NULL,
	[ProcessedBy] [varchar](256) NULL,
	[ProcessedON] [datetime] NULL,
	[QntyDelivered] [int] NULL,
	[IsReplenishment] [bit] NULL,
	[IsNewItem] [bit] NULL,
	[CSLConnectCodePrefix] [nvarchar](80) NULL,
 CONSTRAINT [PK_OrderItems] PRIMARY KEY CLUSTERED 
(
	[OrderItemId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IDX_NC_CategoryID] ON [dbo].[OrderItems] 
(
	[CategoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_NC_CodePrefix] ON [dbo].[OrderItems] 
(
	[CSLConnectCodePrefix] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_NC_OrderItemStatusID] ON [dbo].[OrderItems] 
(
	[OrderItemStatusId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [OrderId] ON [dbo].[OrderItems] 
(
	[OrderId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderItemDetails]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OrderItemDetails](
	[OrderItemDetailId] [int] IDENTITY(1,1) NOT NULL,
	[OrderItemId] [int] NOT NULL,
	[GPRSNo] [nvarchar](50) NULL,
	[PSTNNo] [nvarchar](50) NULL,
	[GSMNo] [nvarchar](50) NULL,
	[LANNo] [nvarchar](50) NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](256) NOT NULL,
	[GPRSNoPostCode] [nvarchar](50) NULL,
	[ICCID] [nvarchar](256) NULL,
	[DataNo] [nvarchar](256) NULL,
	[PrServerDetails] [nvarchar](200) NULL,
	[IsBosInserted] [bit] NULL,
	[IsPendingFileCreated] [bit] NULL,
	[FileName] [varchar](200) NULL,
	[OptionId] [int] NULL,
	[Quantity] [int] NULL,
	[IsDlvNoteGenerated] [bit] NULL,
	[ItemDlvNoteNo] [varchar](250) NULL,
	[Isprocessed] [bit] NULL,
	[ProcessAttempts] [int] NULL,
	[LastProcessedTime] [datetime] NULL,
	[PendingFileErrorMessage] [varchar](max) NULL,
	[BOSErrorMessage] [varchar](max) NULL,
	[isBillingInserted] [bit] NOT NULL,
	[ReplacementProduct] [bit] NULL,
	[SiteName] [nvarchar](256) NULL,
	[IsFOC] [bit] NULL,
	[IsReplacement] [bit] NULL,
	[RatePlanUpdatedonAPI] [bit] NULL,
 CONSTRAINT [PK_OrderItemDetails] PRIMARY KEY CLUSTERED 
(
	[OrderItemDetailId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IDX_NC_ICCID] ON [dbo].[OrderItemDetails] 
(
	[ICCID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_NC_OptionID] ON [dbo].[OrderItemDetails] 
(
	[OptionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_NC_OrderItemID] ON [dbo].[OrderItemDetails] 
(
	[OrderItemId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ARC]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ARC](
	[ARCId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [nvarchar](256) NOT NULL,
	[ARC_Code] [nvarchar](50) NOT NULL,
	[PrimaryContact] [nvarchar](256) NULL,
	[ARC_Email] [nvarchar](256) NOT NULL,
	[Telephone] [nvarchar](50) NULL,
	[Fax] [nvarchar](50) NULL,
	[AddressOne] [nvarchar](256) NULL,
	[AddressTwo] [nvarchar](256) NULL,
	[Town] [nvarchar](256) NULL,
	[PostCode] [nvarchar](10) NULL,
	[County] [nvarchar](256) NULL,
	[Country] [nvarchar](50) NULL,
	[BillingAccountNo] [nvarchar](256) NULL,
	[AnnualBilling] [bit] NOT NULL,
	[AllowReturns] [bit] NOT NULL,
	[PostingOption] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsBulkUploadAllowed] [bit] NOT NULL,
	[IsAPIAccess] [bit] NULL,
	[SalesLedgerNo] [nvarchar](50) NULL,
	[ProductOptionId] [int] NULL,
	[ARC_CCEmail] [nvarchar](256) NULL,
	[PolltoEIRE] [bit] NULL,
	[UNiqueCode] [nvarchar](256) NULL,
	[ArcTypeId] [int] NULL,
	[Description] [nvarchar](256) NULL,
	[LogisticsDescription] [nvarchar](512) NULL,
	[ExcludeTerms] [bit] NULL,
	[CountryCode] [varchar](10) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedOn] [datetime] NULL,
	[IsAllowedCSD] [bit] NULL,
	[EnablePostCodeSearch] [bit] NOT NULL,
	[LocktoDefaultOption] [bit] NOT NULL,
	[SafelinkbyIPSec] [bit] NOT NULL,
	[IsVoiceSMSVisible] [bit] NOT NULL,
	[ReplenishmentLimit] [int] NULL,
	[RuleID] [int] NULL,
 CONSTRAINT [PK_ARC] PRIMARY KEY CLUSTERED 
(
	[ARCId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [AK_UNiqueCode] UNIQUE NONCLUSTERED 
(
	[UNiqueCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ApplicationSetting]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ApplicationSetting](
	[AppId] [int] IDENTITY(1,1) NOT NULL,
	[KeyName] [varchar](100) NULL,
	[KeyValue] [nvarchar](200) NULL,
 CONSTRAINT [PK_ApplicationSetting] PRIMARY KEY CLUSTERED 
(
	[AppId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[CreateDlvOffer]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateDlvOffer]
	@dlvofferid INT,
	@dlvtypeid INT,
	@orderval DECIMAL(8, 2) = 0,
	@arcid INT,
	@proid INT,
	@user VARCHAR(256),
	@minqty INT,
	@maxqty INT,
	@InstallerCompanyID UNIQUEIDENTIFIER,
	@ExpiryDate DATETIME
AS
BEGIN TRY
    BEGIN
        IF (@dlvofferid != 0)
        BEGIN
            UPDATE DeliveryOffers
            SET    DeliveryTypeId = @dlvtypeid,
                   OrderValue = @orderval,
                   ARCId = @arcid,
                   ProductId = @proid,
                   MinQty = @minqty,
                   MaxQty = @maxqty,
                   ModifiedBy = @user,
                   ModifiedOn = GETDATE(),
                   InstallerCompanyID=@InstallerCompanyID,
                   ExpiryDate = @ExpiryDate
            WHERE  DeliveryOfferId = @dlvofferid
            
            ;
            
            SELECT @dlvofferid AS [DeliveryOfferId];
        END
        ELSE
        BEGIN
            INSERT INTO DeliveryOffers
              (
                DeliveryTypeId,
                MaxQty,
                MinQty,
                OrderValue,
                ProductId,
                ARCId,
                CreatedBy,
                CreatedOn,
                InstallerCompanyID,
                ExpiryDate
              )
            VALUES
              (
                @dlvtypeid,
                @maxqty,
                @minqty,
                @orderval,
                @proid,
                @arcid,
                @user,
                GETDATE(),
                @InstallerCompanyID,
                @ExpiryDate
              );
            
            SELECT CAST(SCOPE_IDENTITY() AS INT) AS [DeliveryOfferId];
        END
    END
END TRY 
BEGIN CATCH
    EXEC USP_SaveSPErrorDetails
    RETURN -1
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[CreateDelivery]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateDelivery]
@dlvtypeid int,
@dlvcode varchar(255),
@dlvname varchar(256),
@dlvdesc text,
@user varchar(256),
@price decimal(8,2),
@countryCode varchar(10)='UK'

As

BEGIN TRY 
	BEGIN
	IF Exists (select DeliveryTypeId From DeliveryType Where DeliveryCode = @dlvcode And 
				DeliveryTypeId != @dlvtypeid and IsDeleted = 0)
		BEGIN
			Select 0 as [DeliveryTypeId];		
		END
	ELSE
	BEGIN
		if (@dlvtypeid != 0)
		begin
		   update DeliveryType set DeliveryCode=@dlvcode,DeliveryCompanyName =@dlvname ,DeliveryShortDesc =@dlvdesc,IsDeleted =0,
		   ModifiedBy = @user ,ModifiedOn =GETDATE(),DeliveryPrice=@price,CountryCode = @countryCode
		   where DeliveryTypeId =@dlvtypeid ;
		   	   
		   Select @dlvtypeid as [DeliveryTypeId];
		   
		end
		else
		   begin
		   insert into DeliveryType(DeliveryCode,DeliveryShortDesc,DeliveryCompanyName,CreatedBy,CreatedOn,DeliveryPrice,
		   ModifiedBy,IsDeleted,CountryCode)
		   values(@dlvcode, @dlvdesc , @dlvname, @user ,GETDATE(),@price,@user,0,@countryCode);

			Select Cast(SCOPE_IDENTITY() as int) as [DeliveryTypeId];
			end
		end
	END
END TRY 

BEGIN CATCH
	EXEC USP_SaveSPErrorDetails
	RETURN -1 
END CATCH



/*
ALTER PROCEDURE [dbo].[CreateDelivery]
@dlvtypeid int,
@dlvcode varchar(255),
@dlvname varchar(256),
@dlvdesc text,
@user varchar(256),
@price decimal(8,2)

As

BEGIN TRY 
BEGIN
IF Exists (select DeliveryTypeId From DeliveryType Where DeliveryCode = @dlvcode And DeliveryTypeId != @dlvtypeid and IsDeleted = 0)
	BEGIN
		Select 0 as [DeliveryTypeId];		
	END
ELSE
BEGIN
	if (@dlvtypeid != 0)
	begin
	   update DeliveryType set DeliveryCode=@dlvcode,DeliveryCompanyName =@dlvname ,DeliveryShortDesc =@dlvdesc,IsDeleted =0,ModifiedBy = @user ,ModifiedOn =GETDATE(),DeliveryPrice=@price 
	   where DeliveryTypeId =@dlvtypeid ;
	   	   
	   Select @dlvtypeid as [DeliveryTypeId];
	   
	end
	else
	   begin
	   insert into DeliveryType(DeliveryCode,DeliveryShortDesc,DeliveryCompanyName,CreatedBy,CreatedOn,DeliveryPrice,ModifiedBy,IsDeleted)
	   values(@dlvcode, @dlvdesc , @dlvname, @user ,GETDATE(),@price,@user,0);

		Select Cast(SCOPE_IDENTITY() as int) as [DeliveryTypeId];
		end
	end
END
END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1 
END CATCH
*/
GO
/****** Object:  StoredProcedure [dbo].[CreateCategory]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateCategory]
	@ctgid INT,
	@ctgcode VARCHAR(255),
	@ctgname VARCHAR(256),
	@ctgdesc TEXT,
	@defaultimg VARCHAR(512),
	@largeimg VARCHAR(512),
	@user VARCHAR(256),
	@IsGprschipEmpty BIT,
	@listorder INT,
	@isDeleted BIT =0,
	@salesType VARCHAR(256)
AS
BEGIN TRY
    BEGIN
        IF EXISTS (
               SELECT CategoryId
               FROM   Category
               WHERE  CategoryCode = @ctgcode
                      AND CategoryId != @ctgid
           )
        BEGIN
            SELECT 0 AS [CategoryId];
        END
        ELSE
        BEGIN
            IF (@ctgid != 0)
            BEGIN
                UPDATE Category
                SET    CategoryCode = @ctgcode,
                       CategoryName = @ctgname,
                       CategoryDesc = @ctgdesc,
                       DefaultImage = @defaultimg,
                       LargeImage = @largeimg,
                       ModifiedBy = @user,
                       ModifiedOn = GETDATE(),
                       SeoUrl = @ctgname,
                       IsGPRSChipEmpty = @IsGprschipEmpty,
                       ListOrder = @listorder,
                       IsDeleted = @isDeleted,
					   SalesType = @salesType
                WHERE  CategoryId = @ctgid
                
                ;
                
                DELETE 
                FROM   Category_Product_Map
                WHERE  CategoryId = @ctgid
                
                ;
                DELETE 
                FROM   ARC_Category_Map
                WHERE  CategoryId = @ctgid
                
                ;
                
                SELECT @ctgid AS [CategoryId];
            END
            ELSE
            BEGIN
                INSERT INTO Category
                  (
                    CategoryCode,
                    CategoryDesc,
                    CategoryName,
                    CreatedBy,
                    CreatedOn,
                    DefaultImage,
                    LargeImage,
                    ModifiedBy,
                    IsDeleted,
                    ListOrder,
                    SeoUrl,
                    IsGPRSChipEmpty,
					SalesType
                  )
                VALUES
                  (
                    @ctgcode,
                    @ctgdesc,
                    @ctgname,
                    @user,
                    GETDATE(),
                    @defaultimg,
                    @largeimg,
                    @user,
                    @isDeleted,
                    @listorder,
                    @ctgname,
                    @IsGprschipEmpty,
					@salesType
                  );
                
                SELECT CAST(SCOPE_IDENTITY() AS INT) AS [CategoryId];
            END
        END
    END
END TRY

BEGIN CATCH
    EXEC USP_SaveSPErrorDetails
    RETURN -1
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_SaveARCProductPrice]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_SaveARCProductPrice]

@ARC_Id INT=null,
@ProductId INT=null,
@ARCPrice DECIMAL(6,2)=null,
@ExpiryDate DATETIME=null,
@UserId NVARCHAR(200)=null
As
BEGIN TRY

IF NOT EXISTS (SELECT 1 FROM ARC_Product_Price_Map where ARCId=@ARC_Id AND ProductId=@ProductId AND Price = @ARCPrice AND CONVERT(varchar(10),ExpiryDate,102)=CONVERT(varchar(10), @ExpiryDate,102) and IsDeleted=0   ) --- check ARC price exists or not, if yes then upate price otherwise insert
BEGIN 
    
      -- Delete exists product price 
      UPDATE ARC_Product_Price_Map
      SET  IsDeleted=1,
           CreatedBy=@UserId,
           CreatedOn=GETDATE()     
       WHERE ARCId=@ARC_Id AND ProductId=@ProductId  
    
    -- Insert new price 
     INSERT INTO ARC_Product_Price_Map(ARCId,ProductId,Price,ExpiryDate,IsDeleted,CreatedBy,CreatedOn) VALUES(@ARC_Id,@ProductId,@ARCPrice,@ExpiryDate,0,@UserId,GETDATE() )   
        
END


RETURN 0
END TRY  

   
BEGIN CATCH 
 exec USP_SaveSPErrorDetails  
RETURN -1
End CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetInstallerNameByInstallerId]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetInstallerNameByInstallerId]
(
	@InstallerId NVarchar(256)
)
AS
BEGIN TRY 
BEGIN
	Select (Inst.CompanyName + ' [ ' + InstAdd.Town + ', ' + InstAdd.PostCode + ' ]') as CompanyName
	From Installer as Inst
	Inner Join
	InstallerAddress as InstAdd on Inst.AddressID = InstAdd.AddressID And Inst.InstallerCompanyID = @InstallerId
END
END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetInstallerAddressByInstallerId]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetInstallerAddressByInstallerId]
(
	@InstallerId NVarchar(256)
)
AS
BEGIN TRY 
BEGIN
	Select InstAdd.*,2 as CountryId, Inst.CompanyName
	From 
	InstallerAddress as InstAdd
	Inner Join
	Installer as Inst on Inst.AddressID = InstAdd.AddressID And Inst.InstallerCompanyID = @InstallerId
END
END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_CreatePriceBands]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_CreatePriceBands]

@BandName NVARCHAR(1)=null,
@ProductId INT=null,
@CurrencyId INT=null,
@Price DECIMAL(6,2)=null,
@AnnualPrice DECIMAL(6,2)=null,
@UserId NVARCHAR(200)=null
As
BEGIN TRY

DECLARE @BandNameId int
IF NOT EXISTS (
select 1 from PriceBand pb
join BandNameMaster bnm on pb.BandNameID = bnm.ID
where BandName = @BandName AND CurrencyId = @CurrencyId)
BEGIN 
	IF NOT EXISTS (
	select 1 from BandNameMaster where BandName = @BandName)
	BEGIN
		INSERT INTO BandNameMaster([BandName]) VALUES(@BandName)   
		INSERT INTO PriceBand([BandNameId],[ProductId],[CurrencyID],[Price],[AnnualPrice]) VALUES((select @@IDENTITY),@ProductId,@CurrencyId,@Price,@AnnualPrice)
	END
	ELSE
	BEGIN
		select @BandNameId = ID from BandNameMaster where BandName = @BandName
		INSERT INTO PriceBand([BandNameId],[ProductId],[CurrencyID],[Price],[AnnualPrice]) VALUES(@BandNameId,@ProductId,@CurrencyId,@Price,@AnnualPrice)
	END
END
ELSE
BEGIN
	select @BandNameId = bnm.Id from PriceBand pb
	join BandNameMaster bnm on pb.BandNameID = bnm.ID 
	where BandName = @BandName AND CurrencyId = @CurrencyId
	IF EXISTS (
	select 1 from PriceBand where BandNameId = @BandNameId AND ProductId = @ProductId AND CurrencyId = @CurrencyId)
	BEGIN 
      UPDATE PriceBand
      SET [Price] = @Price
      ,[AnnualPrice] = @AnnualPrice
       WHERE BandNameId=@BandNameId AND ProductId=@ProductId AND CurrencyId = @CurrencyId
	END
	ELSE
	BEGIN 
		INSERT INTO PriceBand([BandNameId],[ProductId],[CurrencyID],[Price],[AnnualPrice]) VALUES(@BandNameId,@ProductId,@CurrencyId,@Price,@AnnualPrice)	
	END
END

RETURN 0
END TRY  

   
BEGIN CATCH 
 exec USP_SaveSPErrorDetails  
RETURN -1
End CATCH
GO
/****** Object:  Table [dbo].[Products]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[ProductCode] [nvarchar](20) NOT NULL,
	[ProductName] [nvarchar](512) NOT NULL,
	[ProductDesc] [nvarchar](max) NULL,
	[Price] [decimal](6, 2) NOT NULL,
	[ListOrder] [int] NOT NULL,
	[DefaultImage] [nvarchar](256) NULL,
	[LargeImage] [nvarchar](256) NULL,
	[IsDeleted] [bit] NOT NULL,
	[ProductType] [nvarchar](10) NOT NULL,
	[IsDependentProduct] [bit] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](256) NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[SeoUrl] [nvarchar](512) NULL,
	[IsCSD] [bit] NULL,
	[Message] [nvarchar](256) NULL,
	[CSL_Grade] [nvarchar](50) NULL,
	[IsSiteName] [bit] NULL,
	[IsReplenishment] [bit] NULL,
	[CSLDescription] [text] NULL,
	[AnnualPrice] [decimal](10, 2) NULL,
	[ListedonCSLConnect] [bit] NOT NULL,
	[CSLConnectVoice] [bit] NOT NULL,
	[CSLConnectSMS] [bit] NOT NULL,
	[Allowance] [float] NULL,
	[IsHardwareType] [bit] NOT NULL,
	[IsOEMProduct] [bit] NOT NULL,
	[IsVoiceSMSVisible] [bit] NOT NULL,
	[IsDeferredPaymentAllowed] [bit] NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_NC_ProductCode] ON [dbo].[Products] 
(
	[ProductCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[GetInstallersByNameOrPostCode]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetInstallersByNameOrPostCode]
	-- Add the parameters for the stored procedure here
	@installerName nvarchar(50),
	@postCode nvarchar(50),
	@ARCID int = 1 
AS
BEGIN TRY 
BEGIN 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;


IF @postCode = ''
BEGIN
	SELECT TOP 10 [InstallerCompanyID],[CompanyName],[Accreditation],[UniqueCode],[AddressOne],[AddressTwo],[Town],[County],[PostCode],coalesce([Country],'') [Country]
FROM 
	(
		SELECT CNTR=1,[Installer].[InstallerCompanyID],[Installer].[CompanyName],[Installer].[Accreditation],[Installer].[UniqueCode]
		,[InstallerAddress].[AddressOne],[InstallerAddress].[AddressTwo],[InstallerAddress].[Town],[InstallerAddress].[County]
		,[InstallerAddress].[PostCode],[InstallerAddress].[Country]
		FROM [Installer] inner join [InstallerAddress] ON Installer.AddressID = InstallerAddress.AddressID 
		WHERE IsActive = 1 AND CompanyName like @installerName+'%'
	) AS inst
	 ORDER BY CNTR,CompanyName
END
ELSE
BEGIN
	SELECT TOP 10 [InstallerCompanyID],[CompanyName],[Accreditation],[UniqueCode],[AddressOne],[AddressTwo],[Town],[County],[PostCode],coalesce([Country],'') [Country]
FROM 
	(
		SELECT CNTR = 2,[Installer].[InstallerCompanyID],[Installer].[CompanyName],[Installer].[Accreditation],[Installer].[UniqueCode]
		,[InstallerAddress].[AddressOne],[InstallerAddress].[AddressTwo],[InstallerAddress].[Town],[InstallerAddress].[County]
		,[InstallerAddress].[PostCode],[InstallerAddress].[Country]
		FROM [Installer] inner join [InstallerAddress] ON Installer.AddressID = InstallerAddress.AddressID 
		where IsActive = 1 AND dbo.Trim(PostCode) like dbo.Trim(@postCode)+'%'
	) AS inst
	ORDER BY CNTR,CompanyName
	END



  
  
END
END TRY
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetInstallersByNameCode]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetInstallersByNameCode]
	-- Add the parameters for the stored procedure here
	@installerName nvarchar(50),
	@installerCode nvarchar(50),
	@ARCID int = 1 
AS
BEGIN TRY 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 50 [InstallerCompanyID],[CompanyName],[PostCode], [Town],[UniqueCode]
  FROM 
  (
  SELECT CNTR=1,[Installer].[InstallerCompanyID],[Installer].[CompanyName],[InstallerAddress].[PostCode], [InstallerAddress].[Town],[Installer].[UniqueCode]
  FROM [Installer] inner join [InstallerAddress] ON Installer.AddressID = InstallerAddress.AddressID 
  WHERE IsActive = 1 AND CompanyName like @installerName+'%'
  UNION 
 SELECT CNTR = 2,[Installer].[InstallerCompanyID],[Installer].[CompanyName],[InstallerAddress].[PostCode], [InstallerAddress].[Town],[Installer].[UniqueCode]
  FROM [Installer] inner join [InstallerAddress] ON Installer.AddressID = InstallerAddress.AddressID 
   where IsActive = 1 AND dbo.Trim(PostCode) like dbo.Trim(@installerName)+'%' AND CompanyName not like @installerName+'%'
  ) AS Z
   ORDER BY CNTR,CompanyName

  
  
END
END TRY
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH


--[GetInstallersByNameCode] 'J' ,'J'
GO
/****** Object:  StoredProcedure [dbo].[USP_SaveInstallerAddress]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SaveInstallerAddress]      
    
     
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
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertUpdateAuditM2M]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Created by:Atiq
-- Created Date:19-05-2015
-- Purpose of this stored procedure to maintain the audit for m2m when login and logout
-- =============================================
CREATE PROCEDURE [dbo].[USP_InsertUpdateAuditM2M]
@UserId nvarchar(500),
@CompanyId nvarchar(500),
@AuditId INT
AS

BEGIN TRY
BEGIN
	IF(@AuditId=0)
	BEGIN
	     Insert INTO AuditM2M(Userid,CompanyId,LoginDate)VALUES(@UserId,@CompanyId,GetDate())
	     SELECT Convert(INT,Scope_Identity()) AS Success
	END
	Else 
	BEGIN
	     Update AuditM2M SET LogoutDate=GetDate() where AuditId=@AuditId;
	     SELECT 0 AS Success
	END
END
END TRY

BEGIN CATCH
EXEC USP_SaveSPErrorDetails     
RETURN -1 
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertAddress]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_InsertAddress] 

(

 	@CompanyName    NVARCHAR(256),

    @ContactName    NVARCHAR(256),

    @ContactNumber  NVARCHAR(256),
	
    @Email          NVARCHAR(256),

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

	      DECLARE @AddressId INT

        -- insert address

            INSERT INTO ADDRESS

              (

			  CompanyName,

                ContactName,

                AddressOne,

                AddressTwo,

                Town,

                County,

                PostCode,

                Mobile,

				Email,

                Country,

                CountryId,

                CreatedBy,

                CreatedOn,

                ModifiedBy,

                ModifiedOn

              )

            VALUES

              (

			    @CompanyName,

                @ContactName,

                @AddressOne,

                @AddressTwo,

                @Town,

                @County,

                @PostCode,

                @ContactNumber,

				@Email,

                @Country,

                @CountryId,

                @CreatedBy,

                GETDATE(),

                @CreatedBy,

                GETDATE()

              )  

            

            SELECT @AddressId=CAST(SCOPE_IDENTITY() AS INT)  

        


		SELECT @AddressId AS AddressId

    END

END TRY   

BEGIN CATCH

    EXEC USP_SaveSPErrorDetails 

    RETURN -1

END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_SyncInstallerShopCompanyUsersToArcOrdering]    Script Date: 12/14/2015 17:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
CreatedBy: ShyamGaddam
CreatedOn: 03/10/2014
Purpose: To sync the installer shop users to arc ordering users map table
*/

CREATE Procedure [dbo].[USP_SyncInstallerShopCompanyUsersToArcOrdering]
as begin

begin try

exec [USP_SyncInstallerUserAddressToArcOrdering]
Merge Arc_Ordering.dbo.[Installer_User_Map] as AOIUP
using
(

select  a.InstallerCompanyID ,a.UserID,C.UserName,a.AddressID  InstallerUserAddressID  from CSLOrdering.dbo.Engineer  a inner join CSLOrdering.dbo.InstallerCompany  b on a.InstallerCompanyID= b.InstallerCompanyID 
inner join CSLOrdering.dbo.aspnet_Users C on a.UserID = c.UserID where a.IsDeleted = 0
) ISIUP
on AOIUP.UserID = ISIUP.UserID and AOIUP.InstallerCompanyID = ISIUP.InstallerCompanyID and AOIUP.InstallerUserAddressID = ISIUP.InstallerUserAddressID
when matched then

update
set 

AOIUP.InstallerCompanyID=ISIUP.InstallerCompanyID,
AOIUP.UserName=ISIUP.UserName,
AOIUP.InstallerUserAddressID=ISIUP.InstallerUserAddressID

when not matched then

insert
(InstallerCompanyID,
UserID,
UserName,
InstallerUserAddressID)
values
(
ISIUP.InstallerCompanyID,
ISIUP.UserID,
ISIUP.UserName,
ISIUP.InstallerUserAddressID
);

end try

begin catch

return error_message()
end catch

end
GO
/****** Object:  StoredProcedure [dbo].[USP_SaveMySMS]    Script Date: 12/14/2015 17:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SaveMySMS] 
	@text nvarchar(500),
	@iccid nvarchar(500)
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @DeviceID INT
-- get deviceId
			SELECT TOP 1 @DeviceID= ID FROM Device_API WHERE DEV_CODE=@iccid

			INSERT INTO DeviceSMS(DeviceID,Text,DateAdded,MessageTypeId,Isprocessed)
			VALUES(@DeviceID,@text,GETDATE(),1,0)

			Declare @returnvalue INT 
			select @returnvalue = cast(SCOPE_IDENTITY() as int)

			Select @returnvalue as DeviceSMSID
END TRY 



BEGIN CATCH
    EXEC USP_SaveSPErrorDetails 
	RETURN -1 
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_SaveM2MCompany]    Script Date: 12/14/2015 17:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
	-- Author:		<Author,,Name>
	-- Create date: <Create Date,,>
	-- Description:	<Description,,>
	-- =============================================
CREATE PROCEDURE [dbo].[USP_SaveM2MCompany]	
	-- Add the parameters for the stored procedure here
		@CompanyName nvarchar(256)='',
		@ContactName nvarchar(256)='',
		@Email nvarchar(256)='',
		@Mobile nvarchar(50)='',
		@AddressOne nvarchar(100)='',
		@AddressTwo nvarchar(100)='',
		@Town nvarchar(100)='',
		@County nvarchar(100)='',
		@PostCode nvarchar(50)='',
		@Country nvarchar(256)='',
		@CountryId int
	 

	AS
	BEGIN
	declare @AddressId int

		BEGIN TRY
			BEGIN
			IF NOT EXISTS ( SELECT 1 FROM M2MCompany m inner join Address a on m.AddressId=a.AddressID WHERE m.CompanyName =@CompanyName and a.PostCode=@PostCode )
				BEGIN
			 	-- Creat address
				INSERT INTO Address (CompanyName,ContactName,Email,Mobile,AddressOne,AddressTwo,Town,County,PostCode,Country,CountryId)
				VALUES(@CompanyName,@ContactName,@Email,@Mobile,@AddressOne,@AddressTwo,@Town,@County,@PostCode,@Country,@CountryId)

				 

				-- Create new M2MCompany
		 
				INSERT INTO  M2MCompany(CompanyName,AddressId,IsCreditAllowed) VALUES(@CompanyName,CAST(SCOPE_IDENTITY() AS INT),0) 
			
			     SELECT CAST(SCOPE_IDENTITY() AS INT) AS id-- get new Company Id
					
				END
			ELSE 
			  BEGIN
	     
			     SELECT 0 AS id
			     
			   END
			END
		END TRY
		BEGIN CATCH
			EXEC USP_SaveSPErrorDetails 
			 SELECT -1 AS id
		END CATCH
    
	END
GO
/****** Object:  View [dbo].[vw_M2MInstallerProducts]    Script Date: 12/14/2015 17:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view  [dbo].[vw_M2MInstallerProducts]
as 
select ProductCode, ProductName,CompanyName as Installer, UniqueCode,IsOEMProduct as [OEM?] 
,P.IsVoiceSMSVisible as Product_VoiceSMSAllowed  
,I.IsVoiceSMSVisible as Installer_VoiceSMSAllowed  
 from dbo.Product_Installer_Map PIM inner join Products P on PIM.ProductId = P.ProductId 
inner join Installer I on PIM.InstallerId = I.InstallerCompanyID
where ListedonCSLConnect  = 1
GO
/****** Object:  View [dbo].[vw_ProductTagList]    Script Date: 12/14/2015 17:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ProductTagList] 

AS
 
	 SELECT pt.Product_Tag_MapId,t.Name, ISNULL(t2.Name,'')  ParentTag ,p.ProductName,p.ProductCode,p.ProductDesc,p.Allowance
	 FROM Product_Tag_Map  pt
		 INNER JOIN Products p on pt.ProductId=p.ProductId 
		 INNER JOIN Tags t on pt.TagsId =t.TagsId
		 LEFT  JOIN  tags t2 on t.ParentId=t2.TagsId
GO
/****** Object:  View [dbo].[VW_OrdersIN_SALESTEAM]    Script Date: 12/14/2015 17:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_OrdersIN_SALESTEAM] AS   
  

SELECT    dbo.Orders.SalesReply AS SalesRep,dbo.Installer.CompanyName AS InstallerName,
dbo.Installer.InstallerCode,
dbo.Installer.UniqueCode,  dbo.ARC.CompanyName as CompanyName,ARC.ARC_Code, REPLACE( ProductName ,'<br/>',' ') as ProductName   
, ProductCode,GPRSNo as ChipNo,ISNULL(ICCID,'') as ICCID,ISNULL(DataNo,'') as DataNo,  
ISNULL(DeliveryNoteNo ,'') AS DeliveryNoteNo ,  
convert(varchar(256),OrderDate,103) as OrderDate,  
convert(varchar(256), Orders.ProcessedOn ,103) DespatchDate,  
OrderNo,dbo.Orders.OrderRefNo AS [ARC Ref],
ISNULL((SELECT     ISNULL(MasterGrade  ,'') FROM          dbo.GradeMap2Master  WHERE      (BOSGrade IN  (SELECT     TOP (1) Dev_Grade  FROM          dbo.Device_Grade  
WHERE      (Product_Code LIKE '%' + dbo.Products.ProductCode + '%')   ))) ,'')
AS Grade,
ISNULL((SELECT     TOP (1) ISNULL(Dev_Grade  ,'') FROM dbo.Device_Grade AS Device_Grade_1  
WHERE      (Product_Code LIKE '%' + dbo.Products.ProductCode + '%') AND (Dev_PS_Code = dbo.OrderItemDetails.PrServerDetails)),'') AS BOS_Grade,
ISNULL(Device_API.Dev_IP_Address ,'') as IPAdd,Orders.ProcessedOn   
,CategoryName AS Category,OrderDate as dtOrderDate ,isnull(IsFOC,0) AS FOC,ISNULL(IsReplacement,0) AS REPLACEMENT,ISNULL(OrderItems.IsCSD,0) AS CSD
FROM         dbo.Device_API RIGHT OUTER JOIN  
                      dbo.OrderItemDetails ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID RIGHT OUTER JOIN  
                      dbo.Orders INNER JOIN  
                      dbo.OrderItems ON dbo.Orders.OrderId = dbo.OrderItems.OrderId INNER JOIN  
                      dbo.Products ON dbo.OrderItems.ProductId = dbo.Products.ProductId ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId LEFT OUTER JOIN  
                      dbo.ARC ON dbo.Orders.ARC_CODE = dbo.ARC.ARC_CODE LEFT OUTER JOIN  
                      dbo.Installer ON dbo.Orders.InstallerId = dbo.Installer.InstallerCompanyID  LEft Join 
                      Category On OrderItems.CategoryID = category.categoryID   
WHERE   
 DATEPART(year,OrderDate) = DATEPART(year,getdate())  
 and   
 DATEPART(month,OrderDate) = (DATEPART(month,getdate()))   
AND 
  (dbo.Products.IsDependentProduct = 0) AND (dbo.OrderItems.OrderItemStatusId not in (13,17)) AND (dbo.OrderItems.IsCSD = 0)  
AND OrderStatusid not in (1,7,13) --Initialised,Cancelled,Deleted,Marked for Delete,Marked for Complete  
and Products.ProductCode in (select ProductCode from Products where  ProductType = 'Product'  and IsDependentProduct = 0)  
  
  
  
  
  /* UPDATE ON 07 MARCH 2014
select VD.SalesRep,InstallerName,Vd.InstallerCode,vd.UniqueCode,VD.CompanyName,ARC_Code,  
REPLACE( ProductName ,'<br/>',' ') as ProductName   
, ProductCode,GPRSNo as ChipNo,ISNULL(ICCID,'') as ICCID,ISNULL(DataNo,'') as DataNo,  
DeliveryNoteNo,  
convert(varchar(256),OrderDate,103) as OrderDate,  
convert(varchar(256), Processedon ,103) DespatchDate,  
OrderNo,[ARC Ref],ISNULL(Grade,'') as Grade,  
ISNULL(BOS_Grade,'')as BOS_Grade,ISNULL(IPAddress,'') as IPAdd,Processedon  
,CategoryName AS Category,OrderDate as dtOrderDate  
from dbo.vw_OrdersIn VD --inner join Category_Product_Map CPM on VD.productid = CPM.ProductId inner join Category C on CPM.CategoryId = C.CategoryId  
LEft Join Category On Vd.CategoryID = category.categoryID   
where   
 DATEPART(year,OrderDate) = DATEPART(year,getdate())  
 and   
 DATEPART(month,OrderDate) = (DATEPART(month,getdate()))   
AND OrderStatusid not in (1,7,13,17,18) --Initialised,Cancelled,Deleted,Marked for Delete,Marked for Complete  
and VD.ProductCode in (select ProductCode from Products where  ProductType = 'Product'  and IsDependentProduct = 0)  
  */
GO
/****** Object:  View [dbo].[vw_OrdersIn]    Script Date: 12/14/2015 17:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_OrdersIn]
AS
SELECT     dbo.Orders.DeliveryNoteNo, dbo.OrderItemDetails.ItemDlvNoteNo, dbo.Orders.SalesReply AS SalesRep, dbo.ARC.CompanyName, dbo.ARC.ARC_Code, 
                      dbo.Products.ProductCode, dbo.OrderItemDetails.GPRSNo, dbo.OrderItemDetails.ICCID, dbo.OrderItemDetails.DataNo, dbo.Device_API.Dev_IP_Address AS IPAddress, 
                      dbo.Installer.InstallerCode, dbo.Installer.UniqueCode, dbo.Orders.OrderDate,
                          (SELECT     TOP 1 MasterGrade
                            FROM          dbo.GradeMap2Master
                            WHERE      (BOSGrade IN
                                                       (SELECT     TOP 1 Dev_Grade
                                                         FROM          dbo.Device_Grade
                                                         WHERE      (Product_Code LIKE '%' + dbo.Products.ProductCode + '%') AND (Dev_PS_Code = dbo.OrderItemDetails.PrServerDetails)))) AS Grade, 
                      dbo.Orders.OrderNo, dbo.Orders.OrderRefNo AS [ARC Ref],
                          (SELECT     TOP 1 Dev_Grade
                            FROM          dbo.Device_Grade AS Device_Grade_1
                            WHERE      (Product_Code LIKE '%' + dbo.Products.ProductCode + '%') AND (Dev_PS_Code = dbo.OrderItemDetails.PrServerDetails)) AS BOS_Grade, 
                      dbo.Orders.ProcessedBy, dbo.Orders.ProcessedOn, dbo.Orders.OrderStatusId, dbo.Device_API.Dev_IMSINumber AS IMSIno, dbo.Products.ProductName, 
                      dbo.Products.IsDependentProduct, dbo.Installer.CompanyName AS InstallerName, dbo.OrderItems.OrderItemStatusId, dbo.Products.ProductId , orderItems.CategoryID
FROM         dbo.Device_API RIGHT OUTER JOIN
                      dbo.OrderItemDetails ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID RIGHT OUTER JOIN
                      dbo.Orders INNER JOIN
                      dbo.OrderItems ON dbo.Orders.OrderId = dbo.OrderItems.OrderId INNER JOIN
                      dbo.Products ON dbo.OrderItems.ProductId = dbo.Products.ProductId ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId LEFT OUTER JOIN
                      dbo.ARC ON dbo.Orders.ARC_CODE = dbo.ARC.ARC_CODE LEFT OUTER JOIN
                      dbo.Installer ON dbo.Orders.InstallerId = dbo.Installer.InstallerCompanyID
WHERE     (dbo.Products.IsDependentProduct = 0) AND (dbo.OrderItems.OrderItemStatusId <> 13) AND (dbo.OrderItems.IsCSD = 0)
AND Orders.OrderStatusId not in (1,7,13,17,18) --Initialised,Cancelled,Deleted,Marked for Delete,Marked for Complete
GO
/****** Object:  View [dbo].[vw_OrderReplaceandCancelreports]    Script Date: 12/14/2015 17:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*    
 View Name  : vw_OrderReplaceandCancelreports    
 Created by : Sivakumar    
 CreatedOn  : 11/06/2015    
 Purpose    : To display Order replacement and Order Cancellation in two different reports.    
     
 */    
     
   CREATE View [dbo].[vw_OrderReplaceandCancelreports]    
   AS    
   SELECT OrderItemDetailId,ORders.OrderID,ICCID,ORDERS.ORDERNO,ORDERS.ORDERREFNO,ORDERS.ORDERDATE,ORDERS.INSTALLERID,ORDERS.USERNAME,ORDERS.INSTALLERUnqCODE,ORDERS.PaymentType,ORDERS.BillingCycleID,ISReplacement        
 FROM Orderitemdetails  with(Nolock)          
 INNER JOIN ORDERITEMS  with(Nolock) on Orderitemdetails.OrderITEMID = ORDERITEMS.OrderITEMID          
 INNER JOIN ORders  with(Nolock) ON ORders.OrderID = ORDERITEMS.OrderID     
 where  Convert(varchar(10),ORDERDATE,112)= Convert(varchar(10),Getdate()-1,112)  and  ICCID is not null
 and ISReplacement=1
GO
/****** Object:  View [dbo].[vw_OrderProducts]    Script Date: 12/14/2015 17:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_OrderProducts]
AS
SELECT  
    [OrderItems].[OrderItemId] AS [OrderItemId], 
    [OrderItems].[OrderId] AS [OrderId], 
    [OrderItems].[ProductId] AS [ProductId], 
    [OrderItems].[ProductQty] AS [ProductQty], 
    ([OrderItems].[Price] + isnull(VoiceProducts.Price,0) + isnull(SMSProducts.Price,0))  AS [Price], 
	[OrderItems].[IsCSD] AS [IsCSD] ,
    [OrderItems].[CategoryId] AS [CategoryId], 
    [Products].[ProductCode] AS [ProductCode], 
    [Products].[ProductName] AS [ProductName], 
    [Products].[ProductDesc] AS [ProductDesc] ,
	VoiceProducts.[ProductCode] AS [VoiceProductCode], 
    VoiceProducts.[ProductName] AS [VoiceProductName], 
	SMSProducts.[ProductCode] AS [SMSProductCode], 
    SMSProducts.[ProductName] AS [SMSProductName],
    [Products].[IsVoiceSMSVisible] AS IsVoiceSMSVisible
    FROM   [dbo].[OrderItems]
    INNER JOIN [dbo].[Products]  ON [OrderItems].[ProductId] = [Products].[ProductId]
	LEFT JOIN OrderDependentItems VoiceItem on [OrderItems].OrderItemId = VoiceItem.OrderItemId AND VoiceItem.ProductID in (SElect ProductID from PRoducts WHERE CSLConnectVoice =1)
	LEFT JOIN [dbo].[Products] VoiceProducts on VoiceItem.ProductID = VoiceProducts.ProductID AND [Products].ListedonCSLConnect =1 
	LEFT JOIN OrderDependentItems SMSItem  on [OrderItems].OrderItemId = SMSItem.OrderItemId AND SMSItem.ProductID in (SElect ProductID from PRoducts WHERE CSLConnectSMS =1)
	LEFT JOIN [dbo].[Products] SMSProducts on SMSItem.ProductID = SMSProducts.ProductID AND [Products].ListedonCSLConnect =1
GO
/****** Object:  View [dbo].[vw_OrderLogRaw]    Script Date: 12/14/2015 17:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_OrderLogRaw]
AS
SELECT     dbo.Orders.DeliveryNoteNo, dbo.OrderItemDetails.ItemDlvNoteNo, dbo.Orders.SalesReply AS SalesRep, dbo.ARC.CompanyName, dbo.ARC.ARC_Code, 
                      dbo.Products.ProductCode, dbo.OrderItemDetails.GPRSNo, dbo.OrderItemDetails.ICCID, dbo.OrderItemDetails.DataNo, dbo.Device_API.Dev_IP_Address AS IPAddress, 
                      dbo.Installer.InstallerCode, dbo.Installer.UniqueCode, dbo.Orders.OrderDate,
                          (SELECT     TOP (1) MasterGrade
                            FROM          dbo.GradeMap2Master
                            WHERE      (BOSGrade IN
                                                       (SELECT     TOP (1) Dev_Grade
                                                         FROM          dbo.Device_Grade
                                                         WHERE      (Product_Code LIKE '%' + dbo.Products.ProductCode + '%') AND (Dev_PS_Code = dbo.OrderItemDetails.PrServerDetails)))) AS Grade, 
                      dbo.Orders.OrderNo, dbo.Orders.OrderRefNo AS [ARC Ref],
                          (SELECT     TOP (1) Dev_Grade
                            FROM          dbo.Device_Grade AS Device_Grade_1
                            WHERE      (Product_Code LIKE '%' + dbo.Products.ProductCode + '%') AND (Dev_PS_Code = dbo.OrderItemDetails.PrServerDetails)) AS BOS_Grade, 
                      dbo.Orders.ProcessedBy, dbo.Orders.ProcessedOn, dbo.Orders.OrderStatusId, dbo.Device_API.Dev_IMSINumber AS IMSIno, dbo.Products.ProductName, 
                      dbo.Products.IsDependentProduct, dbo.Installer.CompanyName AS InstallerName, dbo.OrderItems.OrderItemStatusId, dbo.Products.ProductId , orderItems.CategoryID
FROM         dbo.Device_API RIGHT OUTER JOIN
                      dbo.OrderItemDetails ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID RIGHT OUTER JOIN
                      dbo.Orders INNER JOIN
                      dbo.OrderItems ON dbo.Orders.OrderId = dbo.OrderItems.OrderId INNER JOIN
                      dbo.Products ON dbo.OrderItems.ProductId = dbo.Products.ProductId ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId LEFT OUTER JOIN
                      dbo.ARC ON dbo.Orders.ARC_CODE = dbo.ARC.ARC_CODE LEFT OUTER JOIN
                      dbo.Installer ON dbo.Orders.InstallerId = dbo.Installer.InstallerCompanyID
WHERE     (dbo.OrderItems.OrderItemStatusId <> 13)
GO
/****** Object:  View [dbo].[vw_OrderDetailforEmail]    Script Date: 12/14/2015 17:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Mohd Atiq
-- Create date: 28-Sep-2015
-- Description:	Added one more column SpecialInstructions in select statement 
-- because we are displaying it on order email details
-- =============================================
CREATE VIEW [dbo].[vw_OrderDetailforEmail] 

AS
 
	  SELECT 
	 Orders.OrderID, 
	 ORders.OrderNo , 
	 [Address].CompanyName,
	 [Address].ContactName,
	isnull(nullif([Address].Email,''), Orders.UserEmail) as UserEmail,
	 Orders.UserEmail as UserProfileEmail,
	 Orders.Amount,
	 Orders.DeliveryCost,
	 VATAmount = (Orders.Amount + Orders.DeliveryCost) * Orders.VATRate,
	 Orders.OrderTotalAmount, 
	 DeliveryTYPE.DeliveryShortDesc as 'DeliveryType' , 
	 DeliveryTYPE.DeliveryPrice , 
	[Address].AddressOne , 
	[Address].AddressTwo,
	[Address].Town,
	[Address].County,
	[Address].PostCode,
	[Address].Fax,
	[Address].Mobile,
	[Address].Telephone,
	Curr.CurrencySymbol,
	bc.[Description] As BillingCycle,
	pt.Type AS PaymentType,
	Orders.SpecialInstructions,
	Ins.CompanyName AS InstallerCompanyName,
	Ins.VATNumber,
	Orders.OrderRefNo
	 FROM Orders
	 LEFT JOIN  [Address]  ON ORDERS.DeliveryAddressID = [Address] .ADDRESSID 
	 LEFT JOIN DeliveryTYPE ON ORDERS.DeliveryTYPEID = DeliveryType.DeliveryTypeID
	 LEFT JOIN Currency Curr ON ORDERS.CurrencyId=Curr.CurrencyId	
	 LEFT JOIN BillingCycle bc ON  Orders.BillingCycleId=bc.ID
	 LEFT JOIN PaymentType pt ON  Orders.PaymentType=pt.PaymentTypeId
	 LEFT JOIN dbo.Installer Ins on Orders.InstallerId=Ins.InstallerCompanyID
	 WHERE ORDERTYPE = 2 -- ** Only M2M Connect Orders
GO
/****** Object:  View [dbo].[vw_ICCIDCodes]    Script Date: 12/14/2015 17:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ICCIDCodes]  
AS  
SELECT     dbo.OrderItemDetails.ICCID, dbo.Products.ProductCode, dbo.OrderItemDetails.IsBosInserted, dbo.Orders.OrderNo, dbo.Orders.OrderStatusId,   
                      dbo.OrderItemDetails.GPRSNo ,Orders.ARC_Code 
FROM         dbo.OrderItemDetails INNER JOIN  
                      dbo.OrderItems ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId INNER JOIN  
                      dbo.Products ON dbo.OrderItems.ProductId = dbo.Products.ProductId INNER JOIN  
                      dbo.Orders ON dbo.OrderItems.OrderId = dbo.Orders.OrderId  
WHERE     (dbo.Orders.OrderStatusId IN (10, 14, 15, 16, 19))  and ICCID is not null
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "OrderItemDetails"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 304
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 13
         End
         Begin Table = "OrderItems"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 301
               Right = 465
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Products"
            Begin Extent = 
               Top = 6
               Left = 503
               Bottom = 174
               Right = 691
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Orders"
            Begin Extent = 
               Top = 190
               Left = 518
               Bottom = 309
               Right = 741
            End
            DisplayFlags = 280
            TopColumn = 5
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_ICCIDCodes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_ICCIDCodes'
GO
/****** Object:  View [dbo].[vw_ICCIDAuthCodes]    Script Date: 12/14/2015 17:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ICCIDAuthCodes]    
AS    
 SELECT OrderItemDetailId,ORders.OrderID,ICCID,AuthCode,futurePayId,[PaymentTransaction].Amount,ORDERS.ORDERNO,ORDERS.ORDERREFNO,ORDERS.ORDERDATE,ORDERS.INSTALLERID,ORDERS.USERNAME,ORDERS.INSTALLERUnqCODE,ORDERS.PaymentType,ORDERS.BillingCycleID   
 FROM Orderitemdetails      
 INNER JOIN ORDERITEMS  on Orderitemdetails.OrderITEMID = ORDERITEMS.OrderITEMID    
 INNER JOIN ORders  ON ORders.OrderID = ORDERITEMS.OrderID     
 INNER JOIN [PaymentTransaction] ON [PaymentTransaction].OrderID = ORders.OrderID    
 WHERE [PaymentTransaction].CreatedOn = (Select min(CreatedOn) FROM [PaymentTransaction] X WHERE X.ID = [PaymentTransaction].ID)    
 AND ICCID IS NOT NULL
GO
/****** Object:  View [dbo].[vw_M2MActiveICCIDListV3]    Script Date: 12/14/2015 17:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_M2MActiveICCIDListV3]
AS
	SELECT OrdersCSD.OrderId , ISNULL(OrderitemdetailsCSD.ICCID,OrderitemdetailsCSD.PSTNNO) AS ICCID 
	FROM Orderitemdetails OrderitemdetailsCSD 
	INNER JOIN ORDERITEMS ORDERITEMSCSD on OrderitemdetailsCSD.OrderITEMID = ORDERITEMSCSD.OrderITEMID
	INNER JOIN ORders OrdersCSD ON ORDERITEMSCSD.OrderID = OrdersCSD.OrderID 
	WHERE (ORDERITEMSCSD.ISCSD = 1 OR ORDERITEMSCSD.ISReplenishment = 0  ) 
	AND ORDERSTATUSID not in (1,20) 
	AND ORDERITEMSTATUSID not in (7,13) 
	AND ISNULL(nullif(OrderitemdetailsCSD.ICCID,''),nullif(OrderitemdetailsCSD.PSTNNO,'')) is NOT NULL
GO
/****** Object:  View [dbo].[vw_InstallerPriceBandProducts]    Script Date: 12/14/2015 17:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_InstallerPriceBandProducts]  
AS  
	SELECT 
	I.CompanyName, Y.CurrencyCode AS InstallerCurrencyCode, I.UniqueCode, 
	I.IsActive, I.IsEIRE,I.IsCreditAllowed, I.IsVoiceSMSVisible, 
	I.VATPercentage, K.CurrencyCode, M.BandName,P.ProductCode, 
	P.ProductName, B.Price, B.AnnualPrice 
	from CompanyPriceMap C 
	inner join PriceBand B on C.PriceBandId = B.ID
	inner join Currency K on K.CurrencyID = B.CurrencyID
	inner join Installer I on C.CompanyID = I.InstallerCompanyID
	inner join Products P on B.ProductId = P.ProductId 
	inner join BandNameMaster M on B.BandNameID = M.ID
	left join Currency Y on Y.CurrencyID = I.CurrencyID
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[45] 4[13] 2[25] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "BandNameMaster"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 170
               Right = 207
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Currency"
            Begin Extent = 
               Top = 218
               Left = 658
               Bottom = 372
               Right = 851
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PriceBand"
            Begin Extent = 
               Top = 145
               Left = 428
               Bottom = 306
               Right = 595
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CompanyPriceMap"
            Begin Extent = 
               Top = 27
               Left = 648
               Bottom = 200
               Right = 837
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Installer"
            Begin Extent = 
               Top = 19
               Left = 1108
               Bottom = 346
               Right = 1292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Products"
            Begin Extent = 
               Top = 219
               Left = 48
               Bottom = 338
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Currency_1"
            Begin Extent = 
               Top = 207
               Left = 1330
               Bottom = 326
               Right = 1523
            End
  ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_InstallerPriceBandProducts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'          DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
         Width = 284
         Width = 5205
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2805
         Alias = 1845
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_InstallerPriceBandProducts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_InstallerPriceBandProducts'
GO
/****** Object:  View [dbo].[VW_GetM2MOrderstoProcess]    Script Date: 12/14/2015 17:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_GetM2MOrderstoProcess]     
AS  
Select Orders.OrderID,Orders.OrderNO,OrderItems.OrderItemId,ProductCode,OrderItems.ProductID,ARC_Code,
Orders.ProcessedBy,orderItems.OrderItemStatusID,
Orders.InstallerUnqCode as UniqueCode,
ISNULL(OrderItems.IsCSD,0) AS 'IsCSD', Orders.ARCID ,Orders.UserID,
isnull(Orders.BillingCycleID,0) as BillingCycleID
FROM Orders 
INNER JOIN [OrderItems] on  Orders.OrderID = OrderItems.OrderID
INNER JOIN PRODUCTS on OrderItems.ProductID =  Products.ProductID

WHERE 
--( 
orderItems.OrderItemStatusID in (17,18) 
-- OR (OrderItems.IsCSD =1 AND  orderItems.OrderItemStatusID = 1  ))
AND Orders.OrderStatusID >1
AND Orders.Ordertype = 2
GO
/****** Object:  View [dbo].[VW_GetM2MlistforRatePlan]    Script Date: 12/14/2015 17:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_GetM2MlistforRatePlan]
AS 
 
	SELECT DISTINCT OrderItemDetailID, ICCID,
	CASE 
		WHEN OrderdependentITems.ProductID in (141,151) OR OrderdependentITems.ProductID is null 
			THEN (select NACID FROM [Tele2_Communication] WHERE [IsVoiceIncluded] = 0 )
			ELSE (select NACID FROM [Tele2_Communication] WHERE [IsVoiceIncluded] = 1 )	
		END 
	AS 'NacID',
	Tele2RatePlan,
	ISNULL(RatePlanUpdatedonAPI,0) AS RatePlanUpdatedonAPI
	from orderitems 
	inner join orderitemdetails on orderitems.OrderitemID = orderitemdetails.OrderitemID 
	inner join products on orderitems.ProductID = Products.ProductID 
	LEFT join OrderdependentITems on orderitems.OrderitemID = OrderdependentITems.OrderitemID
	INNER JOIN [Product_RatePlan_Mapping] ON products.ProductID = [Product_RatePlan_Mapping].ProductID
	WHERE Products.ProductCOde in ('CS9001','CS9002','CS9003','CS9005','CS9010','CS9020','RI9010','RI9020')
	AND ORDERITEMSTATUSID = 14
	AND ISNULL(RatePlanUpdatedonAPI,0) = 0 
	AND ICCID LIKE '8946%'
GO
/****** Object:  StoredProcedure [dbo].[USP_SaveInstallerDetailsInOrder]    Script Date: 12/14/2015 17:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_SaveInstallerDetailsInOrder]
(
@InstallerId varchar(256),
@OrderId int
)
As
BEGIN TRY
Begin
	Declare @InstallerCode varchar(100)
	Declare @InstallerUnqCode Varchar(50)
	DECLARE @SALESREP Varchar(10)
	
	Select @InstallerCode = InstallerCode, @InstallerUnqCode = UniqueCode 
	,@SALESREP = SalesRep
		From Installer
		Where InstallerCompanyID = @InstallerId
		
	Update Orders
		Set InstallerId = @InstallerId,
			InstallerCode = @InstallerCode,
			InstallerUnqCode = @InstallerUnqCode,
			SalesReply = @SALESREP
		Where OrderId = @OrderId
End
END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  View [dbo].[vw_GetBuyItemsForM2M]    Script Date: 12/14/2015 17:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Modified by:Atiq 
-- Modified Date:24/04/2015
-- Add one more column IsVoiceSMSVisible in select statement.
-- Modified Date:13/05/2015
-- Add two more fields VoiceProductId and SMSProductId
-- =============================================
CREATE VIEW [dbo].[vw_GetBuyItemsForM2M]
AS
SELECT  DISTINCT 
    oItems.[OrderItemId] AS [OrderItemId], 
    oItems.[OrderId] AS [OrderId], 
    oItems.[ProductId] AS [ProductId], 
    oItems.[ProductQty] AS [ProductQty], 
    oItems.[Price] AS [Price], 
	pro.AnnualPrice as [AnnualPrice],
    oItems.[CategoryId] AS [CategoryId], 
    pro.[ProductCode] AS [ProductCode], 
    pro.[ProductName] AS [ProductName], 
    pro.[ProductDesc] AS [ProductDesc], 
    pro.[DefaultImage] AS [DefaultImage], 
    pro.[LargeImage] AS [LargeImage], 
    oItems.[IsCSD] AS [IsCSD] ,
	VoiceProducts.ProductName as VoiceProductName,
	VoiceProducts.ProductId AS VoiceProductId,
	SMSProducts.ProductName as SMSProductName,
	SMSProducts.ProductId AS SMSProductId,
	VoiceProducts.ProductCode as VoiceProductCode,
	SMSProducts.ProductCode as SMSProductCode,
	VoiceItem.Price as VoiceProductPrice,
	SMSItem.Price as SMSProductPrice,
	VoiceProducts.AnnualPrice as VoiceProductAnnualPrice,
	SMSProducts.AnnualPrice as SMSProductAnnualPrice,
	pro.IsVoiceSMSVisible
    FROM   [dbo].[OrderItems] AS oItems 
    INNER JOIN [dbo].[Products] AS pro ON oItems.[ProductId] = pro.[ProductId] AND pro.ListedonCSLConnect =1 
	INNER JOIN OrderDependentItems VoiceItem on oItems.OrderItemId = VoiceItem.OrderItemId AND VoiceItem.ProductID in (SElect ProductID from PRoducts WHERE CSLConnectVoice =1)
	INNER JOIN [dbo].[Products] VoiceProducts on VoiceItem.ProductID = VoiceProducts.ProductID AND pro.ListedonCSLConnect =1 
	INNER JOIN OrderDependentItems SMSItem  on oItems.OrderItemId = SMSItem.OrderItemId AND SMSItem.ProductID in (SElect ProductID from PRoducts WHERE CSLConnectSMS =1)
	INNER JOIN [dbo].[Products] SMSProducts on SMSItem.ProductID = SMSProducts.ProductID AND pro.ListedonCSLConnect =1
GO
/****** Object:  View [dbo].[VW_GetActiveUsersDetail]    Script Date: 12/14/2015 17:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_GetActiveUsersDetail]     
    
 
AS  
    
SELECT DISTINCT ISNULL(a.ARCId, '')ARCId,
       ISNULL(a.ARC_Code, '')ARC_Code,
       ISNULL(a.CompanyName, '')CompanyName,
       usrs.UserId,
       usrs.UserName,
       ISNULL(dbo.fn_GetUserRoles(usrs.UserId), '') AS RoleName,
       ISNULL(memship.Email, '') AS Email
FROM   CSLOrdering.dbo.aspnet_Users AS usrs
       LEFT  JOIN CSLOrdering.dbo.aspnet_Membership AS memship
            ON  memship.UserId = usrs.UserId
       LEFT  JOIN CSLOrdering.dbo.aspnet_UsersInRoles AS UsrRoles
            ON  UsrRoles.UserId = usrs.UserId
       LEFT  JOIN dbo.ARC_User_Map AS aum
            ON  aum.UserId = usrs.UserId
       LEFT JOIN dbo.ARC a
            ON  a.ARCId = aum.ARCId
WHERE  usrs.UserId IS NOT NULL
and  usrs.applicationID ='A65AEA2D-F9A4-44C2-B895-2A42F3489877'
GO
/****** Object:  View [dbo].[vw_FedexShippinglist]    Script Date: 12/14/2015 17:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_FedexShippinglist]
AS
SELECT DISTINCT
	[Recipient Code]= Address.AddressID ,
	[Recipient Name] = CASE when Address.ContactName = '' THEN '"' + Address.companyname  Collate Latin1_General_CI_AS + '"'  ELSE '"' + Address.ContactName + '"'  END,
	[Address Line 1]='"' + Address.addressOne  + '"',
	[Address Line 2]='"' +  Address.Addresstwo  + '"',
	[Address Line 3]='',
	[Address Line 4]='',
	[Post Town]='"' + Address.Town + '"',
	[Post Code] ='"' + Address.PostCode + '"',
	[Recipient Contact]='"' +isnull(address.Mobile,'') + '"' ,
	[Recipient Telephone]='"' +isnull(address.Telephone,'') + '"' ,
	[Recipient Email] ='"' +isnull(address.Email,'')+ '"',
	[Number of Items] ='1', 
	[Weight] ='1.00',
	[FedEx UK Account] ='Fedex Account Name',
	[Service] = 'A', --HArdcoded to A as currently everything is set to A and also ship manager throws an issue when B and Productcode is D
	--[Service] = CASE WHEN IsTimedDelivery = 1 THEN 'A' ELSE 'B' END ,
	[Timed Delivery Option]=CASE WHEN IsTimedDelivery = 1 THEN TimedDeliveryOption ELSE '' END,
	[Product Code] = 'D',
	[Delivery Instructions 1]= '"' + Replace(Convert(VARCHAR(32),SpecialInstructions),char(13) + char(10), ' ') + '"',
	[Delivery Instructions 2] = '"' +CASE 
			WHEN Len(Convert(VARCHAR(64),SpecialInstructions)) > 32 THEN Replace(Substring(Convert(VARCHAR(64),SpecialInstructions),33,32),char(13) + char(10), ' ') ELSE '' END
			+ '"' ,
	[Customer Notes 1]='',
	[Customer Notes 2]='',
	[Printer] = '',
	[Customs Value] = '',
	[Ship Date] = '',
	[OrderRef1] = '"' +OrderRefNo + '"',
	[OrderRef2] = Orders.OrderNo ,
	[OrderRef3] = '',
	[OrderRef4] = '',
	[OrderRef5] = '', 
	ProcessedOn = orderitems.ProcessedOn 
FROM 
Orders 
left outer join [Address] on Orders.DeliveryAddressID = Address.AddressID 
--left outer join [Address] insAddress  on Orders.installationAddressID = insAddress.AddressID 
INNER JOIN deliverytype on Orders.DeliveryTypeID = deliverytype.DeliveryTypeID
INNER JOIN ORDERITEMS ON dbo.OrderItems.OrderId = dbo.Orders.OrderId 
WHERE ORders.Orderdate >='01 oct 2013' 
AND Orders.OrderstatusID >=2
GO
/****** Object:  View [dbo].[vw_OrderDataWithDetails]    Script Date: 12/14/2015 17:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_OrderDataWithDetails]
AS
SELECT o.OrderId, o.OrderNo, o.OrderRefNo, o.OrderDate, o.Amount, o.DeliveryCost, o.OrderStatusId, o.DeliveryAddressId, o.InstallationAddressID,
o.BillingAddressId, o.OrderTotalAmount, o.DeliveryTypeId, o.UserIPAddress, o.SpecialInstructions, o.ARCId, o.ARC_Code, o.ARC_EmailId, o.ARC_BillingAccountNo,
o.InstallerId, o.InstallerCode, o.InstallerUnqCode, o.UserName, o.UserEmail, o.CreatedBy as OrderCreatedBy, o.CreatedOn as OrderCreatedOn, 
o.ModifiedBy as OrderModifiedBy, o.ModifiedOn as OrderModifiedOn, o.HasUserAcceptedDuplicates, o.VATRate, o.InstallerContactName, 
o.ProcessedBy as OrderProcessedBy, o.ProcessedOn as OrderProcessedOn, o.UserId, o.SalesReply, o.DlvNoteVol, o.MergedOrderID, o.DeliveryNoteNo, o.IsShipped,
o.EmailSent, o.OverriddenDeliveryCost, o.PaymentType, o.BillingCycleID, o.InitialPayment, o.MonthlyPayment, o.OrderType, o.M2MReplacementOrderNo,
--o.CurrencyID, 
oi.OrderItemId, oi.ProductId, oi.ProductQty, oi.Price, oi.OrderItemStatusId, oi.CreatedOn as OrderItemCreatedOn, 
oi.CreatedBy as OrderItemCreatedBy, oi.ModifiedOn as OrderItemModifiedOn, oi.ModifiedBy as OrderItemModifiedBy,oi.CategoryId, oi.IsCSD, 
oi.ProcessedBy as OrderItemProcessedBy, oi.ProcessedON as OrderItemProcessedOn, oi.QntyDelivered, oi.IsReplenishment, oi.IsNewItem, oi.CSLConnectCodePrefix,
oid.OrderItemDetailId, oid.GPRSNo, oid.PSTNNo, oid.GSMNo, oid.LANNo, oid.ModifiedOn as OrderItemDetailModifiedOn, oid.ModifiedBy as OrderItemDetailModifiedBy, 
oid.GPRSNoPostCode, oid.ICCID, oid.DataNo, oid.PrServerDetails, oid.IsBosInserted, oid.IsPendingFileCreated, oid.FileName, oid.OptionId, oid.Quantity, 
oid.IsDlvNoteGenerated, oid.ItemDlvNoteNo, oid.Isprocessed, oid.ProcessAttempts, oid.LastProcessedTime, oid.PendingFileErrorMessage, oid.BOSErrorMessage, 
oid.isBillingInserted, oid.ReplacementProduct, oid.SiteName, oid.IsFOC, oid.IsReplacement
 FROM dbo.Orders o
INNER JOIN dbo.OrderItems oi ON o.OrderId = oi.OrderId 
INNER JOIN dbo.OrderItemDetails oid ON oi.OrderItemId = oid.OrderItemId
GO
/****** Object:  View [dbo].[vw_OrderDataFull]    Script Date: 12/14/2015 17:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_OrderDataFull]  
AS  
SELECT     dbo.Orders.OrderId, dbo.Orders.OrderNo, dbo.Orders.OrderRefNo, dbo.Orders.OrderDate, dbo.Orders.Amount, dbo.Orders.DeliveryCost, dbo.Orders.OrderStatusId,   
                      dbo.Orders.DeliveryAddressId, dbo.Orders.InstallationAddressID, dbo.Orders.BillingAddressId,dbo.Orders.BillingCycleId, dbo.Orders.OrderType,
					  dbo.Orders.OrderTotalAmount, dbo.Orders.DeliveryTypeId, dbo.Orders.UserIPAddress, dbo.Orders.SpecialInstructions, dbo.Orders.ARCId, dbo.Orders.ARC_Code, 
					  dbo.Orders.ARC_EmailId, dbo.Orders.ARC_BillingAccountNo, dbo.Orders.InstallerId, dbo.Orders.InstallerCode, dbo.Orders.InstallerUnqCode, 
					  dbo.Orders.UserName, dbo.Orders.UserEmail, dbo.Orders.CreatedBy, dbo.Orders.CreatedOn, dbo.Orders.ModifiedBy, dbo.Orders.ModifiedOn, 
					  dbo.Orders.HasUserAcceptedDuplicates, dbo.Orders.VATRate, dbo.Orders.InstallerContactName, dbo.Orders.ProcessedBy, dbo.Orders.ProcessedOn, 
					  dbo.Orders.UserId, dbo.Orders.SalesReply, dbo.Orders.DlvNoteVol, dbo.Orders.MergedOrderID, dbo.Orders.DeliveryNoteNo, dbo.Orders.IsShipped, 
					  dbo.Orders.EmailSent, dbo.Orders.OverriddenDeliveryCost, dbo.OrderItems.ProductId, dbo.OrderItems.ProductQty, dbo.OrderItems.Price, 
					  dbo.OrderItems.OrderItemStatusId, dbo.OrderItems.CategoryId, dbo.OrderItems.IsCSD, dbo.OrderItems.ProcessedBy AS Expr1, 
					  dbo.OrderItems.ProcessedOn AS Expr2, dbo.OrderItems.QntyDelivered, dbo.OrderItems.IsReplenishment,   
                      dbo.OrderItems.IsNewItem, dbo.OrderItemDetails.GPRSNo, dbo.OrderItemDetails.PSTNNo, dbo.OrderItemDetails.GSMNo, dbo.OrderItemDetails.GPRSNoPostCode,   
                      dbo.OrderItemDetails.ICCID, dbo.OrderItemDetails.DataNo, dbo.OrderItemDetails.PrServerDetails, dbo.OrderItemDetails.IsBosInserted,   
                      dbo.OrderItemDetails.IsPendingFileCreated, dbo.OrderItemDetails.FileName, dbo.OrderItemDetails.OptionId, dbo.OrderItemDetails.Quantity,   
                      dbo.OrderItemDetails.IsDlvNoteGenerated, dbo.OrderItemDetails.ItemDlvNoteNo, dbo.OrderItemDetails.Isprocessed, dbo.OrderItemDetails.ProcessAttempts,   
                      dbo.OrderItemDetails.LastProcessedTime, dbo.OrderItemDetails.PendingFileErrorMessage, dbo.OrderItemDetails.BOSErrorMessage,   
                      dbo.OrderItemDetails.isBillingInserted, dbo.OrderItemDetails.ReplacementProduct, dbo.OrderItemDetails.SiteName, dbo.OrderItemDetails.IsFOC,   
                      dbo.OrderItemDetails.IsReplacement, dbo.Products.ProductName, dbo.Products.ProductCode, dbo.Category.CategoryName, dbo.Options.OptionName,   
                      dbo.OrderStatusMaster.OrderStatus, OrderStatusMaster_1.OrderStatus AS OrderItemStatus, Products.ProductType  ,OrderItems.OrderItemId ,OrderItemDetails.OrderItemDetailId
FROM				  dbo.Orders INNER JOIN  dbo.OrderItems ON dbo.Orders.OrderId = dbo.OrderItems.OrderId 
						LEFT OUTER  JOIN  dbo.OrderStatusMaster ON dbo.Orders.OrderStatusId = dbo.OrderStatusMaster.OrderStatusId 
						LEFT OUTER JOIN  dbo.OrderStatusMaster AS OrderStatusMaster_1 ON dbo.OrderItems.OrderItemStatusId = OrderStatusMaster_1.OrderStatusId 
                      LEFT OUTER JOIN Category ON   dbo.Category.CategoryId = dbo.OrderItems.CategoryId 
                      LEFT OUTER JOIN  dbo.Products ON dbo.OrderItems.ProductId = dbo.Products.ProductId 
                      LEFT OUTER JOIN  dbo.OrderItemDetails ON dbo.OrderItems.OrderItemId = dbo.OrderItemDetails.OrderItemId  
                      left outer join Options on OrderItemDetails.OptionId = Options.OptID 
                      
                      
                      --select * from dbo.vw_OrderDataFull where ICCID = '89314404000077802198'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[28] 4[48] 2[6] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Orders"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 589
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrderItems"
            Begin Extent = 
               Top = 88
               Left = 305
               Bottom = 486
               Right = 506
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Category"
            Begin Extent = 
               Top = 296
               Left = 767
               Bottom = 626
               Right = 944
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Products"
            Begin Extent = 
               Top = 271
               Left = 1037
               Bottom = 481
               Right = 1225
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrderItemDetails"
            Begin Extent = 
               Top = 9
               Left = 630
               Bottom = 519
               Right = 839
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Options"
            Begin Extent = 
               Top = 504
               Left = 1119
               Bottom = 608
               Right = 1279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrderStatusMaster"
            Begin Extent = 
               Top = 22
               Left = 1244
               Bottom = 196
               Right = 1445
            End
   ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_OrderDataFull'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'         DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrderStatusMaster_1"
            Begin Extent = 
               Top = 117
               Left = 964
               Bottom = 236
               Right = 1165
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1800
         Alias = 1440
         Table = 1785
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_OrderDataFull'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_OrderDataFull'
GO
/****** Object:  View [dbo].[vw_OrderData]    Script Date: 12/14/2015 17:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_OrderData]
AS
SELECT     TOP (100) PERCENT dbo.Orders.ARC_Code, dbo.ARC.CompanyName, dbo.OrderItems.ProductQty, dbo.OrderItems.Price, dbo.OrderItems.IsCSD, 
                      dbo.Products.ProductCode, dbo.Products.ProductName, dbo.OrderItemDetails.GPRSNo, dbo.OrderItemDetails.GPRSNoPostCode, dbo.OrderItemDetails.ItemDlvNoteNo,
                       dbo.Installer.CompanyName AS InstallerCompany, dbo.Installer.UniqueCode, dbo.Installer.InstallerCode, dbo.OrderStatusMaster.OrderStatus, dbo.Orders.OrderNo, 
                      dbo.Orders.OrderRefNo, dbo.Orders.OrderDate, dbo.Orders.Amount, dbo.Orders.DeliveryCost, dbo.Orders.OrderTotalAmount, dbo.Orders.SpecialInstructions, 
                      dbo.Orders.UserName, dbo.Orders.SalesReply, dbo.Orders.DeliveryNoteNo, dbo.Orders.CreatedBy, dbo.Orders.CreatedOn, dbo.Orders.ModifiedBy, 
                      dbo.Orders.ModifiedOn, dbo.Orders.HasUserAcceptedDuplicates, dbo.Orders.VATRate, dbo.Orders.InstallerContactName, dbo.DeliveryType.DeliveryShortDesc, 
                      dbo.DeliveryType.DeliveryCode, dbo.Orders.ARC_EmailId, dbo.Orders.UserEmail, dbo.Address.AddressOne, dbo.Address.AddressTwo, dbo.Address.Town, 
                      dbo.Address.County, dbo.Address.PostCode, dbo.Address.Country
FROM         dbo.Orders INNER JOIN
                      dbo.OrderItems ON dbo.Orders.OrderId = dbo.OrderItems.OrderId INNER JOIN
                      dbo.OrderStatusMaster ON dbo.Orders.OrderStatusId = dbo.OrderStatusMaster.OrderStatusId INNER JOIN
                      dbo.Products ON dbo.OrderItems.ProductId = dbo.Products.ProductId INNER JOIN
                      dbo.ARC ON dbo.Orders.ARCId = dbo.ARC.ARCId INNER JOIN
                      dbo.Installer ON dbo.Orders.InstallerId = dbo.Installer.InstallerCompanyID INNER JOIN
                      dbo.DeliveryType ON dbo.Orders.DeliveryTypeId = dbo.DeliveryType.DeliveryTypeId LEFT OUTER JOIN
                      dbo.Address ON dbo.Orders.DeliveryAddressId = dbo.Address.AddressID LEFT OUTER JOIN
                      dbo.OrderItemDetails ON dbo.OrderItems.OrderItemId = dbo.OrderItemDetails.OrderItemId
ORDER BY dbo.Orders.ModifiedOn DESC
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[50] 4[4] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Orders"
            Begin Extent = 
               Top = 17
               Left = 16
               Bottom = 673
               Right = 250
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrderItems"
            Begin Extent = 
               Top = 148
               Left = 521
               Bottom = 556
               Right = 720
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrderStatusMaster"
            Begin Extent = 
               Top = 11
               Left = 831
               Bottom = 178
               Right = 1032
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Products"
            Begin Extent = 
               Top = 420
               Left = 842
               Bottom = 674
               Right = 1030
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ARC"
            Begin Extent = 
               Top = 225
               Left = 891
               Bottom = 344
               Right = 1078
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Installer"
            Begin Extent = 
               Top = 445
               Left = 286
               Bottom = 691
               Right = 470
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "DeliveryType"
            Begin Extent = 
               Top = 12
               Left = 387
               Bottom = 219
               Right = 587
            End
          ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_OrderData'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'  DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrderItemDetails"
            Begin Extent = 
               Top = 403
               Left = 1120
               Bottom = 666
               Right = 1329
            End
            DisplayFlags = 280
            TopColumn = 11
         End
         Begin Table = "Address"
            Begin Extent = 
               Top = 36
               Left = 1147
               Bottom = 266
               Right = 1308
            End
            DisplayFlags = 280
            TopColumn = 7
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 36
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1800
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_OrderData'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_OrderData'
GO
/****** Object:  View [dbo].[vw_SIMRegister]    Script Date: 12/14/2015 17:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_SIMRegister]
AS


SELECT     Replace(Orderitemdetails.ICCID,'E','') AS ICCID , 
Isnull(CASE when ICCID like '00500%' THEN SUBSTRING (ICCID,0,12) ELSE nullif(isnull(dbo.Device_API.data_number,OrderItemDetails.DataNo),'') END,'N/A') AS 'DataNo',
dbo.Device_API.Dev_IP_Address AS IPAddress, dbo.OrderItemDetails.GPRSNo, 
			ARC.CompanyName ,
dbo.Orders.OrderDate, 

	CASE WHEN (ARC.ARC_Code <> Orders.ARC_Code)
		THEN Orders.ARC_Code
		ELSE 
				ARC.ARC_Code
		END 
	AS ARC_Code,
dbo.Installer.CompanyName AS Installer, dbo.Installer.InstallerCode, dbo.Orders.ProcessedBy, dbo.Orders.ProcessedOn, 
dbo.OrderItemDetails.IsBosInserted, dbo.Orders.OrderNo, dbo.OrderItems.OrderItemStatusId, dbo.Orders.OrderStatusId, dbo.Installer.UniqueCode, 
dbo.OrderItems.ProductId, dbo.Products.ProductCode, dbo.Products.ProductName, dbo.Device_API.Dev_IMSINumber, ISNULL(dbo.OrderItems.IsCSD,0) AS CSD, ISNULL(dbo.OrderItems.IsReplenishment,0) AS Replenishment, dbo.Orders.SalesReply
FROM         dbo.Orders INNER JOIN
dbo.OrderItems ON dbo.Orders.OrderId = dbo.OrderItems.OrderId INNER JOIN
dbo.OrderItemDetails ON dbo.OrderItems.OrderItemId = dbo.OrderItemDetails.OrderItemId INNER JOIN
dbo.ARC ON dbo.Orders.ARC_Code = dbo.ARC.ARC_Code INNER JOIN
dbo.Installer ON dbo.Orders.InstallerId = dbo.Installer.InstallerCompanyID LEFT OUTER JOIN
dbo.Products ON dbo.OrderItems.ProductId = dbo.Products.ProductId LEFT OUTER JOIN
dbo.Device_API ON dbo.OrderItemDetails.ICCID = dbo.Device_API.Dev_Code
                  

/*
SELECT     dbo.OrderItemDetails.ICCID, dbo.OrderItemDetails.DataNo, dbo.Device_API.Dev_IP_Address AS IPAddress, dbo.OrderItemDetails.GPRSNo, dbo.ARC.CompanyName, 
                      dbo.Orders.OrderDate, dbo.ARC.ARC_Code, dbo.Installer.CompanyName AS Installer, dbo.Installer.InstallerCode, dbo.Orders.ProcessedBy, dbo.Orders.ProcessedOn, 
                      dbo.OrderItemDetails.IsBosInserted, dbo.Orders.OrderNo, dbo.OrderItems.OrderItemStatusId, dbo.Orders.OrderStatusId, dbo.Installer.UniqueCode, 
                      dbo.OrderItems.ProductId, dbo.Products.ProductCode, dbo.Products.ProductName, dbo.Device_API.Dev_IMSINumber
FROM         dbo.Orders INNER JOIN
                      dbo.OrderItems ON dbo.Orders.OrderId = dbo.OrderItems.OrderId INNER JOIN
                      dbo.OrderItemDetails ON dbo.OrderItems.OrderItemId = dbo.OrderItemDetails.OrderItemId INNER JOIN
                      dbo.ARC ON dbo.Orders.ARCId = dbo.ARC.ARCId INNER JOIN
                      dbo.Installer ON dbo.Orders.InstallerId = dbo.Installer.InstallerCompanyID LEFT OUTER JOIN
                      dbo.Products ON dbo.OrderItems.ProductId = dbo.Products.ProductId LEFT OUTER JOIN
                      dbo.Device_API ON dbo.OrderItemDetails.ICCID = dbo.Device_API.Dev_Code
*/
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[56] 4[8] 2[21] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Orders"
            Begin Extent = 
               Top = 18
               Left = 34
               Bottom = 497
               Right = 256
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrderItems"
            Begin Extent = 
               Top = 18
               Left = 373
               Bottom = 223
               Right = 566
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrderItemDetails"
            Begin Extent = 
               Top = 7
               Left = 837
               Bottom = 444
               Right = 1047
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "ARC"
            Begin Extent = 
               Top = 217
               Left = 610
               Bottom = 408
               Right = 797
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Installer"
            Begin Extent = 
               Top = 327
               Left = 323
               Bottom = 500
               Right = 507
            End
            DisplayFlags = 280
            TopColumn = 9
         End
         Begin Table = "Products"
            Begin Extent = 
               Top = 273
               Left = 1192
               Bottom = 392
               Right = 1380
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Device_API"
            Begin Extent = 
               Top = 43
               Left = 1194
               Bottom = 250
               Right = 1371
            End
            D' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SIMRegister'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'isplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SIMRegister'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SIMRegister'
GO
/****** Object:  View [dbo].[VW_SIMDetailListForM2M]    Script Date: 12/14/2015 17:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_SIMDetailListForM2M]
 as
	
      SELECT d.ID DeviceM2MId,d.Dev_CODE AS ICCID,d.Dev_usage as Usage,d.Dev_IMSINumber as IMSI,d.Dev_MSISDN as MSISDN,u.ID UserSimsId,u.OverUsageAlert,u.Status,b.Description BillingCycle,p.ProductCode,p.ProductName,p.Allowance,
	  ASPNET_USERS.userName , 
	  INSTALLER.CompanyName
	  FROM  [dbo].[Device_API] d
               INNER JOIN UserSIMS u ON u.DeviceID=d.ID
			   INNER JOIN BillingCycle b ON u.BillingCycleID=b.ID
			   INNER JOIN Products p ON p.ProductId=u.ProductId
			   INNER JOIN USERMAPPING on u.UserID = USERMAPPING.UserID
			   INNER JOIN INSTALLER ON INSTALLER.UniqueCode = USERMAPPING.UniqueCode 
			   INNER JOIN CSLORDERING.DBO.ASPNET_USERS ON USERMAPPING.UserID = ASPNET_USERS.UserID
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateProfileAddress]    Script Date: 12/14/2015 17:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_UpdateProfileAddress] 
(
    @UserId         uniqueidentifier,
	@CompanyName    NVARCHAR(256),
    @ContactName    NVARCHAR(256),
    @Email			NVARCHAR(256),
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
	      DECLARE @AddressId INT
        -- insert address
            INSERT INTO ADDRESS
              (
			  CompanyName,
                ContactName,
				Email,
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
			    @CompanyName,
                @ContactName,
				@Email,
                @AddressOne,
                @AddressTwo,
                @Town,
                @County,
                @PostCode,
                @ContactNumber,
                @Country,
                ISNULL(NULLIF(@CountryId,0),1),
                @CreatedBy,
                GETDATE(),
                @CreatedBy,
                GETDATE()
              )  
            
            SELECT @AddressId=CAST(SCOPE_IDENTITY() AS INT)  
        
        -- update user address
		 
			   UPDATE UserMapping 
				  SET AddressId=@AddressId
			   WHERE UserId=@UserId
	

		UPDATE ORDERS SET BillingAddressID =@AddressId,DeliveryAddressID=@AddressId   WHERE ORDERSTATUSID = 1 AND USERID = @USERID 

			SELECT @AddressId AS AddressId

    END
END TRY   
BEGIN CATCH
    EXEC USP_SaveSPErrorDetails 
    RETURN -1
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateOrderTablesOnUpdateUser]    Script Date: 12/14/2015 17:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_UpdateOrderTablesOnUpdateUser]
(
	@UserId NVarchar(256)	
)
AS
BEGIN TRY
BEGIN

	DECLARE @ARCId Int
	DECLARE @OrderId Int
	DECLARE @OrderItemId Int
	--DECLARE @GetOrderItems CURSOR
		
	IF EXISTS (Select OrderId From Orders Where CreatedBy = @UserId And OrderStatusId = 1)
		BEGIN
			Select TOP 1 @ARCId = ARCId, @OrderId = OrderId From Orders Where CreatedBy = @UserId And OrderStatusId = 1
			IF NOT EXISTS (Select ARCId From ARC_User_Map Where ARCId = @ARCId And UserId = @UserId)
				BEGIN
				
					--SET @GetOrderItems = CURSOR FOR					
					--	Select OrderItemId From OrderItems Where OrderId = @OrderId
					
					--OPEN @GetOrderItems
					--FETCH Next From @GetOrderItems INTO @OrderItemId
					--WHILE @@FETCH_STATUS = 0
					--	BEGIN
					--		Delete From OrderItemDetails Where OrderItemId = @OrderItemId
					--		FETCH Next From @GetOrderItems INTO @OrderItemId
					--	END				
					--CLOSE @GetOrderItems
					--DEALLOCATE @GetOrderItems
					
					Delete From OrderItemDetails Where OrderItemId IN (Select OrderItemId From OrderItems Where OrderId = @OrderId)
					Delete From OrderDependentItems Where OrderId = @OrderId
					Delete From OrderItems Where OrderId = @OrderId
					Delete From Orders Where OrderId = @OrderId
				END
		END
END
END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateOrderTablesOnUpdateProduct]    Script Date: 12/14/2015 17:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_UpdateOrderTablesOnUpdateProduct]
(
	@ProductId INT	
)
AS
BEGIN TRY
BEGIN
	DECLARE @OrderId int
	DECLARE @ARCId int
	DECLARE @CategoryId int
	
	DECLARE @OrderItemId int	
	DECLARE @ProductQty int		
	DECLARE @ProductPrice decimal(6,2)	
	DECLARE @OrderItemTotalPrice decimal(6,2)		
	DECLARE @ProductPriceNew decimal(6,2)	
	DECLARE @OrderItemTotalPriceNew decimal(6,2)		
	DECLARE @GetProducts CURSOR		
	
	DECLARE @DependentProductId INT
	DECLARE @DependentProductIdNew INT
	DECLARE @DependentProductQty INT
	DECLARE @DependentProductPrice DECIMAL(6,2)
	DECLARE @DependentProductPriceTotal DECIMAL(6,2)
	DECLARE @DependentProductPriceNew DECIMAL(6,2)
	DECLARE @DependentProductPriceTotalNew DECIMAL(6,2)
	DECLARE @GetDependentProducts CURSOR		
	
	Update ARC_Product_Price_Map Set IsDeleted = 1 Where ARCId NOT IN
		(Select ARCId from Product_ARC_Map where ProductId = @ProductId)
		And ProductId = @ProductId	
	
	SET @GetProducts = CURSOR FOR
		Select OI.OrderItemId, OI.OrderId, OI.ProductQty, OI.Price, O.ARCId
			From OrderItems OI
			Inner Join
			Orders O ON O.OrderId = OI.OrderId
			Where OI.ProductId = @ProductId
				AND O.OrderStatusId = 1
	
	OPEN @GetProducts
	
	FETCH Next From @GetProducts INTO @OrderItemId, @OrderId, @ProductQty, @ProductPrice, @ARCId
	WHILE @@FETCH_STATUS = 0
		BEGIN
			IF Exists (Select Top 1 cpm.CategoryId 
								From Product_ARC_Map pam								
								Inner Join
								Category_Product_Map cpm on pam.ProductId = cpm.ProductId
								Inner Join
								ARC_Category_Map acm ON acm.CategoryId = cpm.CategoryId And acm.ARCId = pam.ARCId
								Inner Join
								Products p on p.ProductId = pam.ProductId And p.ProductId = @ProductId And p.IsDeleted = 0
								Where pam.ProductId = @ProductId And cpm.ProductId = @ProductId And cpm.ProductId = @ProductId And acm.ARCId = @ARCId)				
				BEGIN
					SET @OrderItemTotalPrice = 0				
					SET @OrderItemTotalPrice = @ProductQty * @ProductPrice	
										
					SET @CategoryId =(Select Top 1 cpm.CategoryId 
								From Product_ARC_Map pam								
								Inner Join
								Category_Product_Map cpm on pam.ProductId = cpm.ProductId
								Inner Join
								ARC_Category_Map acm ON acm.CategoryId = cpm.CategoryId And acm.ARCId = pam.ARCId
								Where pam.ProductId = @ProductId And cpm.ProductId = @ProductId And acm.ARCId = @ARCId)
																	
					Select @ProductPriceNew = case IsNull(t.ARC_Price,0) when 0 then t.Price else t.ARC_Price end
					from
					(Select p.Price, ppm.Price as ARC_Price, p.ListOrder 
						from 
						Products p					
						left join
						ARC_Product_Price_Map ppm on ppm.ProductId = p.ProductId and DATEDIFF(d,isnull(ppm.ExpiryDate,getdate()),GETDATE())>0 And ppm.IsDeleted=0
						Where p.IsDependentProduct = 0 And p.IsDeleted=0  And p.ProductId = @ProductId
					) t		
					
					SET @OrderItemTotalPriceNew = 0
					SET @OrderItemTotalPriceNew = @ProductQty * @ProductPriceNew			
														
					SET @DependentProductPriceTotal = 0
					SET @DependentProductPriceTotal = (Select Sum(IsNull(ProductQty,0) * IsNull(Price,0)) from OrderDependentItems where OrderItemId = @OrderItemId)
					Delete From OrderDependentItems Where OrderItemId = @OrderItemId
					
					SET @DependentProductPriceTotalNew = 0
														
					SET @GetDependentProducts = CURSOR FOR					
						SELECT t.ProductId, CASE IsNull(t.ARC_Price,0) WHEN 0 THEN t.Price ELSE t.ARC_Price END AS Price
						FROM
							(SELECT p.ProductId, p.Price, ppm.Price AS ARC_Price
								FROM Products p
								left join
								ARC_Product_Price_Map ppm ON ppm.ProductId = p.ProductId and DATEDIFF(d,isnull(ppm.ExpiryDate,getdate()),GETDATE())>0 And ppm.IsDeleted=0
								WHERE p.IsDeleted=0 and p.ProductId in
									(SELECT pdm.DependentProductId FROM Product_Dependent_Map pdm WHERE pdm.ProductId = @ProductId)
							) t
					
					OPEN @GetDependentProducts
					FETCH Next From @GetDependentProducts INTO @DependentProductIdNew, @DependentProductPriceNew								
										
					WHILE @@FETCH_STATUS = 0
						BEGIN
							SET @DependentProductPriceTotalNew = @DependentProductPriceTotalNew + @DependentProductPriceNew * @ProductQty												
							
							INSERT INTO OrderDependentItems (OrderId, OrderItemId, ProductId, ProductQty, Price)
													VALUES(@OrderId, @OrderItemId, @DependentProductIdNew, @ProductQty, @DependentProductPriceNew)
							
							FETCH Next From @GetDependentProducts INTO @DependentProductIdNew, @DependentProductPriceNew
						END
					
					CLOSE @GetDependentProducts
					DEALLOCATE @GetDependentProducts	
					
					Update Orders Set Amount = Amount - @OrderItemTotalPrice + @OrderItemTotalPriceNew - @DependentProductPriceTotal + @DependentProductPriceTotalNew Where OrderId = @OrderId
					Update OrderItems Set Price = @ProductPriceNew, CategoryId = @CategoryId Where OrderItemId = @OrderItemId													
							
				END
			Else
				BEGIN
					SET @OrderItemTotalPrice = 0
					SET @DependentProductPriceTotal = 0
					SET @OrderItemTotalPrice = (Select Sum(IsNull(ProductQty,0) * IsNull(Price,0)) from OrderItems where OrderItemId = @OrderItemId)
					SET @DependentProductPriceTotal = (Select Sum(IsNull(ProductQty,0) * IsNull(Price,0)) from OrderDependentItems where OrderItemId = @OrderItemId)
					
					Delete From OrderItems Where OrderItemId = @OrderItemId
					Delete From OrderItemDetails Where OrderItemId = @OrderItemId
					Delete From OrderDependentItems Where OrderItemId = @OrderItemId
					Update Orders Set Amount = Amount - @OrderItemTotalPrice - @DependentProductPriceTotal Where OrderId = @OrderId
				END
			FETCH Next From @GetProducts INTO @OrderItemId, @OrderId, @ProductQty, @ProductPrice, @ARCId
		END
		
	CLOSE @GetProducts
	DEALLOCATE @GetProducts
END
END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateOrderTablesOnUpdateCategory]    Script Date: 12/14/2015 17:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_UpdateOrderTablesOnUpdateCategory]
(
	@CategoryId int
)
AS
BEGIN TRY 
BEGIN
	DECLARE @OrderId int
	DECLARE @ARCId int
	
	DECLARE @OrderItemId int
	DECLARE @ProductId INT	
	DECLARE @ProductQty int		
	DECLARE @ProductPrice decimal(6,2)	
	DECLARE @OrderItemTotalPrice decimal(6,2)		
	DECLARE @GetProducts CURSOR		
	
	DECLARE @DependentProductId INT
	DECLARE @DependentProductQty INT
	DECLARE @DependentProductPrice DECIMAL(6,2)
	DECLARE @DependentProductPriceTotal DECIMAL(6,2)
	DECLARE @GetDependentProducts CURSOR		
	
	SET @GetProducts = CURSOR FOR
		Select OI.OrderItemId, OI.OrderId, OI.ProductId, OI.ProductQty, OI.Price, O.ARCId
			From OrderItems OI
			Inner Join
			Orders O ON O.OrderId = OI.OrderId
			Where OI.CategoryId = @CategoryId
				AND O.OrderStatusId = 1
	
	OPEN @GetProducts
	
	FETCH Next From @GetProducts INTO @OrderItemId, @OrderId, @ProductId, @ProductQty, @ProductPrice, @ARCId
	WHILE @@FETCH_STATUS = 0
		BEGIN
			IF Not Exists (Select Top 1 cpm.ProductId 
								From Category_Product_Map cpm
								Inner Join
								ARC_Category_Map acm ON acm.CategoryId = cpm.CategoryId
								Inner Join
								Category cat on cat.CategoryId = acm.CategoryId And cat.IsDeleted = 0
								Where cpm.CategoryId = @CategoryId And cpm.ProductId = @ProductId And acm.ARCId = @ARCId)				
				BEGIN
					SET @OrderItemTotalPrice = 0
					SET @OrderItemTotalPrice = @ProductQty * @ProductPrice			
										
					SET @GetDependentProducts = CURSOR FOR
						Select ProductId, ProductQty, Price From OrderDependentItems
								Where OrderItemId = @OrderItemId
					
					OPEN @GetDependentProducts
					FETCH Next From @GetDependentProducts INTO @DependentProductId, @DependentProductQty, @DependentProductPrice
				
					WHILE @@FETCH_STATUS = 0
						BEGIN
							SET @DependentProductPriceTotal = 0
							SET @DependentProductPriceTotal = @DependentProductQty * @DependentProductPrice
							
							Delete From OrderDependentItems Where OrderItemId = @OrderItemId And ProductId = @DependentProductId
							FETCH Next From @GetDependentProducts INTO @DependentProductId, @DependentProductQty, @DependentProductPrice
						END
					
					CLOSE @GetDependentProducts
					DEALLOCATE @GetDependentProducts
						
					Update Orders Set Amount = Amount - @OrderItemTotalPrice - @DependentProductPriceTotal Where OrderId = @OrderId
					Delete From OrderItems Where OrderItemId = @OrderItemId
					Delete From OrderItemDetails Where OrderItemId = @OrderItemId
				END
			FETCH Next From @GetProducts INTO @OrderItemId, @OrderId, @ProductId, @ProductQty, @ProductPrice, @ARCId
		END
		
	CLOSE @GetProducts
	DEALLOCATE @GetProducts
END
END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateOrderTablesOnUpdateARCProductPrice]    Script Date: 12/14/2015 17:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_UpdateOrderTablesOnUpdateARCProductPrice]
(
	@ARCId int
)
AS
BEGIN TRY 
BEGIN

	DECLARE @OrderId int
	DECLARE @OrderItemId int
	DECLARE @ProductId INT
	DECLARE @ProductQty int		
	DECLARE @ProductPrice decimal(6,2)	
	DECLARE @OrderItemTotalPrice decimal(6,2)		
	DECLARE @ProductPriceNew decimal(6,2)	
	DECLARE @OrderItemTotalPriceNew decimal(6,2)		
	DECLARE @GetProducts CURSOR
	
	If EXISTS (Select OrderId From Orders Where ARCId = @ARCId And OrderStatusId = 1)
		BEGIN
			SET @GetProducts  = CURSOR FOR
				Select O.OrderId, OI.OrderItemId, OI.ProductId, OI.ProductQty, OI.Price 
					From OrderItems OI
					Inner Join
					Orders O On OI.OrderId = O.OrderId And O.OrderStatusId = 1
					Where O.ARCId = @ARCId
			OPEN @GetProducts
			
			FETCH Next FROM @GetProducts Into @OrderId, @OrderItemId, @ProductId, @ProductQty, @ProductPrice
			WHILE @@FETCH_STATUS = 0
				BEGIN
					Select @ProductPriceNew = case IsNull(t.ARC_Price,0) when 0 then t.Price else t.ARC_Price end
					from
					(Select p.Price, ppm.Price as ARC_Price, p.ListOrder 
						from 
						Products p					
						left join
						ARC_Product_Price_Map ppm on ppm.ProductId = p.ProductId and DATEDIFF(d,isnull(ppm.ExpiryDate,getdate()),GETDATE())>0  And ppm.IsDeleted=0
						Where p.IsDependentProduct = 0 And p.IsDeleted=0 And p.ProductId = @ProductId
					) t
					
					IF @ProductPrice != @ProductPriceNew
						BEGIN
							SET @OrderItemTotalPrice = 0
							SET @OrderItemTotalPrice = @ProductQty * @ProductPrice
							
							SET @OrderItemTotalPriceNew = 0
							SET @OrderItemTotalPriceNew = @ProductQty * @ProductPriceNew
							
							Update OrderItems Set Price = @ProductPriceNew Where OrderItemId = @OrderItemId
							Update Orders Set Amount = Amount - @OrderItemTotalPrice + @OrderItemTotalPriceNew Where OrderId = @OrderId
						END
					
					FETCH Next FROM @GetProducts Into @OrderId, @OrderItemId, @ProductId, @ProductQty, @ProductPrice
				END
		END
END
END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateOrderTablesOnUpdateARC]    Script Date: 12/14/2015 17:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_UpdateOrderTablesOnUpdateARC]
(
	@ARCId int
)
AS
BEGIN TRY 
BEGIN

	DECLARE @OrderId int	
	DECLARE @UserId NVarchar(256)	
	DECLARE @CategoryId int	
	DECLARE @OrderItemId int
	
	DECLARE @ProductId INT		
	DECLARE @ProductQty int		
	DECLARE @ProductPrice decimal(6,2)	
	DECLARE @OrderItemTotalPrice decimal(6,2)		
	
	DECLARE @GetOrders CURSOR		
	DECLARE @GetOrderItems CURSOR		
	
	DECLARE @DependentProductPriceTotal DECIMAL(6,2)
	
	Update ARC_Product_Price_Map Set IsDeleted = 1 Where ProductId NOT IN
		(Select ProductId from Product_ARC_Map where ARCId = @ARCId)
		And ARCId = @ARCId
	
	IF EXISTS (Select ARCId From ARC Where ARCId = @ARCId And IsDeleted = 1)
		BEGIN			
			Delete From OrderItemDetails Where OrderItemId IN (Select OrderItemId From OrderItems Where OrderId IN (SELECT OrderId From Orders Where ARCId = @ARCId And OrderStatusId = 1))
			Delete From OrderDependentItems Where OrderId IN (SELECT OrderId From Orders Where ARCId = @ARCId And OrderStatusId = 1)
			Delete From OrderItems Where OrderId IN (SELECT OrderId From Orders Where ARCId = @ARCId And OrderStatusId = 1)
			Delete From Orders Where ARCId = @ARCId And OrderStatusId = 1
		END
	ELSE
		BEGIN
			SET @GetOrders = CURSOR FOR
				SELECT OrderId, CreatedBy From Orders Where ARCId = @ARCId And OrderStatusId = 1
				
			OPEN @GetOrders
			
			FETCH Next FROM @GetOrders Into @OrderId, @UserId
			WHILE @@FETCH_STATUS = 0
				BEGIN
					IF NOT EXISTS (Select ARCId From ARC_User_Map Where ARCId = @ARCId And UserId = @UserId)
						BEGIN							
							Delete From OrderItemDetails Where OrderItemId IN (Select OrderItemId From OrderItems Where OrderId IN (SELECT OrderId From Orders Where ARCId = @ARCId And CreatedBy = @UserId And OrderStatusId = 1))
							Delete From OrderDependentItems Where OrderId IN (SELECT OrderId From Orders Where ARCId = @ARCId And CreatedBy = @UserId And OrderStatusId = 1)
							Delete From OrderItems Where OrderId IN (SELECT OrderId From Orders Where ARCId = @ARCId And CreatedBy = @UserId And OrderStatusId = 1)
							Delete From Orders Where ARCId = @ARCId And CreatedBy = @UserId And OrderStatusId = 1
						END
					ELSE
						BEGIN
							SET @GetOrderItems = CURSOR FOR
								Select OrderItemId, ProductId, ProductQty, Price, CategoryId From OrderItems Where OrderId = @OrderId
							
							OPEN @GetOrderItems
							
							FETCH Next FROM @GetOrderItems Into @OrderItemId, @ProductId, @ProductQty, @ProductPrice, @CategoryId
							WHILE @@FETCH_STATUS = 0
								BEGIN
									IF NOT EXISTS (Select acm.ARCId From
														ARC_Category_Map acm
														Inner Join
														Product_ARC_Map pam on acm.ARCId = pam.ARCId
														Where CategoryId = @CategoryId And ProductId = @ProductId And pam.ARCId = @ARCId And acm.ARCId = @ARCId)
										BEGIN									
											
											SET @OrderItemTotalPrice = 0
											SET @OrderItemTotalPrice = @ProductQty * @ProductPrice
											
											SET @DependentProductPriceTotal = 0
											SET @DependentProductPriceTotal = (Select Sum(IsNull(ProductQty,0) * IsNull(Price,0)) from OrderDependentItems where OrderItemId = @OrderItemId)
											
											Delete From OrderItemDetails Where OrderItemId = @OrderItemId
											Delete From OrderDependentItems Where OrderItemId = @OrderItemId
											Delete From OrderItems Where OrderItemId = @OrderItemId
											Update Orders Set Amount = Amount - @OrderItemTotalPrice - @DependentProductPriceTotal Where OrderId = @OrderId
										END
									FETCH Next FROM @GetOrderItems Into @OrderItemId, @ProductId, @ProductQty, @ProductPrice, @CategoryId
								END
							CLOSE @GetOrderItems
							DEALLOCATE @GetOrderItems
						END
					FETCH Next FROM @GetOrders Into @OrderId, @UserId
				END
			CLOSE @GetOrders
			DEALLOCATE @GetOrders
		END
END
END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateOrderItemDetailsToBasket]    Script Date: 12/14/2015 17:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_UpdateOrderItemDetailsToBasket]  
   
(  
    @OrderItemDetailId  INT,  @GPRSNo             VARCHAR(50),  @GPRSNoPostCode     VARCHAR(50),  @CreatedBy          VARCHAR(256),  
    @PSTNNo             NVARCHAR(50),@SiteName VARCHAR(256), @optionId int  
)  
AS  
BEGIN TRY  
    BEGIN  
        UPDATE OrderItemDetails  
        SET    GPRSNo = @GPRSNo,  GPRSNoPostCode = @GPRSNoPostCode,  ModifiedOn = GETDATE(),  
               ModifiedBy = @CreatedBy,  PSTNNo = @PSTNNo  ,OptionId = @optionId , SiteName = @SiteName
        WHERE  OrderItemDetailId = @OrderItemDetailId  
    END  
END TRY       
BEGIN CATCH  
    EXEC USP_SaveSPErrorDetails   
    RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateCSDOrder]    Script Date: 12/14/2015 17:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alex Papayianni
-- Create date: 30/04/2014
-- Description:	Update order if CSD
-- =============================================
CREATE PROCEDURE [dbo].[USP_UpdateCSDOrder] 
	@OrderNo nvarchar(512)
AS
BEGIN
	--Update ICCID with value from PSTNNo for CSD orders
	update oid
	set oid.ICCID = CASE 
		WHEN len(oid.PSTNNo) = 19 Then  'E' + oid.PSTNNo Else oid.PSTNNo END ,	PrServerDetails = (CASE
    WHEN oi.CategoryId = '10' THEN (select KeyValue from ApplicationSetting where KeyName = 'APNServerUHS')
    WHEN a.PolltoEIRE = '1' THEN (select KeyValue from ApplicationSetting where KeyName = 'APNServerIRE')
	ELSE (select KeyValue from ApplicationSetting where KeyName = 'APNServer')
	END)
	from Orders o
	inner join OrderItems oi on o.OrderId = oi.OrderId
	inner join OrderItemDetails oid on oi.OrderItemId = oid.OrderItemId
	inner join Products p on oi.ProductId = p.ProductId
	inner join ARC a on o.ARC_Code = a.ARC_Code
	where oi.IsCSD = 1 and o.OrderNo = @OrderNo and p.ProductType = 'Product'
	AND o.OrderStatusId = '5' 
	
	--Update OrderItemStatus to 'Marked for Complete' for CSD orders
	update oi
	set oi.OrderItemStatusId = '18'
	from Orders o
	left join OrderItems oi on o.OrderId = oi.OrderId
	left join OrderItemDetails oid on oi.OrderItemId = oid.OrderItemId
	inner join Products p on oi.ProductId = p.ProductId
	where oi.IsCSD = 1 and o.OrderNo = @OrderNo and p.ProductType = 'Product'
	AND o.OrderStatusId = '5' 

	--Update OrderStatus to 'Part Processed' for CSD orders where OrderItemStatus is 'Marked for Complete' or 'Processed'
	update o
	set o.OrderStatusId = '15'
	from Orders o
	inner join OrderItems ois on o.OrderId = ois.OrderId
	where o.OrderNo = @OrderNo and ois.IsCSD = 1 and exists (select OrderItemId from OrderItems oi
	inner join Products p on oi.ProductId = p.ProductId where o.OrderId = oi.OrderId
	and p.ProductType = 'Product' and oi.OrderItemStatusId in ('18','14'))
	AND o.OrderStatusId = '5'  
	
	--Update OrderStatus to 'Processed' for orders where OrderStatus is 'Part Processed' and all Products in order has been provided with ICCID
	update o
	set o.OrderStatusId = '14'
	from Orders o
	inner join OrderItems ois on o.OrderId = ois.OrderId
	where o.OrderNo = @OrderNo and ois.IsCSD = 1 and not exists (select OrderItemId from OrderItems oi
	inner join Products p on oi.ProductId = p.ProductId where o.OrderId = oi.OrderId
	and p.ProductType = 'Product' and oi.OrderItemStatusId not in ('18','14','13'))
	and o.OrderStatusId = '15'
	
	--Update OrderStatus to 'Processed' for orders where OrderStatus is 'Warehouse_Processing' and order contains only Ancillaries
	update o
	set o.OrderStatusId = '14'
	from Orders o
	where o.OrderNo = @OrderNo and not exists (select OrderItemId from OrderItems oi
	inner join Products p on oi.ProductId = p.ProductId where o.OrderId = oi.OrderId
	and p.ProductType = 'Product') and o.OrderStatusId = '5' 

	declare @ReturnStatus int 
	select @ReturnStatus = OrderStatusId from Orders where OrderNo = @OrderNo
	Return @ReturnStatus
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateARCCodeInOrder]    Script Date: 12/14/2015 17:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Alex Papayianni>
-- Create date: <21/11/2014>
-- Description:	<Update ARC code>
-- =============================================
CREATE PROCEDURE [dbo].[USP_UpdateARCCodeInOrder]
	@ARC_Code nvarchar(100),
	@ARCID int
AS
BEGIN
	UPDATE ORDERS
	SET ARC_Code = @ARC_Code
	WHERE ARCId = @ARCID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Sync_BOS_Ordering_ARC]    Script Date: 12/14/2015 17:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_Sync_BOS_Ordering_ARC]  
as begin 

Merge Arc_Ordering.dbo.ARC as Live_ARC  
using
(
select ARC_Code collate Latin1_General_CI_AS ARC_Code, ARC_Description
, ARC_Loc_Address1, ARC_Loc_Address2, ARC_Loc_Post_Code,
ARC_Loc_City, ARC_Loc_County, ARC_CP_Name, ARC_CP_Designation, ARC_CP_Email, 
ARC_CP_Telephone, ARC_CP_Fax, ARC_Polling_Frequency, ARC_PollingChannel,
ARC_Polling_Lag, ARC_Active, ARC_AdminManager_Name, ARC_AdminManager_Designation,
ARC_AdminManager_Email, ARC_AdminManager_Telephone, ARC_AdminManager_Mobile,
ARC_TechnicalManager_Name, ARC_TechnicalManager_Designation, ARC_TechnicalManager_Email,
ARC_TechnicalManager_Telephone, ARC_TechnicalManager_Mobile, ARC_FastFormatFlag,
ARC_ModifiedBy, ARC_LastModified, ARC_UpdatedBy, ARC_LastUpdated,Arc_uniqueCode
from [BOS].Dualcom_Final.dbo.ARC where Arc_Code not like '%G5' and Arc_Active = 1 and Arc_Code = 'CTSL'
) Final_ARC
on Live_ARC.ARC_Code  = Final_ARC.ARC_Code 
when not matched then 
insert ([CompanyName]
      ,[ARC_Code]
      ,[PrimaryContact]
      ,[ARC_Email]
      ,[Telephone]
      ,[Fax]
      ,[AddressOne]
      ,[AddressTwo]
      ,[Town]
      ,[PostCode]
      ,[County]
      ,[Country]     
      ,[AnnualBilling]
      ,[AllowReturns]
      ,[PostingOption]
      ,[IsDeleted]
      ,[IsBulkUploadAllowed]
      ,[IsAPIAccess]
      ,[SalesLedgerNo]
      ,[ProductOptionId]
      ,[ARC_CCEmail]
      ,[PolltoEIRE]
      ,[UNiqueCode]
      ,[ArcTypeId]
      ,[Description])
values( Final_ARC.ARC_Description,
Final_ARC.ARC_Code,
Final_ARC.ARC_CP_Name,
Final_ARC.[ARC_CP_Email],
Final_ARC.ARC_CP_Telephone,
Final_ARC.ARC_CP_Fax,
Final_ARC.ARC_Loc_Address1,
Final_ARC.ARC_Loc_Address2,
Final_ARC.ARC_Loc_City,
Final_ARC.ARC_Loc_Post_Code,
Final_ARC.ARC_Loc_County,''
,0 --,[AnnualBilling]
,0 -- ,[AllowReturns]
,0 -- ,[PostingOption]
,0 --,[IsDeleted]
,1 -- ,[IsBulkUploadAllowed]
,1 --,[IsAPIAccess]
,Final_ARC.ARC_Code --,[SalesLedgerNo]
,4 -- ,[ProductOptionId]
,Final_ARC.ARC_CP_Email --,[ARC_CCEmail]
,0 --,[PolltoEIRE]
,Arc_uniqueCode --,[UNiqueCode]
,1 --,[ArcTypeId]
,''
);





end
GO
/****** Object:  StoredProcedure [dbo].[USP_SaveUniqueCode]    Script Date: 12/14/2015 17:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Alex Papayianni>
-- Create date: <20/11/2014>
-- Description:	<Update unique code>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SaveUniqueCode]
	@UniqueCode nvarchar(512),
	@ARCID int
AS
BEGIN
	UPDATE ARC
	SET UNiqueCode = @UniqueCode
	WHERE ARCId = @ARCID
END
GO
/****** Object:  View [dbo].[vw_ARC_Products]    Script Date: 12/14/2015 17:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ARC_Products]
AS
SELECT     dbo.ARC.ARCId, dbo.ARC.CompanyName, dbo.ARC.ARC_Code, dbo.ARC.ISAllowedCSD, dbo.ARC.UNiqueCode, dbo.ARC.PolltoEIRE, dbo.ARC.PostCode, 
                      dbo.ARC.County, dbo.ARC.Country, dbo.ARC.IsDeleted, dbo.Products.ProductCode, dbo.Products.ProductName, dbo.Products.IsDeleted AS Expr1, 
                      dbo.Products.ProductType, dbo.Products.IsDependentProduct, dbo.Products.Price, dbo.Products.CSL_Grade, dbo.Products.IsSiteName, dbo.Products.IsReplenishment,
                       dbo.Products.CSLDescription, dbo.Products.ProductId
FROM         dbo.ARC INNER JOIN
                      dbo.Product_ARC_Map ON dbo.ARC.ARCId = dbo.Product_ARC_Map.ARCId INNER JOIN
                      dbo.Products ON dbo.Product_ARC_Map.ProductId = dbo.Products.ProductId
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ARC"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 341
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Product_ARC_Map"
            Begin Extent = 
               Top = 6
               Left = 263
               Bottom = 189
               Right = 452
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Products"
            Begin Extent = 
               Top = 6
               Left = 490
               Bottom = 274
               Right = 678
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_ARC_Products'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_ARC_Products'
GO
/****** Object:  View [dbo].[vw_AllCompanies]    Script Date: 12/14/2015 17:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_AllCompanies] 


AS
 

 select   ISNULL(ROW_NUMBER() OVER (ORDER BY t.UniqueCode), - 9999) AS id, t.UniqueCode,t.CompanyID,t.CompanyName from 
 (
	SELECT        dbo.Installer.UniqueCode,InstallerCompanyID as CompanyID,CompanyName collate SQL_Latin1_General_CP1_CI_AS as CompanyName  FROM        dbo.Installer 
	WHERE IsActive = 1 
	union all
	SELECT        dbo.M2MCompany.UniqueCode,M2MCompanyID as CompanyID,CompanyName FROM            dbo.M2MCompany  
	union all
	SELECT        dbo.ARC.UniqueCode,null as CompanyID,CompanyName FROM            dbo.ARC 
)as t
GO
/****** Object:  View [dbo].[vw_ActiveICCIDs]    Script Date: 12/14/2015 17:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ActiveICCIDs]
AS
	SELECT ISNULL(OrderitemdetailsCSD.ICCID,OrderitemdetailsCSD.PSTNNO) AS ICCID 
	FROM Orderitemdetails OrderitemdetailsCSD 
	INNER JOIN ORDERITEMS ORDERITEMSCSD on OrderitemdetailsCSD.OrderITEMID = ORDERITEMSCSD.OrderITEMID
	INNER JOIN ORders OrdersCSD ON ORDERITEMSCSD.OrderID = OrdersCSD.OrderID 
	WHERE (ORDERITEMSCSD.ISCSD = 1 OR ORDERITEMSCSD.ISReplenishment = 0  ) 
	AND ORDERSTATUSID not in (1,7,13,20) 
	AND ORDERITEMSTATUSID not in (7,13) 
	AND ISNULL(nullif(OrderitemdetailsCSD.ICCID,''),nullif(OrderitemdetailsCSD.PSTNNO,'')) is NOT NULL
GO
/****** Object:  StoredProcedure [dbo].[USP_UploadOrderProduct_BkUp30042015]    Script Date: 12/14/2015 17:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_UploadOrderProduct_BkUp30042015]      
(      
 @ProductCode NVarchar(20),      
 @GPRSChipNo NVarchar(50),      
 @GPRSNoPostCode NVarchar(50),      
 @ARC_Id int,      
 @OrderId int,      
 @IsARC_AllowReturns bit,      
 @UserId NVarchar(256) ,  
 @PSTNNo NVARCHAR(50)='',  
 @OptionId INT=0,
 @IsCSD BIT=0,
 @IsReplenishment BIT =0,
 @SiteName VARCHAR(256)=''     
)      
AS      
BEGIN TRY       
BEGIN      
 Declare @ProductId int      
 Declare @CategoryId int      
 Declare @IsGPRSChipEmpty bit      
 Declare @ProductPrice Decimal(6,2)      
 Declare @OrderItemDetailId int      
 Declare @OrderItemId int      
 Declare @DependentProductId int      
 Declare @DependentProductPrice Decimal(6,2)      
 Declare @DependentProductPriceTotal Decimal(6,2)      
 Declare @DependentOrderItemId int      
 DECLARE @GetDependentProducts CURSOR      
      
 Select @ProductId = ProductId From Products Where ProductCode = @ProductCode And IsDeleted = 0      
 Set @DependentProductPriceTotal = 0      
       
 DECLARE @Result NVarchar(256)      
 DECLARE @IsAnyDuplicate bit      
 Set @Result = 'Error - some logic is missing.'      
 Set @IsAnyDuplicate = 0      
      
 IF @ProductId IS NULL      
  BEGIN      
   Set @Result = 'Product does not exist in the System.'      
  END      
 ELSE IF Not Exists (Select Product_ARC_MapId From Product_ARC_Map Where ProductId = @ProductId AND ARCId = @ARC_Id)      
  BEGIN      
   Set @Result = 'ARC not allowed to order this product.'      
  END      
 ELSE      
  BEGIN      
   Select Top 1 @CategoryId = cpm.CategoryId, @IsGPRSChipEmpty = cat.IsGPRSChipEmpty       
   From       
   Category_Product_Map cpm      
   Inner Join       
   Category cat on cat.CategoryId = cpm.CategoryId AND cpm.ProductId = @ProductId      
   Order by IsGPRSChipEmpty      
      
   IF @IsGPRSChipEmpty = 0 AND @GPRSChipNo = ''      
    BEGIN      
     Set @Result = 'Empty Chip Number is not allowed'      
    END      
   ELSE      
    BEGIN      
     SET @ProductPrice = (Select case IsNull(t.ARC_Price,0) when 0 then t.Price else t.ARC_Price end as Price      
           from      
           (Select p.ProductId, p.Price, ppm.Price as ARC_Price      
           from       
           Products p           
           left join      
           ARC_Product_Price_Map ppm on ppm.ProductId = p.ProductId and DATEDIFF(d,isnull(ppm.ExpiryDate,getdate()),GETDATE())>0 And ppm.IsDeleted=0       
           Where p.IsDependentProduct = 0 And p.IsDeleted=0 And p.ProductId = @ProductId      
          ) t )      
                
     IF  @ProductPrice IS Null       
      BEGIN      
       SET @ProductPrice = 0      
      END          
      
     Select @OrderItemId = OrderItemId From OrderItems Where OrderId = @OrderId And ProductId = @ProductId And CategoryId = @CategoryId      
     IF @OrderItemId Is Null      
      BEGIN      
       Insert Into OrderItems (OrderId, ProductId, ProductQty, Price, OrderItemStatusId, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy, CategoryId,IsReplenishment,IsCSD)      
           Values(@OrderId, @ProductId, 1, @ProductPrice, 1, GETDATE(), @UserId, GETDATE(), @UserId, @CategoryId,@IsReplenishment,@IsCSD)      
             
       Select @OrderItemId = SCOPE_IDENTITY()      
                 
       SET @GetDependentProducts = CURSOR FOR      
       SELECT t.ProductId, CASE IsNull(t.ARC_Price,0) WHEN 0 THEN t.Price ELSE t.ARC_Price END AS Price      
        FROM      
        (SELECT p.ProductId, p.Price, ppm.Price AS ARC_Price      
         FROM Products p      
         left join      
         ARC_Product_Price_Map ppm ON ppm.ProductId = p.ProductId and DATEDIFF(d,isnull(ppm.ExpiryDate,getdate()),GETDATE())>0 And ppm.IsDeleted=0      
         WHERE p.IsDeleted=0 and p.ProductId in      
          (SELECT pdm.DependentProductId FROM Product_Dependent_Map pdm WHERE pdm.ProductId = @ProductId)      
        ) t      
      
       OPEN @GetDependentProducts      
            
 FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice      
       WHILE @@FETCH_STATUS = 0      
        BEGIN       
         SET @DependentProductPriceTotal = @DependentProductPriceTotal + @DependentProductPrice      
                  
         INSERT INTO OrderDependentItems (OrderId, OrderItemId, ProductId, ProductQty, Price)      
              VALUES(@OrderId, @OrderItemId, @DependentProductId, 1, @DependentProductPrice)      
         FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice       
        END      
      
       CLOSE @GetDependentProducts      
       DEALLOCATE @GetDependentProducts      
             
       Update Orders Set OrderDate = GETDATE()      
            , Amount = Amount + @ProductPrice + @DependentProductPriceTotal      
            , ModifiedOn = GETDATE()      
            , ModifiedBy = @UserId      
           Where OrderId = @OrderId      
             
       Insert into OrderItemDetails(OrderItemId, GPRSNo, ModifiedOn, ModifiedBy, GPRSNoPostCode,PSTNNo,OptionId,SiteName)      
            Values (@OrderItemId, @GPRSChipNo, GETDATE(), @UserId, @GPRSNoPostCode,@PSTNNo,@OptionId,@SiteName)      
             
       Set @Result = 'Success'      
      END      
     ELSE      
      BEGIN      
       IF @IsARC_AllowReturns = 1      
        BEGIN      
         IF @GPRSChipNo != '' And Exists (Select OrderItemDetailId From OrderItemDetails Where GPRSNo = @GPRSChipNo)      
          BEGIN      
           Set @IsAnyDuplicate = 1      
          END      
                
           Insert into OrderItemDetails(OrderItemId, GPRSNo, ModifiedOn, ModifiedBy, GPRSNoPostCode,PSTNNo,OptionId,SiteName)      
                Values (@OrderItemId, @GPRSChipNo, GETDATE(), @UserId, @GPRSNoPostCode,@PSTNNo,@OptionId,@SiteName)      
               
           Select @OrderItemDetailId = SCOPE_IDENTITY()      
                 
           Update OrderItems      
            Set ProductQty = ProductQty + 1,      
             Price = @ProductPrice,      
             ModifiedOn = GETDATE(),      
             ModifiedBy = @UserId,      
             CategoryId = @CategoryId      
            Where       
             OrderId = @OrderId       
             And ProductId = @ProductId       
             And CategoryId = @CategoryId      
                   
                 
           SET @GetDependentProducts = CURSOR FOR      
           SELECT t.ProductId, CASE IsNull(t.ARC_Price,0) WHEN 0 THEN t.Price ELSE t.ARC_Price END AS Price      
            FROM      
            (SELECT p.ProductId, p.Price, ppm.Price AS ARC_Price      
             FROM Products p      
             left join      
             ARC_Product_Price_Map ppm ON ppm.ProductId = p.ProductId and DATEDIFF(d,isnull(ppm.ExpiryDate,getdate()),GETDATE())>0 And ppm.IsDeleted=0      
             WHERE p.IsDeleted=0 and p.ProductId in      
              (SELECT pdm.DependentProductId FROM Product_Dependent_Map pdm WHERE pdm.ProductId = @ProductId)      
            ) t      
      
           OPEN @GetDependentProducts      
                
           FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice      
           WHILE @@FETCH_STATUS = 0      
            BEGIN       
             SET @DependentProductPriceTotal = @DependentProductPriceTotal + @DependentProductPrice      
                   
             IF Exists (Select OrderDependentId From OrderDependentItems Where OrderId = @OrderId And ProductId = @DependentProductId)      
              BEGIN      
               Update OrderDependentItems      
                Set ProductQty = ProductQty + 1      
                 , Price = @DependentProductPrice      
                Where OrderId = @OrderId      
                  And ProductId = @DependentProductId      
              END      
             ELSE      
              BEGIN 
               Insert Into OrderDependentItems (OrderId, OrderItemId, ProductId, ProductQty, Price)      
                      VALUES(@OrderId, @OrderItemId, @DependentProductId, 1, @DependentProductPrice)      
              END      
             FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice       
          END      
      
           CLOSE @GetDependentProducts      
           DEALLOCATE @GetDependentProducts      
             
           Update Orders Set OrderDate = GETDATE()      
                , Amount = Amount + @ProductPrice + @DependentProductPriceTotal      
                , ModifiedOn = GETDATE()      
                , ModifiedBy = @UserId      
               Where OrderId = @OrderId      
                        
           Set @Result = 'Success'       
          END              
       ELSE      
        --BEGIN                  
        -- IF @GPRSChipNo != '' And Exists (Select OrderItemDetailId From OrderItemDetails Where GPRSNo = @GPRSChipNo)      
        --  BEGIN      
        --   Set @Result = 'Duplicate Chip Number is not allowed.'      
        --  END      
        -- ELSE      
          BEGIN      
           Insert into OrderItemDetails(OrderItemId, GPRSNo, ModifiedOn, ModifiedBy, GPRSNoPostCode,PSTNNo,OptionId,SiteName)      
                Values (@OrderItemId, @GPRSChipNo, GETDATE(), @UserId, @GPRSNoPostCode,@PSTNNo,@OptionId,@SiteName)      
               
           Select @OrderItemDetailId = SCOPE_IDENTITY()      
                 
           Update OrderItems      
            Set ProductQty = ProductQty + 1,      
             Price = @ProductPrice,      
             ModifiedOn = GETDATE(),      
             ModifiedBy = @UserId,      
             CategoryId = @CategoryId      
            Where       
             OrderId = @OrderId       
             And ProductId = @ProductId       
             And CategoryId = @CategoryId      
                   
                 
           SET @GetDependentProducts = CURSOR FOR      
           SELECT t.ProductId, CASE IsNull(t.ARC_Price,0) WHEN 0 THEN t.Price ELSE t.ARC_Price END AS Price      
            FROM      
            (SELECT p.ProductId, p.Price, ppm.Price AS ARC_Price      
             FROM Products p      
             left join      
             ARC_Product_Price_Map ppm ON ppm.ProductId = p.ProductId and DATEDIFF(d,isnull(ppm.ExpiryDate,getdate()),GETDATE())>0 And ppm.IsDeleted=0      
             WHERE p.IsDeleted=0 and p.ProductId in      
              (SELECT pdm.DependentProductId FROM Product_Dependent_Map pdm WHERE pdm.ProductId = @ProductId)      
            ) t      
      
           OPEN @GetDependentProducts      
                
           FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice      
           WHILE @@FETCH_STATUS = 0      
            BEGIN       
             SET @DependentProductPriceTotal = @DependentProductPriceTotal + @DependentProductPrice      
                   
             IF Exists (Select OrderDependentId From OrderDependentItems Where OrderId = @OrderId And ProductId = @DependentProductId)      
              BEGIN      
               Update OrderDependentItems      
                Set ProductQty = ProductQty + 1      
                 , Price = @DependentProductPrice      
                Where OrderId = @OrderId      
                  And ProductId = @DependentProductId      
              END      
             ELSE      
              BEGIN      
               Insert Into OrderDependentItems (OrderId, OrderItemId, ProductId, ProductQty, Price)      
                      VALUES(@OrderId, @OrderItemId, @DependentProductId, 1, @DependentProductPrice)      
              END  
             FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice       
            END      
      
           CLOSE @GetDependentProducts      
           DEALLOCATE @GetDependentProducts      
             
           Update Orders Set OrderDate = GETDATE()      
                , Amount = Amount + @ProductPrice + @DependentProductPriceTotal      
                , ModifiedOn = GETDATE()      
                , ModifiedBy = @UserId      
               Where OrderId = @OrderId      
                        
           Set @Result = 'Success'      
          END              
        END      
      END       
    END      
  END       
       
 Select @Result as ResultMessage, @IsAnyDuplicate as IsAnyDuplicate      
--END      
END TRY       
BEGIN CATCH      
EXEC USP_SaveSPErrorDetails      
RETURN -1        
END CATCH
GO
/****** Object:  View [dbo].[vw_CSLConnectOrders]    Script Date: 12/14/2015 17:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_CSLConnectOrders]
AS
SELECT     TOP (100) PERCENT dbo.Orders.OrderId, dbo.Orders.OrderNo, dbo.Orders.OrderRefNo, dbo.Orders.OrderDate, dbo.OrderStatusMaster.OrderStatus, 
                      dbo.Orders.Amount, dbo.Orders.VATRate, dbo.Orders.DeliveryCost, dbo.Orders.OrderTotalAmount, dbo.PaymentTransaction.AuthCode, 
                      dbo.PaymentTransaction.Amount AS RBSAmt, dbo.PaymentTransaction.CreatedOn AS PaymentTransactionDate, dbo.PaymentTransaction.futurePayId, 
                      dbo.OrderItemDetails.ICCID, dbo.Products.ProductCode, dbo.Products.ProductName, dbo.VW_InstallerDetails.CompanyName, dbo.VW_InstallerDetails.AddressOne, 
                      dbo.VW_InstallerDetails.AddressTwo, dbo.VW_InstallerDetails.Town, dbo.VW_InstallerDetails.County, dbo.VW_InstallerDetails.PostCode, 
                      dbo.VW_InstallerDetails.SalesRep, dbo.Installer.IsCreditAllowed, dbo.BillingCycle.Description, dbo.Orders.InitialPayment, dbo.Orders.MonthlyPayment, 
                      dbo.Orders.UserName, dbo.Orders.SpecialInstructions, dbo.Orders.ProcessedOn, dbo.Orders.ProcessedBy, dbo.Orders.OrderType, dbo.OrderItems.OrderItemStatusId, 
                      dbo.Orders.OrderStatusId, dbo.Device_API.Dev_IMSINumber, dbo.Device_API.Dev_IP_Address, dbo.Device_API.Dev_MSISDN
FROM         dbo.Device_API RIGHT OUTER JOIN
                      dbo.Orders INNER JOIN
                      dbo.OrderItems ON dbo.Orders.OrderId = dbo.OrderItems.OrderId INNER JOIN
                      dbo.OrderItemDetails ON dbo.OrderItems.OrderItemId = dbo.OrderItemDetails.OrderItemId INNER JOIN
                      dbo.Products ON dbo.OrderItems.ProductId = dbo.Products.ProductId INNER JOIN
                      dbo.OrderStatusMaster ON dbo.Orders.OrderStatusId = dbo.OrderStatusMaster.OrderStatusId INNER JOIN
                      dbo.BillingCycle ON dbo.Orders.BillingCycleID = dbo.BillingCycle.ID ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID LEFT OUTER JOIN
                      dbo.PaymentTransaction ON dbo.Orders.OrderId = dbo.PaymentTransaction.OrderID LEFT OUTER JOIN
                      dbo.Installer INNER JOIN
                      dbo.VW_InstallerDetails ON dbo.Installer.InstallerCompanyID = dbo.VW_InstallerDetails.InstallerCompanyID ON 
                      dbo.Orders.InstallerUnqCode = dbo.VW_InstallerDetails.UniqueCode
WHERE     (dbo.Orders.ARCId = 0) AND (dbo.OrderItems.OrderItemStatusId <> 13) AND (dbo.Orders.OrderType = 2)
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[55] 4[6] 2[8] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Installer"
            Begin Extent = 
               Top = 46
               Left = 1354
               Bottom = 357
               Right = 1538
            End
            DisplayFlags = 280
            TopColumn = 7
         End
         Begin Table = "VW_InstallerDetails"
            Begin Extent = 
               Top = 22
               Left = 1085
               Bottom = 216
               Right = 1269
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "Orders"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 426
               Right = 261
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "OrderItems"
            Begin Extent = 
               Top = 15
               Left = 402
               Bottom = 134
               Right = 602
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "OrderItemDetails"
            Begin Extent = 
               Top = 255
               Left = 744
               Bottom = 601
               Right = 953
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "PaymentTransaction"
            Begin Extent = 
               Top = 239
               Left = 1091
               Bottom = 436
               Right = 1261
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Products"
            Begin Extent = 
               Top = 64
               Left = 792
               Bottom = 183
               Right = 980
       ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_CSLConnectOrders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'     End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrderStatusMaster"
            Begin Extent = 
               Top = 221
               Left = 498
               Bottom = 389
               Right = 699
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BillingCycle"
            Begin Extent = 
               Top = 318
               Left = 324
               Bottom = 407
               Right = 484
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Device_API"
            Begin Extent = 
               Top = 332
               Left = 1048
               Bottom = 556
               Right = 1255
            End
            DisplayFlags = 280
            TopColumn = 7
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 34
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2235
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2190
         Alias = 2040
         Table = 1695
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_CSLConnectOrders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_CSLConnectOrders'
GO
/****** Object:  View [dbo].[vw_DespatchLog]    Script Date: 12/14/2015 17:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_DespatchLog]
AS
SELECT     dbo.Orders.DeliveryNoteNo, dbo.OrderItemDetails.ItemDlvNoteNo, dbo.Orders.SalesReply AS SalesRep, dbo.ARC.CompanyName, dbo.ARC.ARC_Code, 
                      dbo.Products.ProductCode, dbo.OrderItemDetails.GPRSNo, dbo.OrderItemDetails.ICCID, isnull(dbo.Device_API.Data_number,dbo.OrderItemDetails.DataNo) as DataNo, dbo.Device_API.Dev_IP_Address AS IPAddress, 
                      dbo.Installer.InstallerCode, dbo.Installer.UniqueCode, dbo.Orders.OrderDate,
                          (SELECT     TOP (1) MasterGrade
                            FROM          dbo.GradeMap2Master
                            WHERE      (BOSGrade IN
                                                       (SELECT     TOP (1) Dev_Grade
                                                         FROM          dbo.Device_Grade
                                                         WHERE      (Product_Code LIKE '%' + dbo.Products.ProductCode + '%') AND (Dev_PS_Code = dbo.OrderItemDetails.PrServerDetails)))) AS Grade, 
                      dbo.Orders.OrderNo, dbo.Orders.OrderRefNo AS [ARC Ref],
                          (SELECT     TOP (1) Dev_Grade
                            FROM          dbo.Device_Grade AS Device_Grade_1
                            WHERE      (Product_Code LIKE '%' + dbo.Products.ProductCode + '%') AND (Dev_PS_Code = dbo.OrderItemDetails.PrServerDetails)) AS BOS_Grade, 
                      dbo.Orders.ProcessedBy, dbo.Orders.ProcessedOn, dbo.Orders.OrderStatusId, dbo.Device_API.Dev_IMSINumber AS IMSIno, dbo.Products.ProductName, 
                      dbo.Products.IsDependentProduct, dbo.Installer.CompanyName AS InstallerName, dbo.OrderItems.OrderItemStatusId, dbo.Products.ProductId , orderItems.CategoryID
					  ,isnull(IsFOC,0) AS FOC,ISNULL(IsReplacement,0) AS REPLACEMENT, ISNULL(dbo.OrderItems.IsCSD,0) AS CSD, ISNULL(dbo.OrderItems.IsReplenishment,0) AS Replenishment
FROM         dbo.Device_API RIGHT OUTER JOIN
                      dbo.OrderItemDetails ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID RIGHT OUTER JOIN
                      dbo.Orders INNER JOIN
                      dbo.OrderItems ON dbo.Orders.OrderId = dbo.OrderItems.OrderId INNER JOIN
                      dbo.Products ON dbo.OrderItems.ProductId = dbo.Products.ProductId ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId LEFT OUTER JOIN
                      dbo.ARC ON dbo.Orders.ARC_CODE = dbo.ARC.ARC_CODE LEFT OUTER JOIN
                      dbo.Installer ON dbo.Orders.InstallerId = dbo.Installer.InstallerCompanyID
WHERE     (dbo.Products.IsDependentProduct = 0) AND (dbo.OrderItems.OrderItemStatusId <> 13) AND (dbo.OrderItems.IsCSD = 0)
AND Orders.ARC_Code not like 'Q1' -- ** Exclude CareTech
AND Orders.OrderStatusId in (10,19) -- Despatched , Intransit
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[49] 4[27] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Device_API"
            Begin Extent = 
               Top = 168
               Left = 1398
               Bottom = 387
               Right = 1571
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrderItemDetails"
            Begin Extent = 
               Top = 189
               Left = 1102
               Bottom = 475
               Right = 1311
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Orders"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 342
               Right = 237
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrderItems"
            Begin Extent = 
               Top = 6
               Left = 639
               Bottom = 326
               Right = 823
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Products"
            Begin Extent = 
               Top = 3
               Left = 1124
               Bottom = 180
               Right = 1312
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ARC"
            Begin Extent = 
               Top = 138
               Left = 382
               Bottom = 257
               Right = 569
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Installer"
            Begin Extent = 
               Top = 366
               Left = 640
               Bottom = 678
               Right = 824
            End
            ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_DespatchLog'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 22
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3570
         Alias = 960
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_DespatchLog'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_DespatchLog'
GO
/****** Object:  UserDefinedFunction [dbo].[udf_GenerateARC_UniqueCode]    Script Date: 12/14/2015 17:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[udf_GenerateARC_UniqueCode](@newid UNIQUEIDENTIFIER )  RETURNS BIGINT    
   as      
begin    
    
  return (select A.Code from       
    (SELECT  left((cast( CAST( @newid AS BINARY(5)) AS BIGINT)),6)      
    AS Code)A where A.Code NOT IN (select distinct coalesce(BillingAccountNo,0) from ARC))     
        
       
 end
GO
/****** Object:  StoredProcedure [dbo].[GetOrderItemsInvoice]    Script Date: 12/14/2015 17:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetOrderItemsInvoice]  (@orderno NVARCHAR(256))    
AS    
SELECT --distinct
		 Products.ProductCode,    
        Products.ProductName,    
        '1' AS ProductQnty,    
        Case  When OrderItemDetails.GPRSNo is null  then  'N.A'   
        else  OrderItemDetails.GPRSNo end as GPRSNo ,    
		ISNULL(OrderItemDetails.ICCID,'N.A') AS ICCID,
	    ISNULL(Device_API.Data_Number,'N.A') AS DataNo,
        OrderItemDetails.OrderItemId,    
        OrderItemDetails.OrderItemDetailId,  
        Device_API.Dev_IP_Address , ISNULL (OrderItemDetails.IsFOC,0)IsFOC
 FROM   OrderItems    
        INNER JOIN Orders    
             ON  OrderItems.OrderId = Orders.OrderId    
        INNER JOIN Products    
             ON  OrderItems.ProductId = Products.ProductId   
        INNER JOIN Category_Product_Map    
             ON  Products.ProductId = Category_Product_Map.ProductId   
        INNER JOIN OrderItemDetails    
             ON  OrderItems.OrderItemId = OrderItemDetails.OrderItemId   
        INNER JOIN Device_API    
           ON  OrderItemDetails.ICCID = Device_API.Dev_Code  COlLATE SQL_Latin1_General_CP1_CI_AS
                  
 WHERE  (    
            Orders.OrderNo =@orderno 
            AND OrderItems.OrderItemStatusId  IN (18  ,14)   		
           AND OrderItems.CategoryId!=5 --DUALCOM Inside category  
        )
UNION /** FOR DIGIPLUS UNITS - WHICH DO NOT HAVE I.P ADDRESS or DATA NUMBER **/
SELECT --distinct
		 Products.ProductCode,    
        Products.ProductName,    
        '1' AS ProductQnty,    
        Case  When OrderItemDetails.GPRSNo is null  then  'N.A'   
        else  OrderItemDetails.GPRSNo end as GPRSNo ,    
		ISNULL(OrderItemDetails.ICCID,'N.A') AS ICCID,
	    --left(ICCID,12)
		 'N.A' AS DataNo,
        OrderItemDetails.OrderItemId,    
        OrderItemDetails.OrderItemDetailId,  
        '' as Dev_IP_Address , ISNULL (OrderItemDetails.IsFOC,0)IsFOC
 FROM   OrderItems    
        INNER JOIN Orders    
             ON  OrderItems.OrderId = Orders.OrderId    
        INNER JOIN Products    
             ON  OrderItems.ProductId = Products.ProductId   
        INNER JOIN Category_Product_Map    
             ON  Products.ProductId = Category_Product_Map.ProductId   
        INNER JOIN OrderItemDetails    
             ON  OrderItems.OrderItemId = OrderItemDetails.OrderItemId   
                  
 WHERE  (    
             Orders.OrderNo =@orderno 
            AND OrderItems.OrderItemStatusId  IN (18  ,14)   		
           AND OrderItems.CategoryId!=5 --DUALCOM Inside category  
        )
		AND ICCID like '005%'
UNION /** UNION FOR ANCILLARY AS THEY ARE DISPLAYED ON ONE ROW */


SELECT distinct Products.ProductCode,    
        Products.ProductName,    
        CONVERT(VARCHAR, OrderItems.ProductQty) AS ProductQnty,    
        'N.A' as GPRSNo ,    
			'N.A' AS ICCID,
	    'N.A' AS DataNo,
        OrderItems.OrderItemId,    
        MIN(OrderItemDetails.OrderItemDetailId) AS OrderItemDetailId,  -- JUST GET ONE ORDERITEMDETAILID
        '' AS Dev_IP_Address  ,ISNULL(OrderItemDetails.IsFOC,0)IsFOC
         
          
 FROM   OrderItems    
        INNER JOIN Orders    
             ON  OrderItems.OrderId = Orders.OrderId    
        INNER JOIN Products    
             ON  OrderItems.ProductId = Products.ProductId   
        INNER JOIN Category_Product_Map    
             ON  Products.ProductId = Category_Product_Map.ProductId   
		INNER JOIN OrderItemDetails    
             ON  OrderItems.OrderItemId = OrderItemDetails.OrderItemId  
                  
 WHERE  (    
            Orders.OrderNo =@orderno  
            AND (    
                    (oRDERiTEMS.OrderItemStatusId = 1 and Products.Producttype = 'Ancillary' )  
                )   
				
          -- AND OrderItemDetails.IsDlvNoteGenerated  = 0  
           AND OrderItems.CategoryId!=5 --DUALCOM Inside category  
        )
		GROUP BY Products.ProductCode,    
        Products.ProductName,    
        OrderItems.ProductQty,    
       GPRSNo ,    
        OrderItems.OrderItemId,
        OrderItemDetails.IsFOC
GO
/****** Object:  StoredProcedure [dbo].[GetOrderDetailsInvoice]    Script Date: 12/14/2015 17:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[GetOrderDetailsInvoice] (@orderno NVARCHAR(256))          
AS          
  SELECT DISTINCT TOP 1 convert(varchar,convert(datetime,o.OrderDate,3),106) as OrderDate,          
        arc.ARC_Code,            
        arc.Country,            
        o.OrderNo,            
        o.Amount,            
        o.DeliveryCost,            
        o.OrderTotalAmount,           
        o.ProcessedBy, 
      DeliveryNoteNo = Cast(OrderNo as varchar(10)) + '1', 
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
        dlvadr.Mobile AS dlvMobile,       
        dlvadr.Telephone AS dlvTelephone,        
        dlvadr.Town AS dlvTown,         
        insadr.AddressOne AS insaddres,            
        case o.InstallationAddressID when 0 then 'Not Available' else insadr.CompanyName end AS inscompantname,            
        insadr.AddressTwo AS insaddres2,            
        insadr.PostCode AS inspostcode, 
		insadr.ContactName AS insContactName,         
        insadr.Town AS insTown,            
        case dt.DisplayonDeliveryNote when 1 then dt.DeliveryShortDesc  else '' end as DeliveryCompanyName,            
        dt.DeliveryShortDesc,      
        dt.DeliveryTypeId,          
        cm.CountryCode  ,          
        o.OrderRefNo  ,    
       oid.ItemDlvNoteNo ,  
       oi.ProcessedON ,
	   CAST(o.SpecialInstructions AS VARCHAR(1000)) AS SpecialInstructions
       
        
                 
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
        LEFT JOIN OrderItemDetails oid            
             ON  oid.OrderItemId = oi.OrderItemId          
 WHERE  (o.OrderNo = @orderNO) AND ( ISNULL(oi.ProcessedON,0)=(Select ISNULL(MAX(ProcessedON),0) from  OrderItems where orderid=o.OrderId))
GO
/****** Object:  StoredProcedure [dbo].[SP_GetDIOrderITems]    Script Date: 12/14/2015 17:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SP_GetDIOrderITems '2013-12-30 17:21:25.313'
CREATE PROCEDURE [dbo].[SP_GetDIOrderITems]
@Date datetime
AS
BEGIN
	SELECT Orders.OrderDate, Orders.OrderId, OrderItems.ProductId, 1 as QntyDelivered --OrderItems.QntyDelivered
	, OrderItemDetails.PSTNNo, 
	OrderItemDetails.GPRSNo, Orders.ArcId, Orders.ARC_Code, Orders.InstallerId, Orders.InstallerCode,Orders.UserEmail 
	FROM Orders INNER JOIN [OrderItems] ON Orders.OrderId = OrderItems.OrderId 
	inner join OrderItemDetails on OrderItems.OrderItemId = OrderItemDetails.OrderItemId
	WHERE (Orders.OrderStatusId in ( 10,14,15,16,18,19)) AND  ((Orders.OrderDate)>@Date) AND 
	(((OrderItems.ProductId) IN (select * from dbo.split((select KeyValue From ApplicationSetting where KeyName = 'DIProductId'),',')
	)) AND ((Orders.OrderID) Not In (select Distinct(OrderId) from OrderDIConfirmed)))ORDER BY Orders.OrderId DESC 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GenerateOrdersReportByArcCode]    Script Date: 12/14/2015 17:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*CreatedBy: Shyam Gaddam      
              CreatedOn: 26 Th June 2013      
              Purpose: To generate the orders by Arc Code      
                    
                    
              select * from Arc where CompanyName = 'EMCS'      
                    
              SP_GenerateOrdersReportByArcCode '11'       
                  
                  
              select * from Arc where CompanyName like '%csl%'    
                    
                    
              */      
                    
                    
                                
               CREATE Procedure [dbo].[SP_GenerateOrdersReportByArcCode](@Arc_Code varchar(20) ,@Date dateTime = null)      
               as      
               begin         
                     
               --Declare @Date datetime    
                if(@Date is null)      
                begin      
                      
                set @Date = GETDATE()    
                      
                end      
                                              
                            select f.CompanyName Arc_Name, OrderNo as CSL_OrderNo,OrderRefNo ARC_OrderRef,      
                                  
                           CONVERT(varchar(10),OrderDate,103)+' '+CONVERT(varchar(10),OrderDate,108) OrderDate,      
                                  
                            DeliveryCost DeliveryTotal,cast(OrderTotalAmount as varchar) OrderTotal,      
                            e.CompanyName Installer,InstallerContactName,      
                            GPRSNo as GPRS_ChipNo, ProductCode, coalesce(ProductName,'')   Title,                                 
                            ProductQty,      
                                  
                            coalesce((select top 1 AddressOne +', '+ AddressTwo+', '+ Town+', '+ County+', '+PostCode from Address where AddressID = a.InstallationAddressID),'') InstallationAddress,      
                            coalesce( (select top 1 AddressOne +', '+ AddressTwo+', '+ Town+', '+ County+', '+PostCode from Address where AddressID = a.DeliveryAddressId ),'') DeliveryAddress      
                             from Orders a       
                            inner join                                   
                           OrderItems b on a.OrderId = b.OrderId                                  
                           left outer join       
                                 
                           (       
                            select OrderItemID,stuff((select ', '+ GPRSNo from  OrderItemDetails b where b.OrderItemId = a.OrderItemId for XML PATH('')), 1, 2, '') GPRSNo                       
                        
                    from OrderItemDetails a  group by OrderItemID)      
                            c on b.OrderItemId= c.OrderItemId       
                             INNER JOIN Products d ON b.ProductId = d.ProductId      
                              INNER JOIN Installer e ON a.InstallerCode collate Latin1_General_CI_AS  = e.InstallerCode  collate Latin1_General_CI_AS      
                              inner join ARC f on a.ARC_Code = f.ARC_Code       
                                   
                                  
                            where a.OrderStatusId <> 1 and CONVERT(varchar(10),OrderDate,120) =  CONVERT(varchar(10),@Date,120)  and a.ARC_Code =  @Arc_Code order by OrderDate       
                                  
                            end
GO
/****** Object:  StoredProcedure [dbo].[GetOfferData]    Script Date: 12/14/2015 17:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetOfferData]
@dlvtypeid int  
  
As  
BEGIN TRY   
BEGIN  
  
select dl.DeliveryOfferId,ISNULL(p.ProductId,-1) as ProductId,dl.DeliveryTypeId, dl.OrderValue, dl.ARCId,  
 dl.MaxQty, dl.MinQty,   
 ARCDisp = isnull('['+ a.ARC_Code+ '] - ','')  + isnull(a.CompanyName,''),  
  isnull('[' +p.ProductCode + '] - ','') + isnull(p.ProductName,'')  AS ProductDisp,  
  case isnull(dl.ProductId,-1) when -1 then 0 else 1 end  AS CanCreateSibblings, 
  i.CompanyName AS InstallerCompany
   from DeliveryOffers dl  
left join ARC a on dl.ARCId=a.ARCId  
left join Products p on dl.ProductId=p.ProductId  
LEFT JOIN Installer i ON dl.InstallerCompanyID=i.InstallerCompanyID
where DeliveryTypeId=@dlvtypeid


 
  
END  
END TRY   
BEGIN CATCH   
EXEC USP_SaveSPErrorDetails  
RETURN -1   
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_SaveOrderItemsFromPortal]    Script Date: 12/14/2015 17:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SaveOrderItemsFromPortal] 
(
    @OrderId     INT,
    @ProductId   INT,
    @ProductQty  INT,
    @UserId      UNIQUEIDENTIFIER,
    @CreatedBy   VARCHAR(256),
    @CategoryId  INT,
    @Foc         BIT
)
AS
BEGIN TRY
    BEGIN
        DECLARE @OrderItemId INT            
        DECLARE @OrderItemTotalPrice DECIMAL(8, 2)            
        DECLARE @Price DECIMAL(8, 2)            
        DECLARE @ARC_Id INT            
        DECLARE @OrderItemPrice DECIMAL(8, 2)            
        DECLARE @OrderItemQty INT              
        DECLARE @OldOrderDependentItemPrice DECIMAL(8, 2)             
        DECLARE @DependentProductId INT            
        DECLARE @DependentProductPrice DECIMAL(8, 2)            
        DECLARE @DependentProductPriceTotal DECIMAL(8, 2)            
         DECLARE @tot INT
            SET @tot = 1
        
        SELECT @OrderItemQty = ProductQty
        FROM   OrderItems
        WHERE  OrderId = @OrderId
               AND ProductId = @ProductId
               AND CategoryId = @CategoryId          
        
        SET @OrderItemQty = ISNULL(@OrderItemQty, 0) 
        
        --IF @OrderItemQty != @ProductQty
        --BEGIN          
        SELECT @ARC_Id = ARCId
        FROM   ARC_User_Map
        WHERE  UserId = @UserId          
        
        SELECT @Price = CASE ISNULL(t.ARC_Price, 0)
                             WHEN 0 THEN t.Price
                             ELSE t.ARC_Price
                        END
        FROM   (
                   SELECT p.ProductId,
                          p.ProductCode,
                          p.ProductName,
                          p.DefaultImage,
                          p.ProductType,
                          p.Price,
                          ppm.Price AS ARC_Price
                   FROM   Products p
                          LEFT JOIN ARC_Product_Price_Map ppm
                               ON  ppm.ProductId = p.ProductId
                               AND DATEDIFF(d, ISNULL(ppm.ExpiryDate, GETDATE()), GETDATE()) 
                                   > 0
                               AND ppm.ARCId = @ARC_Id
                               AND ppm.IsDeleted = 0
                   WHERE  p.ProductId = @ProductId
               ) t            
        
        SET @OrderItemTotalPrice = @Price * @ProductQty            
        
        DECLARE @tempDependentProduct TABLE (ProductId INT, Price DECIMAL(6, 2))
        
        -- Get product's dependent products into a temp table ---> 
        INSERT INTO @tempDependentProduct
          (
            ProductId,
            Price
          )
        SELECT t.ProductId,
               CASE ISNULL(t.ARC_Price, 0)
                    WHEN 0 THEN t.Price
                    ELSE t.ARC_Price
               END AS Price
        FROM   (
                   SELECT p.ProductId,
                          p.Price,
                          ppm.Price AS ARC_Price
                   FROM   Products p
                          LEFT JOIN ARC_Product_Price_Map ppm
                               ON  ppm.ProductId = p.ProductId
                               AND DATEDIFF(d, ISNULL(ppm.ExpiryDate, GETDATE()), GETDATE()) 
                                   > 0
                               AND ppm.IsDeleted = 0
                   WHERE  p.IsDeleted = 0
                          AND p.ProductId IN (SELECT pdm.DependentProductId
                                              FROM   Product_Dependent_Map 
                                                     pdm
                                              WHERE  pdm.ProductId = @ProductId)
               ) t 
        --<--- End temp table 
        
        
        --IF NOT EXISTS (
        --       SELECT OrderItemId
        --       FROM   OrderItems
        --       WHERE  OrderId = @OrderId
        --              AND ProductId = @ProductId
       --              AND CategoryId = @CategoryId
        --   )
        BEGIN
            INSERT INTO OrderItems
              (
                OrderId,
                ProductId,
                ProductQty,
                Price,
                OrderItemStatusId,
                CreatedOn,
                CreatedBy,
                ModifiedOn,
                ModifiedBy,
                CategoryId,
				IsCSD,
                IsNewItem
              )
            VALUES
              (
                @OrderId,
                @ProductId,
                @ProductQty,
                @Price,
                1,
                GETDATE(),
                @CreatedBy,
                GETDATE(),
                @CreatedBy,
                @CategoryId,
				0,
                1
              )            
            
            SELECT @OrderItemId = SCOPE_IDENTITY() 
            
            /* This code is added to include the dependent product details */            
            SET @DependentProductPriceTotal = 0 
            
            
            
            
            IF EXISTS (
                   SELECT 1
                   FROM   @tempDependentProduct
               )
            BEGIN
                SELECT @DependentProductPriceTotal = SUM(Price) * @ProductQty
                FROM   @tempDependentProduct
                
                INSERT INTO OrderDependentItems
                  (
                    OrderId,
                    OrderItemId,
                    ProductId,
                    ProductQty,
                    Price
                  )
                SELECT @OrderId,
                       @OrderItemId,
                       tdp.ProductId,
                       @ProductQty,
                       tdp.Price
                FROM   @tempDependentProduct tdp
            END 
            /* end - dependent product details*/               
            
            UPDATE Orders
            SET    OrderDate = GETDATE(),
                   Amount = Amount + @OrderItemTotalPrice + @DependentProductPriceTotal,
                   ModifiedBy = @CreatedBy,
                   ModifiedOn = GETDATE()
            WHERE  OrderId = @OrderId
            
             WHILE (@tot <= @ProductQty)
            BEGIN
                INSERT INTO 
                       OrderItemDetails
                  (
                    OrderItemId,
                    ModifiedOn,
                    ModifiedBy,
                    IsFOC
                  )
                VALUES
                  (
                    @OrderItemId,
                    GETDATE(),
                    @CreatedBy,
                    @Foc
                  )
                 
                SET @tot = @tot + 1
            END
            
        END
        --ELSE
        --BEGIN
        --    DECLARE @qty INT = 0; 
            
        --    -- get available qty from orderitems table       
            
        --    SELECT @qty = ProductQty
        --    FROM   OrderItems
        --    WHERE  OrderId = @OrderId
        --           AND ProductId = @ProductId
        --           AND CategoryId = @CategoryId        
            
            
        --    SELECT @OrderItemId = OrderItemId
        --    FROM   OrderItems
        --    WHERE  OrderId = @OrderId
        --           AND ProductId = @ProductId
        --           AND CategoryId = @CategoryId            
            
        --    SELECT @OrderItemPrice = ISNULL(Price, 0),
        --           @OrderItemQty = ISNULL(ProductQty, 0)
        --    FROM   OrderItems
        --    WHERE  OrderId = @OrderId
        --           AND ProductId = @ProductId          
            
        --    SET @OrderItemPrice = @OrderItemPrice * @OrderItemQty            
            
        --    UPDATE OrderItems
        --    SET    ProductQty = @ProductQty + @qty,
        --           Price = @Price,
        --           ModifiedOn = GETDATE(),
        --           ModifiedBy = @CreatedBy,
        --           CategoryId = @CategoryId
        --    WHERE  OrderId = @OrderId
        --           AND ProductId = @ProductId
        --           AND CategoryId = @CategoryId 
            
        --    /* This code is added to include the dependent product details */            
        --    SELECT @OldOrderDependentItemPrice = ISNULL(SUM(ISNULL(ProductQty, 0) * ISNULL(Price, 0)), 0)
        --    FROM   OrderDependentItems
        --    WHERE  OrderItemId = @OrderItemId          
            
        --    DELETE 
        --    FROM   OrderDependentItems
        --    WHERE  OrderItemId = @OrderItemId          
            
        --    SET @DependentProductPriceTotal = 0            
            
        --    IF EXISTS (
        --           SELECT 1
        --           FROM   @tempDependentProduct
        --       )
        --    BEGIN
        --        SELECT @DependentProductPriceTotal = SUM(Price) * @ProductQty
        --        FROM   @tempDependentProduct 
                
        --        INSERT INTO OrderDependentItems
        --          (
        --            OrderId,
        --            OrderItemId,
        --            ProductId,
        --            ProductQty,
        --            Price
        --          )
        --        SELECT @OrderId,
        --               @OrderItemId,
        --               tdp.ProductId,
        --               @ProductQty + @qty,
        --               tdp.Price
        --        FROM   @tempDependentProduct tdp
        --    END 
        --    /* end - dependent product details*/                 
            
            
        --    UPDATE Orders
        --    SET    OrderDate = GETDATE(),
        --           Amount = Amount + @OrderItemTotalPrice + @DependentProductPriceTotal,
        --           ModifiedBy = @CreatedBy,
        --           ModifiedOn = GETDATE()
        --    WHERE  OrderId = @OrderId
        --END 
        
        --SELECT @OrderItemId AS [OrderItemId] 
    END
    -- DROP TABLE #tempDependentProduct
    SELECT OrderItemId
    FROM   OrderItems
    WHERE  OrderItemId = @OrderItemId
END TRY             
BEGIN CATCH
    EXEC USP_SaveSPErrorDetails 
    RETURN -1
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_SaveOrderItems]    Script Date: 12/14/2015 17:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SaveOrderItems] 
(
    @OrderId     INT,
    @ProductId   INT,
    @ProductQty  INT,
    @UserId      UNIQUEIDENTIFIER,
    @CreatedBy   VARCHAR(256),
    @CategoryId  INT
    
)
AS
BEGIN TRY
    BEGIN
        DECLARE @OrderItemId INT            
        DECLARE @OrderItemTotalPrice DECIMAL(8, 2)            
        DECLARE @Price DECIMAL(8, 2)            
        DECLARE @ARC_Id INT            
        DECLARE @OrderItemPrice DECIMAL(8, 2)            
        DECLARE @OrderItemQty INT              
        DECLARE @OldOrderDependentItemPrice DECIMAL(8, 2)             
        DECLARE @DependentProductId INT            
        DECLARE @DependentProductPrice DECIMAL(8, 2)            
        DECLARE @DependentProductPriceTotal DECIMAL(8, 2)            
                     
        
        SELECT @OrderItemQty = ProductQty
        FROM   OrderItems
        WHERE  OrderId = @OrderId
               AND ProductId = @ProductId
               AND CategoryId = @CategoryId          
        
        SET @OrderItemQty = ISNULL(@OrderItemQty, 0) 
        
        --IF @OrderItemQty != @ProductQty
        --BEGIN          
        SELECT @ARC_Id = ARCId
        FROM   ARC_User_Map
        WHERE  UserId = @UserId          
        
        SELECT @Price = CASE ISNULL(t.ARC_Price, 0)
                             WHEN 0 THEN t.Price
                             ELSE t.ARC_Price
                        END
        FROM   (
                   SELECT p.ProductId,
                          p.ProductCode,
                          p.ProductName,
                          p.DefaultImage,
                          p.ProductType,
                          p.Price,
                          ppm.Price AS ARC_Price
                   FROM   Products p
                          LEFT JOIN ARC_Product_Price_Map ppm ON  ppm.ProductId = p.ProductId
                               AND ppm.ARCId = @ARC_Id
                               AND ppm.IsDeleted = 0 AND  CONVERT(DATETIME, GETDATE()) <= CONVERT(DateTime,ppm.ExpiryDate)
                   WHERE  p.ProductId = @ProductId 
               ) t            
        
        SET @OrderItemTotalPrice = @Price * @ProductQty            
         
         DECLARE @tempDependentProduct TABLE (ProductId INT,Price DECIMAL(6,2) )
         
           -- Get product's dependent products into a temp table ---> 
            INSERT into  @tempDependentProduct (ProductId,Price)
            
            SELECT t.ProductId,
                   CASE ISNULL(t.ARC_Price, 0)
                        WHEN 0 THEN t.Price
                        ELSE t.ARC_Price
                   END AS Price 
                    
            FROM   (
                       SELECT p.ProductId,
                              p.Price,
                              ppm.Price AS ARC_Price
                       FROM   Products p
                              LEFT JOIN ARC_Product_Price_Map ppm
                                   ON  ppm.ProductId = p.ProductId
								   AND ppm.ARCId = @ARC_Id --added by alex 11.03.2014 16:04 
                                   AND ppm.IsDeleted = 0 AND  CONVERT(DATETIME, GETDATE()) <= CONVERT(DateTime,ppm.ExpiryDate)
                       WHERE  p.IsDeleted = 0  AND isnull(p.ListedonCSLConnect,0) = 0 
                              AND p.ProductId IN (SELECT pdm.DependentProductId
                                                  FROM   Product_Dependent_Map 
                                                         pdm
                                                  WHERE  pdm.ProductId = @ProductId)
                   ) t 
            --<--- End temp table 
         
         
        IF NOT EXISTS (SELECT OrderItemId FROM   OrderItems WHERE  OrderId = @OrderId AND ProductId = @ProductId AND CategoryId = @CategoryId)
        BEGIN
     INSERT INTO OrderItems ( OrderId,ProductId,ProductQty,Price,OrderItemStatusId,CreatedOn,CreatedBy,ModifiedOn,ModifiedBy,CategoryId )
            VALUES ( @OrderId,@ProductId,@ProductQty,@Price,1,GETDATE(),@CreatedBy,GETDATE(),@CreatedBy,@CategoryId)            
            
            SELECT @OrderItemId = SCOPE_IDENTITY() 
            
            /* This code is added to include the dependent product details */            
            SET @DependentProductPriceTotal = 0 
            
            
          
            
            IF EXISTS ( SELECT 1 FROM   @tempDependentProduct )
            BEGIN
               
                SELECT @DependentProductPriceTotal=SUM(Price)* @ProductQty  FROM @tempDependentProduct
                
                INSERT INTO OrderDependentItems(OrderId,OrderItemId,ProductId,ProductQty,Price)
                SELECT @OrderId,@OrderItemId,tdp.ProductId,@ProductQty,tdp.Price FROM @tempDependentProduct tdp
            END 
            /* end - dependent product details*/               
          
            UPDATE Orders
            SET    OrderDate = GETDATE(),
                   Amount = Amount + @OrderItemTotalPrice + @DependentProductPriceTotal,
                   ModifiedBy = @CreatedBy,
                   ModifiedOn = GETDATE()
            WHERE  OrderId = @OrderId
        END
        ELSE
        BEGIN
            DECLARE @qty INT = 0; 
            
            -- get available qty from orderitems table       
            
            SELECT @qty = ProductQty
            FROM   OrderItems
            WHERE  OrderId = @OrderId
                   AND ProductId = @ProductId
                   AND CategoryId = @CategoryId        
            
            
            SELECT @OrderItemId = OrderItemId
            FROM   OrderItems
            WHERE  OrderId = @OrderId
                   AND ProductId = @ProductId
                   AND CategoryId = @CategoryId            
            
            SELECT @OrderItemPrice = ISNULL(Price, 0),
                   @OrderItemQty = ISNULL(ProductQty, 0)
            FROM   OrderItems
            WHERE  OrderId = @OrderId
                   AND ProductId = @ProductId          
            
            SET @OrderItemPrice = @OrderItemPrice * @OrderItemQty            
            
            UPDATE OrderItems
            SET    ProductQty = @ProductQty + @qty,
                   Price = @Price,
                   ModifiedOn = GETDATE(),
                   ModifiedBy = @CreatedBy,
                   CategoryId = @CategoryId
            WHERE  OrderId = @OrderId
                   AND ProductId = @ProductId
                   AND CategoryId = @CategoryId 
            
            /* This code is added to include the dependent product details */            
            SELECT @OldOrderDependentItemPrice = ISNULL(SUM(ISNULL(ProductQty, 0) * ISNULL(Price, 0)), 0)
            FROM   OrderDependentItems
            WHERE  OrderItemId = @OrderItemId          
            
            DELETE 
            FROM   OrderDependentItems
            WHERE  OrderItemId = @OrderItemId          
            
            SET @DependentProductPriceTotal = 0            
            
            IF EXISTS (SELECT 1 FROM  @tempDependentProduct )
            BEGIN 
                            
               SELECT @DependentProductPriceTotal=SUM(Price)* @ProductQty  FROM @tempDependentProduct 
                       
                INSERT INTO OrderDependentItems(OrderId,OrderItemId,ProductId,ProductQty,Price)
                SELECT @OrderId,@OrderItemId,tdp.ProductId,@ProductQty+ @qty,tdp.Price FROM @tempDependentProduct tdp
                      
              
            END 
            /* end - dependent product details*/                 
           
            
            UPDATE Orders
            SET    OrderDate = GETDATE(),
                   Amount = Amount + @OrderItemTotalPrice + @DependentProductPriceTotal,
                   ModifiedBy = @CreatedBy,
                   ModifiedOn = GETDATE()
            WHERE  OrderId = @OrderId
   END            
        
       --SELECT @OrderItemId AS [OrderItemId] 
            
    END
   -- DROP TABLE #tempDependentProduct
         SELECT OrderItemId FROM OrderItems WHERE OrderItemId=@OrderItemId 
END TRY             
BEGIN CATCH
    EXEC USP_SaveSPErrorDetails 
    RETURN -1
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_Fedex_UpdateStatus]    Script Date: 12/14/2015 17:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SRI
-- Create date:20/03/2014[dbo].[USP_FedexImport]
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[USP_Fedex_UpdateStatus]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEgin 

	INSERT INTO [dbo].[OrderShippingTrack]
	SElect ORders.OrderID,trackingNO,getdate() from fedex_import
	inner join ORders on fedex_import.orderno COLLATE DATABASE_DEFAULT = ORders.OrderNO COLLATE DATABASE_DEFAULT 
	WHERE Orders.OrderstatusID = 14 AND 
	UpdatedOnOrder = 0 
	
	





End
   -- return total imported rows	
	DECLARE @count INT
	
	SElect @count= COUNT(*) from fedex_import
	inner join ORders on fedex_import.orderno COLLATE DATABASE_DEFAULT = ORders.OrderNO COLLATE DATABASE_DEFAULT 
	WHERE Orders.OrderstatusID = 14 AND 
	UpdatedOnOrder = 0 


	UPDATE ORders SET  OrderSTATUSID=10,processedon=getdate() from fedex_import
	inner join ORders on fedex_import.orderno COLLATE DATABASE_DEFAULT = ORders.OrderNO COLLATE DATABASE_DEFAULT 
	WHERE Orders.OrderstatusID = 14 AND UpdatedOnOrder = 0



	UPDATE fedex_import SET  UpdatedOnOrder = 1  from fedex_import
	inner join ORders on fedex_import.orderno COLLATE DATABASE_DEFAULT = ORders.OrderNO COLLATE DATABASE_DEFAULT 
	WHERE Orders.OrderstatusID = 10 AND UpdatedOnOrder = 0 

select @count AS CountRow;


END
GO
/****** Object:  StoredProcedure [dbo].[USP_FailedOrderToEclipse_Count]    Script Date: 12/14/2015 17:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_FailedOrderToEclipse_Count](@ReportID int = Null)  
AS  
Begin  
  
  
 Update BOS.dualcom_reports.dbo.MasterReportInfo  set DataCount =
 (
 
 select count(*) from
 (
 
 select  DISTINCT OrderNO, Orderdate,Arc.CompanyName as ARC_Name,ARC.UNiqueCode as 'ARC UniqueCode', Installer.CompanyName as InstallerName,INstaller.UniqueCode as 'Installer UniqueCode',SalesReply AS SalesRep
 from Arc_ordering.dbo.orders Orders Inner Join Arc_ordering.dbo.Arc Arc
 on Orders.arc_code=arc.arc_code Inner Join Arc_ordering.dbo.installer Installer on installer.Installercompanyid = Orders.Installerid
 Inner join  Arc_ordering.dbo.Orderitems  Orderitems on  Orderitems.OrderID = Orders.OrderID 
 WHERE OrderstatusID = 10 
AND ISCSD = 0 
AND OrderITemStatusID != 13 
AND CAtegoryID != 5 
AND OrderType = 1 
)a)
 
   where ReportID = @ReportID   
   
   
 --print @cnt  
   
 End
GO
/****** Object:  StoredProcedure [dbo].[USP_FailedOrderToEclipse]    Script Date: 12/14/2015 17:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*CreatedBy: Shyam
CreatedOn: 2015-01-06 11:44:32.697
*/

CREATE Procedure [dbo].[USP_FailedOrderToEclipse]
as begin

select  DISTINCT OrderNO, Orderdate,Arc.CompanyName as ARC_Name,ARC.UNiqueCode as 'ARC UniqueCode', Installer.CompanyName as InstallerName,INstaller.UniqueCode as 'Installer UniqueCode',SalesReply AS SalesRep
 from Arc_ordering.dbo.orders Orders Inner Join Arc_ordering.dbo.Arc Arc
 on Orders.arc_code=arc.arc_code Inner Join Arc_ordering.dbo.installer Installer on installer.Installercompanyid = Orders.Installerid
 Inner join  Arc_ordering.dbo.Orderitems  Orderitems on  Orderitems.OrderID = Orders.OrderID 
 WHERE OrderstatusID = 10 
AND ISCSD = 0 
AND OrderITemStatusID != 13 
AND CAtegoryID != 5 
AND OrderType = 1 


end
GO
/****** Object:  StoredProcedure [dbo].[USP_ExecuteLogisticsRule]    Script Date: 12/14/2015 17:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Priya>
-- Create date: <03/12/2015,,>
-- Description:	<To find the rule for the corresponding ARC and execute USP_IsLogisticsdescription,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_ExecuteLogisticsRule]
@orderid int,
@arcid int

AS
BEGIN

DECLARE @ProcName as nvarchar(50)
DECLARE @result as bit
DECLARE @count as int


SELECT @ProcName = SP_Name  FROM [dbo].LogisticsMessageRule WHERE RuleID = (SELECT RuleID FROM ARC WHERE arcid = @arcid)

if exists (SELECT name FROM dbo.sysobjects WHERE (type = 'P') and name = @ProcName)
BEGIN
EXEC @result = @ProcName @orderid
return @result 
END

ELSE
BEGIN
return 0
END

END
GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteOrderwithDetails]    Script Date: 12/14/2015 17:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_DeleteOrderwithDetails]
	-- Add the parameters for the stored procedure here
	@orderID int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF Exists (Select OrderID from Orders WHERE OrderID=@OrderID and OrderStatusID =1 ) 
	BEGIN 
		Delete from [OrderDependentItems] WHERE OrderID = @orderID

		Delete from OrderItemDetails WHERE OrderItemID in (select OrderItemId from OrderItems where OrderID = @OrderID) 

		Delete from OrderItems WHERE OrderID = @orderID

		Delete from Orders WHERE OrderID = @OrderID
	END 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteOrderItems]    Script Date: 12/14/2015 17:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_DeleteOrderItems]
(	
	@OrderId int,
	@ProductId int,
	@CreatedBy varchar(256),
	@CategoryId int
)
As

BEGIN TRY 
Begin	
		
	Declare @OrderItemId int
	Declare @OrderItemTotalPrice decimal(6,2)	
	DECLARE @DependentProductPriceTotal DECIMAL(6,2)
	
	SET @OrderItemId = 0
		
	Select @OrderItemId = OI.OrderItemId
			From OrderItems OI			
			Where OI.ProductId = @ProductId
				And OI.CategoryId = @CategoryId
				And OI.OrderId = @OrderId
	
	IF @OrderItemId != 0
		BEGIN
	
			SET @OrderItemTotalPrice = 0
			SET @DependentProductPriceTotal = 0
			SET @OrderItemTotalPrice = (Select Sum(IsNull(ProductQty,0) * IsNull(Price,0)) from OrderItems where OrderItemId = @OrderItemId)
			SET @DependentProductPriceTotal = (Select Sum(IsNull(ProductQty,0) * IsNull(Price,0)) from OrderDependentItems where OrderItemId = @OrderItemId)
							
			Delete From OrderItems Where OrderItemId = @OrderItemId
			Delete From OrderItemDetails Where OrderItemId = @OrderItemId
			Delete From OrderDependentItems Where OrderItemId = @OrderItemId
			Update Orders Set Amount = Amount - @OrderItemTotalPrice - @DependentProductPriceTotal Where OrderId = @OrderId
		END
End

END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteOrderItemDetailsByOrderItemId]    Script Date: 12/14/2015 17:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_DeleteOrderItemDetailsByOrderItemId]
(
	@OrderItemId int
)
As

BEGIN TRY 
Begin
	Delete From OrderItemDetails
		Where OrderItemId = @OrderItemId
End

END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_ConfirmOrderDetails]    Script Date: 12/14/2015 17:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_ConfirmOrderDetails]  
(  
@OrderId Int,  
@OrderRefNo NVarchar(256),  
@DeliveryCost Decimal(6,2),  
@DeliveryAddressId Int,  
@DeliveryTypeId Int,  
@SpecialInstructions Text,  
@VATRate Decimal(6,3),  
@CreatedBy NVarchar(256),  
@InstallationAddressId int,  
@InstallerContactName NVarchar(250) = ''  
)  
AS  
  
BEGIN TRY   
BEGIN  
  
 Declare @OrderAmount Decimal(9,2)  
 Declare @OrderTotalAmount Decimal(9,2)  
 Select @OrderAmount = Amount From Orders Where OrderId = @OrderId  
 Set @OrderTotalAmount = (@OrderAmount + @DeliveryCost) + ((@OrderAmount + @DeliveryCost)* @VATRate)   
   
 Update Orders  
  Set OrderRefNo = @OrderRefNo,  
   OrderDate = GETDATE(),  
   DeliveryCost = @DeliveryCost,  
   DeliveryAddressId = @DeliveryAddressId,  
   OrderStatusId = 2,  
   OrderTotalAmount = @OrderTotalAmount,  
   DeliveryTypeId = @DeliveryTypeId,  
   SpecialInstructions = @SpecialInstructions,  
   ModifiedBy = @CreatedBy,  
   ModifiedOn = GETDATE(),  
   InstallationAddressID = @InstallationAddressId,  
   VATRate = @VATRate,  
   InstallerContactName = @InstallerContactName  
  Where OrderId = @OrderId  
    
 Select OrderNo From Orders Where OrderId = @OrderId  
END  
  
END TRY   
BEGIN CATCH  
EXEC USP_SaveSPErrorDetails  
RETURN -1    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_ARCAcceptDuplicateChipNumbers]    Script Date: 12/14/2015 17:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ARCAcceptDuplicateChipNumbers]
(
@OrderId int,
@HasUserAcceptedDuplicates bit
)
AS

BEGIN TRY 
BEGIN
	Update Orders Set HasUserAcceptedDuplicates = @HasUserAcceptedDuplicates Where OrderId = @OrderId	
END

END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_AllocateOEMProductsToInstaller]    Script Date: 12/14/2015 17:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Mohd Atiq
-- Create date: 30/04/2015
-- Description:	Purpose of this table to allocate oem products to installer
-- =============================================
CREATE PROCEDURE [dbo].[USP_AllocateOEMProductsToInstaller] (@InstallerId nvarchar(500)
)
AS
BEGIN
BEGIN TRY 
   DECLARE @CountryCode NVARCHAR(50)
   DECLARE @CurrencyId INT
   SET @CountryCode=''
   DECLARE @BandNameId INT
   DECLARE @PriceBandId INT
   SET @PriceBandId=0
   SELECT @CountryCode=Country FROM Installer Ins 
   INNER JOIN Currency Cur
   ON Ins.CurrencyId=Cur.CurrencyID
   Where Ins.InstallerCompanyID=@InstallerId
   IF(@CountryCode='UK')
	SELECT @CurrencyId=CurrencyId From Currency Where CurrencyCode='GBP'
   ELSE
	SELECT @CurrencyId=CurrencyId From Currency Where CurrencyCode='EUR'
		
	SELECT @BandNameId=ID FROM BandNameMaster WHERE IsDefault=1
	
	DECLARE @ProductList VARCHAR(1024)
	DECLARE @ProductId INT
	DECLARE @Pos INT 
    SELECT @ProductList = COALESCE(@ProductList + ',', '') + convert(varchar,Productid)FROM 
    Products where IsOEMProduct=1 and ListedonCSLConnect =1
    SET @ProductList=@ProductList+','
    SET @Pos = CHARINDEX(',', @ProductList, 1)
    IF REPLACE(@ProductList, ',','') <> ''
    BEGIN    
    	WHILE @Pos > 0
    	BEGIN    	
    		SET @ProductId = LTRIM(RTRIM(LEFT(@ProductList, @Pos - 1)))    		
    		IF @ProductId <> ''
    		BEGIN
			    SELECT @PriceBandId=ID FROM PriceBand WHERE 
						BandNameId=@BandNameId AND 
						CurrencyId= @CurrencyId 
						AND ProductId=@ProductId			  	
						
				IF NOT EXISTS(SELECT ProductId from Product_Installer_Map WHERE ProductId=@ProductId
							  AND InstallerId=@InstallerId)
				BEGIN
				   INSERT INTO Product_Installer_Map(ProductId,InstallerId)VALUES(@ProductId,@InstallerId)
				END	
				IF(@PriceBandId>0)
				BEGIN
				
					IF NOT EXISTS(SELECT PriceBandId FROM CompanyPriceMap CPM
					INNER JOIN PriceBand PB ON CPM.PriceBandId=PB.ID
					WHERE CompanyId=@InstallerId AND PB.ProductID=@ProductId)
					
					BEGIN					 
					 INSERT INTO CompanyPriceMap(CompanyId,PriceBandId)VALUES(@InstallerId,@PriceBandId)
					END
					
				END		
    		END
    		SET @ProductList = RIGHT(@ProductList, LEN(@ProductList) - @Pos)
    		SET @Pos = CHARINDEX(',', @ProductList, 1)
    	END
        
   END	
END TRY
	BEGIN CATCH          
    EXEC USP_SaveSPErrorDetails           
    RETURN -1          
END CATCH
   
END
GO
/****** Object:  StoredProcedure [dbo].[USP_AddOrderItemDetailsToBasket]    Script Date: 12/14/2015 17:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_AddOrderItemDetailsToBasket]
(
@OrderItemId int,
@GPRSNo varchar(50),
@GPRSNoPostCode varchar(50),
@CreatedBy varchar(256)
)
As
BEGIN TRY 
Begin		
	Insert into 
		OrderItemDetails (OrderItemId, GPRSNo, GPRSNoPostCode, ModifiedOn, ModifiedBy)
		Values (@OrderItemId, @GPRSNo, @GPRSNoPostCode, GETDATE(), @CreatedBy)
End
END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_ActivateInstallerProducts]    Script Date: 12/14/2015 17:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alex Papayianni
-- Create date: 24/02/2015
-- Description:	To activate the products for Installers on M2M Connect
-- =============================================
CREATE PROCEDURE [dbo].[USP_ActivateInstallerProducts]
 @arcCode nvarchar(100),
 @installerId uniqueidentifier
AS
BEGIN
if not exists (select ProductId from Product_Installer_Map where InstallerId = @installerId)
begin
UPDATE Installer
set IsVoiceSMSVisible = (select IsVoiceSMSVisible from ARC where ARC_Code = @arcCode)
where InstallerCompanyID = @installerId and IsVoiceSMSVisible != (select IsVoiceSMSVisible from ARC where ARC_Code = @arcCode)

insert into product_installer_map (ProductId,InstallerId)
 select ProductId,[InstallerId] from
(
   ( select p.ProductId from product_arc_map pam
   join products p on pam.ProductId = p.ProductId
   join arc a on pam.arcid = a.ARCId
    where listedoncslconnect = 1 and a.ARC_Code = @arcCode ) as A
	cross join 
(SELECT @installerId as InstallerId) as b 
 )
 order by 1,2
 end

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetClearBasket]    Script Date: 12/14/2015 17:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  <Ajitender Vijay>    
-- Create date: <23/04/2013>    
-- Description: <Get delete all basket items>    
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetClearBasket]    
 @ModifiedBy VARCHAR(200),    
 @OrderId INT
 
AS    
BEGIN TRY 
	 
    BEGIN    
        UPDATE Orders    
        SET    Amount = 0.00,    
               DeliveryCost = 0.00,    
               OrderTotalAmount = 0.00,    
               DeliveryTypeId = 0,    
               ModifiedBy = @ModifiedBy,    
               ModifiedOn = GETDATE(),    
               HasUserAcceptedDuplicates = 0,    
               VATRate = 0.00,    
               InstallerContactName = NULL    
        WHERE  OrderId = @OrderId    
            
            
            
        -- delete OrderItemDetails table  --    
            
        CREATE TABLE #tempOrderItemID    
        (    
         orderItemId INT    
        )    
            
        INSERT INTO #tempOrderItemID    
        SELECT OrderId  FROM   OrderItems oi    WHERE  oi.OrderId = @OrderId    
            
        DELETE     
        FROM   OrderItemDetails    
        WHERE  OrderItemId IN (SELECT orderItemId    
                               FROM   #tempOrderItemID)    
            
        --delete OrderItems ---                            
            
        DELETE     
        FROM   OrderItems    
        WHERE  OrderId = @OrderId    
            
          -- delete temp table  
          DROP TABLE #tempOrderItemID  
      
        
           
    END 
    RETURN 0  
END TRY    
BEGIN CATCH    
    EXEC USP_SaveSPErrorDetails    
    RETURN -1    
END CATCH 



/*
select * from orders
select * from orderitems
    
CREATE TABLE #tempOrderItemID  (orderItemId INT )   
INSERT INTO #tempOrderItemID    
SELECT OrderId  FROM   OrderItems oi    WHERE  oi.OrderId = @OrderId    
DELETE     FROM   OrderItemDetails    WHERE  OrderItemId IN 
(SELECT orderItemId FROM   #tempOrderItemID)    

*/
GO
/****** Object:  StoredProcedure [dbo].[USP_GetCategoryRelatedProducts]    Script Date: 12/14/2015 17:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetCategoryRelatedProducts]  

 @CategoryId INT,  

 @ARC_Id INT  

AS  

BEGIN TRY  

    BEGIN  

        SELECT t.ProductId,  

               t.ProductCode,  

               t.ProductName,  

               t.DefaultImage,  

               t.ProductType,  

               CASE ISNULL(t.ARC_Price, 0)  

                    WHEN 0 THEN t.Price  

                    ELSE t.ARC_Price  

               END AS Price,  

               t.ListOrder,  

               t.IsCSD  

        FROM   (  

                    SELECT p.ProductId,  

                          p.ProductCode,  

                          p.ProductName,  

                          p.DefaultImage,  

                          p.ProductType,  

                          p.Price,  

                          ISNULL (ppm.Price,0.0) AS ARC_Price,  

                          p.ListOrder,  

                          ISNULL(p.IsCSD,0)IsCSD  

                   FROM   CategoryRelatedProducts crp  

                          INNER JOIN Category c  

                               ON  c.CategoryId = crp. CategoryId  AND c.CategoryId = @CategoryId  

                          INNER JOIN Products p   

                               ON  p.ProductId = crp.ProductId

                                INNER JOIN Product_ARC_Map pam  

                               ON  pam.ProductId = p.ProductId  

                               AND pam.ARCId = @ARC_Id  

                          LEFT JOIN ARC_Product_Price_Map ppm  

                               ON  ppm.ProductId = p.ProductId  

                               AND DATEDIFF(d, ISNULL(ppm.ExpiryDate, GETDATE()), GETDATE())  

                                   > 0  

                               AND ppm.IsDeleted = 0  

                   WHERE  p.IsDependentProduct = 0  

                          AND p.IsDeleted = 0  

               ) t  

        ORDER BY  

               t.ListOrder,  

               t.ProductName  

    END  

END TRY     

BEGIN CATCH  

    EXEC USP_SaveSPErrorDetails   

    RETURN -1  

END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetBasketQtyByProductId]    Script Date: 12/14/2015 17:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_GetBasketQtyByProductId]
(
	@OrderId int,
	@ProductId int,
	@CategoryId int
)
As

BEGIN TRY 
Begin
	Select OI.ProductQty
		From OrderItems OI
		Inner Join
		Orders O on O.OrderId = OI.OrderId
		Where 
			O.OrderId = @OrderId 
			And OI.ProductId = @ProductId
			And OI.CategoryId = @CategoryId
End

END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetBasketProductsOnPreviousOrders_Ordering]    Script Date: 12/14/2015 17:06:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetBasketProductsOnPreviousOrders_Ordering]     
(@OrderId INT)    
AS    
BEGIN TRY    
    BEGIN    
        SELECT p.ProductId,    
               ISNULL(p.IsCSD, 0)IsCSDProd,    
               ISNULL(oi.IsCSD, 0)IsCSDUser,    
               ISNULL(p.[Message], '')[Message],    
               p.ProductCode,    
               p.ProductName,    
               p.ProductType,    
               oi.Price,    
               SUM(oid.Quantity)   ProductQty,    
               ISNULL(oi.Price, 0) * ISNULL(oi.ProductQty, 0) AS    
               ProductPriceTotal,    
               oi.OrderItemId,    
               ISNULL(cat.IsGPRSChipEmpty, 0) AS IsGPRSChipEmpty,    
               oi.CategoryId,    
               oi.OrderItemStatusId ,
               oi.IsReplenishment IsReplenishment 
                
            
        FROM   Products p    
               INNER JOIN OrderItems oi    
                    ON  oi.ProductId = p.ProductId    
               LEFT JOIN OrderItemDetails oid    
                    ON  oid.OrderItemId = oi.OrderItemId   
               LEFT JOIN Category cat    
                    ON  cat.CategoryId = oi.CategoryId    
        WHERE  oi.OrderId = @OrderId  AND oi.OrderItemstatusID !=13  
        GROUP BY    
          
           p.ProductCode,p.IsCSD,oi.IsCSD,p.Message,p.ProductId,    
           p.ProductName,p.ProductType,oi.Price,ISNULL(oi.Price, 0) * ISNULL(oi.ProductQty, 0), oi.OrderItemId,    
           cat.IsGPRSChipEmpty , oi.CategoryId, oi.OrderItemStatusId,oi.IsReplenishment
      
        ORDER BY    
               p.ProductCode    
            
         
    END    
END TRY                       
BEGIN CATCH    
    EXEC USP_SaveSPErrorDetails     
    RETURN -1    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetBasketProductsOnPreviousOrders]    Script Date: 12/14/2015 17:06:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetBasketProductsOnPreviousOrders]     

     

(@OrderId INT)    

AS    

BEGIN TRY    

    BEGIN    

        SELECT p.ProductId,    

               ISNULL(p.IsCSD, 0)IsCSDProd,    

               ISNULL(oi.IsCSD, 0)IsCSDUser,    

               ISNULL(p.[Message], '')[Message],    

               p.ProductCode,    

               p.ProductName,    

               p.ProductType,    

               oi.Price,    

               SUM(oid.Quantity)   ProductQty,    

               ISNULL(oi.Price, 0) * ISNULL(oi.ProductQty, 0) AS    ProductPriceTotal,    

               oi.OrderItemId,    

               ISNULL(cat.IsGPRSChipEmpty, 0) AS IsGPRSChipEmpty,    

               oi.CategoryId,    

               oi.OrderItemStatusId    

               ,ISNULL(oid.ICCID, '')ICCID,    

               ISNULL(oid.DataNo, '')DataNo,

               ISNULL(oid.GPRSNo,'') GPRSNo,   

              ISNULL(o.OptionName,'') OptionName,

               ISNULL(oid .OptionId,0) OptionId,

               ISNULL(oid.SiteName  , '') SiteName,

               ISNULL(oi.IsReplenishment,'') IsReplenishment,

               ISNULL(oid.IsFOC, 0)IsFOC,

			    ISNULL(oid.IsReplacement, 0)IsReplacement,
				
			    ISNULL(oid.[FileName], 'Not created')[FileName]
                

        FROM   Products p    

               INNER JOIN OrderItems oi    

                    ON  oi.ProductId = p.ProductId    

               LEFT JOIN OrderItemDetails oid    

                    ON  oid.OrderItemId = oi.OrderItemId    

                    LEFT JOIN Options o ON o.OptID=oid.OptionId    

               LEFT JOIN Category cat    

                    ON  cat.CategoryId = oi.CategoryId    

        WHERE  oi.OrderId = @OrderId  AND oi.OrderItemstatusID !=13     

        GROUP BY    

          o.OptionName,

           p.ProductCode,p.IsCSD,oi.IsCSD,p.Message,p.ProductId,    

           p.ProductName,p.ProductType,oi.Price,ISNULL(oi.Price, 0) * ISNULL(oi.ProductQty, 0), oi.OrderItemId,    

           cat.IsGPRSChipEmpty , oi.CategoryId, oi.OrderItemStatusId

            ,oid.ICCID,    

           oid.DataNo ,

           oid.GPRSNo,

           o.OptionName ,

			   oid .OptionId  ,oid.SiteName  ,oi.IsReplenishment ,oid.IsFOC,oid.IsReplacement,oid.[FileName]

        ORDER BY    

               p.ProductCode    

            

         

    END    

END TRY                       

BEGIN CATCH    

    EXEC USP_SaveSPErrorDetails     

    RETURN -1    

END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetBasketProductsOnCheckOut]    Script Date: 12/14/2015 17:06:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetBasketProductsOnCheckOut]                  
     
(@OrderId INT)    
AS    
BEGIN TRY    
    BEGIN    
        SELECT p.ProductId,    
               ISNULL(p.IsCSD, 0)IsCSDProd,    
               ISNULL(oi.IsCSD, 0)IsCSDUser,    
               ISNULL(oi.IsReplenishment, 0)IsReplenishment,    
               ISNULL(p.[Message], '')[Message],    
               p.ProductCode,    
               p.ProductName,    
               p.ProductType,    
               oi.Price,    
               SUM(oid.Quantity)   ProductQty,    
               ISNULL(oi.Price, 0) * ISNULL(oi.ProductQty, 0) AS    
               ProductPriceTotal,    
               oi.OrderItemId,    
               ISNULL(cat.IsGPRSChipEmpty, 0) AS IsGPRSChipEmpty,    
               oi.CategoryId,    
               oi.OrderItemStatusId,    
               ISNULL(oid.ICCID, '')ICCID,    
               ISNULL(oid.DataNo, '')DataNo--,    
            --   ISNULL(oid.IPAddress, '')IPAddress    
              ,ISNULL(o.OptionName,'') OptionName,    
              ISNULL(oid .OptionId,0) OptionId  
        FROM   Products p    
               INNER JOIN OrderItems oi    
                    ON  oi.ProductId = p.ProductId    
               LEFT JOIN OrderItemDetails oid    
                    ON  oid.OrderItemId = oi.OrderItemId    
                    LEFT JOIN Options o ON o.OptID=oid.OptionId    
               LEFT JOIN Category cat    
                    ON  cat.CategoryId = oi.CategoryId    
        WHERE  oi.OrderId = @OrderId    
        GROUP BY    
          o.OptionName, p.ProductCode,p.IsCSD,oi.IsCSD,oi.IsReplenishment,p.Message,p.ProductId,    
           p.ProductName,p.ProductType,oi.Price,ISNULL(oi.Price, 0) * ISNULL(oi.ProductQty, 0), oi.OrderItemId,    
           cat.IsGPRSChipEmpty , oi.CategoryId, oi.OrderItemStatusId, oid.ICCID,    
           oid.DataNo,--oid.IPAddress ,
		   o.OptionName ,oid .OptionId   
        ORDER BY    
               p.ProductCode   
    END    
END TRY                       
BEGIN CATCH    
    EXEC USP_SaveSPErrorDetails     
    RETURN -1    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetBasketProductsForPortal]    Script Date: 12/14/2015 17:06:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*  
ModifiedBy - Shyam Gaddam  
ModifiedOn - 23/01/2015  
Purpose- Device_API result set is very slow during initial join- Takes 32 sec. Join outsite the table takes 0 Sec  
*/  
  
CREATE PROCEDURE [dbo].[USP_GetBasketProductsForPortal]               
    
(@OrderId INT)              
    
AS              
    
BEGIN TRY              
    
    BEGIN      
    
    DECLARE @strOrderItemDetailIds varchar(1000)    
    
    DECLARE  @SQLQUERY varchar(max)        
    
    SELECT  @strOrderItemDetailIds=  COALESCE(@strOrderItemDetailIds + ',', '') + CAST(OrderItemId  AS VARCHAR) from OrderItems where OrderId = @OrderId      
            
 CREATE TABLE #TEMP(PRODUCTID INT,ISCSDPROD BIT,ISCSDUSER BIT,ISREPLENISHMENTPROD BIT,    
 ISREPLENISHMENTUSER BIT,[MESSAGE] NVARCHAR(256),PRODUCTCODE NVARCHAR(120),    
 PRODUCTNAME NVARCHAR(512),PRODUCTTYPE NVARCHAR(100),PRICE DECIMAL(9,2),PRODUCTQTY INT,PRODUCTPRICETOTAL DECIMAL(20,2),    
 ORDERITEMID INT,ISGPRSCHIPEMPTY BIT,CATEGORYID INT,ORDERITEMSTATUSID  INT,ICCID VARCHAR(30),GPRSNO VARCHAR(30))    
       
    SET @SQLQUERY = ' insert into #Temp SELECT DISTINCT(p.ProductId),            
    
               ISNULL(p.IsCSD, 0)IsCSDProd,            
    
               ISNULL(oi.IsCSD, 0)IsCSDUser,            
    
               ISNULL(p.IsReplenishment, 0)IsReplenishmentProd,        
    
               ISNULL(oi.IsReplenishment, 0)IsReplenishmentUser,              
    
               ISNULL(p.[Message], '''')[Message],            
    
               p.ProductCode + isnull(oi.CSLConnectCodePrefix,'''') as ProductCode,            
    
               p.ProductName,            
    
               p.ProductType,            
    
               oi.Price,            
    
               oi.ProductQty,            
    
               ISNULL(oi.Price, 0) * ISNULL(oi.ProductQty, 0) AS   '          
    
                   
    
     SET @SQLQUERY=   @SQLQUERY+'       ProductPriceTotal,            
    
               oi.OrderItemId,            
    
               ISNULL(cat.IsGPRSChipEmpty, 0) AS IsGPRSChipEmpty,            
    
               oi.CategoryId,            
    
               oi.OrderItemStatusId,            
    
               ISNULL(oid.ICCID, '''')ICCID,              
    
    
               [GPRSNO]  = CASE WHEN oid.ICCID is null THEN ''''    
    
        ELSE iSNULL(oid.GPRSNo,'''')    
    
       END     
    
        FROM   Products p  with (nolock)              
    
               INNER JOIN OrderItems oi    with (nolock)            
    
                    ON  oi.ProductId = p.ProductId            
    
               LEFT JOIN OrderItemDetails oid   with (nolock)             
    
                    ON  oid.OrderItemId = oi.OrderItemId            
    
                  LEFT JOIN Options o with (nolock)     ON o.OptID=oid.OptionId          
    
               LEFT JOIN Category cat      with (nolock)          
    
                    ON  cat.CategoryId = oi.CategoryId         
        WHERE      
    
          oi.OrderItemId in ( ' + @strOrderItemDetailIds + ' ) and  oi.OrderItemstatusID !=13       
    
          --32070    
    
        ORDER BY            
    
                p.ProductCode + isnull(oi.CSLConnectCodePrefix,'''')   '                   
    
       --PRINT @SQLQUERY    
    
     EXEC (@SQLQUERY)       
           
     SELECT *,  ISNULL(DAPI.DATA_NUMBER, '')DATANO,ISNULL(DAPI.DEV_IP_ADDRESS, '')IPADDRESS FROM #TEMP OID LEFT OUTER JOIN DEVICE_API DAPI WITH (NOLOCK)    ON OID.ICCID = DAPI.DEV_CODE  ORDER BY GPRSNO    
    
  DROP TABLE #TEMP    
    
    END              
    
END TRY                           
    
BEGIN CATCH              
    
    EXEC USP_SaveSPErrorDetails               
    
    RETURN -1              
    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetBasketProducts]    Script Date: 12/14/2015 17:06:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetBasketProducts]       
(@OrderId INT)          
AS          
BEGIN TRY          
    BEGIN          
        
        SELECT DISTINCT(p.ProductId), 
			   (case
			   when ISNULL(p.IsCSD, 0) = 0 then cast(0 as bit)
			   else a.IsAllowedCSD
			   end)IsCSDProd,      
               ISNULL(oi.IsCSD, 0)IsCSDUser,        
			   (case
			   when ISNULL(p.IsReplenishment, 0) = 0 then cast(0 as bit)
			   else a.IsAllowedCSD
			   end)IsReplenishmentProd,    
               ISNULL(oi.IsReplenishment, 0)IsReplenishmentUser,          
               ISNULL(p.[Message], '')[Message],        
               p.ProductCode,        
               p.ProductName,        
               p.ProductType,        
               oi.Price,        
               oi.ProductQty,        
               ISNULL(oi.Price, 0) * ISNULL(oi.ProductQty, 0) AS         
               ProductPriceTotal,        
               oi.OrderItemId,        
               ISNULL(cat.IsGPRSChipEmpty, 0) AS IsGPRSChipEmpty,        
               oi.CategoryId,        
               oi.OrderItemStatusId, 
               --ISNULL(oid.OptionId ,0) OptionId,    
               TotalOption=(
               	
						 SELECT COUNT(*) FROM Product_Option_Map pom 
										  INNER JOIN Products p2 ON pom.ProductId=p2.ProductId
										  INNER JOIN OrderItems oi ON oi.ProductId=p2.ProductId
										  INNER JOIN OrderItemDetails oid ON oid.OrderItemId = oi.OrderItemId
                                           WHERE oi.OrderId=@OrderId 
               							),
                
               ISNULL(p.IsSiteName ,0) IsSiteName
			   --,[GPRSNO]  = CASE WHEN oid.ICCID is null THEN ''
						--		ELSE iSNULL(oid.GPRSNo,'')
						--	END
        FROM   Products p        
               INNER JOIN OrderItems oi        
                    ON  oi.ProductId = p.ProductId    
				INNER JOIN Orders os ON oi.OrderId = os.OrderId
				INNER JOIN ARC a on os.ARC_Code = a.ARC_Code
               LEFT JOIN OrderItemDetails oid        
                    ON  oid.OrderItemId = oi.OrderItemId        
                  LEFT JOIN Options o ON o.OptID=oid.OptionId      
               LEFT JOIN Category cat        
                    ON  cat.CategoryId = oi.CategoryId     
				LEFT JOIN dbo.Device_API ON oid.ICCID = dbo.Device_API.Dev_Code     
        WHERE  oi.OrderId = @OrderId        
        ORDER BY  IsCSDProd desc,     
               p.ProductCode         
    END          
END TRY                       
BEGIN CATCH          
    EXEC USP_SaveSPErrorDetails           
    RETURN -1          
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetBasketGPRSChipNumbersByProductId]    Script Date: 12/14/2015 17:06:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetBasketGPRSChipNumbersByProductId]  
   
(@OrderId INT, @ProductId INT, @CategoryId INT)  
AS  
BEGIN TRY  
    BEGIN  
        SELECT OID.GPRSNo,  
               OID.GPRSNoPostCode,  
               OID.OrderItemDetailId,  
               ISNULL(OID.PSTNNo, '') PSTNNo,  
               ISNULL(OID.OptionId, 0) OptionId,  
               ISNULL(pom.OptionName, '') OptionName,  
			   ISNULL(SiteName,'') SiteName
        FROM   OrderItemDetails OID  
               INNER JOIN OrderItems OI  
                    ON  OI.OrderItemId = OID.OrderItemId  
               INNER JOIN Orders O  
                    ON  O.OrderId = OI.OrderId  
               LEFT JOIN Options pom  
                    ON  pom.OptID = OID.OptionId  
        WHERE  O.OrderId = @OrderId  
               AND OI.ProductId = @ProductId  
               AND OI.CategoryId = @CategoryId  
    END  
END TRY       
BEGIN CATCH  
    EXEC USP_SaveSPErrorDetails   
    RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetBasketDependentProductsByProductId]    Script Date: 12/14/2015 17:06:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_GetBasketDependentProductsByProductId]
(
	@OrderId int,
	@ProductId int,
	@CategoryId int
)
As
BEGIN TRY 

Begin
	Select odi.ProductId, P.ProductCode, P.ProductName, odi.Price, odi.ProductQty, IsNull(odi.Price,0) * IsNull(odi.ProductQty,0) as DependentProductPriceTotal
		From OrderDependentItems odi
		Inner Join
		OrderItems OI on OI.OrderItemId = odi.OrderItemId
		Inner Join
		Orders O on O.OrderId = OI.OrderId
		Inner Join
		Products P on P.ProductId = odi.ProductId
		Where 
			O.OrderId = @OrderId 
			And OI.ProductId = @ProductId
			aND OI.CategoryId = @CategoryId
End

END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetARCList]    Script Date: 12/14/2015 17:06:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alex Papayianni
-- Create date: 04/04/2014
-- Description:	Generates list of arc addresses
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetARCList]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select UniqueCode,ARC_Code,CompanyName,Addressone,AddressTwo,Town,County,Country,Postcode,CreatedOn,ModifiedOn 
	from [dbo].[ARC]
	order by createdon desc

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetARCEmailCC]    Script Date: 12/14/2015 17:06:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SRI
-- Create date: 23/08/2013
-- Description:	Get CC EMAIL ADDRESS OF AN ARC
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetARCEmailCC]
	-- Add the parameters for the stored procedure here
	@ARCID AS INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ISNULL(ARC_CCEmail,'')ARC_CCEMAIL FROM dbo.ARC WHERE ARCId = @ARCID 

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GenerateOrderReportByARCAndInstaller]    Script Date: 12/14/2015 17:06:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC USP_GenerateOrderReportByARCAndInstaller Null,Null,Null,Null  
CREATE PROCEDURE [dbo].[USP_GenerateOrderReportByARCAndInstaller](@StartDate Datetime=null,@EndDate DateTime= Null,@ARCCode varchar(15) = Null,@InstallerCode Varchar(15) = NULL)  
As  
  
Begin  
  
if(@StartDate is null or @StartDate ='')  
begin  
--Set @StartDate = DATEADD(dd, -DAY(Getdate()) + 1, Getdate())  --Set Current Month FirstDay  
Set @StartDate = DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0)  --Set PreviousMonth FirstDay  
end  
  
if(@EndDate is null or @EndDate ='')  
begin  
--Set @EndDate =  DATEADD(dd, -DAY(DATEADD(mm, 1, Getdate())), DATEADD(mm, 1, Getdate())) --Set Current Month Last Day  
Set @EndDate =  DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)) --Set Previous Month last Day  
end  
  
if(isnull(@ARCCode,'')= '') and (isnull(@InstallerCode,'')= '')  
begin  
set @ARCCode = 'CC,C5,CE'  
end  
  
  
  
  
if (@ARCCode is not null)  
  Begin  
  
    SELECT o.ProcessedOn,i.CompanyName Installer,ar.CompanyName ARC,ISNULL(oid.IsFOC,'')IsFOC,ISNULL(oid.IsReplacement,'')IsReplacement,oi.IsCSD,a.ContactName,a.AddressOne,ISNULL(a.AddressTwo,'')AddressTwo,a.Town,
    ISNULL(a.County,'')County,a.PostCode,p.ProductCode,C.CategoryName  
  FROM  [Orders] o  
  join Installer i on o.InstallerId = i.InstallerCompanyID  
  join OrderItems oi on o.OrderId = oi.OrderId  
  join OrderItemDetails oid on oi.OrderItemId = oid.OrderItemId  
  join Address a on o.DeliveryAddressId = a.AddressId  
  join ARC ar on o.ARC_Code = ar.ARC_Code  
  join Products p on oi.ProductId = p.ProductId 
  join Category c on oi.CategoryId = C.CategoryId 
  where o.ProcessedOn between @StartDate and  @EndDate and o.ARC_Code COLLATE DATABASE_DEFAULT in ( select items from dbo.Split(@ARCCode,','))  
  order by o.ProcessedOn  
  
  End  
    
  
 if (@InstallerCode is not null)  
  
 Begin  
  
  SELECT o.ProcessedOn,i.CompanyName Installer,ar.CompanyName ARC,ISNULL(oid.IsFOC,'')IsFOC,ISNULL(oid.IsReplacement,'')IsReplacement,oi.IsCSD,a.ContactName,a.AddressOne,
  ISNULL(a.AddressTwo,'')AddressTwo,a.Town,ISNULL(a.County,'')County,a.PostCode,p.ProductCode,C.CategoryName  
  FROM [Orders] o  
  join Installer i on o.InstallerId = i.InstallerCompanyID  
  join OrderItems oi on o.OrderId = oi.OrderId  
  join OrderItemDetails oid on oi.OrderItemId = oid.OrderItemId  
  join Address a on o.DeliveryAddressId = a.AddressId  
  join ARC ar on o.ARC_Code = ar.ARC_Code  
  join Products p on oi.ProductId = p.ProductId 
  join Category c on oi.CategoryId = C.CategoryId 
  where o.ProcessedOn between @StartDate and @EndDate and i.CompanyName like '%Chubb%'   
  and i.InstallerCode COLLATE DATABASE_DEFAULT in (select items from dbo.Split(@InstallerCode,','))  
  order by o.ProcessedOn  
   
 End  
 End
GO
/****** Object:  StoredProcedure [dbo].[USP_CreateOrderForUser]    Script Date: 12/14/2015 17:06:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_CreateOrderForUser]    
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
 
   Select @OrderNo = IsNull(MAX(IsNull(Cast(OrderNo as Int), 1000)) + 1, 1001) from Orders   
   where orderid > 89396 and OrderNo not in (  
-- Accidentally the orderno was increased to 186533 from 86533 which resulted in orderno to go far ahead,   
-- below must be avoided for new orders  
'186578','186577','186576','186575','186574','186573','186572','186571','186570',
'186569','186568','186567','186566','186565','186564','186563','186562','186561','186560','186559','186558','186557','186556','186555','186554',  
'186553','186552','186551','186550','186549','186548','186547','186546','186545','186544','186543','186542','186541','186540',  
'186539','186538','186537','186536','186535','186534','99007 ','99006 ','99005 ','99004 ','99003 ','99002 ','99001',
'186608','186607','186606','186605','186604','186603','186602','186601','186600','186599','186598','186597','186596','186595','186594','186593',
'186592','186591','186590','186589','186588','186609','186610','186611','186612','186613','186614'
)  
   
 if(@OrderNo = 186532)  
 Select @OrderNo = IsNull(MAX(IsNull(Cast(OrderNo as Int), 1000)) + 500, 1001) from Orders   
     
       
   If @OrderNo Is Null    
    Set @OrderNo = 100001    
       
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
GO
/****** Object:  StoredProcedure [dbo].[USP_GetUserRegisteredSIMForM2M]    Script Date: 12/14/2015 17:06:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sri
-- Create date: <Create Date,,>
-- Description:	edited by Ravi to override null dates
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetUserRegisteredSIMForM2M]
	-- Add the parameters for the stored procedure here
	@userId uniqueidentifier
AS
BEGIN

IF  dbo.fn_IsM2MAdminUser(@userId) = 1 
BEGIN 

      
	SELECT 
    d.[ID] AS [ID], 
    d.[Dev_Code] AS [ICCID], 
    b.[Description] AS [Description], 
    us.[OverUsageAlert] AS [OverUsageAlert], 
    d.SIM_Status AS [Status], 
    d.[Dev_Usage] AS [Usage], 
    d.[Dev_IMSINumber] AS [IMSI], 
    d.[Dev_MSISDN] AS [MSISDN], 
    p.[ProductName] AS [ProductName],
	d.dev_voiceusage as [VoiceUsage],
	d.dev_smsusage as [SMSUsage],
	isnull(d.Dev_Usage_EndDate ,'1900-01-01') as [UsagetillDate] ,
	us.SIMReference 
    FROM    [dbo].[UserSIMS] AS us
    INNER JOIN [dbo].[Device_API] AS d ON us.[DeviceID] = d.[ID]
    INNER JOIN [dbo].[BillingCycle] AS b ON us.[BillingCycleID] = b.[ID]
    INNER JOIN [dbo].[Products] AS p ON us.[ProductId] = p.[ProductId]   
	INNER JOIN dbo.USERMAPPING on USERMAPPING.UserID = US.USerID AND USERMAPPING.UniqueCode = ( select UniqueCode FROM USERMAPPING WHERE UserID=@userId ) 


END 
ELSE 
BEGIN 
      
	SELECT 
    d.[ID] AS [ID], 
    d.[Dev_Code] AS [ICCID], 
    b.[Description] AS [Description], 
    us.[OverUsageAlert] AS [OverUsageAlert], 
    d.SIM_Status AS [Status], 
    d.[Dev_Usage] AS [Usage], 
    d.[Dev_IMSINumber] AS [IMSI], 
    d.[Dev_MSISDN] AS [MSISDN], 
    p.[ProductName] AS [ProductName],
	d.dev_voiceusage as [VoiceUsage],
	d.dev_smsusage as [SMSUsage],
	isnull(d.Dev_Usage_EndDate ,'1900-01-01') as [UsagetillDate] ,
	us.SIMReference 
    FROM    [dbo].[UserSIMS] AS us
    INNER JOIN [dbo].[Device_API] AS d ON us.[DeviceID] = d.[ID] and us.UserID=@userId
    INNER JOIN [dbo].[BillingCycle] AS b ON us.[BillingCycleID] = b.[ID]
    INNER JOIN [dbo].[Products] AS p ON us.[ProductId] = p.[ProductId]   
END 

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetUserDetailsByUserId]    Script Date: 12/14/2015 17:06:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--USP_GetUserDetailsByUserId '5ddad919-f5ee-4a18-b504-73a06c7885c4'  
  
CREATE PROCEDURE [dbo].[USP_GetUserDetailsByUserId]   
(@UserId NVARCHAR(256))  
AS  
BEGIN TRY  
    BEGIN  
        SELECT ISNULL (a.ARCId,'')ARCId,  
               ISNULL(a.ARC_Code,'')ARC_Code,  
               ISNULL(a.CompanyName,'')CompanyName,  
               usrs.UserId,  
               usrs.UserName,  
               roles.RoleName,  
               memship.Email,  
               memship.IsApproved,  
               memship.IsLockedOut,  
               memship.Password,  
               memship.PasswordQuestion,  
               memship.PasswordAnswer  
        FROM   CSLOrdering.dbo.aspnet_Users usrs  
               LEFT JOIN CSLOrdering.dbo.aspnet_UsersInRoles UsrRoles  
                    ON  usrs.UserId = UsrRoles.UserId  
               LEFT JOIN CSLOrdering.dbo.aspnet_Roles roles  
                    ON  roles.RoleId = UsrRoles.RoleId  
               LEFT JOIN CSLOrdering.dbo.aspnet_Membership memship  
                    ON  memship.UserId = usrs.UserId  
               LEFT JOIN ARC_User_Map aum  
                    ON  aum.UserId = usrs.UserId  
               LEFT JOIN ARC a  
                    ON  a.ARCId = aum.ARCId  
        WHERE  usrs.UserId = @UserId  
    END  
END TRY           
BEGIN CATCH  
    EXEC USP_SaveSPErrorDetails   
    RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetPreviousOrdersDependentProductsByProductId]    Script Date: 12/14/2015 17:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetPreviousOrdersDependentProductsByProductId]
(
	@OrderId int,
	@ProductId int,
	@CategoryId int
)
As
BEGIN TRY 

Begin
	Select odi.ProductId, P.ProductCode, P.ProductName, odi.Price,'' ProductQty, IsNull(odi.Price,0) as DependentProductPriceTotal
		From OrderDependentItems odi
		Inner Join
		OrderItems OI on OI.OrderItemId = odi.OrderItemId
		Inner Join
		Orders O on O.OrderId = OI.OrderId
		Inner Join
		Products P on P.ProductId = odi.ProductId
		Where 
			O.OrderId = @OrderId 
			And OI.ProductId = @ProductId
			aND OI.CategoryId = @CategoryId
End

END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetOrderDetailsforReport]    Script Date: 12/14/2015 17:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetOrderDetailsforReport]
	@OrderItemId INT
AS
BEGIN TRY
    BEGIN
        SELECT t1.OrderItemId,
               [t2].[GPRSNo],
               [t2].[PSTNNo],
               [t2].[GSMNo],
               [t2].[LANNo],
               [t2].[GPRSNoPostCode],
               [t2].[ICCID],
               [t4].[OrderStatus] AS [OrderItemStatus],
               [t3].[OptionName],
               t2.SiteName SiteName
               
        FROM   [dbo].[Orders] AS [t0]
               INNER JOIN [dbo].[OrderItems] AS [t1]
                    ON  [t0].[OrderId] = [t1].[OrderId]
               INNER JOIN [dbo].[OrderItemDetails] AS [t2]
                    ON  [t1].[OrderItemId] = [t2].[OrderItemId]
               LEFT JOIN [dbo].[Options] AS [t3]
                    ON  [t2].[OptionId] = ([t3].[OptID])
               INNER JOIN [dbo].[OrderStatusMaster] AS [t4]
                    ON  [t1].[OrderItemStatusId] = [t4].[OrderStatusId]
        WHERE  ([t1].[OrderItemId] = @OrderItemId)
               AND ([t2].[GPRSNo] <> '')
    END
END TRY

BEGIN CATCH
    EXEC USP_SaveSPErrorDetails 
    RETURN -1
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetNewAddedItem]    Script Date: 12/14/2015 17:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetNewAddedItem]
	@OrderId INT
AS
BEGIN TRY
    BEGIN
        SELECT DISTINCT [t0].[OrderItemId],
               ISNULL( [t0].[ProductQty],0)ProductQty,
               ISNULL([t0].[IsNewItem],0)IsNewItem,
               ISNULL(t1.IsFOC,0)IsFOC,
               ISNULL(t2.ProductCode,0)ProductCode
        FROM   [dbo].[OrderItems] AS [t0]
               LEFT JOIN [dbo].[OrderItemDetails] AS [t1]
                    ON  [t0].[OrderItemId] = [t1].[OrderItemId]
               INNER JOIN [dbo].[Products] AS [t2]
                    ON  [t0].[ProductId] = [t2].[ProductId]
        WHERE  ([t0].[OrderId] = @OrderId)
               AND ([t0].[IsNewItem] = 1)
    END
END TRY             
BEGIN CATCH
    EXEC USP_SaveSPErrorDetails 
    RETURN -1
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetUpgradeProducts]    Script Date: 12/14/2015 17:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetUpgradeProducts]
	-- Add the parameters for the stored procedure here
	@ICCID NVARCHAR(250)
AS
BEGIN
	
	
	SELECT d.Dev_Code as ICCID,d.Dev_Usage as Usage,d.Dev_IMSINumber as IMSI,d.Dev_MSISDN as MSISDN,p.ProductId,p.ProductCode,p.ProductName,p.Price FROM Device_API d 
												INNER JOIN UserSIMS u on d.ID=u.DeviceID
												INNER JOIN Upgrade_Product_Map up on up.ProductID =u.ProductID
												INNER JOIN  Products p on p.ProductId= up.UpgradeProductID  
												WHERE Dev_Code=@ICCID

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetSimUsageByDataPlan]    Script Date: 12/14/2015 17:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

-- Author:		<Author,,Name>

-- Create date: <Create Date,,>

-- Description:	<Description,,>

-- =============================================
CREATE PROCEDURE [dbo].[USP_GetSimUsageByDataPlan]

	 @userId UNIQUEIDENTIFIER

AS

BEGIN

	DECLARE @NoDAYs FLOAT 
	
	SELECT @NoDAYs = datediff(day, dateadd(day, 1-day(GETDATE()), GETDATE()),
              dateadd(month, 1, dateadd(day, 1-day(GETDATE()), GETDATE()))) + 0.00 

			    IF  dbo.fn_IsM2MAdminUser(@userId) = 1 
			BEGIN   

		       SELECT  Products.ProductName,((isnull(Count(products.ProductID),0) * Allowance) / @NoDAYs) * day(getdate()) as Allowance, 
			   SUM(ISNULL(Dev_usage,0)) as Usage
			    FROM UserSIMS  
				INNER JOIN Products on UserSIMS.ProductId=Products.ProductId
				INNER JOIN Device_API ON UserSIMS.DeviceID = Device_API.ID 
				INNER JOIN dbo.USERMAPPING on USERMAPPING.UserID = UserSIMS.USerID AND USERMAPPING.UniqueCode = ( select UniqueCode FROM USERMAPPING WHERE UserID=@userId ) 
				GROUP BY Products.ProductName,Products.productid, Products.Allowance
				HAVING SUM(ISNULL(Dev_usage,0)) > 0 
			END 
			ELSE 
			BEGIN
				SELECT  Products.ProductName,((isnull(Count(products.ProductID),0) * Allowance) / @NoDAYs) * day(getdate()) as Allowance, 
			   SUM(ISNULL(Dev_usage,0)) as Usage
			    FROM UserSIMS  
				INNER JOIN Products on UserSIMS.ProductId=Products.ProductId
				INNER JOIN Device_API ON UserSIMS.DeviceID = Device_API.ID 
				WHERE UserSIMS.UserID=@userId
				GROUP BY Products.ProductName,Products.productid, Products.Allowance
				HAVING SUM(ISNULL(Dev_usage,0)) > 0 
			END 

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetSimByDataPlan]    Script Date: 12/14/2015 17:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

-- Author:		<Author,,Name>

-- Create date: <Create Date,,>

-- Description:	<Description,,>

-- =============================================
CREATE PROCEDURE [dbo].[USP_GetSimByDataPlan]

	 @userId UNIQUEIDENTIFIER

AS

BEGIN

      IF  dbo.fn_IsM2MAdminUser(@userId) = 1 
			BEGIN    

		       SELECT  p.ProductName,COUNT(p.ProductId) Total FROM UserSIMS u 

															   INNER JOIN Products p on u.ProductId=p.ProductId
															   INNER JOIN dbo.USERMAPPING on USERMAPPING.UserID = u.USerID AND USERMAPPING.UniqueCode = ( select UniqueCode FROM USERMAPPING WHERE UserID=@userId ) 
															   

																GROUP BY p.ProductName,u.productid
			END 
		ELSE 
			BEGIN 
				    SELECT  p.ProductName,COUNT(p.ProductId) Total FROM UserSIMS u 

															   INNER JOIN Products p on u.ProductId=p.ProductId

															   WHERE u.UserID=@userId

																GROUP BY p.ProductName,u.productid
			END 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetShippingOptionsForM2M]    Script Date: 12/14/2015 17:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ajitender Vijay
-- Create date: <Create Date,,>
-- Description:	Get List of Shipping Options
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetShippingOptionsForM2M] --'D312A30F-61E3-44A6-958C-68F510335ABE','61'
-- Add the parameters for the stored procedure here
	-- [USP_GetShippingOptionsForM2M] null, 49
	
	@InstallerCompanyID UNIQUEIDENTIFIER,
	@OrderId INT
AS

BEGIN TRY  
BEGIN
    SELECT distinct temp.DeliveryTypeId,
           temp.DeliveryCompanyName,
           '' as DeliveryCompanyDesc,
           temp.DeliveryShortDesc,
           temp.DeliveryPrice,
           temp.DeliveryCode
    FROM   (
               -- DeliveryTypes didn't have any offer
               SELECT dt.DeliveryTypeId,
                      dt.DeliveryCompanyName,
                      dt.DeliveryCompanyDesc,
                      dt.DeliveryShortDesc,
                      dt.DeliveryPrice,
                      dt.DeliveryCode
               FROM   DeliveryType dt
               WHERE  dt.IsDeleted = 0
                      AND dt.DeliveryTypeId <> (
                              SELECT KeyValue
                              FROM   ApplicationSetting app
                              WHERE  app.KeyName = 'MergeDeliveryTypeId'
                          )
                      AND dt.DeliveryTypeId NOT IN (SELECT do.DeliveryTypeId
                                                    FROM   DeliveryOffers do
                                                    )
               
               UNION ALL 
               -- DeliveryTypes they have offer


               
               SELECT dt.DeliveryTypeId,
                      dt.DeliveryCompanyName,
                      dt.DeliveryCompanyDesc,
                      dt.DeliveryShortDesc,
                      isnull((select SUM(oi.ProductQty)* dt.DeliveryPrice from  orderitems oi where  oi.ProductId in (do.ProductId) and dt.EachProductPrice = 1 and oi.OrderId = @OrderId),dt.DeliveryPrice) AS DeliveryPrice,
                      dt.DeliveryCode
               FROM   DeliveryType dt
                      INNER JOIN DeliveryOffers do
                           ON  dt.DeliveryTypeId = do.DeliveryTypeId
                           AND dt.IsDeleted = 0
                           AND dt.DeliveryTypeId <> (
                                   SELECT KeyValue
                                   FROM   ApplicationSetting app
                                   WHERE  app.KeyName = 'MergeDeliveryTypeId'
                               )
               WHERE  CONVERT(VARCHAR(20), GETDATE(), 102) < CONVERT(VARCHAR(20), do.ExpiryDate, 102)
                      AND (
                              do.OrderValue = (SELECT  Amount
                                                  FROM   Orders 
                                                  WHERE  OrderId = @OrderId and Amount > 0)
                              OR do.ProductId IN (SELECT oi.ProductId
                                                  FROM   OrderItems oi
                                                  WHERE  oi.OrderId = @OrderId and oi.ProductQty between do.MinQty and do.MaxQty) 
                              OR do.InstallerCompanyID = @InstallerCompanyID
							  OR do.CategoryID IN (SELECT oi.CategoryID
                                                  FROM   OrderItems oi
                                                  WHERE  oi.OrderId = @OrderId 
												  Group by oi.CategoryID
												  having  sum(oi.ProductQty) between do.MinQty and do.MaxQty) 
                               
                          )
					 AND  EXISTS ( SELECT OrderItemID FROM ORDERITEMS WHERE ORDERID = @ORDERID AND ISCSD != 1)
				
				UNION ALL -- ACtivation only Order 

				  SELECT dt.DeliveryTypeId,
                      dt.DeliveryCompanyName,
                      dt.DeliveryCompanyDesc,
                      dt.DeliveryShortDesc,
                      isnull((select SUM(oi.ProductQty)* dt.DeliveryPrice from  orderitems oi where  oi.ProductId in (do.ProductId) and dt.EachProductPrice = 1 and oi.OrderId = @OrderId),dt.DeliveryPrice) AS DeliveryPrice,
                      dt.DeliveryCode
               FROM   DeliveryType dt
                      INNER JOIN DeliveryOffers do
                           ON  dt.DeliveryTypeId = do.DeliveryTypeId
                           AND dt.IsDeleted = 0
                           AND dt.DeliveryTypeId <> (
                                   SELECT KeyValue
                                   FROM   ApplicationSetting app
                                   WHERE  app.KeyName = 'MergeDeliveryTypeId'
                               )
			  WHERE dt.DeliveryCode = 'Activation'
				 AND NOT  EXISTS ( SELECT OrderItemID FROM ORDERITEMS WHERE ORDERID = @ORDERID AND ISCSD != 1)
				 

           ) AS temp
		   order by DeliveryPrice
END
END TRY
BEGIN CATCH          
    EXEC USP_SaveSPErrorDetails           
    RETURN -1          
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetShippingOptions2]    Script Date: 12/14/2015 17:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetShippingOptions2]
-- Add the parameters for the stored procedure here
	 
	@ARCId INT,
	@InstallerCompanyID UNIQUEIDENTIFIER,
	@OrderId INT
AS

BEGIN TRY  
BEGIN
	
	Declare @icount INT 
	Declare @isActivation Bit 


	SELECT @icount= COUNT(Orderitems.OrderitemID)  FROM 
	ORders 
	INNER JOIN ORDERITEMS ON ORderITEMS.OrderiD = Orders.OrderID 
	WHERE  ORDERITEMS.ISCSD =0 AND ORDERS.ORderID = @OrderId

	IF @icount = 0 
		Begin 
		SET @isActivation = 1
		End 
	
	
    SELECT temp.DeliveryTypeId,
           temp.DeliveryCompanyName,
           temp.DeliveryCompanyDesc,
           temp.DeliveryShortDesc,
           temp.DeliveryPrice,
           temp.DeliveryCode
    FROM   (
               -- DeliveryTypes didn't have any offer
               SELECT dt.DeliveryTypeId,
                      dt.DeliveryCompanyName,
                      dt.DeliveryCompanyDesc,
                      dt.DeliveryShortDesc,
                      dt.DeliveryPrice,
                      dt.DeliveryCode
               FROM   DeliveryType dt
               WHERE  dt.IsDeleted = 0
                      AND dt.DeliveryTypeId <> (
                              SELECT KeyValue
                              FROM   ApplicationSetting app
                              WHERE  app.KeyName = 'MergeDeliveryTypeId'
                          )
                      AND dt.DeliveryTypeId NOT IN (SELECT do.DeliveryTypeId
                                                    FROM   DeliveryOffers do
                                                    WHERE  CONVERT(VARCHAR(20), GETDATE(), 102) 
                                                           < CONVERT(VARCHAR(20), do.ExpiryDate, 102))
					  AND EXISTS -- **  Country specific Offers ; Sri 25/03/14  **
					  (
						Select ARC.ARCID FROM ARC WHERE ARCID= @ARCID AND (ARC.CountryCode = dt.CountryCode  OR ARC.CountryCode is null)
					  )
               
               UNION ALL 
               -- DeliveryTypes they have offer
               
               SELECT dt.DeliveryTypeId,
                      dt.DeliveryCompanyName,
                      dt.DeliveryCompanyDesc,
                      dt.DeliveryShortDesc,
                      dt.DeliveryPrice,
                      dt.DeliveryCode
               FROM   DeliveryType dt
                      INNER JOIN DeliveryOffers do
                           ON  dt.DeliveryTypeId = do.DeliveryTypeId
                           AND dt.IsDeleted = 0
                           AND dt.DeliveryTypeId <> (
                                   SELECT KeyValue
                                   FROM   ApplicationSetting app
                                   WHERE  app.KeyName = 'MergeDeliveryTypeId'
                               )
               WHERE  CONVERT(VARCHAR(20), GETDATE(), 102) < CONVERT(VARCHAR(20), do.ExpiryDate, 102)
                      AND (
                              (do.OrderValue <= (SELECT  Amount
                                                  FROM   Orders 
                                                  WHERE  OrderId = @OrderId)
							  OR do.OrderValue = '0.00')
                              AND (do.ARCId = @ARCId 
							  OR do.ARCId = '-1')
                              AND (do.ProductId IN (SELECT oi.ProductId
                                                  FROM   OrderItems oi
                                                  WHERE  oi.OrderId = @OrderId) 
							  OR do.ProductId = '-1') 
                              AND (do.InstallerCompanyID = @InstallerCompanyID 
							  OR do.InstallerCompanyID is null)
                               
							  AND (do.ISActivation = @isActivation 
							  OR do.ISActivation is null)


                          )
           ) AS temp
END
END TRY
BEGIN CATCH          
    EXEC USP_SaveSPErrorDetails           
    RETURN -1          
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetShippingOptions_Failed]    Script Date: 12/14/2015 17:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetShippingOptions_Failed]
-- Add the parameters for the stored procedure here
	 
	@ARCId INT,
	@InstallerCompanyID UNIQUEIDENTIFIER,
	@OrderId INT
AS

BEGIN TRY  
BEGIN
	
	Declare @icount INT 
	Declare @isActivation Bit 


	SELECT @icount= COUNT(Orderitems.OrderitemID)  FROM 
	ORders 
	INNER JOIN ORDERITEMS ON ORderITEMS.OrderiD = Orders.OrderID 
	WHERE  ORDERITEMS.ISCSD =0 AND ORDERS.ORderID = @OrderId

	SET @isActivation = 0
	IF @icount = 0 
		Begin 
		SET @isActivation = 1
		End 
	
	
    SELECT temp.DeliveryTypeId,
           temp.DeliveryCompanyName,
           temp.DeliveryCompanyDesc,
           temp.DeliveryShortDesc,
           temp.DeliveryPrice,
           temp.DeliveryCode
    FROM   (
               -- DeliveryTypes didn't have any offer
               SELECT dt.DeliveryTypeId,
                      dt.DeliveryCompanyName,
                      dt.DeliveryCompanyDesc,
                      dt.DeliveryShortDesc,
                      dt.DeliveryPrice,
                      dt.DeliveryCode
               FROM   DeliveryType dt
               WHERE  dt.IsDeleted = 0
                      AND dt.DeliveryTypeId <> (
                              SELECT KeyValue
                              FROM   ApplicationSetting app
                              WHERE  app.KeyName = 'MergeDeliveryTypeId'
                          )
                      AND dt.DeliveryTypeId NOT IN (SELECT do.DeliveryTypeId
                                                    FROM   DeliveryOffers do
                                                    WHERE  CONVERT(VARCHAR(20), GETDATE(), 102) 
                                                           < CONVERT(VARCHAR(20), do.ExpiryDate, 102))
					  AND EXISTS -- **  Country specific Offers ; Sri 25/03/14  **
					  (
						Select ARC.ARCID FROM ARC WHERE ARCID= @ARCID AND (ARC.CountryCode = dt.CountryCode  OR ARC.CountryCode is null)
					  )
               
               UNION ALL 
               -- DeliveryTypes they have offer
               
               SELECT  dt.DeliveryTypeId,
                      dt.DeliveryCompanyName,
                      dt.DeliveryCompanyDesc,
                      dt.DeliveryShortDesc,
                      dt.DeliveryPrice,
                      dt.DeliveryCode
               FROM   DeliveryType dt
                      INNER JOIN DeliveryOffers do
                           ON  dt.DeliveryTypeId = do.DeliveryTypeId
                           AND dt.IsDeleted = 0
                           AND dt.DeliveryTypeId <> (
                                   SELECT KeyValue
                                   FROM   ApplicationSetting app
                                   WHERE  app.KeyName = 'MergeDeliveryTypeId'
                               )
               WHERE  CONVERT(VARCHAR(20), GETDATE(), 102) < CONVERT(VARCHAR(20), do.ExpiryDate, 102)
                      AND (
                              (do.OrderValue <= (SELECT  Amount
                                                  FROM   Orders 
                                                  WHERE  OrderId = @OrderId)
							  OR do.OrderValue = '0.00')
                              AND (do.ARCId = @ARCId 
							  OR do.ARCId = '-1')
                              AND (do.ProductId IN (SELECT oi.ProductId
                                                  FROM   OrderItems oi
                                                  WHERE  oi.OrderId = @OrderId) 
							  OR do.ProductId = '-1') 
                              AND (do.InstallerCompanyID = @InstallerCompanyID 
							  OR do.InstallerCompanyID is null)
                               
							  AND ((@isActivation = 1 AND do.deliveryTYPEID =9) or do.deliveryTYPEID =0  )


                          ) 
           ) AS temp
END
END TRY
BEGIN CATCH          
    EXEC USP_SaveSPErrorDetails           
    RETURN -1          
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetShippingOptions_copy]    Script Date: 12/14/2015 17:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetShippingOptions_copy]
-- Add the parameters for the stored procedure here
	 
	@ARCId INT,
	@InstallerCompanyID UNIQUEIDENTIFIER,
	@OrderId INT
AS

BEGIN TRY  
BEGIN
    SELECT temp.DeliveryTypeId,
           temp.DeliveryCompanyName,
           temp.DeliveryCompanyDesc,
           temp.DeliveryShortDesc,
           temp.DeliveryPrice,
           temp.DeliveryCode
    FROM   (
               -- DeliveryTypes didn't have any offer
               SELECT dt.DeliveryTypeId,
                      dt.DeliveryCompanyName,
                      dt.DeliveryCompanyDesc,
                      dt.DeliveryShortDesc,
                      dt.DeliveryPrice,
                      dt.DeliveryCode
               FROM   DeliveryType dt
               WHERE  dt.IsDeleted = 0
                      AND dt.DeliveryTypeId <> (
                              SELECT KeyValue
                              FROM   ApplicationSetting app
                              WHERE  app.KeyName = 'MergeDeliveryTypeId'
                          )
                      AND dt.DeliveryTypeId NOT IN (SELECT do.DeliveryTypeId
                                                    FROM   DeliveryOffers do
                                                    WHERE  CONVERT(VARCHAR(20), GETDATE(), 102) 
                                                           < CONVERT(VARCHAR(20), do.ExpiryDate, 102))
					  AND EXISTS -- **  Country specific Offers ; Sri 25/03/14  **
					  (
						Select ARC.ARCID FROM ARC WHERE ARCID= @ARCID AND (ARC.CountryCode = dt.CountryCode  OR ARC.CountryCode is null)
					  )
               
               UNION ALL 
               -- DeliveryTypes they have offer
               
               SELECT dt.DeliveryTypeId,
                      dt.DeliveryCompanyName,
                      dt.DeliveryCompanyDesc,
                      dt.DeliveryShortDesc,
                      dt.DeliveryPrice,
                      dt.DeliveryCode
               FROM   DeliveryType dt
                      INNER JOIN DeliveryOffers do
                           ON  dt.DeliveryTypeId = do.DeliveryTypeId
                           AND dt.IsDeleted = 0
                           AND dt.DeliveryTypeId <> (
                                   SELECT KeyValue
                                   FROM   ApplicationSetting app
                                   WHERE  app.KeyName = 'MergeDeliveryTypeId'
                               )
               WHERE  CONVERT(VARCHAR(20), GETDATE(), 102) < CONVERT(VARCHAR(20), do.ExpiryDate, 102)
                      AND (
                              (do.OrderValue <= (SELECT  Amount
                                                  FROM   Orders 
                                                  WHERE  OrderId = @OrderId)
							  OR do.OrderValue = '0.00')
                              AND (do.ARCId = @ARCId 
							  OR do.ARCId = '-1')
                              AND (do.ProductId IN (SELECT oi.ProductId
                                                  FROM   OrderItems oi
                                                  WHERE  oi.OrderId = @OrderId) 
							  OR do.ProductId = '-1') 
                              AND (do.InstallerCompanyID = @InstallerCompanyID 
							  OR do.InstallerCompanyID is null)
                               
                          )
           ) AS temp
END
END TRY
BEGIN CATCH          
    EXEC USP_SaveSPErrorDetails           
    RETURN -1          
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetShippingOptions]    Script Date: 12/14/2015 17:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetShippingOptions]
-- Add the parameters for the stored procedure here
	 
	@ARCId INT,
	@InstallerCompanyID UNIQUEIDENTIFIER,
	@OrderId INT
AS

BEGIN TRY  
BEGIN
    SELECT temp.DeliveryTypeId,
           temp.DeliveryCompanyName,
           temp.DeliveryCompanyDesc,
           temp.DeliveryShortDesc,
           temp.DeliveryPrice,
           temp.DeliveryCode
    FROM   (
               -- DeliveryTypes didn't have any offer
               SELECT dt.DeliveryTypeId,
                      dt.DeliveryCompanyName,
                      dt.DeliveryCompanyDesc,
                      dt.DeliveryShortDesc,
                      dt.DeliveryPrice,
                      dt.DeliveryCode
               FROM   DeliveryType dt
               WHERE  dt.IsDeleted = 0
                      AND dt.DeliveryTypeId <> (
                              SELECT KeyValue
                              FROM   ApplicationSetting app
                              WHERE  app.KeyName = 'MergeDeliveryTypeId'
                          )
                      AND dt.DeliveryTypeId NOT IN (SELECT do.DeliveryTypeId
                                                    FROM   DeliveryOffers do
                                                    WHERE  CONVERT(VARCHAR(20), GETDATE(), 102) 
                                                           < CONVERT(VARCHAR(20), do.ExpiryDate, 102))
					  AND EXISTS -- **  Country specific Offers ; Sri 25/03/14  **
					  (
						Select ARC.ARCID FROM ARC WHERE ARCID= @ARCID AND (ARC.CountryCode = dt.CountryCode  OR isnull(ARC.CountryCode,'UK') ='UK')
					  )
               
               UNION ALL 
               -- DeliveryTypes they have offer
               
               SELECT dt.DeliveryTypeId,
                      dt.DeliveryCompanyName,
                      dt.DeliveryCompanyDesc,
                      dt.DeliveryShortDesc,
                      dt.DeliveryPrice,
                      dt.DeliveryCode
               FROM   DeliveryType dt
                      INNER JOIN DeliveryOffers do
                           ON  dt.DeliveryTypeId = do.DeliveryTypeId
                           AND dt.IsDeleted = 0
                           AND dt.DeliveryTypeId <> (
                                   SELECT KeyValue
                                   FROM   ApplicationSetting app
                                   WHERE  app.KeyName = 'MergeDeliveryTypeId'
                               )
               WHERE  CONVERT(VARCHAR(20), GETDATE(), 102) < CONVERT(VARCHAR(20), do.ExpiryDate, 102)
                      AND (
                              (do.OrderValue <= (SELECT  Amount
                                                  FROM   Orders 
                                                  WHERE  OrderId = @OrderId)
							  OR do.OrderValue = '0.00')
                              AND (do.ARCId = @ARCId 
							  OR do.ARCId = '-1')
                              AND (do.ProductId IN (SELECT oi.ProductId
                                                  FROM   OrderItems oi
                                                  WHERE  oi.OrderId = @OrderId) 
							  OR do.ProductId = '-1') 
                              AND (do.InstallerCompanyID = @InstallerCompanyID 
							  OR do.InstallerCompanyID is null)

							  AND (do.CategoryID IN  (SELECT oi.CategoryID
                                                  FROM   OrderItems oi
                                                  WHERE  oi.OrderId = @OrderId 
												  Group by oi.CategoryID
												  having  sum(oi.ProductQty) between do.MinQty and do.MaxQty ) OR  do.CategoryID = '-1') 
                               
                          )
           ) AS temp
END
END TRY
BEGIN CATCH          
    EXEC USP_SaveSPErrorDetails           
    RETURN -1          
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetRelatedProductsByProductId]    Script Date: 12/14/2015 17:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_GetRelatedProductsByProductId]
@ProductId int
As
BEGIN TRY 
Begin
	
	Select t.ProductId, t.ProductCode, t.ProductName, t.DefaultImage, t.ProductType,
		case IsNull(t.ARC_Price,0) when 0 then t.Price else t.ARC_Price end as Price, t.ListOrder
		from
		(Select p.ProductId, p.ProductCode, p.ProductName, p.DefaultImage, p.ProductType,
			p.Price, ppm.Price as ARC_Price, p.ListOrder  
			from Products p		
			left join
			ARC_Product_Price_Map ppm on ppm.ProductId = p.ProductId and DATEDIFF(d,isnull(ppm.ExpiryDate,getdate()),GETDATE())>0 And ppm.IsDeleted=0
			where p.IsDeleted = 0 And p.IsDependentProduct = 0 And p.ProductId in
				(Select RelatedProductId From RelatedProducts Where ProductId = @ProductId)
		) t
		order by t.ListOrder
End

END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetProductsByCategoryAndArc]    Script Date: 12/14/2015 17:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetProductsByCategoryAndArc]
	@CategoryId INT,
	@ARC_Id INT
AS
BEGIN TRY
    BEGIN
        SELECT t.ProductId,
               t.ProductCode,
               t.ProductName,
               t.DefaultImage,
               t.ProductType,
               CASE ISNULL(t.ARC_Price, 0)
                    WHEN 0 THEN t.Price
                    ELSE t.ARC_Price
               END AS Price,
               t.ListOrder,
               t.IsCSD,
               t.IsSiteName,
               t.IsReplenishment
        FROM   (
                   SELECT Distinct p.ProductId,
                          p.ProductCode,
                          p.ProductName,
                          p.DefaultImage,
                          p.ProductType,
                          p.Price,
                          ppm.Price AS ARC_Price,
                          p.ListOrder,
                          ISNULL(p.IsCSD, 0)IsCSD,
                          ISNULL(p.IsReplenishment,0) IsReplenishment,
                          ISNULL(p.IsSiteName,0 )IsSiteName
                   FROM   Products p
                          INNER JOIN Category_Product_Map cp
                               ON  cp.ProductId = p.ProductId
                               AND cp.CategoryId = @CategoryId
                          INNER JOIN Product_ARC_Map pam
                               ON  pam.ProductId = p.ProductId AND p.IsDependentProduct = 0 AND p.IsDeleted = 0 
                               AND pam.ARCId = @ARC_Id
                          LEFT JOIN ARC_Product_Price_Map ppm
                               ON  ppm.ProductId = p.ProductId AND ppm.IsDeleted = 0 AND CONVERT(DATETIME, GETDATE()) <= CONVERT(DateTime,ppm.ExpiryDate) AND ppm.ARCId=@ARC_Id
                  
               ) t
        ORDER BY
               t.ListOrder,
               t.ProductName
    END
END TRY         
BEGIN CATCH
    EXEC USP_SaveSPErrorDetails 
    RETURN -1
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_GetProductsByArc]    Script Date: 12/14/2015 17:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetProductsByArc]
	@ARC_Id INT
AS
BEGIN TRY
    BEGIN
        -- Select t.ProductId, t.ProductCode, t.ProductName,
        --t.ARC_Price  Price, t.ListOrder,  case ExpDate when '01/01/1900' then null else ExpDate end ExpDate
        --from
        --(Select p.ProductId, p.ProductCode, p.ProductName,  p.ProductType,
        --	 ppm.Price as ARC_Price, p.ListOrder,ISNULL(CONVERT(VARCHAR(10),ppm.ExpiryDate,101),CONVERT(VARCHAR(10), '01/01/1900 00:00:00.000',101)) ExpDate
        --	from
        --	Products p
        --	inner join
        --	Product_ARC_Map pam on pam.ProductId = p.ProductId And pam.ARCId = @ARC_Id
        --	left join
        --	ARC_Product_Price_Map ppm on ppm.ProductId = p.ProductId AND ppm.ARCId= @ARC_Id and ppm.IsDeleted=0
        
        --	Where p.IsDeleted=0 and p.IsDependentProduct=0
        --) t
        --Order By t.ListOrder
         DECLARE @temp TABLE(ProductId INT ,ProductCode NVARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS,
         ProductName NVARCHAR(512)COLLATE SQL_Latin1_General_CP1_CI_AS,
         ProductType NVARCHAR(10)COLLATE SQL_Latin1_General_CP1_CI_AS,ProductPrice DECIMAL(6,2),ARC_Price DECIMAL(6,2),
         ListOrder INT,ExpDate DATETIME )
        
        
        INSERT   @temp
        SELECT p.ProductId,
               p.ProductCode,
               p.ProductName,
               p.ProductType,
			   p.Price as ProductPrice,
               ppm.Price AS ARC_Price,
               p.ListOrder,
               ISNULL(
                   CONVERT(VARCHAR(10), ppm.ExpiryDate, 101),
                   CONVERT(VARCHAR(10), '01/01/1900 00:00:00.000', 101)
               ) ExpDate 
               
        FROM   Products p
               INNER JOIN Product_ARC_Map pam
                    ON  pam.ProductId = p.ProductId
                    AND pam.ARCId = @ARC_Id
               LEFT JOIN ARC_Product_Price_Map ppm
                    ON  ppm.ProductId = p.ProductId
                    AND ppm.ARCId = @ARC_Id
                    AND ppm.IsDeleted = 0
        WHERE  p.IsDeleted = 0
               AND p.IsDependentProduct = 0  
		ORDER BY p.ProductCode
        
        
        SELECT t.ProductId,
               t.ProductCode,
               t.ProductName,	
			   t.ProductPrice,		   
               t.ARC_Price Price,
               t.ListOrder,
               CASE ExpDate
                   WHEN '01/01/1900' THEN NULL
                    ELSE CONVERT(VARCHAR(10), ExpDate, 103)
               END ExpDate
        FROM   (
                   SELECT p.ProductId,
                          p.ProductCode,
                          p.ProductName,
                          p.ProductType,
						  p.Price AS ProductPrice,
                          ppm.Price AS ARC_Price,
                          p.ListOrder,
                          ISNULL(
                              CONVERT(VARCHAR(10), ppm.ExpiryDate, 101),
                              CONVERT(VARCHAR(10), '01/01/1900 00:00:00.000', 101)
                          ) ExpDate
                   FROM   Product_Dependent_Map pdm
                          INNER JOIN @temp t 
                               ON  pdm.ProductId  = t.ProductId  
                          INNER JOIN Products p
                               ON  p.ProductId   = pdm.DependentProductId   
                          LEFT JOIN ARC_Product_Price_Map ppm
                               ON  ppm.ProductId   = p.ProductId   
                               AND ppm.ARCId   = @ARC_Id   
                               AND ppm.IsDeleted = 0
                   WHERE  p.IsDeleted = 0 
                   UNION
                   SELECT ProductId,
                          ProductCode,
                          ProductName,
                          ProductType,
						  ProductPrice,
                          ARC_Price,
                          ListOrder,
                           ISNULL(
                               ExpDate,
                              CONVERT(VARCHAR(10), '01/01/1900 00:00:00.000', 101)
                          ) ExpDate
                   FROM   @temp   
               ) t   
		ORDER BY t.ProductCode
        
        
    END
    RETURN 0
END TRY
BEGIN CATCH
    EXEC USP_SaveSPErrorDetails
    RETURN -1
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_LoadInstallerPriceBands]    Script Date: 12/14/2015 17:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_LoadInstallerPriceBands]

@InstallerCompanyId UNIQUEIDENTIFIER=null,
@CurrencyId int = 0
As
BEGIN TRY

select p.ProductId, p.ProductCode, p.ProductName, 
CurrencySymbol=
(select c.CurrencySymbol from PriceBand pb inner join CompanyPriceMap cpm on pb.ID = cpm.PriceBandId
inner join Currency c on pb.CurrencyID = c.CurrencyID
where pb.ProductId = p.ProductId and cpm.CompanyID = i.InstallerCompanyID and pb.CurrencyID = @CurrencyId),
Price=
(select pb.Price from PriceBand pb inner join CompanyPriceMap cpm on pb.ID = cpm.PriceBandId
where pb.ProductId = p.ProductId and cpm.CompanyID = i.InstallerCompanyID and pb.CurrencyID = @CurrencyId),
AnnualPrice=
(select AnnualPrice from PriceBand pb inner join CompanyPriceMap cpm on pb.ID = cpm.PriceBandId
where pb.ProductId = p.ProductId and cpm.CompanyID = i.InstallerCompanyID and pb.CurrencyID = @CurrencyId),
p.ListOrder
 from Installer i
cross join Products p 
where i.InstallerCompanyID = @InstallerCompanyId 
and ListedonCSLConnect = 1

END TRY  

   
BEGIN CATCH 
 exec USP_SaveSPErrorDetails  
RETURN -1
End CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_IsOrderReplenishment]    Script Date: 12/14/2015 17:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alex Papayianni
-- Create date: 07/08/2014
-- Description:	Returns whether an order contains any replenishment products
-- =============================================
CREATE PROCEDURE [dbo].[USP_IsOrderReplenishment]
@OrderId int

AS
BEGIN

DECLARE @Result as bit
SET @Result = 0 

SELECT @Result = 1 WHERE EXISTS(SELECT [IsReplenishment]
  FROM [dbo].[OrderItems]
  where orderid = @OrderId and IsReplenishment = '1')
  
SELECT @Result

END
GO
/****** Object:  StoredProcedure [dbo].[USP_IsLogisticsDescription]    Script Date: 12/14/2015 17:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Priya>
-- Create date: <03/12/2015,,>
-- Description:	<To enable/disable logistics description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_IsLogisticsDescription]
@OrderID int

AS
BEGIN

DECLARE @Result as bit
DECLARE @InstallerUnqCode as nvarchar(50)
DECLARE @InstallerName as nvarchar(50)
SET @Result = 0 

SET @InstallerName = (select CompanyName from [dbo].installer where UniqueCode = (Select InstallerUnqCode from [dbo].orders where orderid = @OrderID))

IF CHARINDEX('chubb', @InstallerName) > 0
BEGIN
SET @Result = 1
END

return @Result 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_IsGPRSChipNoExistsInOrder]    Script Date: 12/14/2015 17:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_IsGPRSChipNoExistsInOrder]
(
@GPRSNo nvarchar(10),
@OrderItemDetailId int,
@OrderId int
)
AS
BEGIN TRY 
BEGIN
	Select oid.GPRSNo
		From OrderItemDetails oid
		Inner Join
		OrderItems oi on oi.OrderItemId = oid.OrderItemId
		Inner Join
		Orders o on o.OrderId = oi.OrderId
		Where 
			GPRSNo = @GPRSNo
			And oi.OrderId = @OrderId
			And oid.OrderItemDetailId != @OrderItemDetailId
End
END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_IsGPRSChipNoExists1]    Script Date: 12/14/2015 17:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_IsGPRSChipNoExists1]
(
@GPRSNo nvarchar(10), @OrderItemDetailId int
)
AS

BEGIN TRY 
	BEGIN

	DECLARE @ORDERID INT, @ARC_CODE VARCHAR(10)

	SET @ORDERID = 0 ;

	-- GET ARC AND ORDER DETAILS TO VALIDATE AGAINST PREVIOUS ORDERS AND BOS FOR THE SPECIFIC ARC --
		SET @ORDERID = (SELECT TOP 1 OrderId From OrderItems OI inner join OrderItemDetails OID 
						on OI.OrderItemId = OID.OrderItemId WHERE OID.OrderItemDetailId = @OrderItemDetailId)

		IF(@ORDERID <> 0 )
			BEGIN
				SET @ARC_CODE = (SELECT ARC_CODE FROM Orders WHERE OrderId = @ORDERID )
				
				--Select oid.GPRSNo From OrderItemDetails oid	Where GPRSNo = @GPRSNo And oid.OrderItemDetailId != @OrderItemDetailId
				
				-- ALL ORDERS FOR SAME ARC EXCEPT CURRENT ITEM--
				SELECT GPRSNo From OrderItemDetails OID inner join OrderItems OS on OID.OrderItemId = OS.OrderItemId 
				inner join Orders O on O.OrderId = OS.OrderId Where oid.OrderItemDetailId != @OrderItemDetailId AND O.ARC_Code = @ARC_CODE 
				and GPRSNo = @GPRSNo 
				
				UNION ALL
				
				-- ON BOS FOR SAME ARC --
				SELECT Dev_Account_Code AS GPRSNo From BOS_Device BD WHERE Dev_Arc_Primary = @ARC_CODE AND Dev_Active = 1 AND Dev_Delete_Flag = 0
				and Dev_Account_Code = @GPRSNo 
				
			END
		
	End
END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH



-- exec [USP_IsGPRSChipNoExists1] '123456',2224
GO
/****** Object:  StoredProcedure [dbo].[USP_IsGPRSChipNoExists]    Script Date: 12/14/2015 17:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [USP_IsGPRSChipNoExists1] '123456',2224
CREATE Procedure [dbo].[USP_IsGPRSChipNoExists]
( @GPRSNo nvarchar(10), @OrderItemDetailId int )
AS

BEGIN TRY 
	BEGIN

	DECLARE @ORDERID INT, @ARC_CODE VARCHAR(10)

	SET @ORDERID = 0 ;

	-- GET ARC AND ORDER DETAILS TO VALIDATE AGAINST PREVIOUS ORDERS AND BOS FOR THE SPECIFIC ARC --
		SET @ORDERID = (SELECT TOP 1 OrderId From OrderItems OI inner join OrderItemDetails OID 
						on OI.OrderItemId = OID.OrderItemId WHERE OID.OrderItemDetailId = @OrderItemDetailId)

		IF(@ORDERID <> 0 )
			BEGIN
				SET @ARC_CODE = (SELECT ARC_CODE FROM Orders WHERE OrderId = @ORDERID )
				
				--Select oid.GPRSNo From OrderItemDetails oid	Where GPRSNo = @GPRSNo And oid.OrderItemDetailId != @OrderItemDetailId
				
				-- ALL ORDERS FOR SAME ARC EXCEPT CURRENT ITEM--
				SELECT GPRSNo From OrderItemDetails OID inner join OrderItems OS on OID.OrderItemId = OS.OrderItemId 
				inner join Orders O on O.OrderId = OS.OrderId Where oid.OrderItemDetailId != @OrderItemDetailId AND O.ARC_Code = @ARC_CODE 
				and GPRSNo = @GPRSNo  and OS.IsReplenishment = 0 and OS.OrderItemStatusId != 13
				
				UNION ALL
				
				-- ON BOS FOR SAME ARC --
				SELECT Dev_Account_Code AS GPRSNo From BOS_Device BD WHERE Dev_Arc_Primary = @ARC_CODE AND Dev_Active = 1 AND Dev_Delete_Flag = 0
				and Dev_Account_Code = @GPRSNo 
				
			END
		
	End
END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertOrderItemDetailsForM2M]    Script Date: 12/14/2015 17:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =====================================================================================
-- Modified by:Atiq 
-- Modified Date:08/05/2015
-- Changed the insert logic for table OrderItemDetails
-- =======================================================================================
CREATE PROCEDURE [dbo].[USP_InsertOrderItemDetailsForM2M]
	-- Add the parameters for the stored procedure here
	@OrderId int,
	@OrderItemId int,
	@Iccid NVARCHAR(300),
	@CreatedBy nvarchar(256),
	@ProductQty int , 	
	@isReplacement BIT = 0
AS
BEGIN
   /*
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
    with q AS (
    SELECT  OrderItemID as ID
            , Number = 1
            , @ProductQty As Quantity
    FROM    Orderitems WHERE ORDERID =@OrderId and OrderItemId = @OrderItemId
    UNION ALL 
    SELECT  ID
            , Number = Number + 1
            , Quantity
    FROM    q
    WHERE   Quantity > Number
)
INSERT INTO 
						   OrderItemDetails
						  (
							OrderItemId,
							GPRSNo,
							PSTNNo,
							ModifiedOn,
							ModifiedBy,
							IsReplacement
                    
						  )
SELECT  ID,'0000',@Iccid,GETDATE(),@CreatedBy,@isReplacement

FROM    q       
ORDER BY
        ID
  */
DECLARE @ID INT 
Declare @Pos INT
SET @Pos=0
WHILE @Pos<@ProductQty
  BEGIN
      SET @Pos=@Pos+1    
      INSERT INTO OrderItemDetails
				(
				OrderItemId,
				GPRSNo,
				PSTNNo,
				ModifiedOn,
				ModifiedBy,
				IsReplacement
				)
                Values
                (
				@OrderItemId,
				'0000',
				@Iccid,
				GETDATE(),
				@CreatedBy,
				@isReplacement
				)
     END 
			
END
GO
/****** Object:  StoredProcedure [dbo].[USP_RemoveProductFromBasketForM2M]    Script Date: 12/14/2015 17:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RemoveProductFromBasketForM2M]
(
	@OrderItemId int,
	@ModifiedBy NVarchar(256)
)
AS
BEGIN TRY 
BEGIN	
	Declare @OrderId int	
	Declare @OrderItemQty int
	Declare @ItemPrice Decimal(8,2)
	Declare @DependentItemPrice Decimal(8,2)
	
	Select @ItemPrice = oi.Price, @OrderItemQty = oi.ProductQty, @OrderItemId = oi.OrderItemId, @OrderId = oi.OrderId
		From OrderItems oi		
		Where oi.OrderItemId = @OrderItemId
	
	Select @DependentItemPrice = IsNull(SUM(IsNull(ProductQty,0) * IsNull(Price,0)),0) From OrderDependentItems Where OrderItemId = @OrderItemId
		
	Delete From OrderItemDetails Where OrderItemId = @OrderItemId
	Delete From OrderDependentItems Where OrderItemId = @OrderItemId
	Delete From OrderItems Where OrderItemId = @OrderItemId
	
	Update Orders set Amount = Amount - IsNull(@ItemPrice, 0) * IsNull(@OrderItemQty, 0) - @DependentItemPrice, ModifiedOn = GETDATE(), ModifiedBy = @ModifiedBy Where OrderId = @OrderId
	
END
END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_RemoveProductFromBasketAPI]    Script Date: 12/14/2015 17:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_RemoveProductFromBasketAPI]  
(  
 @OrderItemId int,  
 @ModifiedBy NVarchar(256)  
)  
AS  
BEGIN TRY   
BEGIN   
 Declare @OrderId int   
 Declare @OrderItemQty int  
 Declare @ItemPrice Decimal(6,2)  
 Declare @DependentItemPrice Decimal(6,2)  
 --DECLARE @TotalAmount DECIMAL(6,2) 
 
  
 Select @ItemPrice = oi.Price, @OrderItemQty = oi.ProductQty, @OrderItemId = oi.OrderItemId, @OrderId = oi.OrderId  
  From OrderItems oi    
  Where oi.OrderItemId = @OrderItemId  
   
 Select @DependentItemPrice = IsNull(SUM(IsNull(ProductQty,0) * IsNull(Price,0)),0) From OrderDependentItems Where OrderItemId = @OrderItemId  
    
 Delete From OrderItemDetails Where OrderItemId = @OrderItemId  
 Delete From OrderItems Where OrderItemId = @OrderItemId  
 Delete From OrderDependentItems Where OrderItemId = @OrderItemId  
    
--SELECT @TotalAmount=ISNULL(o.OrderTotalAmount,0.00)  FROM Orders o WHERE o.OrderId=@OrderId
  
 Update Orders set Amount = Amount - IsNull(@ItemPrice, 0) * IsNull(@OrderItemQty, 0) - @DependentItemPrice, 
 ModifiedOn = GETDATE(), 
 ModifiedBy = @ModifiedBy,
 OrderTotalAmount=OrderTotalAmount-IsNull(@ItemPrice, 0) * IsNull(@OrderItemQty, 0) - @DependentItemPrice
  Where OrderId = @OrderId  


-- update total amount
--UPDATE Orders
--SET
--    OrderTotalAmount = @TotalAmount
--WHERE OrderId=@OrderId
 
   
END  
END TRY   
BEGIN CATCH  
EXEC USP_SaveSPErrorDetails  
RETURN -1    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_RemoveProductFromBasket]    Script Date: 12/14/2015 17:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RemoveProductFromBasket]
(
	@OrderItemId int,
	@ModifiedBy NVarchar(256)
)
AS
BEGIN TRY 
BEGIN	
	Declare @OrderId int	
	Declare @OrderItemQty int
	Declare @ItemPrice Decimal(6,2)
	Declare @DependentItemPrice Decimal(6,2)
	
	Select @ItemPrice = oi.Price, @OrderItemQty = oi.ProductQty, @OrderItemId = oi.OrderItemId, @OrderId = oi.OrderId
		From OrderItems oi		
		Where oi.OrderItemId = @OrderItemId
	
	Select @DependentItemPrice = IsNull(SUM(IsNull(ProductQty,0) * IsNull(Price,0)),0) From OrderDependentItems Where OrderItemId = @OrderItemId
		
	Delete From OrderItemDetails Where OrderItemId = @OrderItemId
	Delete From OrderItems Where OrderItemId = @OrderItemId
	Delete From OrderDependentItems Where OrderItemId = @OrderItemId
	Update Orders set Amount = Amount - IsNull(@ItemPrice, 0) * IsNull(@OrderItemQty, 0) - @DependentItemPrice, ModifiedOn = GETDATE(), ModifiedBy = @ModifiedBy Where OrderId = @OrderId
	Update Orders set InstallerId = null, InstallerCode = null, InstallerUnqCode = null,Amount=0.00,OrderTotalAmount=0.00 where OrderId = @OrderId and not exists(select OrderItemId from OrderItems where OrderId = @OrderId)
END
END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_RemoveChipNumberFromBasket]    Script Date: 12/14/2015 17:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_RemoveChipNumberFromBasket]
(
	@OrderItemDetailId int,
	@ModifiedBy NVarchar(256)
)
AS
BEGIN TRY 
BEGIN	
	Declare @OrderId int	
	Declare @OrderItemId int	
	Declare @OrderItemQty int
	Declare @ItemPrice Decimal(6,2)
	Declare @DependentItemPrice Decimal(6,2)
	
	Select @ItemPrice = oi.Price, @OrderItemQty = oi.ProductQty, @OrderItemId = oi.OrderItemId, @OrderId = oi.OrderId
		From OrderItems oi
		Inner Join
		OrderItemDetails oid on oid.OrderItemId = oi.OrderItemId
		Where oid.OrderItemDetailId = @OrderItemDetailId
		
	Select @DependentItemPrice = IsNull(SUM(IsNull(Price,0)),0) From OrderDependentItems Where OrderItemId = @OrderItemId
		
	IF @OrderItemQty = 1
		BEGIN
			Delete From OrderItemDetails Where OrderItemDetailId = @OrderItemDetailId			
			Delete From OrderItems Where OrderItemId = @OrderItemId
			Delete From OrderDependentItems Where OrderItemId = @OrderItemId
			Update Orders set Amount = Amount - @ItemPrice - @DependentItemPrice, ModifiedOn = GETDATE(), ModifiedBy = @ModifiedBy Where OrderId = @OrderId
		END
	Else If @OrderItemQty > 1
		BEGIN
			Delete From OrderItemDetails Where OrderItemDetailId = @OrderItemDetailId
			Update OrderItems set ProductQty = ProductQty - 1, ModifiedOn = GETDATE(), ModifiedBy = @ModifiedBy Where OrderItemId = @OrderItemId
			Update OrderDependentItems set ProductQty = ProductQty - 1 Where OrderItemId = @OrderItemId
			Update Orders set Amount = Amount - @ItemPrice - @DependentItemPrice, ModifiedOn = GETDATE(), ModifiedBy = @ModifiedBy Where OrderId = @OrderId		
		END		
END
END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[usp_ProcessDetailAdvancedSearch]    Script Date: 12/14/2015 17:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ProcessDetailAdvancedSearch]
	@from DATETIME = NULL,
	@to DATETIME = NULL,
	@arcRef NVARCHAR(250) = NULL,
	@orderStatusId INT = NULL,
	@bosInsertedFail BIT = NULL,
	@pendingFileFail BIT = NULL,
	@billingFail BIT = NULL,
	@sentEmailFail BIT = NULL
AS
BEGIN TRY
    BEGIN
        SELECT DISTINCT top 20 (o.OrderId)OrderId,
               OrderNo = o.OrderNo,
               OrderRefNo = o.OrderRefNo,
               OrderDate = o.OrderDate,
               OrderTotalAmount = o.OrderTotalAmount,
               ARC_Code = o.ARC_Code,
               InstallerId = o.InstallerId,
               InstallerCode = o.InstallerCode,
               InstallerUnqCode = o.InstallerUnqCode,
               InstallerContactName = o.InstallerContactName,
               CompanyName = i.CompanyName,
               ARC = a.CompanyName,
			   MailSent = o.EmailSent,
			   OrderStatus,
			   ProcessedOn = o.ProcessedOn
        FROM   Orders o
               INNER JOIN ARC a
                    ON  a.ARC_Code = o.ARC_Code
               INNER JOIN Installer i
                    ON  o.InstallerId = i.InstallerCompanyID
               INNER JOIN OrderItems oi
                    ON  oi.OrderId = o.OrderId
               INNER JOIN OrderItemDetails oid
                    ON  oid.OrderItemId = oi.OrderItemId
			   INNER JOIN OrderStatusMaster osm
					ON o.OrderStatusId = osm.OrderStatusId
				INNER JOIN PRODUCTS 
					ON oi.ProductID = Products.ProductID
        WHERE  [o].[OrderStatusId] not in (1,2,7,20)
               AND (
                       @from IS NULL
                       OR CONVERT(VARCHAR(20), o.OrderDate, 112) >= CONVERT(VARCHAR(20), @from, 112)
                   )
               AND (
                       @to IS NULL
                       OR CONVERT(VARCHAR(20), o.OrderDate, 112) <= CONVERT(VARCHAR(20), @to, 112)
                   )
               AND (nullif(@arcRef,'') IS NULL OR o.OrderRefNo LIKE '%' + @arcRef + '%')
               AND (o.OrderStatusId = @orderStatusId or isnull(@orderStatusId,0) =0 )
			   AND (
					( isnull(oid.IsBosInserted,0) = 0 AND ProductType ='Product' AND categoryID not in (5))
					OR
					isnull(@bosInsertedFail,0) = 0
					)
			   AND (
				(isnull(oid.IsPendingFileCreated,0) = 0  AND oid.PendingFileErrorMessage is not NULL)
				or isnull(@pendingFileFail,0) = 0
			   )
			   AND (isnull(oid.isBillingInserted,0) = 0 or isnull(@billingFail,0) = 0)
			   AND (isnull(o.EmailSent,0) = 0 or isnull(@sentEmailFail,0) = 0)
              
			   order by o.ProcessedOn desc
			   --order by o.OrderDate desc
    END
 END TRY

BEGIN CATCH
    EXEC USP_SaveSPErrorDetails
    RETURN -1
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[usp_PreviousOrdersAdvancedSearch]    Script Date: 12/14/2015 17:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[usp_PreviousOrdersAdvancedSearch]
	@from DATETIME = NULL,
	@to DATETIME = NULL,
	@arcRef NVARCHAR(250) = NULL,
	@orderStatusId INT = NULL,
	@successfully BIT = NULL,
	@error BIT = NULL,
	@bosInserted BIT = NULL,
	@pendingFile BIT = NULL
AS
BEGIN TRY
    BEGIN
        SELECT  DISTINCT TOP 50 [o].[OrderId],
               [o].[OrderDate],
               [o].[OrderNo],
               [o].[OrderRefNo],
               [o].[DeliveryCost],
               [o].[Amount],
               [o].[OrderTotalAmount],
               [o].[VATRate],
               [i].[CompanyName],
               [o].[OrderStatusId],
               [t2].[CompanyName] AS [arcCompanyName],
               osm.OrderStatus
        FROM   [dbo].[Orders] AS [o]
               INNER JOIN [dbo].[Installer] AS [i]
                    ON  [o].[InstallerId] = ([i].[InstallerCompanyID])
               INNER JOIN [dbo].[ARC] AS [t2]
                    ON  [o].[ARC_code] = [t2].[ARC_code]
               INNER JOIN [dbo].[OrderItems] AS [oi]
                    ON  [o].[OrderId] = [oi].[OrderId]
               INNER JOIN [dbo].[OrderItemDetails] AS [oid]
                    ON  [oi].[OrderItemId] = [oid].[OrderItemId]
               INNER JOIN [dbo].[OrderStatusMaster] AS [osm]
                    ON  [o].[OrderStatusId] = [osm].[OrderStatusId]
        WHERE  ([o].[OrderStatusId] <> 1 )
               AND (
                       @from IS NULL
                       OR CONVERT(VARCHAR(20), o.OrderDate, 112) >= CONVERT(VARCHAR(20), @from, 112)
                   )
               AND (
                       @to IS NULL
                       OR CONVERT(VARCHAR(20), o.OrderDate, 112) <= CONVERT(VARCHAR(20), @to, 112)
                   )
               AND (@arcRef IS NULL OR o.OrderRefNo LIKE '%' + @arcRef + '%')
               AND (@orderStatusId = 0 OR o.OrderStatusId = @orderStatusId)
               AND (
                       @successfully = 0
                       OR (
                              oid.Isprocessed = 1
                              AND ( oid.IsPendingFileCreated = 1 OR oid.IsBosInserted = 1 )
                          )
                   )
               AND (
                       (@error = 0 )
                       OR (
                              @error = 1 AND oid.Isprocessed = 1
							  AND 
							  (
									(
									@bosInserted = 1 AND @pendingFile =1 
									AND  ( oid.IsPendingFileCreated = 0 AND PendingFileErrorMessage is not null AND oid.IsBosInserted = 0 )
									)
									OR
									(
									@bosInserted = 0 AND @pendingFile =0
									AND  ( (oid.IsPendingFileCreated = 0 AND PendingFileErrorMessage is not null) OR oid.IsBosInserted = 0 )
									)
									OR
									( 
										@bosInserted = 1 AND @pendingFile =0
										AND  oid.IsBosInserted = 0 
									)
								   OR
									( 
										@bosInserted = 0 AND @pendingFile =1
										AND  oid.IsPendingFileCreated = 0 AND PendingFileErrorMessage is not null
									)
							  )
                          )
                   )
            
			ORder By [o].[OrderDate] DESC 
    END
END TRY

BEGIN CATCH
    EXEC USP_SaveSPErrorDetails
    RETURN -1
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[CreateProduct]    Script Date: 12/14/2015 17:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateProduct]  
@prodid INT,  
@prodcode VARCHAR(255),  
@prodname VARCHAR(256),  
@proddesc TEXT,  
@price DECIMAL(6, 2),  
@annualprice DECIMAL(6, 2),  
@defaultimg VARCHAR(512),  
@largeimg VARCHAR(512),  
@user VARCHAR(256),  
@IsDependent BIT,  
@listorder INT,  
@prodtype VARCHAR(50),  
@IsCSD BIT,
@Msg NVARCHAR(256),
@prodgrade nvarchar(50),
@IsSiteName BIT=0,
@IsReplenishment BIT=0,
@CSLDescription TEXT=NULL,
@isDeleted BIT=0,
@ListedonCSLConnect BIT=0,
@CSLConnectVoice BIT=0,
@CSLConnectSMS BIT=0,
@Allowance FLOAT=0,
@IsHardwareType BIT=0,
@IsVoiceSMSVisible BIT=0,
@IsOEMProduct BIT=0
AS  
BEGIN TRY
    BEGIN
        IF EXISTS (
               SELECT ProductId
               FROM   Products
               WHERE  ProductCode = @prodcode
                      AND ProductId != @prodid
           )
        BEGIN
            SELECT 0 AS [ProductId];
        END
        ELSE
        BEGIN
            IF (@prodid != 0)
            BEGIN
                UPDATE Products
                SET    ProductCode = @prodcode,
                       ProductName = @prodname,
                       ProductDesc = @proddesc,
                       Price = @price,
                       AnnualPrice = @annualprice,
                       DefaultImage = @defaultimg,
                       LargeImage = @largeimg,
                       ProductType = @prodtype,
                       IsDependentProduct = @IsDependent,
                       ModifiedBy = @user,
                       ModifiedOn = GETDATE(),
                       SeoUrl = @prodname,
                       ListOrder = @listorder,
                       IsCSD = @IsCSD,
                       [Message] = @Msg,
                       CSL_Grade= @prodgrade,
                       IsSiteName=@IsSiteName,
                       IsReplenishment=@IsReplenishment,
                       CSLDescription =@CSLDescription,
                       IsDeleted = @isDeleted,
					   ListedonCSLConnect = @ListedonCSLConnect,
					   CSLConnectVoice = @CSLConnectVoice,
					   CSLConnectSMS = @CSLConnectSMS,
					   Allowance = @Allowance,
					   IsHardwareType = @IsHardwareType,
					   IsVoiceSMSVisible = @IsVoiceSMSVisible,
					   IsOEMProduct = @IsOEMProduct
                WHERE  ProductId = @prodid
                
                ;  
                
                DELETE 
                FROM   Product_ARC_Map
                WHERE  ProductId = @prodid
                
                ;  
                DELETE 
                FROM   Category_Product_Map
                WHERE  ProductId = @prodid
                
                ;  
                DELETE 
                FROM   Product_Dependent_Map
                WHERE  ProductId = @prodid
                
                ;  
                DELETE 
                FROM   RelatedProducts
                WHERE  ProductId = @prodid
                
                ;  
                
                DELETE 
                FROM   Product_Option_Map
                WHERE  ProductId = @prodid
                
                ;

                DELETE 
                FROM   Product_Installer_Map
                WHERE  ProductId = @prodid
                
                ;
                
                SELECT @prodid AS [ProductId];
            END
            ELSE
            BEGIN
                INSERT INTO Products
                  (
                    ProductCode,
                    ProductDesc,
                    ProductName,
                    CreatedBy,
                    CreatedOn,
                    DefaultImage,
                    LargeImage,
                    ModifiedBy,
                    ListOrder,
                    SeoUrl,
                    IsDependentProduct,
                    Price,
					AnnualPrice,
                    ProductType,
                    ModifiedOn,
                    IsCSD,
                    [Message],
                    CSL_Grade,
                    IsSiteName,
                    IsReplenishment,
                    CSLDescription,
                    IsDeleted,
					ListedonCSLConnect,
					CSLConnectVoice,
					CSLConnectSMS,
					Allowance,
					IsHardwareType,
					IsVoiceSMSVisible,
					IsOEMProduct
                  )
                VALUES
                  (
                    @prodcode,
                    @proddesc,
                    @prodname,
                    @user,
                    GETDATE(),
                    @defaultimg,
                    @largeimg,
                    @user,
                    @listorder,
                    @prodname,
                    @IsDependent,
                    @price,
					@annualprice,
                    @prodtype,
					GETDATE(),
                    @IsCSD,
                    @Msg,
                    @prodgrade,
                    @IsSiteName,
                    @IsReplenishment,
                    @CSLDescription,
                    @isDeleted,
					@ListedonCSLConnect,
					@CSLConnectVoice,
					@CSLConnectSMS,
					@Allowance,
					@IsHardwareType,
					@IsVoiceSMSVisible,
					@IsOEMProduct
                  );  
                
                SELECT CAST(SCOPE_IDENTITY() AS INT) AS [ProductId];
            END
        END
    END
END TRY   
BEGIN CATCH
    EXEC USP_SaveSPErrorDetails 
    RETURN -1
END CATCH
GO
/****** Object:  Table [dbo].[ARC_AccessCode]    Script Date: 12/14/2015 17:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARC_AccessCode](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ARCID] [int] NOT NULL,
	[InstallerUniqueCode] [int] NULL,
	[Accesscode] [nvarchar](10) NULL,
 CONSTRAINT [PK_ARC_AccessCode] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[CreateARC]    Script Date: 12/14/2015 17:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateARC]
	@arcid INT,
	@arccode NVARCHAR(255),
	@arcname NVARCHAR(256),
	@email NVARCHAR(256),
	@fax NVARCHAR(256),
	@primcontact NVARCHAR(256),
	@telphn NVARCHAR(256),
	@addone NVARCHAR(256),
	@addtwo NVARCHAR(256),
	@town NVARCHAR(256),
	@postcode NVARCHAR(256),
	@county NVARCHAR(256),
	@country NVARCHAR(256),
	@countrycode NVARCHAR(10),
	@billaccno NVARCHAR(256),
	@annualbilling BIT,
	@allowreturn BIT,
	@postingoption BIT,
	@isbulkuploadallowed BIT,
	@isapiaccess BIT,
	@arcSalesledgeno nvarchar(50),
	@productoptionid INT,
	@arcemailCC NVARCHAR(256),
	@arcTypesId INT,
	@description NVARCHAR(256),
	@LogisticDescription NVARCHAR(500),
	@isDeleted BIT=0,
	@PolltoEIRE BIT=0,
	@ExcludeTerms BIT=0,
	@IsAllowedCSD BIT=0,
	@EnablePostCodeSearch BIT=0,
	@ReplenishmentLimit INT
AS
--BEGIN TRY

    BEGIN
	SET NOCOUNT ON
        IF EXISTS (
               SELECT ARCId
               FROM   ARC
               WHERE  (ARC_Code = @arccode
                      AND ARCId != @arcid)
           )
        BEGIN
            SELECT 0 AS [ARCId];
        END
        ELSE
        BEGIN
            IF (@arcid != 0)
            BEGIN
                UPDATE ARC
                SET    ARC_Code = @arccode,
                       ARC_Email = @email,
                       BillingAccountNo = @billaccno,
                       CompanyName = @arcname,
                       Country = @country,
					   CountryCode = @countrycode,
                       County = @county,
                       Fax = @fax,
                       IsBulkUploadAllowed = @isbulkuploadallowed,
                       PrimaryContact = @primcontact,
                       Telephone = @telphn,
                       Town = @town,
                       AnnualBilling = @annualbilling,
                       AllowReturns = @allowreturn,
                       PostingOption = @postingoption,
                       PostCode = @postcode,
                       AddressOne = @addone,
                       AddressTwo = @addtwo,
                       IsAPIAccess = @isapiaccess,
                       SalesLedgerNo=@arcSalesledgeno,
                       ProductOptionId= @productoptionid,
                       ARC_CCEmail=@arcemailCC,
                       ArcTypeId=@arcTypesId,
                       [DESCRIPTION]=@description,
                       LogisticsDescription = @LogisticDescription,
                       IsDeleted = @isDeleted,
                       PolltoEIRE =@PolltoEIRE,
                       ExcludeTerms = @ExcludeTerms,
                       IsAllowedCSD = @IsAllowedCSD,
                       EnablePostCodeSearch = @EnablePostCodeSearch,
					   ReplenishmentLimit = @ReplenishmentLimit,
					   ModifiedOn = GetDate()
                WHERE  ARCId = @arcid
                
                ;
                
                DELETE 
                FROM   ARC_Category_Map
                WHERE  ARCId = @arcid
                
                ;
                DELETE 
                FROM   Product_ARC_Map
                WHERE  ARCId = @arcid
                
                ;
                
                SELECT @arcid AS [ARCId];
            END
            ELSE
            BEGIN
                INSERT INTO ARC
                  (
                    ARC_Code,
                    ARC_Email,
                    BillingAccountNo,
                    CompanyName,
                    Country,
                    CountryCode,
                    County,
                    Fax,
                    IsBulkUploadAllowed,
                    PostCode,
                    PostingOption,
                    PrimaryContact,
                    Telephone,
                    Town,
                    AddressOne,
                    AddressTwo,
                    AllowReturns,
                    AnnualBilling,
                    IsAPIAccess,
                    SalesLedgerNo,
                    ProductOptionId,
                    ARC_CCEmail,
                    ArcTypeId,
                    [Description],
                    LogisticsDescription,
                    IsDeleted,
                    PolltoEIRE,
                    ExcludeTerms,
                    IsAllowedCSD,
					EnablePostCodeSearch,
					ReplenishmentLimit
                  )
                VALUES
                  (
                    @arccode,
                    @email,
                    @billaccno,
                    @arcname,
                    @country,
                    @countrycode,
                    @county,
                    @fax,
                    @isbulkuploadallowed,
                    @postcode,
					@postingoption,
                    @primcontact,
                    @telphn,
                    @town,
					@addone,
                    @addtwo,
                    @allowreturn,
					@annualbilling,
                    @isapiaccess,
                    @arcSalesledgeno,
                    @productoptionid,
                    @arcemailCC,
                    @arcTypesId,
                    @description,
                    @LogisticDescription,
                    @isDeleted,
                    @PolltoEIRE,
                    @ExcludeTerms,
                    @IsAllowedCSD,
					@EnablePostCodeSearch,
					@ReplenishmentLimit
                  );
                
                SELECT CAST(SCOPE_IDENTITY() AS INT) AS [ARCId];
            END
        END
    END
--END TRY

--BEGIN CATCH
--    EXEC USP_SaveSPErrorDetails
--    RETURN -1
--END CATCH








--/****** Object:  Trigger [dbo].[ARC_Insert]    Script Date: 23/09/2014 14:39:01 ******/
--SET ANSI_NULLS ON







/****** Object:  Table [dbo].[Product_ARC_Map]    Script Date: 23/02/2015 14:35:55 ******/
--ALREADY CREATED ON LIVE
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE TABLE [dbo].[Product_Installer_Map](
--	[Id] [int] IDENTITY(1,1) NOT NULL,
--	[ProductId] [int] NOT NULL,
--	[InstallerId] [uniqueidentifier] NOT NULL,
-- CONSTRAINT [PK_Product_Installer_Map] PRIMARY KEY CLUSTERED 
--(
--	[Id] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY]

--GO









--insert into product_installer_map (ProductId,InstallerId)
-- select ProductId,[InstallerId] from
--(
--   ( select p.ProductId from product_arc_map pam
--   join products p on pam.ProductId = p.ProductId
--    where listedoncslconnect = 1 and arcid = 10) as A
--	cross join 
--(SELECT distinct [InstallerId]
--  FROM [Orders]
--  where ordertype = 2) as b 
-- )
-- order by 1,2







-- SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		Alex Papayianni
---- Create date: 24/02/2015
---- Description:	To activate the products for Installers on M2M Connect
---- =============================================
--CREATE PROCEDURE USP_ActivateInstallerProducts
-- @arcCode nvarchar(100),
-- @installerId uniqueidentifier
--AS
--BEGIN
--if not exists (select ProductId from Product_Installer_Map where InstallerId = @installerId)
--begin
--UPDATE Installer
--set IsVoiceSMSVisible = (select IsVoiceSMSVisible from ARC where ARC_Code = @arcCode)
--where InstallerCompanyID = @installerId and IsVoiceSMSVisible != (select IsVoiceSMSVisible from ARC where ARC_Code = @arcCode)

--insert into product_installer_map (ProductId,InstallerId)
-- select ProductId,[InstallerId] from
--(
--   ( select p.ProductId from product_arc_map pam
--   join products p on pam.ProductId = p.ProductId
--   join arc a on pam.arcid = a.ARCId
--    where listedoncslconnect = 1 and a.ARC_Code = @arcCode ) as A
--	cross join 
--(SELECT @installerId as InstallerId) as b 
-- )
-- order by 1,2
-- end

--END
--GO








/****** Object:  StoredProcedure [dbo].[CreateProduct]    Script Date: 24/02/2015 14:18:35 ******/
SET ANSI_NULLS ON
GO
/****** Object:  UserDefinedFunction [dbo].[GetDeliveryNoteNo]    Script Date: 12/14/2015 17:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE  FUNCTION [dbo].[GetDeliveryNoteNo]
(
	@OrderID int
)
RETURNS NVARCHAR(256)
AS
BEGIN
	-- Declare the return variable here
	DECLARE  @ResultStr nvarchar(10)

	-- Add the T-SQL statements to compute the return value here
	SELECT @ResultStr =  isnull(MAX(ItemDlvNoteNo),'000000') from OrderItemDetails 
				inner join OrderItems on   OrderItems.OrderItemID =OrderItemDetails.OrderItemID
				inner join Orders on OrderItems.OrderID = Orders.OrderID
	Where  Orders.OrderID = @OrderID

	
	RETURN @ResultStr

END
GO
/****** Object:  StoredProcedure [dbo].[GetARCDeliveryAddresses]    Script Date: 12/14/2015 17:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetARCDeliveryAddresses]  
@ArcId int  ,
@postcode varchar(100) = ''  
As  
BEGIN TRY   
BEGIN  
declare @string varchar(500)

If @postcode = ''  
BEGIN 
	Select * FROM 
	(
	select distinct top 20 MAX(addr.AddressID) as AddressID,isnull(addr.PostCode,'') as PostCode,isnull(addr.ContactName,'') as ContactName,isnull(addr.AddressOne,'') as AddressOne,isnull(addr.AddressTwo,'') as AddressTwo
	,isnull(addr.Town,'') as Town,isnull(addr.County,'') as County,
	Substring(CASE isnull(addr.Postcode,'') WHEN '' THEN '' ELSE UPPER(addr.Postcode)+', ' END +
	CASE isnull(addr.ContactName,'') WHEN '' THEN '' ELSE LOWER(addr.ContactName)+', ' END + 
	CASE isnull(addr.AddressOne,'') WHEN '' THEN '' ELSE LOWER(addr.AddressOne)+', ' END +
	CASE isnull(addr.AddressTwo,'') WHEN '' THEN '' ELSE LOWER(addr.AddressTwo)+', ' END +
	CASE isnull(addr.Town,'') WHEN '' THEN '' ELSE LOWER(addr.Town)+', ' END +
	CASE isnull(addr.County,'') WHEN '' THEN '' ELSE LOWER(addr.County) END
	,1,1000)
	AS Display from Orders o
	left join [address] addr on addr.AddressID = o.DeliveryAddressId
	where o.ARCId=@ArcId and addr.AddressID is not null
	--AND addr.AddressID < 32787 --temporary fix to prevent breaking
	group by addr.PostCode,addr.ContactName,addr.AddressOne,addr.AddressTwo
	,addr.Town,addr.County 
	ORDER BY AddressID Desc 
	) as X
	ORDER BY PostCode
END 
ELSE
BEGIN
	select MAX(addr.AddressID) as AddressID,isnull(addr.PostCode,'') as PostCode,isnull(addr.ContactName,'') as ContactName,isnull(addr.AddressOne,'') as AddressOne,isnull(addr.AddressTwo,'') as AddressTwo
	,isnull(addr.Town,'') as Town,isnull(addr.County,'') as County,
	Substring(CASE isnull(addr.Postcode,'') WHEN '' THEN '' ELSE UPPER(addr.Postcode)+', ' END +
	CASE isnull(addr.ContactName,'') WHEN '' THEN '' ELSE LOWER(addr.ContactName)+', ' END + 
	CASE isnull(addr.AddressOne,'') WHEN '' THEN '' ELSE LOWER(addr.AddressOne)+', ' END +
	CASE isnull(addr.AddressTwo,'') WHEN '' THEN '' ELSE LOWER(addr.AddressTwo)+', ' END +
	CASE isnull(addr.Town,'') WHEN '' THEN '' ELSE LOWER(addr.Town)+', ' END +
	CASE isnull(addr.County,'') WHEN '' THEN '' ELSE LOWER(addr.County) END
	,1,1000)
	AS Display from Orders o
	left join [address] addr on addr.AddressID = o.DeliveryAddressId
	where o.ARCId=@ArcId and addr.AddressID is not null
	AND dbo.TRIM(Postcode) like dbo.TRIM(@postcode) + '%'
	--AND addr.AddressID < 32787 --temporary fix to prevent breaking
	group by addr.PostCode,addr.ContactName,addr.AddressOne,addr.AddressTwo
	,addr.Town,addr.County 
	ORDER BY AddressID Desc 
END 
END  
END TRY   
BEGIN CATCH   
EXEC USP_SaveSPErrorDetails  
RETURN -1   
END CATCH
GO
/****** Object:  UserDefinedFunction [dbo].[GetUniquecode]    Script Date: 12/14/2015 17:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetUniquecode] 
(
	-- Add the parameters for the function here
	@ARCId int
)
RETURNS CHAR(6)
AS
BEGIN
	declare @Newcode uniqueidentifier
	SELECT @Newcode =  new_id from getNewID
	--declare @ResultStr VARCHAR(6) = '00000'
	--declare @TEMPSTR VARCHAR(12)

	--Set @TEMPSTR  = REVERSE(@ResultStr + cast(@ARCId as VARCHAR(6)))
	--SET @ResultStr = @TEMPSTR
	--RETURN REVERSE(@ResultStr)

	/** Updated to only numbers 22 Apr 2014 SRi **/
	RETURN (SELECT A.Code from       
    (SELECT  left((cast( CAST( @Newcode AS BINARY(5)) AS BIGINT)),6)      
    AS Code)A where A.Code NOT IN (select distinct isnull(uniquecode,0) from ARC))  



END
GO
/****** Object:  StoredProcedure [dbo].[GetSimRegisterReport]    Script Date: 12/14/2015 17:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSimRegisterReport]
	@date DATETIME
AS
BEGIN
    SELECT ICCID,
           ISNULL(DataNo, '') AS DataNo,
           ISNULL(Dev_IMSINumber, '') AS IMSI,
           ISNULL(IPAddress, '') AS IPAddress,
           GPRSNo AS ChipNo,
           ProductCode,
           REPLACE(ProductName, '<br/>', ' ') AS ProductName,
           CompanyName,
           CONVERT(VARCHAR(256), Processedon, 103) OrderDate,
           ARC_Code,
           Installer,
           InstallerCode,
           UniqueCode AS InstallerUNQCode,
           ISNULL(
               (
                   SELECT TOP 1 OrderRefNo
                   FROM   Orders
                   WHERE  ARCId IN (214)
                          AND OrderNo = vw_SIMRegister.OrderNo
               ),
               ''
           ) +
           ISNULL(
               (
                   SELECT TOP 1 CAST(SUBSTRING(SpecialInstructions, 0, 256) AS NVARCHAR(256))
                   FROM   Orders
                   WHERE  ARCId IN (4)
                          AND OrderNo = vw_SIMRegister.OrderNo
               ),
               ''
           ) AS [REF],
           OrderNo
    FROM   dbo.vw_SIMRegister
    WHERE   CONVERT(VARCHAR(256), processedon, 103) = CONVERT(VARCHAR(256), @date, 103)
            AND OrderStatusid IN (19)
           AND ICCID IS NOT NULL
           AND orderitemstatusid <> 13
    ORDER BY
           processedon DESC
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetAccessCode]    Script Date: 12/14/2015 17:06:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sri
-- Create date: 17 SEpt 2013
-- Description:	Returns Access code for an ARC 
-- =============================================
CREATE FUNCTION [dbo].[GetAccessCode]
(
	@ARC_CODE NVARCHAR(10),
	@UniqueCode INT
)
RETURNS VARCHAR(6)
AS
BEGIN
declare @ResultStr VARCHAR(6) = '212121'

Declare @accesscode VARCHAR(6)

IF EXISTS(SELECT * FROM dbo.Installer WHERE HeadOfficeID IS NOT NULL AND UniqueCode = @UniqueCode)
BEGIN
	SELECT @UniqueCode = Headoffice.UniqueCode FROM Installer HEADOFFICE
	INNER JOIN Installer BRANCH ON HEADOFFICE.InstallerCompanyID = Branch.HeadOfficeID AND Branch.UniqueCode = @UniqueCode
END 

Select @accesscode=Accesscode FROM [dbo].[ARC_AccessCode] 
INNER JOIN ARC ON [ARC_AccessCode].ARCID = ARC.ARCID
WHERE ARC.ARC_CODE=@ARC_CODE AND InstallerUniqueCode = @UniqueCode 

If @accesscode is null 
BEGIN 
	Select @accesscode=Accesscode FROM [dbo].[ARC_AccessCode] INNER JOIN ARC ON [ARC_AccessCode].ARCID = ARC.ARCID WHERE ARC.ARC_CODE=@ARC_CODE AND isnull(InstallerUniqueCode,'') = '' 
END 
If @accesscode is not null 
BEGIN 
	SET @ResultStr = @accesscode
END 

return @ResultStr
END
GO
/****** Object:  StoredProcedure [dbo].[USP_M2MConnectOrders_Count]    Script Date: 12/14/2015 17:06:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_M2MConnectOrders_Count](@ReportID int = Null)    
AS    
Begin    
    
    
 Update BOS.dualcom_reports.dbo.MasterReportInfo  set DataCount =(Select count(*) as cnt  from (  
   
   
     
SELECT  --Orders.OrderID as 'OrderID',OrderStatusId,OrderItemStatusId,      
 InstallerUnqCode AS 'Account_Number' ,       
 ISNULL(substring(OrderRefNo,1,50),OrderNo) AS 'Order_Number' ,       
 OrderNo AS 'CSL_Unique_Order_Number',      
 Products.ProductCode + isnull(CSLConnectCodePrefix,'') AS 'Package_Code',       
 DeliveryType.DeliveryCode AS 'Delivery_Product_Code',      
 Orders.DeliveryCost AS 'Delivery_Charge',   --UPDATED 15 APR 2015    
 Orders.OrderDate AS 'Order_Date',      
 OrderNo + '1'  AS 'Del_Note_Number',      
 1 AS 'Charge_Qty',      
 'N/A'  AS 'Phone_Number',      
 ISNULL(nullif(Device_API.Dev_IMSINumber,''),'N/A') AS 'IMSI',      
 Isnull(CASE when ICCID like '00500%' THEN SUBSTRING (ICCID,0,12) ELSE nullif(dbo.Device_API.Data_Number,'') END,'N/A') AS 'Data_Number',      
 ISNULL(Replace(Orderitemdetails.ICCID,'E',''),'N/A') AS 'SIM_Number',      
 ISNULL(nullif(dbo.Device_API.Dev_IP_Address,''),'N/A') AS 'IP_Address',      
 ISNULL(nullif(dbo.OrderItemDetails.GPRSNo,''),'N/A') AS 'Username_Description',      
 InstallerUnqCode AS 'Installer_Code',      
 isnull(InstallerCode,'N.A') AS 'Old_Installer_Code',      
 isnull(Network_Operators.NetworkName,'N/A') AS 'Data_Provider',      
 isnull(Network_Operators.NetworkName,'N/A') AS 'Supplier_Network',      
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Original_StartDate',      
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Number_Start_Date',      
 DateAdd(Day, DateDiff(Day, 0, GetDate()), 0) AS 'Product_Start_Dates',      
 ISNULL(CONVERT(VARCHAR(50),ORders.SpecialInstructions),'') AS 'Order_Special_Inst',      
 CASE WHEN ProductType = 'Ancillary' OR OrderItems.CategoryID = 3  THEN 1   ELSE 0  END AS 'Ancillary',       
 Rep_code = isnull(Orders.salesReply,'M2M') ,      
 rep_unit = cast(ISNULL(IsReplacement,0) as bit) ,      
 foc = cast(ISNULL(IsFoc,0) as bit) ,      
 con_stk = cast(CASE WHEN Products.ProductCode in ('CS2100') THEN 1 ELSE ISNULL(OrderItems.IsReplenishment,0) END as bit) ,       
 Swap_Out = cast(0 as bit),       
 ISNULL(AuthCode,'N.A') as AuthCode,      
 ISNULL(FuturePayID,'N.A') as FuturePayID,      
 ISNULL(PaymentTransaction.Amount,0.0) as PaymentAmount,      
 isnull(BillingCycle.Description,'N.A') as BillingCycle /*,      
 OrderItemDetails.OrderItemDetailId,      
 isBillingInserted */      
  FROM ORDERS       
 INNER JOIN dbo.OrderItems ON dbo.OrderItems.OrderId = dbo.Orders.OrderId      
 INNER JOIN dbo.OrderItemDetails ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId      
 INNER JOIN dbo.Products ON dbo.Products.ProductId = dbo.OrderItems.ProductId       
 INNER JOIN dbo.DeliveryType ON dbo.DeliveryType.DeliveryTypeId = dbo.Orders.DeliveryTypeId       
 INNER JOIN ARC on ORDERS.ARC_CODE = ARC.ARC_CODE      
 LEFT OUTER JOIN dbo.Device_API ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID      
 LEFT OUTER JOIN dbo.Network_Operators ON OrderItemDetails.ICCID LIKE Network_Operators.ICCIDPrefix + '%'      
 LEFT OUTER JOIN  [PaymentTransaction] on Orders.OrderID = [PaymentTransaction].OrderID       
 LEFT OUTER JOIN  [BillingCycle] on Orders.BillingCycleID = [BillingCycle].ID       
 WHERE        
 OrderStatusId IN (10)       
 AND OrderItemStatusId NOT IN (13)       
 --AND  dbo.OrderItems.IsCSD = 0   --** Activation is now pushed on this report as well    
 --AND Orders.ProcessedOn >='24 NOV 2014'       
 AND Orders.ProcessedOn < GETDATE()      
 AND isBillingInserted = 0       
 AND Not Exists (Select [vw_OrderDataFull].OrderID FROM [vw_OrderDataFull]       
 WHERE [vw_OrderDataFull].OrderID = Orders.OrderID AND isBOSInserted = 0       
 AND vw_OrderDataFull.ProductType ='Product' AND categoryID != 5 and OrderitemstatusID != 13  )       
 --AND nullif(Orders.salesReply,'') is not null       
 AND Orders.Ordertype=2  AND [BillingCycle].ID in (1,2)  
  and Orders.OrderId in (select distinct OrderId from PaymentTransaction)    
   --Modified for adding OverideBillingCodes tables
 )A left outer join OverideBillingCodes B
 on A.Account_Number=B.originalcode)
 
 
  where ReportID = @ReportID     
     
     
 --print @cnt    
     
 End
GO
/****** Object:  StoredProcedure [dbo].[USP_M2MConnectOrders]    Script Date: 12/14/2015 17:06:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*      
CreatedBy- ShyamGaddam/Shree      
CreatedOn- 11/12/2014      
Purpose - To retrive the M2M Connect orders and update the billing and order status      
ModifiedBy: ShyamGaddam    
ModifiedOn - 13/01/2014    
Purpose: Incase SalesReply is null, replace with M2M  (Update Order status)    
ModifiedBy: Sri    
ModifiedOn - 27/02/2011    
Purpose: and criteria to include only card orders    
MODIFIED BY : RAVI, 15 APR 2015, TO SHOW DELIVERY COST AS IN ORDERS TABLE THAN WHATS IN DELIVERY TABLE TO HANDLE M2M ACTIVATION ORDERS.
Modified By SivaKumar.s ,26/05/2015, to display  column(SalesReply) in  Orders  table.
*/      
      
      
CREATE Procedure [dbo].[USP_M2MConnectOrders]      
as begin      
      
SELECT  --Orders.OrderID as 'OrderID',OrderStatusId,OrderItemStatusId,      
 InstallerUnqCode AS 'Account_Number' ,       
 ISNULL(substring(OrderRefNo,1,50),OrderNo) AS 'Order_Number' ,       
 OrderNo AS 'CSL_Unique_Order_Number',      
 Products.ProductCode + isnull(CSLConnectCodePrefix,'') AS 'Package_Code',       
 DeliveryType.DeliveryCode AS 'Delivery_Product_Code',      
 Orders.DeliveryCost AS 'Delivery_Charge',   --UPDATED 15 APR 2015    
 Orders.OrderDate AS 'Order_Date',      
 OrderNo + '1'  AS 'Del_Note_Number',      
 1 AS 'Charge_Qty',      
 'N/A'  AS 'Phone_Number',      
 ISNULL(nullif(Device_API.Dev_IMSINumber,''),'N/A') AS 'IMSI',      
 Isnull(CASE when ICCID like '00500%' THEN SUBSTRING (ICCID,0,12) ELSE nullif(dbo.Device_API.Data_Number,'') END,'N/A') AS 'Data_Number',      
 ISNULL(Replace(Orderitemdetails.ICCID,'E',''),'N/A') AS 'SIM_Number',      
 ISNULL(nullif(dbo.Device_API.Dev_IP_Address,''),'N/A') AS 'IP_Address',      
 ISNULL(nullif(dbo.OrderItemDetails.GPRSNo,''),'N/A') AS 'Username_Description',      
 InstallerUnqCode AS 'Installer_Code',      
 isnull(InstallerCode,'N.A') AS 'Old_Installer_Code',      
 isnull(Network_Operators.NetworkName,'N/A') AS 'Data_Provider',      
 isnull(Network_Operators.NetworkName,'N/A') AS 'Supplier_Network',      
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Original_StartDate',      
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Number_Start_Date',      
 DateAdd(Day, DateDiff(Day, 0, GetDate()), 0) AS 'Product_Start_Dates',      
 ISNULL(CONVERT(VARCHAR(50),ORders.SpecialInstructions),'') AS 'Order_Special_Inst',      
 CASE WHEN ProductType = 'Ancillary' OR OrderItems.CategoryID = 3  THEN 1   ELSE 0  END AS 'Ancillary',       
 Rep_code = isnull(Orders.salesReply,'M2M') ,      
 rep_unit = cast(ISNULL(IsReplacement,0) as bit) ,      
 foc = cast(ISNULL(IsFoc,0) as bit) ,      
 con_stk = cast(CASE WHEN Products.ProductCode in ('CS2100') THEN 1 ELSE ISNULL(OrderItems.IsReplenishment,0) END as bit) ,       
 Swap_Out = cast(0 as bit),       
 ISNULL(AuthCode,'N.A') as AuthCode,      
 ISNULL(FuturePayID,'N.A') as FuturePayID,      
 ISNULL(PaymentTransaction.Amount,0.0) as PaymentAmount,      
 isnull(BillingCycle.Description,'N.A') as BillingCycle,
 Orders.SalesReply as SalesRep
   /*,      
 OrderItemDetails.OrderItemDetailId,      
 isBillingInserted */      
  FROM ORDERS       
 INNER JOIN dbo.OrderItems ON dbo.OrderItems.OrderId = dbo.Orders.OrderId      
 INNER JOIN dbo.OrderItemDetails ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId      
 INNER JOIN dbo.Products ON dbo.Products.ProductId = dbo.OrderItems.ProductId       
 INNER JOIN dbo.DeliveryType ON dbo.DeliveryType.DeliveryTypeId = dbo.Orders.DeliveryTypeId       
 INNER JOIN ARC on ORDERS.ARC_CODE = ARC.ARC_CODE      
 LEFT OUTER JOIN dbo.Device_API ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID      
 LEFT OUTER JOIN dbo.Network_Operators ON OrderItemDetails.ICCID LIKE Network_Operators.ICCIDPrefix + '%'      
 LEFT OUTER JOIN  [PaymentTransaction] on Orders.OrderID = [PaymentTransaction].OrderID       
 LEFT OUTER JOIN  [BillingCycle] on Orders.BillingCycleID = [BillingCycle].ID       
 WHERE        
 OrderStatusId IN (10)       
 AND OrderItemStatusId NOT IN (13)       
 --AND  dbo.OrderItems.IsCSD = 0   --** Activation is now pushed on this report as well    
 --AND Orders.ProcessedOn >='24 NOV 2014'       
 AND Orders.ProcessedOn < GETDATE()      
 AND isBillingInserted = 0       
 AND Not Exists (Select [vw_OrderDataFull].OrderID FROM [vw_OrderDataFull]       
 WHERE [vw_OrderDataFull].OrderID = Orders.OrderID AND isBOSInserted = 0       
 AND vw_OrderDataFull.ProductType ='Product' AND categoryID != 5 and OrderitemstatusID != 13  )       
 --AND nullif(Orders.salesReply,'') is not null       
 AND Orders.Ordertype=2  AND [BillingCycle].ID in (1,2)    
     
 SELECT  Orders.OrderID as 'OrderID',OrderItems.OrderItemId  OrderItemID into #Temp    
  FROM ORDERS       
 INNER JOIN dbo.OrderItems ON dbo.OrderItems.OrderId = dbo.Orders.OrderId      
 INNER JOIN dbo.OrderItemDetails ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId      
 INNER JOIN dbo.Products ON dbo.Products.ProductId = dbo.OrderItems.ProductId       
 INNER JOIN dbo.DeliveryType ON dbo.DeliveryType.DeliveryTypeId = dbo.Orders.DeliveryTypeId       
 INNER JOIN ARC on ORDERS.ARC_CODE = ARC.ARC_CODE      
 LEFT OUTER JOIN dbo.Device_API ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID      
 LEFT OUTER JOIN dbo.Network_Operators ON OrderItemDetails.ICCID LIKE Network_Operators.ICCIDPrefix + '%'      
 LEFT OUTER JOIN  [PaymentTransaction] on Orders.OrderID = [PaymentTransaction].OrderID       
 LEFT OUTER JOIN  [BillingCycle] on Orders.BillingCycleID = [BillingCycle].ID       
 WHERE        
 OrderStatusId IN (10)       
 AND OrderItemStatusId NOT IN (13)       
 --AND  dbo.OrderItems.IsCSD = 0   --** Activation is now pushed on this report as well    
 --AND Orders.ProcessedOn >='24 NOV 2014'       
 AND Orders.ProcessedOn < GETDATE()      
 AND isBillingInserted = 0       
 AND Not Exists (Select [vw_OrderDataFull].OrderID FROM [vw_OrderDataFull]       
 WHERE [vw_OrderDataFull].OrderID = Orders.OrderID AND isBOSInserted = 0       
 AND vw_OrderDataFull.ProductType ='Product' AND categoryID != 5 and OrderitemstatusID != 13  )       
 --AND nullif(Orders.salesReply,'') is not null       
 AND Orders.Ordertype=2  AND [BillingCycle].ID in (1,2)    
     
     
 Update Orders set OrderStatusId = 19  where OrderId in     
(select OrderId from #Temp)    
     
     
 Update OrderItemDetails  set isBillingInserted  = 1  where OrderItemId in     
(select OrderItemId from #Temp)    
     
     
 drop table #Temp    
     
       
 end
GO
/****** Object:  StoredProcedure [dbo].[USP_M2MConnectCCOrders]    Script Date: 12/14/2015 17:06:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*        
Created by: Ravi  
CreatedOn On: 9th June 2015  
Perpose: To make sure the report only returns credit card orders, COPY of [USP_M2MConnectOrders]      but only CC orders  
*/        
        
        
CREATE Procedure [dbo].[USP_M2MConnectCCOrders]  
as begin        

  
  Select Case when Account_Number=B.OriginalCode Then OverideCode Else Account_Number END AS Account_Number,Order_Number,CSL_Unique_Order_Number,Package_Code,Delivery_Product_Code
Delivery_Charge,Order_Date,Del_Note_Number,Charge_Qty,Phone_Number,IMSI,
Data_Number,SIM_Number,IP_Address,Username_Description,Installer_Code,Old_Installer_Code,
Data_Provider,Supplier_Network,Original_StartDate,Number_Start_Date,Product_Start_Dates,
Order_Special_Inst,Ancillary,Rep_code,rep_unit,foc,con_stk,Swap_Out,
AuthCode,FuturePayID,PaymentAmount,BillingCycle,SalesRep,B.OriginalCode,B.OverideCode

 from (SELECT  --Orders.OrderID as 'OrderID',OrderStatusId,OrderItemStatusId,        
 InstallerUnqCode AS 'Account_Number' ,         
 ISNULL(substring(OrderRefNo,1,50),OrderNo) AS 'Order_Number' ,         
 OrderNo AS 'CSL_Unique_Order_Number',        
 Products.ProductCode + isnull(CSLConnectCodePrefix,'') AS 'Package_Code',         
 DeliveryType.DeliveryCode AS 'Delivery_Product_Code',        
 Orders.DeliveryCost AS 'Delivery_Charge',   --UPDATED 15 APR 2015      
 Orders.OrderDate AS 'Order_Date',        
 OrderNo + '1'  AS 'Del_Note_Number',        
 1 AS 'Charge_Qty',        
 'N/A'  AS 'Phone_Number',        
 ISNULL(nullif(Device_API.Dev_IMSINumber,''),'N/A') AS 'IMSI',        
 Isnull(CASE when ICCID like '00500%' THEN SUBSTRING (ICCID,0,12) ELSE nullif(dbo.Device_API.Data_Number,'') END,'N/A') AS 'Data_Number',        
 ISNULL(Replace(Orderitemdetails.ICCID,'E',''),'N/A') AS 'SIM_Number',        
 ISNULL(nullif(dbo.Device_API.Dev_IP_Address,''),'N/A') AS 'IP_Address',        
 ISNULL(nullif(dbo.OrderItemDetails.GPRSNo,''),'N/A') AS 'Username_Description',        
 InstallerUnqCode AS 'Installer_Code',        
 isnull(InstallerCode,'N.A') AS 'Old_Installer_Code',        
 isnull(Network_Operators.NetworkName,'N/A') AS 'Data_Provider',        
 isnull(Network_Operators.NetworkName,'N/A') AS 'Supplier_Network',        
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Original_StartDate',        
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Number_Start_Date',        
 DateAdd(Day, DateDiff(Day, 0, GetDate()), 0) AS 'Product_Start_Dates',        
 ISNULL(CONVERT(VARCHAR(50),ORders.SpecialInstructions),'') AS 'Order_Special_Inst',        
 CASE WHEN ProductType = 'Ancillary' OR OrderItems.CategoryID = 3  THEN 1   ELSE 0  END AS 'Ancillary',         
 Rep_code = isnull(Orders.salesReply,'M2M') ,        
 rep_unit = cast(ISNULL(IsReplacement,0) as bit) ,        
 foc = cast(ISNULL(IsFoc,0) as bit) ,        
 con_stk = cast(CASE WHEN Products.ProductCode in ('CS2100') THEN 1 ELSE ISNULL(OrderItems.IsReplenishment,0) END as bit) ,         
 Swap_Out = cast(0 as bit),         
 ISNULL(AuthCode,'N.A') as AuthCode,        
 ISNULL(FuturePayID,'N.A') as FuturePayID,        
 ISNULL(PaymentTransaction.Amount,0.0) as PaymentAmount,        
 isnull(BillingCycle.Description,'N.A') as BillingCycle,  
 Orders.SalesReply as SalesRep
   /*,        
 OrderItemDetails.OrderItemDetailId,        
 isBillingInserted */        
  FROM ORDERS         
 INNER JOIN dbo.OrderItems ON dbo.OrderItems.OrderId = dbo.Orders.OrderId        
 INNER JOIN dbo.OrderItemDetails ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId        
 INNER JOIN dbo.Products ON dbo.Products.ProductId = dbo.OrderItems.ProductId         
 INNER JOIN dbo.DeliveryType ON dbo.DeliveryType.DeliveryTypeId = dbo.Orders.DeliveryTypeId         
 INNER JOIN ARC on ORDERS.ARC_CODE = ARC.ARC_CODE        
 LEFT OUTER JOIN dbo.Device_API ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID        
 LEFT OUTER JOIN dbo.Network_Operators ON OrderItemDetails.ICCID LIKE Network_Operators.ICCIDPrefix + '%'        
 LEFT OUTER JOIN  [PaymentTransaction] on Orders.OrderID = [PaymentTransaction].OrderID         
 LEFT OUTER JOIN  [BillingCycle] on Orders.BillingCycleID = [BillingCycle].ID         
 WHERE          
 OrderStatusId IN (10)         
 AND OrderItemStatusId NOT IN (13)         
 --AND  dbo.OrderItems.IsCSD = 0   --** Activation is now pushed on this report as well      
 --AND Orders.ProcessedOn >='24 NOV 2014'         
 AND Orders.ProcessedOn < GETDATE()        
 AND isBillingInserted = 0         
 AND Not Exists (Select [vw_OrderDataFull].OrderID FROM [vw_OrderDataFull]         
 WHERE [vw_OrderDataFull].OrderID = Orders.OrderID AND isBOSInserted = 0         
 AND vw_OrderDataFull.ProductType ='Product' AND categoryID != 5 and OrderitemstatusID != 13  )         
 --AND nullif(Orders.salesReply,'') is not null         
 AND Orders.Ordertype=2  AND [BillingCycle].ID in (1,2)      
 and Orders.OrderId in (select distinct OrderId from PaymentTransaction) )A  
 --Modified for adding OverideBillingCodes tables
 left outer join OverideBillingCodes B
 on A.Account_Number=B.originalcode
 
  
       
 SELECT  Orders.OrderID as 'OrderID',OrderItems.OrderItemId  OrderItemID into #Temp      
  FROM ORDERS         
 INNER JOIN dbo.OrderItems ON dbo.OrderItems.OrderId = dbo.Orders.OrderId        
 INNER JOIN dbo.OrderItemDetails ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId        
 INNER JOIN dbo.Products ON dbo.Products.ProductId = dbo.OrderItems.ProductId         
 INNER JOIN dbo.DeliveryType ON dbo.DeliveryType.DeliveryTypeId = dbo.Orders.DeliveryTypeId         
 INNER JOIN ARC on ORDERS.ARC_CODE = ARC.ARC_CODE        
 LEFT OUTER JOIN dbo.Device_API ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID        
 LEFT OUTER JOIN dbo.Network_Operators ON OrderItemDetails.ICCID LIKE Network_Operators.ICCIDPrefix + '%'        
 LEFT OUTER JOIN  [PaymentTransaction] on Orders.OrderID = [PaymentTransaction].OrderID         
 LEFT OUTER JOIN  [BillingCycle] on Orders.BillingCycleID = [BillingCycle].ID         
 WHERE          
 OrderStatusId IN (10)         
 AND OrderItemStatusId NOT IN (13)         
 --AND  dbo.OrderItems.IsCSD = 0   --** Activation is now pushed on this report as well      
 --AND Orders.ProcessedOn >='24 NOV 2014'         
 AND Orders.ProcessedOn < GETDATE()        
 AND isBillingInserted = 0         
 AND Not Exists (Select [vw_OrderDataFull].OrderID FROM [vw_OrderDataFull]         
 WHERE [vw_OrderDataFull].OrderID = Orders.OrderID AND isBOSInserted = 0         
 AND vw_OrderDataFull.ProductType ='Product' AND categoryID != 5 and OrderitemstatusID != 13  )         
 --AND nullif(Orders.salesReply,'') is not null         
 AND Orders.Ordertype=2  AND [BillingCycle].ID in (1,2)    
  and Orders.OrderId in (select distinct OrderId from PaymentTransaction)  
    
       
       
 Update Orders set OrderStatusId = 19  where OrderId in       
(select OrderId from #Temp)      
       
       
 Update OrderItemDetails  set isBillingInserted  = 1  where OrderItemId in       
(select OrderItemId from #Temp)      
       
       
 drop table #Temp      
       
         
 end
GO
/****** Object:  StoredProcedure [dbo].[USP_GetDispatchReport_Count]    Script Date: 12/14/2015 17:06:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*CreatedBy: Shyam  
CreatedOn -23/01/2015  
Purpose: To Update the counts on the report server  
[USP_GetDispatchReport_Count] 12  
*/      
      
CREATE PROCEDURE [dbo].[USP_GetDispatchReport_Count](@ReportID int)      
  
AS      
BEGIN    
  
Declare @Date Datetime    
      
if(@date is null)      
begin      
      
set @date = getdate()    
end     
    
  
  
Update [BOS].Dualcom_Reports.dbo.MasterReportInfo set DataCount = (  SELECT COUNT(*)   
           
    FROM  Arc_Ordering.dbo.vw_despatchlog VD      
    WHERE  CONVERT(VARCHAR(256), processedon, 103) = CONVERT(VARCHAR(256), @date, 103)      
           AND OrderStatusid IN (10, 19)      
           AND VD.IsDependentProduct = 0      
           )  
 Where ReportiD=@ReportID  
  
  
  
                 
  END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetDispatchReport]    Script Date: 12/14/2015 17:06:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*CreatedBy: Shyam  
CreatedOn -23/01/2015  
Purpose: To get the despatch log data  
*/      
CREATE PROCEDURE [dbo].[USP_GetDispatchReport]      
 @date DATETIME = null    
AS      
BEGIN      
      
if(@date is null)      
begin      
      
set @date = getdate()    
end      
    SELECT DeliveryNoteNo,      
           ISNULL(ItemDlvNoteNo, '') AS [CSL Delivery Note],      
           VD.SalesRep,      
           VD.CompanyName,      
           ARC_Code,      
           ProductCode,      
           GPRSNo,      
           ISNULL(ICCID, '') AS ICCID,      
           ISNULL(DataNo, '') AS DataNo,      
           ISNULL(IPAddress, '') AS IPAdd,      
           Vd.InstallerCode,      
           vd.UniqueCode,      
           CONVERT(VARCHAR(256), OrderDate, 103) AS OrderDate,      
           CONVERT(VARCHAR(256), Processedon, 103) DespatchDate,      
           ISNULL(Grade, '') AS Grade,      
           OrderNo,      
           [ARC Ref],      
           ISNULL(BOS_Grade, '') AS BOS_Grade,      
           ProcessedBy,      
           ProcessedOn,      
           --Rtrim(ProductName ),      
           InstallerName,      
     FOC,      
     REPLACEMENT,      
     CSD    
           
    FROM  Arc_Ordering.dbo.vw_despatchlog VD      
    WHERE  CONVERT(VARCHAR(256), processedon, 103) = CONVERT(VARCHAR(256), @date, 103)      
           AND OrderStatusid IN (10, 19)      
           AND VD.IsDependentProduct = 0      
                 
              
                 
         -- return @count      
END
GO
/****** Object:  StoredProcedure [dbo].[USP_CreateOrderForM2M]    Script Date: 12/14/2015 17:06:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =====================================================================================  
-- Modified by:Atiq   
-- Modified Date:04/08/2015  
-- add two functions fn_GetCurrencyId and fn_GetProductPrice to get currency id and price  
-- Modified By:Atiq  
-- Modified Date:08/05/2015  
-- Add one more parameter @MaxProductQty to validate max quantity of the product   
-- Modified By :atiq  
-- Modified Date:15/06/2015  
-- Add code to validate @VoiceproductId and @SMSproductId if its zero the it will be populated   
-- from M2MProductDefaultVoiceSMS for default voice and sms id.  
-- =======================================================================================  
CREATE PROCEDURE [dbo].[USP_CreateOrderForM2M]  
(  
  
 @CreatedBy nvarchar(256),  
 @UserName varchar(256),  
 @UserEmail varchar(256),  
 @UserId nvarchar(256),  
 @ProductId   INT,  
 @ProductQty  INT,  
 @CategoryId  INT,  
 @Iccid NVARCHAR(300),  
 @IsCSD BIT ,  
 @VoiceproductId INT,  
 @SMSproductId INT,  
 @MaxProductQty INT  
)  
As  
BEGIN TRY   
 BEGIN TRANSACTION;  
  Declare @OrderNo INT  
  Declare @OrderId INT  
  DECLARE @OrderItemId INT              
  DECLARE @OrderItemTotalPrice DECIMAL(8, 2)   
  Declare @VoiceTotalPrice  DECIMAL(8, 2)            
  Declare @SMSTotalPrice   DECIMAL(8, 2)           
  DECLARE @Price DECIMAL(8, 2)     
  DEclare @VoicePrice DECIMAL(8,2)  
  DEclare @SMSPrice DECIMAL(8,2)  
  DECLARE @IsCreditAllowed BIT  
  DECLARE @AddRessId AS INT   
  DECLARE @InstallerId AS uniqueidentifier   
  DECLARE @InstallerUnqCode AS INT   
  DECLARE @CurrencyId AS INT   
        DECLARE @TotalProductQty INT  
  DECLARE @DeliveryAddressID AS INT   
    
  IF(@VoiceproductId=0)  
  BEGIN  
     SELECT DISTINCT @VoiceproductId=DefaultVoiceID from dbo.M2MProductDefaultVoiceSMS    
  END   
  IF(@SMSproductId=0)  
  BEGIN  
     SELECT DISTINCT @SMSproductId=DefaultSMSID from dbo.M2MProductDefaultVoiceSMS    
  END  
    
    
  SELECT @AddRessId = AddRessId,@InstallerId =CompanyId, @InstallerUnqCode = UniqueCode,@IsCreditAllowed = [IsCreditAllowed]   FROM USERMAPPING WHERE UserId = @UserId  
  SELECT @DeliveryAddressID = DeliveryAddressId FROM ORDERS WHERE ORDERID =(SELECT MAX(ORDERID) FROM ORDERS WHERE UserId = @UserId AND ORDERSTATUSID > 1 )  
  IF @DeliveryAddressID IS NULL   
  BEGIN   
   SET @DeliveryAddressID = @AddRessId  
  END   
     Select @CurrencyId=dbo.fn_GetCurrencyId(@InstallerId)  
     
    
  IF EXISTS (SELECT OrderID FROM ORDERS WHERE OrderStatusID =1 AND USERID = @USERID AND ORDERTYPE = 1 ) -- ** If Order exists in ARC Ordering  
  BEGIN   
   Declare @OrderIdTODelete INT  
   SELECT @OrderIdTODelete= OrderID FROM ORDERS WHERE OrderStatusID =1 AND USERID = @USERID AND ORDERTYPE = 1  
   EXEC USP_DeleteOrderwithDetails @OrderIdTODelete  
  END   
   
  -- Create order  
  IF NOT EXISTS (SELECT OrderId FROM Orders WHERE OrderStatusId = 1 And UserId = @UserId )  
  BEGIN  
	Select @OrderNo = IsNull(MAX(IsNull(Cast(OrderNo as Int), 1000)) + 1, 1001) from Orders   
	 where orderid > 89396 and OrderNo not in (  
	-- Accidentally the orderno was increased to 186533 from 86533 which resulted in orderno to go far ahead,   
	-- below must be avoided for new orders  
	'186578','186577','186576','186575','186574','186573','186572','186571','186570',
	'186569','186568','186567','186566','186565','186564','186563','186562','186561','186560','186559','186558','186557','186556','186555','186554',  
	'186553','186552','186551','186550','186549','186548','186547','186546','186545','186544','186543','186542','186541','186540',  
	'186539','186538','186537','186536','186535','186534','99007 ','99006 ','99005 ','99004 ','99003 ','99002 ','99001',
	'186608','186607','186606','186605','186604','186603','186602','186601','186600','186599','186598','186597','186596','186595','186594','186593',
	'186592','186591','186590','186589','186588','186609','186610','186611','186612','186613','186614'
	)  
   
	if(@OrderNo = 186532)  
	Select @OrderNo = IsNull(MAX(IsNull(Cast(OrderNo as Int), 1000)) + 500, 1001) from Orders   
         
   
   
   IF @OrderNo Is Null  
   BEGIN  
    SET @OrderNo = 100001  
   END  
   
   IF @ProductQty<=@MaxProductQty   
   BEGIN  
   INSERT INTO Orders  
   (  
    OrderNo,OrderDate,Amount,DeliveryCost,  
    OrderStatusId,DeliveryAddressId,BillingAddressId,OrderTotalAmount,  
    DeliveryTypeId,ARCId,ARC_Code,ARC_EmailId,   
    ARC_BillingAccountNo,UserName,UserEmail,CreatedBy,  
    CreatedOn,ModifiedBy,ModifiedOn,UserId,  
    InstallerId,InstallerUnqCode,Ordertype,CurrencyId  
    )  
      VALUES   
   (  
    @OrderNo, GETDATE(), 0, 0,  
    1, @AddRessId,@AddRessId, 0,  
    9,0,'','',     
    null, @UserName, @UserEmail,@CreatedBy,  
    GETDATE(), @CreatedBy, GETDATE(),@UserId,  
    @InstallerId,@InstallerUnqCode,2,@CurrencyId  
    ) -- **Order type is 2 for M2M       
      
    SELECT @OrderId= Cast(SCOPE_IDENTITY() as int), @OrderNo=Cast(@OrderNo as NVarchar(256))  
    SET @TotalProductQty=@ProductQty   
    select @TotalProductQty  
      
   END  
       
  END  
  ELSE  
  BEGIN  
   SELECT @OrderId=O.OrderId ,@OrderNo= Cast(O.OrderNo as NVarchar(256))   
   FROM Orders O  
   WHERE O.OrderStatusId = 1 And O.CreatedBy = @CreatedBy   
   GROUP BY O.OrderId, O.Amount, O.InstallerId, O.OrderNo  
   -- Select OrderId as [OrderId], 0 as [Amount], 0 as [Quantity] from Orders Where OrderStatusId = 1 And CreatedBy = @CreatedBy And ARCId = @ARC_Id  
   --Added below code by Atiq  
   --SELECT @OrderItemId=OrderItemId FROM OrderItems  WHERE  OrderId=@OrderId and ProductId=@ProductId  
   SELECT @OrderItemId=OrderItemId FROM OrderItems  WHERE  OrderId=@OrderId  and ProductId=@ProductId  
     AND EXISTS (SELECT ORDERITEMID FROM [OrderDependentItems] WHERE   
      OrderDependentItems.ProductID = @VoiceproductId  
      AND [OrderDependentItems].OrderitemID = OrderItems.OrderitemID)  
      AND EXISTS ( SELECT ORDERITEMID FROM [OrderDependentItems] WHERE   
      OrderDependentItems.ProductID = @SMSproductId  
      AND [OrderDependentItems].OrderitemID = OrderItems.OrderitemID)  
        
   IF EXISTS(SELECT OrderItemId FROM OrderItems  WHERE  OrderItemId=@OrderItemId)  
   BEGIN  
         SELECT @TotalProductQty= ProductQty FROM OrderItems  WHERE  OrderItemId=@OrderItemId  
            SET @TotalProductQty=@TotalProductQty+@ProductQty         
      END  
      ELSE  
      BEGIN   
            SET @TotalProductQty=@ProductQty              
      END   
          
  END  
   --  orderid should not be null or 0     
   IF  @OrderId >0 AND @TotalProductQty<=@MaxProductQty   
   BEGIN  
       
    -- ** SET PRICE  
    IF @IsCreditAllowed = 1   
    BEGIN  
     SELECT @Price = 0.00  
     SELECT @VoicePrice = 0.00   
     SELECT @SMSPrice = 0.00   
    END  
    ELSE  
    BEGIN      
    /*  
          SELECT @Price =  t.Price  
    FROM   (  
                   SELECT p.ProductId,  
                          p.ProductCode,  
                          p.ProductName,  
                          p.DefaultImage,  
                          p.ProductType,  
                          p.Price  
                   FROM   Products p    
                   WHERE  p.ProductId = @ProductId  
     ) t      
       
     SELECT @VoicePrice = Price FROM Products WHERE ProductID = @VoiceProductID  
  
     SELECT @SMSPrice = Price FROM Products WHERE ProductID = @SMSProductID  
    */  
       
    SELECT @Price=dbo.fn_GetProductPrice(@InstallerId,@ProductId)  
    SELECT @VoicePrice = dbo.fn_GetProductPrice(@InstallerId,@VoiceProductID)  
    SELECT @SMSPrice = dbo.fn_GetProductPrice(@InstallerId,@SMSProductID)  
           
    END  
    -- **END OF SET PRICE  
  
    -- calculate total price   
    SET @OrderItemTotalPrice = @Price * @ProductQty    
    SET @VoiceTotalPrice = @VoicePrice * @ProductQty  
    SET @SMSTotalPrice = @SMSPrice * @ProductQty   
  
    IF NOT EXISTS (  
    SELECT OrderItemId FROM OrderItems  WHERE  OrderId=@OrderId and ProductId=@ProductId  
     AND EXISTS (SELECT ORDERITEMID FROM [OrderDependentItems] WHERE   
      OrderDependentItems.ProductID = @VoiceproductId  
      AND [OrderDependentItems].OrderitemID = OrderItems.OrderitemID)  
      AND EXISTS ( SELECT ORDERITEMID FROM [OrderDependentItems] WHERE   
      OrderDependentItems.ProductID = @SMSproductId  
      AND [OrderDependentItems].OrderitemID = OrderItems.OrderitemID)  
    )   
    --or @IsCSD = 1  
          BEGIN  
     -- insert items details   
     INSERT INTO OrderItems  
     (  
     OrderId,  
     ProductId,  
     ProductQty,  
     Price,  
     OrderItemStatusId,  
     CreatedOn,  
     CreatedBy,  
     ModifiedOn,  
     ModifiedBy,  
     CategoryId,  
     IsNewItem,  
     IsCSD  
     )  
     VALUES  
     (  
     @OrderId,  
     @ProductId,  
     @ProductQty,  
     @Price,  
     1,  
     GETDATE(),  
     @CreatedBy,  
     GETDATE(),  
     @CreatedBy,  
     @CategoryId,  
     0,  
     @IsCSD  
     )              
     SELECT @OrderItemId = SCOPE_IDENTITY()  
     select @OrderItemId,@VoiceProductID,@SMSProductID  
     INSERT INTO [OrderDependentItems]([OrderId],[OrderItemId],[ProductId],[ProductQty],[Price])   
     VALUES (@OrderID,@orderItemID,@VoiceProductID ,@ProductQty, @VoicePrice)  
       
     INSERT INTO [OrderDependentItems]([OrderId],[OrderItemId],[ProductId],[ProductQty],[Price])   
     VALUES (@OrderID,@orderItemID,@SMSProductID ,@ProductQty, @SMSPrice)  
  
     UPDATE ORDERITEMS SET CSLConnectCodePrefix = (SELECT PRODUCTCODE FROM PRODUCTS WHERE ProductID = @VoiceProductID)  
              + (SELECT PRODUCTCODE FROM PRODUCTS WHERE ProductID = @SMSProductID)  
     FROM ORDERITEMS WHERE [OrderItemId] = @OrderItemId  
                        
     -- update order Amount  
     UPDATE Orders  
     SET    OrderDate = GETDATE(),  
         Amount = Amount + @OrderItemTotalPrice + @VoiceTotalPrice + @SMSTotalPrice ,  
         ModifiedBy = @CreatedBy,  
         ModifiedOn = GETDATE()  
     WHERE  OrderId = @OrderId  
       -- insert details in orderitemdetails table with ICCID         
       EXEC USP_InsertOrderItemDetailsForM2M @OrderId,@OrderItemId,@Iccid,@CreatedBy,@ProductQty        
             END  
    ELSE  
       BEGIN   
      IF(@IsCSD=0)  
      BEGIN  
        
      SELECT @OrderItemId=OrderItemId FROM OrderItems  WHERE  OrderId=@OrderId and ProductId=@ProductId  
     AND EXISTS ( SELECT ORDERITEMID FROM [OrderDependentItems] WHERE   
      OrderDependentItems.ProductID = @VoiceproductId  
      AND [OrderDependentItems].OrderitemID = OrderItems.OrderitemID)  
      AND EXISTS ( SELECT ORDERITEMID FROM [OrderDependentItems] WHERE   
      OrderDependentItems.ProductID = @SMSproductId  
      AND [OrderDependentItems].OrderitemID = OrderItems.OrderitemID)  
       -- update the item qty  
       -- added below code  
       IF(@TotalProductQty<=@MaxProductQty)  
       BEGIN  
       UPDATE OrderItems SET ProductQty= ProductQty+ @ProductQty WHERE  OrderItemId=@OrderItemId and IsCSD = @IsCSD   
                UPDATE [OrderDependentItems] SET ProductQty= ProductQty+ @ProductQty   WHERE  OrderItemId=@OrderItemId  
     -- update order Amount  
     UPDATE Orders  
     SET    OrderDate = GETDATE(),  
         Amount = Amount + @OrderItemTotalPrice + @VoiceTotalPrice + @SMSTotalPrice,  
         ModifiedBy = @CreatedBy,  
         ModifiedOn = GETDATE()  
     WHERE  OrderId = @OrderId  
     -- insert details in orderitemdetails table with ICCID        
      EXEC USP_InsertOrderItemDetailsForM2M @OrderId,@OrderItemId,@Iccid,@CreatedBy,@ProductQty             
      END        
      END  
   END      
  END  
     SELECT @OrderId as OrderId  
    COMMIT TRANSACTION;    
 END TRY   
 BEGIN CATCH   
  IF @@TRANCOUNT > 0  
  ROLLBACK TRANSACTION;  
  EXEC USP_SaveSPErrorDetails  
  RETURN -1   
 END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_CreateM2MUser]    Script Date: 12/14/2015 17:06:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Modified by:Atiq
-- Modified Date:18-05-2015
-- Call USP_AllocateOEMProductsToInstaller to mapp the oem products to the company
-- Modified Date :22-05-2015
-- =============================================
CREATE PROCEDURE [dbo].[USP_CreateM2MUser]
@UserId nvarchar(500),
@CompanyId nvarchar(500),
@UserCategoryId nvarchar(500),
@FirstName nvarchar(512),
@LastName nvarchar(512),
@Email nvarchar(256),
@ContactNumber nvarchar(256),
@AddressOne nvarchar(256),
@AddressTwo nvarchar(256),
@Town nvarchar(256),
@County nvarchar(256),
@PostCode nvarchar(256),
@Country nvarchar(256),
@CountryId int,
@UserName nvarchar(256),
@homeCountryId INT=1,
@currencyId INT
AS

BEGIN TRY   

BEGIN

set @homeCountryId = 1
--set @currencyId = 1
BEGIN TRANSACTION 
      -- insert user address 
	  INSERT INTO Address(ContactName,FirstName,LastName,AddressOne,AddressTwo,Town,County,PostCode,Email,Mobile,Country,CreatedBy,CreatedOn,CountryId)

                  VALUES(@FirstName + ' ' + @LastName,@FirstName,@LastName,@AddressOne,@AddressTwo,@Town,@County,@PostCode,@Email,@ContactNumber,@Country,@UserName,GETDATE(),@CountryId)

				   



	   -- Map user with Company & User Category



	   declare @UniqueCode int

	   select @UniqueCode = UniqueCode from Installer where InstallerCompanyID = @CompanyId



	   INSERT INTO UserMapping (UserId,UserCategoryId,CompanyId,AddressId,HomeCountryId,CurrencyID,UniqueCode) VALUES(@UserId,@UserCategoryId,@CompanyId,CAST(SCOPE_IDENTITY() AS INT),@homeCountryId,@currencyId,@UniqueCode)
	   
       ---Use below code to map OEMProducts
       exec USP_AllocateOEMProductsToInstaller @CompanyId
       SELECT 1 AS Success

COMMIT TRANSACTION



END



END TRY

BEGIN CATCH 

    ROLLBACK

	EXEC USP_SaveSPErrorDetails     

    RETURN -1        





END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_CreateM2MOrder_for_Replacement]    Script Date: 12/14/2015 17:06:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =====================================================================================
-- Modified by:Atiq 
-- Modified Date:06/05/2015
-- add two functions fn_GetCurrencyId and fn_GetProductPrice to get currency id and price
-- =======================================================================================
CREATE PROCEDURE [dbo].[USP_CreateM2MOrder_for_Replacement]
	-- Add the parameters for the stored procedure here
	@AddressID INT,
	@UserSimsID INT
AS
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @OrderNo INT
	DECLARE @OrderId INT
	DECLARE @OrderItemId INT            
	DECLARE @OrderItemTotalPrice DECIMAL(8, 2) 
	Declare @VoiceTotalPrice  DECIMAL(8, 2)          
	Declare @SMSTotalPrice   DECIMAL(8, 2)         
	DECLARE @Price DECIMAL(8, 2)   
	DEclare @VoicePrice DECIMAL(8,2)
	DEclare @SMSPrice DECIMAL(8,2)
	DECLARE @IsCreditAllowed BIT
	DECLARE @InstallerId AS uniqueidentifier 
	DECLARE @InstallerUnqCode AS INT 
	DECLARE @UserId NVARCHAR(256)
	DECLARE @BillingAddressID INT
	DECLARE @BillingCycleID INT
	DECLARE @PaymentType INT
	DECLARE @UserName NVARCHAR(256)
	DECLARE @UserEmail NVARCHAR(256)
	DECLARE @CreatedBy NVARCHAR(256)
	
	DECLARE @OldOrderId INT
	DECLARE @OldOrderItemId INT
	DECLARE @ICCIDtoReplace NVARCHAR(50)
	DECLARE @ProductId INT
	DECLARE @VoiceProductID INT 
	DECLARE @SMSProductID INT 
	DECLARE @ProductQty INT 
	DECLARE @CategoryId INT
    DECLARE @CurrencyId AS INT 
    DECLARE @DeliveryTypeId AS INT
	DECLARE @SpecialInstructions AS NVARCHAR(256) --added by priya
	
	DECLARE @Old_Orderno INT
	DECLARE @Old_Orderdate DATETIME

	SET @ProductQty = 1
	
	-- ** Get details from USERSIMSID
		SELECT @UserId = UserSIMS.UserId,
				@InstallerId =CompanyId,
				@InstallerUnqCode = USERMAPPING.UniqueCode,
				@IsCreditAllowed = [IsCreditAllowed] ,
				@BillingAddressID = USERMAPPING.AddressID,
				@UserName = ASPNET_USERS.UserName,
				@UserEmail = ASPNET_MEMBERSHIP.Email,
				@OldOrderId = UserSIMS.OrderID, 
				@ICCIDtoReplace = [Device_API].Dev_Code,
				@ProductId = UserSIMS.ProductID,
				@CreatedBy = ASPNET_USERS.UserName
				
		FROM  [dbo].[Device_API]  INNER JOIN UserSIMS ON UserSIMS.DeviceID=[Device_API].ID
			INNER JOIN Products  ON Products.ProductId=UserSIMS.ProductId
			INNER JOIN USERMAPPING on UserSIMS.UserID = USERMAPPING.UserID
			INNER JOIN CSLORDERING.DBO.ASPNET_USERS ON USERMAPPING.UserID = ASPNET_USERS.UserID 
			INNER JOIN CSLORDERING.DBO.ASPNET_MEMBERSHIP ON ASPNET_USERS.UserID = ASPNET_MEMBERSHIP.UserID 
		WHERE UserSIMS.ID = @UserSimsID

        SELECT @Old_Orderno=OrderNo,@Old_Orderdate=OrderDate FROM ORDERS WHERE ORDERID=@OldOrderId
        
        select @CurrencyId=dbo.fn_GetCurrencyId(@InstallerId)
        Select @DeliveryTypeId=DeliveryTypeId FROM DeliveryPrices 
               Where CurrencyId=@CurrencyId and IsFreeDelivery=1
        
		SELECT @OldOrderItemId=ORDERITEMS.OrderITemID,@CategoryId = ORDERITEMS.CategoryID,@BillingCycleID=ORDERS.BillingCycleID,@PaymentType=ORDERS.PaymentType FROM ORDERITEMS INNER JOIN ORDERITEMDETAILS ON ORDERITEMDETAILS.OrderITEMID =ORDERITEMS.OrderITEMID 
		JOIN ORDERS ON ORDERS.ORDERID = ORDERITEMS.ORDERID
			WHERE ORDERITEMS.ORDERID = @OldOrderId AND ProductID = @ProductID AND ORDERITEMDETAILS.ICCID = @ICCIDtoReplace

	  
		SELECT @VoiceProductID=Products.ProductID from [dbo].[OrderDependentItems] 
		INNER JOIN Products ON Products.ProductID = [OrderDependentItems].ProductID WHERE ORderITEMID = @OldOrderItemId AND CSLConnectVoice = 1 

		SELECT @SMSProductID=Products.ProductID from [dbo].[OrderDependentItems] 
		INNER JOIN Products ON Products.ProductID = [OrderDependentItems].ProductID WHERE ORderITEMID = @OldOrderItemId AND CSLConnectSMS = 1 

		----added by priya---
		SELECT @SpecialInstructions = UserRequest_Status_Map.Comments from [dbo].[UserRequest_Status_Map]
		JOIN UserSIMS ON UserRequest_Status_Map.UserSIMSId = UserSIMS.ID
		WHERE UserSIMS.ID=@UserSimsID
		-----------------------

	-- ** ENd of Get Details
	
	-- ** DELETE  OPEN ORDER FOR USER 
	IF EXISTS (SELECT OrderID FROM ORDERS WHERE OrderStatusID =1 AND USERID = @USERID ) 
	BEGIN 
		DECLARE @OrderIdTODelete INT
		SELECT TOP 1 @OrderIdTODelete= OrderID FROM ORDERS WHERE OrderStatusID =1 AND USERID = @USERID
		EXEC USP_DeleteOrderwithDetails @OrderIdTODelete
	END 
	-- ** END DELETE

	-- Create order
	IF NOT EXISTS (SELECT OrderId FROM Orders WHERE OrderStatusId = 1 And UserId = @UserId )
		BEGIN
			SELECT @OrderNo = IsNull(MAX(IsNull(Cast(OrderNo as Int), 1000)) + 1, 1001) FROM Orders -- Where ARCId = @ARC_Id
			IF @OrderNo Is Null
			BEGIN
				SET @OrderNo = 1001
			END
            --Below code is commented by Atiq on 06-Oct-2015
			--UPDATE ORDERS
			--SET M2MReplacementOrderNo = @OrderNo
			--WHERE Orders.OrderId = @OldOrderId
			--Added Below code is commented by Atiq on 06-Oct-2015
            EXEC USP_InsertOrderSIMMapForM2M @Old_Orderno,@ICCIDtoReplace,@Old_Orderdate,@OrderNo,null
			--special instructions not included
			INSERT INTO Orders
			(OrderNo, OrderDate, Amount, DeliveryCost, OrderStatusId, DeliveryAddressId,
			BillingAddressId,BillingCycleID,PaymentType, OrderTotalAmount, DeliveryTypeId, ARCId, ARC_Code, ARC_EmailId, 
			ARC_BillingAccountNo, UserName, UserEmail, 
			CreatedBy, CreatedOn, ModifiedBy, ModifiedOn,UserId,InstallerId,InstallerUnqCode,Ordertype,CurrencyId)
		    VALUES 
			(@OrderNo, GETDATE(), 0, 0, 1, @aDDRESSid, @BillingAddressID,@BillingCycleID,@PaymentType, 0, @DeliveryTypeId, 0, '', '', 
			 null, @UserName, @UserEmail,@UserName, GETDATE(), @UserName, GETDATE(),@UserId,@InstallerId,@InstallerUnqCode,2,@CurrencyId) -- **Order type is 2 for M2M
					
			SELECT @OrderId= Cast(SCOPE_IDENTITY() as int), @OrderNo=Cast(@OrderNo as NVarchar(256))

			-- ** SET PRICE
			IF @IsCreditAllowed = 1 
			BEGIN
				SELECT @Price = 0.00
				SELECT @VoicePrice = 0.00 
				SELECT @SMSPrice = 0.00 
			END
			ELSE
			BEGIN
			    /*
				SELECT @Price =  t.Price
				FROM   (
					SELECT p.ProductId,
							p.ProductCode,
							p.ProductName,
							p.DefaultImage,
							p.ProductType,
							p.Price
					FROM   Products p  
					WHERE  p.ProductId = @ProductId
					) t    
					
					SELECT @VoicePrice = Price FROM Products WHERE ProductID = @VoiceProductID
					SELECT @SMSPrice = Price FROM Products WHERE ProductID = @SMSProductID
					*/
			    SELECT @Price=dbo.fn_GetProductPrice(@InstallerId,@ProductId)
				SELECT @VoicePrice = dbo.fn_GetProductPrice(@InstallerId,@VoiceProductID)
				SELECT @SMSPrice = dbo.fn_GetProductPrice(@InstallerId,@SMSProductID)
					        
			END
			-- **END OF SET PRICE

			-- calculate total price 
			SET @OrderItemTotalPrice = @Price * @ProductQty  
			SET @VoiceTotalPrice = @VoicePrice * @ProductQty
			SET @SMSTotalPrice = @SMSPrice * @ProductQty  

			-- insert items details 
					INSERT INTO OrderItems
					(
					OrderId,
					ProductId,
					ProductQty,
					Price,
					OrderItemStatusId,
					CreatedOn,
					CreatedBy,
					ModifiedOn,
					ModifiedBy,
					CategoryId,
					IsNewItem,
					IsCSD
					)
					VALUES
					(
					@OrderId,
					@ProductId,
					@ProductQty,
					@Price,
					1,
					GETDATE(),
					@CreatedBy,
					GETDATE(),
					@CreatedBy,
					@CategoryId,
					0,
					0
					)            
					SELECT @OrderItemId = SCOPE_IDENTITY()
					
					INSERT INTO [OrderDependentItems]([OrderId],[OrderItemId],[ProductId],[ProductQty],[Price]) 
					VALUES (@OrderID,@orderItemID,@VoiceProductID ,@ProductQty, @VoicePrice)
					
					INSERT INTO [OrderDependentItems]([OrderId],[OrderItemId],[ProductId],[ProductQty],[Price]) 
					VALUES (@OrderID,@orderItemID,@SMSProductID ,@ProductQty, @SMSPrice)

					UPDATE ORDERITEMS SET CSLConnectCodePrefix = (SELECT PRODUCTCODE FROM PRODUCTS WHERE ProductID = @VoiceProductID)
													 + (SELECT PRODUCTCODE FROM PRODUCTS WHERE ProductID = @SMSProductID)
					FROM ORDERITEMS WHERE [OrderItemId] = @OrderItemId
										            
					-- update order Amount
					UPDATE Orders
					SET    OrderDate = GETDATE(),
						   Amount = Amount + @OrderItemTotalPrice + @VoiceTotalPrice + @SMSTotalPrice ,
						   ModifiedBy = @CreatedBy,
						   ModifiedOn = GETDATE(),
						   OrderstatusID=2,
						   SpecialInstructions = 'Auto Generated Replacement Order for SIM test ' + @ICCIDtoReplace +' '+ @SpecialInstructions
					WHERE  OrderId = @OrderId
				   -- insert details in orderitemdetails table with ICCID
				   EXEC USP_InsertOrderItemDetailsForM2M @OrderId,@OrderItemId,null,@CreatedBy,@ProductQty,1

					
		END
        SELECT @OrderId as OrderId, OrderNo, @UserId as UserId from Orders where OrderId = @OrderId
	   COMMIT TRANSACTION;	 
	END TRY 
	BEGIN CATCH 
		IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		EXEC USP_SaveSPErrorDetails
		RETURN -1 
	END CATCH
GO
/****** Object:  StoredProcedure [dbo].[USP_CreateInstallerUserForM2M]    Script Date: 12/14/2015 17:06:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Mohd Atiq
-- Create date: 29-Sep-2015
-- Description:	Added code to insert address in address table based on addressid from useraddress table
-- =============================================
CREATE PROCEDURE [dbo].[USP_CreateInstallerUserForM2M]
	-- Add the parameters for the stored procedure here
 @UserId UNIQUEIDENTIFIER=NULL,
 @UserCategoryId UNIQUEIDENTIFIER=NULL,
 @AddressId UNIQUEIDENTIFIER=NULL,
 @HomeCountryId INT,
 @CurrencyId INT

AS
    BEGIN TRY
		-- ** Hardcoded Default  as of now 
	 DECLARE @CompanyId NVARCHAR(500)	
	 BEGIN TRANSACTION;
			  IF EXISTS(SELECT 1 FROM CSLOrderingTest.dbo.UserAddress WHERE AddressID=@AddressId)
			  
			  BEGIN
			       INSERT INTO Address (ContactName,AddressOne,AddressTwo,Town,County,PostCode,Email,Fax,Telephone,Mobile,Country,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			       SELECT FirstName+''+LastName,AddressOne,AddressTwo,Town,County,PostCode,Email,Fax,Telephone,Mobile,Country,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn FROM CSLOrderingTest.dbo.UserAddress WHERE AddressID=@AddressId			       
			  END			  
			  ELSE
			  BEGIN
			              INSERT INTO Address(ContactName,AddressOne,ModifiedOn)VALUES ('','',getdate())		              
			              
			  END
			  -- map users
			    IF NOT EXISTS(SELECT 1 FROM UserMapping WHERE UserId=@UserId and UserCategoryId=@UserCategoryId )
					BEGIN
						 INSERT INTO UserMapping (UserId,UserCategoryId,CompanyId,UniqueCode,AddressId,HomeCountryId,CurrencyID)
						 SELECT @UserId,@UserCategoryId,[Installer_User_Map].installerCompanyID,Installer.UniqueCode,Cast(SCOPE_IDENTITY() as int),HomeCountryId,HomeCurrencyId
						 FROM  [dbo].[Installer_User_Map]
						 INNER JOIN INSTALLER on [Installer_User_Map].installerCompanyID = INSTALLER.installerCompanyID 
						 WHERE userID = @UserId
						 
                          -- Added below code to Allocate oem products to installer.
			              SELECT @CompanyId=CompanyId FROM UserMapping 
                                WHERE UserId=@UserId
                                EXEC USP_AllocateOEMProductsToInstaller @CompanyId
                                                                
						 COMMIT TRANSACTION;
						 SELECT  1 Status
					END
				ELSE 
					 BEGIN
						  COMMIT TRANSACTION;
						  SELECT  0 Status
					 END
     END TRY 
BEGIN CATCH 
	 IF XACT_STATE() <>  0
			ROLLBACK TRANSACTION;
			 EXEC USP_SaveSPErrorDetails
			SELECT  -1 Status
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[SP_SIM_REGISTER]    Script Date: 12/14/2015 17:06:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_SIM_REGISTER](@STARTDATE DATETIME, @ENDDATE DATETIME)
-- CREATED ON 02 10 2013 
-- CREATED BY - RAVI GILLELLA
AS
BEGIN
	--- SIM REGISTER ----
	select ICCID,
	ISNULL(DataNo,'') AS DataNo,
	ISNULL( IPAddress,'') as IPAddress,
	GPRSNo as ChipNo,
	ProductCode,ProductName
	,CompanyName,convert(varchar(256), Processedon ,103) DespatchDate
	,ARC_Code,Installer,InstallerCode,UniqueCode as InstallerUNQCode, 
	ISNULL( (SELECT TOP 1 OrderRefNo from Orders where ARCId in( 214,4) and OrderNo = vw_SIMRegister.OrderNo ) , '' ) as [REF] ,
	OrderNo
	from dbo.vw_SIMRegister where 
	CAST(processedon  as DATE)  > CAST( @STARTDATE  as DATE)
	and  
	CAST(processedon  as DATE)  < CAST( @ENDDATE  as DATE)
	 AND OrderStatusid in ( 10,14,15,16)
	 AND ICCID IS NOT NULL and orderitemstatusid <>13 
	order by processedon desc
END
GO
/****** Object:  StoredProcedure [dbo].[GetDispatchReport]    Script Date: 12/14/2015 17:06:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDispatchReport]
	@date DATETIME = null
AS
BEGIN

if(@date is null)
begin

set @date = getdate()
end
    SELECT DeliveryNoteNo,
           ISNULL(ItemDlvNoteNo, '') AS [CSL Delivery Note],
           VD.SalesRep,
           VD.CompanyName,
           ARC_Code,
           ProductCode,
           GPRSNo,
           ISNULL(ICCID, '') AS ICCID,
           ISNULL(DataNo, '') AS DataNo,
           ISNULL(IPAddress, '') AS IPAdd,
           Vd.InstallerCode,
           vd.UniqueCode,
           CONVERT(VARCHAR(256), OrderDate, 103) AS OrderDate,
           CONVERT(VARCHAR(256), Processedon, 103) DespatchDate,
           ISNULL(Grade, '') AS Grade,
           OrderNo,
           [ARC Ref],
           ISNULL(BOS_Grade, '') AS BOS_Grade,
           ProcessedBy,
           ProcessedOn,
           --Rtrim(ProductName ),
           InstallerName,
		   FOC,
		   REPLACEMENT,
		   CSD
    FROM   vw_despatchlog VD
    WHERE   DATEADD(dd, 0, DATEDIFF(dd, 0, processedon)) =  DATEADD(dd, 0, DATEDIFF(dd, 0, @date)) 
           AND OrderStatusid IN (10, 19)
           AND VD.IsDependentProduct = 0
END
GO
/****** Object:  View [dbo].[VW_DESPATCH_LOG_VICKIE_DAILY]    Script Date: 12/14/2015 17:06:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view  [dbo].[VW_DESPATCH_LOG_VICKIE_DAILY]  
 as  
 select DeliveryNoteNo,isnull(ItemDlvNoteNo,'') as [CSL Delivery Note],VD.SalesRep,VD.CompanyName,ARC_Code,ProductCode,GPRSNo,  
 ISNULL(ICCID,'') as ICCID,ISNULL(DataNo,'') as DataNo,ISNULL(IPAddress,'') as IPAdd,Vd.InstallerCode,vd.UniqueCode,convert(varchar(256),OrderDate,103) as OrderDate,  
 convert(varchar(256), Processedon ,103) DespatchDate,ISNULL(Grade,'') as Grade,OrderNo,[ARC Ref],ISNULL(BOS_Grade,'')as BOS_Grade,ProcessedBy,ProcessedOn,ProductName ,InstallerName  
 from vw_despatchlog  VD where   
 CAST(processedon  as DATE)  > CAST( getdate()- 1  as DATE)  
 and    
 CAST(processedon  as DATE)  < CAST( getdate() +1   as DATE)  
 AND OrderStatusid in ( 10,14,15,16,19)  
 and VD.ProductCode in (select ProductCode from Products where  IsDependentProduct = 0)
GO
/****** Object:  View [dbo].[VW_DESPATCH_LOG_PreviousMonth]    Script Date: 12/14/2015 17:06:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_DESPATCH_LOG_PreviousMonth]    
 as    
 select DeliveryNoteNo,isnull(ItemDlvNoteNo,'') as [CSL Delivery Note],VD.SalesRep,VD.CompanyName,ARC_Code,ProductCode,GPRSNo,    
 ISNULL(ICCID,'') as ICCID,ISNULL(DataNo,'') as DataNo,ISNULL(IPAddress,'') as IPAdd,Vd.InstallerCode,vd.UniqueCode,convert(varchar(256),OrderDate,103) as OrderDate,    
 convert(varchar(256), Processedon ,103) DespatchDate,ISNULL(Grade,'') as Grade,OrderNo,[ARC Ref],ISNULL(BOS_Grade,'')as BOS_Grade,ProcessedBy,ProcessedOn,ProductName ,InstallerName    
 from vw_despatchlog  VD where     
     
     
(DATEPART(year,processedon) =    
 case     
 when(DATEPART(month,GETDATE()) = 01)     
  then  DATEPART(year,getdate()) - 1    
 else    
  DATEPART(year,getdate())      
  END    
)    
and     
DATEPART(month,processedon) =     
case     
 when(DATEPART(month,GETDATE()) = 01)     
 then     
 12    
 else    
 (DATEPART(month,getdate())-1)    
end    
 AND OrderStatusid in ( 10,14,15,16,19)    
 and VD.ProductCode in (select ProductCode from Products where  IsDependentProduct = 0)
GO
/****** Object:  View [dbo].[VW_DESPATCH_LOG_CurrentMonth]    Script Date: 12/14/2015 17:06:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view  [dbo].[VW_DESPATCH_LOG_CurrentMonth]  
 as  
 select DeliveryNoteNo,isnull(ItemDlvNoteNo,'') as [CSL Delivery Note],VD.SalesRep,VD.CompanyName,ARC_Code,ProductCode,GPRSNo,  
 ISNULL(ICCID,'') as ICCID,ISNULL(DataNo,'') as DataNo,ISNULL(IPAddress,'') as IPAdd,Vd.InstallerCode,vd.UniqueCode,convert(varchar(256),OrderDate,103) as OrderDate,  
 convert(varchar(256), Processedon ,103) DespatchDate,ISNULL(Grade,'') as Grade,OrderNo,[ARC Ref],ISNULL(BOS_Grade,'')as BOS_Grade,ProcessedBy,ProcessedOn,ProductName ,InstallerName  
 from vw_despatchlog  VD where   
 DATEPART(year,processedon) = DATEPART(year,getdate())  
 and   
 DATEPART(month,processedon) = (DATEPART(month,getdate()))  
 AND OrderStatusid in ( 10,14,15,16,19)  
 and VD.ProductCode in (select ProductCode from Products where  IsDependentProduct = 0)
GO
/****** Object:  View [dbo].[vw_BillingOrdersList_Backup]    Script Date: 12/14/2015 17:06:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_BillingOrdersList_Backup]    
AS    


select OrderID,
OrderStatusId,
OrderItemStatusId,
case when  Account_Number = OriginalCode then OverideCode else  Account_Number end as Account_Number,
Order_Number,
CSL_Unique_Order_Number,
Package_Code,
Delivery_Product_Code,
Delivery_Charge,
Order_Date,
Del_Note_Number,
Charge_Qty,
Phone_Number,
IMSI,
Data_Number,
SIM_Number,
IP_Address,
Username_Description,
Installer_Code,
Old_Installer_Code,
Data_Provider,
Supplier_Network,
Original_StartDate,
Number_Start_Date,
Product_Start_Dates,
Order_Special_Inst,
Ancillary,
Rep_code,
rep_unit,
foc,
con_stk,
Swap_Out,
OrderItemDetailId,
isBillingInserted
from
(
     
 SELECT  Orders.OrderID as 'OrderID',OrderStatusId,OrderItemStatusId,    
 isnull(Eclipse_uniqueCode_mapping.Eclipse_uniqueCode,ARC.[UNiqueCode]) AS 'Account_Number' ,     
 substring(OrderRefNo,1,50) AS 'Order_Number' ,     
 OrderNo AS 'CSL_Unique_Order_Number',    
 Products.ProductCode AS 'Package_Code',     
 DeliveryType.DeliveryCode AS 'Delivery_Product_Code',    
 DeliveryType.DeliveryPrice AS 'Delivery_Charge',     
 Orders.OrderDate AS 'Order_Date',    
 --isnull(nullif(dbo.Orders.DeliveryNoteNo,''),dbo.GetDeliveryNoteNo(Orders.OrderID)) AS 'Del_Note_Number',    
 OrderNo + '1'  AS 'Del_Note_Number',    
 1 AS 'Charge_Qty',    
 'N/A'  AS 'Phone_Number',    
 ISNULL(nullif(Device_API.Dev_IMSINumber,''),'N/A') AS 'IMSI',    
 Isnull(CASE when ICCID like '00500%' THEN SUBSTRING (ICCID,0,12) ELSE nullif(dbo.Device_API.Data_Number,'') END,'N/A') AS 'Data_Number',    
 ISNULL(Replace(Orderitemdetails.ICCID,'E',''),'N/A') AS 'SIM_Number',    
 ISNULL(nullif(dbo.Device_API.Dev_IP_Address,''),'N/A') AS 'IP_Address',    
 ISNULL(nullif(dbo.OrderItemDetails.GPRSNo,''),'N/A') AS 'Username_Description',    
 InstallerUnqCode AS 'Installer_Code',    
 isnull(InstallerCode,'N.A') AS 'Old_Installer_Code',    
 isnull(Network_Operators.NetworkName,'N/A') AS 'Data_Provider',    
 isnull(Network_Operators.NetworkName,'N/A') AS 'Supplier_Network',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Original_StartDate',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Number_Start_Date',    
 DateAdd(Day, DateDiff(Day, 0, GetDate()), 0) AS 'Product_Start_Dates',    
 CONVERT(VARCHAR(50),ORders.SpecialInstructions) AS 'Order_Special_Inst',    
 CASE WHEN ProductType = 'Ancillary' OR OrderItems.CategoryID = 3  THEN 1   ELSE 0  END AS 'Ancillary',     
 Rep_code = Orders.salesReply ,    
 rep_unit = cast(ISNULL(IsReplacement,0) as bit) ,    
 foc = cast(ISNULL(IsFoc,0) as bit) ,    
 con_stk = cast(CASE WHEN Products.ProductCode in ('CS2100') THEN 1 WHEN Orders.ARC_CODE IN ('11','C1') THEN 1 ELSE ISNULL(OrderItems.IsReplenishment,0) END as bit) ,     
 Swap_Out = cast(0 as bit),     
 OrderItemDetails.OrderItemDetailId,    
 isBillingInserted     
  FROM ORDERS     
 INNER JOIN dbo.OrderItems ON dbo.OrderItems.OrderId = dbo.Orders.OrderId    
 INNER JOIN dbo.OrderItemDetails ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId    
 INNER JOIN dbo.Products ON dbo.Products.ProductId = dbo.OrderItems.ProductId     
 INNER JOIN dbo.DeliveryType ON dbo.DeliveryType.DeliveryTypeId = dbo.Orders.DeliveryTypeId     
 INNER JOIN ARC on ORDERS.ARC_CODE = ARC.ARC_CODE    
 LEFT OUTER JOIN dbo.Device_API ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID    
 LEFT OUTER JOIN dbo.Network_Operators ON OrderItemDetails.ICCID LIKE Network_Operators.ICCIDPrefix + '%'    
 LEFT OUTER JOIN dbo.Eclipse_uniqueCode_mapping on ARC.UniqueCode =Eclipse_uniqueCode_mapping.CSL_UniqueCode AND Products.ProductCode=Eclipse_uniqueCode_mapping.ProductCode    
 WHERE  OrderStatusId IN (10)     
 AND OrderItemStatusId NOT IN (13)     
 AND  dbo.OrderItems.IsCSD = 0     
 AND Products.ProductCode not like 'CS2244'     
 --AND Orders.ProcessedOn >='01 Feb 2014'     
 --AND Orders.Orderdate <'24 Feb 2014'     
 AND isBillingInserted = 0     
 AND Not Exists (Select [vw_OrderDataFull].OrderID FROM [vw_OrderDataFull] WHERE [vw_OrderDataFull].OrderID = Orders.OrderID AND isBOSInserted = 0 AND vw_OrderDataFull.ProductType ='Product' AND categoryID != 5 and OrderitemstatusID != 13  )     
 AND nullif(Orders.salesReply,'') is not null     
 and nullif(Orders.ARC_CODE,'') is not null AND Orders.ARC_CODE != 'OO' -- Replacement_ARC    
 AND Orders.Ordertype=1    
    
UNION ALL  -- ** SWAPPED OUT ITEMS WITH -ve qty     
    
 SELECT  Orders.OrderID as 'OrderID', OrderStatusId,OrderItemStatusId,    
 isnull(Eclipse_uniqueCode_mapping.Eclipse_uniqueCode,ARC.[UNiqueCode]) AS 'Account_Number' ,     
 substring(OrderRefNo,1,50) AS 'Order_Number' ,     
 OrderNo AS 'CSL_Unique_Order_Number',    
 Products.ProductCode AS 'Package_Code',     
 DeliveryType.DeliveryCode AS 'Delivery_Product_Code',    
 DeliveryType.DeliveryPrice AS 'Delivery_Charge',     
 Orders.OrderDate AS 'Order_Date',    
 OrderNo + '1'  AS 'Del_Note_Number',    
 -1 AS 'Charge_Qty',    
 'N/A'  AS 'Phone_Number',    
 'N/A' AS 'IMSI',    
 'N/A' AS 'Data_Number',    
 'N/A' AS 'SIM_Number',    
 'N/A'AS 'IP_Address',    
 'N/A' AS 'Username_Description',    
 InstallerUnqCode AS 'Installer_Code',    
 isnull(InstallerCode,'N.A') AS 'Old_Installer_Code',    
 'N/A' AS 'Data_Provider',    
 'N/A' AS 'Supplier_Network',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Original_StartDate',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Number_Start_Date',    
 DateAdd(Day, DateDiff(Day, 0, GetDate()), 0) AS 'Product_Start_Dates',    
 CONVERT(VARCHAR(50),ORders.SpecialInstructions) AS 'Order_Special_Inst',    
 CASE WHEN ProductType = 'Ancillary' OR OrderItems.CategoryID = 3  THEN 1   ELSE 0  END AS 'Ancillary',     
 Rep_code = Orders.salesReply ,    
 rep_unit = cast(ISNULL(IsReplacement,0) as bit) ,    
 foc = cast(ISNULL(IsFoc,0) as bit) ,    
 con_stk = cast(CASE WHEN Products.ProductCode in ('CS2100') THEN 1 WHEN Orders.ARC_CODE IN ('11','C1') THEN 1 ELSE ISNULL(OrderItems.IsReplenishment,0) END as bit) ,     
 Swap_Out = cast(1 as bit),     
 cast(OrderItemDetails.OrderItemDetailId as varchar(10)) + cast(swapoutID as varchar(10))  AS OrderItemDetailId ,    
 isBillingInserted     
 FROM ORDERS     
 INNER JOIN dbo.OrderItems ON dbo.OrderItems.OrderId = dbo.Orders.OrderId    
 INNER JOIN dbo.OrderItemDetails ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId    
 INNER JOIN SWAPOUT on OrderItems.OrderItemId = SWAPOUT.OrderItemId    
 INNER JOIN dbo.Products ON dbo.Products.ProductId = dbo.SWAPOUT.BundleProductId     
 INNER JOIN dbo.DeliveryType ON dbo.DeliveryType.DeliveryTypeId = dbo.Orders.DeliveryTypeId     
 INNER JOIN ARC on ORDERS.ARC_CODE = ARC.ARC_CODE    
 LEFT OUTER JOIN dbo.Device_API ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID    
 LEFT OUTER JOIN dbo.Network_Operators ON OrderItemDetails.ICCID LIKE Network_Operators.ICCIDPrefix + '%'    
 LEFT OUTER JOIN dbo.Eclipse_uniqueCode_mapping on ARC.UniqueCode =Eclipse_uniqueCode_mapping.CSL_UniqueCode AND Products.ProductCode=Eclipse_uniqueCode_mapping.ProductCode    
 WHERE  OrderStatusId IN (10)     
 AND OrderItemStatusId NOT IN (13)     
 AND  dbo.OrderItems.IsCSD = 0     
 AND Products.ProductCode not like 'CS2244'     
 AND isBillingInserted = 0     
 AND Not Exists (Select [vw_OrderDataFull].OrderID FROM [vw_OrderDataFull] WHERE [vw_OrderDataFull].OrderID = Orders.OrderID AND isBOSInserted = 0 AND vw_OrderDataFull.ProductType ='Product' AND categoryID != 5 and OrderitemstatusID != 13  )     
 AND nullif(Orders.salesReply,'') is not null     
 and nullif(Orders.ARC_CODE,'') is not null AND Orders.ARC_CODE != 'OO' -- Replacement_ARC    
 AND Orders.Ordertype=1    
    
UNION ALL -- SWAP OUT ITEMS WITH +ve     
    
 SELECT  Orders.OrderID as 'OrderID',OrderStatusId,OrderItemStatusId,    
 isnull(Eclipse_uniqueCode_mapping.Eclipse_uniqueCode,ARC.[UNiqueCode]) AS 'Account_Number' ,      
 substring(OrderRefNo,1,50) AS 'Order_Number' ,     
 OrderNo AS 'CSL_Unique_Order_Number',    
 Products.ProductCode AS 'Package_Code',     
 DeliveryType.DeliveryCode AS 'Delivery_Product_Code',    
 DeliveryType.DeliveryPrice AS 'Delivery_Charge',     
 Orders.OrderDate AS 'Order_Date',    
 OrderNo + '1'  AS 'Del_Note_Number',    
 1 AS 'Charge_Qty',    
 'N/A'  AS 'Phone_Number',    
 'N/A' AS 'IMSI',    
 'N/A' AS 'Data_Number',    
 'N/A' AS 'SIM_Number',    
 'N/A'AS 'IP_Address',    
 'N/A' AS 'Username_Description',    
 InstallerUnqCode AS 'Installer_Code',    
 isnull(InstallerCode,'N.A') AS 'Old_Installer_Code',    
 'N/A' AS 'Data_Provider',    
 'N/A' AS 'Supplier_Network',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Original_StartDate',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Number_Start_Date',    
 DateAdd(Day, DateDiff(Day, 0, GetDate()), 0) AS 'Product_Start_Dates',    
 CONVERT(VARCHAR(50),ORders.SpecialInstructions) AS 'Order_Special_Inst',    
 CASE WHEN ProductType = 'Ancillary' OR OrderItems.CategoryID = 3  THEN 1   ELSE 0  END AS 'Ancillary',     
 Rep_code = Orders.salesReply ,    
 rep_unit = cast(ISNULL(IsReplacement,0) as bit) ,    
 foc = cast(ISNULL(IsFoc,0) as bit) ,    
 con_stk = cast(CASE WHEN Products.ProductCode in ('CS2100') THEN 1 WHEN Orders.ARC_CODE IN ('11','C1') THEN 1 ELSE ISNULL(OrderItems.IsReplenishment,0) END as bit) ,     
 Swap_Out = cast(1 as bit),     
 cast(OrderItemDetails.OrderItemDetailId as varchar(10)) + cast(swapoutID as varchar(10)) AS OrderItemDetailId , -- + + '00'  altered as range out of int  
 isBillingInserted     
 FROM ORDERS     
 INNER JOIN dbo.OrderItems ON dbo.OrderItems.OrderId = dbo.Orders.OrderId    
 INNER JOIN dbo.OrderItemDetails ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId    
 INNER JOIN SWAPOUT on OrderItems.OrderItemId = SWAPOUT.OrderItemId    
 INNER JOIN dbo.Products ON dbo.Products.ProductId = dbo.SWAPOUT.SwapWithProductId     
 INNER JOIN dbo.DeliveryType ON dbo.DeliveryType.DeliveryTypeId = dbo.Orders.DeliveryTypeId     
 INNER JOIN ARC on ORDERS.ARC_CODE = ARC.ARC_CODE    
 LEFT OUTER JOIN dbo.Device_API ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID    
 LEFT OUTER JOIN dbo.Network_Operators ON OrderItemDetails.ICCID LIKE Network_Operators.ICCIDPrefix + '%'    
 LEFT OUTER JOIN dbo.Eclipse_uniqueCode_mapping on ARC.UniqueCode =Eclipse_uniqueCode_mapping.CSL_UniqueCode AND Products.ProductCode=Eclipse_uniqueCode_mapping.ProductCode    
 WHERE  OrderStatusId IN (10)     
 AND OrderItemStatusId NOT IN (13)     
 AND  dbo.OrderItems.IsCSD = 0     
 AND Products.ProductCode not like 'CS2244'     
 --AND Orders.ProcessedOn >='01 Feb 2014'     
 --AND Orders.Orderdate <'24 Feb 2014'     
 AND isBillingInserted = 0     
 AND Not Exists (Select [vw_OrderDataFull].OrderID FROM [vw_OrderDataFull] WHERE [vw_OrderDataFull].OrderID = Orders.OrderID AND isBOSInserted = 0 AND vw_OrderDataFull.ProductType ='Product' AND categoryID != 5 and OrderitemstatusID != 13  )     
 AND nullif(Orders.salesReply,'') is not null     
 and nullif(Orders.ARC_CODE,'') is not null AND Orders.ARC_CODE != 'OO' -- Replacement_ARC    
 AND Orders.Ordertype=1    
    
UNION ALL -- Deleted Items     
    
SELECT  Orders.OrderID as 'OrderID',OrderStatusId,OrderItemStatusId,    
 isnull(Eclipse_uniqueCode_mapping.Eclipse_uniqueCode,ARC.[UNiqueCode]) AS 'Account_Number' ,     
 substring(OrderRefNo,1,50) AS 'Order_Number' ,     
 OrderNo AS 'CSL_Unique_Order_Number',    
 Products.ProductCode AS 'Package_Code',     
 DeliveryType.DeliveryCode AS 'Delivery_Product_Code',    
 DeliveryType.DeliveryPrice AS 'Delivery_Charge',     
 Orders.OrderDate AS 'Order_Date',    
 --isnull(nullif(dbo.Orders.DeliveryNoteNo,''),dbo.GetDeliveryNoteNo(Orders.OrderID)) AS 'Del_Note_Number',    
 OrderNo + '1'  AS 'Del_Note_Number',    
 -1 AS 'Charge_Qty',    
 'N/A'  AS 'Phone_Number',    
 ISNULL(nullif(Device_API.Dev_IMSINumber,''),'N/A') AS 'IMSI',    
 Isnull(CASE when ICCID like '00500%' THEN SUBSTRING (ICCID,0,12) ELSE nullif(isnull(nullif(datano,''),dbo.Device_API.Data_Number),'') END,'N/A') AS 'Data_Number',    
 ISNULL(Replace(Orderitemdetails.ICCID,'E',''),'N/A') AS 'SIM_Number',    
 ISNULL(nullif(dbo.Device_API.Dev_IP_Address,''),'N/A') AS 'IP_Address',    
 ISNULL(nullif(dbo.OrderItemDetails.GPRSNo,''),'N/A') AS 'Username_Description',    
 InstallerUnqCode AS 'Installer_Code',    
 isnull(InstallerCode,'N.A') AS 'Old_Installer_Code',    
 isnull(Network_Operators.NetworkName,'N/A') AS 'Data_Provider',    
 isnull(Network_Operators.NetworkName,'N/A') AS 'Supplier_Network',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Original_StartDate',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Number_Start_Date',    
 DateAdd(Day, DateDiff(Day, 0, GetDate()), 0) AS 'Product_Start_Dates',    
 CONVERT(VARCHAR(50),ORders.SpecialInstructions) AS 'Order_Special_Inst',    
 CASE WHEN ProductType = 'Ancillary' OR OrderItems.CategoryID = 3  THEN 1   ELSE 0  END AS 'Ancillary',     
 Rep_code = Orders.salesReply ,    
 rep_unit = cast(ISNULL(IsReplacement,0) as bit) ,    
 foc = cast(ISNULL(IsFoc,0) as bit) ,    
 con_stk = cast(CASE WHEN Products.ProductCode in ('CS2100') THEN 1 WHEN Orders.ARC_CODE IN ('11','C1') THEN 1 ELSE ISNULL(OrderItems.IsReplenishment,0) END as bit) ,     
 Swap_Out = cast(0 as bit),     
 OrderItemDetails.OrderItemDetailId,    
 isBillingInserted     
  FROM ORDERS     
 INNER JOIN dbo.OrderItems ON dbo.OrderItems.OrderId = dbo.Orders.OrderId    
 INNER JOIN dbo.OrderItemDetails ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId    
 INNER JOIN dbo.Products ON dbo.Products.ProductId = dbo.OrderItems.ProductId     
 INNER JOIN dbo.DeliveryType ON dbo.DeliveryType.DeliveryTypeId = dbo.Orders.DeliveryTypeId     
 INNER JOIN ARC on ORDERS.ARC_CODE = ARC.ARC_CODE    
 LEFT OUTER JOIN dbo.Device_API ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID    
 LEFT OUTER JOIN dbo.Network_Operators ON OrderItemDetails.ICCID LIKE Network_Operators.ICCIDPrefix + '%'    
 LEFT OUTER JOIN dbo.Eclipse_uniqueCode_mapping on ARC.UniqueCode =Eclipse_uniqueCode_mapping.CSL_UniqueCode AND Products.ProductCode=Eclipse_uniqueCode_mapping.ProductCode    
 WHERE  OrderStatusId IN (20)     
 AND  dbo.OrderItems.IsCSD = 0     
 AND Products.ProductCode not like 'CS2244'     
 AND isBillingInserted = 0     
 AND Orders.Ordertype=1    
    
--M2M CONNECT ORDERS     
 UNION ALL     
    
 SELECT  Orders.OrderID as 'OrderID',OrderStatusId,OrderItemStatusId,    
 InstallerUnqCode AS 'Account_Number' ,     
 isnull(substring(OrderRefNo,1,50),OrderNO) AS 'Order_Number' ,     
 OrderNo AS 'CSL_Unique_Order_Number',    
 Products.ProductCode+ ISNULL(CSLConnectCodePrefix,'') AS 'Package_Code',     
 DeliveryType.DeliveryCode AS 'Delivery_Product_Code',    
 DeliveryType.DeliveryPrice AS 'Delivery_Charge',     
 Orders.OrderDate AS 'Order_Date',    
 OrderNo + '1'  AS 'Del_Note_Number',    
 1 AS 'Charge_Qty',    
 'N/A'  AS 'Phone_Number',    
 ISNULL(nullif(Device_API.Dev_IMSINumber,''),'N/A') AS 'IMSI',    
 Isnull(CASE when ICCID like '00500%' THEN SUBSTRING (ICCID,0,12) ELSE nullif(dbo.Device_API.Data_Number,'') END,'N/A') AS 'Data_Number',    
 ISNULL(Replace(Orderitemdetails.ICCID,'E',''),'N/A') AS 'SIM_Number',    
 ISNULL(nullif(dbo.Device_API.Dev_IP_Address,''),'N/A') AS 'IP_Address',    
 ISNULL(nullif(dbo.OrderItemDetails.GPRSNo,''),'N/A') AS 'Username_Description',    
 InstallerUnqCode AS 'Installer_Code',    
 isnull(InstallerCode,'N.A') AS 'Old_Installer_Code',    
 isnull(Network_Operators.NetworkName,'N/A') AS 'Data_Provider',    
 isnull(Network_Operators.NetworkName,'N/A') AS 'Supplier_Network',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Original_StartDate',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Number_Start_Date',    
 DateAdd(Day, DateDiff(Day, 0, GetDate()), 0) AS 'Product_Start_Dates',    
 isnull(CONVERT(VARCHAR(50),ORders.SpecialInstructions),'N/A') AS 'Order_Special_Inst',    
 CASE WHEN ProductType = 'Ancillary' OR OrderItems.CategoryID = 3  THEN 1   ELSE 0  END AS 'Ancillary',     
 Rep_code = 'M2M' ,    
 rep_unit = cast(ISNULL(IsReplacement,0) as bit) ,    
 foc = cast(ISNULL(IsFoc,0) as bit) ,    
 con_stk = cast(CASE WHEN Products.ProductCode in ('CS2100') THEN 1 ELSE ISNULL(OrderItems.IsReplenishment,0) END as bit) ,     
 Swap_Out = cast(0 as bit),     
 OrderItemDetails.OrderItemDetailId,    
 isBillingInserted     
  FROM ORDERS     
 INNER JOIN dbo.OrderItems ON dbo.OrderItems.OrderId = dbo.Orders.OrderId    
 INNER JOIN dbo.OrderItemDetails ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId    
 INNER JOIN dbo.Products ON dbo.Products.ProductId = dbo.OrderItems.ProductId     
 INNER JOIN dbo.DeliveryType ON dbo.DeliveryType.DeliveryTypeId = dbo.Orders.DeliveryTypeId     
 INNER JOIN ARC on ORDERS.ARC_CODE = ARC.ARC_CODE    
 LEFT OUTER JOIN dbo.Device_API ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID    
 LEFT OUTER JOIN dbo.Network_Operators ON OrderItemDetails.ICCID LIKE Network_Operators.ICCIDPrefix + '%'    
 LEFT OUTER JOIN dbo.Eclipse_uniqueCode_mapping on ARC.UniqueCode =Eclipse_uniqueCode_mapping.CSL_UniqueCode AND Products.ProductCode=Eclipse_uniqueCode_mapping.ProductCode    
 WHERE  OrderStatusId  IN (10)     
 AND OrderItemStatusId NOT IN (13)     
 AND  dbo.OrderItems.IsCSD = 0     
 AND Products.ProductCode not like 'CS2244'     
 AND isBillingInserted = 0    
 AND Not Exists (Select [vw_OrderDataFull].OrderID FROM [vw_OrderDataFull] WHERE [vw_OrderDataFull].OrderID = Orders.OrderID AND isBOSInserted = 0 AND vw_OrderDataFull.ProductType ='Product' AND categoryID != 5 and OrderitemstatusID != 13  )     
 AND Orders.Ordertype=2    
 AND isnull(BILLINGCYCLEID,0) = 0     
    
UNION ALL -- ** DELETED M2M CONNECT ORDERS    
    
    
 SELECT  Orders.OrderID as 'OrderID',OrderStatusId,OrderItemStatusId,    
 InstallerUnqCode AS 'Account_Number' ,     
 isnull(substring(OrderRefNo,1,50),OrderNO) AS 'Order_Number' ,     
 OrderNo AS 'CSL_Unique_Order_Number',    
 Products.ProductCode + ISNULL(CSLConnectCodePrefix,'') AS 'Package_Code',     
 DeliveryType.DeliveryCode AS 'Delivery_Product_Code',    
 DeliveryType.DeliveryPrice AS 'Delivery_Charge',     
 Orders.OrderDate AS 'Order_Date',    
 OrderNo + '1'  AS 'Del_Note_Number',    
 -1 AS 'Charge_Qty',    
 'N/A'  AS 'Phone_Number',    
 ISNULL(nullif(Device_API.Dev_IMSINumber,''),'N/A') AS 'IMSI',    
 Isnull(CASE when ICCID like '00500%' THEN SUBSTRING (ICCID,0,12) ELSE nullif(dbo.Device_API.Data_Number,'') END,'N/A') AS 'Data_Number',    
 ISNULL(Replace(Orderitemdetails.ICCID,'E',''),'N/A') AS 'SIM_Number',    
 ISNULL(nullif(dbo.Device_API.Dev_IP_Address,''),'N/A') AS 'IP_Address',    
 ISNULL(nullif(dbo.OrderItemDetails.GPRSNo,''),'N/A') AS 'Username_Description',    
 InstallerUnqCode AS 'Installer_Code',    
 isnull(InstallerCode,'N.A') AS 'Old_Installer_Code',    
 isnull(Network_Operators.NetworkName,'N/A') AS 'Data_Provider',    
 isnull(Network_Operators.NetworkName,'N/A') AS 'Supplier_Network',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Original_StartDate',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Number_Start_Date',    
 DateAdd(Day, DateDiff(Day, 0, GetDate()), 0) AS 'Product_Start_Dates',    
 isnull(CONVERT(VARCHAR(50),ORders.SpecialInstructions),'N/A') AS 'Order_Special_Inst',    
 CASE WHEN ProductType = 'Ancillary' OR OrderItems.CategoryID = 3  THEN 1   ELSE 0  END AS 'Ancillary',     
 Rep_code = 'M2M' ,    
 rep_unit = cast(ISNULL(IsReplacement,0) as bit) ,    
 foc = cast(ISNULL(IsFoc,0) as bit) ,    
 con_stk = cast(CASE WHEN Products.ProductCode in ('CS2100') THEN 1 ELSE ISNULL(OrderItems.IsReplenishment,0) END as bit) ,     
 Swap_Out = cast(0 as bit),     
 OrderItemDetails.OrderItemDetailId,    
 isBillingInserted     
  FROM ORDERS     
 INNER JOIN dbo.OrderItems ON dbo.OrderItems.OrderId = dbo.Orders.OrderId    
 INNER JOIN dbo.OrderItemDetails ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId    
 INNER JOIN dbo.Products ON dbo.Products.ProductId = dbo.OrderItems.ProductId     
 INNER JOIN dbo.DeliveryType ON dbo.DeliveryType.DeliveryTypeId = dbo.Orders.DeliveryTypeId     
 INNER JOIN ARC on ORDERS.ARC_CODE = ARC.ARC_CODE    
 LEFT OUTER JOIN dbo.Device_API ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID    
 LEFT OUTER JOIN dbo.Network_Operators ON OrderItemDetails.ICCID LIKE Network_Operators.ICCIDPrefix + '%'    
 LEFT OUTER JOIN dbo.Eclipse_uniqueCode_mapping on ARC.UniqueCode =Eclipse_uniqueCode_mapping.CSL_UniqueCode AND Products.ProductCode=Eclipse_uniqueCode_mapping.ProductCode    
 WHERE  OrderStatusId  IN (20)     
 AND  dbo.OrderItems.IsCSD = 0     
 AND Products.ProductCode not like 'CS2244'     
 AND isBillingInserted = 0    
 AND Not Exists (Select [vw_OrderDataFull].OrderID FROM [vw_OrderDataFull] WHERE   
 [vw_OrderDataFull].OrderID = Orders.OrderID AND isBOSInserted = 0  
  AND vw_OrderDataFull.ProductType ='Product' AND categoryID != 5 and OrderitemstatusID != 13  )     
 AND Orders.Ordertype=2    
 AND isnull(BILLINGCYCLEID,0) = 0    
 )a  left outer join OverideBillingCodes b on a.Account_Number = b.OriginalCode
GO
/****** Object:  View [dbo].[vw_BillingOrdersList]    Script Date: 12/14/2015 17:06:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*CreatedBy - SRI
Purpose - Retrives the order details  for the billing and push to eclipse
ModifiedBy- Shyam
ModifiedOn - 03rd August 2015
Purpose - Overrides the account number for the billing with the ARC unique code from Overide table
RequestedBy - Ravi as per Email Dated (Account numbers M2M orders) Wed 29/07/2015 17:38
*/
      
CREATE VIEW [dbo].[vw_BillingOrdersList]    
AS 
SELECT OrderID,OrderStatusId,OrderItemStatusId
	,CASE 
		WHEN Account_Number = OriginalCode
			THEN OverideCode
		ELSE Account_Number
		END AS Account_Number
	,Order_Number,CSL_Unique_Order_Number,Package_Code,Delivery_Product_Code
	,Delivery_Charge,Order_Date,Del_Note_Number,Charge_Qty,Phone_Number,IMSI
	,Data_Number,SIM_Number,IP_Address,Username_Description,Installer_Code
	,Old_Installer_Code,Data_Provider,Supplier_Network,Original_StartDate
	,Number_Start_Date,Product_Start_Dates,Order_Special_Inst,Ancillary
	,Rep_code,rep_unit,foc,con_stk,Swap_Out,OrderItemDetailId,isBillingInserted
FROM	
(
     
 SELECT  Orders.OrderID as 'OrderID',OrderStatusId,OrderItemStatusId,    
 isnull(Eclipse_uniqueCode_mapping.Eclipse_uniqueCode,ARC.[UNiqueCode]) AS 'Account_Number' ,     
 substring(OrderRefNo,1,50) AS 'Order_Number' ,     
 OrderNo AS 'CSL_Unique_Order_Number',    
 Products.ProductCode AS 'Package_Code',     
 DeliveryType.DeliveryCode AS 'Delivery_Product_Code',    
 DeliveryType.DeliveryPrice AS 'Delivery_Charge',     
 Orders.OrderDate AS 'Order_Date',    
 --isnull(nullif(dbo.Orders.DeliveryNoteNo,''),dbo.GetDeliveryNoteNo(Orders.OrderID)) AS 'Del_Note_Number',    
 OrderNo + '1'  AS 'Del_Note_Number',    
 1 AS 'Charge_Qty',    
 'N/A'  AS 'Phone_Number',    
 ISNULL(nullif(Device_API.Dev_IMSINumber,''),'N/A') AS 'IMSI',    
 Isnull(CASE when ICCID like '00500%' THEN SUBSTRING (ICCID,0,12) ELSE nullif(dbo.Device_API.Data_Number,'') END,'N/A') AS 'Data_Number',    
 ISNULL(Replace(Orderitemdetails.ICCID,'E',''),'N/A') AS 'SIM_Number',    
 ISNULL(nullif(dbo.Device_API.Dev_IP_Address,''),'N/A') AS 'IP_Address',    
 ISNULL(nullif(dbo.OrderItemDetails.GPRSNo,''),'N/A') AS 'Username_Description',    
 InstallerUnqCode AS 'Installer_Code',    
 isnull(InstallerCode,'N.A') AS 'Old_Installer_Code',    
 isnull(Network_Operators.NetworkName,'N/A') AS 'Data_Provider',    
 isnull(Network_Operators.NetworkName,'N/A') AS 'Supplier_Network',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Original_StartDate',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Number_Start_Date',    
 DateAdd(Day, DateDiff(Day, 0, GetDate()), 0) AS 'Product_Start_Dates',    
 CONVERT(VARCHAR(50),ORders.SpecialInstructions) AS 'Order_Special_Inst',    
 CASE WHEN ProductType = 'Ancillary' OR OrderItems.CategoryID = 3  THEN 1   ELSE 0  END AS 'Ancillary',     
 Rep_code = Orders.salesReply ,    
 rep_unit = cast(ISNULL(IsReplacement,0) as bit) ,    
 foc = cast(ISNULL(IsFoc,0) as bit) ,    
 con_stk = cast(CASE WHEN Products.ProductCode in ('CS2100') THEN 1 WHEN Orders.ARC_CODE IN ('11','C1') THEN 1 ELSE ISNULL(OrderItems.IsReplenishment,0) END as bit) ,     
 Swap_Out = cast(0 as bit),     
 OrderItemDetails.OrderItemDetailId,    
 isBillingInserted     
  FROM ORDERS     
 INNER JOIN dbo.OrderItems ON dbo.OrderItems.OrderId = dbo.Orders.OrderId    
 INNER JOIN dbo.OrderItemDetails ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId    
 INNER JOIN dbo.Products ON dbo.Products.ProductId = dbo.OrderItems.ProductId     
 INNER JOIN dbo.DeliveryType ON dbo.DeliveryType.DeliveryTypeId = dbo.Orders.DeliveryTypeId     
 INNER JOIN ARC on ORDERS.ARC_CODE = ARC.ARC_CODE    
 LEFT OUTER JOIN dbo.Device_API ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID    
 LEFT OUTER JOIN dbo.Network_Operators ON OrderItemDetails.ICCID LIKE Network_Operators.ICCIDPrefix + '%'    
 LEFT OUTER JOIN dbo.Eclipse_uniqueCode_mapping on ARC.UniqueCode =Eclipse_uniqueCode_mapping.CSL_UniqueCode AND Products.ProductCode=Eclipse_uniqueCode_mapping.ProductCode    
 WHERE  OrderStatusId IN (10)     
 AND OrderItemStatusId NOT IN (13)     
 AND  dbo.OrderItems.IsCSD = 0     
 AND Products.ProductCode not like 'CS2244'     
 --AND Orders.ProcessedOn >='01 Feb 2014'     
 --AND Orders.Orderdate <'24 Feb 2014'     
 AND isBillingInserted = 0     
 AND Not Exists (Select [vw_OrderDataFull].OrderID FROM [vw_OrderDataFull] WHERE [vw_OrderDataFull].OrderID = Orders.OrderID AND isBOSInserted = 0 AND vw_OrderDataFull.ProductType ='Product' AND categoryID != 5 and OrderitemstatusID != 13  )     
 AND nullif(Orders.salesReply,'') is not null     
 and nullif(Orders.ARC_CODE,'') is not null AND Orders.ARC_CODE != 'OO' -- Replacement_ARC    
 AND Orders.Ordertype=1    
    
UNION ALL  -- ** SWAPPED OUT ITEMS WITH -ve qty     
    
 SELECT  Orders.OrderID as 'OrderID', OrderStatusId,OrderItemStatusId,    
 isnull(Eclipse_uniqueCode_mapping.Eclipse_uniqueCode,ARC.[UNiqueCode]) AS 'Account_Number' ,     
 substring(OrderRefNo,1,50) AS 'Order_Number' ,     
 OrderNo AS 'CSL_Unique_Order_Number',    
 Products.ProductCode AS 'Package_Code',     
 DeliveryType.DeliveryCode AS 'Delivery_Product_Code',    
 DeliveryType.DeliveryPrice AS 'Delivery_Charge',     
 Orders.OrderDate AS 'Order_Date',    
 OrderNo + '1'  AS 'Del_Note_Number',    
 -1 AS 'Charge_Qty',    
 'N/A'  AS 'Phone_Number',    
 'N/A' AS 'IMSI',    
 'N/A' AS 'Data_Number',    
 'N/A' AS 'SIM_Number',    
 'N/A'AS 'IP_Address',    
 'N/A' AS 'Username_Description',    
 InstallerUnqCode AS 'Installer_Code',    
 isnull(InstallerCode,'N.A') AS 'Old_Installer_Code',    
 'N/A' AS 'Data_Provider',    
 'N/A' AS 'Supplier_Network',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Original_StartDate',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Number_Start_Date',    
 DateAdd(Day, DateDiff(Day, 0, GetDate()), 0) AS 'Product_Start_Dates',    
 CONVERT(VARCHAR(50),ORders.SpecialInstructions) AS 'Order_Special_Inst',    
 CASE WHEN ProductType = 'Ancillary' OR OrderItems.CategoryID = 3  THEN 1   ELSE 0  END AS 'Ancillary',     
 Rep_code = Orders.salesReply ,    
 rep_unit = cast(ISNULL(IsReplacement,0) as bit) ,    
 foc = cast(ISNULL(IsFoc,0) as bit) ,    
 con_stk = cast(CASE WHEN Products.ProductCode in ('CS2100') THEN 1 WHEN Orders.ARC_CODE IN ('11','C1') THEN 1 ELSE ISNULL(OrderItems.IsReplenishment,0) END as bit) ,     
 Swap_Out = cast(1 as bit),     
 cast(OrderItemDetails.OrderItemDetailId as varchar(10)) + cast(swapoutID as varchar(10))  AS OrderItemDetailId ,    
 isBillingInserted     
 FROM ORDERS     
 INNER JOIN dbo.OrderItems ON dbo.OrderItems.OrderId = dbo.Orders.OrderId    
 INNER JOIN dbo.OrderItemDetails ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId    
 INNER JOIN SWAPOUT on OrderItems.OrderItemId = SWAPOUT.OrderItemId    
 INNER JOIN dbo.Products ON dbo.Products.ProductId = dbo.SWAPOUT.BundleProductId     
 INNER JOIN dbo.DeliveryType ON dbo.DeliveryType.DeliveryTypeId = dbo.Orders.DeliveryTypeId     
 INNER JOIN ARC on ORDERS.ARC_CODE = ARC.ARC_CODE    
 LEFT OUTER JOIN dbo.Device_API ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID    
 LEFT OUTER JOIN dbo.Network_Operators ON OrderItemDetails.ICCID LIKE Network_Operators.ICCIDPrefix + '%'    
 LEFT OUTER JOIN dbo.Eclipse_uniqueCode_mapping on ARC.UniqueCode =Eclipse_uniqueCode_mapping.CSL_UniqueCode AND Products.ProductCode=Eclipse_uniqueCode_mapping.ProductCode    
 WHERE  OrderStatusId IN (10)     
 AND OrderItemStatusId NOT IN (13)     
 AND  dbo.OrderItems.IsCSD = 0     
 AND Products.ProductCode not like 'CS2244'     
 AND isBillingInserted = 0     
 AND Not Exists (Select [vw_OrderDataFull].OrderID FROM [vw_OrderDataFull] WHERE [vw_OrderDataFull].OrderID = Orders.OrderID AND isBOSInserted = 0 AND vw_OrderDataFull.ProductType ='Product' AND categoryID != 5 and OrderitemstatusID != 13  )     
 AND nullif(Orders.salesReply,'') is not null     
 and nullif(Orders.ARC_CODE,'') is not null AND Orders.ARC_CODE != 'OO' -- Replacement_ARC    
 AND Orders.Ordertype=1    
    
UNION ALL -- SWAP OUT ITEMS WITH +ve     
    
 SELECT  Orders.OrderID as 'OrderID',OrderStatusId,OrderItemStatusId,    
 isnull(Eclipse_uniqueCode_mapping.Eclipse_uniqueCode,ARC.[UNiqueCode]) AS 'Account_Number' ,      
 substring(OrderRefNo,1,50) AS 'Order_Number' ,     
 OrderNo AS 'CSL_Unique_Order_Number',    
 Products.ProductCode AS 'Package_Code',     
 DeliveryType.DeliveryCode AS 'Delivery_Product_Code',    
 DeliveryType.DeliveryPrice AS 'Delivery_Charge',     
 Orders.OrderDate AS 'Order_Date',    
 OrderNo + '1'  AS 'Del_Note_Number',    
 1 AS 'Charge_Qty',    
 'N/A'  AS 'Phone_Number',    
 'N/A' AS 'IMSI',    
 'N/A' AS 'Data_Number',    
 'N/A' AS 'SIM_Number',    
 'N/A'AS 'IP_Address',    
 'N/A' AS 'Username_Description',    
 InstallerUnqCode AS 'Installer_Code',    
 isnull(InstallerCode,'N.A') AS 'Old_Installer_Code',    
 'N/A' AS 'Data_Provider',    
 'N/A' AS 'Supplier_Network',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Original_StartDate',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Number_Start_Date',    
 DateAdd(Day, DateDiff(Day, 0, GetDate()), 0) AS 'Product_Start_Dates',    
 CONVERT(VARCHAR(50),ORders.SpecialInstructions) AS 'Order_Special_Inst',    
 CASE WHEN ProductType = 'Ancillary' OR OrderItems.CategoryID = 3  THEN 1   ELSE 0  END AS 'Ancillary',     
 Rep_code = Orders.salesReply ,    
 rep_unit = cast(ISNULL(IsReplacement,0) as bit) ,    
 foc = cast(ISNULL(IsFoc,0) as bit) ,    
 con_stk = cast(CASE WHEN Products.ProductCode in ('CS2100') THEN 1 WHEN Orders.ARC_CODE IN ('11','C1') THEN 1 ELSE ISNULL(OrderItems.IsReplenishment,0) END as bit) ,     
 Swap_Out = cast(1 as bit),     
 cast(OrderItemDetails.OrderItemDetailId as varchar(10)) + cast(swapoutID as varchar(10)) AS OrderItemDetailId , -- + + '00'  altered as range out of int  
 isBillingInserted     
 FROM ORDERS     
 INNER JOIN dbo.OrderItems ON dbo.OrderItems.OrderId = dbo.Orders.OrderId    
 INNER JOIN dbo.OrderItemDetails ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId    
 INNER JOIN SWAPOUT on OrderItems.OrderItemId = SWAPOUT.OrderItemId    
 INNER JOIN dbo.Products ON dbo.Products.ProductId = dbo.SWAPOUT.SwapWithProductId     
 INNER JOIN dbo.DeliveryType ON dbo.DeliveryType.DeliveryTypeId = dbo.Orders.DeliveryTypeId     
 INNER JOIN ARC on ORDERS.ARC_CODE = ARC.ARC_CODE    
 LEFT OUTER JOIN dbo.Device_API ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID    
 LEFT OUTER JOIN dbo.Network_Operators ON OrderItemDetails.ICCID LIKE Network_Operators.ICCIDPrefix + '%'    
 LEFT OUTER JOIN dbo.Eclipse_uniqueCode_mapping on ARC.UniqueCode =Eclipse_uniqueCode_mapping.CSL_UniqueCode AND Products.ProductCode=Eclipse_uniqueCode_mapping.ProductCode    
 WHERE  OrderStatusId IN (10)     
 AND OrderItemStatusId NOT IN (13)     
 AND  dbo.OrderItems.IsCSD = 0     
 AND Products.ProductCode not like 'CS2244'     
 --AND Orders.ProcessedOn >='01 Feb 2014'     
 --AND Orders.Orderdate <'24 Feb 2014'     
 AND isBillingInserted = 0     
 AND Not Exists (Select [vw_OrderDataFull].OrderID FROM [vw_OrderDataFull] WHERE [vw_OrderDataFull].OrderID = Orders.OrderID AND isBOSInserted = 0 AND vw_OrderDataFull.ProductType ='Product' AND categoryID != 5 and OrderitemstatusID != 13  )     
 AND nullif(Orders.salesReply,'') is not null     
 and nullif(Orders.ARC_CODE,'') is not null AND Orders.ARC_CODE != 'OO' -- Replacement_ARC    
 AND Orders.Ordertype=1    
    
UNION ALL -- Deleted Items     
    
SELECT  Orders.OrderID as 'OrderID',OrderStatusId,OrderItemStatusId,    
 isnull(Eclipse_uniqueCode_mapping.Eclipse_uniqueCode,ARC.[UNiqueCode]) AS 'Account_Number' ,     
 substring(OrderRefNo,1,50) AS 'Order_Number' ,     
 OrderNo AS 'CSL_Unique_Order_Number',    
 Products.ProductCode AS 'Package_Code',     
 DeliveryType.DeliveryCode AS 'Delivery_Product_Code',    
 DeliveryType.DeliveryPrice AS 'Delivery_Charge',     
 Orders.OrderDate AS 'Order_Date',    
 --isnull(nullif(dbo.Orders.DeliveryNoteNo,''),dbo.GetDeliveryNoteNo(Orders.OrderID)) AS 'Del_Note_Number',    
 OrderNo + '1'  AS 'Del_Note_Number',    
 -1 AS 'Charge_Qty',    
 'N/A'  AS 'Phone_Number',    
 ISNULL(nullif(Device_API.Dev_IMSINumber,''),'N/A') AS 'IMSI',    
 Isnull(CASE when ICCID like '00500%' THEN SUBSTRING (ICCID,0,12) ELSE nullif(isnull(nullif(datano,''),dbo.Device_API.Data_Number),'') END,'N/A') AS 'Data_Number',    
 ISNULL(Replace(Orderitemdetails.ICCID,'E',''),'N/A') AS 'SIM_Number',    
 ISNULL(nullif(dbo.Device_API.Dev_IP_Address,''),'N/A') AS 'IP_Address',    
 ISNULL(nullif(dbo.OrderItemDetails.GPRSNo,''),'N/A') AS 'Username_Description',    
 InstallerUnqCode AS 'Installer_Code',    
 isnull(InstallerCode,'N.A') AS 'Old_Installer_Code',    
 isnull(Network_Operators.NetworkName,'N/A') AS 'Data_Provider',    
 isnull(Network_Operators.NetworkName,'N/A') AS 'Supplier_Network',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Original_StartDate',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Number_Start_Date',    
 DateAdd(Day, DateDiff(Day, 0, GetDate()), 0) AS 'Product_Start_Dates',    
 CONVERT(VARCHAR(50),ORders.SpecialInstructions) AS 'Order_Special_Inst',    
 CASE WHEN ProductType = 'Ancillary' OR OrderItems.CategoryID = 3  THEN 1   ELSE 0  END AS 'Ancillary',     
 Rep_code = Orders.salesReply ,    
 rep_unit = cast(ISNULL(IsReplacement,0) as bit) ,    
 foc = cast(ISNULL(IsFoc,0) as bit) ,    
 con_stk = cast(CASE WHEN Products.ProductCode in ('CS2100') THEN 1 WHEN Orders.ARC_CODE IN ('11','C1') THEN 1 ELSE ISNULL(OrderItems.IsReplenishment,0) END as bit) ,     
 Swap_Out = cast(0 as bit),     
 OrderItemDetails.OrderItemDetailId,    
 isBillingInserted     
  FROM ORDERS     
 INNER JOIN dbo.OrderItems ON dbo.OrderItems.OrderId = dbo.Orders.OrderId    
 INNER JOIN dbo.OrderItemDetails ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId    
 INNER JOIN dbo.Products ON dbo.Products.ProductId = dbo.OrderItems.ProductId     
 INNER JOIN dbo.DeliveryType ON dbo.DeliveryType.DeliveryTypeId = dbo.Orders.DeliveryTypeId     
 INNER JOIN ARC on ORDERS.ARC_CODE = ARC.ARC_CODE    
 LEFT OUTER JOIN dbo.Device_API ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID    
 LEFT OUTER JOIN dbo.Network_Operators ON OrderItemDetails.ICCID LIKE Network_Operators.ICCIDPrefix + '%'    
 LEFT OUTER JOIN dbo.Eclipse_uniqueCode_mapping on ARC.UniqueCode =Eclipse_uniqueCode_mapping.CSL_UniqueCode AND Products.ProductCode=Eclipse_uniqueCode_mapping.ProductCode    
 WHERE  OrderStatusId IN (20)     
 AND  dbo.OrderItems.IsCSD = 0     
 AND Products.ProductCode not like 'CS2244'     
 AND isBillingInserted = 0     
 AND Orders.Ordertype=1    
    
--M2M CONNECT ORDERS     
 UNION ALL     
    
 SELECT  Orders.OrderID as 'OrderID',OrderStatusId,OrderItemStatusId,    
 InstallerUnqCode AS 'Account_Number' ,     
 isnull(substring(OrderRefNo,1,50),OrderNO) AS 'Order_Number' ,     
 OrderNo AS 'CSL_Unique_Order_Number',    
 Products.ProductCode+ ISNULL(CSLConnectCodePrefix,'') AS 'Package_Code',     
 DeliveryType.DeliveryCode AS 'Delivery_Product_Code',    
 DeliveryType.DeliveryPrice AS 'Delivery_Charge',     
 Orders.OrderDate AS 'Order_Date',    
 OrderNo + '1'  AS 'Del_Note_Number',    
 1 AS 'Charge_Qty',    
 'N/A'  AS 'Phone_Number',    
 ISNULL(nullif(Device_API.Dev_IMSINumber,''),'N/A') AS 'IMSI',    
 Isnull(CASE when ICCID like '00500%' THEN SUBSTRING (ICCID,0,12) ELSE nullif(dbo.Device_API.Data_Number,'') END,'N/A') AS 'Data_Number',    
 ISNULL(Replace(Orderitemdetails.ICCID,'E',''),'N/A') AS 'SIM_Number',    
 ISNULL(nullif(dbo.Device_API.Dev_IP_Address,''),'N/A') AS 'IP_Address',    
 ISNULL(nullif(dbo.OrderItemDetails.GPRSNo,''),'N/A') AS 'Username_Description',    
 InstallerUnqCode AS 'Installer_Code',    
 isnull(InstallerCode,'N.A') AS 'Old_Installer_Code',    
 isnull(Network_Operators.NetworkName,'N/A') AS 'Data_Provider',    
 isnull(Network_Operators.NetworkName,'N/A') AS 'Supplier_Network',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Original_StartDate',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Number_Start_Date',    
 DateAdd(Day, DateDiff(Day, 0, GetDate()), 0) AS 'Product_Start_Dates',    
 isnull(CONVERT(VARCHAR(50),ORders.SpecialInstructions),'N/A') AS 'Order_Special_Inst',    
 CASE WHEN ProductType = 'Ancillary' OR OrderItems.CategoryID = 3  THEN 1   ELSE 0  END AS 'Ancillary',     
 Rep_code = 'M2M' ,    
 rep_unit = cast(ISNULL(IsReplacement,0) as bit) ,    
 foc = cast(ISNULL(IsFoc,0) as bit) ,    
 con_stk = cast(CASE WHEN Products.ProductCode in ('CS2100') THEN 1 ELSE ISNULL(OrderItems.IsReplenishment,0) END as bit) ,     
 Swap_Out = cast(0 as bit),     
 OrderItemDetails.OrderItemDetailId,    
 isBillingInserted     
  FROM ORDERS     
 INNER JOIN dbo.OrderItems ON dbo.OrderItems.OrderId = dbo.Orders.OrderId    
 INNER JOIN dbo.OrderItemDetails ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId    
 INNER JOIN dbo.Products ON dbo.Products.ProductId = dbo.OrderItems.ProductId     
 INNER JOIN dbo.DeliveryType ON dbo.DeliveryType.DeliveryTypeId = dbo.Orders.DeliveryTypeId     
 INNER JOIN ARC on ORDERS.ARC_CODE = ARC.ARC_CODE    
 LEFT OUTER JOIN dbo.Device_API ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID    
 LEFT OUTER JOIN dbo.Network_Operators ON OrderItemDetails.ICCID LIKE Network_Operators.ICCIDPrefix + '%'    
 LEFT OUTER JOIN dbo.Eclipse_uniqueCode_mapping on ARC.UniqueCode =Eclipse_uniqueCode_mapping.CSL_UniqueCode AND Products.ProductCode=Eclipse_uniqueCode_mapping.ProductCode    
 WHERE  OrderStatusId  IN (10)     
 AND OrderItemStatusId NOT IN (13)     
 AND  dbo.OrderItems.IsCSD = 0     
 AND Products.ProductCode not like 'CS2244'     
 AND isBillingInserted = 0    
 AND Not Exists (Select [vw_OrderDataFull].OrderID FROM [vw_OrderDataFull] WHERE [vw_OrderDataFull].OrderID = Orders.OrderID AND isBOSInserted = 0 AND vw_OrderDataFull.ProductType ='Product' AND categoryID != 5 and OrderitemstatusID != 13  )     
 AND Orders.Ordertype=2    
 AND isnull(BILLINGCYCLEID,0) = 0     
    
UNION ALL -- ** DELETED M2M CONNECT ORDERS    
    
    
 SELECT  Orders.OrderID as 'OrderID',OrderStatusId,OrderItemStatusId,    
 InstallerUnqCode AS 'Account_Number' ,     
 isnull(substring(OrderRefNo,1,50),OrderNO) AS 'Order_Number' ,     
 OrderNo AS 'CSL_Unique_Order_Number',    
 Products.ProductCode + ISNULL(CSLConnectCodePrefix,'') AS 'Package_Code',     
 DeliveryType.DeliveryCode AS 'Delivery_Product_Code',    
 DeliveryType.DeliveryPrice AS 'Delivery_Charge',     
 Orders.OrderDate AS 'Order_Date',    
 OrderNo + '1'  AS 'Del_Note_Number',    
 -1 AS 'Charge_Qty',    
 'N/A'  AS 'Phone_Number',    
 ISNULL(nullif(Device_API.Dev_IMSINumber,''),'N/A') AS 'IMSI',    
 Isnull(CASE when ICCID like '00500%' THEN SUBSTRING (ICCID,0,12) ELSE nullif(dbo.Device_API.Data_Number,'') END,'N/A') AS 'Data_Number',    
 ISNULL(Replace(Orderitemdetails.ICCID,'E',''),'N/A') AS 'SIM_Number',    
 ISNULL(nullif(dbo.Device_API.Dev_IP_Address,''),'N/A') AS 'IP_Address',    
 ISNULL(nullif(dbo.OrderItemDetails.GPRSNo,''),'N/A') AS 'Username_Description',    
 InstallerUnqCode AS 'Installer_Code',    
 isnull(InstallerCode,'N.A') AS 'Old_Installer_Code',    
 isnull(Network_Operators.NetworkName,'N/A') AS 'Data_Provider',    
 isnull(Network_Operators.NetworkName,'N/A') AS 'Supplier_Network',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Original_StartDate',    
 DateAdd(Day, DateDiff(Day, 0, Orders.ProcessedOn), 0) AS 'Number_Start_Date',    
 DateAdd(Day, DateDiff(Day, 0, GetDate()), 0) AS 'Product_Start_Dates',    
 isnull(CONVERT(VARCHAR(50),ORders.SpecialInstructions),'N/A') AS 'Order_Special_Inst',    
 CASE WHEN ProductType = 'Ancillary' OR OrderItems.CategoryID = 3  THEN 1   ELSE 0  END AS 'Ancillary',     
 Rep_code = 'M2M' ,    
 rep_unit = cast(ISNULL(IsReplacement,0) as bit) ,    
 foc = cast(ISNULL(IsFoc,0) as bit) ,    
 con_stk = cast(CASE WHEN Products.ProductCode in ('CS2100') THEN 1 ELSE ISNULL(OrderItems.IsReplenishment,0) END as bit) ,     
 Swap_Out = cast(0 as bit),     
 OrderItemDetails.OrderItemDetailId,    
 isBillingInserted     
  FROM ORDERS     
 INNER JOIN dbo.OrderItems ON dbo.OrderItems.OrderId = dbo.Orders.OrderId    
 INNER JOIN dbo.OrderItemDetails ON dbo.OrderItemDetails.OrderItemId = dbo.OrderItems.OrderItemId    
 INNER JOIN dbo.Products ON dbo.Products.ProductId = dbo.OrderItems.ProductId     
 INNER JOIN dbo.DeliveryType ON dbo.DeliveryType.DeliveryTypeId = dbo.Orders.DeliveryTypeId     
 INNER JOIN ARC on ORDERS.ARC_CODE = ARC.ARC_CODE    
 LEFT OUTER JOIN dbo.Device_API ON dbo.Device_API.Dev_Code = dbo.OrderItemDetails.ICCID    
 LEFT OUTER JOIN dbo.Network_Operators ON OrderItemDetails.ICCID LIKE Network_Operators.ICCIDPrefix + '%'    
 LEFT OUTER JOIN dbo.Eclipse_uniqueCode_mapping on ARC.UniqueCode =Eclipse_uniqueCode_mapping.CSL_UniqueCode AND Products.ProductCode=Eclipse_uniqueCode_mapping.ProductCode    
 WHERE  OrderStatusId  IN (20)     
 AND  dbo.OrderItems.IsCSD = 0     
 AND Products.ProductCode not like 'CS2244'     
 AND isBillingInserted = 0    
 AND Not Exists (Select [vw_OrderDataFull].OrderID FROM [vw_OrderDataFull] WHERE   
 [vw_OrderDataFull].OrderID = Orders.OrderID AND isBOSInserted = 0  
  AND vw_OrderDataFull.ProductType ='Product' AND categoryID != 5 and OrderitemstatusID != 13  )     
 AND Orders.Ordertype=2    
 AND isnull(BILLINGCYCLEID,0) = 0      
 )a  LEFT OUTER JOIN OverideBillingCodes b on a.Account_Number = b.OriginalCode
GO
/****** Object:  StoredProcedure [dbo].[USP_UploadOrderProduct]    Script Date: 12/14/2015 17:06:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_UploadOrderProduct]      
(      
 @ProductCode NVarchar(20),      
 @GPRSChipNo NVarchar(50),      
 @GPRSNoPostCode NVarchar(50),      
 @ARC_Id int,      
 @OrderId int,      
 @IsARC_AllowReturns bit,      
 @UserId NVarchar(256) ,  
 @PSTNNo NVARCHAR(50)='',  
 @OptionId INT=0,
 @IsCSD BIT=0,
 @IsReplenishment BIT =0,
 @SiteName VARCHAR(256)=''     
)      
AS      
BEGIN TRY       
BEGIN      
 Declare @ProductId int      
 Declare @CategoryId int      
 Declare @IsGPRSChipEmpty bit      
 Declare @ProductPrice Decimal(6,2)      
 Declare @OrderItemDetailId int      
 Declare @OrderItemId int      
 Declare @DependentProductId int      
 Declare @DependentProductPrice Decimal(6,2)      
 Declare @DependentProductPriceTotal Decimal(6,2)      
 Declare @DependentOrderItemId int      
 DECLARE @GetDependentProducts CURSOR      
      
 Select @ProductId = ProductId From Products Where ProductCode = @ProductCode And IsDeleted = 0      
 Set @DependentProductPriceTotal = 0      
       
 DECLARE @Result NVarchar(256)      
 DECLARE @IsAnyDuplicate bit      
 Set @Result = 'Error - some logic is missing.'      
 Set @IsAnyDuplicate = 0      
      
 IF @ProductId IS NULL      
  BEGIN      
   Set @Result = 'Product does not exist in the System.'      
  END      
 ELSE IF Not Exists (Select Product_ARC_MapId From Product_ARC_Map Where ProductId = @ProductId AND ARCId = @ARC_Id)      
  BEGIN      
   Set @Result = 'ARC not allowed to order this product.'      
  END      
 ELSE      
  BEGIN      
   Select Top 1 @CategoryId = cpm.CategoryId, @IsGPRSChipEmpty = cat.IsGPRSChipEmpty       
   From       
   Category_Product_Map cpm      
   Inner Join       
   Category cat on cat.CategoryId = cpm.CategoryId AND cpm.ProductId = @ProductId      
   Order by IsGPRSChipEmpty      
      
   IF @IsGPRSChipEmpty = 0 AND @GPRSChipNo = ''      
    BEGIN      
     Set @Result = 'Empty Chip Number is not allowed'      
    END      
   ELSE      
    BEGIN      
     SET @ProductPrice = (Select case IsNull(t.ARC_Price,0) when 0 then t.Price else t.ARC_Price end as Price      
           from      
           (Select p.ProductId, p.Price, ppm.Price as ARC_Price      
           from       
           Products p           
           left join      
           ARC_Product_Price_Map ppm on ppm.ProductId = p.ProductId and DATEDIFF(d,isnull(ppm.ExpiryDate,getdate()),GETDATE())>0 And ppm.IsDeleted=0       
           Where p.IsDependentProduct = 0 And p.IsDeleted=0 And p.ProductId = @ProductId      
          ) t )      
                
     IF  @ProductPrice IS Null       
      BEGIN      
       SET @ProductPrice = 0      
      END          
      
     Select @OrderItemId = OrderItemId From OrderItems Where OrderId = @OrderId And ProductId = @ProductId And CategoryId = @CategoryId      
     IF @OrderItemId Is Null      
      BEGIN      
       Insert Into OrderItems (OrderId, ProductId, ProductQty, Price, OrderItemStatusId, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy, CategoryId,IsReplenishment,IsCSD)      
           Values(@OrderId, @ProductId, 1, @ProductPrice, 1, GETDATE(), @UserId, GETDATE(), @UserId, @CategoryId,@IsReplenishment,@IsCSD)      
             
       Select @OrderItemId = SCOPE_IDENTITY()      
                 
       SET @GetDependentProducts = CURSOR FOR      
       SELECT t.ProductId, CASE IsNull(t.ARC_Price,0) WHEN 0 THEN t.Price ELSE t.ARC_Price END AS Price      
        FROM      
        (SELECT p.ProductId, p.Price, ppm.Price AS ARC_Price      
         FROM Products p      
         left join      
         ARC_Product_Price_Map ppm ON ppm.ProductId = p.ProductId and DATEDIFF(d,isnull(ppm.ExpiryDate,getdate()),GETDATE())>0 And ppm.IsDeleted=0      
         WHERE p.IsDeleted=0 and p.ProductId in      
          (SELECT pdm.DependentProductId FROM Product_Dependent_Map pdm WHERE pdm.ProductId = @ProductId)      
        ) t      
      
       OPEN @GetDependentProducts      
            
 FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice      
       WHILE @@FETCH_STATUS = 0      
        BEGIN       
         SET @DependentProductPriceTotal = @DependentProductPriceTotal + @DependentProductPrice      
                  
         INSERT INTO OrderDependentItems (OrderId, OrderItemId, ProductId, ProductQty, Price)      
              VALUES(@OrderId, @OrderItemId, @DependentProductId, 1, @DependentProductPrice)      
         FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice       
        END      
      
       CLOSE @GetDependentProducts      
       DEALLOCATE @GetDependentProducts      
             
       Update Orders Set OrderDate = GETDATE()      
            , Amount = Amount + @ProductPrice + @DependentProductPriceTotal      
            , ModifiedOn = GETDATE()      
            , ModifiedBy = @UserId      
           Where OrderId = @OrderId      
             
       Insert into OrderItemDetails(OrderItemId, GPRSNo, ModifiedOn, ModifiedBy, GPRSNoPostCode,PSTNNo,OptionId,SiteName)      
            Values (@OrderItemId, @GPRSChipNo, GETDATE(), @UserId, @GPRSNoPostCode,@PSTNNo,@OptionId,@SiteName)      
             
       Set @Result = 'Success'      
      END      
     ELSE      
      BEGIN      
       IF @IsARC_AllowReturns = 1      
        BEGIN      
         IF @GPRSChipNo != '' And Exists (Select OrderItemDetailId From vw_OrderDataWithDetails Where GPRSNo = @GPRSChipNo and ARCId = @ARC_Id)        
          BEGIN      
           Set @IsAnyDuplicate = 1      
          END      
                
           Insert into OrderItemDetails(OrderItemId, GPRSNo, ModifiedOn, ModifiedBy, GPRSNoPostCode,PSTNNo,OptionId,SiteName)      
                Values (@OrderItemId, @GPRSChipNo, GETDATE(), @UserId, @GPRSNoPostCode,@PSTNNo,@OptionId,@SiteName)      
               
           Select @OrderItemDetailId = SCOPE_IDENTITY()      
                 
           Update OrderItems      
            Set ProductQty = ProductQty + 1,      
             Price = @ProductPrice,      
             ModifiedOn = GETDATE(),      
             ModifiedBy = @UserId,      
             CategoryId = @CategoryId      
            Where       
             OrderId = @OrderId       
             And ProductId = @ProductId       
             And CategoryId = @CategoryId      
                   
                 
           SET @GetDependentProducts = CURSOR FOR      
           SELECT t.ProductId, CASE IsNull(t.ARC_Price,0) WHEN 0 THEN t.Price ELSE t.ARC_Price END AS Price      
            FROM      
            (SELECT p.ProductId, p.Price, ppm.Price AS ARC_Price      
             FROM Products p      
             left join      
             ARC_Product_Price_Map ppm ON ppm.ProductId = p.ProductId and DATEDIFF(d,isnull(ppm.ExpiryDate,getdate()),GETDATE())>0 And ppm.IsDeleted=0      
             WHERE p.IsDeleted=0 and p.ProductId in      
              (SELECT pdm.DependentProductId FROM Product_Dependent_Map pdm WHERE pdm.ProductId = @ProductId)      
            ) t      
      
           OPEN @GetDependentProducts      
                
           FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice      
           WHILE @@FETCH_STATUS = 0      
            BEGIN       
             SET @DependentProductPriceTotal = @DependentProductPriceTotal + @DependentProductPrice      
                   
             IF Exists (Select OrderDependentId From OrderDependentItems Where OrderId = @OrderId And ProductId = @DependentProductId)      
              BEGIN      
               Update OrderDependentItems      
                Set ProductQty = ProductQty + 1      
                 , Price = @DependentProductPrice      
                Where OrderId = @OrderId      
                  And ProductId = @DependentProductId      
              END      
             ELSE      
              BEGIN 
               Insert Into OrderDependentItems (OrderId, OrderItemId, ProductId, ProductQty, Price)      
                      VALUES(@OrderId, @OrderItemId, @DependentProductId, 1, @DependentProductPrice)      
              END      
             FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice       
          END      
      
           CLOSE @GetDependentProducts      
           DEALLOCATE @GetDependentProducts      
             
           Update Orders Set OrderDate = GETDATE()      
                , Amount = Amount + @ProductPrice + @DependentProductPriceTotal      
                , ModifiedOn = GETDATE()      
                , ModifiedBy = @UserId      
               Where OrderId = @OrderId      
                        
           Set @Result = 'Success'       
          END              
       ELSE      
        --BEGIN                  
        -- IF @GPRSChipNo != '' And Exists (Select OrderItemDetailId From OrderItemDetails Where GPRSNo = @GPRSChipNo)      
        --  BEGIN      
        --   Set @Result = 'Duplicate Chip Number is not allowed.'      
        --  END      
        -- ELSE      
          BEGIN      
           Insert into OrderItemDetails(OrderItemId, GPRSNo, ModifiedOn, ModifiedBy, GPRSNoPostCode,PSTNNo,OptionId,SiteName)      
                Values (@OrderItemId, @GPRSChipNo, GETDATE(), @UserId, @GPRSNoPostCode,@PSTNNo,@OptionId,@SiteName)      
               
           Select @OrderItemDetailId = SCOPE_IDENTITY()      
                 
           Update OrderItems      
            Set ProductQty = ProductQty + 1,      
             Price = @ProductPrice,      
             ModifiedOn = GETDATE(),      
             ModifiedBy = @UserId,      
             CategoryId = @CategoryId      
            Where       
             OrderId = @OrderId       
             And ProductId = @ProductId       
             And CategoryId = @CategoryId      
                   
                 
           SET @GetDependentProducts = CURSOR FOR      
           SELECT t.ProductId, CASE IsNull(t.ARC_Price,0) WHEN 0 THEN t.Price ELSE t.ARC_Price END AS Price      
            FROM      
            (SELECT p.ProductId, p.Price, ppm.Price AS ARC_Price      
             FROM Products p      
             left join      
             ARC_Product_Price_Map ppm ON ppm.ProductId = p.ProductId and DATEDIFF(d,isnull(ppm.ExpiryDate,getdate()),GETDATE())>0 And ppm.IsDeleted=0      
             WHERE p.IsDeleted=0 and p.ProductId in      
              (SELECT pdm.DependentProductId FROM Product_Dependent_Map pdm WHERE pdm.ProductId = @ProductId)      
            ) t      
      
           OPEN @GetDependentProducts      
                
           FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice      
           WHILE @@FETCH_STATUS = 0      
            BEGIN       
             SET @DependentProductPriceTotal = @DependentProductPriceTotal + @DependentProductPrice      
                   
             IF Exists (Select OrderDependentId From OrderDependentItems Where OrderId = @OrderId And ProductId = @DependentProductId)      
              BEGIN      
               Update OrderDependentItems      
                Set ProductQty = ProductQty + 1      
                 , Price = @DependentProductPrice      
                Where OrderId = @OrderId      
                  And ProductId = @DependentProductId      
              END      
             ELSE      
              BEGIN      
               Insert Into OrderDependentItems (OrderId, OrderItemId, ProductId, ProductQty, Price)      
                      VALUES(@OrderId, @OrderItemId, @DependentProductId, 1, @DependentProductPrice)      
              END  
             FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice       
            END      
      
           CLOSE @GetDependentProducts      
           DEALLOCATE @GetDependentProducts      
             
           Update Orders Set OrderDate = GETDATE()      
                , Amount = Amount + @ProductPrice + @DependentProductPriceTotal      
                , ModifiedOn = GETDATE()      
                , ModifiedBy = @UserId      
               Where OrderId = @OrderId      
                        
           Set @Result = 'Success'      
          END              
        END      
      END       
    END      
  END       
       
 Select @Result as ResultMessage, @IsAnyDuplicate as IsAnyDuplicate      
--END      
END TRY       
BEGIN CATCH      
EXEC USP_SaveSPErrorDetails      
RETURN -1        
END CATCH
GO
/****** Object:  View [dbo].[VW_SIM_REGISTER_PREVIOUSMONTH]    Script Date: 12/14/2015 17:06:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_SIM_REGISTER_PREVIOUSMONTH] AS    
    
select     
    
CASE when ICCID like '00500%'     
 THEN    
  SUBSTRING (ICCID,0,12)      
 ELSE     
  CASE WHEN ICCID LIKE 'E%'    
   THEN REPLACE(ICCID,'E','')    
   ELSE ICCID    
  END    
 END    
AS ICCID,    
COALESCE(DataNo,'') AS DataNo,    
CASE when ICCID like '00500%'     
 THEN    
  SUBSTRING (ICCID,0,12)      
 ELSE     
 COALESCE(Dev_IMSINumber, DataNo )     
 END    
as IMSI,    
COALESCE( IPAddress,'') as IPAddress,GPRSNo as ChipNo,    
ProductCode,Replace(ProductName,'<br/>',' ') as ProductName,CompanyName,convert(varchar(256), Processedon ,103) OrderDate,ARC_Code,Installer,InstallerCode,UniqueCode as InstallerUNQCode,     
COALESCE( (SELECT TOP 1 OrderRefNo from Orders where ARCId in( 214) and OrderNo = vw_SIMRegister.OrderNo ) , '' ) +    
COALESCE( (SELECT TOP 1 cast(substring(SpecialInstructions,0,256) as nvarchar(256)) from Orders where ARCId in( 4) and OrderNo = vw_SIMRegister.OrderNo ) , '' ) as [REF] ,    
OrderNo,ProcessedOn    
from dbo.vw_SIMRegister where     
(DATEPART(year,processedon) =    
 case     
 when(DATEPART(month,GETDATE()) = 01)     
  then  DATEPART(year,getdate()) - 1    
 else    
  DATEPART(year,getdate())      
  END    
)    
and     
DATEPART(month,processedon) =     
case     
 when(DATEPART(month,GETDATE()) = 01)     
 then     
 12    
 else    
 (DATEPART(month,getdate())-1)    
end    
 --CAST(processedon  as DATE)  > CAST(   as DATE) and   CAST(processedon  as DATE)  < CAST( getdate()  as DATE)    
 AND OrderStatusid in ( 10,19) AND ICCID IS NOT NULL and orderitemstatusid <>13
GO
/****** Object:  View [dbo].[VW_SIM_REGISTER_CURRENTMONTH]    Script Date: 12/14/2015 17:06:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_SIM_REGISTER_CURRENTMONTH] AS  
  
select   
CASE when ICCID like '00500%'   
 THEN  
  SUBSTRING (ICCID,0,12)    
 ELSE   
  CASE WHEN ICCID LIKE 'E%'  
   THEN REPLACE(ICCID,'E','')  
   ELSE ICCID  
  END  
 END  
AS ICCID,  
COALESCE(DataNo,'') AS DataNo,  
CASE when ICCID like '00500%'   
 THEN  
  SUBSTRING (ICCID,0,12)    
 ELSE   
 COALESCE(Dev_IMSINumber, DataNo )   
 END  
as IMSI,  
COALESCE( IPAddress,'') as IPAddress,GPRSNo as ChipNo,  
ProductCode,Replace(ProductName,'<br/>',' ') as ProductName,CompanyName,convert(varchar(256), Processedon ,103) OrderDate,ARC_Code,Installer,InstallerCode,UniqueCode as InstallerUNQCode,   
COALESCE( (SELECT TOP 1 OrderRefNo from Orders where ARCId in( 214) and OrderNo = vw_SIMRegister.OrderNo ) , '' ) +  
COALESCE( (SELECT TOP 1 cast(substring(SpecialInstructions,0,256) as nvarchar(256)) from Orders where ARCId in( 4) and OrderNo = vw_SIMRegister.OrderNo ) , '' ) as [REF] ,  
OrderNo,Processedon  
from dbo.vw_SIMRegister where   
DATEPART(year,processedon) = DATEPART(year,getdate())  
and   
DATEPART(month,processedon) = DATEPART(month,getdate())  
--AND OrderStatusid in (19) AND ICCID IS NOT NULL and orderitemstatusid <>13   
AND OrderStatusid in (10,19) AND ICCID IS NOT NULL and orderitemstatusid <>13
GO
/****** Object:  View [dbo].[VW_DESPATCHLOG_SALESTEAM]    Script Date: 12/14/2015 17:06:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_DESPATCHLOG_SALESTEAM] AS 

select VD.SalesRep,InstallerName,Vd.InstallerCode,vd.UniqueCode,VD.CompanyName,ARC_Code,
REPLACE( ProductName ,'<br/>',' ') as ProductName 
, ProductCode,GPRSNo as ChipNo,ISNULL(ICCID,'') as ICCID,ISNULL(DataNo,'') as DataNo,
DeliveryNoteNo,
convert(varchar(256),OrderDate,103) as OrderDate,
convert(varchar(256), Processedon ,103) DespatchDate,
OrderNo,[ARC Ref],ISNULL(Grade,'') as Grade,
ISNULL(BOS_Grade,'')as BOS_Grade,ISNULL(IPAddress,'') as IPAdd,Processedon
,CategoryName AS 
Category
from vw_despatchlog  VD --inner join Category_Product_Map CPM on VD.productid = CPM.ProductId inner join Category C on CPM.CategoryId = C.CategoryId
LEft Join Category On Vd.CategoryID = category.categoryID 
where 
	DATEPART(year,processedon) = DATEPART(year,getdate())
	and 
	DATEPART(month,processedon) = (DATEPART(month,getdate())) 
AND OrderStatusid in ( 10,14,15,16)
and VD.ProductCode in (select ProductCode from Products where  ProductType = 'Product'  and IsDependentProduct = 0)
GO
/****** Object:  View [dbo].[vw_IdentList]    Script Date: 12/14/2015 17:06:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Modified by:Atiq 
-- Modified Date:24/04/2015
-- Add one more column IsVoiceSMSVisible in select statement.
-- =============================================

CREATE VIEW [dbo].[vw_IdentList]
AS 
 --DROP TABLE TEMPIdent
 SELECT --DISTINCT 
  ORDERS.ARCID,ORDERS.ARC_CODE,CompanyName, ORDERITEMDETAILS.ICCID,ProductS.ProductID,Products.ProductCode,ProductName,ORDERITEMS.Price,ORDERITEMS.CategoryID,PRODUCTS.IsVoiceSMSVisible  from ORDERS 
 INNER JOIN ORDERITEMS ON ORDERS.ORDERID = ORDERITEMS.ORDERID AND ORDERITEMS.OrderItemStatusID != 13 and  ORDERITEMS.ISREPLENISHMENT =1 
 INNER JOIN ORDERITEMDETAILS ON  ORDERITEMS.ORDERITEMID  = ORDERITEMDETAILS.ORDERITEMID 
 INNER JOIN PRODUCTS on OrderItems.ProductID = ProductS.ProductID 
 INNER JOIN ARC on ORDERS.ARC_Code = ARC.ARC_Code
 LEFT JOIN vw_ActiveICCIDs on  ORDERITEMDETAILS.ICCID = vw_ActiveICCIDs.ICCID 

 WHERE
  vw_ActiveICCIDs.ICCID is null 
  AND ORDERITEMDETAILS.ICCId is not null 
  AND OrderITemDetails.ICCID NOT IN 
  (SELECT ICCID FROM ActiveConsignmentOldUnits)
    AND OrderITemDetails.ICCID NOT IN ( SElect PSTNNo FROM ORDERITEMDETAILS x WHERE x.OrderItemDetailId = ORDERITEMDETAILS.OrderItemDetailId)
GO
/****** Object:  View [dbo].[VW_GetOrderItemstoProcess]    Script Date: 12/14/2015 17:06:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_GetOrderItemstoProcess]     
AS  
SELECT Orders.OrderID,Orders.OrderNO,OrderItems.OrderItemId,
ProductCode,
ARC_Code,
Orders.ARCID as ArcID,
CASE WHEN PRODUCTCODE NOT IN ('CS3212','CS3312','CS3200') THEN ARCBasedPRMPath ELSE (SELECT ARCBasedPRMPath FROM CATEGORY WHERE CATEGORYID =1 ) END AS ARCBasedPRMPath ,
CASE WHEN PRODUCTCODE NOT IN ('CS3212','CS3312','CS3200') THEN ARCBasedPRMPathO2 ELSE (SELECT ARCBasedPRMPath FROM CATEGORY WHERE CATEGORYID =1 ) END AS ARCBasedPRMPathO2 ,
CASE WHEN PRODUCTCODE NOT IN ('CS3212','CS3312','CS3200') THEN ARCBasedPRMPathWorldSim ELSE (SELECT ARCBasedPRMPath FROM CATEGORY WHERE CATEGORYID =1 ) END AS ARCBasedPRMPathWorldSim ,
CASE WHEN PRODUCTCODE NOT IN ('CS3212','CS3312','CS3200') THEN ARCBasedPRMPathGDSP ELSE (SELECT ARCBasedPRMPath FROM CATEGORY WHERE CATEGORYID =1 ) END AS ARCBasedPRMPathGDSP ,
CASE WHEN PRODUCTCODE NOT IN ('CS3212','CS3312','CS3200') THEN ARCBasedPRMPathTele2 ELSE (SELECT ARCBasedPRMPath FROM CATEGORY WHERE CATEGORYID =1 ) END AS ARCBasedPRMPathTele2 ,
CASE WHEN PRODUCTCODE NOT IN ('CS3212','CS3312','CS3200') THEN GenericPRMPath ELSE (SELECT GenericPRMPath FROM CATEGORY WHERE CATEGORYID =1 ) END AS GenericPRMPath,
CASE WHEN PRODUCTCODE NOT IN ('CS3212','CS3312','CS3200') THEN GenericPRMPathO2 ELSE (SELECT ARCBasedPRMPath FROM CATEGORY WHERE CATEGORYID =1 ) END AS GenericPRMPathO2 ,
CASE WHEN PRODUCTCODE NOT IN ('CS3212','CS3312','CS3200') THEN GenericPRMPathWorldSim ELSE (SELECT ARCBasedPRMPath FROM CATEGORY WHERE CATEGORYID =1 ) END AS GenericPRMPathWorldSim ,
CASE WHEN PRODUCTCODE NOT IN ('CS3212','CS3312','CS3200') THEN GenericPRMPathGDSP ELSE (SELECT ARCBasedPRMPath FROM CATEGORY WHERE CATEGORYID =1 ) END AS GenericPRMPathGDSP ,
CASE WHEN PRODUCTCODE NOT IN ('CS3212','CS3312','CS3200') THEN GenericPRMPathTele2 ELSE (SELECT ARCBasedPRMPath FROM CATEGORY WHERE CATEGORYID =1 ) END AS GenericPRMPathTele2 ,
CASE WHEN PRODUCTCODE NOT IN ('CS3212','CS3312','CS3200') THEN PendingFilePath  ELSE (SELECT PendingFilePath FROM CATEGORY WHERE CATEGORYID =1 ) END AS PendingFilePath,
Orders.ProcessedBy,
CASE WHEN PRODUCTCODE NOT IN ('CS3212','CS3312','CS3200') THEN  orderItems.categoryID ELSE 1 END as categoryID,
orderItems.OrderItemStatusID,
installer.Uniquecode AS 'UniqueCode',
isnull(installer.Installercode,'') AS 'InstallerCode',
isnull(dbo.GetHOUniqueCode(installer.Uniquecode),0) AS 'HOUniqueCode',
ISNULL(CountryCode,'UK') as 'CountryCode' ,
[dbo].[GetAccessCode](Orders.ARC_CODE,installer.Uniquecode) AS 'AccessCode' ,
ISNULL(OrderItems.IsCSD,0) AS 'IsCSD',
-- ** IF CSD THEN REPLENISHMENT IS FALSE 
CASE WHEN ISNULL(OrderItems.IsCSD,0) = 1 THEN 0  ELSE  ISNULL(OrderItems.IsReplenishment,0)  END AS 'IsReplenishment'
FROM Orders 
INNER JOIN [OrderItems] on  Orders.OrderID = OrderItems.OrderID
INNER JOIN PRODUCTS on OrderItems.ProductID =  Products.ProductID
INNER JOIN Installer ON Orders.InstallerID = Installer.InstallerCompanyID
LEFT OUTER JOIN [dbo].[Address] on Orders.DeliveryAddressId = [Address].AddressID 
LEFT OUTER JOIN  COUNTRYMASTER on [Address].CountryID = COUNTRYMASTER.CountryID
LEFT OUTER JOIN category on orderitems.categoryID = category.categoryID
WHERE orderItems.OrderItemStatusID in (17,18) AND Orders.Ordertype = 1
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateSSRSArcOrderingReportCount_ReportId]    Script Date: 12/14/2015 17:06:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*CreateBy: Siva  
CreatedOn -  
Purpose: To update the master info table with the count on BOS server. User by SSRS reports  
*/    
     
       
CREATE procedure [dbo].[sp_UpdateSSRSArcOrderingReportCount_ReportId](@ReportId int)          
as begin      
          
       
if(@ReportId  = 12)          
          
begin          
          
Execute [USP_GetDispatchReport_Count] 12  
    
end             
          
          
if(@ReportId  = 61)          
          
begin          
          
Execute [USP_M2MConnectOrders_Count] 61     
    
end     
    
if(@ReportId  = 26)          
          
begin          
          
Execute USP_FailedOrderToEclipse_Count 26     
    
end     
        
        
select ReportName,[To],CC,BCC,Subject +' - ' + Convert(varchar(10),GETDATE(),103)Subject,          
Case when DataCount>0 then  Body else 'No Data Available' end as Body ,          
Case when DataCount>0 then 'True' else 'False' end as IncludeReport,          
Case when DataCount>0 then 'Excel' else 'MHTML' end as RenderFormat          
from BOS.dualcom_reports.dbo.MasterReportInfo  where ReportId = @ReportId     
    
       
            
              
          
end
GO
/****** Object:  Default [DF_ProductCodeMapping_ModifiedOn]    Script Date: 12/14/2015 17:06:28 ******/
ALTER TABLE [dbo].[ProductCodeMapping] ADD  CONSTRAINT [DF_ProductCodeMapping_ModifiedOn]  DEFAULT (getdate()) FOR [ModifiedOn]
GO
/****** Object:  Default [DF__Product_A__CSDRe__6D4D2A16]    Script Date: 12/14/2015 17:06:28 ******/
ALTER TABLE [dbo].[Product_ARC_Map] ADD  DEFAULT ((0)) FOR [CSDRestriction]
GO
/****** Object:  Default [DF_Portal_Roles_Active]    Script Date: 12/14/2015 17:06:28 ******/
ALTER TABLE [dbo].[Portal_Roles] ADD  CONSTRAINT [DF_Portal_Roles_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_PaymentTransaction_CreatedOn]    Script Date: 12/14/2015 17:06:28 ******/
ALTER TABLE [dbo].[PaymentTransaction] ADD  CONSTRAINT [DF_PaymentTransaction_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_PaymentNotes_CreatedOn]    Script Date: 12/14/2015 17:06:28 ******/
ALTER TABLE [dbo].[PaymentNotes] ADD  CONSTRAINT [DF_PaymentNotes_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_Category_IsDeleted]    Script Date: 12/14/2015 17:06:28 ******/
ALTER TABLE [dbo].[Category] ADD  CONSTRAINT [DF_Category_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
/****** Object:  Default [DF_Category_CreatedOn]    Script Date: 12/14/2015 17:06:28 ******/
ALTER TABLE [dbo].[Category] ADD  CONSTRAINT [DF_Category_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_Category_ModifiedOn]    Script Date: 12/14/2015 17:06:28 ******/
ALTER TABLE [dbo].[Category] ADD  CONSTRAINT [DF_Category_ModifiedOn]  DEFAULT (getdate()) FOR [ModifiedOn]
GO
/****** Object:  Default [DF_Category_ListOrder]    Script Date: 12/14/2015 17:06:28 ******/
ALTER TABLE [dbo].[Category] ADD  CONSTRAINT [DF_Category_ListOrder]  DEFAULT ((0)) FOR [ListOrder]
GO
/****** Object:  Default [DF_Category_IsGPRSChipEmpty]    Script Date: 12/14/2015 17:06:28 ******/
ALTER TABLE [dbo].[Category] ADD  CONSTRAINT [DF_Category_IsGPRSChipEmpty]  DEFAULT ((0)) FOR [IsGPRSChipEmpty]
GO
/****** Object:  Default [def_InsertedDate]    Script Date: 12/14/2015 17:06:28 ******/
ALTER TABLE [dbo].[BillingOrdersList_sent] ADD  CONSTRAINT [def_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
GO
/****** Object:  Default [df_IsDefault]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[BandNameMaster] ADD  CONSTRAINT [df_IsDefault]  DEFAULT ((0)) FOR [IsDefault]
GO
/****** Object:  Default [DF_ArcTypes_IsDeleted]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[ArcTypes] ADD  CONSTRAINT [DF_ArcTypes_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
/****** Object:  Default [DF__ARC_Repor__IsAct__5AD97420]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[ARC_Reports] ADD  CONSTRAINT [DF__ARC_Repor__IsAct__5AD97420]  DEFAULT ((0)) FOR [IsActive]
GO
/****** Object:  Default [DF_ARC_Product_Price_Map_ExpiryDate]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[ARC_Product_Price_Map] ADD  CONSTRAINT [DF_ARC_Product_Price_Map_ExpiryDate]  DEFAULT ('1900-01-01') FOR [ExpiryDate]
GO
/****** Object:  Default [DF_ARC_Product_Price_Map_IsDeleted]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[ARC_Product_Price_Map] ADD  CONSTRAINT [DF_ARC_Product_Price_Map_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
/****** Object:  Default [DF_Fedex_Import_UpdatedOnOrder]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[Fedex_Import] ADD  CONSTRAINT [DF_Fedex_Import_UpdatedOnOrder]  DEFAULT ((0)) FOR [UpdatedOnOrder]
GO
/****** Object:  Default [DF_ErrorLog_Status]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[ErrorLog] ADD  CONSTRAINT [DF_ErrorLog_Status]  DEFAULT ((0)) FOR [Status]
GO
/****** Object:  Default [DF__DeviceSMS__Datea__168449D3]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[DeviceSMS] ADD  CONSTRAINT [DF__DeviceSMS__Datea__168449D3]  DEFAULT (getdate()) FOR [DateAdded]
GO
/****** Object:  Default [DF__DeviceSMS__ISPro__17786E0C]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[DeviceSMS] ADD  CONSTRAINT [DF__DeviceSMS__ISPro__17786E0C]  DEFAULT ((0)) FOR [Isprocessed]
GO
/****** Object:  Default [DF__Device_AP__blnFe__06B7F65E]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[Device_API] ADD  DEFAULT ((0)) FOR [blnFetched]
GO
/****** Object:  Default [DF__Device_AP__Data___7CF981FA]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[Device_API] ADD  DEFAULT ('') FOR [Data_Number]
GO
/****** Object:  Default [DF__Device_AP__Dev_U__5D4BCC77]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[Device_API] ADD  DEFAULT ('0') FOR [Dev_UsageLimitReached]
GO
/****** Object:  Default [DF__Device_AP__Custo__66A02C87]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[Device_API] ADD  DEFAULT ((0)) FOR [CustomerID]
GO
/****** Object:  Default [DF_DeliveryType_IsDeleted]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[DeliveryType] ADD  CONSTRAINT [DF_DeliveryType_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
/****** Object:  Default [DF_DeliveryType_CreatedOn]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[DeliveryType] ADD  CONSTRAINT [DF_DeliveryType_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_DeliveryType_ModifiedOn]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[DeliveryType] ADD  CONSTRAINT [DF_DeliveryType_ModifiedOn]  DEFAULT (getdate()) FOR [ModifiedOn]
GO
/****** Object:  Default [DF__DeliveryT__IsTim__61516785]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[DeliveryType] ADD  DEFAULT ((0)) FOR [IsTimedDelivery]
GO
/****** Object:  Default [DF__DeliveryP__IsFre__18027DF1]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[DeliveryPrices] ADD  CONSTRAINT [DF__DeliveryP__IsFre__18027DF1]  DEFAULT ((0)) FOR [IsFreeDelivery]
GO
/****** Object:  Default [DF_DeliveryOffers_CreatedOn]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[DeliveryOffers] ADD  CONSTRAINT [DF_DeliveryOffers_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_DeliveryOffers_ModifiedOn]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[DeliveryOffers] ADD  CONSTRAINT [DF_DeliveryOffers_ModifiedOn]  DEFAULT (getdate()) FOR [ModifiedOn]
GO
/****** Object:  Default [DF__DeliveryO__Categ__32EB7E57]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[DeliveryOffers] ADD  CONSTRAINT [DF__DeliveryO__Categ__32EB7E57]  DEFAULT ((-1)) FOR [CategoryID]
GO
/****** Object:  Default [DF_Delivery_Product_Sibblings_CreatedOn]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[Delivery_Product_Sibblings] ADD  CONSTRAINT [DF_Delivery_Product_Sibblings_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_Delivery_Product_Sibblings_ModifiedOn]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[Delivery_Product_Sibblings] ADD  CONSTRAINT [DF_Delivery_Product_Sibblings_ModifiedOn]  DEFAULT (getdate()) FOR [ModifiedOn]
GO
/****** Object:  Default [DF__Currency__Curren__6482D9EB]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[Currency] ADD  CONSTRAINT [DF__Currency__Curren__6482D9EB]  DEFAULT (NULL) FOR [CurrencySymbol]
GO
/****** Object:  Default [DF__CSLOrderi__Sync___06B7F65E]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[CSLOrderingEmail] ADD  CONSTRAINT [DF__CSLOrderi__Sync___06B7F65E]  DEFAULT ('A') FOR [Sync_Status]
GO
/****** Object:  Default [DF_OrderDIConfirmed_DateCSVGenerated]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[OrderDIConfirmed] ADD  CONSTRAINT [DF_OrderDIConfirmed_DateCSVGenerated]  DEFAULT (getdate()) FOR [DateCSVGenerated]
GO
/****** Object:  Default [DF_OrderDependentItems_QntyDelivered]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[OrderDependentItems] ADD  CONSTRAINT [DF_OrderDependentItems_QntyDelivered]  DEFAULT ((0)) FOR [QntyDelivered]
GO
/****** Object:  Default [DF_Order_FailedDevices_IsDeleted]    Script Date: 12/14/2015 17:06:31 ******/
ALTER TABLE [dbo].[Order_FailedDevices] ADD  CONSTRAINT [DF_Order_FailedDevices_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
/****** Object:  Default [DF_M2MCompany_M2MCompanyID]    Script Date: 12/14/2015 17:06:34 ******/
ALTER TABLE [dbo].[M2MCompany] ADD  CONSTRAINT [DF_M2MCompany_M2MCompanyID]  DEFAULT (newid()) FOR [M2MCompanyID]
GO
/****** Object:  Default [DF_M2MCompany_CreatedOn]    Script Date: 12/14/2015 17:06:34 ******/
ALTER TABLE [dbo].[M2MCompany] ADD  CONSTRAINT [DF_M2MCompany_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [df_HomeCountryId]    Script Date: 12/14/2015 17:06:34 ******/
ALTER TABLE [dbo].[Installer_User_Map] ADD  CONSTRAINT [df_HomeCountryId]  DEFAULT ((1)) FOR [HomeCountryId]
GO
/****** Object:  Default [df_HomeCurrencyId]    Script Date: 12/14/2015 17:06:34 ******/
ALTER TABLE [dbo].[Installer_User_Map] ADD  CONSTRAINT [df_HomeCurrencyId]  DEFAULT ((1)) FOR [HomeCurrencyId]
GO
/****** Object:  Default [df_CurrencyId]    Script Date: 12/14/2015 17:06:34 ******/
ALTER TABLE [dbo].[Installer_User_Map] ADD  CONSTRAINT [df_CurrencyId]  DEFAULT ((1)) FOR [CurrencyId]
GO
/****** Object:  Default [DF__Installer__IsExd__16B953FD]    Script Date: 12/14/2015 17:06:34 ******/
ALTER TABLE [dbo].[Installer] ADD  DEFAULT ('0') FOR [IsExdirectory]
GO
/****** Object:  Default [DF__Installer__IsVoi__6B64E1A4]    Script Date: 12/14/2015 17:06:34 ******/
ALTER TABLE [dbo].[Installer] ADD  DEFAULT ((0)) FOR [IsVoiceSMSVisible]
GO
/****** Object:  Default [DF__GradeMap2__IsAct__5026DB83]    Script Date: 12/14/2015 17:06:34 ******/
ALTER TABLE [dbo].[GradeMap2Master] ADD  DEFAULT ('0') FOR [IsActive]
GO
/****** Object:  Default [DF_Address_Country]    Script Date: 12/14/2015 17:06:34 ******/
ALTER TABLE [dbo].[Address] ADD  CONSTRAINT [DF_Address_Country]  DEFAULT ('UK') FOR [Country]
GO
/****** Object:  Default [DF_Address_ModifiedOn]    Script Date: 12/14/2015 17:06:34 ******/
ALTER TABLE [dbo].[Address] ADD  CONSTRAINT [DF_Address_ModifiedOn]  DEFAULT (getdate()) FOR [ModifiedOn]
GO
/****** Object:  Default [DF__UserSIMS__ACTIVE__27AED5D5]    Script Date: 12/14/2015 17:06:34 ******/
ALTER TABLE [dbo].[UserSIMS] ADD  CONSTRAINT [DF__UserSIMS__ACTIVE__27AED5D5]  DEFAULT ((1)) FOR [ACTIVE]
GO
/****** Object:  Default [DF_UserMapping_UserMappingId]    Script Date: 12/14/2015 17:06:34 ******/
ALTER TABLE [dbo].[UserMapping] ADD  CONSTRAINT [DF_UserMapping_UserMappingId]  DEFAULT (newid()) FOR [UserMappingId]
GO
/****** Object:  Default [df_usermapping_HomeCountryId]    Script Date: 12/14/2015 17:06:34 ******/
ALTER TABLE [dbo].[UserMapping] ADD  CONSTRAINT [df_usermapping_HomeCountryId]  DEFAULT ((1)) FOR [HomeCountryId]
GO
/****** Object:  Default [DF__UserMappi__Creat__35FCF52C]    Script Date: 12/14/2015 17:06:34 ******/
ALTER TABLE [dbo].[UserMapping] ADD  CONSTRAINT [DF__UserMappi__Creat__35FCF52C]  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF__UserMappi__IsCre__31F75A1E]    Script Date: 12/14/2015 17:06:34 ******/
ALTER TABLE [dbo].[UserMapping] ADD  CONSTRAINT [DF__UserMappi__IsCre__31F75A1E]  DEFAULT ((0)) FOR [IsCreditAllowed]
GO
/****** Object:  Default [DF_UserCategory_UserCategoryId]    Script Date: 12/14/2015 17:06:34 ******/
ALTER TABLE [dbo].[UserCategory] ADD  CONSTRAINT [DF_UserCategory_UserCategoryId]  DEFAULT (newid()) FOR [UserCategoryId]
GO
/****** Object:  Default [DF_UserCategory_CreatedOn]    Script Date: 12/14/2015 17:06:34 ******/
ALTER TABLE [dbo].[UserCategory] ADD  CONSTRAINT [DF_UserCategory_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_Orders_OrderDate]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_OrderDate]  DEFAULT (getdate()) FOR [OrderDate]
GO
/****** Object:  Default [DF_Orders_DeliveryTypeId]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_DeliveryTypeId]  DEFAULT ((2)) FOR [DeliveryTypeId]
GO
/****** Object:  Default [DF_Orders_CreatedOn]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_Orders_ModifiedOn]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_ModifiedOn]  DEFAULT (getdate()) FOR [ModifiedOn]
GO
/****** Object:  Default [DF_Orders_HasUserAcceptedDuplicates]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_HasUserAcceptedDuplicates]  DEFAULT ((0)) FOR [HasUserAcceptedDuplicates]
GO
/****** Object:  Default [DF_Orders_VATRate]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_VATRate]  DEFAULT ((0)) FOR [VATRate]
GO
/****** Object:  Default [DF_Orders_DlvNoteVol]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_DlvNoteVol]  DEFAULT ((0)) FOR [DlvNoteVol]
GO
/****** Object:  Default [def_emailsent]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [def_emailsent]  DEFAULT ((0)) FOR [EmailSent]
GO
/****** Object:  Default [df_PaymentType]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [df_PaymentType]  DEFAULT ((1)) FOR [PaymentType]
GO
/****** Object:  Default [df_BillingcycleID]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [df_BillingcycleID]  DEFAULT ((0)) FOR [BillingCycleID]
GO
/****** Object:  Default [DF__Orders__Ordertyp__1F198FD4]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF__Orders__Ordertyp__1F198FD4]  DEFAULT ((1)) FOR [OrderType]
GO
/****** Object:  Default [DF__Orders__Currency__08012052]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Orders] ADD  DEFAULT ((1)) FOR [CurrencyID]
GO
/****** Object:  Default [DF_OrderItems_CreatedOn]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[OrderItems] ADD  CONSTRAINT [DF_OrderItems_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_OrderItems_ModifiedOn]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[OrderItems] ADD  CONSTRAINT [DF_OrderItems_ModifiedOn]  DEFAULT (getdate()) FOR [ModifiedOn]
GO
/****** Object:  Default [df_isCSD]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[OrderItems] ADD  CONSTRAINT [df_isCSD]  DEFAULT ((0)) FOR [IsCSD]
GO
/****** Object:  Default [DF_OrderItems_QntyDelivered]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[OrderItems] ADD  CONSTRAINT [DF_OrderItems_QntyDelivered]  DEFAULT ((0)) FOR [QntyDelivered]
GO
/****** Object:  Default [DF__OrderItem__IsRep]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[OrderItems] ADD  CONSTRAINT [DF__OrderItem__IsRep]  DEFAULT ((0)) FOR [IsReplenishment]
GO
/****** Object:  Default [DF__OrderItem__CSLCo__69B1A35C]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[OrderItems] ADD  DEFAULT ('') FOR [CSLConnectCodePrefix]
GO
/****** Object:  Default [DF_OrderItemDetails_ModifiedOn]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[OrderItemDetails] ADD  CONSTRAINT [DF_OrderItemDetails_ModifiedOn]  DEFAULT (getdate()) FOR [ModifiedOn]
GO
/****** Object:  Default [DF_OrderItemDetails_IsDelivered]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[OrderItemDetails] ADD  CONSTRAINT [DF_OrderItemDetails_IsDelivered]  DEFAULT ((0)) FOR [IsBosInserted]
GO
/****** Object:  Default [DF__OrderItem__Quant__3B60C8C7]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[OrderItemDetails] ADD  CONSTRAINT [DF__OrderItem__Quant__3B60C8C7]  DEFAULT ((1)) FOR [Quantity]
GO
/****** Object:  Default [def_constr]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[OrderItemDetails] ADD  CONSTRAINT [def_constr]  DEFAULT ((0)) FOR [IsDlvNoteGenerated]
GO
/****** Object:  Default [DF_OrderItemDetails_ProcessAttempts]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[OrderItemDetails] ADD  CONSTRAINT [DF_OrderItemDetails_ProcessAttempts]  DEFAULT ((0)) FOR [ProcessAttempts]
GO
/****** Object:  Default [DF__OrderItem__isBil__5B988E2F]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[OrderItemDetails] ADD  DEFAULT ((0)) FOR [isBillingInserted]
GO
/****** Object:  Default [DF__OrderItem__Repla__5F691F13]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[OrderItemDetails] ADD  CONSTRAINT [DF__OrderItem__Repla__5F691F13]  DEFAULT ((0)) FOR [ReplacementProduct]
GO
/****** Object:  Default [DF_ARC_AnnualBilling]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[ARC] ADD  CONSTRAINT [DF_ARC_AnnualBilling]  DEFAULT ((1)) FOR [AnnualBilling]
GO
/****** Object:  Default [DF_ARC_AllowReturns]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[ARC] ADD  CONSTRAINT [DF_ARC_AllowReturns]  DEFAULT ((1)) FOR [AllowReturns]
GO
/****** Object:  Default [DF_ARC_PostingOption]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[ARC] ADD  CONSTRAINT [DF_ARC_PostingOption]  DEFAULT ((1)) FOR [PostingOption]
GO
/****** Object:  Default [DF_ARC_IsDeleted]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[ARC] ADD  CONSTRAINT [DF_ARC_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
/****** Object:  Default [DF_ARC_IsBulkUploadAllowed]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[ARC] ADD  CONSTRAINT [DF_ARC_IsBulkUploadAllowed]  DEFAULT ((1)) FOR [IsBulkUploadAllowed]
GO
/****** Object:  Default [DF_ARC_ExcludeTerms]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[ARC] ADD  CONSTRAINT [DF_ARC_ExcludeTerms]  DEFAULT ((0)) FOR [ExcludeTerms]
GO
/****** Object:  Default [DF__ARC__CreatedOn__3631FF56]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[ARC] ADD  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF__ARC__ModifiedOn__3726238F]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[ARC] ADD  DEFAULT (getdate()) FOR [ModifiedOn]
GO
/****** Object:  Default [DF__ARC__ISAllowedCS__40AF8DC9]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[ARC] ADD  DEFAULT ((0)) FOR [IsAllowedCSD]
GO
/****** Object:  Default [DF__ARC__EnablePostC__611C5D5B]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[ARC] ADD  DEFAULT ((0)) FOR [EnablePostCodeSearch]
GO
/****** Object:  Default [DF__ARC__LocktoDefau__63F8CA06]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[ARC] ADD  DEFAULT ((0)) FOR [LocktoDefaultOption]
GO
/****** Object:  Default [DF__ARC__SafelinkbyI__64ECEE3F]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[ARC] ADD  DEFAULT ((0)) FOR [SafelinkbyIPSec]
GO
/****** Object:  Default [DF__ARC__IsVoiceSMSV__6A70BD6B]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[ARC] ADD  DEFAULT ((0)) FOR [IsVoiceSMSVisible]
GO
/****** Object:  Default [DF_Products_ListOrder]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_ListOrder]  DEFAULT ((0)) FOR [ListOrder]
GO
/****** Object:  Default [DF_Products_IsDeleted]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
/****** Object:  Default [DF_Products_IsDependentProduct]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_IsDependentProduct]  DEFAULT ((0)) FOR [IsDependentProduct]
GO
/****** Object:  Default [DF_Products_CreatedOn]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_Products_ModifiedOn]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_ModifiedOn]  DEFAULT (getdate()) FOR [ModifiedOn]
GO
/****** Object:  Default [DF__Products__IsSite__5AA469F6]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF__Products__IsSite__5AA469F6]  DEFAULT ((0)) FOR [IsSiteName]
GO
/****** Object:  Default [DF__Products__IsRepl__5B988E2F]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF__Products__IsRepl__5B988E2F]  DEFAULT ((0)) FOR [IsReplenishment]
GO
/****** Object:  Default [df_AnnualPrice]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [df_AnnualPrice]  DEFAULT ((0.00)) FOR [AnnualPrice]
GO
/****** Object:  Default [DF__Products__Listed__46335CF5]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF__Products__Listed__46335CF5]  DEFAULT ((0)) FOR [ListedonCSLConnect]
GO
/****** Object:  Default [DF__Products__CSLCOn__4A03EDD9]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF__Products__CSLCOn__4A03EDD9]  DEFAULT ((0)) FOR [CSLConnectVoice]
GO
/****** Object:  Default [DF__Products__CSLCon__4AF81212]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF__Products__CSLCon__4AF81212]  DEFAULT ((0)) FOR [CSLConnectSMS]
GO
/****** Object:  Default [df_Allowance]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [df_Allowance]  DEFAULT ((0)) FOR [Allowance]
GO
/****** Object:  Default [DF__Products__IsHard__0618D7E0]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF__Products__IsHard__0618D7E0]  DEFAULT ((0)) FOR [IsHardwareType]
GO
/****** Object:  Default [DF__Products__IsOEMP__070CFC19]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF__Products__IsOEMP__070CFC19]  DEFAULT ((0)) FOR [IsOEMProduct]
GO
/****** Object:  Default [DF__Products__IsVoic__7E42ABEE]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF__Products__IsVoic__7E42ABEE]  DEFAULT ((1)) FOR [IsVoiceSMSVisible]
GO
/****** Object:  Default [DF__Products__IsDefe__0AA882D3]    Script Date: 12/14/2015 17:06:39 ******/
ALTER TABLE [dbo].[Products] ADD  DEFAULT ((0)) FOR [IsDeferredPaymentAllowed]
GO
/****** Object:  ForeignKey [FK_ARC_AccessCode_ARC]    Script Date: 12/14/2015 17:06:46 ******/
ALTER TABLE [dbo].[ARC_AccessCode]  WITH CHECK ADD  CONSTRAINT [FK_ARC_AccessCode_ARC] FOREIGN KEY([ARCID])
REFERENCES [dbo].[ARC] ([ARCId])
GO
ALTER TABLE [dbo].[ARC_AccessCode] CHECK CONSTRAINT [FK_ARC_AccessCode_ARC]
GO
