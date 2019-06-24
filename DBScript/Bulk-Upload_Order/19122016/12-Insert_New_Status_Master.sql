IF NOT EXISTS(SELECT 1 FROM OrderStatusMaster WHERE OrderStatusId=21)
BEGIN
         INSERT INTO OrderStatusMaster(OrderStatus,ListOrder)VALUES('Initialised By Bulk Upload Multiple Orders',201)
END

