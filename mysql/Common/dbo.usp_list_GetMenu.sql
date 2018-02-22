DROP PROCEDURE IF EXISTS dbo.usp_list_GetMenu;

DELIMITER $$
CREATE PROCEDURE dbo.usp_list_GetMenu(
	   input NVARCHAR(64)
	 , PageNumber INT
     , PageCount INT)
BEGIN
	
    DECLARE _ID INT;
    
	IF input REGEXP '^[0-9]+$'
    THEN 
		SELECT EntityID INTO _ID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectID = CAST(input AS UNSIGNED);
	ELSE
		SELECT EntityID INTO _ID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = input;
    END IF;
    
    SELECT * 
      FROM (SELECT rm.ID AS TID
				 , CASE rm.ItemType WHEN 1 THEN '1' ELSE '0' END AS IT
				 , rm.ItemGroup AS IG
				 , rm.ItemName AS 'IN'
				 , rm.ItemPrice AS IP
				 , rm.ItemDesc AS ID
				 , rm.SpiceIndex AS SI
				 , CASE rm.ChefRecommended WHEN 1 THEN '1' ELSE '0' END AS CR
				 , 1 AS Usr
				 , 1 AS Rating
				 , @OID := @OID+1 AS OID
			  FROM dbo.tbl_mstr_RestaurantMenu rm, (SELECT @OID := 0) r
			 WHERE rm.EntityID = _ID) AS tbl_final
	  WHERE tbl_final.OID BETWEEN ((PageNumber-1) * PageCount + 1)	
        AND (PageNumber * PageCount)
      ORDER BY tbl_final.OID;

END$$
DELIMITER ;

#CALL dbo.usp_list_GetMenu('2',2,30);