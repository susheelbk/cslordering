
/****** Object:  Table [dbo].[Polling_Server]    Script Date: 29/08/2013 15:51:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Polling_Server](
	[PS_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[PS_Code] [nvarchar](15) NOT NULL

 CONSTRAINT [PK_Polling_Server] PRIMARY KEY CLUSTERED 
(
	[PS_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


--Insert into [Polling_Server] VALUES ('APN530')
--Insert into [Polling_Server] VALUES ('APN630')
--Insert into [Polling_Server] VALUES ('APN520')
--Insert into [Polling_Server] VALUES ('APN620')
--Insert into [Polling_Server] VALUES ('APN540')
--Insert into [Polling_Server] VALUES ('APN640')
--Insert into [Polling_Server] VALUES ('APN5')
--Insert into [Polling_Server] VALUES ('APN6')
--Insert into [Polling_Server] VALUES ('APN550')
--Insert into [Polling_Server] VALUES ('APN650')
--Insert into [Polling_Server] VALUES ('IREA10')
--Insert into [Polling_Server] VALUES ('IREB10')
--Insert into [Polling_Server] VALUES ('APN560')
--Insert into [Polling_Server] VALUES ('APN660')
