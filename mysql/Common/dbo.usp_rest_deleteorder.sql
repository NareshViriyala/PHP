DROP PROCEDURE IF EXISTS dbo.usp_rest_deleteorder;

DELIMITER $$
CREATE PROCEDURE dbo.usp_rest_deleteorder(
	   _MasterID INT
	 , _GUID NVARCHAR(64)
	 , _DeviceID INT
	 , _Status NVARCHAR(20))
BEGIN
	DECLARE _SubjectID INT;
    SET SQL_SAFE_UPDATES=0;
	IF _GUID REGEXP '^[0-9]+$'
	THEN 
		SET _SubjectID = CAST(_GUID AS UNSIGNED);
	ELSE 
		SELECT SubjectID INTO _SubjectID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = _GUID;
	END IF;
    
    IF _Status IN ('OrderCompleted', 'OrderDeleted')
    THEN
		INSERT INTO dbo.tbl_PushNotification(DeviceUri, DeviceType, PushMessage, DeviceGroup)
		SELECT ud.Uri
			 , ud.DeviceType
			 , CONCAT('{"ScreenName":"FragmentScanQR","Status":"',_Status,'"}')
			 , 'Client'
		  FROM dbo.tbl_mstr_UserDevice ud
          JOIN dbo.tbl_rest_PlacedOrderMaster pom
			ON pom.DeviceID = ud.ID
	     WHERE (pom.ID = _MasterID OR pom.SubjectID = _SubjectID)
           AND ud.Uri IS NOT NULL;
    END IF;
    
    INSERT INTO dbo.tbl_rest_PlacedOrderSlaveArchive(SlaveID, MasterID, TID, Quantity)
    SELECT pos.* 
	  FROM dbo.tbl_rest_PlacedOrderSlave pos
      JOIN dbo.tbl_rest_PlacedOrderMaster pom
        ON pos.MasterID = pom.ID
	 WHERE pom.ID = _MasterID
        OR pom.SubjectID = _SubjectID;
     
    DELETE pos
      FROM dbo.tbl_rest_PlacedOrderSlave pos
      JOIN dbo.tbl_rest_PlacedOrderMaster pom
        ON pos.MasterID = pom.ID
	 WHERE pom.ID = _MasterID
        OR pom.SubjectID = _SubjectID;
    
    INSERT INTO dbo.tbl_rest_PlacedOrderMasterArchive(MasterID, DeviceID, SubjectID, PlacedTime, AckTime, AckBit, CallWaiter, Person)
    SELECT * FROM dbo.tbl_rest_PlacedOrderMaster WHERE ID = _MasterID OR SubjectID = _SubjectID;
    DELETE FROM dbo.tbl_rest_PlacedOrderMaster WHERE ID = _MasterID OR SubjectID = _SubjectID;
    
END$$
DELIMITER ;
#CALL dbo.usp_rest_deleteorder(1, 1,'34', 1, 100);

