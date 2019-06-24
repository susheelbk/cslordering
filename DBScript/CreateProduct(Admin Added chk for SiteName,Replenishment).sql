 
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
@IsReplenishment BIT =0
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
                       IsDeleted = 0,
                       ProductType = @prodtype,
                       IsDependentProduct = @IsDependent,
                       ModifiedBy = @user,
                       ModifiedOn = GETDATE(),
                       SeoUrl = @prodname,
                       ListOrder = @listorder,
                       IsCSD = @IsCSD,
                       [Message] = @Msg,
                       CSL_Grade= @prodgrade,
                       IsSiteNameEnabled=@IsSiteName,
                        IsReplenishmentEnabled=@IsReplenishment
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
                    IsDeleted,
                    ListOrder,
                    SeoUrl,
                    IsDependentProduct,
                    Price,
                    ProductType,
                    ModifiedOn,
                    IsCSD,
                    [Message],
                    CSL_Grade,
                    IsSiteNameEnabled,
                    IsReplenishmentEnabled
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
                    0,
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
                    @IsReplenishment
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


