DROP PROCEDURE IF EXISTS dbo.usp_get_AutoDriverFeedback;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_AutoDriverFeedback(input NVARCHAR(64), gettype NVARCHAR(10))
BEGIN

	DECLARE ID INT;
    IF input REGEXP '^[0-9]+$'
    THEN 
		SET ID = CAST(input AS UNSIGNED);
    ELSE 
		SELECT SubjectID INTO ID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = input;
    END IF;

   IF(gettype = 'Average')
   THEN
	   SELECT ROUND(AVG(Politeness),0) AS Politeness
			, ROUND(AVG(Driving),0) AS Driving
			, ROUND(AVG(TrafficRules),0) AS TrafficRules
			, ROUND(AVG(AutoInterior),0) AS AutoInterior
			, ROUND(AVG(AutoFare),0) AS AutoFare
		 FROM dbo.tbl_fback_autorikshaw
		WHERE DriverID = ID
		GROUP BY DriverID;
    ELSE
	   SELECT FBDate
			, ROUND(AVG(Politeness),0) AS Politeness
			, ROUND(AVG(Driving),0) AS Driving
			, ROUND(AVG(TrafficRules),0) AS TrafficRules
			, ROUND(AVG(AutoInterior),0) AS AutoInterior
			, ROUND(AVG(AutoFare),0) AS AutoFare
		 FROM dbo.tbl_fback_autorikshaw
		WHERE DriverID = ID
		GROUP BY DriverID, FBDate
        ORDER BY FBDate;
    END IF;
    

END$$
DELIMITER ;

#CALL dbo.usp_get_AutoDriverFeedback('11', 'Hisotory');
#SELECT * FROM dbo.tbl_fback_autorikshaw;

