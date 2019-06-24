
/****** Object:  StoredProcedure [dbo].[USP_GetUploadedMultipleOrderItems]    Script Date: 12/02/2016 14:38:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Mohd Atiq	
-- Create date: <18-10-2016>
-- Description:	The purpose of this stored to get the results of bulk uploaded multiple orders in Arc Ordering
-- =============================================
Create PROCEDURE [dbo].[USP_GetUploadedMultipleOrderItems] --'ATIQ.M'
(
 @UserName VARCHAR(256)
)
AS
BEGIN
    SELECT ord.OrderId,Ord.OrderNo,
    ord.DeliveryAddressId,
    ISNULL(ord.OrderRefNo,'')AS OrderRefNo,
    Convert(varchar(12),ord.CreatedOn,105)+' '+ Convert(varchar(12),ord.CreatedOn,108) AS UploadedOn,
    Ins.CompanyName,
    Ins.InstallerCompanyId,
    ad.Town	FROM Orders ord
	LEFT JOIN Installer Ins 
	ON Ord.InstallerUnqCode=Ins.UniqueCode
	LEFT JOIN Address ad
	ON AD.AddressId=Ord.DeliveryAddressId
    WHERE Ord.username=@UserName 
    AND Ord.OrderStatusId=21 
    ORDER BY ORD.OrderId DESC
    
	SELECT ord.OrderId,Ord.OrderNo,oi.OrderItemId,
	Ins.CompanyName,
	Oi.ProductId,p.ProductCode,Oi.ProductQty
	FROM Orders ord
	INNER JOIN OrderItems oi
	on ord.OrderId=oi.OrderId
	INNER JOIN  Products p
	ON OI.ProductId=p.ProductId
	LEFT JOIN Installer Ins 
	ON Ord.InstallerUnqCode=Ins.UniqueCode
	WHERE Ord.username=@UserName  AND Ord.OrderStatusId=21
    ORDER BY ORD.OrderId DESC
    
    SELECT ord.OrderNo,prod.ProductCodes,SUM(Oi.ProductQty) AS Qty
	FROM Orders ord
	INNER JOIN OrderItems oi
	on ord.OrderId=oi.OrderId
	INNER JOIN  Products p
	ON OI.ProductId=p.ProductId
	INNER JOIN(SELECT Main.OrderId,
       LEFT(Main.ProductDetails,Len(Main.ProductDetails)-1) As "ProductCodes" FROM
       (
        SELECT DISTINCT ORD.OrderId, 
            (
                Select P.ProductCode + ',' AS [text()]
                From dbo.OrderItems OI
                INNER JOIN Products P
                ON OI.ProductId=p.ProductId
                Where OI.OrderId = ORD.OrderId
                ORDER BY OI.OrderId            
                For XML PATH ('')
            ) [ProductDetails]
        From dbo.Orders ORD
        WHERE ORD.username=@UserName and ORD.OrderStatusId=21
    ) [Main]
    ) AS prod
    ON ord.OrderId=prod.OrderId    
    GROUP BY ord.OrderNo,prod.ProductCodes
    Order by ord.OrderNo
 
END