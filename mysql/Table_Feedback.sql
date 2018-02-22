DROP TABLE IF EXISTS dbo.tbl_fback_autorikshaw;

CREATE TABLE dbo.tbl_fback_autorikshaw(
	   ID INT PRIMARY KEY AUTO_INCREMENT
	 , DriverID INT 
	 , FBDate Date 
	 , FBTime Time
	 , Politeness INT
	 , Driving INT
	 , TrafficRules INT
     , AutoInterior INT
     , AutoFare INT);

INSERT INTO dbo.tbl_fback_autorikshaw(DriverID, FBDate, FBTime, Politeness, Driving, TrafficRules, AutoInterior, AutoFare)
SELECT 11,"2016-06-12","07:55:42",1,5,2,1,1 UNION ALL
SELECT 11,"2016-11-29","05:49:20",1,3,1,4,3 UNION ALL
SELECT 11,"2017-03-01","00:18:15",3,5,3,1,5 UNION ALL
SELECT 11,"2016-02-05","04:01:57",2,5,5,2,2 UNION ALL
SELECT 11,"2016-09-16","00:58:33",3,3,5,4,1 UNION ALL
SELECT 11,"2016-06-16","15:19:26",1,4,2,2,5 UNION ALL
SELECT 11,"2017-01-13","17:22:27",1,5,5,4,4 UNION ALL
SELECT 11,"2016-03-17","02:08:27",1,4,2,2,2 UNION ALL
SELECT 11,"2016-01-13","10:32:08",1,3,5,1,3 UNION ALL
SELECT 11,"2016-02-26","10:44:37",1,3,3,5,3 UNION ALL
SELECT 11,"2016-10-29","10:39:58",2,5,5,2,2 UNION ALL
SELECT 11,"2016-11-20","11:05:35",2,3,2,1,2 UNION ALL
SELECT 11,"2016-07-09","15:13:38",1,3,5,5,1 UNION ALL
SELECT 11,"2016-02-25","10:33:33",1,5,2,1,5 UNION ALL
SELECT 11,"2016-03-30","23:18:23",3,4,5,2,3 UNION ALL
SELECT 11,"2016-02-03","01:41:18",2,4,5,2,5 UNION ALL
SELECT 11,"2016-01-11","09:22:48",2,5,5,1,3 UNION ALL
SELECT 11,"2016-08-28","19:00:54",2,4,5,3,4 UNION ALL
SELECT 11,"2016-09-24","22:31:39",1,5,3,4,1 UNION ALL
SELECT 11,"2016-07-24","12:59:14",3,3,4,4,5 UNION ALL
SELECT 11,"2016-06-07","00:10:47",3,3,1,5,5 UNION ALL
SELECT 11,"2016-03-27","20:14:34",3,3,5,1,4 UNION ALL
SELECT 11,"2016-08-05","20:21:30",2,5,3,5,5 UNION ALL
SELECT 11,"2016-05-24","21:46:54",3,5,4,3,1 UNION ALL
SELECT 11,"2016-01-24","23:14:52",2,4,5,4,5 UNION ALL
SELECT 11,"2016-05-02","19:28:03",2,3,2,3,5 UNION ALL
SELECT 11,"2016-07-09","22:10:14",2,5,2,5,1 UNION ALL
SELECT 11,"2016-06-17","03:57:41",1,4,1,2,5 UNION ALL
SELECT 11,"2016-03-11","03:49:10",1,3,2,5,3 UNION ALL
SELECT 11,"2016-08-09","11:08:31",1,5,1,5,5 UNION ALL
SELECT 11,"2016-01-30","08:59:57",3,4,2,2,5 UNION ALL
SELECT 11,"2016-09-12","01:36:00",1,4,5,4,2 UNION ALL
SELECT 11,"2016-06-02","06:47:15",3,5,2,2,3 UNION ALL
SELECT 11,"2016-10-29","22:17:18",2,4,4,4,4 UNION ALL
SELECT 11,"2017-01-28","16:52:09",3,3,4,2,5 UNION ALL
SELECT 11,"2016-10-28","12:15:30",2,5,1,5,3 UNION ALL
SELECT 11,"2016-12-29","01:36:46",1,5,1,1,5 UNION ALL
SELECT 11,"2016-12-11","17:55:20",2,3,1,3,4 UNION ALL
SELECT 11,"2016-12-11","18:35:35",1,4,4,4,5 UNION ALL
SELECT 11,"2016-02-12","13:37:49",1,5,4,2,5 UNION ALL
SELECT 11,"2016-05-12","19:08:46",2,5,3,1,4 UNION ALL
SELECT 11,"2016-02-10","15:25:58",1,4,2,1,3 UNION ALL
SELECT 11,"2016-11-01","13:46:35",3,3,2,3,1 UNION ALL
SELECT 11,"2016-07-26","09:03:42",2,3,5,2,4 UNION ALL
SELECT 11,"2016-12-30","10:55:40",1,3,2,3,5 UNION ALL
SELECT 11,"2017-01-30","19:51:10",2,4,5,4,2 UNION ALL
SELECT 11,"2017-02-27","17:31:38",2,3,4,2,3 UNION ALL
SELECT 11,"2016-10-18","12:17:27",2,5,4,5,3 UNION ALL
SELECT 11,"2016-04-10","18:42:43",2,5,1,1,3 UNION ALL
SELECT 11,"2016-12-16","20:08:57",2,5,5,5,2 UNION ALL
SELECT 11,"2016-03-18","16:26:09",2,3,4,4,4 UNION ALL
SELECT 11,"2017-01-04","12:09:40",1,4,3,1,4 UNION ALL
SELECT 11,"2017-02-18","12:20:57",2,3,1,1,2 UNION ALL
SELECT 11,"2016-10-05","20:53:00",2,3,4,4,2 UNION ALL
SELECT 11,"2016-02-16","06:52:22",3,4,5,1,1 UNION ALL
SELECT 11,"2016-09-29","02:57:49",1,4,3,2,5 UNION ALL
SELECT 11,"2016-09-16","22:57:01",3,3,5,3,1 UNION ALL
SELECT 11,"2016-03-27","23:51:47",2,4,1,2,3 UNION ALL
SELECT 11,"2016-10-31","23:03:47",2,3,1,1,5 UNION ALL
SELECT 11,"2016-01-14","16:29:11",2,4,1,1,1 UNION ALL
SELECT 11,"2016-07-16","05:33:31",1,3,1,4,2 UNION ALL
SELECT 11,"2016-03-11","08:26:59",1,5,1,1,4 UNION ALL
SELECT 11,"2016-01-21","22:43:09",2,5,2,3,1 UNION ALL
SELECT 11,"2016-09-25","02:15:40",3,5,3,5,4 UNION ALL
SELECT 11,"2016-09-21","03:48:42",3,3,2,4,4 UNION ALL
SELECT 11,"2016-02-12","17:30:25",3,3,4,4,2 UNION ALL
SELECT 11,"2016-03-03","17:41:48",2,3,5,2,4 UNION ALL
SELECT 11,"2016-12-20","09:13:26",3,5,5,3,4 UNION ALL
SELECT 11,"2016-04-16","03:54:43",1,5,5,4,4 UNION ALL
SELECT 11,"2016-02-08","23:15:19",3,3,1,3,4 UNION ALL
SELECT 11,"2016-03-04","05:42:35",3,5,3,4,4 UNION ALL
SELECT 11,"2016-02-12","12:28:03",3,5,1,5,2 UNION ALL
SELECT 11,"2016-10-26","06:18:30",3,4,1,1,3 UNION ALL
SELECT 11,"2016-09-22","01:26:50",3,5,5,5,2 UNION ALL
SELECT 11,"2016-05-08","20:11:38",2,3,4,3,4 UNION ALL
SELECT 11,"2017-02-03","10:53:43",2,5,3,4,1 UNION ALL
SELECT 11,"2016-01-24","01:30:36",2,5,5,3,3 UNION ALL
SELECT 11,"2016-07-04","09:10:40",1,3,3,3,4 UNION ALL
SELECT 11,"2016-01-19","02:02:48",2,5,2,1,2 UNION ALL
SELECT 11,"2016-11-13","13:29:30",2,5,4,5,5 UNION ALL
SELECT 11,"2016-12-05","22:25:24",2,3,3,5,4 UNION ALL
SELECT 11,"2016-09-20","16:18:36",2,5,3,2,4 UNION ALL
SELECT 11,"2016-07-28","11:03:59",1,5,4,2,2 UNION ALL
SELECT 11,"2016-01-08","09:17:43",1,5,3,5,4 UNION ALL
SELECT 11,"2016-06-03","23:51:26",3,5,3,2,5 UNION ALL
SELECT 11,"2016-07-08","09:50:43",1,4,5,1,1 UNION ALL
SELECT 11,"2016-04-30","00:52:48",1,3,5,3,1 UNION ALL
SELECT 11,"2016-05-19","19:14:49",2,4,3,1,2 UNION ALL
SELECT 11,"2016-01-02","21:21:33",1,5,1,4,2 UNION ALL
SELECT 11,"2016-04-07","14:52:03",2,5,4,1,5 UNION ALL
SELECT 11,"2016-07-04","23:19:37",2,5,5,4,3 UNION ALL
SELECT 11,"2016-01-04","11:45:01",3,4,5,2,3 UNION ALL
SELECT 11,"2016-12-26","20:08:35",1,4,1,3,4 UNION ALL
SELECT 11,"2016-02-12","23:06:16",3,5,1,2,5 UNION ALL
SELECT 11,"2016-01-17","17:15:17",1,4,1,3,5 UNION ALL
SELECT 11,"2016-10-18","19:43:52",3,5,2,2,1 UNION ALL
SELECT 11,"2016-09-23","07:19:12",2,3,1,2,5 UNION ALL
SELECT 11,"2016-11-20","14:21:26",1,5,5,2,1 UNION ALL
SELECT 11,"2017-01-25","19:17:36",3,4,3,5,3 UNION ALL
SELECT 11,"2016-06-16","14:38:46",3,5,5,3,3;


SELECT * FROM dbo.tbl_fback_autorikshaw;
/*===============================================================================================================================================
===============================================================================================================================================
===============================================================================================================================================*/