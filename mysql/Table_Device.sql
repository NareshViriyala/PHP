DROP TABLE IF EXISTS dbo.tbl_mstr_GroupDevice;

CREATE TABLE dbo.tbl_mstr_GroupDevice(ID INT, UpdateDate DATETIME);

INSERT INTO dbo.tbl_mstr_GroupDevice
SELECT 0, now();

/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_mstr_UserDevice;

CREATE TABLE dbo.tbl_mstr_UserDevice(
	   ID INT PRIMARY KEY
	 , DeviceID NVARCHAR(100) 
	 , Uri NVARCHAR(500)
	 , DeviceType NVARCHAR(100)
	 , DeviceVersion NVARCHAR(50)
	 , AppVersion NVARCHAR(50)
	 , InsertDate DATETIME
	 , UpdateDate DATETIME
	 , CONSTRAINT uk_tbl_mstr_UserDevice_DeviceID UNIQUE (DeviceID)
);

/*
INSERT INTO dbo.tbl_mstr_UserDevice(ID, DeviceID, Uri, DeviceType, DeviceVersion, AppVersion)
SELECT 2, '4487f100306536ce', 'fccDYYqAboM:APA91bFvEbDQEAkDx4EeSH0X8rZm5y17X715v4rsIkP2KTF_46LLQ6l3TZ-u7Rny7Y6RCw0enPGwXzRqZRXkrq7nOhfn55XUsAtcDwQMJ7DRUKI6OIDf9cgwZDkcW_PuPd0HHcYcADgC', 'Android', '4.2.2', '1.0.0.0' UNION
SELECT 3, 'c684f882fe110bed', 'fDFokAsZQYI:APA91bFBdH4d13Kn5vE3ogiZXVzqa9acfHGbLkl0fwVbo3iHhtdRl8vAj0z_oLQ-YZtoQeGrxrgjOtsV1GeMqqXtzm7Bq2jmVZ7nbyowJDDETUluGeG3HGGRZ_FV_vNzwPYaKXBkgZeY', 'Android', '4.2.2', '1.0.0.0' UNION
SELECT 4, 'DummyDevice1', '', 'Android', '4.2.2', '1.0.0.0' UNION
SELECT 5, 'DummyDevice2', '', 'Android', '4.2.2', '1.0.0.0' UNION
SELECT 6, 'DummyDevice3', '', 'Android', '4.2.2', '1.0.0.0' UNION
SELECT 7, 'DummyDevice4', '', 'Android', '4.2.2', '1.0.0.0' UNION
SELECT 8, 'DummyDevice5', '', 'Android', '4.2.2', '1.0.0.0' UNION
SELECT 9, 'DummyDevice6', '', 'Android', '4.2.2', '1.0.0.0' UNION
SELECT 10, 'DummyDevice7', '', 'Android', '4.2.2', '1.0.0.0' UNION
SELECT 11, 'DummyDevice8', '', 'Android', '4.2.2', '1.0.0.0'; 
*/
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_WebAPIErrorLog;

CREATE TABLE dbo.tbl_WebAPIErrorLog(
	   ID INT PRIMARY KEY AUTO_INCREMENT
     , ControllerName NVARCHAR(100)
     , MethodName NVARCHAR(100)
     , ExceptionType NVARCHAR(100)
	 , JsonString NVARCHAR(2000)
	 , ErrorMsg NVARCHAR(2000)
	 , OcrDate DATETIME);
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_mstr_ServerDevice;

CREATE TABLE dbo.tbl_mstr_ServerDevice(
	   ID INT PRIMARY KEY
	 , DeviceID NVARCHAR(100)
     , Uri NVARCHAR(500)
	 , DeviceType NVARCHAR(100)
	 , DeviceVersion NVARCHAR(50)
	 , AppVersion NVARCHAR(50)
	 , InsertDate DATETIME
	 , UpdateDate DATETIME
	 , CONSTRAINT uk_tbl_mstr_ServerDevice_DeviceID UNIQUE (DeviceID));
     
/*
INSERT INTO dbo.tbl_mstr_ServerDevice(ID, DeviceID, Uri, DeviceType, DeviceVersion, AppVersion)
SELECT 1, '4487f100306536ce', 'fccDYYqAboM:APA91bFvEbDQEAkDx4EeSH0X8rZm5y17X715v4rsIkP2KTF_46LLQ6l3TZ-u7Rny7Y6RCw0enPGwXzRqZRXkrq7nOhfn55XUsAtcDwQMJ7DRUKI6OIDf9cgwZDkcW_PuPd0HHcYcADgC', 'Android', '4.2.2', '1.0.0.0' UNION
SELECT 12, 'c684f882fe110bed', 'fDFokAsZQYI:APA91bFBdH4d13Kn5vE3ogiZXVzqa9acfHGbLkl0fwVbo3iHhtdRl8vAj0z_oLQ-YZtoQeGrxrgjOtsV1GeMqqXtzm7Bq2jmVZ7nbyowJDDETUluGeG3HGGRZ_FV_vNzwPYaKXBkgZeY', 'Android', '4.2.2', '1.0.0.0';
*/     
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_mstr_ServerDeviceEntityMap;

CREATE TABLE dbo.tbl_mstr_ServerDeviceEntityMap(
	   ID INT PRIMARY KEY AUTO_INCREMENT
	 , ServerDeviceID INT
	 , EEID INT
	 , SubjectID INT
	 , IsActive BIT DEFAULT 1);
INSERT INTO dbo.tbl_mstr_ServerDeviceEntityMap(ServerDeviceID, EEID, SubjectID, IsActive)
SELECT 1, 3, 4, 1 UNION 
SELECT 1, 3, 5, 1 UNION
SELECT 1, 2, NULL, 1 UNION
SELECT 1, 5, NULL, 1 UNION
SELECT 1, 6, NULL, 1 UNION
SELECT 1, 1, NULL, 1 ;
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_ServerDeviceErrorLog;

CREATE TABLE tbl_ServerDeviceErrorLog(
	   ID INT PRIMARY KEY AUTO_INCREMENT
	 , DeviceID INT
     , PageName NVARCHAR(100)
     , MethodName NVARCHAR(100)
     , ExceptionType NVARCHAR(100)
	 , ExceptionText NVARCHAR(2000)
	 , OcrDate NVARCHAR(50)
	 , SystemTime TIMESTAMP DEFAULT NOW());
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/     
DROP TABLE IF EXISTS dbo.tbl_UserDeviceErrorLog;

CREATE TABLE dbo.tbl_UserDeviceErrorLog(
	   ID INT PRIMARY KEY AUTO_INCREMENT
	 , DeviceID INT
     , PageName NVARCHAR(100)
     , MethodName NVARCHAR(100)
     , ExceptionType NVARCHAR(100)
	 , ExceptionText NVARCHAR(2000)
	 , OcrDate NVARCHAR(50)
	 , SystemTime TIMESTAMP DEFAULT NOW());
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/ 
DROP TABLE IF EXISTS dbo.tbl_PushNotification;

CREATE TABLE dbo.tbl_PushNotification(
	   ID INT PRIMARY KEY AUTO_INCREMENT
	 , DeviceUri NVARCHAR(1000)
     , DeviceType NVARCHAR(100)
     , PushMessage NVARCHAR(2000)
     , DeviceGroup NVARCHAR(100)
     , InTime TIMESTAMP DEFAULT NOW()
	 , PushTime DATETIME);
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/  
/*
IF TYPE_ID('utt_tbl_ServerDeviceErrorLog') IS NOT NULL 
DROP TYPE utt_tbl_ServerDeviceErrorLog

CREATE TYPE utt_tbl_ServerDeviceErrorLog AS TABLE(
       PageName NVARCHAR(100)
     , MethodName NVARCHAR(100)
     , ExceptionType NVARCHAR(100)
	 , ExceptionText NVARCHAR(2000)
	 , OcrDate NVARCHAR(50)
)    
*/
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/  
/*
IF TYPE_ID('utt_tbl_UserDeviceErrorLog') IS NOT NULL 
DROP TYPE utt_tbl_UserDeviceErrorLog

CREATE TYPE utt_tbl_UserDeviceErrorLog AS TABLE(
	   PageName NVARCHAR(100)
     , MethodName NVARCHAR(100)
     , ExceptionType NVARCHAR(100)
	 , ExceptionText NVARCHAR(2000)
	 , OcrDate NVARCHAR(50))
*/     




























