
CREATE PROCEDURE  [dbo].[USP_UploadOrderProduct]      
(      
 @ProductCode NVarchar(20),      
 @GPRSChipNo NVarchar(50),      
 @GPRSNoPostCode NVarchar(50),      
 @ARC_Id int,      
 @OrderId int,      
 @IsARC_AllowReturns bit,      
 @UserId NVarchar(256) ,  
 @PSTNNo NVARCHAR(50),  
 @OptionId INT=0,
 @Sitename VARCHAR(256)
  
)      
AS      
BEGIN TRY       
BEGIN      
 Declare @ProductId int      
 Declare @CategoryId int      
 Declare @IsGPRSChipEmpty bit      
 Declare @ProductPrice Decimal(6,2)      
 Declare @OrderItemDetailId int      
 Declare @OrderItemId int      
 Declare @DependentProductId int      
 Declare @DependentProductPrice Decimal(6,2)      
 Declare @DependentProductPriceTotal Decimal(6,2)      
 Declare @DependentOrderItemId int      
 DECLARE @GetDependentProducts CURSOR      
      
 Select @ProductId = ProductId From Products Where ProductCode = @ProductCode And IsDeleted = 0      
 Set @DependentProductPriceTotal = 0      
       
 DECLARE @Result NVarchar(256)      
 DECLARE @IsAnyDuplicate bit      
 Set @Result = 'Error - some logic is missing.'      
 Set @IsAnyDuplicate = 0      
      
 IF @ProductId IS NULL      
  BEGIN      
   Set @Result = 'Product does not exist in the System.'      
  END      
 ELSE IF Not Exists (Select Product_ARC_MapId From Product_ARC_Map Where ProductId = @ProductId AND ARCId = @ARC_Id)      
  BEGIN      
   Set @Result = 'ARC not allowed to order this product.'      
  END      
 ELSE      
  BEGIN      
   Select Top 1 @CategoryId = cpm.CategoryId, @IsGPRSChipEmpty = cat.IsGPRSChipEmpty       
   From       
   Category_Product_Map cpm      
   Inner Join       
   Category cat on cat.CategoryId = cpm.CategoryId AND cpm.ProductId = @ProductId      
   Order by IsGPRSChipEmpty      
      
   IF @IsGPRSChipEmpty = 0 AND @GPRSChipNo = ''      
    BEGIN      
     Set @Result = 'Empty Chip Number is not allowed'      
    END      
   ELSE      
    BEGIN      
     SET @ProductPrice = (Select case IsNull(t.ARC_Price,0) when 0 then t.Price else t.ARC_Price end as Price      
           from      
           (Select p.ProductId, p.Price, ppm.Price as ARC_Price      
           from       
           Products p           
           left join      
           ARC_Product_Price_Map ppm on ppm.ProductId = p.ProductId and DATEDIFF(d,isnull(ppm.ExpiryDate,getdate()),GETDATE())>0 And ppm.IsDeleted=0       
           Where p.IsDependentProduct = 0 And p.IsDeleted=0 And p.ProductId = @ProductId      
          ) t )      
                
     IF  @ProductPrice IS Null       
      BEGIN      
       SET @ProductPrice = 0      
      END          
      
     Select @OrderItemId = OrderItemId From OrderItems Where OrderId = @OrderId And ProductId = @ProductId And CategoryId = @CategoryId      
     IF @OrderItemId Is Null      
      BEGIN      
       Insert Into OrderItems (OrderId, ProductId, ProductQty, Price, OrderItemStatusId, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy, CategoryId)      
           Values(@OrderId, @ProductId, 1, @ProductPrice, 1, GETDATE(), @UserId, GETDATE(), @UserId, @CategoryId)      
             
       Select @OrderItemId = SCOPE_IDENTITY()      
                 
       SET @GetDependentProducts = CURSOR FOR      
       SELECT t.ProductId, CASE IsNull(t.ARC_Price,0) WHEN 0 THEN t.Price ELSE t.ARC_Price END AS Price      
        FROM      
        (SELECT p.ProductId, p.Price, ppm.Price AS ARC_Price      
         FROM Products p      
         left join      
         ARC_Product_Price_Map ppm ON ppm.ProductId = p.ProductId and DATEDIFF(d,isnull(ppm.ExpiryDate,getdate()),GETDATE())>0 And ppm.IsDeleted=0      
         WHERE p.IsDeleted=0 and p.ProductId in      
          (SELECT pdm.DependentProductId FROM Product_Dependent_Map pdm WHERE pdm.ProductId = @ProductId)      
        ) t      
      
       OPEN @GetDependentProducts      
            
   FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice      
       WHILE @@FETCH_STATUS = 0      
        BEGIN       
         SET @DependentProductPriceTotal = @DependentProductPriceTotal + @DependentProductPrice      
                  
         INSERT INTO OrderDependentItems (OrderId, OrderItemId, ProductId, ProductQty, Price)      
              VALUES(@OrderId, @OrderItemId, @DependentProductId, 1, @DependentProductPrice)      
         FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice       
        END      
      
       CLOSE @GetDependentProducts      
       DEALLOCATE @GetDependentProducts      
             
       Update Orders Set OrderDate = GETDATE()      
            , Amount = Amount + @ProductPrice + @DependentProductPriceTotal      
            , ModifiedOn = GETDATE()      
            , ModifiedBy = @UserId      
           Where OrderId = @OrderId      
             
       Insert into OrderItemDetails(OrderItemId, GPRSNo, ModifiedOn, ModifiedBy, GPRSNoPostCode,PSTNNo,OptionId,SiteName)      
            Values (@OrderItemId, @GPRSChipNo, GETDATE(), @UserId, @GPRSNoPostCode,@PSTNNo,@OptionId,@Sitename)      
             
       Set @Result = 'Success'      
      END      
     ELSE      
      BEGIN      
       IF @IsARC_AllowReturns = 1      
        BEGIN      
         IF @GPRSChipNo != '' And Exists (Select OrderItemDetailId From OrderItemDetails Where GPRSNo = @GPRSChipNo)      
          BEGIN      
           Set @IsAnyDuplicate = 1      
          END      
                
           Insert into OrderItemDetails(OrderItemId, GPRSNo, ModifiedOn, ModifiedBy, GPRSNoPostCode,PSTNNo,OptionId,Sitename)      
                Values (@OrderItemId, @GPRSChipNo, GETDATE(), @UserId, @GPRSNoPostCode,@PSTNNo,@OptionId,@Sitename)      
               
           Select @OrderItemDetailId = SCOPE_IDENTITY()      
                 
           Update OrderItems      
            Set ProductQty = ProductQty + 1,      
             Price = @ProductPrice,      
             ModifiedOn = GETDATE(),      
             ModifiedBy = @UserId,      
             CategoryId = @CategoryId      
            Where       
             OrderId = @OrderId       
             And ProductId = @ProductId       
             And CategoryId = @CategoryId      
                   
                 
           SET @GetDependentProducts = CURSOR FOR      
           SELECT t.ProductId, CASE IsNull(t.ARC_Price,0) WHEN 0 THEN t.Price ELSE t.ARC_Price END AS Price      
            FROM      
            (SELECT p.ProductId, p.Price, ppm.Price AS ARC_Price      
             FROM Products p      
             left join      
             ARC_Product_Price_Map ppm ON ppm.ProductId = p.ProductId and DATEDIFF(d,isnull(ppm.ExpiryDate,getdate()),GETDATE())>0 And ppm.IsDeleted=0      
             WHERE p.IsDeleted=0 and p.ProductId in      
              (SELECT pdm.DependentProductId FROM Product_Dependent_Map pdm WHERE pdm.ProductId = @ProductId)      
            ) t      
      
           OPEN @GetDependentProducts      
                
           FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice      
           WHILE @@FETCH_STATUS = 0      
            BEGIN       
             SET @DependentProductPriceTotal = @DependentProductPriceTotal + @DependentProductPrice      
                   
             IF Exists (Select OrderDependentId From OrderDependentItems Where OrderId = @OrderId And ProductId = @DependentProductId)      
              BEGIN      
               Update OrderDependentItems      
                Set ProductQty = ProductQty + 1      
                 , Price = @DependentProductPrice      
                Where OrderId = @OrderId      
                  And ProductId = @DependentProductId      
              END      
             ELSE      
              BEGIN   
               Insert Into OrderDependentItems (OrderId, OrderItemId, ProductId, ProductQty, Price)      
                      VALUES(@OrderId, @OrderItemId, @DependentProductId, 1, @DependentProductPrice)      
              END      
             FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice       
          END      
      
           CLOSE @GetDependentProducts      
           DEALLOCATE @GetDependentProducts      
             
           Update Orders Set OrderDate = GETDATE()      
                , Amount = Amount + @ProductPrice + @DependentProductPriceTotal      
                , ModifiedOn = GETDATE()      
                , ModifiedBy = @UserId      
               Where OrderId = @OrderId      
                        
           Set @Result = 'Success'       
          END              
       ELSE      
        BEGIN                  
         IF @GPRSChipNo != '' And Exists (Select OrderItemDetailId From OrderItemDetails Where GPRSNo = @GPRSChipNo)      
          BEGIN      
           Set @Result = 'Duplicate Chip Number is not allowed.'      
          END      
         ELSE      
          BEGIN      
           Insert into OrderItemDetails(OrderItemId, GPRSNo, ModifiedOn, ModifiedBy, GPRSNoPostCode,PSTNNo,OptionId,SiteName)      
                Values (@OrderItemId, @GPRSChipNo, GETDATE(), @UserId, @GPRSNoPostCode,@PSTNNo,@OptionId,@Sitename)      
               
           Select @OrderItemDetailId = SCOPE_IDENTITY()      
                 
           Update OrderItems      
            Set ProductQty = ProductQty + 1,      
             Price = @ProductPrice,      
             ModifiedOn = GETDATE(),      
             ModifiedBy = @UserId,      
             CategoryId = @CategoryId      
            Where       
             OrderId = @OrderId       
             And ProductId = @ProductId       
             And CategoryId = @CategoryId      
                   
                 
           SET @GetDependentProducts = CURSOR FOR      
           SELECT t.ProductId, CASE IsNull(t.ARC_Price,0) WHEN 0 THEN t.Price ELSE t.ARC_Price END AS Price      
            FROM      
            (SELECT p.ProductId, p.Price, ppm.Price AS ARC_Price      
             FROM Products p      
             left join      
             ARC_Product_Price_Map ppm ON ppm.ProductId = p.ProductId and DATEDIFF(d,isnull(ppm.ExpiryDate,getdate()),GETDATE())>0 And ppm.IsDeleted=0      
             WHERE p.IsDeleted=0 and p.ProductId in      
              (SELECT pdm.DependentProductId FROM Product_Dependent_Map pdm WHERE pdm.ProductId = @ProductId)      
            ) t      
      
           OPEN @GetDependentProducts      
                
           FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice      
           WHILE @@FETCH_STATUS = 0      
            BEGIN       
             SET @DependentProductPriceTotal = @DependentProductPriceTotal + @DependentProductPrice      
                   
             IF Exists (Select OrderDependentId From OrderDependentItems Where OrderId = @OrderId And ProductId = @DependentProductId)      
              BEGIN      
               Update OrderDependentItems      
                Set ProductQty = ProductQty + 1      
                 , Price = @DependentProductPrice      
                Where OrderId = @OrderId      
                  And ProductId = @DependentProductId      
              END      
             ELSE      
              BEGIN      
               Insert Into OrderDependentItems (OrderId, OrderItemId, ProductId, ProductQty, Price)      
                      VALUES(@OrderId, @OrderItemId, @DependentProductId, 1, @DependentProductPrice)      
              END      
             FETCH NEXT FROM @GetDependentProducts INTO @DependentProductId, @DependentProductPrice       
            END      
      
           CLOSE @GetDependentProducts      
           DEALLOCATE @GetDependentProducts      
             
           Update Orders Set OrderDate = GETDATE()      
                , Amount = Amount + @ProductPrice + @DependentProductPriceTotal      
                , ModifiedOn = GETDATE()      
                , ModifiedBy = @UserId      
               Where OrderId = @OrderId      
                        
           Set @Result = 'Success'      
          END              
        END      
      END       
    END      
  END       
       
 Select @Result as [ResultMessage], @IsAnyDuplicate as [IsAnyDuplicate]       
END      
END TRY       
BEGIN CATCH      
EXEC USP_SaveSPErrorDetails      
RETURN -1        
END CATCH 

