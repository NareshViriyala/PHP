DROP PROCEDURE IF EXISTS dbo.usp_add_UserHomeAddress;

DELIMITER $$
CREATE PROCEDURE dbo.usp_add_UserHomeAddress(
	   _DeviceID INT
	 , _Add1 NVARCHAR(100) 
	 , _Add2 NVARCHAR(100)
	 , _LandMark NVARCHAR(100)
	 , _City NVARCHAR(50)
	 , _State NVARCHAR(20)
	 , _Country NVARCHAR(20)
	 , _Zip NVARCHAR(20))
BEGIN

    DROP TABLE IF EXISTS dbo.tbl_tmp_UserHomeAddress;
	CREATE TEMPORARY TABLE dbo.tbl_tmp_UserHomeAddress (
		   DeviceID INT PRIMARY KEY
		 , Add1 NVARCHAR(100) 
		 , Add2 NVARCHAR(100)
		 , LandMark NVARCHAR(100)
		 , City NVARCHAR(50)
		 , State NVARCHAR(50)
		 , Country NVARCHAR(50)
		 , Zip NVARCHAR(10))engine=memory;
         
    INSERT INTO dbo.tbl_tmp_UserHomeAddress(DeviceID, Add1, Add2, LandMark, City, State, Country, Zip)     
    VALUES (_DeviceID, _Add1, _Add2, _LandMark, _City, _State, _Country, _Zip) ;

    INSERT INTO dbo.tbl_mstr_UserHomeAddress(DeviceID, Add1, Add2, LandMark, City, State, Country, Zip)
    SELECT DeviceID, Add1, Add2, LandMark, City, State, Country, Zip 
	  FROM dbo.tbl_tmp_UserHomeAddress
	  -- FROM (_DeviceID AS DeviceID, _Add1 AS Add1, _Add2 AS Add2, _LandMark AS LandMark, _City AS City, _State AS State, _Country AS Country, _Zip AS _Zip) AS tbl
        ON DUPLICATE KEY 
	UPDATE Add1 = values(Add1)
         , Add2 = values(Add2)
         , LandMark = values(LandMark)
         , City = values(City)
         , State = values(State)
         , Country = values(Country)
         , Zip = values(Zip)
         , UpdateDate = NOW();
END$$
DELIMITER ;

#CALL dbo.usp_add_UserHomeAddress('1','Add1','Add2','LandMark','City','State','Country','32245');
#SELECT * FROM dbo.tbl_mstr_UserHomeAddress;
