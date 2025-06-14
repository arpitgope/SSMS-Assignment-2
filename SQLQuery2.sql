CREATE PROCEDURE UpdateOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice MONEY = NULL,
    @Quantity INT = NULL,
    @Discount FLOAT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OldQuantity INT;
    DECLARE @NewQuantity INT;
    DECLARE @OldUnitPrice MONEY;
    DECLARE @OldDiscount FLOAT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Get existing order values
        SELECT 
            @OldQuantity = OrderQty,
            @OldUnitPrice = UnitPrice,
            @OldDiscount = UnitPriceDiscount
        FROM SalesOrderDetail
        WHERE SalesOrderID = @OrderID AND ProductID = @ProductID;

        IF @OldQuantity IS NULL
        BEGIN
            PRINT 'Order detail not found.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Use original values if NULL is passed
        SET @NewQuantity = ISNULL(@Quantity, @OldQuantity);
        SET @UnitPrice = ISNULL(@UnitPrice, @OldUnitPrice);
        SET @Discount = ISNULL(@Discount, @OldDiscount);

        -- Update inventory stock: restore old, apply new
        UPDATE ProductInventory
        SET QuantityInStock = QuantityInStock + @OldQuantity - @NewQuantity
        WHERE ProductID = @ProductID;

        -- Update order detail
        UPDATE SalesOrderDetail
        SET 
            OrderQty = @NewQuantity,
            UnitPrice = @UnitPrice,
            UnitPriceDiscount = @Discount
        WHERE SalesOrderID = @OrderID AND ProductID = @ProductID;

        IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Failed to update the order.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        PRINT 'Order updated successfully.';
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
