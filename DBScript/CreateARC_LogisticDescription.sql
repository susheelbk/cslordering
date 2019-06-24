
IF  EXISTS ( SELECT 1 FROM sys.procedures WHERE name LIKE 'CreateARC') 
BEGIN
DROP PROC  CreateARC
END
GO


CREATE PROCEDURE [dbo].[CreateARC]
	@arcid INT,
	@arccode NVARCHAR(255),
	@arcname NVARCHAR(256),
	@email NVARCHAR(256),
	@fax NVARCHAR(256),
	@primcontact NVARCHAR(256),
	@telphn NVARCHAR(256),
	@addone NVARCHAR(256),
	@addtwo NVARCHAR(256),
	@town NVARCHAR(256),
	@postcode NVARCHAR(256),
	@county NVARCHAR(256),
	@country NVARCHAR(256),
	@billaccno NVARCHAR(256),
	@annualbilling BIT,
	@allowreturn BIT,
	@postingoption BIT,
	@isbulkuploadallowed BIT,
	@isapiaccess BIT,
	@arcSalesledgeno nvarchar(50),
	@productoptionid INT,
	@arcemailCC NVARCHAR(256),
	@arcTypesId INT,
	@description NVARCHAR(256),
	@LogisticDescription NVARCHAR(500)
AS
BEGIN TRY
    BEGIN
        IF EXISTS (
               SELECT ARCId
               FROM   ARC
               WHERE  (ARC_Code = @arccode
                      AND ARCId != @arcid)Or(SalesLedgerNo = @arcSalesledgeno
                      AND ARCId != @arcid)
           )
        BEGIN
            SELECT 0 AS [ARCId];
        END
        ELSE
        BEGIN
            IF (@arcid != 0)
            BEGIN
                UPDATE ARC
                SET    ARC_Code = @arccode,
                       ARC_Email = @email,
                       BillingAccountNo = @billaccno,
                       CompanyName = @arcname,
                       IsDeleted = 0,
                       Country = @country,
                       County = @county,
                       Fax = @fax,
                       IsBulkUploadAllowed = @isbulkuploadallowed,
                       PrimaryContact = @primcontact,
                       Telephone = @telphn,
                       Town = @town,
                       AnnualBilling = @annualbilling,
                       AllowReturns = @allowreturn,
                       PostingOption = @postingoption,
                       PostCode = @postcode,
                       AddressOne = @addone,
                       AddressTwo = @addtwo,
                       IsAPIAccess = @isapiaccess,
                       SalesLedgerNo=@arcSalesledgeno,
                       ProductOptionId= @productoptionid,
                       ARC_CCEmail=@arcemailCC,
                       ArcTypeId=@arcTypesId,
                       [DESCRIPTION]=@description,
                       LogisticsDescription = @LogisticDescription
                WHERE  ARCId = @arcid
                
                ;
                
                DELETE 
                FROM   ARC_Category_Map
                WHERE  ARCId = @arcid
                
                ;
                DELETE 
                FROM   Product_ARC_Map
                WHERE  ARCId = @arcid
                
                ;
                
                SELECT @arcid AS [ARCId];
            END
            ELSE
            BEGIN
                INSERT INTO ARC
                  (
                    ARC_Code,
                    ARC_Email,
                    BillingAccountNo,
                    CompanyName,
                    Country,
                    County,
                    Fax,
                    IsBulkUploadAllowed,
                    IsDeleted,
                    PostCode,
                    PostingOption,
                    PrimaryContact,
                    Telephone,
                    Town,
                    AddressOne,
                    AddressTwo,
                    AllowReturns,
                    AnnualBilling,
                    IsAPIAccess,
                    SalesLedgerNo,
                    ProductOptionId,
                    ARC_CCEmail,
                    ArcTypeId,
                    [Description],
                    LogisticsDescription
                  )
                VALUES
                  (
                    @arccode,
                    @email,
                    @billaccno,
                    @arcname,
                    @country,
                    @county,
                    @fax,
                    @isbulkuploadallowed,
                    0,
                    @postcode,
					@postingoption,
                    @primcontact,
                    @telphn,
                    @town,
					@addone,
                    @addtwo,
                    @allowreturn,
					@annualbilling,
                    @isapiaccess,
                    @arcSalesledgeno,
                    @productoptionid,
                    @arcemailCC,
                    @arcTypesId,
                    @description,
                    @LogisticDescription
                  );
                
                SELECT CAST(SCOPE_IDENTITY() AS INT) AS [ARCId];
            END
        END
    END
END TRY

BEGIN CATCH
    EXEC USP_SaveSPErrorDetails
    RETURN -1
END CATCH






GO