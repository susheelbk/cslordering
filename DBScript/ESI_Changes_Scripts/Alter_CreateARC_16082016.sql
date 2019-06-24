
GO
/****** Object:  StoredProcedure [dbo].[CreateARC]    Script Date: 08/16/2016 13:07:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Modified by:Atiq
-- Modified Date:12-08-2018
-- Add one more parameter @IsARCAllowedForBranch for ESI Changes
ALTER PROCEDURE [dbo].[CreateARC]
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
	@countrycode NVARCHAR(10),
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
	@isDeleted BIT=0,
	@PolltoEIRE BIT=0,
	@ExcludeTerms BIT=0,
	@IsAllowedCSD BIT=0,
	@EnablePostCodeSearch BIT=0,
	@ReplenishmentLimit INT,
	@IsARCAllowedForBranch BIT
AS
--BEGIN TRY

    BEGIN
	SET NOCOUNT ON
        IF EXISTS (
               SELECT ARCId
               FROM   ARC
               WHERE  (ARC_Code = @arccode
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
					   CountryCode = @countrycode,
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
                       IsDeleted = @isDeleted,
                       PolltoEIRE =@PolltoEIRE,
                       ExcludeTerms = @ExcludeTerms,
                       IsAllowedCSD = @IsAllowedCSD,
                       EnablePostCodeSearch = @EnablePostCodeSearch,
					   ReplenishmentLimit = @ReplenishmentLimit,
					   ModifiedOn = GetDate(),
					   IsARCAllowedForBranch=@IsARCAllowedForBranch
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
                    CountryCode,
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
                    IsDeleted,
                    PolltoEIRE,
                    ExcludeTerms,
                    IsAllowedCSD,
					EnablePostCodeSearch,
					ReplenishmentLimit,
					IsARCAllowedForBranch
                  )
                VALUES
                  (
                    @arccode,
                    @email,
                    @billaccno,
                    @arcname,
                    @country,
                    @countrycode,
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
                    @isDeleted,
                    @PolltoEIRE,
                    @ExcludeTerms,
                    @IsAllowedCSD,
					@EnablePostCodeSearch,
					@ReplenishmentLimit,
					@IsARCAllowedForBranch
                  );
                
                SELECT CAST(SCOPE_IDENTITY() AS INT) AS [ARCId];
            END
        END
    END
--END TRY

--BEGIN CATCH
--    EXEC USP_SaveSPErrorDetails
--    RETURN -1
--END CATCH








--/****** Object:  Trigger [dbo].[ARC_Insert]    Script Date: 23/09/2014 14:39:01 ******/
--SET ANSI_NULLS ON







/****** Object:  Table [dbo].[Product_ARC_Map]    Script Date: 23/02/2015 14:35:55 ******/
--ALREADY CREATED ON LIVE
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE TABLE [dbo].[Product_Installer_Map](
--	[Id] [int] IDENTITY(1,1) NOT NULL,
--	[ProductId] [int] NOT NULL,
--	[InstallerId] [uniqueidentifier] NOT NULL,
-- CONSTRAINT [PK_Product_Installer_Map] PRIMARY KEY CLUSTERED 
--(
--	[Id] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY]

--GO









--insert into product_installer_map (ProductId,InstallerId)
-- select ProductId,[InstallerId] from
--(
--   ( select p.ProductId from product_arc_map pam
--   join products p on pam.ProductId = p.ProductId
--    where listedoncslconnect = 1 and arcid = 10) as A
--	cross join 
--(SELECT distinct [InstallerId]
--  FROM [Orders]
--  where ordertype = 2) as b 
-- )
-- order by 1,2







-- SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		Alex Papayianni
---- Create date: 24/02/2015
---- Description:	To activate the products for Installers on M2M Connect
---- =============================================
--CREATE PROCEDURE USP_ActivateInstallerProducts
-- @arcCode nvarchar(100),
-- @installerId uniqueidentifier
--AS
--BEGIN
--if not exists (select ProductId from Product_Installer_Map where InstallerId = @installerId)
--begin
--UPDATE Installer
--set IsVoiceSMSVisible = (select IsVoiceSMSVisible from ARC where ARC_Code = @arcCode)
--where InstallerCompanyID = @installerId and IsVoiceSMSVisible != (select IsVoiceSMSVisible from ARC where ARC_Code = @arcCode)

--insert into product_installer_map (ProductId,InstallerId)
-- select ProductId,[InstallerId] from
--(
--   ( select p.ProductId from product_arc_map pam
--   join products p on pam.ProductId = p.ProductId
--   join arc a on pam.arcid = a.ARCId
--    where listedoncslconnect = 1 and a.ARC_Code = @arcCode ) as A
--	cross join 
--(SELECT @installerId as InstallerId) as b 
-- )
-- order by 1,2
-- end

--END
--GO








/****** Object:  StoredProcedure [dbo].[CreateProduct]    Script Date: 24/02/2015 14:18:35 ******/
SET ANSI_NULLS ON
