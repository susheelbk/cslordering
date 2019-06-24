
  
  IF  EXISTS ( SELECT 1 FROM sys.procedures WHERE name LIKE 'GetOrderItemsInvoice') 
BEGIN
DROP PROC  GetOrderItemsInvoice
END
GO
CREATE PROCEDURE [dbo].[GetOrderItemsInvoice] (@orderno NVARCHAR(256))
AS
	SELECT DISTINCT Products.ProductCode,
	       Products.ProductName,
	       CONVERT(VARCHAR, OrderItems.ProductQty) AS ProductQnty,
	       CASE OrderItems.CategoryId
	            WHEN 2 THEN 'N.A'
	            ELSE OrderItemDetails.GPRSNo
	       END AS GPRSNo,
	       OrderItemDetails.ICCID AS ICCID,
	       OrderItemDetails.DataNo AS DataNo,
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
	            ON  OrderItemDetails.ICCID = Device_API.Dev_Code COLLATE 
	                SQL_Latin1_General_CP1_CI_AS
	WHERE  (
	           Orders.OrderNo = @orderno
	           AND (
	                   OrderItems.OrderItemStatusId = 18
	                   OR OrderItems.OrderItemStatusId = 14
	                   OR (
	                          oRDERiTEMS.OrderItemStatusId = 1
	                          AND Products.Producttype = 'Ancillary'
	                      )
	               ) 
	               
	               -- AND OrderItemDetails.IsDlvNoteGenerated  = 0
	           AND OrderItems.CategoryId != 5 --DUALCOM Inside category
	       )  
	       GO