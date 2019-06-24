
/****** Object:  Table [dbo].[Device_API]    Script Date: 02/09/2013 12:12:33 ******/
/* DEV_CODE is ICCID */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Device_API](
	[ID] [int] NOT NULL,
	[Dev_Code] [varchar](20) NOT NULL,
	[Dev_IMSINumber] [varchar](30) NULL,
	[Dev_IP_Address] [varchar](30) NULL,
	[blnFetched] [bit] NULL,
	[CreatedBy] [varchar](100) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [varchar](100) NULL,
	[ModifiedOn] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

