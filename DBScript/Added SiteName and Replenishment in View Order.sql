
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
               oi.OrderItemStatusId    
               ,ISNULL(oid.ICCID, '')ICCID,    
               ISNULL(oid.DataNo, '')DataNo,
               ISNULL(oid.GPRSNo,'') GPRSNo,   
              ISNULL(o.OptionName,'') OptionName,
               ISNULL(oid .OptionId,0) OptionId,
               ISNULL(oid.SiteName  , '') SiteName,
               ISNULL(oi.IsReplenishmentEnabled,'') IsReplenishment
               
                
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
           cat.IsGPRSChipEmpty , oi.CategoryId, oi.OrderItemStatusId
            ,oid.ICCID,    
           oid.DataNo ,
           oid.GPRSNo,
           o.OptionName ,
			   oid .OptionId  ,oid.SiteName  ,oi.IsReplenishmentEnabled 
        ORDER BY    
               p.ProductCode    
            
         
    END    
END TRY                       
BEGIN CATCH    
    EXEC USP_SaveSPErrorDetails     
    RETURN -1    
END CATCH 
GO


IF  EXISTS ( SELECT 1 FROM sys.procedures WHERE name LIKE 'USP_GetBasketProductsOnPreviousOrders_Ordering') 
BEGIN
DROP PROC  USP_GetBasketProductsOnPreviousOrders_Ordering
END
GO
CREATE PROCEDURE [dbo].[USP_GetBasketProductsOnPreviousOrders_Ordering]     
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
               oi.IsReplenishmentEnabled IsReplenishment 
                
            
        FROM   Products p    
               INNER JOIN OrderItems oi    
                    ON  oi.ProductId = p.ProductId    
               LEFT JOIN OrderItemDetails oid    
                    ON  oid.OrderItemId = oi.OrderItemId   
               LEFT JOIN Category cat    
                    ON  cat.CategoryId = oi.CategoryId    
        WHERE  oi.OrderId = @OrderId    
        GROUP BY    
          
           p.ProductCode,p.IsCSD,oi.IsCSD,p.Message,p.ProductId,    
           p.ProductName,p.ProductType,oi.Price,ISNULL(oi.Price, 0) * ISNULL(oi.ProductQty, 0), oi.OrderItemId,    
           cat.IsGPRSChipEmpty , oi.CategoryId, oi.OrderItemStatusId,oi.IsReplenishmentEnabled
      
        ORDER BY    
               p.ProductCode    
            
         
    END    
END TRY                       
BEGIN CATCH    
    EXEC USP_SaveSPErrorDetails     
    RETURN -1    
END CATCH 
GO



IF  EXISTS ( SELECT 1 FROM sys.procedures WHERE name LIKE 'USP_GetOrderDetailsforReport') 
BEGIN
DROP PROC  USP_GetOrderDetailsforReport
END
GO
CREATE PROCEDURE USP_GetOrderDetailsforReport
	@OrderItemId INT
AS
BEGIN TRY
    BEGIN
        SELECT t1.OrderItemId,
               [t2].[GPRSNo],
               [t2].[PSTNNo],
               [t2].[GSMNo],
               [t2].[LANNo],
               [t2].[GPRSNoPostCode],
               [t2].[ICCID],
               [t4].[OrderStatus] AS [OrderItemStatus],
               [t3].[OptionName],
               t2.SiteName SiteName
               
        FROM   [dbo].[Orders] AS [t0]
               INNER JOIN [dbo].[OrderItems] AS [t1]
                    ON  [t0].[OrderId] = [t1].[OrderId]
               INNER JOIN [dbo].[OrderItemDetails] AS [t2]
                    ON  [t1].[OrderItemId] = [t2].[OrderItemId]
               LEFT JOIN [dbo].[Options] AS [t3]
                    ON  [t2].[OptionId] = ([t3].[OptID])
               INNER JOIN [dbo].[OrderStatusMaster] AS [t4]
                    ON  [t1].[OrderItemStatusId] = [t4].[OrderStatusId]
        WHERE  ([t1].[OrderItemId] = @OrderItemId)
               AND ([t2].[GPRSNo] <> '')
    END
END TRY

BEGIN CATCH
    EXEC USP_SaveSPErrorDetails 
    RETURN -1
END CATCH


GO
