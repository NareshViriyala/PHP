DROP PROCEDURE IF EXISTS dbo.usp_web_forgotpassword;

DELIMITER $$
CREATE PROCEDURE dbo.usp_web_forgotpassword(
	   _phone NVARCHAR(15),
       _otp NVARCHAR(10),
       _newpassword NVARCHAR(50))
BEGIN
	DECLARE _retval NVARCHAR(70);
	DECLARE _setotp NVARCHAR(70);
    DECLARE _userid INT;
    DECLARE _username NVARCHAR(100);
    SET SQL_SAFE_UPDATES=0;
    
    /*actual plan was to allow user to update password once in 24 hours because updating password "forgot password" option requires
    OTP which requires money for each message. but later it is assumed that that user won't missuse this feature hence allowing it for now.
    if in future it is observer that this feature is missused then the 24 hour limit will be implemented
    */
    SELECT userid, username, deviceid INTO _userid, _username, _setotp FROM dbo.tbl_mstr_webuser WHERE phone = trim(_phone);
    
    
    IF(NULLIF(_otp,'') IS NULL AND NULLIF(_newpassword,'') IS NULL) #user forgot password and phone number is sent for validation
    THEN
		IF (_userid IS NOT NULL) #User is registered
		THEN
			SET _setotp = ROUND((RAND() * (10000-1000))+1000); 
			UPDATE dbo.tbl_mstr_webuser SET deviceid = _setotp, UpdateDate = NOW() WHERE userid = _userid;
			SET _retval = 'Enter OTP';
		ELSE
			SET _retval = 'Phone number not registered';
			SET _setotp = 0;
		END IF;
    ELSE #user forgot password, phone number is valid hence OTP is sent for conformation
		IF (_userid IS NOT NULL AND _otp = _setotp) #User is registered and otp is valid
		THEN
			SET _setotp = _username; 
			UPDATE dbo.tbl_mstr_webuser SET pin = _newpassword, deviceid = null, UpdateDate = NOW() WHERE userid = _userid;
			SET _retval = _userid;
		ELSE
			SET _retval = 'Invalid OTP';
			SET _setotp = 0;
		END IF;
    END IF;
    
    
    SELECT _retval AS result, _setotp AS otp;
END$$
DELIMITER ;

#CALL dbo.usp_web_forgotpassword('9985265352','7920','1253');

#select * from dbo.tbl_mstr_webuser; 