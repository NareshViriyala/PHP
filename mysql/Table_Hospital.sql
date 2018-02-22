USE dbo;
DROP TABLE IF EXISTS dbo.tbl_hosp_DoctorAppointment;

CREATE TABLE dbo.tbl_hosp_DoctorAppointment(
	   ID INT PRIMARY KEY AUTO_INCREMENT
	 , SubjectID INT
	 , PatientName NVARCHAR(200)
	 , AgeYear TINYINT
	 , AgeMonth TINYINT
	 , Gender BIT
	 , PatientDeviceID INT
	 , ApptTime TIMESTAMP DEFAULT NOW()
	 , InTime DATETIME 
	 , OutTime DATETIME
	 , UserCancelled BIT DEFAULT 0
	 , DocCancelled BIT DEFAULT 0
	 , CallDeviceID INT
     , PatientPhone NVARCHAR(20));
 
/*
INSERT INTO  dbo.tbl_hosp_DoctorAppointment (SubjectID, PatientName, AgeYear, AgeMonth, Gender, PatientDeviceID)
SELECT 4, 'Naresh', 34, 8, 1, 1 UNION
SELECT 5, 'Bharat', 33, 0, 1, 2 UNION
SELECT 4, 'Laharika', 28, 3, 0, 3 UNION
SELECT 4, 'Janaki', 32, 12, 0, 4 UNION
SELECT 5, 'Bharathi', 26, 10, 0, 5 UNION
SELECT 4, 'Dasaradhi', 28, 8, 1, 6 UNION
SELECT 5, 'Rama Mani', 52, 1, 0, 7 UNION
SELECT 5, 'Kanthamma', 85, 6, 0, 8;

SELECT * FROM tbl_hosp_DoctorAppointment;
*/


