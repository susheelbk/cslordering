GO
/****** Object:  StoredProcedure [dbo].[USP_BulkUploadOrderResults]    Script Date: 11/03/2016 12:49:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Mohd Atiq	
-- Create date: <19-09-2016>
-- Description:	The purpose of this stored to get the results of bulk uploaded orders in Arc Ordering
-- =============================================
CREATE PROCEDURE [dbo].[USP_BulkUploadOrderResults]--'atiq.m'
(
 @UserName VARCHAR(256)
)
AS
BEGIN
SELECT ID,ProductCode,GPRSChipNo AS GPRS,GPRSChippostCode AS PostCode,Sitename,Ident,
Result,IsAnyDuplicate,GSMNo 
FROM dbo.BulkUploadOrders WHERE UploadedBy=@UserName
--DELETE FROM BulkUploadOrders WHERE UploadedBy=@UserName
END

