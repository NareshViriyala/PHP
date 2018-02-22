DROP FUNCTION IF EXISTS dbo.fn_gettotalbill;


DELIMITER $$
CREATE FUNCTION dbo.fn_gettotalbill (_ID INT) 
RETURNS INT
BEGIN
    DECLARE tob INT DEFAULT 0;
	DECLARE finalbill INT DEFAULT 0;
    SET @tob := 0;
    
    SELECT MAX(totalbill) INTO tob
      FROM (SELECT @tob := @tob + (rm.ItemPrice*pos.Quantity) AS totalbill
			  FROM dbo.tbl_rest_PlacedOrderMaster pom
			  JOIN dbo.tbl_rest_PlacedOrderSlave pos
				ON pom.ID = pos.MasterID
			  JOIN dbo.tbl_mstr_RestaurantMenu rm
				ON pos.TID = rm.ID
			 WHERE pom.ID = _ID) AS tbl;
       
       -- SET tob = @tob;
     
	SELECT SUM(@tob * (rtt.TaxPercentage/100)) INTO finalbill
	  FROM dbo.tbl_rest_PlacedOrderMaster pom
	  JOIN dbo.tbl_mstr_EntitySubject es
		ON pom.SubjectID = es.SubjectID
	  JOIN dbo.tbl_mstr_EstablishmentEntity ee 
		ON es.EntityID = ee.EEID
	  JOIN dbo.tbl_mstr_RestaurantTaxType rtt 
		ON ee.EEID = rtt.EntityID
	 WHERE pom.ID = _ID;
     
	IF finalbill IS NULL
	THEN
		SET @tob := 0;
        SET tob = 0;
        SELECT MAX(totalbill) INTO tob
          FROM (SELECT @tob := @tob + (rm.ItemPrice*pos.Quantity) AS totalbill
				  FROM dbo.tbl_rest_PlacedOrderMasterArchive pom
				  JOIN dbo.tbl_rest_PlacedOrderSlaveArchive pos
					ON pom.MasterID = pos.MasterID
				  JOIN dbo.tbl_mstr_RestaurantMenu rm
					ON pos.TID = rm.ID
				 WHERE pom.MasterID = _ID) AS tbl ;
         
           -- SET tob = @tob;
		 
		SELECT SUM(@tob * (rtt.TaxPercentage/100)) INTO finalbill
		  FROM dbo.tbl_rest_PlacedOrderMasterArchive pom
		  JOIN dbo.tbl_mstr_EntitySubject es
			ON pom.SubjectID = es.SubjectID
		  JOIN dbo.tbl_mstr_EstablishmentEntity ee
			ON es.EntityID = ee.EEID
		  JOIN dbo.tbl_mstr_RestaurantTaxType rtt 
			ON ee.EEID = rtt.EntityID
		 WHERE pom.MasterID = _ID;
	END IF;
	
	RETURN finalbill;
END$$
DELIMITER ;


#SELECT dbo.fn_gettotalbill(1); 