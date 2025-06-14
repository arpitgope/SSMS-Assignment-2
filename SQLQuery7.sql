CREATE VIEW vwCustomerOrders AS
SELECT 
    c.CustomerID,
    so.SalesOrderID AS OrderID,
    so.OrderDate,
    sod.ProductID,
    p.Name AS ProductName,
    sod.OrderQty AS Quantity,
    sod.UnitPrice,
    (sod.OrderQty * sod.UnitPrice) AS TotalPrice
FROM Sales.SalesOrderHeader so
JOIN Sales.Customer c ON so.CustomerID = c.CustomerID
JOIN Sales.SalesOrderDetail sod ON so.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID;
