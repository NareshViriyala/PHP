DROP PROCEDURE IF EXISTS dbo.usp_list_RestaurantTableLog;

DELIMITER $$
CREATE PROCEDURE dbo.usp_list_RestaurantTableLog(
	   _Guid NVARCHAR(64)
	 , _SearchString NVARCHAR(50)
	 , _PageNumber INT
	 , _PageCount INT)
BEGIN
	
	DECLARE _SubjectID INT;
	SELECT SubjectID INTO _SubjectID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = _Guid;
    SET @OID := 0;
	SELECT * FROM
    (SELECT *, @OID := @OID + 1 AS OID
      FROM (SELECT pom.ID AS MasterID
				 , COUNT(*) AS TotalItems
				 , dbo.fn_gettotalbill(pom.ID) AS TotalBill
				 , MIN(pom.PlacedTime) AS PlacedTime
				 , GROUP_CONCAT(CONCAT('{TID:',pos.TID,',Qty:',pos.Quantity,'}')) AS Items
			  FROM dbo.tbl_rest_PlacedOrderMaster pom
			  JOIN dbo.tbl_rest_PlacedOrderSlave pos
				ON pom.ID = pos.MasterID
			 WHERE pom.SubjectID = _SubjectID
			 GROUP BY pom.ID
			 UNION
			 SELECT pom.MasterID
				 , COUNT(*)
				 , dbo.fn_gettotalbill(pom.MasterID)
				 , MIN(pom.PlacedTime)
				 , GROUP_CONCAT(CONCAT('{TID:',pos.TID,',Qty:',pos.Quantity,'}')) AS Items
			  FROM dbo.tbl_rest_PlacedOrderMasterArchive pom
			  JOIN dbo.tbl_rest_PlacedOrderSlaveArchive pos
				ON pom.MasterID = pos.MasterID
			 WHERE pom.SubjectID = _SubjectID
			 GROUP BY pom.MasterID) AS tbl ORDER BY MasterID) AS tbl_final
	 WHERE tbl_final.OID BETWEEN ((_PageNumber-1) * _PageCount + 1)	
       AND (_PageNumber * _PageCount)
     ORDER BY tbl_final.OID;
    
END$$
DELIMITER ;

#CALL dbo.usp_list_RestaurantTableLog('5B0A3D65-BA4C-4312-9910-0F13D994513D', NULL, 2, 20);
