    
    
CREATE PROCEDURE [dbo].[SP_GetDistributerUI]    
@UrlName nvarchar(max)    
      
AS      
      
 BEGIN      
 Select * from DistributerUIDetails nolock  
 where UrlName like '%'+@UrlName+'%'  
 END      
    