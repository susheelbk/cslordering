GO

/****** Object:  Table [dbo].[AlarmDeliveryARCMapping]    Script Date: 08/17/2016 12:46:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AlarmDeliveryARCMapping](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ARCId] [int] NOT NULL,
	[Branch_ARC_Code] [nvarchar](50) NULL,
	[Branch_ARC_Name] [nvarchar](50) NULL,
	[Branch_ARC_Identifier] [nvarchar](100) NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [nvarchar](50) NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_AlarmDeliveryARCMapping] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[AlarmDeliveryARCMapping]  WITH CHECK ADD  CONSTRAINT [FK_AlarmDeliveryARCMapping] FOREIGN KEY([ARCId])
REFERENCES [dbo].[ARC] ([ARCId])
GO

ALTER TABLE [dbo].[AlarmDeliveryARCMapping] CHECK CONSTRAINT [FK_AlarmDeliveryARCMapping]
GO

ALTER TABLE [dbo].[AlarmDeliveryARCMapping]  WITH CHECK ADD  CONSTRAINT [FK_AlarmDeliveryARCMapping_AlarmDeliveryARCMapping] FOREIGN KEY([ID])
REFERENCES [dbo].[AlarmDeliveryARCMapping] ([ID])
GO

ALTER TABLE [dbo].[AlarmDeliveryARCMapping] CHECK CONSTRAINT [FK_AlarmDeliveryARCMapping_AlarmDeliveryARCMapping]
GO

ALTER TABLE [dbo].[AlarmDeliveryARCMapping] ADD  CONSTRAINT [DF_AlarmDeliveryARCMapping_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO


