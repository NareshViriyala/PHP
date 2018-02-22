DROP PROCEDURE IF EXISTS dbo.usp_get_TableList;

DELIMITER $$
CREATE PROCEDURE dbo.usp_get_TableList(_DeviceID INT, _EntityID INT)
BEGIN

	SELECT es.SubjectGuid AS SubjectID
	    , REPLACE(es.SubjectInfo, 'Table', '') AS SubjectInfo
	    , es.EntityID AS EntityID
	    , MIN(om.AckBit) AS AckBit
	    , MIN(om.CallWaiter) AS CallWaiter
	    , IFNULL(MIN(om.ID), 0) AS TblStatus
     FROM tbl_mstr_EntitySubject es
     LEFT JOIN dbo.tbl_rest_PlacedOrderMaster om
       ON es.SubjectID = om.SubjectID
    WHERE es.EntityID = _EntityID
    GROUP BY es.SubjectID, es.SubjectInfo, es.EntityID;
    
END$$
DELIMITER ;

#CALL dbo.usp_get_TableList(2, 2);
