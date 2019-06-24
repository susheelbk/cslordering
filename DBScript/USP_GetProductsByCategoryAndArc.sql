ALTER PROCEDURE [dbo].[USP_GetProductsByCategoryAndArc]
	@CategoryId INT,
	@ARC_Id INT
AS
BEGIN TRY
    BEGIN
        SELECT t.ProductId,
               t.ProductCode,
               t.ProductName,
               t.DefaultImage,
               t.ProductType,
               CASE ISNULL(t.ARC_Price, 0)
                    WHEN 0 THEN t.Price
                    ELSE t.ARC_Price
               END AS Price,
               t.ListOrder,
               t.IsCSD,
               t.IsSiteName,
               t.IsReplenishment
        FROM   (
                   SELECT p.ProductId,
                          p.ProductCode,
                          p.ProductName,
                          p.DefaultImage,
                          p.ProductType,
                          p.Price,
                          ppm.Price AS ARC_Price,
                          p.ListOrder,
                          ISNULL(p.IsCSD, 0)IsCSD,
                          ISNULL(p.IsReplenishment,0) IsReplenishment,
                          ISNULL(p.IsSiteName,0 )IsSiteName
                   FROM   Products p
                          INNER JOIN Category_Product_Map cp
                               ON  cp.ProductId = p.ProductId
                               AND cp.CategoryId = @CategoryId
                          INNER JOIN Product_ARC_Map pam
                               ON  pam.ProductId = p.ProductId AND p.IsDependentProduct = 0 AND p.IsDeleted = 0 
                               AND pam.ARCId = @ARC_Id
                          LEFT JOIN ARC_Product_Price_Map ppm
                               ON  ppm.ProductId = p.ProductId AND ppm.IsDeleted = 0 AND CONVERT(DATETIME, GETDATE()) <= CONVERT(DateTime,ppm.ExpiryDate) AND ppm.ARCId=@ARC_Id
                  
               ) t
        ORDER BY
               t.ListOrder,
               t.ProductName
    END
END TRY         
BEGIN CATCH
    EXEC USP_SaveSPErrorDetails 
    RETURN -1
END CATCH






