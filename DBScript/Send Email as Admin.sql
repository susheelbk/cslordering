IF  EXISTS ( SELECT 1 FROM sys.procedures WHERE name LIKE 'USP_GetBasketProductsOnPreviousOrders') 
BEGIN
DROP PROC  USP_GetBasketProductsOnPreviousOrders
END
GO
              
CREATE PROCEDURE [dbo].[USP_GetBasketProductsOnPreviousOrders]     
(@OrderId INT)    
AS    
BEGIN TRY    
    BEGIN    
        SELECT p.ProductId,    
               ISNULL(p.IsCSD, 0)IsCSDProd,    
               ISNULL(oi.IsCSD, 0)IsCSDUser,    
               ISNULL(p.[Message], '')[Message],    
               p.ProductCode,    
               p.ProductName,    
               p.ProductType,    
               oi.Price,    
               SUM(oid.Quantity)   ProductQty,    
               ISNULL(oi.Price, 0) * ISNULL(oi.ProductQty, 0) AS    
               ProductPriceTotal,    
               oi.OrderItemId,    
               ISNULL(cat.IsGPRSChipEmpty, 0) AS IsGPRSChipEmpty,    
               oi.CategoryId,    
               oi.OrderItemStatusId ,   
               ISNULL(oid.ICCID, '')ICCID,    
               ISNULL(oid.DataNo, '')DataNo,    
               ISNULL(oid.IPAddress, '')IPAddress,
               ISNULL(oid.GPRSNo,'') GPRSNo,   
              ISNULL(o.OptionName,'') OptionName,
               ISNULL(oid .OptionId,0) OptionId  
        FROM   Products p    
               INNER JOIN OrderItems oi    
                    ON  oi.ProductId = p.ProductId    
               LEFT JOIN OrderItemDetails oid    
                    ON  oid.OrderItemId = oi.OrderItemId    
                    LEFT JOIN Options o ON o.OptID=oid.OptionId    
               LEFT JOIN Category cat    
                    ON  cat.CategoryId = oi.CategoryId    
        WHERE  oi.OrderId = @OrderId    
        GROUP BY    
          o.OptionName,
           p.ProductCode,p.IsCSD,oi.IsCSD,p.Message,p.ProductId,    
           p.ProductName,p.ProductType,oi.Price,ISNULL(oi.Price, 0) * ISNULL(oi.ProductQty, 0), oi.OrderItemId,    
           cat.IsGPRSChipEmpty , oi.CategoryId, oi.OrderItemStatusId,
            oid.ICCID,    
           oid.DataNo,oid.IPAddress ,oid.GPRSNo,
           o.OptionName ,
			   oid .OptionId   
        ORDER BY    
               p.ProductCode 
    END    
END TRY                       
BEGIN CATCH    
    EXEC USP_SaveSPErrorDetails     
    RETURN -1    
END CATCH 
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
               oi.OrderItemStatusId
               --ISNULL(oid.ICCID, '')ICCID,          
               --ISNULL(oid.DataNo, '')DataNo,          
               --ISNULL(oid.IPAddress, '')IPAddress           
               ,ISNULL(oid.OptionId ,0) OptionId        
        FROM   Products p          
               INNER JOIN OrderItems oi          
                    ON  oi.ProductId = p.ProductId          
               LEFT JOIN OrderItemDetails oid          
                    ON  oid.OrderItemId = oi.OrderItemId          
                  LEFT JOIN Options o ON o.OptID=oid.OptionId      
               LEFT JOIN Category cat          
                    ON  cat.CategoryId = oi.CategoryId          
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

IF  EXISTS ( SELECT 1 FROM sys.procedures WHERE name LIKE 'USP_GetBasketProductsOnCheckOut') 
BEGIN
DROP PROC  USP_GetBasketProductsOnCheckOut
END
GO
               
CREATE PROCEDURE [dbo].[USP_GetBasketProductsOnCheckOut]     
(@OrderId INT)    
AS    
BEGIN TRY    
    BEGIN    
        SELECT p.ProductId,    
               ISNULL(p.IsCSD, 0)IsCSDProd,    
               ISNULL(oi.IsCSD, 0)IsCSDUser,    
               ISNULL(p.[Message], '')[Message],    
               p.ProductCode,    
               p.ProductName,    
               p.ProductType,    
               oi.Price,    
               SUM(oid.Quantity)   ProductQty,    
               ISNULL(oi.Price, 0) * ISNULL(oi.ProductQty, 0) AS    
               ProductPriceTotal,    
               oi.OrderItemId,    
               ISNULL(cat.IsGPRSChipEmpty, 0) AS IsGPRSChipEmpty,    
               oi.CategoryId,    
               oi.OrderItemStatusId ,   
               --ISNULL(oid.ICCID, '')ICCID,    
               --ISNULL(oid.DataNo, '')DataNo,    
               --ISNULL(oid.IPAddress, '')IPAddress,
               --ISNULL(oid.GPRSNo,'') GPRSNo,   
              ISNULL(o.OptionName,'') OptionName,
               ISNULL(oid .OptionId,0) OptionId  
        FROM   Products p    
               INNER JOIN OrderItems oi    
                    ON  oi.ProductId = p.ProductId    
               LEFT JOIN OrderItemDetails oid    
                    ON  oid.OrderItemId = oi.OrderItemId    
                    LEFT JOIN Options o ON o.OptID=oid.OptionId    
               LEFT JOIN Category cat    
                    ON  cat.CategoryId = oi.CategoryId    
        WHERE  oi.OrderId = @OrderId    
        GROUP BY    
         -- o.OptionName,
           p.ProductCode,p.IsCSD,oi.IsCSD,p.Message,p.ProductId,    
           p.ProductName,p.ProductType,oi.Price,ISNULL(oi.Price, 0) * ISNULL(oi.ProductQty, 0), oi.OrderItemId,    
           cat.IsGPRSChipEmpty , oi.CategoryId, oi.OrderItemStatusId,
          --  oid.ICCID,    
          -- oid.DataNo,oid.IPAddress ,oid.GPRSNo,
           o.OptionName ,
			   oid .OptionId   
        ORDER BY    
               p.ProductCode    
            
         
    END    
END TRY                       
BEGIN CATCH    
    EXEC USP_SaveSPErrorDetails     
    RETURN -1    
END CATCH 
GO


