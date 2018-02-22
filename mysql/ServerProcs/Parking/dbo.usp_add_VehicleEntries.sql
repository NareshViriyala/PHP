DROP PROCEDURE IF EXISTS dbo.usp_add_VehicleEntries;

DELIMITER $$
CREATE PROCEDURE dbo.usp_add_VehicleEntries(_input TEXT)
BEGIN
	DECLARE ISTDate DATETIME DEFAULT NOW();
    DECLARE itemCount INT DEFAULT ExtractValue(_input, 'count(//ServerID)');
    SET @MaxID := 1;
    SET SQL_SAFE_UPDATES=0;
	DROP TABLE IF EXISTS dbo.tbl_temp_vehicleentryoutput;
    CREATE TEMPORARY TABLE dbo.tbl_temp_vehicleentryoutput (
		   ID INT
		 , LocalDBID INT
		 , IEntryDate DATETIME
		 , DEntryDate DATETIME
		 , LocalEnterDate DATETIME
		 , IExitDate DATETIME
		 , DExitDate DATETIME
		 , LocalExitDate DATETIME);

    DROP TABLE IF EXISTS dbo.tbl_temp_VehicleEntry;
	CREATE TEMPORARY TABLE dbo.tbl_temp_VehicleEntry(
		   ServerID INT
		 , EntityID INT
		 , ServerDeviceID INT	
		 , LocalDBID INT 
		 , LocalDBTime DATETIME
		 , DeviceID NVARCHAR(100) 
		 , VehicleNo NVARCHAR(20) 
		 , VehicleType INT
		 , TCTID INT
		 , AddType INT
		 , OverRide INT);	 
    
    WHILE @MaxID <= itemCount DO
		INSERT INTO dbo.tbl_temp_VehicleEntry(ServerID, EntityID, ServerDeviceID, LocalDBID, LocalDBTime, DeviceID, VehicleNo, VehicleType, TCTID, AddType, OverRide)
        SELECT ExtractValue(_input, '//ServerID[$@MaxID]') AS ServerID
			 , ExtractValue(_input, '//EntityID[$@MaxID]') AS EntityID
			 , ExtractValue(_input, '//ServerDeviceID[$@MaxID]') AS ServerDeviceID
			 , ExtractValue(_input, '//LocalDBID[$@MaxID]') AS LocalDBID
			 , ExtractValue(_input, '//LocalDBTime[$@MaxID]') AS LocalDBTime
			 , ExtractValue(_input, '//DeviceID[$@MaxID]') AS DeviceID
			 , ExtractValue(_input, '//VehicleNo[$@MaxID]') AS VehicleNo
			 , ExtractValue(_input, '//VehicleType[$@MaxID]') AS VehicleType
			 , ExtractValue(_input, '//TCTID[$@MaxID]') AS TCTID
			 , ExtractValue(_input, '//AddType[$@MaxID]') AS AddType
			 , ExtractValue(_input, '//OverRide[$@MaxID]') AS OverRide;
		SET @MaxID := @MaxID + 1;
    END WHILE; 
	-- SELECT * FROM dbo.tbl_temp_VehicleEntry;
    SET @MaxID := 1;
    # Find all the DeviceIDs which are non numeric and assign the numeric values for them
	BEGIN
		DECLARE _deviceid VARCHAR(100) DEFAULT "";
        DECLARE devicemap INT;
		DECLARE v_finished INTEGER DEFAULT 0;
		
		DECLARE unsync_deviceid_cursor CURSOR FOR
		SELECT DISTINCT DeviceID FROM dbo.tbl_temp_VehicleEntry WHERE DeviceID*1 != DeviceID;   
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
					SET SQL_SAFE_UPDATES=0;
					SELECT ID INTO devicemap FROM dbo.tbl_mstr_GroupDevice;
					SET devicemap = devicemap+1;
					UPDATE dbo.tbl_mstr_GroupDevice SET ID = devicemap, UpdateDate = NOW();
					SET SQL_SAFE_UPDATES=1;
				COMMIT;
                
                INSERT INTO dbo.tbl_mstr_userdevice(ID, DeviceID)
				SELECT devicemap, _deviceid;
                
                UPDATE dbo.tbl_temp_VehicleEntry SET DeviceID = devicemap WHERE DeviceID = _deviceid;
            ELSE
				UPDATE dbo.tbl_temp_VehicleEntry SET DeviceID = devicemap WHERE DeviceID = _deviceid;
            END IF;

		END LOOP get_deviceid;
		CLOSE unsync_deviceid_cursor;
    END;
    
    -- Entries already exists for these vehicle and a request for entry has come again
	INSERT INTO dbo.tbl_temp_vehicleentryoutput(ID, LocalDBID, IEntryDate, DEntryDate, LocalEnterDate, IExitDate, DExitDate, LocalExitDate)
    SELECT ve.ID, src.LocalDBID, ve.EnterDateTime, ve.EnterDateTime, ve.EntryLocalTime, ve.ExitDateTime, ve.ExitDateTime, ve.ExitLocalTime
      FROM dbo.tbl_VehicleEntry ve
      JOIN dbo.tbl_temp_VehicleEntry src
        ON ve.EEID = src.EntityID
	   AND ve.UDID = src.DeviceID
	   AND ve.VehicleNo = src.VehicleNo
	   AND ve.EnterDateTime IS NOT NULL
	   AND ve.ExitDateTime IS NULL
	 WHERE src.AddType = 1
       AND src.OverRide = 0;
    
    
	-- Entries already exists for these vehicles but its a force over ride
    INSERT INTO dbo.tbl_temp_vehicleentryoutput(ID, LocalDBID, IEntryDate, DEntryDate, LocalEnterDate, IExitDate, DExitDate, LocalExitDate)
    SELECT ve.ID, src.LocalDBID, ISTDate, ve.EnterDateTime, ve.EntryLocalTime, ve.ExitDateTime, ve.ExitDateTime, ve.ExitLocalTime
      FROM dbo.tbl_VehicleEntry ve
      JOIN dbo.tbl_temp_VehicleEntry src
        ON ve.EEID = src.EntityID
	   AND ve.UDID = src.DeviceID
	   AND ve.VehicleNo = src.VehicleNo
	   AND ve.EnterDateTime IS NOT NULL
	   AND ve.ExitDateTime IS NULL
	 WHERE src.AddType = 1
       AND src.OverRide = 1;
	
    
	UPDATE dbo.tbl_VehicleEntry ve
      JOIN dbo.tbl_temp_VehicleEntry src
        ON ve.EEID = src.EntityID
	   AND ve.UDID = src.DeviceID
	   AND ve.VehicleNo = src.VehicleNo
	   AND ve.EnterDateTime IS NOT NULL
	   AND ve.ExitDateTime IS NULL
       SET ve.EnterDateTime = ISTDate
		 , ve.TCTID = src.TCTID
         , ve.EntryLocalDBID = src.LocalDBID
         , ve.EntrySDID = src.ServerDeviceID
         , ve.EntryLocalTime = src.LocalDBTime
         , ve.VehicleType = src.VehicleType
         , ve.OverRideData = CONCAT(IFNULL(ve.OverRideData,','),'{"EnterDateTime":"',ve.EnterDateTime,'","TCTID":',ve.TCTID,',"EntrySDID":',ve.EntrySDID,',"EntryLocalTime":"',ve.EntryLocalTime,'","VehicleType":',ve.VehicleType,'}')
	 WHERE src.AddType = 1
       AND src.OverRide = 1;
    
    SELECT IFNULL(MAX(ID),0) INTO @MaxID FROM dbo.tbl_VehicleEntry;
    
	-- Geniune entries
    INSERT INTO dbo.tbl_VehicleEntry(EEID, EntryLocalDBID, EntrySDID, EntryLocalTime, TCTID, UDID, VehicleNo, VehicleType, EnterDateTime)
	SELECT src.EntityID, src.LocalDBID, src.ServerDeviceID, src.LocalDBTime, src.TCTID, src.DeviceID, src.VehicleNo, src.VehicleType, ISTDate -- ,ve.ID,src.AddType,src.OverRide
	  FROM dbo.tbl_temp_VehicleEntry src
      LEFT JOIN dbo.tbl_VehicleEntry ve
        ON ve.EEID = src.EntityID
	   AND ve.UDID = src.DeviceID
	   AND ve.VehicleNo = src.VehicleNo
	   AND ve.EnterDateTime IS NOT NULL
	   AND ve.ExitDateTime IS NULL
	 WHERE src.AddType = 1
       AND src.OverRide = 0
       AND ve.ID IS NULL;
       
	INSERT INTO dbo.tbl_temp_vehicleentryoutput(ID, LocalDBID, IEntryDate, DEntryDate, LocalEnterDate, IExitDate, DExitDate, LocalExitDate)
    SELECT ve.ID, src.LocalDBID, ISTDate, NULL, ve.EntryLocalTime, ve.ExitDateTime, ve.ExitDateTime, ve.ExitLocalTime
      FROM dbo.tbl_VehicleEntry ve
      JOIN dbo.tbl_temp_VehicleEntry src
        ON ve.EEID = src.EntityID
	   AND ve.UDID = src.DeviceID
       AND ve.EntrySDID = src.ServerDeviceID
	   AND ve.VehicleNo = src.VehicleNo
	   AND ve.EnterDateTime IS NOT NULL
	   AND ve.ExitDateTime IS NULL
	 WHERE src.AddType = 1
       AND src.OverRide = 0
       AND ve.ID > @MaxID;
     
     -- SELECT * FROM dbo.tbl_temp_vehicleentryoutput;
     -- no entries exists for these vehicle and a request for exit has come
	INSERT INTO dbo.tbl_temp_vehicleentryoutput(ID, LocalDBID, IEntryDate, DEntryDate, LocalEnterDate, IExitDate, DExitDate, LocalExitDate)
    SELECT ve.ID, src.LocalDBID, ve.EnterDateTime, ve.EnterDateTime, ve.EntryLocalTime, ve.ExitDateTime, ve.ExitDateTime, ve.ExitLocalTime
      FROM dbo.tbl_temp_VehicleEntry src
      LEFT JOIN dbo.tbl_VehicleEntry ve
        ON ve.EEID = src.EntityID
	   AND ve.UDID = src.DeviceID
	   AND ve.VehicleNo = src.VehicleNo
	   AND ve.EnterDateTime IS NOT NULL
	   AND ve.ExitDateTime IS NULL
	 WHERE src.AddType = 2
       AND src.OverRide = 0
       AND ve.ID IS NULL;
       
    -- Geniune exits   
    INSERT INTO dbo.tbl_temp_vehicleentryoutput(ID, LocalDBID, IEntryDate, DEntryDate, LocalEnterDate, IExitDate, DExitDate, LocalExitDate)
    SELECT ve.ID, src.LocalDBID, ve.EnterDateTime, ve.EnterDateTime, ve.EntryLocalTime, ISTDate, NULL, src.LocalDBTime
      FROM dbo.tbl_VehicleEntry ve
      JOIN dbo.tbl_temp_VehicleEntry src
        ON ve.EEID = src.EntityID
	   AND ve.UDID = src.DeviceID
	   AND ve.VehicleNo = src.VehicleNo
	   AND ve.EnterDateTime IS NOT NULL
	   AND ve.ExitDateTime IS NULL
	 WHERE src.AddType = 2
       AND src.OverRide = 0;
       
    UPDATE dbo.tbl_VehicleEntry ve
      JOIN dbo.tbl_temp_VehicleEntry src
        ON ve.EEID = src.EntityID
	   AND ve.UDID = src.DeviceID
	   AND ve.VehicleNo = src.VehicleNo
	   AND ve.EnterDateTime IS NOT NULL
	   AND ve.ExitDateTime IS NULL
       SET ve.ExitDateTime = ISTDate
		 , ve.ExitSDID = src.ServerDeviceID
         , ve.ExitLocalDBID = src.LocalDBID
         , ve.ExitLocalTime = src.LocalDBTime
	 WHERE src.AddType = 2
       AND src.OverRide = 0;     
       
	SELECT IFNULL(MAX(ID),0) INTO @MaxID FROM dbo.tbl_VehicleEntry;
    -- Force exit with override bit = 1 
    INSERT INTO dbo.tbl_VehicleEntry(EEID, EntryLocalDBID, ExitLocalDBID, EntryLocalTime, ExitLocalTime, EntrySDID, ExitSDID, TCTID, UDID, VehicleNo, VehicleType, EnterDateTime, ExitDateTime, OverRideData)
	SELECT src.EntityID, src.LocalDBID, src.LocalDBID, src.LocalDBTime, src.LocalDBTime, src.ServerDeviceID, src.ServerDeviceID, src.TCTID, src.DeviceID, src.VehicleNo, src.VehicleType, ISTDate, ISTDate, '1'
	  FROM dbo.tbl_temp_VehicleEntry src
	 WHERE src.AddType = 2
       AND src.OverRide = 1;
    
    INSERT INTO dbo.tbl_temp_vehicleentryoutput(ID, LocalDBID, IEntryDate, DEntryDate, LocalEnterDate, IExitDate, DExitDate, LocalExitDate)
    SELECT ve.ID, src.LocalDBID, ve.EnterDateTime, ve.EnterDateTime, ve.EntryLocalTime, ve.ExitDateTime, ve.ExitDateTime, ve.ExitLocalTime
      FROM dbo.tbl_VehicleEntry ve
      JOIN dbo.tbl_temp_VehicleEntry src
        ON ve.EEID = src.EntityID
	   AND ve.UDID = src.DeviceID
       AND ve.ExitSDID = src.ServerDeviceID
	   AND ve.VehicleNo = src.VehicleNo
	   AND ve.EnterDateTime IS NOT NULL
	   AND ve.ExitDateTime IS NOT NULL
	 WHERE src.AddType = 2
       AND src.OverRide = 1
       AND ve.ID > @MaxID;
       
    INSERT INTO dbo.tbl_PushNotification(DeviceUri, DeviceType, PushMessage, DeviceGroup)
	SELECT ud.Uri
		 , ud.DeviceType
		 , CONCAT('{"ScreenName":"FragmentParking"
		   ,"Status":"',CASE da.AddType WHEN 1 THEN 'Entry' ELSE 'Exit' END,'"
		   ,"ServerID":',tt.ID,'
		   ,"VehicleNo":"',da.VehicleNo,'"
		   ,"VehicleType":',da.VehicleType,'
		   ,"Entity":"',ee.EEName,'"
		   ,"TariffAmt":',tpt.TariffAmount,'
		   ,"EntryDate":"',IFNULL(tt.LocalEnterDate,''),'"
		   ,"ExitDate":"',IFNULL(tt.LocalExitDate,''),'"
		   ,"Timer":',tpt.MaxMinutes,'
		   ,"ServerEntryDate":"',IFNULL(tt.IEntryDate,''),'"
		   ,"ServerExitDate":"',IFNULL(tt.IExitDate,''),'"
		   ,"OID":0}')
		 , 'Client'
	  FROM dbo.tbl_temp_VehicleEntry da
	  JOIN dbo.tbl_temp_vehicleentryoutput tt
	    ON da.LocalDBID = tt.LocalDBID
	  JOIN dbo.tbl_mstr_UserDevice ud
		ON da.DeviceID = ud.ID
	   AND ud.Uri IS NOT NULL
	  JOIN dbo.tbl_mstr_EstablishmentEntity ee
	    ON da.EntityID = ee.EEID
	  LEFT JOIN dbo.tbl_mstr_TariffPlanTime tpt
        ON da.EntityID = tpt.EEID
       AND da.VehicleType = tpt.VehicleType
       AND da.TCTID = tpt.TCTID
       AND TIMESTAMPDIFF(MINUTE, tt.IEntryDate, IFNULL(tt.IExitDate, ISTDate)) BETWEEN tpt.MinMinutes AND tpt.MaxMinutes
     WHERE (tt.IEntryDate IS NOT NULL AND tt.DEntryDate IS NULL)
        OR (tt.IExitDate IS NOT NULL AND tt.DExitDate IS NULL)
        OR da.OverRide = 1;

	SELECT ID 
		 , LocalDBID AS DBID
		 , IFNULL(IEntryDate, '') AS IEntryDate
		 , IFNULL(DEntryDate, '') AS DEntryDate
		 , IFNULL(LocalEnterDate, '') AS LocalEnterDate 
		 , IFNULL(IExitDate, '') AS IExitDate
		 , IFNULL(DExitDate, '') AS DExitDate
		 , IFNULL(LocalExitDate, '') AS LocalExitDate 
	  FROM dbo.tbl_temp_vehicleentryoutput;
END$$
DELIMITER ;

#CALL dbo.usp_add_VehicleEntries('2968491D-75BB-4C48-8F16-E789EE44860E', NULL, 2, 10);

