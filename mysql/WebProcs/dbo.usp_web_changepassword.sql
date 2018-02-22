DROP PROCEDURE IF EXISTS dbo.usp_web_changepassword;

DELIMITER $$
CREATE PROCEDURE dbo.usp_web_changepassword(
	   _userid INT
	 , _currentpin NVARCHAR(50) 
	 , _newpin NVARCHAR(50))
BEGIN
	DECLARE _retval NVARCHAR(70);
	DECLARE _savedpin NVARCHAR(10);
    
    SELECT pin INTO _savedpin FROM dbo.tbl_mstr_webuser WHERE userid = _userid;
    
    
	IF (_savedpin = _currentpin) #User is registered and current password is valid
    THEN
        UPDATE dbo.tbl_mstr_webuser SET pin = _newpin WHERE userid = _userid;
        SET _retval = 'Password changed.';
	ELSEIF (_savedpin != _currentpin) THEN
		SET _retval = 'Current password is not correct.';
	ELSEIF (NULLIF(_savedpin, '') IS NULL) THEN
		SET _retval = 'User not registered.';
    ELSE #password change failed
		SET _retval = 'Something went wrong.';
    END IF;
    SELECT _retval AS result;
END$$
DELIMITER ;

#CALL dbo.usp_web_changepassword(32,1254,1253);