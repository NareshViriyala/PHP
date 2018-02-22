<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $DeviceID = $_REQUEST["DeviceID"];
    $PageNumber = $_REQUEST["PageNumber"];
    $PageCount = $_REQUEST["PageCount"];
    $stmt = $mysqlconn->prepare("CALL usp_list_ClientHistory(:DeviceID,:PageNumber,:PageCount)");
    $stmt->bindValue(':DeviceID', $DeviceID);
    $stmt->bindValue(':PageNumber', $PageNumber);
    $stmt->bindValue(':PageCount', $PageCount);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
    echo json_encode($result);
}catch(PDOException $e){
    echo "Connection failed: ";
}
?>