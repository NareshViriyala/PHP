USE dbo;
DROP TABLE IF EXISTS dbo.tbl_mstr_UserPersonalInfo;

CREATE TABLE dbo.tbl_mstr_UserPersonalInfo(
	   DeviceID INT PRIMARY KEY
	 , FName NVARCHAR(100) 
	 , MName NVARCHAR(100)
	 , LName NVARCHAR(100)
	 , Email NVARCHAR(50)
	 , Phone NVARCHAR(20)
	 , UpdateDate TIMESTAMP DEFAULT NOW());
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_mstr_UserHomeAddress;

CREATE TABLE dbo.tbl_mstr_UserHomeAddress(
	   DeviceID INT PRIMARY KEY
	 , Add1 NVARCHAR(100) 
	 , Add2 NVARCHAR(100)
	 , LandMark NVARCHAR(100)
	 , City NVARCHAR(50)
	 , State NVARCHAR(50)
	 , Country NVARCHAR(50)
	 , Zip NVARCHAR(10)
	 , UpdateDate TIMESTAMP DEFAULT NOW());	
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_mstr_UserOfficeAddress;

CREATE TABLE dbo.tbl_mstr_UserOfficeAddress(
	   DeviceID INT PRIMARY KEY
	 , Add1 NVARCHAR(100) 
	 , Add2 NVARCHAR(100)
	 , City NVARCHAR(50)
	 , State NVARCHAR(50)
	 , Country NVARCHAR(50)
	 , Zip NVARCHAR(10)
	 , UpdateDate TIMESTAMP DEFAULT NOW());     