DROP PROCEDURE IF EXISTS dbo.usp_validate_webuser;

DELIMITER $$
CREATE PROCEDURE dbo.usp_validate_webuser(
	   _phone NVARCHAR(20) 
	 , _pin NVARCHAR(50))
BEGIN
	DECLARE _retval NVARCHAR(64);
    DECLARE _id INT;
	IF NOT EXISTS (SELECT 1 FROM dbo.tbl_mstr_webuser WHERE phone = trim(_phone))
    THEN
		SET _retval = 'User does not Exists';
	ELSE
		SET _retval = uuid();
        SELECT CASE WHEN pin = _pin THEN username ELSE 'False' END, userid INTO _retval, _id
          FROM dbo.tbl_mstr_webuser
		 WHERE phone = _phone;
    END IF;
    SELECT _retval AS result, _id as id, _phone as phone;
END$$
DELIMITER ;

#CALL dbo.usp_validate_webuser('9985265352','1253');
