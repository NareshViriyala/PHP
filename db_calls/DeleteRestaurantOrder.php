<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
    $jsonobject = json_decode($input, true);
    
    $MasterID = $jsonobject["MasterID"];
    $GUID = $jsonobject["GUID"];
    $DeviceID = $jsonobject["DeviceID"];
    $Status = $jsonobject["Status"];
    if($input == ""){
        return;
    }
    $stmt = $mysqlconn->prepare("CALL usp_rest_deleteorder(:_MasterID,:_GUID,:_DeviceID,:_Status)");
    $stmt->bindValue(':_MasterID', $MasterID);
    $stmt->bindValue(':_GUID', $GUID);
    $stmt->bindValue(':_DeviceID', $DeviceID);
    $stmt->bindValue(':_Status', $Status);
    $stmt->execute();
    echo ("Success");
}catch(PDOException $e){
    echo "Connection failed: ";
    echo $e->getMessage();
}
?>