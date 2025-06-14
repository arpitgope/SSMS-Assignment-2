CREATE FUNCTION dbo.fn_FormatDate_MMDDYYYY
(
    @InputDate DATETIME
)
RETURNS VARCHAR(10)
AS
BEGIN
    RETURN CONVERT(VARCHAR(10), @InputDate, 101);  
END;

SELECT dbo.fn_FormatDate_MMDDYYYY('2006-11-21 23:34:05.920') AS FormattedDate;

