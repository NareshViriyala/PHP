DROP PROCEDURE IF EXISTS dbo.usp_rest_PlaceOrder;

DELIMITER $$
CREATE PROCEDURE dbo.usp_rest_PlaceOrder(
       _DeviceID INT
     , _SubjectID NVARCHAR(64)
     , _xml_OrderItem TEXT
     , _DeviceType TINYINT #1 = Client, 2 = Server
     , _PersonName NVARCHAR(100))
BEGIN
	DECLARE _ID INT;
    DECLARE _MasterID INT;
    DECLARE itemCount INT DEFAULT ExtractValue(_xml_OrderItem, 'count(//TID)');
    DECLARE i INT DEFAULT 1;
    
    IF(_PersonName = 'Login') THEN
		SET _PersonName = '';
    END IF;
    
    IF _SubjectID REGEXP '^[0-9]+$'
    THEN 
		SET _ID = CAST(_SubjectID AS UNSIGNED);
    ELSE 
		SELECT SubjectID INTO _ID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = _SubjectID;
    END IF;
	
	SELECT ID INTO _MasterID FROM dbo.tbl_rest_PlacedOrderMaster WHERE DeviceID = _DeviceID AND SubjectID = _ID;
    
    IF _MasterID = 0 OR _MasterID IS NULL
    THEN
		INSERT INTO dbo.tbl_rest_PlacedOrderMaster(DeviceID, SubjectID, Person)
        SELECT _DeviceID, _ID, _PersonName;
        
        SET _MasterID = LAST_INSERT_ID();
	ELSE
		 
		UPDATE dbo.tbl_rest_PlacedOrderMaster
           SET PlacedTime = NOW()
 			 , AckTime = NULL
			 , AckBit = 0
             , Person = _PersonName
 		 WHERE ID = _MasterID;
          
    END IF;
    SET SQL_SAFE_UPDATES=0;
    DELETE FROM dbo.tbl_rest_PlacedOrderSlave WHERE MasterID = _MasterID;
    SET SQL_SAFE_UPDATES=1;
              
   WHILE i <= itemCount DO
		INSERT INTO dbo.tbl_rest_PlacedOrderSlave(MasterID, TID, Quantity)
        SELECT _MasterID
			 , ExtractValue(_xml_OrderItem, '//TID[$i]') AS TID
			 , ExtractValue(_xml_OrderItem, '//QTY[$i]') AS QTY; 
		SET i = i + 1;
   END WHILE;
   
   INSERT INTO dbo.tbl_PushNotification(DeviceUri, DeviceType, PushMessage, DeviceGroup)
   SELECT DISTINCT sd.Uri, sd.DeviceType
		, CONCAT('{"MasterID":',_MasterID,',"ScreenName":"ActivityTables","Status":"Order Placed","guid":"',es.SubjectGuid,'"}')
		, 'Server'
     FROM dbo.tbl_mstr_EntitySubject es
     JOIN dbo.tbl_mstr_ServerDeviceEntityMap sdem
       ON es.EntityID = sdem.EEID
     JOIN dbo.tbl_mstr_ServerDevice sd
       ON sd.ID = sdem.ServerDeviceID
    WHERE es.SubjectID = _ID
      AND sd.Uri IS NOT NULL;
      
	SELECT _MasterID AS MasterID;
END$$
DELIMITER ;

#CALL dbo.usp_rest_PlaceOrder('1','5B0A3D65-BA4C-4312-9910-0F13D994513D','<order><TID>2</TID><QTY>1</QTY><TID>24</TID><QTY>2</QTY></order>',2);
