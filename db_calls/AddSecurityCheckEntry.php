<?php
include 'dbconnect.php'; 
include "globalvariables.php";
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];  
    $stmt = $mysqlconn->prepare("CALL usp_add_SecurityCheckEntry(:_input)");
    $stmt->bindValue(':_input', $input);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
	@file_get_contents($webserviceurl.'PushNotification.php');
    echo json_encode($result);
}catch(PDOException $e){
    echo "Connection failed: ". $e->getMessage();
}
?>