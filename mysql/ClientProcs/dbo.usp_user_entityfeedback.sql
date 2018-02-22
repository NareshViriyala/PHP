DROP PROCEDURE IF EXISTS dbo.usp_add_entityfeedback;

DELIMITER $$
CREATE PROCEDURE dbo.usp_add_entityfeedback(
	_userid int, 
    _entityid int,
    _feedback nvarchar(2000))
BEGIN
	INSERT INTO dbo.tbl_user_entityfeedback(UserID, EntityID, Feedback)
    SELECT _userid, _entityid, _feedback;
    
    SELECT 'Success' AS Output;
END$$
DELIMITER ;