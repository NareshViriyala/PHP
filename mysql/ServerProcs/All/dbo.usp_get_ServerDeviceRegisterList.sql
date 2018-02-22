DROP PROCEDURE IF EXISTS dbo.usp_get_ServerDeviceRegisterList;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_ServerDeviceRegisterList(_DeviceID INT)
BEGIN
   SELECT DISTINCT es.EntityType 
     FROM dbo.tbl_mstr_ServerDeviceEntityMap sdem
     JOIN dbo.tbl_mstr_EstablishmentEntity ee
       ON sdem.EEID = ee.EEID
     JOIN dbo.tbl_mstr_EntitySubject es 
       ON ee.EEID = es.EntityID
    WHERE sdem.ServerDeviceID = _DeviceID;
END$$
DELIMITER ;

#CALL dbo.usp_get_ServerDeviceRegisterList(NULL, "HOSPITAL");

