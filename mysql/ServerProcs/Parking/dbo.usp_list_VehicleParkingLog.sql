DROP PROCEDURE IF EXISTS dbo.usp_list_VehicleParkingLog;

DELIMITER $$
CREATE PROCEDURE dbo.usp_list_VehicleParkingLog(
	   _EntityID INT
	 , _DeviceID INT
	 , _VehicleNo NVARCHAR(20)
	 , _PageNumber INT
	 , _PageCount INT)
BEGIN
	SET @OID := 0;
    SELECT *
      FROM (SELECT ve.ID
				 , ve.EEID
				 , ve.EntryLocalDBID
				 , ve.ExitLocalDBID
				 , ve.EntrySDID
				 , ve.ExitSDID
				 , IFNULL(ve.EntryLocalTime, '') AS LITime
				 , IFNULL(ve.ExitLocalTime, '') AS LOTime
				 , ve.TCTID
				 , ve.VehicleNo AS VNo
				 , ve.VehicleType AS VType
				 , IFNULL(ve.EnterDateTime, '') AS SITime
				 , IFNULL(ve.ExitDateTime, '') AS SOTime
				 , CONCAT(TIMESTAMPDIFF(HOUR, ve.EntryLocalTime, IFNULL(ve.ExitLocalTime, NOW())) ,' Hr ',TIMESTAMPDIFF(MINUTE, ve.EntryLocalTime, IFNULL(ve.ExitLocalTime, NOW()))%60 , ' Mins') AS LParkTime
				 , CONCAT(TIMESTAMPDIFF(HOUR, ve.EnterDateTime, IFNULL(ve.ExitDateTime, NOW())) ,' Hr ',TIMESTAMPDIFF(MINUTE, ve.EnterDateTime, IFNULL(ve.ExitDateTime, NOW()))%60 , ' Mins') AS SParkTime
				 , tp.TariffAmount
				 , @OID := @OID + 1 AS OID
			  FROM dbo.tbl_VehicleEntry ve
			  LEFT JOIN dbo.tbl_mstr_TariffPlanTime tp
				ON ve.EEID = tp.EEID
			   AND ve.TCTID = tp.TCTID
			   AND ve.VehicleType = tp.VehicleType
			   AND TIMESTAMPDIFF(MINUTE, ve.EnterDateTime, IFNULL(ve.ExitDateTime, NOW())) BETWEEN tp.MinMinutes AND tp.MaxMinutes 
			 WHERE ve.EEID = _EntityID
			   AND ((NULLIF(_VehicleNo,'') IS NULL) OR (REPLACE(ve.VehicleNo, ' ','') LIKE CONCAT('%',REPLACE(_VehicleNo,' ',''),'%')))
			 ORDER BY IFNULL(ve.ExitDateTime, ve.EnterDateTime) DESC) AS tbl_final
	 WHERE tbl_final.OID BETWEEN ((_PageNumber-1) * _PageCount + 1)	
       AND (_PageNumber * _PageCount)
     ORDER BY tbl_final.OID DESC;

END$$
DELIMITER ;
#CALL dbo.usp_list_VehicleParkingLog(1, 1,'34', 1, 100);

