GO
/****** Object:  StoredProcedure [dbo].[USP_BulkUploadMultipleOrders]    Script Date: 02/08/2017 16:24:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================
--Author-----------------Mohd Atiq
--Created On-------------04-09-2016
--Description-------------The purpose of this stored procedure to upload multiple orders from excel sheet.
ALTER PROCEDURE [dbo].[USP_BulkUploadMultipleOrders] --10,'atiq.m','testemail','76500A81-A167-4C41-B52C-87CC39CB8704',1
(   
   @ARC_Id int,        
   @UserName varchar(256),    
   @UserEmail varchar(256),    
   @UserId nvarchar(256),
   @HasUserAcceptedDuplicates BIT
)      
AS           
	BEGIN TRY       
	 BEGIN	
	    Declare @OrderNo int 
		Declare @ARC_Code varchar(256)    
		Declare @ARC_Email varchar(256)    
		Declare @ARC_BillingAccountNo varchar(256)    
		DECLARE @ProductId   INT 
		DECLARE @ProductCode NVARCHAR(20)
		DECLARE @CreatedBy nvarchar(256) 
	    DECLARE @MinId INT = 1, @MaxId INT = 1
		DECLARE @ExcelOrderId VARCHAR(100)
		DECLARE @PreviousOrderId VARCHAR(100) 
		DECLARE @NewOrderId INT
		--Save Order Items----------
		DECLARE @OrderItemId INT            
        DECLARE @OrderItemTotalPrice DECIMAL(8, 2)            
        DECLARE @Price DECIMAL(8, 2)            
        DECLARE @OrderItemPrice DECIMAL(8, 2)            
        DECLARE @OldOrderDependentItemPrice DECIMAL(8, 2)             
        DECLARE @DependentProductId INT            
        DECLARE @DependentProductPrice DECIMAL(8, 2)            
        DECLARE @DependentProductPriceTotal DECIMAL(8, 2)
        DECLARE @CategoryId  INT
        DECLARE @ProductQty  INT
        DECLARE @GPRSNo NVarchar(50)
        DECLARE @GPRSNOPostCode NVarchar(50)
        DECLARE @PostCode NVarchar(50)
        DECLARE @AddressId INT
        DECLARE @InstallationAddressId INT
        DECLARE @CompanyName NVARCHAR(256)
        DECLARE @FirstName NVARCHAR(512)
        DECLARE @LastName NVARCHAR(512)
        DECLARE @AddressOne NVARCHAR(100)
        DECLARE @AddressTwo NVARCHAR(100)
        DECLARE @Town NVARCHAR(100)
        DECLARE @County NVARCHAR(100)
        DECLARE @Email NVARCHAR(256)
        DECLARE @Fax NVARCHAR(50)
        DECLARE @Telephone NVARCHAR(50)
        DECLARE @Mobile NVARCHAR(50)
        DECLARE @Country NVARCHAR(256)
        DECLARE @CountryId INT
        DECLARE @ContactName NVARCHAR(256)
        DECLARE @OrderAmount Decimal(9,2)  
	    DECLARE @OrderTotalAmount Decimal(9,2)  
	    DECLARE @OrderRefNo NVarchar(256)  
        DECLARE @DeliveryCost Decimal(6,2)
        DECLARE @VATRate Decimal(6,3)
        DECLARE @Result NVarchar(256)      
        DECLARE @IsAnyDuplicate bit 
        DECLARE @PSTNNo NVARCHAR(50) 
        DECLARE @IsValidGPRSChipPostCode BIT 
        DECLARE @IsCSD BIT 
        DECLARE @InstallerCode VARCHAR(100)
	    DECLARE @InstallerUnqCode VARCHAR(50)
	    DECLARE @SALESREP VARCHAR(10) 
	    DECLARE @InstallerId VARCHAR(256) 
	    DECLARE @CustomerFullName VARCHAR(1000)
	    DECLARE @CustomerName VARCHAR(250)
	    DECLARE @SiteName VARCHAR(256)
	    --Below is the new chnages for customer name field and installer address
	    DECLARE @Pos INT
		DECLARE @Len INT
		DECLARE @Value varchar(8000)
		DECLARE @Count INT
		DECLARE @InstallationAddressOne VARCHAR(100)
		DECLARE @InstallationAddressTwo VARCHAR(100)
		DECLARE @InstallationTown VARCHAR(100)
		 --End is the new chnages for customer name field and installer address
		 
	    DECLARE @LoopStartCursor INT = 1, @MaxCursorCount INT = 1
        Set @Result = 'Error - some logic is missing.' 
		--End Save Order Items------
		SET @NewOrderId=0
		SET @PreviousOrderId=''
		SET @ProductId=0
		SET @CreatedBy=@UserName
		SET @ProductQty=1
		SET @AddressId=0
		SET @ContactName=''
		SET @OrderRefNo=''
		SET @DeliveryCost=0
		SET @VATRate=0
		
		SET @Pos = 0
		SET @Len = 0
		SET @Count = 0
		SET @InstallationAddressOne=''
		CREATE TABLE #TempBulkUploadMultipleOrders(
		[SNO] [int],
		[ID] [int] NULL,
		[OrderId] [nvarchar](256) NULL,
		[RedcareChipNumber] [nvarchar](50) NULL,
		[CustomerName] [nvarchar](256) NULL,
		[GPRSNOPostCode] [nvarchar](50) NULL,
		[RedCareType] [nvarchar](256) NULL,
		[DualComGradeRequired] [nvarchar](20) NULL,
		[NewGPRSChipNo] [nvarchar](50) NULL,
		[CustomerOrderNo] [nvarchar](256) NULL,
		[SiteName] [varchar](256) NULL,
		[FirstName] [nvarchar](256) NULL,
		[LastName] [nvarchar](256) NULL,
		[AddressOne] [nvarchar](100) NULL,
		[AddressTwo] [nvarchar](100) NULL,
		[Town] [nvarchar](100) NULL,
		[County] [nvarchar](100) NULL,
		[PostCode] [nvarchar](50) NULL,
		[Email] [nvarchar](256) NULL,
		[Fax] [nvarchar](50) NULL,
		[Telephone] [nvarchar](50) NULL,
		[Mobile] [nvarchar](50) NULL,
		[Country] [nvarchar](256) NULL,
		[UploadedBy] [nvarchar](256) NULL,
		[UploadedOn] [datetime] NULL,
		[IsAnyDuplicate] [bit] NULL,
		[IsValidGPRSNoPostCode] [bit] NULL,
		[IsValidPostCode] [bit] NULL,
		[Result] [nvarchar](500) NULL
		)
	   IF(@HasUserAcceptedDuplicates=1)
        BEGIN 
        	INSERT INTO #TempBulkUploadMultipleOrders SELECT ROW_NUMBER() OVER (ORDER BY ID) AS SNo,*  FROM BulkUploadMultipleOrders 
			WHERE UploadedBy=@UserName AND Result='Success'
		END
		ELSE
		BEGIN
			INSERT INTO #TempBulkUploadMultipleOrders SELECT ROW_NUMBER() OVER (ORDER BY ID) AS SNo,* FROM BulkUploadMultipleOrders 
			WHERE UploadedBy=@UserName AND Result='Success' AND IsAnyDuplicate=0
		END
		 
		SELECT @MinId= MIN(SNO),@MaxId= MAX(SNO) FROM #TempBulkUploadMultipleOrders 
		WHERE UploadedBy=@UserName AND Result='Success'
		
		SELECT @MinId, @MaxId
		WHILE(@MinId<=@MaxId)
		BEGIN
			SET @ContactName=''
			SET @CustomerFullName=''
			SET @CustomerName=''
			SET @Pos = 0
		    SET @Len = 0
		    SET @Count = 0
		    SELECT @ExcelOrderId= ISNULL(OrderId,''),
			       @ProductCode=ISNULL(DualComGradeRequired,''),
			       @GPRSNo=NewGPRSChipNo,
			       @GPRSNOPostCode=GPRSNOPostCode,
			       @ContactName=ISNULL(CustomerName,''),
			       @CustomerFullName=ISNULL(CustomerName,''),
			       @SiteName=SiteName,
			       @OrderRefNo=ISNULL(CustomerOrderNo,''),
			       @AddressOne=AddressOne,
			       @AddressTwo=AddressTwo,
			       @Town=Town,
			       @County=County,
			       @Email=Email,
			       @Fax=Fax,
			       @Telephone=Telephone,
			       @Mobile=Mobile,
			       @Country=Country,
			       @FirstName=FirstName,
			       @LastName=LastName,
			       @PostCode=PostCode
			       FROM #TempBulkUploadMultipleOrders
			       WHERE SNO=@MinId
			
			
			IF(@PreviousOrderId <> @ExcelOrderId OR @ExcelOrderId='')--Creating Order Id			
			BEGIN			 
			 SELECT @ARC_Code = ARC_Code, @ARC_Email = ARC_Email, @ARC_BillingAccountNo = BillingAccountNo FROM ARC WHERE ARCId = @ARC_Id       
			 SELECT @OrderNo = IsNull(MAX(IsNull(Cast(OrderNo as Int), 1000)) + 1, 1001) FROM Orders   
			 WHERE OrderId > 89396 and OrderNo not in (  
			-- Accidentally the orderno was increased to 186533 from 86533 which resulted in orderno to go far ahead,   
			-- below must be avoided for new orders  
			'186578','186577','186576','186575','186574','186573','186572','186571','186570',
			'186569','186568','186567','186566','186565','186564','186563','186562','186561','186560','186559','186558','186557','186556','186555','186554',  
			'186553','186552','186551','186550','186549','186548','186547','186546','186545','186544','186543','186542','186541','186540',  
			'186539','186538','186537','186536','186535','186534','99007 ','99006 ','99005 ','99004 ','99003 ','99002 ','99001',
			'186608','186607','186606','186605','186604','186603','186602','186601','186600','186599','186598','186597','186596','186595','186594','186593',
			'186592','186591','186590','186589','186588','186609','186610','186611','186612','186613','186614'
			) 
			IF(@OrderNo = 186532)  
              SELECT @OrderNo = IsNull(MAX(IsNull(Cast(OrderNo as Int), 1000)) + 500, 1001) from Orders   
            IF @OrderNo Is Null    
            SET      @OrderNo = 100001    
            
       	    SELECT @InstallerCode = InstallerCode,@InstallerId=InstallerCompanyID,@SALESREP = SalesRep 
       	                               FROM Installer
		                               WHERE UniqueCode= @InstallerUnqCode
		 
            INSERT INTO Orders(OrderNo, OrderDate, Amount, DeliveryCost,
                      OrderStatusId, DeliveryAddressId,BillingAddressId,
                      OrderTotalAmount, DeliveryTypeId, ARCId,
                      ARC_Code,ARC_EmailId,ARC_BillingAccountNo,
                      UserName,UserEmail,CreatedBy,
                      CreatedOn,ModifiedBy,ModifiedOn,UserId,
                      InstallerId,InstallerCode,InstallerUnqCode)    
               VALUES (@OrderNo,GETDATE(),0,0, 21, 0,0, 0, 0,@ARC_Id,
                       @ARC_Code, @ARC_Email,@ARC_BillingAccountNo,@UserName,@UserEmail,
                       @CreatedBy, GETDATE(),@CreatedBy,GETDATE(),@UserId,
                       @InstallerId,@InstallerCode,@InstallerUnqCode)    
         
			  SET  @NewOrderId=CAST(SCOPE_IDENTITY() as int)
			  SET  @AddressId=0
              SELECT @CountryId=CountryId FROM CountryMaster where CountryName=@Country              
              SET @InstallationAddressId=0 
              SET @InstallationAddressOne=''
              SET @InstallationAddressTwo=''
              SET @InstallationTown=''
              
              IF(@FirstName IS NOT NULL AND @FirstName !='' AND @LastName IS NOT NULL AND @LastName !='') 
              BEGIN
                    SET @ContactName=@FirstName+' '+@LastName
              END
              
              select @CustomerFullName as custfullname,@MinId
              SET @CustomerFullName=@CustomerFullName+','
              IF(@CustomerFullName IS NOT NULL AND @CustomerFullName !='')
			  BEGIN	    
			      WHILE CHARINDEX(',', @CustomerFullName, @Pos+1)>0
					BEGIN
						SET @Len = CHARINDEX(',', @CustomerFullName, @Pos+1) - @Pos
						SET @Value = SUBSTRING(@CustomerFullName, @Pos, @Len)						
						IF(@Count=0)
						BEGIN
							SET @CustomerName=@Value							
						END
						IF(@Count=1)
						BEGIN
							SET @InstallationAddressOne=@Value							
						END
						IF(@Count=2)
						BEGIN
							SET @InstallationAddressTwo=@Value							
						END
						IF(@Count=3)
						BEGIN
							SET @InstallationTown=@Value							
						END
						SET @Count=@Count+1
						SET @Pos = CHARINDEX(',', @CustomerFullName, @Pos+@Len) +1
						
					END
				    INSERT INTO ADDRESS(CompanyName,ContactName,AddressOne,
						  AddressTwo,Town,PostCode,    
						  CreatedBy,CreatedOn,    
						  ModifiedBy,ModifiedOn    
						  )    
						VALUES(@CompanyName,@CustomerName,@InstallationAddressOne,
							 @InstallationAddressTwo,@InstallationTown,@GPRSNOPostCode,
							 @CreatedBy,GETDATE(),    
							 @CreatedBy,GETDATE())  
					
			        SET  @InstallationAddressId = SCOPE_IDENTITY()
                select @CustomerName as custname,@InstallationAddressOne,@InstallationAddressId,@MinId
              END
              IF(@AddressOne IS NOT NULL OR @AddressOne <> '')
              BEGIN
			  INSERT INTO ADDRESS(CompanyName,ContactName,AddressOne,AddressTwo,Town,County,    
									   PostCode,Email,Fax,Telephone,Mobile,Country,CountryId,
									   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn,FirstName,LastName    
									   )    
							 VALUES(@CompanyName,ISNULL(@ContactName,''),@AddressOne,@AddressTwo,@Town,@County,
									@PostCode,@Email,@Fax,@Telephone,@Mobile,@Country,@CountryId,
									@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),@FirstName,@LastName)
				  SET  @AddressId = SCOPE_IDENTITY()
			  END
			  --SET @ContactName=''
			  
			END--end creating order id
			SELECT @NewOrderId
			----Save Order Items----------------------------
			IF(@SiteName='' OR @SiteName IS NULL)
			 BEGIN
			      SET @SiteName=@CustomerName
			 END			 
			SELECT @CategoryId=CategoryId FROM dbo.Category_Product_Map 
	         WHERE ProductId=(SELECT ProductId FROM Products WHERE ProductCode=@ProductCode)           
	         SELECT @ProductId=ProductId from Products WHERE ProductCode=@ProductCode
	         
                   SELECT @ARC_Id = ARCId FROM   ARC_User_Map
                                 WHERE  UserId = @UserId   
                   SELECT @Price = CASE ISNULL(t.ARC_Price, 0)
                                   WHEN 0 THEN t.Price
                                   ELSE t.ARC_Price
                                   END FROM(SELECT p.ProductId,p.ProductCode,
                                   p.ProductName,p.DefaultImage,p.ProductType,
                                   p.Price,ppm.Price AS ARC_Price FROM Products p
                     LEFT JOIN ARC_Product_Price_Map ppm ON  ppm.ProductId = p.ProductId
                     AND ppm.ARCId = @ARC_Id
                     AND ppm.IsDeleted = 0 AND  CONVERT(DATETIME, GETDATE()) <= CONVERT(DateTime,ppm.ExpiryDate)
                                  WHERE  p.ProductId = @ProductId 
                        ) t            
        
            SET @OrderItemTotalPrice = @Price * @ProductQty 
            DECLARE @tempDependentProduct TABLE (ProductId INT,Price DECIMAL(6,2) )         
           -- Get product's dependent products into a temp table ---> 
            INSERT INTO  @tempDependentProduct (ProductId,Price)            
            SELECT t.ProductId,
                   CASE ISNULL(t.ARC_Price, 0)
                        WHEN 0 THEN t.Price
                        ELSE t.ARC_Price
                   END AS Price FROM(SELECT p.ProductId,p.Price,ppm.Price AS ARC_Price
                           FROM Products p
                              LEFT JOIN ARC_Product_Price_Map ppm
                              ON  ppm.ProductId = p.ProductId
							   AND ppm.ARCId = @ARC_Id --added by alex 11.03.2014 16:04 
                               AND ppm.IsDeleted = 0 AND  CONVERT(DATETIME, GETDATE()) <= CONVERT(DateTime,ppm.ExpiryDate)
                               WHERE  p.IsDeleted = 0  AND isnull(p.ListedonCSLConnect,0) = 0 
                                      AND p.ProductId IN (SELECT pdm.DependentProductId
                                      FROM   Product_Dependent_Map 
                                      pdm
                                      WHERE  pdm.ProductId = @ProductId)
                                   ) t 
            ---End temp table 
            SET @OrderItemId=0
            SELECT @OrderItemId = OrderItemId FROM OrderItems WHERE OrderId = @NewOrderId 
					AND ProductId = @ProductId AND CategoryId = @CategoryId
		    select @OrderItemId as ordertemid
		    IF (@OrderItemId =0 OR @OrderItemId IS NULL)
		    BEGIN
                       INSERT INTO OrderItems(OrderId,ProductId,
                                              ProductQty,Price,
                                              OrderItemStatusId,CreatedOn,
                                              CreatedBy,ModifiedOn,
                                              ModifiedBy,CategoryId,IsCSD)
                       VALUES (@NewOrderId,@ProductId,
                               1,@Price,
                               1,GETDATE(),
                               @CreatedBy,GETDATE(),
                               @CreatedBy,@CategoryId,@IsCSD)
                               
                               SET @OrderItemId = SCOPE_IDENTITY()            
            END
            ELSE
            BEGIN
              UPDATE  OrderItems      
							 SET  ProductQty = ProductQty + 1,      
							 Price = @Price,      
							 ModifiedOn = GETDATE(),                                                                                                                                                                                              
							 ModifiedBy = @CreatedBy,      
							 CategoryId = @CategoryId      
							WHERE	 OrderId = @NewOrderId 
							         And ProductId = @ProductId       
					                 And CategoryId = @CategoryId   
            END
            
             
            
            /* This code is added to include the dependent product details */            
            SET @DependentProductPriceTotal = 0 
            IF EXISTS ( SELECT 1 FROM   @tempDependentProduct)
            BEGIN
                SELECT @LoopStartCursor=MIN(ProductId),@MaxCursorCount=MAX(ProductId) 
			FROM @tempDependentProduct
				 WHILE(@LoopStartCursor <= @MaxCursorCount)
					BEGIN 
					SELECT  @DependentProductId=ProductId,
					        @DependentProductPrice=Price
					        FROM @tempDependentProduct 
					             WHERE ProductId = @LoopStartCursor					  
					  SET @DependentProductPriceTotal = @DependentProductPriceTotal + @DependentProductPrice      
					--SELECT @DependentProductPriceTotal=SUM(Price)* @ProductQty  FROM @tempDependentProduct
	                --INSERT INTO OrderDependentItems(OrderId,OrderItemId,ProductId,ProductQty,Price)
					--SELECT @NewOrderId,@OrderItemId,tdp.ProductId,@ProductQty,tdp.Price FROM @tempDependentProduct tdp
					IF Exists(SELECT OrderDependentId FROM OrderDependentItems WHERE OrderId = @NewOrderId 
					  And ProductId = @DependentProductId)      
					  BEGIN      
					   Update OrderDependentItems SET ProductQty = ProductQty + 1      
						 ,Price = @DependentProductPrice      
						    WHERE  OrderId = @NewOrderId      
						           And ProductId = @DependentProductId      
					  END      
					  ELSE      
					   BEGIN 
					   INSERT INTO OrderDependentItems(OrderId, OrderItemId, ProductId, ProductQty, Price)      
							  VALUES(@NewOrderId, @OrderItemId, @DependentProductId, 1, @DependentProductPrice)      
					   
					   END 
					   SET @LoopStartCursor  = @LoopStartCursor+1
					
					END
            END 
            /* end - dependent product details*/           
            UPDATE Orders
            SET    OrderDate = GETDATE(),
                   Amount = Amount + @OrderItemTotalPrice + @DependentProductPriceTotal,
                   ModifiedBy = @CreatedBy,
                   ModifiedOn = GETDATE(),
                   DeliveryAddressId=@AddressId,
                   InstallationAddressId=@InstallationAddressId,
                   HasUserAcceptedDuplicates=@HasUserAcceptedDuplicates,
                   OrderRefNo = @OrderRefNo
            WHERE  OrderId = @NewOrderId
            SET @OrderItemTotalPrice=0
            DELETE FROM @tempDependentProduct
            INSERT INTO OrderItemDetails(OrderItemId,GPRSNo, GPRSNoPostCode, ModifiedOn, ModifiedBy,SiteName)
		                 VALUES (@OrderItemId,@GPRSNo,@GPRSNoPostCode,GETDATE(),@CreatedBy,@SiteName)		                        
			-----End Save Order Items			
			SET @PreviousOrderId=@ExcelOrderId
			SET @MinId  = @MinId  + 1
		END --While loop End 
	      DROP TABLE #TempBulkUploadMultipleOrders
	      DELETE  FROM BulkUploadMultipleOrders WHERE UploadedBy=@CreatedBy      
		END --Main begin 
	 
	END TRY      
	BEGIN CATCH      
		EXEC USP_SaveSPErrorDetails      
		RETURN -10        
	END CATCH
	
	
	
	
	 