GO
/****** Object:  StoredProcedure [dbo].[USP_RemoveBulkMultipleOrderItemsFromBasket]    Script Date: 11/15/2016 17:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================
--Author-----------------Mohd Atiq
--Created On-------------04-09-2016
--Description-------------The purpose this stored procedure to clear all the data inculding order id form database
CREATE PROCEDURE [dbo].[USP_RemoveBulkMultipleOrderItemsFromBasket]
(
	@OrderId int,
	@ModifiedBy NVarchar(256)
)
AS
BEGIN TRY 
BEGIN	
	DELETE From OrderItemDetails WHERE OrderItemId IN (SELECT OrderItemId FROM OrderItems WHERE OrderId=@OrderId)
	DELETE From OrderItems WHERE OrderItemId IN (SELECT OrderItemId FROM OrderItems WHERE OrderId=@OrderId)
	DELETE From OrderDependentItems WHERE OrderItemId = (SELECT OrderItemId FROM OrderItems WHERE OrderId=@OrderId)
	DELETE From Orders WHERE OrderId = @OrderId
	
END
END TRY 
BEGIN CATCH
EXEC USP_SaveSPErrorDetails
RETURN -1  
END CATCH
