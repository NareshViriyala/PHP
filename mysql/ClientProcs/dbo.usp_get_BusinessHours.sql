DROP PROCEDURE IF EXISTS dbo.usp_get_BusinessHours;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_BusinessHours(input NVARCHAR(64))
BEGIN
	DECLARE EID INT;
    DECLARE SID INT;
    IF input REGEXP '^[0-9]+$'
    THEN 
		SELECT EntityID,SubjectID INTO EID, SID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectID = CAST(input AS UNSIGNED);
    ELSE 
		SELECT EntityID,SubjectID INTO EID, SID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = input;
    END IF;
   -- SELECT EID, SID;
   SELECT DISTINCT bh.Day, bh.BusinessHours AS BH
     FROM dbo.tbl_mstr_EntitySubject es
     JOIN dbo.tbl_mstr_BusinessHour bh
       ON es.EntityID = bh.EntityID
	WHERE es.EntityID = EID
      AND (bh.SubjectID = SID OR bh.SubjectID IS NULL);
    
END$$
DELIMITER ;

#CALL dbo.usp_get_BusinessHours('D1ACE192-0BED-4311-BA62-F49DEA2C66F8');
