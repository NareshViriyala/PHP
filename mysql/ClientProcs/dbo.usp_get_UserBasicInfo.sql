DROP PROCEDURE IF EXISTS dbo.usp_get_UserBasicInfo;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_UserBasicInfo(_UserID INT)
BEGIN
	IF EXISTS (SELECT 1 FROM dbo.tbl_mstr_userpersonalinfo WHERE DeviceID = _UserID)
	THEN
		SELECT FName AS FirstName
			 , MName AS MiddleName
             , LName AS LastName
             , Email
             , Phone
          FROM dbo.tbl_mstr_userpersonalinfo
		 WHERE DeviceID = _UserID;    
    ELSE
		SELECT username AS FirstName
			 , '' AS MiddleName
             , '' AS LastName
             , email AS Email
             , phone AS Phone
          FROM dbo.tbl_mstr_webuser
		 WHERE userid = _UserID;
    END IF;
	
END$$
DELIMITER ;

#CALL dbo.usp_get_UserBasicInfo(13);
