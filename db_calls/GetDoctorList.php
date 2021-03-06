<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
    $jsonobject = json_decode($input, true);
    $DeviceID = $jsonobject["DeviceID"];
    $HospitalID = $jsonobject["HospitalID"];
    
    //echo ($DeviceID);
    
    $stmt = $mysqlconn->prepare("CALL usp_get_DoctorList(:_DeviceID, :_HospitalID)");
    $stmt->bindValue(':_DeviceID', $DeviceID);
    $stmt->bindValue(':_HospitalID', $HospitalID);
    
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
    echo json_encode($result);
}catch(PDOException $e){
    echo "Connection failed: ". $e->getMessage();
}
?>