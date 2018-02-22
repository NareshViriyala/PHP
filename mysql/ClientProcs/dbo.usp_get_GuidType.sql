DROP PROCEDURE IF EXISTS dbo.usp_get_GuidType;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_GuidType(input NVARCHAR(64))
BEGIN

	DECLARE ID INT;
    IF input REGEXP '^[0-9]+$'
    THEN 
		SET ID = CAST(input AS UNSIGNED);
    ELSE 
		SELECT SubjectID INTO ID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = input;
    END IF;

   SELECT EntityType
        , SubjectType
     FROM dbo.tbl_mstr_EntitySubject
	WHERE SubjectID = ID;

END$$
DELIMITER ;

#CALL dbo.usp_get_GuidType('4');

