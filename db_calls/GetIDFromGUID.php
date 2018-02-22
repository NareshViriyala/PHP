<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $guid = $_REQUEST["guid"];
    if($guid == ""){
        return;
    }
    $stmt = $mysqlconn->prepare("CALL usp_get_IDfromGUID(:guid)");
    $stmt->bindValue(':guid', $guid);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
    echo json_encode($result);
}catch(PDOException $e){
    echo "Connection failed: ";
}
?>