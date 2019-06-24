  IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OverriddenDeliveryCost' AND Object_ID = Object_ID(N'Orders'))    
BEGIN
ALTER TABLE Orders ADD OverriddenDeliveryCost DECIMAL(9,2) NULL
END
GO