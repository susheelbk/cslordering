
/****** Object:  Table [dbo].[OrderShippingTrack]    Script Date: 05/09/2013 17:39:27 ******/
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


