CREATE TRIGGER trg_CheckStock_BeforeInsert
ON OrderDetails
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Products p ON i.ProductID = p.ProductID
        WHERE i.Quantity > p.UnitsInStock
    )
    BEGIN
        RAISERROR ('Order cannot be placed. Insufficient stock.', 16, 1);
        RETURN;
    END

    INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
    SELECT OrderID, ProductID, Quantity
    FROM inserted;

    UPDATE p
    SET p.UnitsInStock = p.UnitsInStock - i.Quantity
    FROM Products p
    JOIN inserted i ON p.ProductID = i.ProductID;
END;
