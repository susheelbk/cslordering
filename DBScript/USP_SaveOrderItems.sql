USE [ARC_Ordering_LiveBeta]
GO

/****** Object:  StoredProcedure [dbo].[USP_SaveOrderItems]    Script Date: 12/03/2014 10:21:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[USP_SaveOrderItems] 
(
    @OrderId     INT,
    @ProductId   INT,
    @ProductQty  INT,
    @UserId      UNIQUEIDENTIFIER,
    @CreatedBy   VARCHAR(256),
    @CategoryId  INT
    
)
AS
BEGIN TRY
    BEGIN
        DECLARE @OrderItemId INT            
        DECLARE @OrderItemTotalPrice DECIMAL(8, 2)            
        DECLARE @Price DECIMAL(8, 2)            
        DECLARE @ARC_Id INT            
        DECLARE @OrderItemPrice DECIMAL(8, 2)            
        DECLARE @OrderItemQty INT              
        DECLARE @OldOrderDependentItemPrice DECIMAL(8, 2)             
        DECLARE @DependentProductId INT            
        DECLARE @DependentProductPrice DECIMAL(8, 2)            
        DECLARE @DependentProductPriceTotal DECIMAL(8, 2)            
                     
        
        SELECT @OrderItemQty = ProductQty
        FROM   OrderItems
        WHERE  OrderId = @OrderId
               AND ProductId = @ProductId
               AND CategoryId = @CategoryId          
        
        SET @OrderItemQty = ISNULL(@OrderItemQty, 0) 
        
        --IF @OrderItemQty != @ProductQty
        --BEGIN          
        SELECT @ARC_Id = ARCId
        FROM   ARC_User_Map
        WHERE  UserId = @UserId          
        
        SELECT @Price = CASE ISNULL(t.ARC_Price, 0)
                             WHEN 0 THEN t.Price
                             ELSE t.ARC_Price
                        END
        FROM   (
                   SELECT p.ProductId,
                          p.ProductCode,
                          p.ProductName,
                          p.DefaultImage,
                          p.ProductType,
                          p.Price,
                          ppm.Price AS ARC_Price
                   FROM   Products p
                          LEFT JOIN ARC_Product_Price_Map ppm ON  ppm.ProductId = p.ProductId
                               AND ppm.ARCId = @ARC_Id
                               AND ppm.IsDeleted = 0 AND  CONVERT(DATETIME, GETDATE()) <= CONVERT(DateTime,ppm.ExpiryDate)
                   WHERE  p.ProductId = @ProductId 
               ) t            
        
        SET @OrderItemTotalPrice = @Price * @ProductQty            
         
         DECLARE @tempDependentProduct TABLE (ProductId INT,Price DECIMAL(6,2) )
         
           -- Get product's dependent products into a temp table ---> 
            INSERT into  @tempDependentProduct (ProductId,Price)
            
            SELECT t.ProductId,
                   CASE ISNULL(t.ARC_Price, 0)
                        WHEN 0 THEN t.Price
                        ELSE t.ARC_Price
                   END AS Price 
                    
            FROM   (
                       SELECT p.ProductId,
                              p.Price,
                              ppm.Price AS ARC_Price
                       FROM   Products p
                              LEFT JOIN ARC_Product_Price_Map ppm
                                   ON  ppm.ProductId = p.ProductId
								   AND ppm.ARCId = @ARC_Id --added by alex 11.03.2014 16:04 
                                   AND ppm.IsDeleted = 0 AND  CONVERT(DATETIME, GETDATE()) <= CONVERT(DateTime,ppm.ExpiryDate)
                       WHERE  p.IsDeleted = 0  
                              AND p.ProductId IN (SELECT pdm.DependentProductId
                                                  FROM   Product_Dependent_Map 
                                                         pdm
                                                  WHERE  pdm.ProductId = @ProductId)
                   ) t 
            --<--- End temp table 
         
         
        IF NOT EXISTS (SELECT OrderItemId FROM   OrderItems WHERE  OrderId = @OrderId AND ProductId = @ProductId AND CategoryId = @CategoryId)
        BEGIN
     INSERT INTO OrderItems ( OrderId,ProductId,ProductQty,Price,OrderItemStatusId,CreatedOn,CreatedBy,ModifiedOn,ModifiedBy,CategoryId )
            VALUES ( @OrderId,@ProductId,@ProductQty,@Price,1,GETDATE(),@CreatedBy,GETDATE(),@CreatedBy,@CategoryId)            
            
            SELECT @OrderItemId = SCOPE_IDENTITY() 
            
            /* This code is added to include the dependent product details */            
            SET @DependentProductPriceTotal = 0 
            
            
          
            
            IF EXISTS ( SELECT 1 FROM   @tempDependentProduct )
            BEGIN
               
                SELECT @DependentProductPriceTotal=SUM(Price)* @ProductQty  FROM @tempDependentProduct
                
                INSERT INTO OrderDependentItems(OrderId,OrderItemId,ProductId,ProductQty,Price)
                SELECT @OrderId,@OrderItemId,tdp.ProductId,@ProductQty,tdp.Price FROM @tempDependentProduct tdp
            END 
            /* end - dependent product details*/               
          
            UPDATE Orders
            SET    OrderDate = GETDATE(),
                   Amount = Amount + @OrderItemTotalPrice + @DependentProductPriceTotal,
                   ModifiedBy = @CreatedBy,
                   ModifiedOn = GETDATE()
            WHERE  OrderId = @OrderId
        END
        ELSE
        BEGIN
            DECLARE @qty INT = 0; 
            
            -- get available qty from orderitems table       
            
            SELECT @qty = ProductQty
            FROM   OrderItems
            WHERE  OrderId = @OrderId
                   AND ProductId = @ProductId
                   AND CategoryId = @CategoryId        
            
            
            SELECT @OrderItemId = OrderItemId
            FROM   OrderItems
            WHERE  OrderId = @OrderId
                   AND ProductId = @ProductId
                   AND CategoryId = @CategoryId            
            
            SELECT @OrderItemPrice = ISNULL(Price, 0),
                   @OrderItemQty = ISNULL(ProductQty, 0)
            FROM   OrderItems
            WHERE  OrderId = @OrderId
                   AND ProductId = @ProductId          
            
            SET @OrderItemPrice = @OrderItemPrice * @OrderItemQty            
            
            UPDATE OrderItems
            SET    ProductQty = @ProductQty + @qty,
                   Price = @Price,
                   ModifiedOn = GETDATE(),
                   ModifiedBy = @CreatedBy,
                   CategoryId = @CategoryId
            WHERE  OrderId = @OrderId
                   AND ProductId = @ProductId
                   AND CategoryId = @CategoryId 
            
            /* This code is added to include the dependent product details */            
            SELECT @OldOrderDependentItemPrice = ISNULL(SUM(ISNULL(ProductQty, 0) * ISNULL(Price, 0)), 0)
            FROM   OrderDependentItems
            WHERE  OrderItemId = @OrderItemId          
            
            DELETE 
            FROM   OrderDependentItems
            WHERE  OrderItemId = @OrderItemId          
            
            SET @DependentProductPriceTotal = 0            
            
            IF EXISTS (SELECT 1 FROM  @tempDependentProduct )
            BEGIN 
                            
               SELECT @DependentProductPriceTotal=SUM(Price)* @ProductQty  FROM @tempDependentProduct 
                       
                INSERT INTO OrderDependentItems(OrderId,OrderItemId,ProductId,ProductQty,Price)
                SELECT @OrderId,@OrderItemId,tdp.ProductId,@ProductQty+ @qty,tdp.Price FROM @tempDependentProduct tdp
                      
              
            END 
            /* end - dependent product details*/                 
           
            
            UPDATE Orders
            SET    OrderDate = GETDATE(),
                   Amount = Amount + @OrderItemTotalPrice + @DependentProductPriceTotal,
                   ModifiedBy = @CreatedBy,
                   ModifiedOn = GETDATE()
            WHERE  OrderId = @OrderId
   END            
        
       --SELECT @OrderItemId AS [OrderItemId] 
            
    END
   -- DROP TABLE #tempDependentProduct
         SELECT OrderItemId FROM OrderItems WHERE OrderItemId=@OrderItemId 
END TRY             
BEGIN CATCH
    EXEC USP_SaveSPErrorDetails 
    RETURN -1
END CATCH 



GO

