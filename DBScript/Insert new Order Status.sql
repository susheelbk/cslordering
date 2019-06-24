
IF NOT EXISTS(SELECT 1 FROM OrderStatusMaster WHERE OrderStatus='ItemProcessed')
BEGIN
	INSERT INTO OrderStatusMaster(OrderStatus)VALUES('ItemProcessed')
END
GO
IF NOT EXISTS(SELECT 1 FROM OrderStatusMaster WHERE OrderStatus='PartItemProcessed')
BEGIN
	INSERT INTO OrderStatusMaster(OrderStatus)VALUES('PartItemProcessed')
END

GO

IF NOT EXISTS( SELECT 1 FROM sys.columns WHERE Name = N'MergedOrderId' and Object_ID = Object_ID(N'Orders'))
BEGIN
	ALTER TABLE Orders ADD MergedOrderId INT NULL
END


