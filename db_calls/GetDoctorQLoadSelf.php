<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    $id = $_REQUEST["id"];
	$userid = $_REQUEST["userid"];
    if($id == ""){
        return;
    }
    
    $stmt = $mysqlconn->prepare("CALL usp_get_DoctorQueueLoadSelf(:input,:userid)");
    $stmt->bindValue(':input', $id);
	$stmt->bindValue(':userid', $userid);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
    echo json_encode($result);
}catch(PDOException $e){
    echo "Connection failed: ". $e->getMessage();
}
?>