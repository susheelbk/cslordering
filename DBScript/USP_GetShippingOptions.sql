USE [ARC_Ordering_LiveBeta]
GO
/****** Object:  StoredProcedure [dbo].[USP_GetShippingOptions]    Script Date: 04/03/2014 12:48:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ajitender Vijay
-- Create date: <Create Date,,>
-- Description:	Get List of Shipping Options
-- =============================================
ALTER PROCEDURE [dbo].[USP_GetShippingOptions]
-- Add the parameters for the stored procedure here
	 
	@ARCId INT,
	@InstallerCompanyID UNIQUEIDENTIFIER,
	@OrderId INT
AS

BEGIN TRY  
BEGIN
    SELECT temp.DeliveryTypeId,
           temp.DeliveryCompanyName,
           temp.DeliveryCompanyDesc,
           temp.DeliveryShortDesc,
           temp.DeliveryPrice,
           temp.DeliveryCode
    FROM   (
               -- DeliveryTypes didn't have any offer
               SELECT dt.DeliveryTypeId,
                      dt.DeliveryCompanyName,
                      dt.DeliveryCompanyDesc,
                      dt.DeliveryShortDesc,
                      dt.DeliveryPrice,
                      dt.DeliveryCode
               FROM   DeliveryType dt
               WHERE  dt.IsDeleted = 0
                      AND dt.DeliveryTypeId <> (
                              SELECT KeyValue
                              FROM   ApplicationSetting app
                              WHERE  app.KeyName = 'MergeDeliveryTypeId'
                          )
                      AND dt.DeliveryTypeId NOT IN (SELECT do.DeliveryTypeId
                                                    FROM   DeliveryOffers do
                                                    WHERE  CONVERT(VARCHAR(20), GETDATE(), 102) 
                                                           < CONVERT(VARCHAR(20), do.ExpiryDate, 102))
               
               UNION ALL 
               -- DeliveryTypes they have offer
               
               SELECT dt.DeliveryTypeId,
                      dt.DeliveryCompanyName,
                      dt.DeliveryCompanyDesc,
                      dt.DeliveryShortDesc,
                      dt.DeliveryPrice,
                      dt.DeliveryCode
               FROM   DeliveryType dt
                      INNER JOIN DeliveryOffers do
                           ON  dt.DeliveryTypeId = do.DeliveryTypeId
                           AND dt.IsDeleted = 0
                           AND dt.DeliveryTypeId <> (
                                   SELECT KeyValue
                                   FROM   ApplicationSetting app
                                   WHERE  app.KeyName = 'MergeDeliveryTypeId'
                               )
               WHERE  CONVERT(VARCHAR(20), GETDATE(), 102) < CONVERT(VARCHAR(20), do.ExpiryDate, 102)
                      AND (
                              (do.OrderValue <= (SELECT  Amount
                                                  FROM   Orders 
                                                  WHERE  OrderId = @OrderId)
							  OR do.OrderValue = '0.00')
                              AND (do.ARCId = @ARCId 
							  OR do.ARCId = '-1')
                              AND (do.ProductId IN (SELECT oi.ProductId
                                                  FROM   OrderItems oi
                                                  WHERE  oi.OrderId = @OrderId) 
							  OR do.ProductId = '-1') 
                              AND (do.InstallerCompanyID = @InstallerCompanyID 
							  OR do.InstallerCompanyID is null)
                               
                          )
           ) AS temp
END
END TRY
BEGIN CATCH          
    EXEC USP_SaveSPErrorDetails           
    RETURN -1          
END CATCH  
