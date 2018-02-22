DROP PROCEDURE IF EXISTS dbo.usp_get_DoctorDetails;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_DoctorDetails(input NVARCHAR(64))
BEGIN

	DECLARE ID INT;
    IF input REGEXP '^[0-9]+$'
    THEN 
		SET ID = CAST(input AS UNSIGNED);
    ELSE 
		SELECT SubjectID INTO ID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = input;
    END IF;

   SELECT Name AS Dname
		, Degree AS Deg
        , Specialty AS Spec
        , ConsultationFee AS Fee
        , AvgConsultationTime AS Act
        , Mobile
        , Work AS Land
        , Email AS email
        , Image
        , NULL AS remarks
     FROM dbo.tbl_mstr_SubjectDetail
	WHERE SubjectID = ID;

END$$
DELIMITER ;

#CALL dbo.usp_get_DoctorDetails('D1ACE192-0BED-4311-BA62-F49DEA2C66F8');
#SELECT * FROM dbo.tbl_mstr_SubjectDetail;

