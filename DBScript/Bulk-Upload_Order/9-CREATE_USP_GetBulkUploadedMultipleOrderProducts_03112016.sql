GO
/****** Object:  StoredProcedure [dbo].[USP_GetBulkUploadedMultipleOrderProducts]    Script Date: 11/03/2016 14:23:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Mohd Atiq	
-- Create date: <10-10-2016>
-- Description:	The purpose of this stored to get the results of bulk uploaded multiple orders in Arc Ordering
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetBulkUploadedMultipleOrderProducts]
(
@UserName VARCHAR(256)
)
AS
BEGIN
SELECT ID,OrderId,ProductCode,GPRSChipNo AS GPRS,PostCode,Sitename,Ident,Result,IsAnyDuplicate 
FROM dbo.BulkUploadMultipleOrders WHERE CreatedBy=@UserName
END

