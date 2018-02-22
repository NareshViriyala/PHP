DROP PROCEDURE IF EXISTS dbo.usp_add_SecurityCheckEntry;

DELIMITER $$
CREATE PROCEDURE dbo.usp_add_SecurityCheckEntry(_input TEXT)
BEGIN
	
	DECLARE ISTDate DATETIME DEFAULT NOW();
    DECLARE itemCount INT DEFAULT ExtractValue(_input, 'count(//ServerDeviceID)');
    SET @MaxID := 1;
	
    DROP TABLE IF EXISTS dbo.tbl_temp_SecurityEntry;
	CREATE TEMPORARY TABLE dbo.tbl_temp_SecurityEntry(
		   ID INT
		 , EntityID INT
		 , ServerDeviceID INT
		 , LocalDBID INT
		 , DeviceID INT 
		 , JSONData NVARCHAR(1000));	
    
    WHILE @MaxID <= itemCount DO
		INSERT INTO dbo.tbl_temp_SecurityEntry
        SELECT ExtractValue(_input, '//EntityID[$@MaxID]') AS EntityID
			 , ExtractValue(_input, '//ServerDeviceID[$@MaxID]') AS ServerDeviceID
             , ExtractValue(_input, '//LocalDBID[$@MaxID]') AS LocalDBID
			 , ExtractValue(_input, '//DeviceID[$@MaxID]') AS DeviceID
             , ExtractValue(_input, '//JSONData[$@MaxID]') AS JSONData;
		SET @MaxID := @MaxID + 1;
    END WHILE; 
    
    SET @MaxID := 0;
    SET SQL_SAFE_UPDATES=0;
    # Find all the DeviceIDs which are non numeric and assign the numeric values for them
	BEGIN
		DECLARE _deviceid VARCHAR(100) DEFAULT "";
        DECLARE devicemap INT;
		DECLARE v_finished INTEGER DEFAULT 0;
		
		DECLARE unsync_deviceid_cursor CURSOR FOR
		SELECT DISTINCT DeviceID FROM dbo.tbl_temp_SecurityEntry WHERE DeviceID*1 != DeviceID;   
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
		
		OPEN unsync_deviceid_cursor;
		get_deviceid: LOOP
			FETCH unsync_deviceid_cursor INTO _deviceid;
			SET devicemap = 0;
            
			IF v_finished = 1 THEN 
			LEAVE get_deviceid;
			END IF;
            
            SELECT ID INTO devicemap FROM dbo.tbl_mstr_userdevice WHERE DeviceID = _deviceid;
            
            IF devicemap = 0
            THEN
				START TRANSACTION;
					
					SELECT ID INTO devicemap FROM dbo.tbl_mstr_GroupDevice;
					SET devicemap = devicemap+1;
					UPDATE dbo.tbl_mstr_GroupDevice SET ID = devicemap, UpdateDate = NOW();
					
				COMMIT;
                
                INSERT INTO dbo.tbl_mstr_userdevice(ID, DeviceID)
				SELECT devicemap, _deviceid;
                
                UPDATE dbo.tbl_temp_SecurityEntry SET DeviceID = devicemap WHERE DeviceID = _deviceid;
            ELSE
				UPDATE dbo.tbl_temp_SecurityEntry SET DeviceID = devicemap WHERE DeviceID = _deviceid;
            END IF;
            

		END LOOP get_deviceid;
		CLOSE unsync_deviceid_cursor;
    END;
	-- SELECT * FROM dbo.tbl_temp_SecurityEntry;
    SELECT IFNULL(MAX(ID),0) INTO @MaxID FROM dbo.tbl_SecurityCheckEntry;
    
    INSERT INTO dbo.tbl_SecurityCheckEntry(EntityID,ServerDeviceID,LocalDBID,DeviceID,JSONData,SystemTime)
    SELECT EntityID,ServerDeviceID,LocalDBID,DeviceID,JSONData,ISTDate 
      FROM dbo.tbl_temp_SecurityEntry src;
      
    UPDATE dbo.tbl_temp_SecurityEntry src
      JOIN dbo.tbl_SecurityCheckEntry sce
        ON src.LocalDBID = sce.LocalDBID
	   AND src.EntityID = sce.EntityID
       AND src.ServerDeviceID = sce.ServerDeviceID
       AND src.DeviceID = sce.DeviceID
       SET src.ID = sce.ID
	 WHERE sce.ID > @MaxID;
			  
    #SET SQL_SAFE_UPDATES=1;
    
   INSERT INTO dbo.tbl_PushNotification(DeviceUri, DeviceType, PushMessage, DeviceGroup)
   SELECT ud.Uri
		, ud.DeviceType
		, CONCAT('{"ScreenName":"FragmentProfile","Status":"GeneralVisit"
		   ,"Entity":"',ee.EEName,'"
		   ,"InformationShared":',da.JSONData,'}')
		, 'Client'
     FROM dbo.tbl_temp_SecurityEntry da
	 JOIN dbo.tbl_mstr_UserDevice ud
	   ON da.DeviceID = ud.ID
	 JOIN dbo.tbl_mstr_EstablishmentEntity ee
	   ON da.EntityID = ee.EEID
	WHERE ud.Uri IS NOT NULL;
    
   SELECT ID, LocalDBID AS DBID, DeviceID, ISTDate AS SystemTime FROM dbo.tbl_temp_SecurityEntry;
END$$
DELIMITER ;

#CALL dbo.usp_add_SecurityCheckEntry('2968491D-75BB-4C48-8F16-E789EE44860E', NULL, 2, 10);

