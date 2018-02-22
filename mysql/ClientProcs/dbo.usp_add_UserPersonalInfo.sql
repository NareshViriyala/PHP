DROP PROCEDURE IF EXISTS dbo.usp_add_UserPersonalInfo;

DELIMITER $$
CREATE PROCEDURE dbo.usp_add_UserPersonalInfo(
	   _DeviceID INT
	 , _FName NVARCHAR(100) 
	 , _MName NVARCHAR(100)
	 , _LName NVARCHAR(100)
	 , _Email NVARCHAR(50)
	 , _Phone NVARCHAR(20))
BEGIN

    DROP TABLE IF EXISTS dbo.tbl_tmp_UserPersonalInfo;
	CREATE TEMPORARY TABLE dbo.tbl_tmp_UserPersonalInfo (
		   DeviceID INT PRIMARY KEY
		 , FName NVARCHAR(100) 
		 , MName NVARCHAR(100)
		 , LName NVARCHAR(100)
		 , Email NVARCHAR(50)
		 , Phone NVARCHAR(20))engine=memory;
         
    INSERT INTO dbo.tbl_tmp_UserPersonalInfo(DeviceID, FName, MName, LName, Email, Phone)     
    VALUES (_DeviceID, _FName, _MName, _LName, _Email, _Phone) ;

    INSERT INTO dbo.tbl_mstr_UserPersonalInfo(DeviceID, FName, MName, LName, Email, Phone)
    SELECT DeviceID, FName, MName, LName, Email, Phone
	  FROM dbo.tbl_tmp_UserPersonalInfo
		ON DUPLICATE KEY 
	UPDATE FName = values(FName)
         , MName = values(MName)
         , LName = values(LName)
         , Email = values(Email)
         , Phone = values(Phone);
END$$
DELIMITER ;

#CALL dbo.usp_add_UserPersonalInfo('1','naresh','kumar','viriyala','naresh1253@gmail.com','9985265352');
#SELECT * FROM dbo.tbl_mstr_UserPersonalInfo;
