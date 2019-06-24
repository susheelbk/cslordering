USE [ARC_Ordering_LiveBeta]
GO

/****** Object:  StoredProcedure [dbo].[USP_GetARCEmailCC]    Script Date: 28/08/2013 11:01:04 ******/
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

