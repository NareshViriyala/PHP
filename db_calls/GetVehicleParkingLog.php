<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
    $jsonobject = json_decode($input, true);
    $EntityID = $jsonobject["EntityID"];
    $DeviceID = $jsonobject["DeviceID"];
    $VehicleNo = $jsonobject["VehicleNo"];
    $PageNumber = $jsonobject["PageNumber"];
    $PageCount = $jsonobject["PageCount"];
    
    //echo ($DeviceID);
    
    $stmt = $mysqlconn->prepare("CALL usp_list_VehicleParkingLog(:_EntityID, :_DeviceID, :_VehicleNo,:_PageNumber, :_PageCount)");
    $stmt->bindValue(':_EntityID', $EntityID);   
    $stmt->bindValue(':_DeviceID', $DeviceID);
    $stmt->bindValue(':_VehicleNo', $VehicleNo);
    $stmt->bindValue(':_PageNumber', $PageNumber);
    $stmt->bindValue(':_PageCount', $PageCount);
    
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
    echo json_encode($result);
}catch(PDOException $e){
    echo "Connection failed: ". $e->getMessage();
}
?>