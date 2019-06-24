GO
/****** Object:  StoredProcedure [dbo].[USP_ConfirmBulkUploadMultipleOrders]    Script Date: 11/09/2016 16:15:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Created by:Atiq
-- Created On:24-10-2016
-- =============================================
CREATE rocedure [dbo].[USP_ConfirmBulkUploadMultipleOrders]  
(  
@OrderId Int,  
@OrderRefNo NVarchar(256),  
@DeliveryCost Decimal(6,2),  
@DeliveryAddressId Int,  
@DeliveryTypeId Int,  
@SpecialInstructions Text,  
@VATRate Decimal(6,3),  
@CreatedBy NVarchar(256)
)  
AS  
  
BEGIN TRY   
BEGIN  
  
 Declare @OrderAmount Decimal(9,2)  
 Declare @OrderTotalAmount Decimal(9,2)  
 Select @OrderAmount = Amount From Orders Where OrderId = @OrderId  
 Set @OrderTotalAmount = (@OrderAmount + @DeliveryCost) + ((@OrderAmount + @DeliveryCost)* @VATRate)   
 Update Orders  
   Set OrderRefNo = @OrderRefNo,  
   OrderDate = GETDATE(),  
   DeliveryCost = @DeliveryCost,  
   OrderStatusId = 2,  
   OrderTotalAmount = @OrderTotalAmount,  
   DeliveryTypeId = @DeliveryTypeId,  
   SpecialInstructions = @SpecialInstructions,  
   ModifiedBy = @CreatedBy,  
   ModifiedOn = GETDATE(),
   VATRate = @VATRate   
   Where OrderId = @OrderId 
     
   DELETE  FROM BulkUploadMultipleOrders WHERE CreatedBy=@CreatedBy 
   Select OrderNo From Orders Where OrderId = @OrderId  
   
END  
  
END TRY   
BEGIN CATCH  
EXEC USP_SaveSPErrorDetails  
RETURN -1    
END CATCH  