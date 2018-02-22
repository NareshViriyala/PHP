DROP PROCEDURE IF EXISTS dbo.usp_list_ClientHistory;

DELIMITER $$
CREATE PROCEDURE dbo.usp_list_ClientHistory(
	   DeviceID NVARCHAR(50)
	 , PageNumber INT
     , PageCount INT)
BEGIN
	DECLARE _ID INT;
    DECLARE _QueueCnt INT DEFAULT 0; -- Incase the user has an open appointment, then show the Queue count
    DECLARE _ApptID INT DEFAULT 0;
 	DECLARE _SubjectID INT; 
 	DECLARE _PreCnt INT DEFAULT 0;
    -- CREATE TEMPORARY TABLE tbl_temp_clienthistory (Type NVARCHAR(50), Info NVARCHAR(2000), LogTime DATETIME)engine=memory; 

	IF DeviceID REGEXP '^[0-9]+$'
    THEN 
		SET _ID = CAST(DeviceID AS UNSIGNED);
	ELSE
		START TRANSACTION;
			SET SQL_SAFE_UPDATES=0;
			SELECT ID INTO _ID FROM dbo.tbl_mstr_GroupDevice;
            SET _ID = _ID+1;
			UPDATE dbo.tbl_mstr_GroupDevice SET ID = _ID, UpdateDate = NOW();
            SET SQL_SAFE_UPDATES=1;
		COMMIT;
        INSERT INTO dbo.tbl_mstr_UserDevice(ID, DeviceID)
		SELECT _ID, DeviceID; 
    END IF;
	
    /*
    -- Getting the Queue count
	SELECT ID, SubjectID 
      INTO _ApptID, _SubjectID
	  FROM dbo.tbl_hosp_DoctorAppointment
	 WHERE PatientDeviceID = _ID
	   AND InTime IS NULL
	   AND OutTIme IS NULL;
	SELECT COUNT(*) INTO _PreCnt 
	  FROM dbo.tbl_hosp_DoctorAppointment da
	 WHERE da.SubjectID = _SubjectID
	   AND da.InTime IS NULL
	   AND da.OutTime IS NULL
	   AND da.ID < _ApptID;
       */
       
    SELECT * FROM
    (SELECT Type, Info, LogTime, Image, @OID := @OID + 1 AS OID
      FROM (SELECT Type, Info, LogTime, Image
			  FROM (SELECT 'Parking' AS Type
						 , CONCAT('{|EntityName|:|',ee.EEName,'|,|InDate|:|',IFNULL(ve.EnterDateTime,''),'|,|OutDate|:|',IFNULL(ve.ExitDateTime,''),'|,|VehicleNo|:|',ve.VehicleNo,'|,|TariffAmt|:',tp.TariffAmount,'}') AS Info
						 , ve.EnterDateTime AS LogTime
                         , ee.Image
					  FROM dbo.tbl_VehicleEntry ve
					  JOIN dbo.tbl_mstr_EstablishmentEntity ee
						ON ve.EEID = ee.EEID
					  LEFT JOIN dbo.tbl_mstr_TariffPlanTime tp
						ON ve.EEID = tp.EEID
					   AND ve.TCTID = tp.TCTID
					   AND ve.VehicleType = tp.VehicleType
					   AND TIMESTAMPDIFF(MINUTE, ve.EnterDateTime, IFNULL(ve.ExitDateTime, NOW())) BETWEEN tp.MinMinutes AND tp.MaxMinutes 
					 WHERE ve.UDID = _ID
					 UNION ALL
					SELECT 'General Visit' AS Type
						 , CONCAT('{|EntityName|:|',ee.EEName,'|,|Information Shared|:{|Dummy|:0',CASE WHEN NULLIF(sce.Name,'') IS NULL THEN '' ELSE CONCAT(',|Name|:|',sce.Name,'|') END
																					   ,CASE WHEN NULLIF(sce.Phone,'') IS NULL THEN '' ELSE CONCAT(',|Phone|:|',sce.Phone,'|') END
																					   ,CASE WHEN NULLIF(sce.Email,'') IS NULL THEN '' ELSE CONCAT(',|Email|:|',sce.Email,'|') END
																					   ,CASE WHEN NULLIF(sce.HomeAdd,'') IS NULL THEN '' ELSE CONCAT(',|HomeAddress|:|',sce.HomeAdd,'|') END
																					   ,CASE WHEN NULLIF(sce.OfcAdd,'') IS NULL THEN '' ELSE CONCAT(',|OfficeAddress|:|',sce.OfcAdd,'|') END
																					   ,CASE WHEN NULLIF(sce.DOB,'') IS NULL THEN '' ELSE CONCAT(',|DOB|:|',sce.DOB,'|') END
																					   ,CASE WHEN NULLIF(sce.Age,'') IS NULL THEN '' ELSE CONCAT(',|Age|:|',sce.Age,'|') END
																					   ,CASE WHEN NULLIF(sce.Sex,'') IS NULL THEN '' ELSE CONCAT(',|Sex|:|',sce.Sex,'|') END
																					   ,CASE WHEN NULLIF(sce.Vehicle,'') IS NULL THEN '' ELSE CONCAT(',|Vehicle|:|',SUBSTRING(sce.Vehicle,1,20),'|') END
																					   ,CASE WHEN NULLIF(sce.ComingFrom,'') IS NULL THEN '' ELSE CONCAT(',|ComingFrom|:|',sce.ComingFrom,'|') END
																					   ,CASE WHEN NULLIF(sce.Purpose,'') IS NULL THEN '' ELSE CONCAT(',|Purpose|:|',sce.Purpose,'|') END
																					   ,CASE WHEN NULLIF(sce.VisitingCompany,'') IS NULL THEN '' ELSE CONCAT(',|VisitingCompany|:|',sce.VisitingCompany,'|') END
                                                                                       ,CASE WHEN NULLIF(sce.Blok,'') IS NULL THEN '' ELSE CONCAT(',|Block|:|',sce.Blok,'|') END
                                                                                       ,CASE WHEN NULLIF(sce.Flat,'') IS NULL THEN '' ELSE CONCAT(',|Flat|:|',sce.Flat,'|') END
																					   ,CASE WHEN NULLIF(sce.ContactPerson,'') IS NULL THEN '' ELSE CONCAT(',|ContactPerson|:|',sce.ContactPerson,'|') END,'}}') AS Info
						 , sce.SystemTime AS LogTime
                         , ee.Image
					  FROM dbo.tbl_SecurityCheckEntry sce
					  JOIN dbo.tbl_mstr_EstablishmentEntity ee
						ON sce.EntityID = ee.EEID
					 WHERE sce.DeviceID = _ID
					 UNION ALL
					SELECT 'Hospital' AS Type
						 , CONCAT('{|EntityName|:|',ee.EEName,'|,|DoctorName|:|',sd.Name,'|,|ApptID|:',sce.ID,',|InDate|:|',IFNULL(sce.InTime, ''),'|,|OutDate|:|',IFNULL(sce.OutTime, ''),'|,|QCnt|:',IFNULL(pre.PreCnt, 0),',|Remark|:|',CASE WHEN sce.UserCancelled = 1 THEN 'You cancelled this appointment' WHEN sce.DocCancelled = 1 THEN 'Doctor cancelled this appointment' ELSE '' END,'|,|Fee|:',sd.ConsultationFee,'}') AS Info
						 , sce.ApptTime AS LogTime
                         , sd.Image
					  FROM dbo.tbl_hosp_DoctorAppointment sce
                      
					  JOIN dbo.tbl_mstr_SubjectDetail sd
						ON sce.SubjectID = sd.SubjectID
					  JOIN dbo.tbl_mstr_EntitySubject es
						ON sd.SubjectID = es.SubjectID
					  JOIN dbo.tbl_mstr_EstablishmentEntity ee
						ON es.EntityID = ee.EEID
					  LEFT JOIN(SELECT da.SubjectID, (COUNT(*)-1) AS PreCnt, MAX(da.ID) AS ApptID 
								  FROM dbo.tbl_hosp_DoctorAppointment da
								  LEFT JOIN (SELECT ID, SubjectID 
										  FROM dbo.tbl_hosp_DoctorAppointment
										 WHERE PatientDeviceID = _ID
										   AND InTime IS NULL
										   AND OutTIme IS NULL) AS tbl
									ON da.SubjectID = tbl.SubjectID
								   AND da.ID <= tbl.ID
								 WHERE da.InTime IS NULL
								   AND da.OutTime IS NULL
								 GROUP BY da.SubjectID) pre
                        ON sce.SubjectID = pre.SubjectID
				       AND sce.ID = pre.ApptID
					 WHERE sce.PatientDeviceID = _ID
					 UNION ALL
					SELECT 'Restaurant' AS Type
						 , CONCAT('{|EntityName|:|',MIN(ee.EEName),'|,|Total items|:',COUNT(*),',|Total bill|:',dbo.fn_gettotalbill(pom.ID),'}') AS Info
						 , MIN(pom.PlacedTime) AS LogTime
                         , ee.Image
					  FROM dbo.tbl_rest_PlacedOrderMaster pom
					  JOIN dbo.tbl_rest_PlacedOrderSlave pos
						ON pom.ID = pos.MasterID
					  JOIN dbo.tbl_mstr_EntitySubject es
						ON pom.SubjectID = es.SubjectID
					  JOIN dbo.tbl_mstr_EstablishmentEntity ee
						ON es.EntityID = ee.EEID
					  JOIN dbo.tbl_mstr_RestaurantMenu rm
						ON pos.TID = rm.ID
					 WHERE pom.DeviceID = _ID 
					 GROUP BY pom.ID
					 UNION ALL
					SELECT 'Restaurant' AS Type
						 , CONCAT('{|EntityName|:|',MIN(ee.EEName),'|,|Total items|:',COUNT(*),',|Total bill|:',dbo.fn_gettotalbill(pom.MasterID),'}') AS Info
						 , MIN(pom.PlacedTime) AS LogTime
                         , ee.Image
					  FROM dbo.tbl_rest_PlacedOrderMasterArchive pom
					  JOIN dbo.tbl_rest_PlacedOrderSlaveArchive pos
						ON pom.MasterID = pos.MasterID
					  JOIN dbo.tbl_mstr_EntitySubject es
						ON pom.SubjectID = es.SubjectID
					  JOIN dbo.tbl_mstr_EstablishmentEntity ee
						ON es.EntityID = ee.EEID
					  JOIN dbo.tbl_mstr_RestaurantMenu rm
						ON pos.TID = rm.ID
					 WHERE pom.DeviceID = _ID
					 GROUP BY pom.MasterID
                     ) AS tbl
			ORDER BY LogTime DESC) AS tbl_order, (SELECT @OID := 0) r) AS tbl_final
	 WHERE tbl_final.OID BETWEEN ((PageNumber-1) * PageCount + 1)	
       AND (PageNumber * PageCount)
     ORDER BY tbl_final.OID;
	

END$$
DELIMITER ;

#CALL dbo.usp_list_ClientHistory(3,1,10);