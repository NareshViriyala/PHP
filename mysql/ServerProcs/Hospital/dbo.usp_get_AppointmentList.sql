DROP PROCEDURE IF EXISTS dbo.usp_get_AppointmentList;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_AppointmentList(
	   _DeviceID INT 
	 , _HospitalID INT
     , _Guid NVARCHAR(64))
BEGIN
    SELECT da.ID AS ApptID
		 , da.PatientName AS pn
		 , da.AgeYear AS ay
		 , da.AgeMonth AS am
		 , CASE da.Gender WHEN 1 THEN '1' ELSE '0' END AS gen
		 , da.ApptTime AS ApptTime
		 , es.SubjectGuid  AS guid
		 , da.InTime
		 , da.OutTime
         , da.PatientPhone
	  FROM dbo.tbl_mstr_ServerDeviceEntityMap sdem
	  JOIN dbo.tbl_hosp_DoctorAppointment da
	    ON sdem.SubjectID = da.SubjectID
	  JOIN dbo.tbl_mstr_EntitySubject es 
        ON sdem.SubjectID = es.SubjectID
	 WHERE sdem.ServerDeviceID = IFNULL(NULLIF(_DeviceID, 0), sdem.ServerDeviceID)
	   AND sdem.EEID = IFNULL(NULLIF(_HospitalID, 0), sdem.EEID)
	   AND es.SubjectGuid = IFNULL(NULLIF(_Guid, 0), es.SubjectGuid)
	   AND (da.InTime IS NULL OR da.OutTime IS NULL)
	   AND da.UserCancelled = 0
	   AND da.DocCancelled = 0;
END$$
DELIMITER ;

#CALL dbo.usp_get_AppointmentList(1, 3, 'D1ACE192-0BED-4311-BA62-F49DEA2C66F8');

