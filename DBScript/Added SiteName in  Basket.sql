

 
  IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'SiteName' AND Object_ID = Object_ID(N'OrderItemDetails'))    
BEGIN
ALTER TABLE OrderItemDetails ADD SiteName VARCHAR(256) null
END
GO

IF  EXISTS ( SELECT 1 FROM sys.procedures WHERE name LIKE 'USP_UpdateOrderItemDetailsToBasket') 
BEGIN
DROP PROC  USP_UpdateOrderItemDetailsToBasket
END
GO
CREATE PROCEDURE [dbo].[USP_UpdateOrderItemDetailsToBasket]   
(  
    @OrderItemDetailId  INT,  
    @GPRSNo             VARCHAR(50),  
    @GPRSNoPostCode     VARCHAR(50),  
    @CreatedBy          VARCHAR(256),  
    @PSTNNo             NVARCHAR(50),
    @SiteName   VARCHAR(256),
    @optionId   INT  
)  
AS  
BEGIN TRY  
    BEGIN  
        UPDATE OrderItemDetails  
        SET    GPRSNo = @GPRSNo,  
               GPRSNoPostCode = @GPRSNoPostCode,  
               ModifiedOn = GETDATE(),  
               ModifiedBy = @CreatedBy,  
               PSTNNo = @PSTNNo,  
               SiteName = @SiteName, 
               OptionId = @optionId  
        WHERE  OrderItemDetailId = @OrderItemDetailId  
    END  
END TRY       
BEGIN CATCH  
    EXEC USP_SaveSPErrorDetails   
    RETURN -1  
END CATCH 

GO

IF  EXISTS ( SELECT 1 FROM sys.procedures WHERE name LIKE 'USP_GetBasketGPRSChipNumbersByProductId') 
BEGIN
DROP PROC  USP_GetBasketGPRSChipNumbersByProductId
END
GO


CREATE PROCEDURE [dbo].[USP_GetBasketGPRSChipNumbersByProductId]   
(@OrderId INT, @ProductId INT, @CategoryId INT)  
AS  
BEGIN TRY  
    BEGIN  
        SELECT OID.GPRSNo,  
               OID.GPRSNoPostCode,  
               OID.OrderItemDetailId,  
               ISNULL(OID.PSTNNo, '') PSTNNo,  
               ISNULL(OID.SiteName, '') SiteName, 
               ISNULL(OID.OptionId, 0) OptionId,  
               ISNULL(pom.OptionName, '') OptionName 
               
        FROM   OrderItemDetails OID  
               INNER JOIN OrderItems OI  
                    ON  OI.OrderItemId = OID.OrderItemId  
               INNER JOIN Orders O  
                    ON  O.OrderId = OI.OrderId  
               LEFT JOIN Options pom  
                    ON  pom.OptID = OID.OptionId  
              
        WHERE  O.OrderId = @OrderId  
               AND OI.ProductId = @ProductId  
               AND OI.CategoryId = @CategoryId  
    END  
END TRY       
BEGIN CATCH  
    EXEC USP_SaveSPErrorDetails   
    RETURN -1  
END CATCH 


