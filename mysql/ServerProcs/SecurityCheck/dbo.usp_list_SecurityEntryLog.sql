DROP PROCEDURE IF EXISTS dbo.usp_list_SecurityEntryLog;

DELIMITER $$
CREATE PROCEDURE dbo.usp_list_SecurityEntryLog(
	   _EntityID INT
	 , _DeviceID INT
	 , _SearchString NVARCHAR(20)
	 , _PageNumber INT
	 , _PageCount INT)
BEGIN
	SET @OID := 0;
    SELECT *
      FROM (SELECT LocalDBID AS DBID
				 , DeviceID
				 , NULLIF(Name, '') AS Name
                 , NULLIF(Age, '') AS Age
                 , NULLIF(DOB, '') AS DOB
                 , NULLIF(Vehicle, '') AS Vehicle
                 , NULLIF(ComingFrom, '') AS ComingFrom
                 , NULLIF(VisitingCompany, '') AS VisitingCompany
                 , NULLIF(HomeAdd, '') AS HomeAddress
				 , NULLIF(Email, '') AS Email
				 , NULLIF(Phone, '') AS Phone
				 , CASE Sex WHEN 1 THEN '1' ELSE '0' END AS Gender
				 , NULLIF(Purpose,'') AS Pov
				 , NULLIF(ContactPerson, '') AS ContactPerson
                 , NULLIF(OfcAdd, '') AS OfficeAddress
                 , NULLIF(Blok, '') AS 'Block'
                 , NULLIF(Flat, '') AS 'Flat'
				 , CASE isDeleted WHEN 1 THEN '1' ELSE '0' END AS isDeleted
				 , SystemTime AS EnterTime
				 , @OID := @OID + 1 AS OID
                 , ID AS ServerID
			  FROM dbo.tbl_SecurityCheckEntry
			 WHERE EntityID = _EntityID
			   AND (IFNULL(_SearchString,'') = ''
				OR Name LIKE CONCAT('%',_SearchString,'%')
				OR Email LIKE CONCAT('%',_SearchString,'%')
				OR Phone LIKE CONCAT('%',_SearchString,'%')
				OR Sex LIKE CONCAT('%',_SearchString,'%')
				OR Vehicle LIKE CONCAT('%',_SearchString,'%')
				OR ComingFrom LIKE CONCAT('%',_SearchString,'%')
				OR Purpose LIKE CONCAT('%',_SearchString,'%')
				OR VisitingCompany LIKE CONCAT('%',_SearchString,'%')
				OR ContactPerson LIKE CONCAT('%',_SearchString,'%'))
			 ORDER BY SystemTime DESC) AS tbl_final
	 WHERE tbl_final.OID BETWEEN ((_PageNumber-1) * _PageCount + 1)	
       AND (_PageNumber * _PageCount)
     ORDER BY tbl_final.OID;

END$$
DELIMITER ;
#CALL dbo.usp_list_SecurityEntryLog(6, 1,'Naresh', 1, 10);

