DROP PROCEDURE IF EXISTS dbo.usp_get_RestaurantPlacedOrderSelf;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_RestaurantPlacedOrderSelf(input NVARCHAR(64), userid INT)
BEGIN
	DECLARE _ID INT;
    IF input REGEXP '^[0-9]+$'
    THEN 
		SET _ID = CAST(input AS UNSIGNED);
    ELSE 
		SELECT SubjectID INTO _ID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = input;
    END IF;
    
	SELECT TID, Quantity,MasterID
      FROM dbo.tbl_rest_PlacedOrderSlave pos
      JOIN dbo.tbl_rest_PlacedOrderMaster pom
        ON pos.MasterID = pom.ID
     WHERE pom.SubjectID = _ID
       AND pom.DeviceID = userid;
END$$
DELIMITER ;

#CALL dbo.usp_get_RestaurantPlacedOrderSelf('2',13);
