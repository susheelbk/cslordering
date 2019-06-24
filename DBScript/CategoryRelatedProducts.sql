
USE [ARC_Ordering]
GO


CREATE TABLE [dbo].[CategoryRelatedProducts](
	[CategoryRelatedProductId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NULL,
	[CategoryId] [int] NULL,
 CONSTRAINT [PK_CategoryRelatedProducts] PRIMARY KEY CLUSTERED 
(
	[CategoryRelatedProductId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


IF  EXISTS ( SELECT 1 FROM sys.procedures WHERE name LIKE 'USP_GetCategoryRelatedProducts') 
BEGIN
DROP PROC  USP_GetCategoryRelatedProducts
END
GO
    
CREATE PROCEDURE [dbo].[USP_GetCategoryRelatedProducts]  
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
               t.IsCSD  
        FROM   (  
                    SELECT p.ProductId,  
                          p.ProductCode,  
                          p.ProductName,  
                          p.DefaultImage,  
                          p.ProductType,  
                          p.Price,  
                          ISNULL (ppm.Price,0.0) AS ARC_Price,  
                          p.ListOrder,  
                          ISNULL(p.IsCSD,0)IsCSD  
                   FROM   CategoryRelatedProducts crp  
                          INNER JOIN Category c  
                               ON  c.CategoryId = crp. CategoryId  AND c.CategoryId = @CategoryId  
                          INNER JOIN Products p   
                               ON  p.ProductId = crp.ProductId
                                INNER JOIN Product_ARC_Map pam  
                               ON  pam.ProductId = p.ProductId  
                               AND pam.ARCId = @ARC_Id  
                          LEFT JOIN ARC_Product_Price_Map ppm  
                               ON  ppm.ProductId = p.ProductId  
                               AND DATEDIFF(d, ISNULL(ppm.ExpiryDate, GETDATE()), GETDATE())  
                                   > 0  
                               AND ppm.IsDeleted = 0  
                   WHERE  p.IsDependentProduct = 0  
                          AND p.IsDeleted = 0  
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
GO


