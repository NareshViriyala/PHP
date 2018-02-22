DROP PROCEDURE IF EXISTS dbo.usp_add_DoctorAppointment;

DELIMITER $$
CREATE PROCEDURE dbo.usp_add_DoctorAppointment(
	   _DocGuid NVARCHAR(64) 
	 , _PatientName NVARCHAR(200)
	 , _AgeYear TINYINT
	 , _AgeMonth TINYINT
	 , _Gender TINYINT -- 1 = Male, 0 = Female
	 , _PatientDeviceID INT
	 , _CurrApptID INT
     , _PatientPhone NVARCHAR(20))
BEGIN
	DECLARE _SubjectID INT;
    DECLARE _PreCount INT DEFAULT 0;
    DECLARE _AWT INT DEFAULT 0;
	IF _DocGuid REGEXP '^[0-9]+$'
	THEN 
		SET _SubjectID = CAST(_DocGuid AS UNSIGNED);
	ELSE 
		SELECT SubjectID INTO _SubjectID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = _DocGuid;
	END IF;
    
    IF EXISTS (SELECT 1 FROM dbo.tbl_hosp_DoctorAppointment WHERE ID = _CurrApptID AND OutTime IS NOT NULL)#if the user is trying to access the appt after it is closed then simply send -1 as appr_id
    THEN
		SELECT -1 AS ApptID, NOW() AS ApptTime, -1 AS Qcnt, 0 AS AWT; 
    ELSE
		IF _CurrApptID = 0
        THEN
			INSERT INTO dbo.tbl_hosp_DoctorAppointment(SubjectID, PatientName, AgeYear, AgeMonth, Gender, PatientDeviceID, ApptTime, PatientPhone)
            SELECT _SubjectID, _PatientName, _AgeYear, _AgeMonth, _Gender, _PatientDeviceID, NOW(), _PatientPhone;
            
            SET _CurrApptID = LAST_INSERT_ID();
        ELSE
			UPDATE dbo.tbl_hosp_DoctorAppointment
               SET PatientName = _PatientName
				 , AgeYear = _AgeYear
				 , AgeMonth = _AgeMonth
				 , Gender = _Gender
                 , PatientDeviceID = _PatientDeviceID
                 , SubjectID = _SubjectID
                 , PatientPhone = _PatientPhone
			 WHERE ID = _CurrApptID;
        END IF;
        
        SELECT COUNT(*), MIN(sd.AvgConsultationTime) INTO _PreCount, _AWT
		  FROM dbo.tbl_hosp_DoctorAppointment da 
		  JOIN dbo.tbl_mstr_SubjectDetail sd 
			ON da.SubjectID = sd.SubjectID
		 WHERE da.SubjectID = _SubjectID
		   AND da.InTime IS NULL
		   AND da.OutTIme IS NULL
		   AND da.ApptTime IS NOT NULL
		   AND da.ID < _CurrApptID
		 GROUP BY da.SubjectID;
         
		   SET _PreCount = CASE WHEN _PreCount = 0 THEN 0 ELSE _PreCount + 1 END;
	    SELECT _CurrApptID AS ApptID, NOW() AS ApptTime, _PreCount AS Qcnt, (_PreCount*_AWT) AS AWT;
        
        INSERT INTO dbo.tbl_PushNotification(DeviceUri, DeviceType, PushMessage, DeviceGroup)
		SELECT msd.Uri
			 , msd.DeviceType 
			 , CONCAT('{"ApptID":',_CurrApptID,',"pn":"',_PatientName,'",
				 "ay":',_AgeYear,',"am":',_AgeMonth,',
				 "gen":',_Gender,',"ApptTime":"',NOW(),'",
				 "guid":"',es.SubjectGuid,'",
				 "Status":"New Appointment","ScreenName":"ActivityAppointments","JustIn":1,"InTime":"null","OutTime":"null"}')
			 , 'Server'
		  FROM dbo.tbl_mstr_EntitySubject es
		  JOIN dbo.tbl_mstr_ServerDeviceEntityMap sd
			ON es.EntityID = sd.EEID
		   AND sd.SubjectID = es.SubjectID
		  JOIN dbo.tbl_mstr_ServerDevice msd
			ON sd.ServerDeviceID = msd.ID
		 WHERE es.SubjectID = _SubjectID
		   AND msd.Uri IS NOT NULL;
    END IF;
    
END$$
DELIMITER ;
#CALL dbo.usp_add_DoctorAppointment(1, 1,'34', 1, 100);

