DROP TABLE IF EXISTS dbo.tbl_mstr_EstablishmentEntity;

CREATE TABLE tbl_mstr_EstablishmentEntity(
	   EEID INT PRIMARY Key AUTO_INCREMENT
	 , EEName NVARCHAR(200)
	 , AddressLine1 NVARCHAR(200)
	 , AddressLine2 NVARCHAR(200)
	 , City NVARCHAR(100)
	 , State NVARCHAR(100)
	 , Country NVARCHAR(100)
	 , Zip NVARCHAR(15)
	 , ContactNo1 NVARCHAR(20)
	 , ContactNo2 NVARCHAR(20)
	 , EmailID NVARCHAR(50)
	 , WebSite NVARCHAR(200)
	 , Latitude FLOAT
	 , Longitude FLOAT
	 , Image NVARCHAR(50)
	 , PermittedDist INT);
INSERT INTO dbo.tbl_mstr_EstablishmentEntity(EEName, AddressLine1, AddressLine2, City, State, Country, Zip, ContactNo1, ContactNo2, EmailID, WebSite, Latitude, Longitude, Image, PermittedDist)
SELECT 'Forum Sujana Mall', 'Plot No. S-16, Survey No. 1009', 'Opposite Malaysian Township, KPHB - 6th Phase', 'Hyderabad', 'Telangana', 'India', '500072', '04030534053', '', 'Test@gmail.com', 'www.SujanaMall.com', 17.484131, 78.388964, 'sujana01.jpg', 5000;
INSERT INTO dbo.tbl_mstr_EstablishmentEntity(EEName, AddressLine1, AddressLine2, City, State, Country, Zip, ContactNo1, ContactNo2, EmailID, WebSite, Latitude, Longitude, Image, PermittedDist)
SELECT 'Paradise Food Court', 'Shilpakalavedika Compound,', 'Hitec City', 'Hyderabad', 'Telangana', 'India', '500081', '04066661199', '', 'Test@gmail.com', 'www.paradisefoodcourt.com', 17.450498, 78.379022, 'paradise02.jpg', 5000;
INSERT INTO dbo.tbl_mstr_EstablishmentEntity(EEName, AddressLine1, AddressLine2, City, State, Country, Zip, ContactNo1, ContactNo2, EmailID, WebSite, Latitude, Longitude, Image, PermittedDist)
SELECT 'Apollo Hospitals', 'Jubilee Hills', '', 'Hyderabad', 'Telangana', 'India', '500033', '04023607777', '04023605555', 'info@apollohospitals.com', 'https://www.apollohospitals.com', 17.414915, 78.412390, 'apollo03.jpg', 5000;
INSERT INTO dbo.tbl_mstr_EstablishmentEntity(EEName, AddressLine1, AddressLine2, City, State, Country, Zip, ContactNo1, ContactNo2, EmailID, WebSite, Latitude, Longitude, Image, PermittedDist)
SELECT 'Axis Bank', '63879/B, G Pullareddy Building', 'Greenlands, Begumpet Road', 'Hyderabad', 'Telangana', 'India', '500016', '18001035577', '', 'info@axisbank.com', 'https://www.axisbank.com', 17.418185, 78.409728, NULL, 5000;
INSERT INTO dbo.tbl_mstr_EstablishmentEntity(EEName, AddressLine1, AddressLine2, City, State, Country, Zip, ContactNo1, ContactNo2, EmailID, WebSite, Latitude, Longitude, Image, PermittedDist)
SELECT 'Cream Stone', 'Bullet King Commercial Complex, Plot 15/1', 'Opposite Cyber Gateway, HITEC City', 'Hyderabad', 'Telangana', 'India', '500081', '040 6559 9920', '', '', '', 17.445496, 78.377676, 'creamstone05.jpg', 5000;
INSERT INTO dbo.tbl_mstr_EstablishmentEntity(EEName, AddressLine1, AddressLine2, City, State, Country, Zip, ContactNo1, ContactNo2, EmailID, WebSite, Latitude, Longitude, Image, PermittedDist)
SELECT 'Malaysian Township', 'Rain Tree Park', 'Near Sujana forum mall', 'Hyderabad', 'Telangana', 'India', '500072', '040 6688 0000', '', '', '', 17.445496, 78.377676, 'rtp06.jpg', 5000;
INSERT INTO dbo.tbl_mstr_EstablishmentEntity(EEName, AddressLine1, AddressLine2, City, State, Country, Zip, ContactNo1, ContactNo2, EmailID, WebSite, Latitude, Longitude, Image, PermittedDist)
SELECT 'Incor society', NULL , 'Near Malaysian township', 'Hyderabad', 'Telangana', 'India', '500072', '040 6666 8888', '', 'rajan.a@incor.com', 'http://www.incor.in/', 17.445496, 78.377676, 'incor09.jpg', 5000;

-- select * from dbo.tbl_mstr_EstablishmentEntity; 
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_mstr_EntitySubject;

CREATE TABLE dbo.tbl_mstr_EntitySubject(
	   SubjectID INT PRIMARY KEY AUTO_INCREMENT
	 , SubjectGuid NVARCHAR(64) NOT NULL 
	 , EntityID INT 
	 , ServerDeviceID INT
	 , EntityType NVARCHAR(50)
	 , SubjectType NVARCHAR(50)
	 , SubjectInfo NVARCHAR(50)
	 , UpdateDate TIMESTAMP DEFAULT NOW());

INSERT INTO dbo.tbl_mstr_EntitySubject(SubjectGuid, EntityID, EntityType, SubjectType, SubjectInfo)
SELECT '4634D4A0-DBEB-4E98-939D-7F107B7E1CDA', 1, 'Parking', 'Parking', '' UNION ALL
SELECT '5B0A3D65-BA4C-4312-9910-0F13D994513D', 2, 'Restaurant', 'Table', 'Table01'  UNION ALL
SELECT '49F2F5AB-15AC-47C9-99B0-FC3CDBDF946B', 2, 'Restaurant', 'Table', 'Table02'  UNION ALL
SELECT '2968491D-75BB-4C48-8F16-E789EE44860E', 3, 'Hospital', 'Doctor', ''  UNION ALL
SELECT 'D1ACE192-0BED-4311-BA62-F49DEA2C66F8', 3, 'Hospital', 'Doctor', ''  UNION ALL
SELECT '5497F884-796F-4845-8FA4-DE52278C696F', 4, 'Bank', 'Counter', 'Counter01'  UNION ALL
SELECT '9B666237-3210-4ED9-9075-C7338191E8EC', 5, 'Restaurant', 'Table', 'Table02' UNION ALL
SELECT 'D0162440-7129-11E6-9022-00155DA81418', 6, 'SecurityCheck', 'Society', 'Gated Community' UNION ALL
SELECT '4EE9DAD4-847E-11E6-B066-082E5F24C5B1', 7, 'SecurityCheck', 'Society', 'Gated Community' UNION ALL 
SELECT 'c26d03c9-f5a6-11e6-9885-b46d833ff56b', 2, 'CustomerFeedback', 'Restaurant', 'Table' UNION ALL
SELECT 'a3c21bd6-fe49-11e6-99c4-082e5f24c5b1', -1, 'CustomerFeedback', 'AutoRikshaw', '' ;
#SELECT * FROM tbl_mstr_EntitySubject;
#SELECT uuid();


/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_mstr_BusinessHour;

CREATE TABLE dbo.tbl_mstr_BusinessHour(
	   EntityID INT 
	 , SubjectID INT
	 , Day NVARCHAR(10)
	 , BusinessHours NVARCHAR(50)
	 , UpdateDate TIMESTAMP DEFAULT NOW());
CREATE INDEX CIX_tbl_mstr_BusinessHour ON dbo.tbl_mstr_BusinessHour(EntityID);
CREATE INDEX NCIX_tbl_mstr_BusinessHour ON dbo.tbl_mstr_BusinessHour(SubjectID);

INSERT INTO dbo.tbl_mstr_BusinessHour(EntityID, SubjectID, Day, BusinessHours)
SELECT 1, NULL, 'Mon', '10AM - 10PM' UNION ALL
SELECT 1, NULL, 'Tue', '10AM - 10PM' UNION ALL
SELECT 1, NULL, 'Wed', '10AM - 10PM' UNION ALL
SELECT 1, NULL, 'Thu', '10AM - 10PM' UNION ALL
SELECT 1, NULL, 'Fri', '10AM - 10PM' UNION ALL
SELECT 1, NULL, 'Sat', '10AM - 10PM' UNION ALL
SELECT 1, NULL, 'Sun', '10AM - 10PM' UNION ALL

SELECT 2, NULL, 'Mon', '10AM - 10PM' UNION ALL
SELECT 2, NULL, 'Tue', '10AM - 10PM' UNION ALL
SELECT 2, NULL, 'Wed', '10AM - 10PM' UNION ALL
SELECT 2, NULL, 'Thu', '10AM - 10PM' UNION ALL
SELECT 2, NULL, 'Fri', '10AM - 10PM' UNION ALL
SELECT 2, NULL, 'Sat', '10AM - 10PM' UNION ALL

SELECT 3, 4, 'Mon', '10AM - 1:30PM' UNION ALL
SELECT 3, 4, 'Tue', '10AM - 4PM' UNION ALL
SELECT 3, 4, 'Fri', '9AM - 2PM' UNION ALL
SELECT 3, 5, 'Sun', '9AM - 12PM' UNION ALL
SELECT 3, 5, 'Mon', '9AM - 12PM   3PM - 8PM' UNION ALL
SELECT 3, 5, 'Wed', '9AM - 12PM   3PM - 8PM' UNION ALL
SELECT 3, 5, 'Sat', '2PM - 7PM' UNION ALL

SELECT 4, NULL, 'Mon', '8AM - 3PM' UNION ALL
SELECT 4, NULL, 'Tue', '8AM - 3PM' UNION ALL
SELECT 4, NULL, 'Wed', '8AM - 3PM' UNION ALL
SELECT 4, NULL, 'Thu', '8AM - 3PM' UNION ALL
SELECT 4, NULL, 'Fri', '8AM - 3PM' UNION ALL
SELECT 4, NULL, 'Sat', '9AM - 12PM' UNION ALL

SELECT 5, NULL, 'Mon', '11AM - 12AM' UNION ALL
SELECT 5, NULL, 'Tue', '11AM - 12AM' UNION ALL
SELECT 5, NULL, 'Wed', '11AM - 12AM' UNION ALL
SELECT 5, NULL, 'Thu', '11AM - 12AM' UNION ALL
SELECT 5, NULL, 'Fri', '11AM - 12AM' UNION ALL
SELECT 5, NULL, 'Sat', '12AM - 12AM' UNION ALL
SELECT 5, NULL, 'Sun', '11AM - 12AM';

/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_mstr_SubjectDetail;

CREATE TABLE dbo.tbl_mstr_SubjectDetail(
	   SubjectID INT PRIMARY KEY
	 , Name NVARCHAR(100)
	 , Degree NVARCHAR(100)
	 , Specialty NVARCHAR(100)
	 , ConsultationFee INT
	 , AvgConsultationTime INT
	 , Mobile NVARCHAR(20)
	 , Work NVARCHAR(20)
	 , Email NVARCHAR(50)
	 , Image NVARCHAR(50)
	 , UpdateDate TIMESTAMP DEFAULT NOW());

INSERT INTO dbo.tbl_mstr_SubjectDetail(SubjectID, Name, Degree, Specialty, ConsultationFee, AvgConsultationTime, Mobile, Work, Email, Image)
SELECT 4, 'Dr.Pratyusha', 'MBBS FRCS', 'Ortho', 200, 14, NULL, '04066883498', 'pratyusha@gmail.com', 'MomPic4.jpg'  UNION
SELECT 5, 'Dr.Raghava Dutt', 'MBBS FRCS', 'Cardiology', 450, 20, NULL, '0402727921', NULL, 'Kanthamma5.jpg' UNION
SELECT 11, 'Hari', 'AP 28 CL 6824', '', 0, 0, '9888884444', NULL, NULL, 'Kanthamma5.jpg';

/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_mstr_RestaurantTaxType;

CREATE TABLE dbo.tbl_mstr_RestaurantTaxType(
	   EntityID INT 
	 , OID INT
	 , TaxName NVARCHAR(100)
	 , TaxPercentage FLOAT
	 , UpdateDate TIMESTAMP DEFAULT NOW());
CREATE INDEX CIX_tbl_mstr_RestaurantTaxType ON dbo.tbl_mstr_RestaurantTaxType(EntityID);

INSERT INTO dbo.tbl_mstr_RestaurantTaxType(EntityID, OID, TaxName, TaxPercentage)
SELECT 2, 1, 'Sub Total', 100  UNION
SELECT 2, 2, 'Service Tax', 4.94 UNION
SELECT 2, 3, 'Vat Tax', 5 UNION
SELECT 2, 4, 'Swachh Bharat Cess', 0.5 UNION
SELECT 2, 5, 'Krishi Kalyan Cess', 0.5; 

INSERT INTO dbo.tbl_mstr_RestaurantTaxType(EntityID, OID, TaxName, TaxPercentage)
SELECT 5, 1, 'Sub Total', 100  UNION
SELECT 5, 2, 'Service Charge', 5  UNION
SELECT 5, 3, 'Service Tax', 4.94 UNION
SELECT 5, 4, 'Vat Tax', 5 UNION
SELECT 5, 5, 'Swachh Bharat Cess', 0.5 UNION
SELECT 5, 6, 'Krishi Kalyan Cess', 0.5; 
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/
DROP TABLE IF EXISTS dbo.tbl_mstr_SecurityCheckParameter;

CREATE TABLE dbo.tbl_mstr_SecurityCheckParameter(
	   ID INT PRIMARY Key AUTO_INCREMENT
	 , ParamID INT
	 , ParamType NVARCHAR(100)
	 , UpdateDate TIMESTAMP DEFAULT NOW());

INSERT INTO dbo.tbl_mstr_SecurityCheckParameter(ParamID, ParamType)
SELECT 1, 'Name'  UNION
SELECT 2, 'Email' UNION
SELECT 3, 'Phone' UNION
SELECT 4, 'Date of Birth' UNION
SELECT 5, 'Age' UNION 
SELECT 6, 'Gender' UNION
SELECT 7, 'Vehicle No' UNION
SELECT 8, 'Vehicle Type' UNION
SELECT 9, 'Coming from' UNION
SELECT 10, 'Purpose of visit' UNION
SELECT 11, 'Visiting Company' UNION
SELECT 12, 'Meeting person' UNION
SELECT 13, 'Block' UNION 
SELECT 14, 'Flat' ; 

/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/

DROP TABLE IF EXISTS dbo.tbl_user_entityfeedback;

CREATE TABLE dbo.tbl_user_entityfeedback(
	   ID INT PRIMARY Key AUTO_INCREMENT
	 , UserID INT
     , EntityID INT
	 , Feedback NVARCHAR(2000)
	 , UpdateDate TIMESTAMP DEFAULT NOW());

/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/


