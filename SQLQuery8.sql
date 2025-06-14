CREATE TRIGGER trg_DeleteOrder_Instead
ON Orders
INSTEAD OF DELETE
AS
BEGIN
    DELETE od
    FROM [Order Details] od
    INNER JOIN deleted d ON od.OrderID = d.OrderID;

    DELETE o
    FROM Orders o
    INNER JOIN deleted d ON o.OrderID = d.OrderID;
END;
