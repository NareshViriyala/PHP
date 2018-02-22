<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $uid = $_REQUEST["uid"];
    
    $stmt = $mysqlconn->prepare("CALL usp_get_UserBasicInfo(:_UserID)");
    $stmt->bindValue(':_UserID', $uid);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
    echo json_encode($result);
}catch(PDOException $e){
    echo "Connection failed";
}
?>