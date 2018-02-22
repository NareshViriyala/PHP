DROP PROCEDURE IF EXISTS dbo.usp_get_DoctorQueueLoad;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_DoctorQueueLoad(input NVARCHAR(64))
BEGIN
	DECLARE ID INT;
    IF input REGEXP '^[0-9]+$'
    THEN 
		SET ID = CAST(input AS UNSIGNED);
    ELSE 
		SELECT SubjectID INTO ID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = input;
    END IF;
    
   SELECT es.SubjectID AS Guid, IFNULL(c.Qid, 0) AS Qcnt, IFNULL((AvgConsultationTime*c.Qid), 0) AS AWT, NOW() AS ApptTime, '0' AS ApptID
     FROM dbo.tbl_mstr_SubjectDetail es
     LEFT JOIN (SELECT da.SubjectID, COUNT(*) AS Qid
				  FROM dbo.tbl_hosp_DoctorAppointment da
				 WHERE da.SubjectID = ID
				   AND da.InTime IS NULL
				   AND da.OutTIme IS NULL
				   AND da.ApptTime IS NOT NULL
				 GROUP BY da.SubjectID) AS c
       ON es.SubjectID = c.SubjectID
	WHERE es.SubjectID = ID;
    
END$$
DELIMITER ;

#CALL dbo.usp_get_DoctorQueueLoad('5');
