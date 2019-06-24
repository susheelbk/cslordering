/****** Object:  StoredProcedure [dbo].[GetARCDeliveryAddresses]    Script Date: 23/09/2013 10:22:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetARCDeliveryAddresses]  
@ArcId int  ,
@postcode varchar(100) = ''  
As  
BEGIN TRY   
BEGIN  
declare @string varchar(500)

If @postcode = ''  
BEGIN 
	Select * FROM 
	(
	select distinct top 20 MAX(addr.AddressID) as AddressID,isnull(addr.PostCode,'') as PostCode,isnull(addr.ContactName,'') as ContactName,isnull(addr.AddressOne,'') as AddressOne,isnull(addr.AddressTwo,'') as AddressTwo
	,isnull(addr.Town,'') as Town,isnull(addr.County,'') as County,
	Substring(CASE isnull(addr.Postcode,'') WHEN '' THEN '' ELSE UPPER(addr.Postcode)+', ' END +
	CASE isnull(addr.ContactName,'') WHEN '' THEN '' ELSE LOWER(addr.ContactName)+', ' END + 
	CASE isnull(addr.AddressOne,'') WHEN '' THEN '' ELSE LOWER(addr.AddressOne)+', ' END +
	CASE isnull(addr.AddressTwo,'') WHEN '' THEN '' ELSE LOWER(addr.AddressTwo)+', ' END +
	CASE isnull(addr.Town,'') WHEN '' THEN '' ELSE LOWER(addr.Town)+', ' END +
	CASE isnull(addr.County,'') WHEN '' THEN '' ELSE LOWER(addr.County) END
	,1,1000)
	AS Display from Orders o
	left join [address] addr on addr.AddressID = o.DeliveryAddressId
	where o.ARCId=@ArcId and addr.AddressID is not null
	group by addr.PostCode,addr.ContactName,addr.AddressOne,addr.AddressTwo
	,addr.Town,addr.County 
	ORDER BY AddressID Desc 
	) as X
	ORDER BY PostCode
END 
ELSE
BEGIN
	select MAX(addr.AddressID) as AddressID,isnull(addr.PostCode,'') as PostCode,isnull(addr.ContactName,'') as ContactName,isnull(addr.AddressOne,'') as AddressOne,isnull(addr.AddressTwo,'') as AddressTwo
	,isnull(addr.Town,'') as Town,isnull(addr.County,'') as County,
	Substring(CASE isnull(addr.Postcode,'') WHEN '' THEN '' ELSE UPPER(addr.Postcode)+', ' END +
	CASE isnull(addr.ContactName,'') WHEN '' THEN '' ELSE LOWER(addr.ContactName)+', ' END + 
	CASE isnull(addr.AddressOne,'') WHEN '' THEN '' ELSE LOWER(addr.AddressOne)+', ' END +
	CASE isnull(addr.AddressTwo,'') WHEN '' THEN '' ELSE LOWER(addr.AddressTwo)+', ' END +
	CASE isnull(addr.Town,'') WHEN '' THEN '' ELSE LOWER(addr.Town)+', ' END +
	CASE isnull(addr.County,'') WHEN '' THEN '' ELSE LOWER(addr.County) END
	,1,1000)
	AS Display from Orders o
	left join [address] addr on addr.AddressID = o.DeliveryAddressId
	where o.ARCId=@ArcId and addr.AddressID is not null
	AND dbo.TRIM(Postcode) like dbo.TRIM(@postcode) + '%'
	group by addr.PostCode,addr.ContactName,addr.AddressOne,addr.AddressTwo
	,addr.Town,addr.County 
	ORDER BY AddressID Desc 
END 
END  
END TRY   
BEGIN CATCH   
EXEC USP_SaveSPErrorDetails  
RETURN -1   
END CATCH