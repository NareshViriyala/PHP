DROP PROCEDURE IF EXISTS dbo.usp_get_NotificationMsgs;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_NotificationMsgs()
BEGIN
	SET SQL_SAFE_UPDATES=0;
    SELECT * FROM dbo.tbl_PushNotification WHERE PushTime IS NULL;
    UPDATE dbo.tbl_PushNotification SET PushTime = NOW() WHERE PushTime IS NULL;
    #SET SQL_SAFE_UPDATES=1;
END$$
DELIMITER ;
-- CALL dbo.usp_get_NotificationMsgs();
-- SELECT * FROM dbo.tbl_PushNotification;
-- SET SQL_SAFE_UPDATES=0;
-- UPDATE dbo.tbl_PushNotification SET PushTime = NULL;
