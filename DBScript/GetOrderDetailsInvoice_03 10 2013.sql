
  
  IF  EXISTS ( SELECT 1 FROM sys.procedures WHERE name LIKE 'GetOrderDetailsInvoice') 
BEGIN
DROP PROC  GetOrderDetailsInvoice
END
GO     
CREATE PROCEDURE [dbo].[GetOrderDetailsInvoice](@orderno NVARCHAR(256))                  
AS                  
  SELECT DISTINCT convert(varchar,convert(datetime,o.OrderDate,3),106) as OrderDate,                  
        arc.ARC_Code,                    
        arc.Country,                    
        o.OrderNo,                    
        o.Amount,                    
        o.DeliveryCost,                    
        o.OrderTotalAmount,                   
        o.ProcessedBy,         
        o.DeliveryNoteNo,         
        case convert(varchar,o.SpecialInstructions) when '' then 'Not Available' else convert(varchar,o.SpecialInstructions) end AS SpecialInstructions,                
        arc.CompanyName,                    
        arc.AddressOne,                    
        arc.AddressTwo,                    
        arc.PostCode,                    
        arc.Telephone,                    
        arc.Fax,                    
        arc.ARC_Email,                    
        dlvadr.AddressOne AS dlvaddres,                    
        dlvadr.AddressTwo AS dlvaddres2,                    
        dlvadr.CompanyName AS dlvcompanyname,                    
        dlvadr.PostCode AS dlvpostcode,                    
        dlvadr.ContactName AS dlvContactName,                
        dlvadr.Telephone AS dlvTelephone,           
        dlvadr.Mobile AS dlvMobile,           
        dlvadr.Town AS dlvTown,                 
        insadr.AddressOne AS insaddres,                    
        case o.InstallationAddressID when 0 then 'Not Available' else insadr.CompanyName end AS inscompantname,                    
        insadr.AddressTwo AS insaddres2,                    
        insadr.PostCode AS inspostcode,  
         insadr.ContactName AS insContactName,             
        insadr.Town AS insTown,                    
        case dt.DisplayonDeliveryNote when 1 then dt.DeliveryCompanyName  else '' end as DeliveryCompanyName,                    
        dt.DeliveryShortDesc,              
        dt.DeliveryTypeId,                  
        cm.CountryCode  ,                  
        o.OrderRefNo  ,            
       oid.ItemDlvNoteNo ,          
       oi.ProcessedON         
               
                
                         
 FROM   OrderItems oi                    
        LEFT JOIN Products p                    
             ON  oi.ProductId = p.ProductId                    
        LEFT JOIN Orders o                    
             ON  oi.OrderId = o.OrderId                    
        LEFT JOIN DeliveryType dt                    
             ON  dt.DeliveryTypeId = o.DeliveryTypeId                    
        LEFT JOIN [Address] dlvadr                    
             ON  dlvadr.AddressID = o.DeliveryAddressId                    
        LEFT JOIN [Address] insadr                    
             ON  insadr.AddressID = o.InstallationAddressID                    
        LEFT JOIN ARC arc                    
             ON  arc.ARCId = o.ARCId                    
        LEFT JOIN CountryMaster cm                    
             ON  cm.CountryId = dlvadr.CountryId              
        LEFT JOIN OrderItemDetails oid                    
             ON  oid.OrderItemId = oi.OrderItemId                  
 WHERE  (o.OrderNo = @orderno)and oi.ProcessedON=(Select MAX(ProcessedON) from  OrderItems where orderid=o.OrderId) 
 GO