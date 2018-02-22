DROP PROCEDURE IF EXISTS dbo.usp_rest_CallWaiter;

DELIMITER $$
CREATE PROCEDURE dbo.usp_rest_CallWaiter(
	   _MasterID INT
	 , _input NVARCHAR(64))
BEGIN
	
    DECLARE _SubjectID INT;
	IF _input REGEXP '^[0-9]+$'
    THEN 
		SET _SubjectID = CAST(_input AS UNSIGNED);
	ELSE
		SELECT SubjectID INTO _SubjectID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = _input;
    END IF;
    
    UPDATE dbo.tbl_rest_PlacedOrderMaster
      SET CallWaiter = 0
    WHERE ID = _MasterID;
    
   INSERT INTO dbo.tbl_PushNotification(DeviceUri, DeviceType, PushMessage, DeviceGroup)
   SELECT DISTINCT sd.Uri, sd.DeviceType
		, CONCAT('{"MasterID":',_MasterID,',"ScreenName":"ActivityTables","Status":"Call","guid":"',es.SubjectGuid,'"}')
		, 'Server'
     FROM dbo.tbl_mstr_EntitySubject es
     JOIN dbo.tbl_mstr_ServerDeviceEntityMap sdem
       ON es.EntityID = sdem.EEID
     JOIN dbo.tbl_mstr_ServerDevice sd
       ON sd.ID = sdem.ServerDeviceID
    WHERE es.SubjectID = _SubjectID
      AND sd.Uri IS NOT NULL;

END$$
DELIMITER ;

#CALL dbo.usp_rest_CallWaiter(1,'2');