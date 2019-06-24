GO
/****** Object:  StoredProcedure [dbo].[USP_BulkUploadMultipleOrderProducts]    Script Date: 02/07/2017 19:17:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================
--Author-----------------Mohd Atiq
--Created On-------------04-09-2016
--Description-------------The purpose of this stored procedure to upload multiple orders from excel sheet.
ALTER PROCEDURE [dbo].[USP_BulkUploadMultipleOrderProducts] --10,'atiq.m','testemail','76500A81-A167-4C41-B52C-87CC39CB8704'     
(   
   @ARC_Id int,        
   @UserName varchar(256),    
   @UserEmail varchar(256),    
   @UserId nvarchar(256)
)      
AS           
	BEGIN TRY       
	 BEGIN	
		DECLARE @ProductId   INT 
		DECLARE @ProductCode NVARCHAR(20)
		DECLARE @CreatedBy nvarchar(256) 
	    DECLARE @MinId INT = 1, @MaxId INT = 1
		DECLARE @ExcelOrderId VARCHAR(100)
		DECLARE @PreviousOrderId VARCHAR(100)      
        DECLARE @GPRSChipNo NVarchar(50)
        DECLARE @GPRSNOPostCode NVarchar(50) 
        DECLARE @PostCode NVarchar(50)     
        DECLARE @CompanyName NVARCHAR(512)
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
        DECLARE @ContactName NVARCHAR(256)
        DECLARE @Result NVarchar(256)      
        DECLARE @IsAnyDuplicate bit 
        DECLARE @PSTNNo NVARCHAR(50)
	    DECLARE @GroupOrderId VARCHAR(100) 
	    DECLARE @IsValidGPRSNoPostCode BIT
	    DECLARE @IsValidPostCode BIT
	    DECLARE @SiteName VARCHAR(256)
	    DECLARE @ProductCategory VARCHAR(256)
        Set @Result = 'Error-there is some issue.' 
		--End Save Order Items------
		SET @PreviousOrderId='No'
		SET @ProductId=0
		SET @CreatedBy=@UserName
		SET @ContactName=''
		SET @GroupOrderId=''
		SELECT @MinId= MIN(ID),@MaxId= MAX(ID) FROM BulkUploadMultipleOrders 
		WHERE UploadedBy=@UserName --AND OrderID  IS NOT NULL
		
		WHILE(@MinId<=@MaxId)
		BEGIN
		    Set @Result = 'Error-there is some issue.'
            SELECT @ExcelOrderId= ISNULL(OrderId,''),
			       @ProductCode=ISNULL(DualComGradeRequired,''),
			       @GPRSChipNo=NewGPRSChipNo,
			       @GPRSNOPostCode=GPRSNOPostCode,
			       @IsValidGPRSNoPostCode=@IsValidGPRSNoPostCode,			       
			       @ContactName=CustomerName,
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
			       @IsValidPostCode=IsValidPostCode,
			       @SiteName=SiteName
			       FROM BulkUploadMultipleOrders
			       WHERE ID=@MinId --AND OrderID  IS NOT NULL
			     
			   SELECT @ProductId = ProductId From Products Where ProductCode = @ProductCode And IsDeleted = 0   
			   
                SELECT Top 1 @ProductCategory=cat.CategoryName  FROM Category_Product_Map cpm 
                  INNER JOIN Category cat ON cat.CategoryId = cpm.CategoryId 
                  AND cpm.ProductId = @ProductId
                  
	           IF (@GPRSChipNo = '' OR  @GPRSChipNo IS NULL)
			    BEGIN
					SET @Result = 'New Chip Number is required'
					SET @IsAnyDuplicate = 0				
					UPDATE BulkUploadMultipleOrders SET UploadedBy=@UserName,
							UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,
							Result=@Result
					WHERE ID=@MinId
					SET @MinId  = @MinId  + 1				    
					CONTINUE
		        END
	            ELSE IF(@GPRSChipNo != '' AND (LEN(@GPRSChipNo) < 4 OR LEN(@GPRSChipNo)> 6))
			    BEGIN
					SET @Result = 'Invalid New Chip Number'
					SET @IsAnyDuplicate = 0				
					UPDATE BulkUploadMultipleOrders SET UploadedBy=@UserName,
							UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,
							Result=@Result
					WHERE ID=@MinId
					SET @MinId  = @MinId  + 1				    
					CONTINUE
		        END
		        ELSE IF(ISNUMERIC(@GPRSChipNo)=0)
					BEGIN
							SET @Result = 'Invalid New Chip Number'
							SET @IsAnyDuplicate = 0	
							SET @PreviousOrderId=@ExcelOrderId	
							UPDATE BulkUploadMultipleOrders SET UploadedBy=@UserName,
								   UploadedOn=GETDATE(),
								   IsAnyDuplicate=@IsAnyDuplicate,
								   Result=@Result
								   WHERE ID=@MinId
						SET @MinId  = @MinId  + 1			        
						CONTINUE		  	
			        END
		         ELSE IF(@ProductCode = '' OR  @ProductCode IS NULL)
					BEGIN
							SET @Result = 'Product Code is required'
							SET @IsAnyDuplicate = 0	
							UPDATE BulkUploadMultipleOrders SET UploadedBy=@UserName,
								   UploadedOn=GETDATE(),
								   IsAnyDuplicate=@IsAnyDuplicate,
								   Result=@Result
								   WHERE ID=@MinId
						SET @MinId  = @MinId  + 1			        
						CONTINUE		  	
			        END
			    ELSE IF(@GPRSNOPostCode != '' AND ( LEN(@GPRSNOPostCode)< 2 OR LEN(@GPRSNOPostCode) > 10 ))
				    BEGIN
						SET @Result = 'Invalid Postal Code.'
						SET @IsAnyDuplicate = 0						
							UPDATE BulkUploadMultipleOrders 
							   SET UploadedBy=@UserName,
								   UploadedOn=GETDATE(),
								   IsAnyDuplicate=@IsAnyDuplicate,
								   Result=@Result
								   WHERE ID=@MinId
						SET @MinId  = @MinId  + 1
						CONTINUE   
				    END
				ELSE IF(@IsValidGPRSNoPostCode!=1)
					 BEGIN
						SET @Result = 'Invalid Postal Code.'
					    SET @IsAnyDuplicate = 0					
						UPDATE BulkUploadMultipleOrders SET UploadedBy=@UserName,
								UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
						WHERE ID=@MinId
						SET @MinId  = @MinId  + 1				    
					    CONTINUE   
					    
					 END
			    ELSE IF(@ProductId =0)       
					 BEGIN
					    SET @Result = 'Product does not exist in the System.' 			
						SET @IsAnyDuplicate = 0	
						UPDATE BulkUploadMultipleOrders 
						SET UploadedBy=@UserName,
							UploadedOn=GETDATE(),
							IsAnyDuplicate=@IsAnyDuplicate,
							Result=@Result
							WHERE ID=@MinId
							
							SET @MinId  = @MinId  + 1				    				    
						CONTINUE        
				END
				ELSE IF (@ProductCategory = 'SafeLink' AND (@SiteName='' OR @SiteName IS NULL))
				BEGIN  
						SET @Result = 'Sitename should not be blank for product category SafeLink.'			  
						SET @IsAnyDuplicate = 0	
						UPDATE BulkUploadMultipleOrders 
						SET UploadedBy=@UserName,
							UploadedOn=GETDATE(),
							IsAnyDuplicate=@IsAnyDuplicate,
							Result=@Result
							WHERE ID=@MinId
							
							SET @MinId  = @MinId  + 1				    				    
						CONTINUE          
				END	
				ELSE IF Not Exists (Select Product_ARC_MapId From Product_ARC_Map Where ProductId = @ProductId AND ARCId = @ARC_Id)      
			          BEGIN      
					    SET @Result = 'ARC not allowed to order this product.'			  
					    SET @IsAnyDuplicate = 0						
						UPDATE BulkUploadMultipleOrders 
						SET    UploadedBy=@UserName,
					           UploadedOn=GETDATE(),
					           IsAnyDuplicate=@IsAnyDuplicate,
					           Result=@Result
					           WHERE ID=@MinId
				        SET @MinId  = @MinId  + 1			        				    
			            CONTINUE       
			    END 
				ELSE IF @GPRSChipNo != '' And Exists (SELECT OrderItemDetailId FROM vw_OrderDataWithDetails WHERE GPRSNo = @GPRSChipNo and ARCId = @ARC_Id)        
			        BEGIN 
			          SET @Result = 'Success'     
					  SET @IsAnyDuplicate = 1 
					  SET @PreviousOrderId=@ExcelOrderId	
							UPDATE BulkUploadMultipleOrders 
							   SET UploadedBy=@UserName,
								   UploadedOn=GETDATE(),
								   IsAnyDuplicate=@IsAnyDuplicate,
								   Result=@Result
								   WHERE ID=@MinId
						SET @MinId  = @MinId  + 1			        				    
						CONTINUE           
			        END 	  					    
		        ELSE 
			        BEGIN 
			          SET @Result = 'Success'     
					  SET @IsAnyDuplicate = 0
					  UPDATE BulkUploadMultipleOrders 
					  SET UploadedBy=@UserName,
					      UploadedOn=GETDATE(),
						  IsAnyDuplicate=@IsAnyDuplicate,
						  Result=@Result
						  WHERE ID=@MinId
						SET @MinId  = @MinId  + 1			        				    
						CONTINUE           
			        END 
		    END--END While loop		  
			 	        
	       END	       
	END TRY      
	BEGIN CATCH      
		EXEC USP_SaveSPErrorDetails      
		RETURN -10        
	END CATCH