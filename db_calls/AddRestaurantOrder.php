<?php
include 'dbconnect.php'; 
include "globalvariables.php";
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
    $jsonobject = json_decode($input, true);
    
    $DeviceID = $jsonobject["DeviceID"];
    $SubjectID = $jsonobject["SubjectID"];
    $XMLOrder = $jsonobject["XMLOrder"];
    $DeviceType = $jsonobject["DeviceType"];
	$PersonName = $jsonobject["PersonName"];
    if($input == ""){
        return;
    }
    $stmt = $mysqlconn->prepare("CALL usp_rest_PlaceOrder(:_DeviceID,:_SubjectID,:_xml_OrderItem,:_DeviceType, :_PersonName)");
    $stmt->bindValue(':_DeviceID', $DeviceID);
    $stmt->bindValue(':_SubjectID', $SubjectID);
    $stmt->bindValue(':_xml_OrderItem', $XMLOrder);
    $stmt->bindValue(':_DeviceType', $DeviceType);
	$stmt->bindValue(':_PersonName', $PersonName);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
	@file_get_contents($webserviceurl.'PushNotification.php');
    echo json_encode($result);
}catch(PDOException $e){
    echo "Connection failed: ";
    echo $e->getMessage();
}
?>