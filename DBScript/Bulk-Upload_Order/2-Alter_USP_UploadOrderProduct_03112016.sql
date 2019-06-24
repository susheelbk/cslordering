
GO
/****** Object:  StoredProcedure [dbo].[USP_UploadOrderProduct]    Script Date: 11/07/2016 19:05:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==================================================================
--Author-----------------Mohd Atiq
--Modified On-------------03-11-2016
--Description-------------The purpose of this to upload the bulk products for the order.it was taking mutch time.
--And it was throwing session time out issue.  
--===================================================================
ALTER PROCEDURE  [dbo].[USP_UploadOrderProduct] --10,130764,1,'76500A81-A167-4C41-B52C-87CC39CB8704',0,0,'atiq.m'    
(      
   @ARC_Id int,      
   @OrderId int,      
   @IsARC_AllowReturns bit,      
   @UserId NVarchar(256) ,  
   @OptionId INT=0,
   @IsReplenishment BIT =0,
   @UserName varchar(256)     
)      
AS           
BEGIN TRY       
BEGIN
 DECLARE @ProductCode NVarchar(20)      
 DECLARE @GPRSChipNo NVarchar(50)      
 DECLARE @GPRSNoPostCode NVarchar(50)      
 DECLARE @PSTNNo NVARCHAR(50)  
 DECLARE @IsCSD BIT
 DECLARE @SiteName VARCHAR(256) 
 DECLARE @ProductType NVARCHAR(50)
 DECLARE @IsAncillary BIT
 DECLARE @IsValidGPRSChipPostCode BIT 
 DECLARE @Result NVarchar(256)      
 DECLARE @IsAnyDuplicate bit      
 
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
 DECLARE @GSMNo NVARCHAR(50)      
 DECLARE @LoopCounter INT = 0, @MaxUploadedId INT = 0
 SELECT @LoopCounter=MIN(ID),@MaxUploadedId= MAX(ID) FROM BulkUploadOrders 
 WHERE OrderId=@OrderId AND Result='Success'
 DECLARE @LoopStartCursor INT = 1, @MaxCursorCount INT = 1
 select @LoopCounter,@MaxUploadedId
CREATE TABLE #DependentProducts(
   ProductId int,
   ARC_Price DECIMAL(6,1)) 
 CREATE UNIQUE NONCLUSTERED INDEX IX_#DependentProducts_ProductId
 ON #DependentProducts (ProductId); 
WHILE(@LoopCounter <= @MaxUploadedId)
BEGIN
    select @LoopCounter,@MaxUploadedId
    SET @LoopStartCursor=0
    SET @MaxCursorCount=0
     SELECT @ProductCode=ProductCode,
          @GPRSChipNo=GPRSChipNo,
          @GPRSNoPostCode=GPRSChippostCode,
          @PSTNNo=Ident,  
          @IsCSD= IsCSD,
          @SiteName=SiteName,
          @IsValidGPRSChipPostCode=IsValidGPRSChipPostCode,
          @GSMNo=GSMNo FROM BulkUploadOrders 
          WHERE ID = @LoopCounter AND OrderId=@OrderId           
       SET @DependentProductPriceTotal = 0 
       SET @ProductId=0
       SELECT @ProductId = ProductId FROM Products 
       WHERE ProductCode = @ProductCode AND IsDeleted = 0 
       SELECT TOP 1 @CategoryId = cpm.CategoryId, 
                    @IsGPRSChipEmpty = cat.IsGPRSChipEmpty       
		   FROM Category_Product_Map cpm 
		   INNER JOIN Category cat ON  cat.CategoryId = cpm.CategoryId 
		   AND cpm.ProductId = @ProductId ORDER BY IsGPRSChipEmpty    
	        
	        INSERT INTO #DependentProducts (ProductId, ARC_Price)    
			SELECT t.ProductId, CASE ISNULL(t.ARC_Price,0) WHEN 0 THEN t.Price ELSE t.ARC_Price END AS Price      
			FROM  (SELECT p.ProductId, p.Price, ppm.Price AS ARC_Price      
			 FROM Products p LEFT JOIN ARC_Product_Price_Map ppm 
			 ON ppm.ProductId = p.ProductId AND
			 DATEDIFF(d,ISNULL(ppm.ExpiryDate,GETDATE()),GETDATE())>0 AND ppm.IsDeleted=0      
			 WHERE p.IsDeleted=0 AND p.ProductId IN (SELECT pdm.DependentProductId FROM 
			 Product_Dependent_Map pdm WHERE pdm.ProductId = @ProductId))t
			 		
		    SELECT @LoopStartCursor=MIN(ProductId),@MaxCursorCount=MAX(ProductId) 
			FROM #DependentProducts
		    SET @ProductPrice = (SELECT CASE ISNULL(t.ARC_Price,0) WHEN 0 THEN t.Price 
				   ELSE t.ARC_Price END AS Price FROM
				 (SELECT p.ProductId, p.Price,ppm.Price AS ARC_Price      
					   FROM Products p LEFT JOIN ARC_Product_Price_Map ppm 
					   ON  ppm.ProductId = p.ProductId 
					   AND DATEDIFF(d,isnull(ppm.ExpiryDate,getdate()),GETDATE())>0 
					   AND ppm.IsDeleted=0 WHERE p.IsDependentProduct = 0 
					   AND p.IsDeleted=0 AND p.ProductId = @ProductId      
					  )t)              
					  IF  @ProductPrice IS Null       
					  BEGIN      
					       SET @ProductPrice = 0      
					  END
		    
			    SET @OrderItemId=0
			    SELECT @OrderItemId = OrderItemId FROM OrderItems WHERE OrderId = @OrderId 
					AND ProductId = @ProductId AND CategoryId = @CategoryId
			    
		      IF (@OrderItemId =0 OR @OrderItemId IS NULL)      
				BEGIN --IF Start @OrderItemId
				select 		@LoopCounter as counters		   
				INSERT INTO OrderItems(OrderId,ProductId,ProductQty,Price,OrderItemStatusId,CreatedOn,CreatedBy,ModifiedOn,ModifiedBy,CategoryId,IsReplenishment,IsCSD)      
				VALUES(@OrderId,@ProductId,1,@ProductPrice,1,GETDATE(),@UserId,GETDATE(),@UserId,@CategoryId,@IsReplenishment,@IsCSD)      
	            SELECT @OrderItemId = SCOPE_IDENTITY()	            
	            WHILE(@LoopStartCursor <= @MaxCursorCount)
                BEGIN 
                SELECT  @DependentProductId=ProductId,
					     @DependentProductPrice=ARC_Price
					     FROM #DependentProducts 
					  WHERE ProductId = @LoopStartCursor					  
					  SET @DependentProductPriceTotal = @DependentProductPriceTotal + @DependentProductPrice      
					  IF Exists(SELECT OrderDependentId FROM OrderDependentItems WHERE OrderId = @OrderId 
					  And ProductId = @DependentProductId)      
					  BEGIN      
					   Update OrderDependentItems SET ProductQty = ProductQty + 1      
						 ,Price = @DependentProductPrice      
						    WHERE  OrderId = @OrderId      
						           And ProductId = @DependentProductId      
					  END      
					  ELSE      
					   BEGIN 
					   INSERT INTO OrderDependentItems(OrderId, OrderItemId, ProductId, ProductQty, Price)      
							  VALUES(@OrderId, @OrderItemId, @DependentProductId, 1, @DependentProductPrice)      
					   
					   END 
					   SET @LoopStartCursor  = @LoopStartCursor+1         
					  
                  END                 
                     DELETE FROM #DependentProducts                                  
                     UPDATE Orders SET OrderDate = GETDATE(),
					 Amount = Amount + @ProductPrice + @DependentProductPriceTotal,
					 ModifiedOn = GETDATE(),
					 ModifiedBy = @UserId      
					 WHERE OrderId = @OrderId 
					 INSERT INTO OrderItemDetails(OrderItemId, GPRSNo,GSMNo, ModifiedOn, ModifiedBy, GPRSNoPostCode,PSTNNo,OptionId,SiteName)      
					 VALUES (@OrderItemId, @GPRSChipNo,@GSMNo, GETDATE(), @UserId, @GPRSNoPostCode,@PSTNNo,@OptionId,@SiteName)      
					 SET @LoopCounter  = @LoopCounter  + 1                 
	            END  --IF END @OrderItemId   
	            ELSE --ELSE Start @OrderItemId 
	            BEGIN
					IF @IsARC_AllowReturns = 1 --IF START @IsARC_AllowReturns     
					BEGIN 
					 select 1
					      INSERT INTO OrderItemDetails(OrderItemId, GPRSNo,GSMNo, ModifiedOn, ModifiedBy, GPRSNoPostCode,PSTNNo,OptionId,SiteName)      
							  VALUES (@OrderItemId, @GPRSChipNo,@GSMNo, GETDATE(), @UserId, @GPRSNoPostCode,@PSTNNo,@OptionId,@SiteName)      
							  SELECT @OrderItemDetailId = SCOPE_IDENTITY() 
                          
                           UPDATE  OrderItems      
							 SET  ProductQty = ProductQty + 1,      
							 Price = @ProductPrice,      
							 ModifiedOn = GETDATE(),                                                                                                                                                                                              
							 ModifiedBy = @UserId,      
							 CategoryId = @CategoryId      
							WHERE	 OrderId = @OrderId And ProductId = @ProductId       
					                 And CategoryId = @CategoryId 
					
					       SELECT @LoopStartCursor=MIN(ProductId),
					              @MaxCursorCount=MAX(ProductId) FROM #DependentProducts
					              
					       WHILE(@LoopStartCursor <= @MaxCursorCount)--START WHILE LOOP FOR DEPENDENR PRODUCT ITEMS
                           BEGIN
						         SELECT  @DependentProductId=ProductId,
						                 @DependentProductPrice=ARC_Price
						                           FROM #DependentProducts 
						          WHERE ProductId = @LoopStartCursor 
						  
						  SET @DependentProductPriceTotal = @DependentProductPriceTotal + @DependentProductPrice      
						  IF Exists (SELECT OrderDependentId FROM OrderDependentItems WHERE OrderId = @OrderId And ProductId = @DependentProductId)      
						  BEGIN      
						   UPDATE OrderDependentItems SET ProductQty = ProductQty + 1      
							      ,Price = @DependentProductPrice      
							       WHERE OrderId = @OrderId AND 
							             ProductId = @DependentProductId      
						  END      
						  ELSE      
						   BEGIN 
						   INSERT INTO OrderDependentItems (OrderId, OrderItemId, ProductId, ProductQty, Price)      
								  VALUES(@OrderId, @OrderItemId, @DependentProductId, 1, @DependentProductPrice)      
						   END  
						    SET @LoopStartCursor  = @LoopStartCursor+1  
                         END--END WHILE LOOP FOR DEPENDENR PRODUCT ITEMS 
                                                             
                         UPDATE Orders SET OrderDate = GETDATE(),
							  Amount = Amount + @ProductPrice + @DependentProductPriceTotal,
							  ModifiedOn = GETDATE(),
							  ModifiedBy = @UserId WHERE OrderId = @OrderId                          
                          SET @LoopCounter  = @LoopCounter  + 1                         
                          DELETE FROM #DependentProducts
					
					END --IF END @IsARC_AllowReturns 
					ELSE --ELSE START @IsARC_AllowReturns
					BEGIN
					     select 0
					     INSERT INTO OrderItemDetails(OrderItemId,GPRSNo,GSMNo,ModifiedOn,ModifiedBy,
					          GPRSNoPostCode,PSTNNo,OptionId,SiteName)      
                              VALUES(@OrderItemId,@GPRSChipNo,@GSMNo,GETDATE(),@UserId,
                               @GPRSNoPostCode,@PSTNNo,@OptionId,@SiteName)              
                          SELECT @OrderItemDetailId = SCOPE_IDENTITY()                
                          
                          UPDATE OrderItems      
								SET ProductQty = ProductQty + 1,      
								 Price = @ProductPrice,      
								 ModifiedOn = GETDATE(),      
								 ModifiedBy = @UserId,      
								 CategoryId = @CategoryId      
								 WHERE   OrderId = @OrderId 
										AND ProductId = @ProductId       
										AND CategoryId = @CategoryId  
						  SELECT @LoopStartCursor=MIN(ProductId),
						          @MaxCursorCount=MAX(ProductId) FROM #DependentProducts
						        
						  WHILE(@LoopStartCursor <= @MaxCursorCount)--START WHILE LOOP FOR DEPENDENR PRODUCT ITEMS
						  BEGIN
						  SELECT  @DependentProductId=ProductId,
								  @DependentProductPrice=ARC_Price
								  FROM #DependentProducts 
								  WHERE ProductId = @LoopStartCursor 					  
								  SET @DependentProductPriceTotal = @DependentProductPriceTotal + @DependentProductPrice      
								  IF EXISTS(SELECT OrderDependentId FROM OrderDependentItems WHERE OrderId = @OrderId And ProductId = @DependentProductId)      
								  BEGIN      
								   UPDATE OrderDependentItems      
									SET ProductQty = ProductQty + 1      
									 , Price = @DependentProductPrice      
									WHERE OrderId = @OrderId      
									  And ProductId = @DependentProductId      
								  END      
								  ELSE      
								   BEGIN 
								   INSERT INTO OrderDependentItems (OrderId, OrderItemId, ProductId, ProductQty, Price)      
										  VALUES(@OrderId, @OrderItemId, @DependentProductId, 1, @DependentProductPrice)      
								   END  
								   SET @LoopStartCursor  = @LoopStartCursor+1          
								  
						   END--END WHILE LOOP FOR DEPENDENR PRODUCT ITEMS						   
					       UPDATE Orders SET OrderDate = GETDATE(),      
								 Amount = Amount + @ProductPrice + @DependentProductPriceTotal,
								 ModifiedOn = GETDATE(),
								 ModifiedBy = @UserId  WHERE OrderId = @OrderId						    
							     SET @LoopCounter  = @LoopCounter  + 1  
							     
					END  
	            END--ELSE END @OrderItemId	 
			  DELETE FROM #DependentProducts	    		      
 END --END while Loop
 DROP Table #DependentProducts
 DELETE FROM BulkUploadOrders WHERE OrderId=@OrderId
END  
END TRY      
BEGIN CATCH      
EXEC USP_SaveSPErrorDetails      
RETURN -10        
END CATCH
