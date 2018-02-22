<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
    $jsonobject = json_decode($input, true);
    $GUID = $jsonobject["GUID"];
    $stmt = $mysqlconn->prepare("CALL usp_rest_CallWaiterAck(:input)");
    $stmt->bindValue(':input', $GUID);
    $stmt->execute();
    echo ("Success");
}catch(PDOException $e){
    echo "Connection failed: ";
}
?>