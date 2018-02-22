<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
    $jsonobject = json_decode($input, true);
    $DeviceID = $jsonobject["DeviceID"];
    $Uri = $jsonobject["Uri"];
    $DeviceType = $jsonobject["DeviceType"];
    $DeviceVersion = $jsonobject["DeviceVersion"];
    $AppVersion = $jsonobject["AppVersion"];
    //echo ($DeviceID);
    
    $stmt = $mysqlconn->prepare("CALL usp_add_ServerDevice(:_DeviceID, :_Uri, :_DeviceType, :_DeviceVersion, :_AppVersion)");
    $stmt->bindValue(':_DeviceID', $DeviceID);
    $stmt->bindValue(':_Uri', $Uri);
    $stmt->bindValue(':_DeviceType', $DeviceType);
    $stmt->bindValue(':_DeviceVersion', $DeviceVersion);
    $stmt->bindValue(':_AppVersion', $AppVersion);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
    echo json_encode($result);
}catch(PDOException $e){
    echo "Connection failed: ". $e->getMessage();
}
?>