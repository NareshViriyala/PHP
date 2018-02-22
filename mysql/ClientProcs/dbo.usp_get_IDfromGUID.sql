DROP PROCEDURE IF EXISTS dbo.usp_get_IDfromGUID;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_IDfromGUID(guid NVARCHAR(64))
BEGIN
   SELECT SubjectID
     FROM dbo.tbl_mstr_EntitySubject
	WHERE SubjectGuid = guid;
END$$
DELIMITER ;

#CALL dbo.usp_get_IDfromGUID('c26d03c9-f5a6-11e6-9885-b46d833ff56b');

