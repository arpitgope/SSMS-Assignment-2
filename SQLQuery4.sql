IF OBJECT_ID('dbo.DeleteOrderDetails', 'P') IS NOT NULL
    DROP PROCEDURE dbo.DeleteOrderDetails;
GO

CREATE PROCEDURE DeleteOrderDetails
    @OrderID INT,
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate if the combination exists
    IF NOT EXISTS (
        SELECT 1 
        FROM SalesOrderDetail
        WHERE SalesOrderID = @OrderID AND ProductID = @ProductID
    )
    BEGIN
        PRINT 'Error: Either the OrderID or ProductID is invalid.';
        RETURN -1;
    END

    -- Perform delete
    DELETE FROM SalesOrderDetail
    WHERE SalesOrderID = @OrderID AND ProductID = @ProductID;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Delete failed. Please try again.';
        RETURN -1;
    END

    PRINT 'Order detail deleted successfully.';
END;
GO
