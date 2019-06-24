GO
/****** Object:  StoredProcedure [dbo].[USP_GetBulkUploadedMultipleOrderProducts]    Script Date: 12/09/2016 15:17:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Mohd Atiq	
-- Create date: <10-10-2016>
-- Description:	The purpose of this stored to get the results of bulk uploaded multiple orders in Arc Ordering
-- =============================================
Create PROCEDURE [dbo].[USP_GetBulkUploadedMultipleOrderProducts]
(
@UserName VARCHAR(256)
)
AS
BEGIN
SELECT ID,OrderId,DualComGradeRequired AS ProductCode,NewGPRSChipNo AS GPRS,
GPRSNOPostCode AS PostCode,SiteName,Result,IsAnyDuplicate 
FROM dbo.BulkUploadMultipleOrders WHERE UploadedBy=@UserName
END

