<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["input"];
    $PageNumber = $_REQUEST["PageNumber"];
    $PageCount = $_REQUEST["PageCount"];
    if($input == ""){
        return;
    }
    $stmt = $mysqlconn->prepare("CALL usp_list_GetMenu(:input,:PageNumber,:PageCount)");
    $stmt->bindValue(':input', $input);
    $stmt->bindValue(':PageNumber', $PageNumber);
    $stmt->bindValue(':PageCount', $PageCount);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
    echo json_encode($result);
}catch(PDOException $e){
    echo "Connection failed: ";
}
?>