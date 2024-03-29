GO
/****** Object:  StoredProcedure [dbo].[USP_BulkUploadOrderProducts]    Script Date: 01/23/2017 18:27:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==================================================================
--Author-----------------Mohd Atiq
--Modified On-------------03-11-2016
--Description-------------The purpose of this to upload the bulk products for the order.it was taking mutch time.
--And it was throwing session time out issue.
--Modified on ------------23-01-2017
--Description ------------no major chnages only change the error message GPRS to GPRS Chip No 
--and   GSMNO to Panel ID
--===================================================================
ALTER PROCEDURE  [dbo].[USP_BulkUploadOrderProducts] --10,130764
(      
   @ARC_Id int,
   @OrderId int     
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
 Declare @IsGPRSChipEmpty bit
 DECLARE @GSMNo NVARCHAR(50) 
 DECLARE @LoopCounter INT = 0, @MaxUploadedId INT = 0
 SELECT @LoopCounter=MIN(ID),@MaxUploadedId= MAX(ID) FROM BulkUploadOrders 
 WHERE OrderId=@OrderId 
WHILE(@LoopCounter <= @MaxUploadedId)
BEGIN
    SET @Result = 'Error - some logic is missing.'      
    SET @IsAnyDuplicate = 0 
    
    SELECT @ProductCode=ProductCode,@GPRSChipNo=GPRSChipNo,
          @GPRSNoPostCode=GPRSChippostCode,@IsValidGPRSChipPostCode=IsValidGPRSChipPostCode,
          @GSMNo=GSMNo FROM BulkUploadOrders 
          WHERE ID = @LoopCounter AND OrderId=@OrderId        
        
        SELECT @ProductType=ProductType FROM  Products WHERE ProductCode=@ProductCode
	    IF(@ProductType='Ancillary')
		 BEGIN
			 SET @IsAncillary=1			 
		 END
		 ELSE
		 BEGIN
			 SET @IsAncillary=0			
		 END
	   
	   IF(@IsAncillary=0)
	   BEGIN
	    IF (@GPRSChipNo != '' AND (LEN(@GPRSChipNo) < 4 OR LEN(@GPRSChipNo)> 6))
		BEGIN
			SET @Result = 'Invalid GPRS Chip No'
			SET @IsAnyDuplicate = 0			
			Update BulkUploadOrders SET Result=@Result,IsAnyDuplicate=@IsAnyDuplicate WHERE ID = @LoopCounter AND OrderId=@OrderId 
	        SET @LoopCounter  = @LoopCounter  + 1				
	        CONTINUE
		END		
        IF (ISNUMERIC(@GPRSChipNo)=0)
        BEGIN
            SET @Result = 'Invalid GPRS Chip No'
			SET @IsAnyDuplicate = 0	
			Update BulkUploadOrders SET Result=@Result,IsAnyDuplicate=@IsAnyDuplicate WHERE ID = @LoopCounter AND OrderId=@OrderId 
	        SET @LoopCounter  = @LoopCounter  + 1	
	        CONTINUE			
        END
        IF (@GPRSNoPostCode != '' AND ( LEN(@GPRSNoPostCode)< 2 OR LEN(@GPRSNoPostCode) > 10 ))
        BEGIN
            SET @Result = 'Invalid PostCode'
		    SET @IsAnyDuplicate = 0	
		    Update BulkUploadOrders SET Result=@Result,IsAnyDuplicate=@IsAnyDuplicate WHERE ID = @LoopCounter AND OrderId=@OrderId 
	        SET @LoopCounter  = @LoopCounter  + 1		        
	        CONTINUE   
        END
        IF(@IsValidGPRSChipPostCode!=1)
         BEGIN
             SET @Result = 'Invalid PostCode'
		     SET @IsAnyDuplicate = 0		     	
		     Update BulkUploadOrders SET Result=@Result,IsAnyDuplicate=@IsAnyDuplicate WHERE ID = @LoopCounter AND OrderId=@OrderId 
	          SET @LoopCounter  = @LoopCounter  + 1	
	         CONTINUE 
         END
      END --End @IsAncillary IF
              
       SET @ProductId=0
       SELECT @ProductId = ProductId FROM Products WHERE ProductCode = @ProductCode AND IsDeleted = 0 
       IF(@ProductId =0 OR @ProductId IS NULL)
	   BEGIN      
			SET @Result = 'Product does not exist in the System.' 			
			Update BulkUploadOrders SET Result=@Result,IsAnyDuplicate=@IsAnyDuplicate WHERE ID = @LoopCounter AND OrderId=@OrderId 
			SET @LoopCounter  = @LoopCounter  + 1		        
	        CONTINUE        
	   END      
	   ELSE IF Not Exists (SELECT Product_ARC_MapId FROM Product_ARC_Map WHERE ProductId = @ProductId AND ARCId = @ARC_Id)      
	   BEGIN      
			SET @Result = 'ARC not allowed to order this product.'			  
			Update BulkUploadOrders SET Result=@Result,IsAnyDuplicate=@IsAnyDuplicate WHERE ID = @LoopCounter AND OrderId=@OrderId 
	        SET @LoopCounter  = @LoopCounter  + 1
	       	CONTINUE       
	   END
	   ELSE IF (@GSMNo != '' AND LEN(@GSMNo) >20)
	   BEGIN  
	        SET @Result = 'Panel ID should not be more than 20 digits.'			  
			Update BulkUploadOrders SET Result=@Result,IsAnyDuplicate=@IsAnyDuplicate WHERE ID = @LoopCounter AND OrderId=@OrderId 
	        SET @LoopCounter  = @LoopCounter  + 1
	       	CONTINUE       
	   END
	   ELSE
	   BEGIN	
	       --Select  len(@GSMNo)        
	       SELECT TOP 1 @IsGPRSChipEmpty = cat.IsGPRSChipEmpty       
		   FROM Category_Product_Map cpm INNER JOIN Category cat 
		   ON  cat.CategoryId = cpm.CategoryId AND cpm.ProductId = @ProductId      
		   ORDER BY IsGPRSChipEmpty    
	        IF @IsGPRSChipEmpty = 0 AND @GPRSChipNo = ''      
			BEGIN      
			   Set @Result = 'Empty GPRS Chip No is not allowed.'
			   SET @IsAnyDuplicate = 0
			   UPDATE BulkUploadOrders SET Result=@Result,IsAnyDuplicate=@IsAnyDuplicate WHERE ID = @LoopCounter AND OrderId=@OrderId  
               SET @LoopCounter  = @LoopCounter  + 1 
               CONTINUE
			       
			END      
            IF @GPRSChipNo != '' And Exists (SELECT OrderItemDetailId FROM vw_OrderDataWithDetails Where GPRSNo = @GPRSChipNo and ARCId = @ARC_Id)        
			BEGIN      
			   SET @IsAnyDuplicate = 1
			   SET @Result = 'Success'
               UPDATE BulkUploadOrders SET Result=@Result,IsAnyDuplicate=@IsAnyDuplicate WHERE ID = @LoopCounter AND OrderId=@OrderId  
               SET @LoopCounter  = @LoopCounter  + 1 
               CONTINUE	          
			END
			   SET @IsAnyDuplicate = 0
			   SET @Result = 'Success'
               UPDATE BulkUploadOrders SET Result=@Result,IsAnyDuplicate=@IsAnyDuplicate WHERE ID = @LoopCounter AND OrderId=@OrderId  
               SET @LoopCounter  = @LoopCounter  + 1               	
                       	
	   END 		      
 END --END while Loop 
END  
END TRY      
BEGIN CATCH      
EXEC USP_SaveSPErrorDetails      
RETURN -10        
END CATCH
