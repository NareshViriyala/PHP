USE dbo;
DROP TABLE IF EXISTS dbo.tbl_mstr_VehicleType;

CREATE TABLE tbl_mstr_VehicleType(
	   VehicleTypeID INT PRIMARY KEY
	 , VehicleTypeDesc NVARCHAR(100));
INSERT INTO tbl_mstr_VehicleType
SELECT 2, '2 Wheeler' UNION
SELECT 3, '3 Wheeler' UNION
SELECT 4, '4 Wheeler' UNION
SELECT 0, '0 Wheeler';

/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_mstr_TariffChargeType;

CREATE TABLE tbl_mstr_TariffChargeType(
	   TCTID INT PRIMARY Key AUTO_INCREMENT
	 , ChargeTypeName NVARCHAR(100));
INSERT INTO tbl_mstr_TariffChargeType(ChargeTypeName)
SELECT 'WeekEnd' UNION
SELECT 'PeakTime' UNION
SELECT 'Festival' UNION
SELECT 'Normal';


/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_mstr_TariffPlanTime;

CREATE TABLE tbl_mstr_TariffPlanTime(
       TPID INT	PRIMARY Key AUTO_INCREMENT
	 , EEID INT
	 , VehicleType INT
	 , TCTID INT
	 , MinMinutes INT
	 , MaxMinutes INT
	 , TariffAmount INT);
INSERT INTO tbl_mstr_TariffPlanTime(EEID, VehicleType, TCTID, MinMinutes, MaxMinutes, TariffAmount)
SELECT 3, 2, 2, 0, 120, 20 UNION
SELECT 3, 3, 2, 0, 120, 40 UNION
SELECT 3, 4, 2, 0, 120, 40 UNION
SELECT 3, 2, 2, 121, 240, 40 UNION
SELECT 3, 3, 2, 121, 240, 60 UNION
SELECT 3, 4, 2, 121, 240, 60 UNION
SELECT 3, 2, 2, 241, 9999, 100 UNION
SELECT 3, 3, 2, 241, 9999, 150 UNION
SELECT 3, 4, 2, 241, 9999, 200 UNION

SELECT 1, 2, 2, 0, 120, 20 UNION
SELECT 1, 3, 2, 0, 120, 40 UNION
SELECT 1, 4, 2, 0, 120, 40 UNION
SELECT 1, 2, 2, 121, 240, 40 UNION
SELECT 1, 3, 2, 121, 240, 60 UNION
SELECT 1, 4, 2, 121, 240, 60 UNION
SELECT 1, 2, 2, 241, 9999, 100 UNION
SELECT 1, 3, 2, 241, 9999, 150 UNION
SELECT 1, 4, 2, 241, 9999, 200 UNION
SELECT 2, 2, 2, 0, 120, 20 UNION
SELECT 2, 3, 2, 0, 120, 40 UNION
SELECT 2, 4, 2, 0, 120, 40 UNION
SELECT 2, 2, 2, 121, 240, 40 UNION
SELECT 2, 3, 2, 121, 240, 60 UNION
SELECT 2, 4, 2, 121, 240, 60 UNION
SELECT 2, 2, 2, 241, 9999, 100 UNION
SELECT 2, 3, 2, 241, 9999, 150 UNION
SELECT 2, 4, 2, 241, 9999, 200;
/*
INSERT INTO tbl_mstr_TariffPlanTime
SELECT 1, 2, 2, 0, 120, 20 UNION
SELECT 1, 3, 2, 0, 120, 40 UNION
SELECT 1, 4, 2, 0, 120, 40 UNION
SELECT 1, 2, 2, 121, 240, 40 UNION
SELECT 1, 3, 2, 121, 240, 60 UNION
SELECT 1, 4, 2, 121, 240, 60 UNION
SELECT 1, 2, 2, 241, 9999, 100 UNION
SELECT 1, 3, 2, 241, 9999, 150 UNION
SELECT 1, 4, 2, 241, 9999, 200
*/

/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_mstr_TariffPlanLocation;

CREATE TABLE tbl_mstr_TariffPlanLocation(
       TPID INT	
	 , EEID INT
	 , VehicleType INT
	 , TCTID INT
	 , EntryLocation INT
	 , ExitLocation INT
	 , TariffAmount INT);

/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_mstr_TariffPlanDistance;

CREATE TABLE tbl_mstr_TariffPlanDistance(
       TPID INT	
	 , EEID INT
	 , VehicleType INT
	 , TCTID INT
	 , MinDistance INT
	 , MaxDistance INT
	 , TariffAmount INT);

/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_VehicleEntry;

CREATE TABLE tbl_VehicleEntry(
	   ID INT PRIMARY KEY AUTO_INCREMENT
	 , EEID INT 
	 , EntryLocalDBID INT
	 , ExitLocalDBID INT
	 , EntrySDID NVARCHAR(100)
	 , ExitSDID NVARCHAR(100)
	 , EntryLocalTime DATETIME
	 , ExitLocalTime DATETIME
	 , TCTID INT
     , UDID NVARCHAR(100)
     , VehicleNo NVARCHAR(15)
     , VehicleType INT
     , OverRideData NVARCHAR(2000)
     , EnterDateTime DATETIME
     , ExitDateTime DATETIME);
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
/*
IF TYPE_ID('utt_tbl_UserDeviceParkingID') IS NOT NULL 
DROP TYPE utt_tbl_UserDeviceParkingID

CREATE TYPE utt_tbl_UserDeviceParkingID AS TABLE(ServerID INT PRIMARY KEY)
*/
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
/*
IF TYPE_ID('utt_tbl_VehicleEntry') IS NOT NULL 
DROP TYPE utt_tbl_VehicleEntry

CREATE TYPE utt_tbl_VehicleEntry AS TABLE(
	   ServerID INT
	 , EntityID INT
	 , ServerDeviceID INT	
	 , LocalDBID INT 
	 , LocalTime DATETIME
	 , DeviceID NVARCHAR(100) 
	 , VehicleNo NVARCHAR(20) 
	 , VehicleType INT
	 , TCTID INT
	 , AddType INT
	 , [OverRide] BIT)
*/
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
