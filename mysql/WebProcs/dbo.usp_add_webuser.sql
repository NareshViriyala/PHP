DROP PROCEDURE IF EXISTS dbo.usp_add_webuser;

DELIMITER $$
CREATE PROCEDURE dbo.usp_add_webuser(
	   _username NVARCHAR(100)
	 , _phone NVARCHAR(20) 
	 , _pin NVARCHAR(50) 
	 , _email NVARCHAR(50)
     , _otp INT)
BEGIN
	DECLARE _retval NVARCHAR(64);
    DECLARE _ID INT;
    DECLARE _setotp INT;
    
    
	IF EXISTS (SELECT 1 FROM dbo.tbl_mstr_webuser WHERE phone = trim(_phone) AND guid REGEXP '^[0-9]+$') #User is registered and phone validation pending
    THEN
		SELECT userid, guid INTO _ID,_setotp FROM dbo.tbl_mstr_webuser WHERE phone = trim(_phone);
        IF (_otp = _setotp) THEN #OTP matched, confirm validation
			SET _retval = uuid(); #Once validation is successful then replace the OTP from the guid column with actual guid
            SET _setotp = 1; #Once phone validation is successful the set _setotp = 1
            UPDATE dbo.tbl_mstr_webuser SET guid = _retval WHERE userid = _ID;
            SET _retval = _ID;
		ELSE
			SET _retval = 'Invalid OTP';
            SET _setotp = 0; #if OTP validation has failed then set _setotp to 0 and return it to PHP Web service
        END IF;
	ELSEIF (SELECT 1 FROM dbo.tbl_mstr_webuser WHERE phone = trim(_phone) AND NOT guid REGEXP '^[0-9]+$') THEN #User is registered and phone validation completed
		SET _retval = 'User already exists';
        SET _setotp = 0; #if OTP validation has failed then set _setotp to 0 and return it to PHP Web service
    ELSE #user not registered yet
		START TRANSACTION;
			SET SQL_SAFE_UPDATES=0;
			SELECT ID INTO _ID FROM dbo.tbl_mstr_GroupDevice;
            SET _ID = _ID+1;
			UPDATE dbo.tbl_mstr_GroupDevice SET ID = _ID, UpdateDate = NOW();
		COMMIT;
    
		SET _retval = 'New User';
        SET _setotp = ROUND((RAND() * (10000-1000))+1000); #for new user registration generate a random OTP between 1000 and 10000
		INSERT INTO dbo.tbl_mstr_webuser(userid, username, phone, pin, email, guid)
        SELECT _ID, _username, _phone, _pin, _email, _setotp;
    END IF;
    SELECT _retval AS result, _setotp AS otp;
END$$
DELIMITER ;

#CALL dbo.usp_add_WebUser('DeviceID','Urid','DeviceType','DeviceVersion','AppVersion');
#SELECT * FROM dbo.tbl_mstr_UserDevice;
#SELECT * FROM dbo.tbl_mstr_GroupDevice;