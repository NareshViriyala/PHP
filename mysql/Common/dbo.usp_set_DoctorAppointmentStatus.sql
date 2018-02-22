DROP PROCEDURE IF EXISTS dbo.usp_set_DoctorAppointmentStatus;

DELIMITER $$
CREATE PROCEDURE dbo.usp_set_DoctorAppointmentStatus(
	   _ApptID INT 
	 , _CallType NVARCHAR(50)
	 , _CallFrom INT
	 , _DeviceID INT)
BEGIN
	DECLARE ISTDate DATETIME DEFAULT NOW();
    DECLARE _PreCnt INT DEFAULT 0;
	UPDATE dbo.tbl_hosp_DoctorAppointment
	   SET InTime = CASE _CallType WHEN 'In' THEN IFNULL(InTime, ISTDate)
								   WHEN 'Out' THEN IFNULL(InTime, ISTDate)
								   WHEN 'UserCancelled' THEN IFNULL(InTime, ISTDate)
								   WHEN 'DocCancelled' THEN IFNULL(InTime, ISTDate)
								   ELSE InTime END
	     , OutTime = CASE _CallType WHEN 'Out' THEN IFNULL(OutTime, ISTDate) 
									WHEN 'UserCancelled' THEN IFNULL(OutTime, ISTDate)
								    WHEN 'DocCancelled' THEN IFNULL(OutTime, ISTDate)
								    ELSE OutTime END
	     , UserCancelled = CASE _CallType WHEN 'UserCancelled' THEN 1 ELSE UserCancelled END
	     , DocCancelled = CASE _CallType WHEN 'DocCancelled' THEN 1 ELSE DocCancelled END
	     , CallDeviceID = _DeviceID
	 WHERE ID = _ApptID;
     
	-- Implement push notification to the corresponding patient devices about the status change
    -- when Qid = 0 and ct = 'In', that patient is called now, accordingly send push notifications
    -- when Qid = 0 and ct = 'Out', that patient has come out of doctor's room, accordingly send push notifications
	 IF _CallType = 'Out'
	 THEN
		INSERT INTO dbo.tbl_PushNotification(DeviceUri, DeviceType, PushMessage, DeviceGroup)
		SELECT ud.Uri
		     , ud.DeviceType
		     , CONCAT('{"ApptID":',_ApptID,'
		       ,"DeviceID":',da.PatientDeviceID,'
		       ,"ApptTime":"',da.ApptTime,'"
		       ,"Qcnt":0,"AWT":0
		       ,"ScreenName":"FragmentScanQR","Status":"Visit Complete"}')
		     , 'Client'
		  FROM dbo.tbl_hosp_DoctorAppointment da
		  JOIN dbo.tbl_mstr_UserDevice ud
		    ON da.PatientDeviceID = ud.ID
		 WHERE da.ID = _ApptID
		   AND ud.Uri IS NOT NULL;
	 END IF;
     
     -- send notification to doc device that the user has cancelled the meeting
     IF _CallType = 'UserCancelled' 
	 THEN
		INSERT INTO dbo.tbl_PushNotification(DeviceUri, DeviceType, PushMessage, DeviceGroup)
		SELECT DISTINCT msd.Uri
			 , msd.DeviceType 
			 , CONCAT('{"ApptID":',_ApptID,',"ScreenName":"ActivityAppointments","Status":"Appointment Cancelled","guid":"',es.SubjectGUID,'"}')
			 , 'Server'
		  FROM dbo.tbl_hosp_DoctorAppointment da
		  JOIN dbo.tbl_mstr_EntitySubject es
		    ON da.SubjectID = es.SubjectID
		  JOIN dbo.tbl_mstr_ServerDeviceEntityMap sd
			ON es.EntityID = sd.EEID
		   AND sd.SubjectID = da.SubjectID
		  JOIN dbo.tbl_mstr_ServerDevice msd
			ON sd.ServerDeviceID = msd.ID
		 WHERE da.ID = _ApptID
		   AND msd.Uri IS NOT NULL;
	 END IF;

	-- send notification to user device that the doc has cancelled the meeting
	 IF _CallType = 'DocCancelled' 
	 THEN
		 
		INSERT INTO dbo.tbl_PushNotification(DeviceUri, DeviceType, PushMessage, DeviceGroup)
		SELECT msd.Uri
			 , msd.DeviceType 
			 , CONCAT('{"ApptID":',_ApptID,'
			   ,"ApptTime":"',da.ApptTime,'"
			   ,"Qcnt":0,"AWT":0
			   ,"ScreenName":"FragmentScanQR","Status":"Appointment Cancelled","guid":""}')
			 , 'Client'
		  FROM dbo.tbl_hosp_DoctorAppointment da
		  JOIN dbo.tbl_mstr_UserDevice msd
		    ON msd.ID = da.PatientDeviceID
		 WHERE da.ID = _ApptID
		   AND msd.Uri IS NOT NULL;
	 END IF;
     
     -- send notification to the Q members only when a call is made to the first patient in the Q
	IF _CallType <> 'Out' 
	THEN
	   
        #case where there are n people in the quere and the doctor instead of calling the 1st person in the Q calls (say) 3rd person
        #in that case the status(Q count) for 1st and 2nd member will not change where as from 4th the Q count will reduce by 1
		SELECT COUNT(*) INTO _PreCnt
		  FROM dbo.tbl_hosp_DoctorAppointment da
		 WHERE da.SubjectID = (SELECT SubjectID FROM dbo.tbl_hosp_DoctorAppointment WHERE ID = _ApptID)
		   AND da.InTime IS NULL
		   AND da.OutTime IS NULL
		   AND da.ID < _ApptID;
		    

		SET _PreCnt = CASE _CallType WHEN 'In' THEN _PreCnt-1 ELSE _PreCnt END;
							
		
        SET @Qcnt := 0;
        
        INSERT INTO dbo.tbl_PushNotification(DeviceUri, DeviceType, PushMessage, DeviceGroup)
        SELECT Uri
		      , DeviceType
		      , CONCAT('{"ApptID":',ApptID,'
						,"DeviceID":',DeviceID,'
						,"ApptTime":"',ApptTime,'"
						,"Qcnt":',Qcnt,'
						,"AWT":',AWT,'
						,"ScreenName":"FragmentScanQR","Status":"Status Update"}')
		      , 'Client'
          FROM (SELECT ApptID
					 , DeviceID
					 , ApptTime
					 , Uri
					 , DeviceType
					 , CASE WHEN ApptID = _ApptID THEN 0 ELSE ((_PreCnt+Qcnt)*AvgConsultationTime) END AS AWT
					 , CASE WHEN ApptID = _ApptID THEN 0 ELSE (_PreCnt+Qcnt) END AS Qcnt
				  FROM (SELECT da.ID AS ApptID
							 , da.PatientDeviceID AS DeviceID
							 , da.ApptTime
							 , ud.Uri
							 , ud.DeviceType
							 , @Qcnt := @Qcnt + 1 AS Qcnt
							 , sd.AvgConsultationTime
						  FROM dbo.tbl_hosp_DoctorAppointment da						  
						  JOIN dbo.tbl_mstr_SubjectDetail sd 
							ON sd.SubjectID = da.SubjectID
						  #Version:1 JOIN dbo.tbl_mstr_UserDevice ud, Bug detected, if there is a mix of web and mobile user then the Q count was ignoring the
                          #web users as they exists in a different table.
                          #Version:2 LEFT JOIN dbo.tbl_mstr_UserDevice ud 
                          #Left join would make sure the the web users are also considerd in the Q count thought the notification is not sent to them
						  LEFT JOIN dbo.tbl_mstr_UserDevice ud 
							ON da.PatientDeviceID = ud.ID
						 WHERE da.OutTime IS NULL
						   AND da.ID >= _ApptID
						   AND da.SubjectID = (SELECT SubjectID FROM dbo.tbl_hosp_DoctorAppointment WHERE ID = _ApptID)) AS tbl_a) AS tbl_b
         WHERE tbl_b.Uri IS NOT NULL;
	 END IF;
END$$
DELIMITER ;
#CALL dbo.usp_set_DoctorAppointmentStatus(1, 1,'34', 1, 100);

