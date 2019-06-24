GO
/****** Object:  StoredProcedure [dbo].[USP_BulkUploadMultipleOrderProducts]    Script Date: 11/03/2016 14:21:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================
--Author-----------------Mohd Atiq
--Created On-------------04-09-2016
--Description-------------The purpose of this stored procedure to upload multiple orders from excel sheet.
CREATE PROCEDURE [dbo].[USP_BulkUploadMultipleOrderProducts] --10,'atiq.m','testemail','76500A81-A167-4C41-B52C-87CC39CB8704'     
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
        DECLARE @InstallerUnqCode VARCHAR(50)
	    DECLARE @GroupOrderId VARCHAR(100) 
	    DECLARE @IsValidGPRSNoPostCode BIT
	    DECLARE @IsValidPostCode BIT
        Set @Result = 'Error-there is some issue.' 
		--End Save Order Items------
		SET @PreviousOrderId='No'
		SET @ProductId=0
		SET @CreatedBy=@UserName
		SET @ContactName=''
		SET @GroupOrderId=''
		SELECT @MinId= MIN(ID),@MaxId= MAX(ID) FROM BulkUploadMultipleOrders 
		WHERE CreatedBy=@UserName --AND OrderID  IS NOT NULL
		
		WHILE(@MinId<=@MaxId)
		BEGIN
		    Set @Result = 'Error-there is some issue.'
            SELECT @ExcelOrderId= ISNULL(OrderId,''),
			       @ProductCode=ISNULL(ProductCode,''),
			       @GPRSChipNo=GPRSChipNo,
			       @GPRSNOPostCode=GPRSNOPostCode,
			       @PostCode=PostCode,
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
			       @PSTNNo=Ident,
			       @InstallerUnqCode=InstallerUniqueCode,
			       @IsValidGPRSNoPostCode=@IsValidGPRSNoPostCode,
			       @IsValidPostCode=IsValidPostCode
			       FROM BulkUploadMultipleOrders
			       WHERE ID=@MinId --AND OrderID  IS NOT NULL
			     
			     SET @ProductId=0
		           SELECT @ProductId = ProductId From Products Where ProductCode = @ProductCode And IsDeleted = 0   
		         IF(@ExcelOrderId = @GroupOrderId)
				 BEGIN
				        SET @MinId  = @MinId  + 1					    
						CONTINUE
				 END				 			 			
			     IF(@PreviousOrderId <> @ExcelOrderId)--Start IF Previous Order
			     BEGIN	
			        
			        IF(@ExcelOrderId ='' OR @ExcelOrderId IS NULL)
					BEGIN
					
						SET @Result = 'Order Id is required.'
						SET @IsAnyDuplicate = 0										
						SET @PreviousOrderId=@ExcelOrderId
						SET @GroupOrderId	=@ExcelOrderId
						UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
						WHERE ID=@MinId
						SET @MinId  = @MinId  + 1					    
						CONTINUE
			        END			                   
			        ELSE IF(@CompanyName ='' OR @CompanyName IS NULL)
					BEGIN
						SET @Result = 'Company name is required.'
						SET @IsAnyDuplicate = 0										
						SET @PreviousOrderId=@ExcelOrderId
						SET @GroupOrderId	=@ExcelOrderId
						UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
						WHERE ID=@MinId
						SET @MinId  = @MinId  + 1					    
						CONTINUE
			        END
			        ELSE IF (@FirstName = '' OR @FirstName IS NULL)
				    BEGIN
						SET @Result = 'First name is required.'
						SET @IsAnyDuplicate = 0					
						SET @PreviousOrderId=@ExcelOrderId	
						SET @GroupOrderId	=@ExcelOrderId
						UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
						WHERE ID=@MinId
						SET @MinId  = @MinId  + 1				    
						CONTINUE
				   END
				   ELSE IF(@LastName = '' OR @LastName IS NULL)
				    BEGIN
						SET @Result = 'Last name is required.'
						SET @IsAnyDuplicate = 0					
						SET @PreviousOrderId=@ExcelOrderId	
						SET @GroupOrderId	=@ExcelOrderId
						UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
						WHERE ID=@MinId
						SET @MinId  = @MinId  + 1				    
						CONTINUE
				   END
				   ELSE IF (@AddressOne ='' OR @AddressOne IS NULL)
						BEGIN
						SET @Result = 'Address One is required'
						SET @IsAnyDuplicate = 0		
						SET @PreviousOrderId=@ExcelOrderId	
						SET @GroupOrderId	=@ExcelOrderId								
						UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
						WHERE ID=@MinId
						SET @MinId  = @MinId  + 1				    
						CONTINUE
				   END
				   ELSE IF (@Email ='' OR @Email IS NULL)
				   BEGIN
						SET @Result = 'Email is required'						
						SET @IsAnyDuplicate = 0					
						SET @PreviousOrderId=@ExcelOrderId	
						SET @GroupOrderId	=@ExcelOrderId
						UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
						WHERE ID=@MinId
						SET @MinId  = @MinId  + 1
					    
						CONTINUE
				    END
				    ELSE IF (@Country ='' OR @Country IS NULL)
				    BEGIN
						SET @Result = 'Country name is required'
						SET @IsAnyDuplicate = 0					
						SET @PreviousOrderId=@ExcelOrderId	
						SET @GroupOrderId	=@ExcelOrderId
						UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
						WHERE ID=@MinId
						SET @MinId  = @MinId  + 1					    
						CONTINUE
				    END
				    ELSE IF(@GPRSNoPostCode != '' AND ( LEN(@GPRSNoPostCode)< 2 OR LEN(@GPRSNoPostCode) > 10 ))
                    BEGIN                    
					    SET @Result = 'Invalid GPRS NO PostCode'
					    SET @IsAnyDuplicate = 0					
						SET @PreviousOrderId=@ExcelOrderId
						SET @GroupOrderId	=@ExcelOrderId	
						UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
						WHERE ID=@MinId
						SET @MinId  = @MinId  + 1				    
					    CONTINUE   
			        END
			        ELSE IF(@IsValidGPRSNoPostCode!=1)
					 BEGIN
						SET @Result = 'Invalid GPRS NO PostCode'
					    SET @IsAnyDuplicate = 0					
						SET @PreviousOrderId=@ExcelOrderId
						SET @GroupOrderId	=@ExcelOrderId	
						UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
						WHERE ID=@MinId
						SET @MinId  = @MinId  + 1				    
					    CONTINUE   
					    
					 END
			        ELSE IF (@GPRSChipNo != '' AND (LEN(@GPRSChipNo) < 4 OR LEN(@GPRSChipNo)> 6))
				    BEGIN
				        
						SET @Result = 'Invalid GPRS Chip No.'
						SET @IsAnyDuplicate = 0									
						SET @PreviousOrderId=@ExcelOrderId
						SET @GroupOrderId	=@ExcelOrderId	
						UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
						WHERE ID=@MinId
						SET @MinId  = @MinId  + 1				    
						CONTINUE
			        END
			        ELSE IF (ISNUMERIC(@GPRSChipNo)=0)
					BEGIN
							SET @Result = 'Invalid GPRS Chip No.'
							SET @IsAnyDuplicate = 0	
							SET @PreviousOrderId=@ExcelOrderId
						    SET @GroupOrderId	=@ExcelOrderId	
							UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								   UploadedOn=GETDATE(),
								   IsAnyDuplicate=@IsAnyDuplicate,
								   Result=@Result
								   WHERE ID=@MinId
						SET @MinId  = @MinId  + 1			        
						CONTINUE		  	
			        END
			        ELSE IF (@PostCode != '' AND ( LEN(@PostCode)< 2 OR LEN(@PostCode) > 10 ))
				    BEGIN
						SET @Result = 'Invalid PostCode.'
						SET @IsAnyDuplicate = 0						
							SET @PreviousOrderId=@ExcelOrderId
						    SET @GroupOrderId	=@ExcelOrderId	
							UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								   UploadedOn=GETDATE(),
								   IsAnyDuplicate=@IsAnyDuplicate,
								   Result=@Result
								   WHERE ID=@MinId
						SET @MinId  = @MinId  + 1
						CONTINUE   
				    END
				    ELSE IF (@IsValidPostCode!=1)
				    BEGIN
						SET @Result = 'Invalid PostCode.'
						SET @IsAnyDuplicate = 0						
							SET @PreviousOrderId=@ExcelOrderId
						    SET @GroupOrderId	=@ExcelOrderId	
							UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								   UploadedOn=GETDATE(),
								   IsAnyDuplicate=@IsAnyDuplicate,
								   Result=@Result
								   WHERE ID=@MinId
						SET @MinId  = @MinId  + 1
						CONTINUE   
				    END
				    ELSE IF(@ProductId =0)       
					 BEGIN
					    SET @Result = 'Product does not exist in the System.' 			
						SET @IsAnyDuplicate = 0	
						SET @PreviousOrderId=@ExcelOrderId
						SET @GroupOrderId	=@ExcelOrderId	
						UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
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
						SET @PreviousOrderId=@ExcelOrderId
						SET @GroupOrderId	=@ExcelOrderId	
					    UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
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
					  --SET @GroupOrderId	=@ExcelOrderId	
							UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								   UploadedOn=GETDATE(),
								   IsAnyDuplicate=@IsAnyDuplicate,
								   Result=@Result
								   WHERE ID=@MinId
						SET @MinId  = @MinId  + 1			        				    
						CONTINUE           
			        END 
			        ELSE IF(@InstallerUnqCode ='' OR @InstallerUnqCode IS NULL)
					BEGIN
					    
						SET @Result = 'Installer unique code is required.'
						 SET @IsAnyDuplicate = 0
						 SET @PreviousOrderId	=@ExcelOrderId
						 SET @GroupOrderId	=@ExcelOrderId				 
						 UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,
								Result=@Result WHERE ID=@MinId
						SET @MinId  = @MinId  + 1					    
						CONTINUE
					END
					ELSE IF(@InstallerUnqCode != '' OR @InstallerUnqCode IS NOT NULL)
			        BEGIN			        
			           SET @IsAnyDuplicate = 0
			           
			               IF(ISNUMERIC(@InstallerUnqCode)=1 AND LEN(@InstallerUnqCode)>5 AND LEN(@InstallerUnqCode)<7)
			               BEGIN
			                	IF NOT EXISTS (SELECT 1 FROM Installer WHERE UniqueCode= CAST(@InstallerUnqCode AS INT))
								BEGIN
								   
								   SET @Result = 'Installer unique code does not exist in the system.'
								   SET @PreviousOrderId=@ExcelOrderId
						           SET @GroupOrderId	=@ExcelOrderId
								   UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
										UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
										WHERE ID=@MinId
										SET @MinId  = @MinId  + 1
								   CONTINUE
								END
								ELSE
								BEGIN
								
								   SET @Result = 'Success'
								   SET @PreviousOrderId=@ExcelOrderId
						           UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
										UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
										WHERE ID=@MinId
										SET @MinId  = @MinId  + 1
								   CONTINUE  
								END
						   END
						   ELSE
							    BEGIN
							       
							       SET @Result = 'Installer Unique code should be numeric with 6 digits.'
								   SET @PreviousOrderId=@ExcelOrderId
						           SET @GroupOrderId	=@ExcelOrderId
								   UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
										UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
										WHERE ID=@MinId
										SET @MinId  = @MinId  + 1
								   CONTINUE
							END
			           END
			            ELSE
						BEGIN
						   
							SET @Result = 'Success'
							SET @IsAnyDuplicate = 0										
							SET @PreviousOrderId=@ExcelOrderId	
							UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
									UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
							WHERE ID=@MinId
							SET @MinId  = @MinId  + 1					    
							CONTINUE
						END
						SET @MinId  = @MinId  + 1							
						
			      END --END IF Previous Order
			      ELSE --ELSE START of Previous Order
			      BEGIN
			        IF(@ExcelOrderId ='' OR @ExcelOrderId IS NULL)
					BEGIN					
						SET @Result = 'Order Id is required.'
						SET @IsAnyDuplicate = 0										
						SET @PreviousOrderId=@ExcelOrderId
						SET @GroupOrderId	=@ExcelOrderId
						UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
						WHERE ID=@MinId
						SET @MinId  = @MinId  + 1					    
						CONTINUE
			        END	
			        ELSE IF (@GPRSChipNo != '' AND (LEN(@GPRSChipNo) < 4 OR LEN(@GPRSChipNo)> 6))
				    BEGIN
						SET @Result = 'Invalid GPRS Chip No.'
						SET @IsAnyDuplicate = 0									
						SET @PreviousOrderId=@ExcelOrderId	
						UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
						WHERE ID=@MinId
						SET @MinId  = @MinId  + 1				    
						CONTINUE
			        END
			        ELSE IF (ISNUMERIC(@GPRSChipNo)=0)
					BEGIN
							SET @Result = 'Invalid GPRS Chip No.'
							SET @IsAnyDuplicate = 0	
							SET @PreviousOrderId=@ExcelOrderId	
							UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								   UploadedOn=GETDATE(),
								   IsAnyDuplicate=@IsAnyDuplicate,
								   Result=@Result
								   WHERE ID=@MinId
						SET @MinId  = @MinId  + 1			        
						CONTINUE		  	
			        END
			        ELSE IF (@GPRSNOPostCode != '' AND ( LEN(@GPRSNOPostCode)< 2 OR LEN(@GPRSNOPostCode) > 10 ))
				    BEGIN
						SET @Result = 'Invalid GPRS NO PostCode.'
						SET @IsAnyDuplicate = 0						
							SET @PreviousOrderId=@ExcelOrderId	
							UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								   UploadedOn=GETDATE(),
								   IsAnyDuplicate=@IsAnyDuplicate,
								   Result=@Result
								   WHERE ID=@MinId
						SET @MinId  = @MinId  + 1
						CONTINUE   
				    END
				     ELSE IF(@IsValidGPRSNoPostCode!=1)
					 BEGIN
						SET @Result = 'Invalid GPRS NO PostCode.'
					    SET @IsAnyDuplicate = 0					
						SET @PreviousOrderId=@ExcelOrderId
						UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
						WHERE ID=@MinId
						SET @MinId  = @MinId  + 1				    
					    CONTINUE   
					    
					 END					 
					 ELSE IF (@PostCode != '' AND ( LEN(@PostCode)< 2 OR LEN(@PostCode) > 10 ))
				     BEGIN
						SET @Result = 'Invalid PostCode.'
						SET @IsAnyDuplicate = 0						
							SET @PreviousOrderId=@ExcelOrderId	
							UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								   UploadedOn=GETDATE(),
								   IsAnyDuplicate=@IsAnyDuplicate,
								   Result=@Result
								   WHERE ID=@MinId
						SET @MinId  = @MinId  + 1
						CONTINUE   
				    END
				     ELSE IF(@IsValidPostCode!=1)
					 BEGIN
						SET @Result = 'Invalid PostCode.'
					    SET @IsAnyDuplicate = 0					
						SET @PreviousOrderId=@ExcelOrderId
						UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
						WHERE ID=@MinId
						SET @MinId  = @MinId  + 1				    
					    CONTINUE	    
					 END				 
				     ELSE IF(@ProductId =0)       
					 BEGIN
					    SET @Result = 'Product does not exist in the System.' 			
						SET @IsAnyDuplicate = 0	
						SET @PreviousOrderId=@ExcelOrderId	
								UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
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
						SET @PreviousOrderId=@ExcelOrderId	
					    UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
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
							UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								   UploadedOn=GETDATE(),
								   IsAnyDuplicate=@IsAnyDuplicate,
								   Result=@Result
								   WHERE ID=@MinId
						SET @MinId  = @MinId  + 1			        				    
						CONTINUE           
			        END 
			        ELSE IF(@InstallerUnqCode ='' OR @InstallerUnqCode IS NULL)
					BEGIN
						SET @Result = 'Installer unique code is required.'
						 SET @IsAnyDuplicate = 0
						 SET @PreviousOrderId	=@ExcelOrderId
						 UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
								UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,
								Result=@Result WHERE ID=@MinId
						SET @MinId  = @MinId  + 1					    
						CONTINUE
					END
					ELSE IF(@InstallerUnqCode != '' OR @InstallerUnqCode IS NOT NULL)
			        BEGIN			        
			               SET @IsAnyDuplicate = 0
			               IF(ISNUMERIC(@InstallerUnqCode)=1 AND LEN(@InstallerUnqCode)>5 AND LEN(@InstallerUnqCode)<7)
			               BEGIN
			                   IF NOT EXISTS (SELECT 1 FROM Installer WHERE UniqueCode= CAST(@InstallerUnqCode AS INT))
								BEGIN
								   SET @Result = 'Installer unique code does not exist in the system.'
								   SET @PreviousOrderId	=@ExcelOrderId
								   UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
										UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
										WHERE ID=@MinId
										SET @MinId  = @MinId  + 1
								   CONTINUE
								END
								ELSE
								BEGIN
								   SET @Result = 'Success'
								   SET @PreviousOrderId	=@ExcelOrderId
								   UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
										UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
										WHERE ID=@MinId
										SET @MinId  = @MinId  + 1
								   CONTINUE  
								END
						   END
						   ELSE
							    BEGIN							       
								   SET @Result = 'Installer Unique code should be numeric with 6 digits.'
								   SET @PreviousOrderId	=@ExcelOrderId
								   UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
										UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
										WHERE ID=@MinId
										SET @MinId  = @MinId  + 1
								   CONTINUE
							END
			           END
			            ELSE
						BEGIN
							SET @Result = 'Success'
							SET @IsAnyDuplicate = 0										
							SET @PreviousOrderId=@ExcelOrderId	
							UPDATE BulkUploadMultipleOrders SET CreatedBy=@UserName,
									UploadedOn=GETDATE(),IsAnyDuplicate=@IsAnyDuplicate,Result=@Result
							WHERE ID=@MinId
							SET @MinId  = @MinId  + 1					    
							CONTINUE
						END	  
			      END----END ELSE of Previous Order			      
		    END--END While loop		        
	       END	       
	END TRY      
	BEGIN CATCH      
		EXEC USP_SaveSPErrorDetails      
		RETURN -10        
	END CATCH