DROP PROCEDURE IF EXISTS dbo.usp_get_ServerDeviceEntityList;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_ServerDeviceEntityList(_DeviceID INT, _EntityType NVARCHAR(50))
BEGIN
   SELECT ee.EEID
		, EEName AS Ename
	    , AddressLine1 AS Add1
	    , AddressLine2 AS Add2
	    , City
	    , State
	    , Country
	    , Zip
	    , ContactNo1
	    , ContactNo2
	    , EmailID
	    , WebSite
	    , Latitude AS Lat
	    , Longitude AS 'Long'
	    , PermittedDist AS PD
     FROM dbo.tbl_mstr_EstablishmentEntity ee
     JOIN (SELECT DISTINCT EEID 
			 FROM dbo.tbl_mstr_ServerDeviceEntityMap sdem
			 JOIN dbo.tbl_mstr_EntitySubject es
			   ON sdem.EEID = es.EntityID
			WHERE (sdem.ServerDeviceID = _DeviceID OR _DeviceID = 0 OR _DeviceID IS NULL)
			  AND (es.EntityType = _EntityType OR _EntityType = '' OR _EntityType IS NULL)) AS sdem
       ON ee.EEID = sdem.EEID;

END$$
DELIMITER ;

#CALL dbo.usp_get_ServerDeviceEntityList(NULL, "HOSPITAL");

