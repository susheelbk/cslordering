GO
/****** Object:  Table [dbo].[BulkUploadMultipleOrders]    Script Date: 01/30/2017 15:05:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
IF OBJECT_ID('dbo.BulkUploadMultipleOrders', 'U') IS NOT NULL
          DROP TABLE dbo.BulkUploadMultipleOrders 
CREATE TABLE [dbo].[BulkUploadMultipleOrders](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [nvarchar](256) NULL,
	[RedcareChipNumber] [nvarchar](50) NULL,
	[CustomerName] [nvarchar](256) NULL,
	[GPRSNOPostCode] [nvarchar](50) NULL,
	[RedCareType] [nvarchar](256) NULL,
	[DualComGradeRequired] [nvarchar](20) NULL,
	[NewGPRSChipNo] [nvarchar](50) NULL,
	[CustomerOrderNo] [nvarchar](256) NULL,
	[SiteName] [varchar](256) NULL,
	[FirstName] [nvarchar](256) NULL,
	[LastName] [nvarchar](256) NULL,
	[AddressOne] [nvarchar](100) NULL,
	[AddressTwo] [nvarchar](100) NULL,
	[Town] [nvarchar](100) NULL,
	[County] [nvarchar](100) NULL,
	[PostCode] [nvarchar](50) NULL,
	[Email] [nvarchar](256) NULL,
	[Fax] [nvarchar](50) NULL,
	[Telephone] [nvarchar](50) NULL,
	[Mobile] [nvarchar](50) NULL,
	[Country] [nvarchar](256) NULL,
	[UploadedBy] [nvarchar](256) NULL,
	[UploadedOn] [datetime] NULL,
	[IsAnyDuplicate] [bit] NULL,
	[IsValidGPRSNoPostCode] [bit] NULL,
	[IsValidPostCode] [bit] NULL,
	[Result] [nvarchar](500) NULL,
 CONSTRAINT [PK_BulkUploadMultipleOrder] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


