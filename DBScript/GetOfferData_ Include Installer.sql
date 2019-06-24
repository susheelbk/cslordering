
CREATE PROCEDURE [dbo].[GetOfferData]
@dlvtypeid int  
  
As  
BEGIN TRY   
BEGIN  
  
select dl.DeliveryOfferId,ISNULL(p.ProductId,-1) as ProductId,dl.DeliveryTypeId, dl.OrderValue, dl.ARCId,  
 dl.MaxQty, dl.MinQty,   
 ARCDisp = isnull('['+ a.ARC_Code+ '] - ','')  + isnull(a.CompanyName,''),  
  isnull('[' +p.ProductCode + '] - ','') + isnull(p.ProductName,'')  AS ProductDisp,  
  case isnull(dl.ProductId,-1) when -1 then 0 else 1 end  AS CanCreateSibblings, 
  i.CompanyName AS InstallerCompany
   from DeliveryOffers dl  
left join ARC a on dl.ARCId=a.ARCId  
left join Products p on dl.ProductId=p.ProductId  
LEFT JOIN Installer i ON dl.InstallerCompanyID=i.InstallerCompanyID
where DeliveryTypeId=@dlvtypeid


 
  
END  
END TRY   
BEGIN CATCH   
EXEC USP_SaveSPErrorDetails  
RETURN -1   
END CATCH 



