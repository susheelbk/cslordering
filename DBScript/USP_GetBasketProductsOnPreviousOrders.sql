/****** Object:  StoredProcedure [dbo].[USP_GetBasketProductsOnPreviousOrders]    Script Date: 16/01/2014 17:01:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       
ALTER PROCEDURE [dbo].USP_GetBasketProductsOnPreviousOrders     
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
               oid.Quantity   ProductQty,    
               ISNULL(oi.Price, 0)  AS    
               ProductPriceTotal,    
               oi.OrderItemId,    
               ISNULL(cat.IsGPRSChipEmpty, 0) AS IsGPRSChipEmpty,    
               oi.CategoryId,    
               oi.OrderItemStatusId ,   
               ISNULL(oid.ICCID, '')ICCID,    
               ISNULL(oid.DataNo, '')DataNo,
               ISNULL(oid.GPRSNo,'') GPRSNo,   
              ISNULL(o.OptionName,'') OptionName,
               ISNULL(oid .OptionId,0) OptionId ,
               ISNULL(oid.SiteName,'') SiteName,
               ISNULL(oid.IsFOC,0)IsFoc,
               ISNULL(oid.IsReplacement,0)IsReplacement 
        FROM   Products p    
               INNER JOIN OrderItems oi    
                    ON  oi.ProductId = p.ProductId    
               LEFT JOIN OrderItemDetails oid    
                    ON  oid.OrderItemId = oi.OrderItemId    
                    LEFT JOIN Options o ON o.OptID=oid.OptionId    
               LEFT JOIN Category cat    
                    ON  cat.CategoryId = oi.CategoryId    
        WHERE  oi.OrderId = @OrderId  
		AND p.ProductType= 'Product'
	UNION 
	SELECT p.ProductId,    
               ISNULL(p.IsCSD, 0)IsCSDProd,    
               ISNULL(oi.IsCSD, 0)IsCSDUser,    
               ISNULL(p.[Message], '')[Message],    
               p.ProductCode,    
               p.ProductName,    
               p.ProductType,    
               oi.Price,    
               oi.ProductQty  ProductQty,    
               ISNULL(oi.Price, 0)  AS    
               ProductPriceTotal,    
               oi.OrderItemId,    
               ISNULL(cat.IsGPRSChipEmpty, 0) AS IsGPRSChipEmpty,    
               oi.CategoryId,    
               oi.OrderItemStatusId ,   
               '' as ICCID,    
               '' as DataNo,
               '' as GPRSNo,   
              '' as  OptionName,
               '' as  OptionId ,
               '' as  SiteName,
               0 as IsFoc,
               0 as IsReplacement 
        FROM   Products p    
               INNER JOIN OrderItems oi    
                    ON  oi.ProductId = p.ProductId    
               LEFT JOIN OrderItemDetails oid    
                    ON  oid.OrderItemId = oi.OrderItemId    
                    LEFT JOIN Options o ON o.OptID=oid.OptionId    
               LEFT JOIN Category cat    
                    ON  cat.CategoryId = oi.CategoryId    
        WHERE  oi.OrderId = @OrderId   
		AND p.ProductType= 'Ancillary' 
           
           
			 
        ORDER BY    
               p.ProductCode    
            
         
    END    
END TRY                       
BEGIN CATCH    
    EXEC USP_SaveSPErrorDetails     
    RETURN -1    
END CATCH 


