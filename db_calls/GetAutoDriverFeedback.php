<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $id = $_REQUEST["id"];
	$gettype = $_REQUEST["gettype"];
    if($id == ""){
        return;
    }
    $stmt = $mysqlconn->prepare("CALL usp_get_AutoDriverFeedback(:input, :gettype)");
    $stmt->bindValue(':input', $id);
	$stmt->bindValue(':gettype', $gettype);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
    echo json_encode($result);
}catch(PDOException $e){
    echo "Connection failed: ";
}
?>