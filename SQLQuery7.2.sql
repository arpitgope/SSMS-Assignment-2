ALTER VIEW MyProducts AS
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.ProductNumber,
    p.Size,
    p.StandardCost,
    p.ListPrice AS UnitPrice,
    v.Name AS SupplierName,
    c.Name AS CategoryName
FROM Production.Product p
JOIN Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
JOIN Production.ProductSubcategory sc ON p.ProductSubcategoryID = sc.ProductSubcategoryID
JOIN Production.ProductCategory c ON sc.ProductCategoryID = c.ProductCategoryID
WHERE p.DiscontinuedDate IS NULL OR p.SellEndDate IS NULL;
