DROP PROCEDURE IF EXISTS dbo.usp_get_PlacedOrderItems;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_PlacedOrderItems(input NVARCHAR(64))
BEGIN
	DECLARE _SubjectID INT;
	SELECT SubjectID INTO _SubjectID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = input;

	SET SQL_SAFE_UPDATES=0;
   UPDATE dbo.tbl_rest_PlacedOrderMaster
      SET AckTime = NOW()
        , AckBit = 1
        , CallWaiter = 1
    WHERE SubjectID = _SubjectID;
    SET SQL_SAFE_UPDATES=1;
    
   SELECT rm.ID AS ItemID
		, rm.ItemGroup
        , rm.ItemName
        , rm.ItemPrice
	    , os.Quantity
	    , om.Person
	    , om.DeviceID
	    , om.ID AS MasterID
        , rm.OrderID  
        , CASE rm.ItemType WHEN 1 THEN '1' ELSE '0' END  AS ItemType
     FROM dbo.tbl_rest_PlacedOrderMaster om
     JOIN dbo.tbl_rest_PlacedOrderSlave os
       ON om.ID = os.MasterID
     JOIN dbo.tbl_mstr_RestaurantMenu rm
       ON os.TID = rm.ID
    WHERE om.SubjectID = _SubjectID
    ORDER BY om.DeviceID, rm.ID;
    
END$$
DELIMITER ;

#CALL dbo.usp_get_PlacedOrderItems('49F2F5AB-15AC-47C9-99B0-FC3CDBDF946B');
