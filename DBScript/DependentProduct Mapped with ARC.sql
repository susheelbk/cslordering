
IF  EXISTS ( SELECT 1 FROM sys.procedures WHERE name LIKE 'USP_SaveOrderItems') 
BEGIN
DROP PROC  USP_SaveOrderItems
END
GO  

CREATE PROCEDURE [dbo].[USP_SaveOrderItems] 
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

IF  EXISTS ( SELECT 1 FROM sys.procedures WHERE name LIKE 'USP_GetProductsByCategoryAndArc') 
BEGIN
DROP PROC  USP_GetProductsByCategoryAndArc
END
GO  

CREATE PROCEDURE [dbo].[USP_GetProductsByCategoryAndArc]
	@CategoryId INT,
	@ARC_Id INT
AS
BEGIN TRY
    BEGIN
        SELECT t.ProductId,
               t.ProductCode,
               t.ProductName,
               t.DefaultImage,
               t.ProductType,
               CASE ISNULL(t.ARC_Price, 0)
                    WHEN 0 THEN t.Price
                    ELSE t.ARC_Price
               END AS Price,
               t.ListOrder,
               t.IsCSD,
               t.IsSiteName,
               t.IsReplenishment
        FROM   (
                   SELECT p.ProductId,
                          p.ProductCode,
                          p.ProductName,
                          p.DefaultImage,
                          p.ProductType,
                          p.Price,
                          ppm.Price AS ARC_Price,
                          p.ListOrder,
                          ISNULL(p.IsCSD, 0)IsCSD,
                          ISNULL(p.IsReplenishment,0) IsReplenishment,
                          ISNULL(p.IsSiteName,0 )IsSiteName
                   FROM   Products p
                          INNER JOIN Category_Product_Map cp
                               ON  cp.ProductId = p.ProductId
                               AND cp.CategoryId = @CategoryId
                          INNER JOIN Product_ARC_Map pam
                               ON  pam.ProductId = p.ProductId AND p.IsDependentProduct = 0 AND p.IsDeleted = 0 
                               AND pam.ARCId = @ARC_Id
                          LEFT JOIN ARC_Product_Price_Map ppm
                               ON  ppm.ProductId = p.ProductId AND ppm.IsDeleted = 0 AND CONVERT(DATETIME, GETDATE()) <= CONVERT(DateTime,ppm.ExpiryDate)
                  
               ) t
        ORDER BY
               t.ListOrder,
               t.ProductName
    END
END TRY         
BEGIN CATCH
    EXEC USP_SaveSPErrorDetails 
    RETURN -1
END CATCH


GO

IF  EXISTS ( SELECT 1 FROM sys.procedures WHERE name LIKE 'USP_GetProductsByArc') 
BEGIN
DROP PROC  USP_GetProductsByArc
END
GO  


CREATE PROCEDURE [dbo].[USP_GetProductsByArc]
	@ARC_Id INT
AS
BEGIN TRY
    BEGIN
        -- Select t.ProductId, t.ProductCode, t.ProductName,
        --t.ARC_Price  Price, t.ListOrder,  case ExpDate when '01/01/1900' then null else ExpDate end ExpDate
        --from
        --(Select p.ProductId, p.ProductCode, p.ProductName,  p.ProductType,
        --	 ppm.Price as ARC_Price, p.ListOrder,ISNULL(CONVERT(VARCHAR(10),ppm.ExpiryDate,101),CONVERT(VARCHAR(10), '01/01/1900 00:00:00.000',101)) ExpDate
        --	from
        --	Products p
        --	inner join
        --	Product_ARC_Map pam on pam.ProductId = p.ProductId And pam.ARCId = @ARC_Id
        --	left join
        --	ARC_Product_Price_Map ppm on ppm.ProductId = p.ProductId AND ppm.ARCId= @ARC_Id and ppm.IsDeleted=0
        
        --	Where p.IsDeleted=0 and p.IsDependentProduct=0
        --) t
        --Order By t.ListOrder
         DECLARE @temp TABLE(ProductId INT ,ProductCode NVARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS,
         ProductName NVARCHAR(512)COLLATE SQL_Latin1_General_CP1_CI_AS,
         ProductType NVARCHAR(10)COLLATE SQL_Latin1_General_CP1_CI_AS,ARC_Price DECIMAL(6,2),
         ListOrder INT,ExpDate DATETIME )
        
        
        INSERT   @temp
        SELECT p.ProductId,
               p.ProductCode,
               p.ProductName,
               p.ProductType,
               ppm.Price AS ARC_Price,
               p.ListOrder,
               ISNULL(
                   CONVERT(VARCHAR(10), ppm.ExpiryDate, 101),
                   CONVERT(VARCHAR(10), '01/01/1900 00:00:00.000', 101)
               ) ExpDate 
               
        FROM   Products p
               INNER JOIN Product_ARC_Map pam
                    ON  pam.ProductId = p.ProductId
                    AND pam.ARCId = @ARC_Id
               LEFT JOIN ARC_Product_Price_Map ppm
                    ON  ppm.ProductId = p.ProductId
                    AND ppm.ARCId = @ARC_Id
                    AND ppm.IsDeleted = 0
        WHERE  p.IsDeleted = 0
               AND p.IsDependentProduct = 0  
        
        
        SELECT t.ProductId,
               t.ProductCode,
               t.ProductName,
               t.ARC_Price Price,
               t.ListOrder,
               CASE ExpDate
                    WHEN '01/01/1900' THEN NULL
                    ELSE ExpDate
               END ExpDate
        FROM   (
                   SELECT p.ProductId,
                          p.ProductCode,
                          p.ProductName,
                          p.ProductType,
                          ppm.Price AS ARC_Price,
                          p.ListOrder,
                          ISNULL(
                              CONVERT(VARCHAR(10), ppm.ExpiryDate, 101),
                              CONVERT(VARCHAR(10), '01/01/1900 00:00:00.000', 101)
                          ) ExpDate
                   FROM   Product_Dependent_Map pdm
                          INNER JOIN @temp t 
                               ON  pdm.ProductId  = t.ProductId  
                          INNER JOIN Products p
                               ON  p.ProductId   = pdm.DependentProductId   
                          LEFT JOIN ARC_Product_Price_Map ppm
                               ON  ppm.ProductId   = p.ProductId   
                               AND ppm.ARCId   = @ARC_Id   
                               AND ppm.IsDeleted = 0
                   WHERE  p.IsDeleted = 0 
                   UNION
                   SELECT ProductId,
                          ProductCode,
                          ProductName,
                          ProductType,
                          ARC_Price,
                          ListOrder,
                          ExpDate
                   FROM   @temp   
               ) t
        
        
    END
    RETURN 0
END TRY
BEGIN CATCH
    EXEC USP_SaveSPErrorDetails
    RETURN -1
END CATCH

GO