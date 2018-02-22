DROP PROCEDURE IF EXISTS dbo.usp_get_DoctorQueueLoadSelf;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_DoctorQueueLoadSelf(input NVARCHAR(64), userid INT)
BEGIN
	DECLARE _ID INT;
    DECLARE _ApptID INT DEFAULT 0;
    DECLARE _pn NVARCHAR(100);
    DECLARE _ay INT;
    DECLARE _am INT;
    DECLARE _gender INT;
    DECLARE _ApptTime DATETIME;
    IF input REGEXP '^[0-9]+$'
    THEN 
		SET _ID = CAST(input AS UNSIGNED);
    ELSE 
		SELECT SubjectID INTO _ID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = input;
    END IF;
    
    
    SELECT ID
		 , PatientName
         , AgeYear
         , AgeMonth
         , CASE Gender WHEN 1 THEN '1' ELSE '0' END AS Gender
         , ApptTime
	  INTO _ApptID 
		 , _pn
         , _ay
         , _am
         , _gender
         , _ApptTime
      FROM dbo.tbl_hosp_DoctorAppointment da
	 WHERE da.SubjectID = _ID
	   AND da.PatientDeviceID = userid
	   AND da.InTime IS NULL
	   AND da.OutTIme IS NULL
	   AND da.ApptTime IS NOT NULL;
    
    IF _ApptID <> 0
	THEN
		SELECT es.SubjectID AS Guid
			 #Version:1 IFNULL(c.Qid, 0) AS Qcnt
             #Bug here was, if the user was 1st in the Q and there is one patient with the doctor, then ideally the Q status for the user should be 1
             # where as it was showing as 0 the left join was resulting in 0 rows hence change the logic here
             #Version:2 IFNULL(c.Qid, 1) AS Qcnt
			 , IFNULL(c.Qid, 1) AS Qcnt
             #Version:1 IFNULL((AvgConsultationTime*c.Qid), 0) AS AWT
             #Bug here was, if the user was 1st in the Q and there is one patient with the doctor, then ideally the Avg waiting time for the user should be 1*AWT
             # where as it was showing as 0 the left join was resulting in 0 for Qid hence change the logic here
             #Version:2 IFNULL((AvgConsultationTime*IFNULL(c.Qid,1)), 0) AS AWT
             , IFNULL((AvgConsultationTime*IFNULL(c.Qid,1)), 0) AS AWT
             , _ApptID AS ApptID
             , _pn AS PatientName
             , _ay AS AgeYear
             , _am as AgeMonth
             , _gender AS Gender
             , _ApptTime AS ApptTime
		  FROM dbo.tbl_mstr_SubjectDetail es
          #Version:1 LEFT JOIN (SELECT da.SubjectID, CASE IFNULL(COUNT(*),0) WHEN 0 THEN 0 ELSE COUNT(*)+1 END AS Qid
          #The problem with above line is, if doctor is attending to one patient and if you are next, then in that case
          #ideally your qcnt should be 1 but it is showing as 0, hence i am change the logic here to version:2
          #Version:2 LEFT JOIN (SELECT da.SubjectID, IFNULL(COUNT(*),0)+1 END AS Qid
		  LEFT JOIN (SELECT da.SubjectID, IFNULL(COUNT(*),0)+1 AS Qid
					  FROM dbo.tbl_hosp_DoctorAppointment da
					 WHERE da.SubjectID = _ID
                       AND da.ID < _ApptID
					   AND da.InTime IS NULL
					   AND da.OutTIme IS NULL
					   AND da.ApptTime IS NOT NULL
					 GROUP BY da.SubjectID) AS c
		    ON es.SubjectID = c.SubjectID
		 WHERE es.SubjectID = _ID;
	ELSE #_ApptID = 0 in 2 cases, 1. The user has no appointment or the user has appt and is currently with the doctor
		IF EXISTS (SELECT 1 FROM dbo.tbl_hosp_DoctorAppointment WHERE SubjectID = _ID AND PatientDeviceID = userid AND InTime IS NOT NULL AND OutTime IS NULL) THEN #the user has appt and is currently with the doctor
			SELECT SubjectID AS Guid
				 , 0 AS Qcnt
				 , 0 AS AWT
				 , NOW() AS ApptTime
				 , ID AS ApptID
                 , PatientName
				 , AgeYear
				 , AgeMonth
				 , CASE Gender WHEN 1 THEN '1' ELSE '0' END AS Gender
				 , ApptTime
			 FROM dbo.tbl_hosp_DoctorAppointment 
			WHERE SubjectID = _ID
              AND PatientDeviceID = userid
              AND InTime IS NOT NULL
              AND OutTime IS NULL;
        ELSE #The user has no appointment
			SELECT es.SubjectID AS Guid
				 , IFNULL(c.Qid, 0) AS Qcnt
				 , IFNULL((AvgConsultationTime*c.Qid), 0) AS AWT
				 , NOW() AS ApptTime
				 , '0' AS ApptID
			 FROM dbo.tbl_mstr_SubjectDetail es
			 LEFT JOIN (SELECT da.SubjectID, COUNT(*) AS Qid
						  FROM dbo.tbl_hosp_DoctorAppointment da
						 WHERE da.SubjectID = _ID
						   AND da.InTime IS NULL
						   AND da.OutTIme IS NULL
						   AND da.ApptTime IS NOT NULL
						 GROUP BY da.SubjectID) AS c
			   ON es.SubjectID = c.SubjectID
			WHERE es.SubjectID = _ID;
		END IF;
	END IF;    
END$$
DELIMITER ;

#CALL dbo.usp_get_DoctorQueueLoadSelf('4',13);
