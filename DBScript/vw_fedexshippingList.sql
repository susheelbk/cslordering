USE [ARC_Ordering]
GO

/****** Object:  View [dbo].[vw_FedexShippinglist]    Script Date: 25/11/2013 10:02:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE VIEW [dbo].[vw_FedexShippinglist]
AS
SELECT 
	[Recipient Code]= Address.AddressID ,
	[Recipient Name] = CASE when Address.ContactName = '' THEN '"' + Address.companyname  Collate Latin1_General_CI_AS + '"'  ELSE '"' + Address.ContactName + '"'  END,
	[Address Line 1]='"' + Address.addressOne  + '"',
	[Address Line 2]='"' +  Address.Addresstwo  + '"',
	[Address Line 3]='',
	[Address Line 4]='',
	[Post Town]='"' + Address.Town + '"',
	[Post Code] ='"' + Address.PostCode + '"',
	[Recipient Contact]='"' +isnull(address.Mobile,'') + '"' ,
	[Recipient Telephone]='"' +isnull(address.Telephone,'') + '"' ,
	[Recipient Email] ='"' +isnull(address.Email,'')+ '"',
	[Number of Items] ='1', 
	[Weight] ='1.00',
	[FedEx UK Account] ='Fedex Account Name',
	[Service] = 'A', --HArdcoded to A as currently everything is set to A and also ship manager throws an issue when B and Productcode is D
	--[Service] = CASE WHEN IsTimedDelivery = 1 THEN 'A' ELSE 'B' END ,
	[Timed Delivery Option]=CASE WHEN IsTimedDelivery = 1 THEN TimedDeliveryOption ELSE '' END,
	[Product Code] = 'D',
	[Delivery Instructions 1]= '"' + Replace(Convert(VARCHAR(32),SpecialInstructions),char(13) + char(10), ' ') + '"',
	[Delivery Instructions 2] = '"' +CASE 
			WHEN Len(Convert(VARCHAR(64),SpecialInstructions)) > 32 THEN Replace(Substring(Convert(VARCHAR(64),SpecialInstructions),33,32),char(13) + char(10), ' ') ELSE '' END
			+ '"' ,
	[Customer Notes 1]='',
	[Customer Notes 2]='',
	[Printer] = '',
	[Customs Value] = '',
	[Ship Date] = '',
	[OrderRef1] = '"' +OrderRefNo + '"',
	[OrderRef2] = '',
	[OrderRef3] = '',
	[OrderRef4] = '',
	[OrderRef5] = '', 
	ProcessedOn = orderitems.ProcessedOn 
FROM 
Orders 
left outer join [Address] on Orders.DeliveryAddressID = Address.AddressID 
--left outer join [Address] insAddress  on Orders.installationAddressID = insAddress.AddressID 
INNER JOIN deliverytype on Orders.DeliveryTypeID = deliverytype.DeliveryTypeID
INNER JOIN ORDERITEMS ON dbo.OrderItems.OrderId = dbo.Orders.OrderId 
WHERE ORders.Orderdate >='01 oct 2013' 
AND Orders.OrderstatusID >=2 









GO

