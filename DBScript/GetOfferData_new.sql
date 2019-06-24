USE [ARC_Ordering]
GO

/****** Object:  StoredProcedure [dbo].[GetOfferData]    Script Date: 08/01/2013 17:15:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetOfferData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetOfferData]
GO

USE [ARC_Ordering]
GO

/****** Object:  StoredProcedure [dbo].[GetOfferData]    Script Date: 08/01/2013 17:15:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetOfferData]--32  
@dlvtypeid int  
  
As  
BEGIN TRY   
BEGIN  
  
select dl.DeliveryOfferId,ISNULL(p.ProductId,-1) as ProductId,dl.DeliveryTypeId, dl.OrderValue, dl.ARCId,  
 dl.MaxQty, dl.MinQty,   
 ARCDisp = isnull('['+ a.ARC_Code+ '] - ','')  + isnull(a.CompanyName,''),  
  isnull('[' +p.ProductCode + '] - ','') + isnull(p.ProductName,'')  AS ProductDisp,  
  case isnull(dl.ProductId,-1) when -1 then 0 else 1 end  AS CanCreateSibblings 
   from DeliveryOffers dl  
left join ARC a on dl.ARCId=a.ARCId  
left join Products p on dl.ProductId=p.ProductId  
where DeliveryTypeId=@dlvtypeid


 
  
END  
END TRY   
BEGIN CATCH   
EXEC USP_SaveSPErrorDetails  
RETURN -1   
END CATCH 


GO


