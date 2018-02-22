<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
    $jsonobject = json_decode($input, true);
    $DeviceID = $jsonobject["DeviceID"];
    $EntityType = $jsonobject["EntityType"];
    
    $stmt = $mysqlconn->prepare("CALL usp_get_ServerDeviceEntityList(:_DeviceID, :_EntityType)");
    $stmt->bindValue(':_DeviceID', $DeviceID);
    $stmt->bindValue(':_EntityType', $EntityType);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
    echo json_encode($result);
}catch(PDOException $e){
    echo "Connection failed: ". $e->getMessage();
}
?>