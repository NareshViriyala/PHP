<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
    $stmt = $mysqlconn->prepare("CALL usp_add_ServerDeviceErrorLog(:_input)");
    $stmt->bindValue(':_input', $input);
    $stmt->execute(); 
    echo ("Success");
}catch(PDOException $e){
    echo "Connection failed: ";
    echo $e->getMessage();
}
?>