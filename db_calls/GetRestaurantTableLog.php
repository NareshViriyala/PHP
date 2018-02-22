<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
    $jsonobject = json_decode($input, true);
    $GUID = $jsonobject["GUID"];
    $SearchString = $jsonobject["SearchString"];
    $PageNumber = $jsonobject["PageNumber"];
    $PageCount = $jsonobject["PageCount"];
    
    //echo ($DeviceID);
    
    $stmt = $mysqlconn->prepare("CALL usp_list_RestaurantTableLog(:_Guid, :_SearchString,:_PageNumber, :_PageCount)");
    $stmt->bindValue(':_Guid', $GUID);
    $stmt->bindValue(':_SearchString', $SearchString);
    $stmt->bindValue(':_PageNumber', $PageNumber);
    $stmt->bindValue(':_PageCount', $PageCount);
    
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
    echo json_encode($result);
}catch(PDOException $e){
    echo "Connection failed: ". $e->getMessage();
}
?>