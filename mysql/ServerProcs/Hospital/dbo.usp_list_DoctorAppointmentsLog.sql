DROP PROCEDURE IF EXISTS dbo.usp_list_DoctorAppointmentsLog;

DELIMITER $$
CREATE PROCEDURE dbo.usp_list_DoctorAppointmentsLog(
	   _GUID NVARCHAR(64)
	 , _SearchString NVARCHAR(50)
	 , _PageNumber INT
	 , _PageCount INT)
BEGIN
	SET @OID := 0;
    
    SELECT *
      FROM (SELECT da.ID AS ApptID
				 , da.PatientName
                 , da.AgeYear
                 , da.AgeMonth
                 , CASE da.Gender WHEN 1 THEN '1' ELSE '0' END AS Gender
                 , da.ApptTime
                 , _GUID AS Guid
                 , da.InTime
                 , da.OutTime
                 , CASE da.DocCancelled WHEN 1 THEN '1' ELSE '0' END AS JustIn
                 , CASE da.UserCancelled WHEN 1 THEN '1' ELSE '0' END AS UserCancelled
				 , @OID := @OID + 1 AS OID
                 , da.PatientPhone
			  FROM dbo.tbl_hosp_DoctorAppointment da
			  JOIN dbo.tbl_mstr_EntitySubject es
				ON da.SubjectID = es.SubjectID
			 WHERE es.SubjectGUID = _GUID
			   AND (IFNULL(_SearchString,'') = ''
				OR PatientName LIKE CONCAT('%',_SearchString,'%')
				OR Gender LIKE CONCAT('%',_SearchString,'%'))
			 ORDER BY da.ApptTime DESC) AS tbl_final
     WHERE tbl_final.OID BETWEEN ((_PageNumber-1) * _PageCount + 1)	
       AND (_PageNumber * _PageCount)
     ORDER BY tbl_final.OID;

END$$
DELIMITER ;

#CALL dbo.usp_list_DoctorAppointmentsLog('2968491D-75BB-4C48-8F16-E789EE44860E', NULL, 2, 10);

