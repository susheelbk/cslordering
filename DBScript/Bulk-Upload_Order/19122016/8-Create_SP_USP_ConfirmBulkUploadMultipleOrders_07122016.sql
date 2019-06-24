GO
/****** Object:  StoredProcedure [dbo].[USP_ConfirmBulkUploadMultipleOrders]    Script Date: 12/08/2016 18:07:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Created by:Atiq
-- Created On:24-10-2016
-- =============================================
Create Procedure [dbo].[USP_ConfirmBulkUploadMultipleOrders]  
(  
@OrderId Int,  
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
   Set OrderDate = GETDATE(),  
   DeliveryCost = @DeliveryCost,  
   OrderStatusId = 2,  
   OrderTotalAmount = @OrderTotalAmount,  
   DeliveryTypeId = @DeliveryTypeId,  
   SpecialInstructions = @SpecialInstructions,  
   ModifiedBy = @CreatedBy,  
   ModifiedOn = GETDATE(),
   VATRate = @VATRate   
   WHERE OrderId = @OrderId  
   DELETE  FROM BulkUploadMultipleOrders WHERE UploadedBy=@CreatedBy   
   SELECT OrderNo FROM Orders WHERE OrderId = @OrderId  
   
END  
  
END TRY   
BEGIN CATCH  
EXEC USP_SaveSPErrorDetails  
RETURN -1    
END CATCH  