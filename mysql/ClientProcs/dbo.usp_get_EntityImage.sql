DROP PROCEDURE IF EXISTS dbo.usp_get_EntityImage;

DELIMITER $$
CREATE PROCEdure dbo.usp_get_EntityImage(input NVARCHAR(64))
BEGIN
	DECLARE ID INT;
    DECLARE GUID NVARCHAR(64);
    IF input REGEXP '^[0-9]+$'
    THEN SET ID = CAST(input AS UNSIGNED);
    ELSE SET GUID = input;
    END IF;
    
   SELECT Image
     FROM dbo.tbl_mstr_EstablishmentEntity ee
     JOIN dbo.tbl_mstr_EntitySubject es
       ON ee.EEID = es.EntityID
	WHERE (es.SubjectGuid = GUID or GUID IS NULL)
	  AND (es.SubjectID = ID or ID IS NULL);
    
END$$
DELIMITER ;

#CALL dbo.usp_get_EntityImage('5');