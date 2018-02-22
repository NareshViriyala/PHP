DROP PROCEDURE IF EXISTS dbo.usp_add_UserSCEParam;

DELIMITER $$
CREATE PROCEDURE dbo.usp_add_UserSCEParam(
       _DeviceID INT
     , _EntityID NVARCHAR(64)
     , _xmlData TEXT)
BEGIN
	DECLARE _ID INT;
    DECLARE itemCount INT DEFAULT ExtractValue(_xmlData, 'count(//ID)');
    DECLARE i INT DEFAULT 1;
    
    IF _EntityID REGEXP '^[0-9]+$'
    THEN 
		SET _ID = CAST(_EntityID AS UNSIGNED);
    ELSE 
		SELECT SubjectID INTO _ID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = _EntityID;
    END IF;
    
    DROP TABLE IF EXISTS dbo.tbl_tmp_EntityUserSCEParam;
	CREATE TEMPORARY TABLE dbo.tbl_tmp_EntityUserSCEParam (
		   EntityID INT
		 , ParamID INT
		 , UserID INT
		 , ParamValue NVARCHAR(100)
		 , UNIQUE (EntityID, ParamID, UserID))engine=memory;
              
   WHILE i <= itemCount DO
		INSERT INTO dbo.tbl_tmp_EntityUserSCEParam(EntityID, ParamID, UserID, ParamValue)
        SELECT _EntityID AS EntityID
			 , ExtractValue(_xmlData, '//ID[$i]') AS ParamID
             , _DeviceID AS UserID
			 , ExtractValue(_xmlData, '//Value[$i]') AS ParamValue; 
		SET i = i + 1;
   END WHILE;
   #SELECT * FROM dbo.tbl_tmp_EntityUserSCEParam;
   
   INSERT INTO dbo.tbl_EntityUserSCEParam(EntityID, ParamID, UserID, ParamValue)
   SELECT EntityID, ParamID, UserID, ParamValue 
      FROM dbo.tbl_tmp_EntityUserSCEParam
        ON DUPLICATE KEY 
	UPDATE EntityID = values(EntityID)
         , ParamID = values(ParamID)
         , UserID = values(UserID)
         , ParamValue = values(ParamValue);
	
END$$
DELIMITER ;

#CALL dbo.usp_add_UserSCEParam('1','5B0A3D65-BA4C-4312-9910-0F13D994513D','<order><TID>2</TID><QTY>1</QTY><TID>24</TID><QTY>2</QTY></order>',2);
