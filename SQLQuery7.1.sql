CREATE VIEW vwCustomerOrders_Yesterday AS
SELECT 
    c.AccountNumber,
    o.SalesOrderID AS OrderID,
    o.OrderDate,
    od.ProductID,
    p.Name AS ProductName,
    od.OrderQty AS Quantity,
    od.UnitPrice,
    (od.OrderQty * od.UnitPrice) AS TotalPrice
FROM Sales.SalesOrderHeader o
JOIN Sales.Customer c ON o.CustomerID = c.CustomerID
JOIN Sales.SalesOrderDetail od ON o.SalesOrderID = od.SalesOrderID
JOIN Production.Product p ON od.ProductID = p.ProductID
WHERE CAST(o.OrderDate AS DATE) = CAST(DATEADD(DAY, -1, GETDATE()) AS DATE);