DROP PROCEDURE IF EXISTS dbo.usp_rest_CallWaiterAck;

DELIMITER $$
CREATE PROCEDURE dbo.usp_rest_CallWaiterAck(input NVARCHAR(64))
BEGIN
	DECLARE ID INT;
    IF input REGEXP '^[0-9]+$'
    THEN 
		SET ID = CAST(input AS UNSIGNED);
    ELSE 
		SELECT SubjectID INTO ID FROM dbo.tbl_mstr_EntitySubject WHERE SubjectGuid = input;
    END IF;


	UPDATE dbo.tbl_rest_PlacedOrderMaster
      SET CallWaiter = 1
    WHERE SubjectID = ID;
END$$
DELIMITER ;

#CALL dbo.usp_rest_CallWaiterAck('5');
