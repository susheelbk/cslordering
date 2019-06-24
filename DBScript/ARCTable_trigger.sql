USE [ARC_Ordering]
GO

/****** Object:  Trigger [dbo].[ARC_Insert]    Script Date: 18/02/2014 12:14:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  TRIGGER [dbo].[ARC_Insert]
   ON  [dbo].[ARC]
   AFTER INSERT , UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	UPDATE ARC SET ARC.UniqueCode = dbo.GetUniquecode(ARC.ARCID) FROM ARC INNER JOIN INSERTED ON ARC.ARCID = INSERTED.ARCID 
	WHERE nullif(ARC.UniqueCode,'') is null 

END

GO

