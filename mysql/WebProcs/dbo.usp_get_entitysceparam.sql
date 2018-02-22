DROP PROCEDURE IF EXISTS dbo.usp_get_entitysceparam;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_entitysceparam(_entityid NVARCHAR(64), _deviceid int)
BEGIN
/*
	SELECT mp.ParamID, MAX(eu.ParamValue) AS ParamValue
	  FROM dbo.tbl_EntityUserSCEParam eu
      JOIN dbo.tbl_mstr_SecurityCheckParameter mp
        ON eu.ParamID = mp.ParamID
	 WHERE eu.UserID = _deviceid
       AND eu.EntityID = _entityid
     GROUP BY mp.ParamID;
*/
	DECLARE _ID INT;
    
    IF _entityid REGEXP '^[0-9]+$'
    THEN 
		SET _ID = CAST(_entityid AS UNSIGNED);
    ELSE 
		SELECT SubjectID INTO _ID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = _entityid;
    END IF;

	IF(_deviceid <= 0 || _deviceid = null)
    THEN
		SELECT mp.ParamID, mp.ParamType, '' AS ParamValue
		  FROM dbo.tbl_EntitySCEParam sp
		  JOIN dbo.tbl_mstr_SecurityCheckParameter mp
			ON sp.ParamID = mp.ParamID
		 WHERE sp.EntityID = _ID;
    ELSE
		SELECT mp.ParamID, mp.ParamType, IFNULL(IFNULL(eu.ParamValue, his.ParamValue),'') AS ParamValue
		  FROM dbo.tbl_EntitySCEParam sp
		  JOIN dbo.tbl_mstr_SecurityCheckParameter mp
			ON sp.ParamID = mp.ParamID
		  LEFT JOIN dbo.tbl_EntityUserSCEParam eu
			ON eu.EntityID = sp.EntityID
		   AND eu.ParamID = sp.ParamID
		   AND eu.UserID = _deviceid
		  LEFT JOIN (SELECT mp.ParamID, MAX(eu.ParamValue) AS ParamValue
					  FROM dbo.tbl_EntityUserSCEParam eu
					  JOIN dbo.tbl_mstr_SecurityCheckParameter mp
						ON eu.ParamID = mp.ParamID
					 WHERE eu.UserID = _deviceid
					  # AND eu.EntityID = _entityid
					 GROUP BY mp.ParamID) AS his
			ON his.ParamID = sp.ParamID
		 WHERE sp.EntityID = _ID;
    END IF;
END$$
DELIMITER ;

#CALL dbo.usp_get_entitysceparam(9, 13);
#SELECT * FROM dbo.tbl_mstr_UserDevice;
#SELECT * FROM dbo.tbl_mstr_GroupDevice;