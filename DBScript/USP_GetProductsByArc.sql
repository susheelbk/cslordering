
ALTER PROCEDURE [dbo].[USP_GetProductsByArc]
	@ARC_Id INT
AS
BEGIN TRY
    BEGIN
        -- Select t.ProductId, t.ProductCode, t.ProductName,
        --t.ARC_Price  Price, t.ListOrder,  case ExpDate when '01/01/1900' then null else ExpDate end ExpDate
        --from
        --(Select p.ProductId, p.ProductCode, p.ProductName,  p.ProductType,
        --	 ppm.Price as ARC_Price, p.ListOrder,ISNULL(CONVERT(VARCHAR(10),ppm.ExpiryDate,101),CONVERT(VARCHAR(10), '01/01/1900 00:00:00.000',101)) ExpDate
        --	from
        --	Products p
        --	inner join
        --	Product_ARC_Map pam on pam.ProductId = p.ProductId And pam.ARCId = @ARC_Id
        --	left join
        --	ARC_Product_Price_Map ppm on ppm.ProductId = p.ProductId AND ppm.ARCId= @ARC_Id and ppm.IsDeleted=0
        
        --	Where p.IsDeleted=0 and p.IsDependentProduct=0
        --) t
        --Order By t.ListOrder
         DECLARE @temp TABLE(ProductId INT ,ProductCode NVARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS,
         ProductName NVARCHAR(512)COLLATE SQL_Latin1_General_CP1_CI_AS,
         ProductType NVARCHAR(10)COLLATE SQL_Latin1_General_CP1_CI_AS,ARC_Price DECIMAL(6,2),
         ListOrder INT,ExpDate DATETIME )
        
        
        INSERT   @temp
        SELECT p.ProductId,
               p.ProductCode,
               p.ProductName,
               p.ProductType,
               ppm.Price AS ARC_Price,
               p.ListOrder,
               ISNULL(
                   CONVERT(VARCHAR(10), ppm.ExpiryDate, 101),
                   CONVERT(VARCHAR(10), '01/01/1900 00:00:00.000', 101)
               ) ExpDate 
               
        FROM   Products p
               INNER JOIN Product_ARC_Map pam
                    ON  pam.ProductId = p.ProductId
                    AND pam.ARCId = @ARC_Id
               LEFT JOIN ARC_Product_Price_Map ppm
                    ON  ppm.ProductId = p.ProductId
                    AND ppm.ARCId = @ARC_Id
                    AND ppm.IsDeleted = 0
        WHERE  p.IsDeleted = 0
               AND p.IsDependentProduct = 0  
        
        
        SELECT t.ProductId,
               t.ProductCode,
               t.ProductName,
               t.ARC_Price Price,
               t.ListOrder,
               CASE ExpDate
                   WHEN '01/01/1900' THEN '01/01/1900'
                    ELSE CONVERT(VARCHAR(10), ExpDate, 103)
               END ExpDate
        FROM   (
                   SELECT p.ProductId,
                          p.ProductCode,
                          p.ProductName,
                          p.ProductType,
                          ppm.Price AS ARC_Price,
                          p.ListOrder,
                          ISNULL(
                              CONVERT(VARCHAR(10), ppm.ExpiryDate, 101),
                              CONVERT(VARCHAR(10), '01/01/1900 00:00:00.000', 101)
                          ) ExpDate
                   FROM   Product_Dependent_Map pdm
                          INNER JOIN @temp t 
                               ON  pdm.ProductId  = t.ProductId  
                          INNER JOIN Products p
                               ON  p.ProductId   = pdm.DependentProductId   
                          LEFT JOIN ARC_Product_Price_Map ppm
                               ON  ppm.ProductId   = p.ProductId   
                               AND ppm.ARCId   = @ARC_Id   
                               AND ppm.IsDeleted = 0
                   WHERE  p.IsDeleted = 0 
                   UNION
                   SELECT ProductId,
                          ProductCode,
                          ProductName,
                          ProductType,
                          ARC_Price,
                          ListOrder,
                           ISNULL(
                               ExpDate,
                              CONVERT(VARCHAR(10), '01/01/1900 00:00:00.000', 101)
                          ) ExpDate
                   FROM   @temp   
               ) t
        
        
    END
    RETURN 0
END TRY
BEGIN CATCH
    EXEC USP_SaveSPErrorDetails
    RETURN -1
END CATCH








