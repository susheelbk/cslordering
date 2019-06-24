
IF  EXISTS ( SELECT 1 FROM sys.procedures WHERE name LIKE 'CreateCategory') 
BEGIN
DROP PROC  CreateCategory
END
GO  


CREATE PROCEDURE [dbo].[CreateCategory]
	@ctgid INT,
	@ctgcode VARCHAR(255),
	@ctgname VARCHAR(256),
	@ctgdesc TEXT,
	@defaultimg VARCHAR(512),
	@largeimg VARCHAR(512),
	@user VARCHAR(256),
	@IsGprschipEmpty BIT,
	@listorder INT,
	@isDeleted BIT =0
AS
BEGIN TRY
    BEGIN
        IF EXISTS (
               SELECT CategoryId
               FROM   Category
               WHERE  CategoryCode = @ctgcode
                      AND CategoryId != @ctgid
           )
        BEGIN
            SELECT 0 AS [CategoryId];
        END
        ELSE
        BEGIN
            IF (@ctgid != 0)
            BEGIN
                UPDATE Category
                SET    CategoryCode = @ctgcode,
                       CategoryName = @ctgname,
                       CategoryDesc = @ctgdesc,
                       DefaultImage = @defaultimg,
                       LargeImage = @largeimg,
                       ModifiedBy = @user,
                       ModifiedOn = GETDATE(),
                       SeoUrl = @ctgname,
                       IsGPRSChipEmpty = @IsGprschipEmpty,
                       ListOrder = @listorder,
                       IsDeleted = @isDeleted
                WHERE  CategoryId = @ctgid
                
                ;
                
                DELETE 
                FROM   Category_Product_Map
                WHERE  CategoryId = @ctgid
                
                ;
                DELETE 
                FROM   ARC_Category_Map
                WHERE  CategoryId = @ctgid
                
                ;
                
                SELECT @ctgid AS [CategoryId];
            END
            ELSE
            BEGIN
                INSERT INTO Category
                  (
                    CategoryCode,
                    CategoryDesc,
                    CategoryName,
                    CreatedBy,
                    CreatedOn,
                    DefaultImage,
                    LargeImage,
                    ModifiedBy,
                    IsDeleted,
                    ListOrder,
                    SeoUrl,
                    IsGPRSChipEmpty
                  )
                VALUES
                  (
                    @ctgcode,
                    @ctgdesc,
                    @ctgname,
                    @user,
                    GETDATE(),
                    @defaultimg,
                    @largeimg,
                    @user,
                    @isDeleted,
                    @listorder,
                    @ctgname,
                    @IsGprschipEmpty
                  );
                
                SELECT CAST(SCOPE_IDENTITY() AS INT) AS [CategoryId];
            END
        END
    END
END TRY

BEGIN CATCH
    EXEC USP_SaveSPErrorDetails
    RETURN -1
END CATCH 
 
 GO
 
 
IF  EXISTS ( SELECT 1 FROM sys.procedures WHERE name LIKE 'CreateProduct') 
BEGIN
DROP PROC  CreateProduct
END
GO 


CREATE PROC [dbo].[CreateProduct]  
@prodid INT,  
@prodcode VARCHAR(255),  
@prodname VARCHAR(256),  
@proddesc TEXT,  
@price DECIMAL(6, 2),  
@defaultimg VARCHAR(512),  
@largeimg VARCHAR(512),  
@user VARCHAR(256),  
@IsDependent BIT,  
@listorder INT,  
@prodtype VARCHAR(50),  
@IsCSD BIT,
@Msg NVARCHAR(256),
@prodgrade nvarchar(50),
@IsSiteName BIT=0,
@IsReplenishment BIT =0,
@CSLDescription TEXT=NULL,
@isDeleted BIT=0
AS  
BEGIN TRY
    BEGIN
        IF EXISTS (
               SELECT ProductId
               FROM   Products
               WHERE  ProductCode = @prodcode
                      AND ProductId != @prodid
           )
        BEGIN
            SELECT 0 AS [ProductId];
        END
        ELSE
        BEGIN
            IF (@prodid != 0)
            BEGIN
                UPDATE Products
                SET    ProductCode = @prodcode,
                       ProductName = @prodname,
                       ProductDesc = @proddesc,
                       Price = @price,
                       DefaultImage = @defaultimg,
                       LargeImage = @largeimg,
                       ProductType = @prodtype,
                       IsDependentProduct = @IsDependent,
                       ModifiedBy = @user,
                       ModifiedOn = GETDATE(),
                       SeoUrl = @prodname,
                       ListOrder = @listorder,
                       IsCSD = @IsCSD,
                       [Message] = @Msg,
                       CSL_Grade= @prodgrade,
                       IsSiteName=@IsSiteName,
                       IsReplenishment=@IsReplenishment,
                       CSLDescription =@CSLDescription,
                       IsDeleted = @isDeleted
                WHERE  ProductId = @prodid
                
                ;  
                
                DELETE 
                FROM   Product_ARC_Map
                WHERE  ProductId = @prodid
                
                ;  
                DELETE 
                FROM   Category_Product_Map
                WHERE  ProductId = @prodid
                
                ;  
                DELETE 
                FROM   Product_Dependent_Map
                WHERE  ProductId = @prodid
                
                ;  
                DELETE 
                FROM   RelatedProducts
                WHERE  ProductId = @prodid
                
                ;  
                
                DELETE 
                FROM   Product_Option_Map
                WHERE  ProductId = @prodid
                
                ;
                
                SELECT @prodid AS [ProductId];
            END
            ELSE
            BEGIN
                INSERT INTO Products
                  (
                    ProductCode,
                    ProductDesc,
                    ProductName,
                    CreatedBy,
                    CreatedOn,
                    DefaultImage,
                    LargeImage,
                    ModifiedBy,
                    ListOrder,
                    SeoUrl,
                    IsDependentProduct,
                    Price,
                    ProductType,
                    ModifiedOn,
                    IsCSD,
                    [Message],
                    CSL_Grade,
                    IsSiteName,
                    IsReplenishment,
                    CSLDescription,
                    IsDeleted
                  )
                VALUES
                  (
                    @prodcode,
                    @proddesc,
                    @prodname,
                    @user,
                    GETDATE(),
                    @defaultimg,
                    @largeimg,
                    @user,
                    @listorder,
                    @prodname,
                    @IsDependent,
                    @price,
                    @prodtype,
					GETDATE(),
                    @IsCSD,
                    @Msg,
                    @prodgrade,
                    @IsSiteName,
                    @IsReplenishment,
                    @CSLDescription,
                    @isDeleted
                  );  
                
                SELECT CAST(SCOPE_IDENTITY() AS INT) AS [ProductId];
            END
        END
    END
END TRY   
BEGIN CATCH
    EXEC USP_SaveSPErrorDetails 
    RETURN -1
END CATCH 


GO

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
	@LogisticDescription NVARCHAR(500),
	@isDeleted BIT=0
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
                       LogisticsDescription = @LogisticDescription,
                       IsDeleted = @isDeleted
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
                    LogisticsDescription,
                    IsDeleted
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
                    @LogisticDescription,
                    @isDeleted
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