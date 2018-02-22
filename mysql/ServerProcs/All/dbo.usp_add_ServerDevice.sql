DROP PROCEDURE IF EXISTS dbo.usp_add_ServerDevice;

DELIMITER $$
CREATE PROCEDURE dbo.usp_add_ServerDevice(
	   _DeviceID NVARCHAR(100) 
	 , _Uri NVARCHAR(500) 
	 , _DeviceType NVARCHAR(100) 
	 , _DeviceVersion NVARCHAR(50)
	 , _AppVersion NVARCHAR(50))
BEGIN
	DECLARE _ID INT;
	SELECT ud.ID INTO _ID FROM dbo.tbl_mstr_ServerDevice ud WHERE ud.DeviceID = _DeviceID;
    
    DROP TABLE IF EXISTS dbo.tbl_tmp_ServerMapID;
	CREATE TEMPORARY TABLE dbo.tbl_tmp_ServerMapID (
		   ID INT PRIMARY KEY
		 , DeviceID NVARCHAR(100) 
		 , Uri NVARCHAR(500)
		 , DeviceType NVARCHAR(100)
		 , DeviceVersion NVARCHAR(50)
		 , AppVersion NVARCHAR(50))engine=memory;

	IF _ID IS NULL
	THEN
		START TRANSACTION;
			SET SQL_SAFE_UPDATES=0;
			SELECT ID INTO _ID FROM dbo.tbl_mstr_GroupDevice;
            SET _ID = _ID+1;
			UPDATE dbo.tbl_mstr_GroupDevice SET ID = _ID, UpdateDate = NOW();
            SET SQL_SAFE_UPDATES=1;
		COMMIT;
	END IF;
    
    INSERT INTO dbo.tbl_tmp_ServerMapID
	SELECT _ID, _DeviceID, _Uri, _DeviceType, _DeviceVersion, _AppVersion;
    
    INSERT INTO dbo.tbl_mstr_ServerDevice(ID, DeviceID, Uri, DeviceType, DeviceVersion, AppVersion, InsertDate)
    SELECT ID, DeviceID, Uri, DeviceType, DeviceVersion, AppVersion, NOW() 
      FROM dbo.tbl_tmp_ServerMapID
        ON DUPLICATE KEY 
	UPDATE DeviceID = values(DeviceID)
         , Uri = values(Uri)
         , DeviceType = values(DeviceType)
         , DeviceVersion = values(DeviceVersion)
         , AppVersion = values(AppVersion)
         , UpdateDate = NOW();

	SELECT _ID AS ServerMAPID;
END$$
DELIMITER ;

#CALL dbo.usp_add_ServerDevice('DeviceID','Urid','DeviceType','DeviceVersion','AppVersion');
#SELECT * FROM dbo.tbl_mstr_UserDevice;
#SELECT * FROM dbo.tbl_mstr_GroupDevice;