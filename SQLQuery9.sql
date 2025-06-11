-- Should succeed
INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES (1, 1, 10);

-- Should fail due to insufficient stock
INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES (1, 1, 1000);
