USE [ARC_Ordering]
GO

/****** Object:  StoredProcedure [dbo].[GetOfferData]    Script Date: 05/27/2013 10:35:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetOfferData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetOfferData]
GO

USE [ARC_Ordering]
GO

/****** Object:  StoredProcedure [dbo].[GetOfferData]    Script Date: 05/27/2013 10:35:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetOfferData]  
@dlvtypeid int  
  
As  
BEGIN TRY   
BEGIN  
  
select dl.DeliveryOfferId DeleteID,'0' Delivery_Prod_SibblingId,dl.DeliveryOfferId,ISNULL(p.ProductId,-1) as ProductId,dl.DeliveryTypeId, dl.OrderValue, dl.ARCId,  
 dl.MaxQty, dl.MinQty,   
 ARCDisp = isnull('['+ a.ARC_Code+ '] - ','')  + isnull(a.CompanyName,''),  
  isnull('[' +p.ProductCode + '] - ','') + isnull(p.ProductName,'')  AS ProductDisp,  
  case isnull(dl.ProductId,-1) when -1 then Cast(0 as bit) else Cast(1 as bit) end as CanCreateSibblings  
  from DeliveryOffers dl  
left join ARC a on dl.ARCId=a.ARCId  
left join Products p on dl.ProductId=p.ProductId  
where DeliveryTypeId=@dlvtypeid  
  
union  
  
select '0' DeleteID ,Delivery_Prod_SibblingId,dl.DeliveryOfferId,isnull(sib.Sibbling_ProductId,-1) as ProductId,dl.DeliveryTypeId, dl.OrderValue, dl.ARCId,  
 dl.MaxQty, dl.MinQty,   
 ARCDisp = isnull('['+ a.ARC_Code+ '] - ','')  + isnull(a.CompanyName,''),  
 ProductDisp =  isnull('[' +p.ProductCode + '] - ','') + isnull(p.ProductName,''),  
  case isnull(dl.ProductId,-1) when -1 then Cast(0 as bit) else Cast(1 as bit) end as CanCreateSibblings  
  from Delivery_Product_Sibblings sib   
   left join DeliveryOffers dl on dl.DeliveryOfferId=sib.DeliveryOfferId  
   left join Products p on sib.Sibbling_ProductId =p.ProductId  
   left join ARC a on dl.ARCId =a.ARCId and a.IsDeleted=0  
     
where dl.DeliveryTypeId=@dlvtypeid   order by dl.ARCId,ProductId  
  
  
END  
END TRY   
BEGIN CATCH   
EXEC USP_SaveSPErrorDetails  
RETURN -1   
END CATCH   
  
   
  
  
  
GO


