USE [ARC_Ordering]
GO

/****** Object:  StoredProcedure [dbo].[GetOrderItemsInvoice]    Script Date: 09/03/2013 17:10:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetOrderItemsInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetOrderItemsInvoice]
GO

USE [ARC_Ordering]
GO

/****** Object:  StoredProcedure [dbo].[GetOrderItemsInvoice]    Script Date: 09/03/2013 17:10:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetOrderItemsInvoice](@orderno NVARCHAR(256))  
AS  
 SELECT distinct Products.ProductCode,  
        Products.ProductName,  
        CONVERT(VARCHAR, OrderItems.ProductQty) AS ProductQnty,  
        OrderItemDetails.GPRSNo,  
        OrderItemDetails.OrderItemId,  
        OrderItemDetails.OrderItemDetailId,
        case OrderItems.CategoryId when 2 then Device_API.Dev_IP_Address
        else ''  end as Dev_IP_Address
        
 FROM   OrderItems  
        INNER JOIN Orders  
             ON  OrderItems.OrderId = Orders.OrderId  
        INNER JOIN Products  
             ON  OrderItems.ProductId = Products.ProductId 
        INNER JOIN Category_Product_Map  
             ON  Products.ProductId = Category_Product_Map.ProductId 
        INNER JOIN OrderItemDetails  
             ON  OrderItems.OrderItemId = OrderItemDetails.OrderItemId 
        INNER JOIN Device_API  
            ON  OrderItemDetails.ICCID = Device_API.Dev_Code
                
 WHERE  (  
            Orders.OrderNo =@orderno 
            AND (  
                    OrderItems.OrderItemStatusId = 18 
                    OR OrderItems.OrderItemStatusId =14  
                ) 
            AND OrderItemDetails.IsDelivered = 1  
           AND OrderItemDetails.IsDlvNoteGenerated  = 0  
        ) 
        
  
GO


