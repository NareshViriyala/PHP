DROP PROCEDURE IF EXISTS dbo.usp_get_RestaurantTaxes;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_RestaurantTaxes(input NVARCHAR(64))
BEGIN

	DECLARE ID INT;
    IF input REGEXP '^[0-9]+$'
    THEN 
		SELECT EntityID INTO ID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectID = CAST(input AS UNSIGNED);
    ELSE 
		SELECT EntityID INTO ID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = input;
    END IF;

   SELECT DISTINCT ee.OID
		, ee.TaxName
		, ee.TaxPercentage
     FROM dbo.tbl_mstr_RestaurantTaxType ee
	WHERE ee.EntityID = ID
	ORDER BY ee.OID;

END$$
DELIMITER ;

#CALL dbo.usp_get_RestaurantTaxes('172346723946293');
#SELECT * FROM dbo.tbl_mstr_RestaurantTaxType;
#SELECT * FROM dbo.tbl_mstr_EntitySubject;

