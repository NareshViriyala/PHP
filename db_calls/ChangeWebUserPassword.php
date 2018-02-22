<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
	if($input == null)
		return;
    $jsonobject = json_decode($input, true);
    $userid = $jsonobject["userid"];
    $currentpin = $jsonobject["currentpin"];
	$newpin = $jsonobject["newpin"];
    
    
    $stmt = $mysqlconn->prepare("CALL usp_web_changepassword(:_userid, :_currentpin, :_newpin)");
    $stmt->bindValue(':_userid', $userid);
    $stmt->bindValue(':_currentpin', $currentpin);
    $stmt->bindValue(':_newpin', $newpin);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);    
	echo $result[0]['result'];
}catch(PDOException $e){
    //echo "Connection failed: ". $e->getMessage();
	echo "Connection failed: ";
}
?>