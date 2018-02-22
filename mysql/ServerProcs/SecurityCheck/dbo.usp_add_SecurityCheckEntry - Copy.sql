DROP PROCEDURE IF EXISTS dbo.usp_add_SecurityCheckEntry;

DELIMITER $$
CREATE PROCEDURE dbo.usp_add_SecurityCheckEntry(_input TEXT)
BEGIN
	
	DECLARE ISTDate DATETIME DEFAULT NOW();
    DECLARE itemCount INT DEFAULT ExtractValue(_input, 'count(//ServerID)');
    SET @MaxID := 1;
	
    DROP TABLE IF EXISTS dbo.tbl_temp_SecurityEntry;
	CREATE TEMPORARY TABLE dbo.tbl_temp_SecurityEntry(
		   ID INT
		 , LocalDBID INT 
		 , EntityID INT
		 , ServerDeviceID INT
		 , DeviceID NVARCHAR(100)
		 , Name NVARCHAR(100)
		 , Email NVARCHAR(100)
		 , Phone NVARCHAR(15)
		 , DOB NVARCHAR(20)
		 , Age NVARCHAR(3)
		 , Sex NVARCHAR(10)
		 , Vehicle NVARCHAR(20)
         , VehicleType NVARCHAR(4)
		 , ComingFrom NVARCHAR(50)
		 , Purpose NVARCHAR(50)
		 , VisitingCompany NVARCHAR(50)
		 , ContactPerson NVARCHAR(50)
		 , HomeAdd NVARCHAR(500)
		 , OfcAdd NVARCHAR(500)
         , Blok NVARCHAR(100)
         , Flat NVARCHAR(10)
		 , isDeleted INT);	
    
    WHILE @MaxID <= itemCount DO
		INSERT INTO dbo.tbl_temp_SecurityEntry
        SELECT ExtractValue(_input, '//ServerID[$@MaxID]') AS ID
			 , ExtractValue(_input, '//LocalDBID[$@MaxID]') AS LocalDBID
			 , ExtractValue(_input, '//EntityID[$@MaxID]') AS EntityID
			 , ExtractValue(_input, '//ServerDeviceID[$@MaxID]') AS ServerDeviceID
			 , ExtractValue(_input, '//DeviceID[$@MaxID]') AS DeviceID
			 , ExtractValue(_input, '//Name[$@MaxID]') AS Name
			 , ExtractValue(_input, '//Email[$@MaxID]') AS Email
			 , ExtractValue(_input, '//Phone[$@MaxID]') AS Phone
			 , ExtractValue(_input, '//DOB[$@MaxID]') AS DOB
			 , ExtractValue(_input, '//Age[$@MaxID]') AS Age
			 , ExtractValue(_input, '//Sex[$@MaxID]') AS Sex
			 , ExtractValue(_input, '//Vehicle[$@MaxID]') AS Vehicle
             , ExtractValue(_input, '//VehicleType[$@MaxID]') AS VehicleType
			 , ExtractValue(_input, '//ComingFrom[$@MaxID]') AS ComingFrom
			 , ExtractValue(_input, '//Purpose[$@MaxID]') AS Purpose
			 , ExtractValue(_input, '//VisitingCompany[$@MaxID]') AS VisitingCompany
			 , ExtractValue(_input, '//ContactPerson[$@MaxID]') AS ContactPerson
			 , ExtractValue(_input, '//HomeAdd[$@MaxID]') AS HomeAdd
			 , ExtractValue(_input, '//OfcAdd[$@MaxID]') AS OfcAdd
             , ExtractValue(_input, '//Block[$@MaxID]') AS Blok
             , ExtractValue(_input, '//Flat[$@MaxID]') AS Flat
			 , ExtractValue(_input, '//isDeleted[$@MaxID]') AS isDeleted;
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
    
    INSERT INTO dbo.tbl_SecurityCheckEntry(LocalDBID,EntityID,ServerDeviceID,DeviceID,Name,Email,Phone,DOB,Age,Sex,Vehicle,VehicleType,ComingFrom,Purpose,VisitingCompany,ContactPerson,HomeAdd,OfcAdd,Blok,Flat,isDeleted,SystemTime)
    SELECT LocalDBID,EntityID,ServerDeviceID,DeviceID,Name,Email,Phone,DOB,Age,Sex,Vehicle,VehicleType,ComingFrom,Purpose,VisitingCompany,ContactPerson,HomeAdd,OfcAdd,Blok,Flat,isDeleted,ISTDate 
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
		   ,"InformationShared":{"Dummy":0',CASE WHEN NULLIF(da.Name,'') IS NULL THEN '' ELSE CONCAT(',"Name":"',da.Name,'"') END
											,CASE WHEN NULLIF(da.Phone,'') IS NULL THEN '' ELSE CONCAT(',"Phone":"',da.Phone,'"') END
											,CASE WHEN NULLIF(da.Email,'') IS NULL THEN '' ELSE CONCAT(',"Email":"',da.Email,'"') END
											,CASE WHEN NULLIF(da.DOB,'') IS NULL THEN '' ELSE CONCAT(',"DOB":"',da.DOB,'"') END
											,CASE WHEN NULLIF(da.Age,'') IS NULL THEN '' ELSE CONCAT(',"Age":"',da.Age,'"') END
											,CASE WHEN NULLIF(da.Sex,'') IS NULL THEN '' ELSE CONCAT(',"Sex":"',da.Sex,'"') END
											,CASE WHEN NULLIF(da.Vehicle,'') IS NULL THEN '' ELSE CONCAT(',"Vehicle":"',da.Vehicle,'"') END
											,CASE WHEN NULLIF(da.ComingFrom,'') IS NULL THEN '' ELSE CONCAT(',"ComingFrom":"',da.ComingFrom,'"') END
											,CASE WHEN NULLIF(da.Purpose,'') IS NULL THEN '' ELSE CONCAT(',"Purpose":"',da.Purpose,'"') END
											,CASE WHEN NULLIF(da.HomeAdd,'') IS NULL THEN '' ELSE CONCAT(',"HomeAddress":"',da.HomeAdd,'"') END
											,CASE WHEN NULLIF(da.OfcAdd,'') IS NULL THEN '' ELSE CONCAT(',"OfficeAddress":"',da.OfcAdd,'"') END
											,CASE WHEN NULLIF(da.VisitingCompany,'') IS NULL THEN '' ELSE CONCAT(',"VisitingCompany":"',da.VisitingCompany,'"') END
											,CASE WHEN NULLIF(da.ContactPerson,'') IS NULL THEN '' ELSE CONCAT(',"ContactPerson":"',da.ContactPerson,'"') END
                                            ,CASE WHEN NULLIF(da.Blok,'') IS NULL THEN '' ELSE CONCAT(',"Block":"',da.Blok,'"') END
                                            ,CASE WHEN NULLIF(da.Flat,'') IS NULL THEN '' ELSE CONCAT(',"Flat":"',da.Flat,'"') END
							   ,'}}')
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

