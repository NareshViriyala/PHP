<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
    $jsonobject = json_decode($input, true);
    $DeviceID = $jsonobject["DeviceID"];
    $EntityID = $jsonobject["EntityID"];
    //echo ($DeviceID);
    
    $stmt = $mysqlconn->prepare("CALL usp_get_entitysceparam(:_entityid, :_deviceid)");
    $stmt->bindValue(':_entityid', $EntityID);
    $stmt->bindValue(':_deviceid', $DeviceID);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
    echo json_encode($result);
}catch(PDOException $e){
    echo "Connection failed";
}
?>