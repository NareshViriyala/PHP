DROP PROCEDURE IF EXISTS dbo.usp_get_DoctorList;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_DoctorList(
	   _DeviceID INT 
	 , _HospitalID INT)
BEGIN

   SELECT C.SubjectGuid AS guid
		, IFNULL(_HospitalID, 0) AS EntityID
		, Name AS Dname
		, Degree AS Deg
		, Specialty AS Spec
		, ConsultationFee AS Fee
		, AvgConsultationTime AS Act
		, Mobile AS mobile
		, Work AS land
		, Email AS email
		, NULL AS remarks
     FROM dbo.tbl_mstr_SubjectDetail es
     JOIN (SELECT DISTINCT em.SubjectID, es.SubjectGuid
			 FROM dbo.tbl_mstr_ServerDeviceEntityMap em
             JOIN dbo.tbl_mstr_EntitySubject es
               ON em.SubjectID = es.SubjectID
			WHERE em.ServerDeviceID = IFNULL(NULLIF(_DeviceID, 0), em.ServerDeviceID)
			  AND EEID = IFNULL(NULLIF(_HospitalID, 0), EEID)) AS C
       ON es.SubjectID = C.SubjectID;

END$$
DELIMITER ;

#CALL dbo.usp_get_DoctorList(1, 3);

