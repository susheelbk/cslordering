  IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'IsSiteNameEnabled' AND Object_ID = Object_ID(N'Products'))    
BEGIN
ALTER TABLE Products ADD IsSiteNameEnabled BIT DEFAULT(0)
END
GO

  IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'IsReplenishmentEnabled' AND Object_ID = Object_ID(N'Products'))    
BEGIN
ALTER TABLE Products ADD IsReplenishmentEnabled BIT DEFAULT(0)
END
GO


  IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'IsReplenishmentEnabled' AND Object_ID = Object_ID(N'OrderItems'))    
BEGIN
ALTER TABLE OrderItems ADD IsReplenishmentEnabled BIT DEFAULT(0)
END
GO

IF  EXISTS ( SELECT 1 FROM sys.procedures WHERE name LIKE 'USP_GetBasketProducts') 
BEGIN
DROP PROC  USP_GetBasketProducts
END
GO              

CREATE PROCEDURE [dbo].[USP_GetBasketProducts]           
(@OrderId INT)          
AS          
BEGIN TRY          
    BEGIN          
        
        SELECT DISTINCT(p.ProductId),        
               ISNULL(p.IsCSD, 0)IsCSDProd,        
               ISNULL(oi.IsCSD, 0)IsCSDUser,        
               ISNULL(p.IsReplenishmentEnabled, 0)IsReplenishmentProd,    
               ISNULL(oi.IsReplenishmentEnabled, 0)IsReplenishmentUser,          
               ISNULL(p.[Message], '')[Message],        
               p.ProductCode,        
               p.ProductName,        
               p.ProductType,        
               oi.Price,        
               oi.ProductQty,        
               ISNULL(oi.Price, 0) * ISNULL(oi.ProductQty, 0) AS         
               ProductPriceTotal,        
               oi.OrderItemId,        
               ISNULL(cat.IsGPRSChipEmpty, 0) AS IsGPRSChipEmpty,        
               oi.CategoryId,        
               oi.OrderItemStatusId, 
               ISNULL(oid.OptionId ,0) OptionId,     
               ISNULL(p.IsSiteNameEnabled ,0) IsSiteNameEnabled,
			   [GPRSNO]  = CASE WHEN oid.ICCID is null THEN ''
								ELSE iSNULL(oid.GPRSNo,'')
							END
        FROM   Products p        
               INNER JOIN OrderItems oi        
                    ON  oi.ProductId = p.ProductId        
               LEFT JOIN OrderItemDetails oid        
                    ON  oid.OrderItemId = oi.OrderItemId        
                  LEFT JOIN Options o ON o.OptID=oid.OptionId      
               LEFT JOIN Category cat        
                    ON  cat.CategoryId = oi.CategoryId     
				LEFT JOIN dbo.Device_API ON oid.ICCID = dbo.Device_API.Dev_Code       
        WHERE  oi.OrderId = @OrderId        
        ORDER BY        
               p.ProductCode         
    END          
END TRY                       
BEGIN CATCH          
    EXEC USP_SaveSPErrorDetails           
    RETURN -1          
END CATCH   



GO

