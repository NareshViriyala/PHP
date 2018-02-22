<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
	if($input == null)
		return;
    $jsonobject = json_decode($input, true);
    $phone = $jsonobject["phone"];
    $pin = $jsonobject["pin"];
    
    
    $stmt = $mysqlconn->prepare("CALL usp_validate_webuser(:_phone, :_pin)");
    $stmt->bindValue(':_phone', $phone);
    $stmt->bindValue(':_pin', $pin);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
	$username = $result[0]['result'];
	$userid = $result[0]['id'];
	if($username != 'False' && $username != 'User does not Exists') {
		session_start();
		$_SESSION["username"] = $username;
		$_SESSION["userid"] = $userid;
		$_SESSION["phonenumber"] = $phone;
	}
	//echo($result[0]['result']);
    //echo $username;
	echo json_encode($result);
}catch(PDOException $e){
    //echo "Connection failed: ". $e->getMessage();
	echo "Connection failed: ";
}
?>