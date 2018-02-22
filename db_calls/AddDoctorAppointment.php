<?php
include 'dbconnect.php'; 
include "globalvariables.php";
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
    $jsonobject = json_decode($input, true);
    $DocGuid = $jsonobject["DocGuid"];
    $PatientName = $jsonobject["PatientName"];
    $AgeYear = $jsonobject["AgeYear"];
    $AgeMonth = $jsonobject["AgeMonth"];
    $Gender = $jsonobject["Gender"];
    $PatientDeviceID = $jsonobject["PatientDeviceID"];
    $CurrApptID = $jsonobject["CurrApptID"];
	$PatientPhone = $jsonobject["PatientPhone"];
    //echo ($DocGuid.$PatientName.$AgeYear.$AgeMonth.$Gender.$PatientDeviceID.$CurrApptID);
    $stmt = $mysqlconn->prepare("CALL usp_add_DoctorAppointment(:_DocGuid,:_PatientName,:_AgeYear,:_AgeMonth,:_Gender,:_PatientDeviceID,:_CurrApptID,:_PatientPhone)");
    $stmt->bindValue(':_DocGuid', $DocGuid);
    $stmt->bindValue(':_PatientName', $PatientName);
    $stmt->bindValue(':_AgeYear', $AgeYear);
    $stmt->bindValue(':_AgeMonth', $AgeMonth);
    $stmt->bindValue(':_Gender', $Gender);
    $stmt->bindValue(':_PatientDeviceID', $PatientDeviceID);
    $stmt->bindValue(':_CurrApptID', $CurrApptID);
	$stmt->bindValue(':_PatientPhone', $PatientPhone);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
	@file_get_contents($webserviceurl.'PushNotification.php');
    echo json_encode($result);
}catch(PDOException $e){
    echo "Connection failed: ";
}
?>