GO
/****** Object:  StoredProcedure [dbo].[USP_BulkUploadMultipleOrders]    Script Date: 11/03/2016 14:24:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================
--Author-----------------Mohd Atiq
--Created On-------------04-09-2016
--Description-------------The purpose of this stored procedure to upload multiple orders from excel sheet.
CREATE PROCEDURE [dbo].[USP_BulkUploadMultipleOrders] --10,'atiq.m','testemail','76500A81-A167-4C41-B52C-87CC39CB8704',0
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
		
		CREATE TABLE dbo.#TempBulkUploadMultipleOrders(
		[SNO] [int],
		[ID] [int] NULL,
		[OrderId] [nvarchar](20) NULL,
		[ProductCode] [nvarchar](20) NULL,
		[InstallerUniqueCode] [nvarchar](20) NULL,
		[GPRSChipNo] [nvarchar](50) NULL,
		[GPRSNOPostCode] [nvarchar](50) NULL,
		[SiteName] [varchar](256) NULL,
		[Ident] [nvarchar](50) NULL,
		[CompanyName] [nvarchar](256) NULL,
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
		[CreatedBy] [nvarchar](256) NULL,
		[UploadedOn] [datetime] NULL,
		[IsAnyDuplicate] [bit] NULL,
		[IsValidGPRSNoPostCode] [bit] NULL,
		[IsValidPostCode] [nchar](10) NULL,
		[Result] [nvarchar](500) NULL
		)
	
        IF(@HasUserAcceptedDuplicates=1)
        BEGIN 
        	INSERT INTO #TempBulkUploadMultipleOrders SELECT ROW_NUMBER() OVER (ORDER BY ID) AS SNo,*  FROM BulkUploadMultipleOrders 
			WHERE CreatedBy=@UserName AND Result='Success'
		END
		ELSE
		BEGIN
			INSERT INTO #TempBulkUploadMultipleOrders SELECT ROW_NUMBER() OVER (ORDER BY ID) AS SNo,*  FROM BulkUploadMultipleOrders 
			WHERE CreatedBy=@UserName AND Result='Success' AND IsAnyDuplicate=0
		END
		 
		SELECT @MinId= MIN(SNO),@MaxId= MAX(SNO) FROM #TempBulkUploadMultipleOrders 
		WHERE CreatedBy=@UserName AND Result='Success'
		
		WHILE(@MinId<=@MaxId)
		BEGIN
		    select @MinId
            SELECT @ExcelOrderId= ISNULL(OrderId,''),
			       @ProductCode=ISNULL(ProductCode,''),
			       @GPRSNo=GPRSChipNo,
			       @GPRSNOPostCode=GPRSNOPostCode,
			       @CompanyName=CompanyName,
			       @ContactName=FirstName+' '+LastName,
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
			       @PostCode=PostCode,
			       @PSTNNo=Ident,
			       @InstallerUnqCode=InstallerUniqueCode
			       FROM #TempBulkUploadMultipleOrders
			       WHERE SNO=@MinId
			
			IF(@PSTNNo !='' OR @PSTNNo IS NOT NULL)
			   SET @IsCSD=0
			ELSE
			   SET @IsCSD=1
			
			IF(@PreviousOrderId <> @ExcelOrderId)--Creating Order Id
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
			   
              
              SELECT @CountryId=CountryId FROM CountryMaster where CountryName=@Country
              IF(@ContactName IS NULL OR @ContactName = '' OR @AddressOne IS NULL OR @AddressOne = '')
              BEGIN
                   SELECT TOP 1 @CompanyName=CompanyName,
			       @ContactName=FirstName+' '+LastName,
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
			       FROM BulkUploadMultipleOrders WHERE OrderId=@ExcelOrderId 
			       AND FirstName IS NOT NULL 
			       AND LastName IS NOT NULL
			       AND AddressOne IS NOT NULL 
              END
              
			  INSERT INTO ADDRESS(CompanyName,ContactName,AddressOne,AddressTwo,Town,County,    
									   PostCode,Email,Fax,Telephone,Mobile,Country,CountryId,
									   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn,FirstName,LastName    
									   )    
							 VALUES(@CompanyName,ISNULL(@ContactName,''),@AddressOne,@AddressTwo,@Town,@County,
									@PostCode,@Email,@Fax,@Telephone,@Mobile,@Country,@CountryId,
									@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),@FirstName,@LastName)
				  SET  @AddressId = SCOPE_IDENTITY()
				  
				  
				  
			END--end creating order id
			SELECT @NewOrderId
			----Save Order Items----------------------------
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
            INSERT INTO OrderItems(OrderId,ProductId,ProductQty,Price,OrderItemStatusId,
                                    CreatedOn,CreatedBy,ModifiedOn,ModifiedBy,CategoryId,IsCSD)
                       VALUES (@NewOrderId,@ProductId,1,@Price,1,
                                GETDATE(),@CreatedBy,GETDATE(),@CreatedBy,@CategoryId,@IsCSD)            
            
            SET @OrderItemId = SCOPE_IDENTITY() 
            
            /* This code is added to include the dependent product details */            
            SET @DependentProductPriceTotal = 0 
            IF EXISTS ( SELECT 1 FROM   @tempDependentProduct )
            BEGIN
               
                SELECT @DependentProductPriceTotal=SUM(Price)* @ProductQty  FROM @tempDependentProduct
                INSERT INTO OrderDependentItems(OrderId,OrderItemId,ProductId,ProductQty,Price)
                SELECT @NewOrderId,@OrderItemId,tdp.ProductId,@ProductQty,tdp.Price FROM @tempDependentProduct tdp
            END 
            /* end - dependent product details*/           
            UPDATE Orders
            SET    OrderDate = GETDATE(),
                   Amount = Amount + @OrderItemTotalPrice + @DependentProductPriceTotal,
                   ModifiedBy = @CreatedBy,
                   ModifiedOn = GETDATE(),
                   DeliveryAddressId=@AddressId,
                   HasUserAcceptedDuplicates=@HasUserAcceptedDuplicates
            WHERE  OrderId = @NewOrderId
            SET @OrderItemTotalPrice=0
            DELETE FROM @tempDependentProduct
            INSERT INTO OrderItemDetails(OrderItemId,GPRSNo, GPRSNoPostCode, ModifiedOn, ModifiedBy)
		                 VALUES (@OrderItemId,@GPRSNo,@GPRSNoPostCode,GETDATE(),@CreatedBy)
		                        
			-----End Save Order Items			
			SET @PreviousOrderId=@ExcelOrderId
			SET @MinId  = @MinId  + 1
		END --While loop End 
		      DROP Table #TempBulkUploadMultipleOrders
		      DELETE  FROM BulkUploadMultipleOrders WHERE CreatedBy=@CreatedBy      
		END --Main begin 
	 
	END TRY      
	BEGIN CATCH      
		EXEC USP_SaveSPErrorDetails      
		RETURN -10        
	END CATCH
	
	
	
	
	 