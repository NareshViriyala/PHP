DROP PROCEDURE IF EXISTS dbo.usp_add_ServerDeviceErrorLog;

DELIMITER $$
CREATE PROCEDURE dbo.usp_add_ServerDeviceErrorLog(_input TEXT)
BEGIN
	DECLARE itemCount INT DEFAULT ExtractValue(_input, 'count(//DeviceID)');
    SET @MaxID := 1;
    
    WHILE @MaxID <= itemCount DO
		INSERT INTO dbo.tbl_ServerDeviceErrorLog(DeviceID,PageName,MethodName,ExceptionType,ExceptionText,OcrDate)
        SELECT ExtractValue(_input, '//DeviceID[$@MaxID]') AS DeviceID
			 , ExtractValue(_input, '//PageName[$@MaxID]') AS PageName
			 , ExtractValue(_input, '//MethodName[$@MaxID]') AS MethodName
			 , ExtractValue(_input, '//ExceptionType[$@MaxID]') AS ExceptionType
			 , substr(ExtractValue(_input, '//ExceptionText[$@MaxID]'),1,2000) AS ExceptionText
             , ExtractValue(_input, '//OcrDate[$@MaxID]') AS OcrDate;
		SET @MaxID := @MaxID + 1;
    END WHILE; 
	
END$$
DELIMITER ;

#CALL dbo.usp_add_ServerDeviceErrorLog('2968491D-75BB-4C48-8F16-E789EE44860E', NULL, 2, 10);

