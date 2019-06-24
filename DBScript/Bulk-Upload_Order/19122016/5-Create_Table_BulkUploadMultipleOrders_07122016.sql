/****** Object:  Table [dbo].[BulkUploadMultipleOrders]    Script Date: 12/08/2016 18:02:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

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
	[UploadedBy] [nvarchar](256) NULL,
	[UploadedOn] [datetime] NULL,
	[IsAnyDuplicate] [bit] NULL,
	[IsValidGPRSNoPostCode] [bit] NULL,
	[Result] [nvarchar](500) NULL,
 CONSTRAINT [PK_BulkUploadMultipleOrders] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


