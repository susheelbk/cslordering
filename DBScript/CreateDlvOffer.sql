
CREATE PROCEDURE [dbo].[CreateDlvOffer]
	@dlvofferid INT,
	@dlvtypeid INT,
	@orderval DECIMAL(8, 2) = 0,
	@arcid INT,
	@proid INT,
	@user VARCHAR(256),
	@minqty INT,
	@maxqty INT,
	@InstallerCompanyID UNIQUEIDENTIFIER,
	@ExpiryDate DATETIME
AS
BEGIN TRY
    BEGIN
        IF (@dlvofferid != 0)
        BEGIN
            UPDATE DeliveryOffers
            SET    DeliveryTypeId = @dlvtypeid,
                   OrderValue = @orderval,
                   ARCId = @arcid,
                   ProductId = @proid,
                   MinQty = @minqty,
                   MaxQty = @maxqty,
                   ModifiedBy = @user,
                   ModifiedOn = GETDATE(),
                   InstallerCompanyID=@InstallerCompanyID,
                   ExpiryDate = @ExpiryDate
            WHERE  DeliveryOfferId = @dlvofferid
            
            ;
            
            SELECT @dlvofferid AS [DeliveryOfferId];
        END
        ELSE
        BEGIN
            INSERT INTO DeliveryOffers
              (
                DeliveryTypeId,
                MaxQty,
                MinQty,
                OrderValue,
                ProductId,
                ARCId,
                CreatedBy,
                CreatedOn,
                InstallerCompanyID,
                ExpiryDate
              )
            VALUES
              (
                @dlvtypeid,
                @maxqty,
                @minqty,
                @orderval,
                @proid,
                @arcid,
                @user,
                GETDATE(),
                @InstallerCompanyID,
                @ExpiryDate
              );
            
            SELECT CAST(SCOPE_IDENTITY() AS INT) AS [DeliveryOfferId];
        END
    END
END TRY 
BEGIN CATCH
    EXEC USP_SaveSPErrorDetails
    RETURN -1
END CATCH 
 
 


