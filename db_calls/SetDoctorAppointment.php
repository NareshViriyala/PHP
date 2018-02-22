<?php
include 'dbconnect.php'; 
include "globalvariables.php";
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
    $jsonobject = json_decode($input, true);
    
    $ApptID = $jsonobject["ApptID"];
    $CallType = $jsonobject["CallType"];
    $CallFrom = $jsonobject["CallFrom"];
    $DeviceID = $jsonobject["DeviceID"];
    if($input == ""){
        return;
    }
    $stmt = $mysqlconn->prepare("CALL usp_set_DoctorAppointmentStatus(:_ApptID,:_CallType,:_CallFrom,:_DeviceID)");
    $stmt->bindValue(':_ApptID', $ApptID);
    $stmt->bindValue(':_CallType', $CallType);
    $stmt->bindValue(':_CallFrom', $CallFrom);
    $stmt->bindValue(':_DeviceID', $DeviceID);
    $stmt->execute();
	@file_get_contents($webserviceurl.'PushNotification.php');
    echo ('Success');
}catch(PDOException $e){
    echo "Connection failed: ";
    echo $e->getMessage();
}
?>