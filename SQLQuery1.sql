CREATE PROCEDURE InsertOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice MONEY = NULL,
    @Quantity INT,
    @Discount FLOAT = 0
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Stock INT;
    DECLARE @ReorderLevel INT;
    DECLARE @FinalPrice MONEY;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Step 1: Check current stock and reorder level
        SELECT 
            @Stock = QuantityInStock,
            @ReorderLevel = ReorderLevel
        FROM ProductInventory
        WHERE ProductID = @ProductID;

        -- Step 2: If product doesn't exist in inventory
        IF @Stock IS NULL
        BEGIN
            PRINT 'Product not found in inventory.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Step 3: Check if enough stock is available
        IF @Stock < @Quantity
        BEGIN
            PRINT 'Not enough stock.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Step 4: Use product price if not provided
        IF @UnitPrice IS NULL
        BEGIN
            SELECT @FinalPrice = UnitPrice 
            FROM Product 
            WHERE ProductID = @ProductID;

            IF @FinalPrice IS NULL
            BEGIN
                PRINT 'Product price not found.';
                ROLLBACK TRANSACTION;
                RETURN;
            END
        END
        ELSE
        BEGIN
            SET @FinalPrice = @UnitPrice;
        END

        -- Step 5: Insert the order detail
        INSERT INTO SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice, UnitPriceDiscount)
        VALUES (@OrderID, @ProductID, @Quantity, @FinalPrice, @Discount);

        -- Step 6: Verify insert success
        IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Failed to place the order. Please try again.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Step 7: Update inventory
        UPDATE ProductInventory
        SET QuantityInStock = QuantityInStock - @Quantity
        WHERE ProductID = @ProductID;

        -- Step 8: Warn if stock goes below reorder level
        SELECT @Stock = QuantityInStock 
        FROM ProductInventory 
        WHERE ProductID = @ProductID;

        IF @Stock < @ReorderLevel
        BEGIN
            PRINT 'Warning: Stock below reorder level.';
        END

        COMMIT TRANSACTION;
        PRINT 'Order placed successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
