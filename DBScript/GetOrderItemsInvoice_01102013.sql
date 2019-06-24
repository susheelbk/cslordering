USE [ARC_Ordering]
GO

/****** Object:  StoredProcedure [dbo].[GetOrderItemsInvoice]    Script Date: 10/01/2013 15:49:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetOrderItemsInvoice]  (@orderno NVARCHAR(256))    
AS    
SELECT distinct Products.ProductCode,    
        Products.ProductName,    
        CONVERT(VARCHAR, OrderItems.ProductQty) AS ProductQnty,    
        Case OrderItems.CategoryId When 2 then  'N.A'   
        else  OrderItemDetails.GPRSNo end as GPRSNo ,    
        OrderItemDetails.OrderItemId,    
        OrderItemDetails.OrderItemDetailId,  
        Device_API.Dev_IP_Address  
         
          
 FROM   OrderItems    
        INNER JOIN Orders    
             ON  OrderItems.OrderId = Orders.OrderId    
        INNER JOIN Products    
             ON  OrderItems.ProductId = Products.ProductId   
        INNER JOIN Category_Product_Map    
             ON  Products.ProductId = Category_Product_Map.ProductId   
        INNER JOIN OrderItemDetails    
             ON  OrderItems.OrderItemId = OrderItemDetails.OrderItemId   
        LEFT JOIN Device_API    
           ON  OrderItemDetails.ICCID = Device_API.Dev_Code  COlLATE SQL_Latin1_General_CP1_CI_AS
                  
 WHERE  (    
            Orders.OrderNo =@orderno  
            AND (    
                    OrderItems.OrderItemStatusId = 18   
                    OR OrderItems.OrderItemStatusId =14  
					OR (oRDERiTEMS.OrderItemStatusId = 1 and Products.Producttype = 'Ancillary' )  
                )   
				
          -- AND OrderItemDetails.IsDlvNoteGenerated  = 0  
           AND OrderItems.CategoryId!=5 --DUALCOM Inside category  
        )
GO


