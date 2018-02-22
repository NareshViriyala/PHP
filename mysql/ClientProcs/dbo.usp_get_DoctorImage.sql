DROP PROCEDURE IF EXISTS dbo.usp_get_DoctorImage;

DELIMITER $$
CREATE PROCEdure dbo.usp_get_DoctorImage(input NVARCHAR(64))
BEGIN
    DECLARE ID INT;
    IF input REGEXP '^[0-9]+$'
    THEN 
		SET ID = CAST(input AS UNSIGNED);
    ELSE 
		SELECT SubjectID INTO ID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = input;
    END IF;
    
   SELECT Image
     FROM dbo.tbl_mstr_SubjectDetail
	WHERE SubjectID = ID;
    
END$$
DELIMITER ;

#CALL dbo.usp_get_DoctorImage('D1ACE192-0BED-4311-BA62-F49DEA2C66F8');