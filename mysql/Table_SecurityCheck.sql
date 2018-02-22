/*
DROP TABLE IF EXISTS dbo.tbl_SecurityCheckEntry;

CREATE TABLE dbo.tbl_SecurityCheckEntry(
	   ID INT PRIMARY KEY AUTO_INCREMENT
     , EntityID INT
	 , ServerDeviceID INT
     , LocalDBID INT
	 , DeviceID INT 
     , JSONData NVARCHAR(1000)
     , SystemTime TIMESTAMP DEFAULT NOW());
*/

DROP TABLE IF EXISTS dbo.tbl_SecurityCheckEntry;  

CREATE TABLE dbo.tbl_SecurityCheckEntry(
	   ID INT PRIMARY KEY AUTO_INCREMENT
	 , LocalDBID INT
	 , EntityID INT
	 , ServerDeviceID INT
	 , DeviceID INT
     , Name NVARCHAR(100)
     , Email NVARCHAR(100)
     , Phone NVARCHAR(15)
	 , DOB NVARCHAR(10)
	 , Age NVARCHAR(3)
	 , Sex NVARCHAR(10)
	 , Vehicle NVARCHAR(20)
     , VehicleType INT
	 , ComingFrom NVARCHAR(50)
	 , Purpose NVARCHAR(50)
	 , VisitingCompany NVARCHAR(50)
	 , ContactPerson NVARCHAR(50)
	 , HomeAdd NVARCHAR(500)
	 , OfcAdd NVARCHAR(500)
     , Blok NVARCHAR(100)
     , Flat NVARCHAR(20)
	 , isDeleted BIT
	 , SystemTime TIMESTAMP DEFAULT NOW());

/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_EntitySCEParam;  

CREATE TABLE dbo.tbl_EntitySCEParam(
	   EntityID INT
	 , ParamID INT
     , UNIQUE (EntityID, ParamID));   

INSERT INTO dbo.tbl_EntitySCEParam(EntityID, ParamID)    
SELECT 8, 1 UNION
SELECT 8, 2 UNION
SELECT 8, 3 UNION
SELECT 8, 7 UNION
SELECT 8, 8 UNION
SELECT 8, 10 UNION
SELECT 8, 13 UNION
SELECT 8, 14;

INSERT INTO dbo.tbl_EntitySCEParam(EntityID, ParamID)    
SELECT 9, 1 UNION
SELECT 9, 2 UNION
SELECT 9, 3 UNION
SELECT 9, 4 UNION
SELECT 9, 5 UNION
SELECT 9, 6 UNION
SELECT 9, 7 UNION
SELECT 9, 8 UNION
SELECT 9, 9 UNION
SELECT 9, 10 UNION
SELECT 9, 11 UNION
SELECT 9, 12;
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_EntityUserSCEParam;  

CREATE TABLE dbo.tbl_EntityUserSCEParam(
	   EntityID INT
	 , ParamID INT
     , UserID INT
     , ParamValue NVARCHAR(100)
     , UNIQUE (EntityID, ParamID, UserID));   

#INSERT INTO dbo.tbl_EntityUserSCEParam(EntityID, ParamID, UserID, ParamValue)    

/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/