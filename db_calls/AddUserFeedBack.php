<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $userid = $_REQUEST["id"];
	$feedback = $_REQUEST["feedback"];
    if($feedback == ""){
        return;
    }
    $stmt = $mysqlconn->prepare("CALL usp_add_userfeedback(:_userid,:_feedback)");
    $stmt->bindValue(':_userid', $userid);
    $stmt->bindValue(':_feedback', $feedback);
    $stmt->execute();
	echo 'Success';
}catch(PDOException $e){
    echo "Connection failed: ";
    echo $e->getMessage();
}
?>