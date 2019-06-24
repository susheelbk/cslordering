GO
/****** Object:  StoredProcedure [dbo].[USP_ConfirmOrderDetails]    Script Date: 08/16/2016 13:08:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Modified by:Atiq
-- Modified Date:11-08-2016
-- Add one more parameter @AlarmDeliveryARCCode to update in order table for ARC ESI chnages
-- Modified Date :22-05-2015
-- =============================================
ALTER Procedure [dbo].[USP_ConfirmOrderDetails]  
(  
@OrderId Int,  
@OrderRefNo NVarchar(256),  
@DeliveryCost Decimal(6,2),  
@DeliveryAddressId Int,  
@DeliveryTypeId Int,  
@SpecialInstructions Text,  
@VATRate Decimal(6,3),  
@CreatedBy NVarchar(256),  
@InstallationAddressId int, 
@InstallerContactName NVarchar(250) = '',
@AlarmDeliveryARCCode NVarchar(50)  
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
   DeliveryAddressId = @DeliveryAddressId,  
   OrderStatusId = 2,  
   OrderTotalAmount = @OrderTotalAmount,  
   DeliveryTypeId = @DeliveryTypeId,  
   SpecialInstructions = @SpecialInstructions,  
   ModifiedBy = @CreatedBy,  
   ModifiedOn = GETDATE(),  
   InstallationAddressID = @InstallationAddressId,  
   VATRate = @VATRate,  
   InstallerContactName = @InstallerContactName,  
   AlarmDeliveryARCCode = @AlarmDeliveryARCCode  
  Where OrderId = @OrderId  
    
 Select OrderNo From Orders Where OrderId = @OrderId  
END  
  
END TRY   
BEGIN CATCH  
EXEC USP_SaveSPErrorDetails  
RETURN -1    
END CATCH  