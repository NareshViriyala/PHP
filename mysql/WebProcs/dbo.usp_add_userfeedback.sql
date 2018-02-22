DROP PROCEDURE IF EXISTS dbo.usp_add_userfeedback;

DELIMITER $$
CREATE PROCEDURE dbo.usp_add_userfeedback(_userid int, _feedback nvarchar(500))
BEGIN
	INSERT INTO dbo.tbl_usr_feedback(userid, feedback)
    SELECT _userid, _feedback;
END$$
DELIMITER ;

#CALL dbo.usp_get_entitysceparam(9, 13);
#SELECT * FROM dbo.tbl_mstr_UserDevice;
#SELECT * FROM dbo.tbl_mstr_GroupDevice;