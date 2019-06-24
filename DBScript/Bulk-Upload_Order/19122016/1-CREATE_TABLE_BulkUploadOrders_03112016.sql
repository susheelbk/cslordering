GO
/****** Object:  Table [dbo].[BulkUploadOrders]    Script Date: 11/08/2016 18:20:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[BulkUploadOrders](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProductCode] [nvarchar](20) NULL,
	[GPRSChipNo] [nvarchar](50) NULL,
	[GPRSChippostCode] [nvarchar](200) NULL,
	[ARC_Id] [int] NULL,
	[OrderId] [int] NULL,
	[IsARC_AllowReturns] [bit] NULL,
	[UserId] [nvarchar](256) NULL,
	[Ident] [nvarchar](50) NULL,
	[OptionId] [int] NULL,
	[IsCSD] [bit] NULL,
	[IsReplenishment] [bit] NULL,
	[SiteName] [varchar](256) NULL,
	[IsValidGPRSChipPostCode] [bit] NULL,
	[UploadedBy] [varchar](256) NULL,
	[UploadedOn] [datetime] NULL,
	[Result] [nvarchar](500) NULL,
	[IsAnyDuplicate] [bit] NULL,
	[GSMNo] [nvarchar](50) NULL,
 CONSTRAINT [PK_BulkUploadOrders] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


