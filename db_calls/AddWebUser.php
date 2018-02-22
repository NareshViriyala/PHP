<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
	if($input == null)
		return;
    $jsonobject = json_decode($input, true);
    $name = $jsonobject["name"];
    $phone = $jsonobject["phone"];
    $pin = $jsonobject["pin"];
    $email = $jsonobject["email"];
	$otp = $jsonobject["otp"];
    
    
    $stmt = $mysqlconn->prepare("CALL usp_add_webuser(:_name, :_phone, :_pin, :_email, :_otp)");
    $stmt->bindValue(':_name', $name);
    $stmt->bindValue(':_phone', $phone);
    $stmt->bindValue(':_pin', $pin);
    $stmt->bindValue(':_email', $email);
	$stmt->bindValue(':_otp', $otp);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
    //echo json_encode($result);
	if(strcmp($result[0]['result'],"New User") == 0){ //send otp message for phone validation
		$baseurl = "https://control.msg91.com/api/sendhttp.php?";
		$authkey = "authkey=139187ASehoZ5QNuKp58905ae9";
		$mobilenumber = "&mobiles=".$phone;
		//$mobilenumber = "&mobiles=9985265352";
		$message = "&message=Logmenow registration OTP is ".$result[0]['otp'];
		$sender = "&sender=VERIFY&route=4";
		//$otpresponse = file_get_contents('https://control.msg91.com/api/sendhttp.php?authkey=139187ASehoZ5QNuKp58905ae9&mobiles=9052224636&message=Logmenow%20registration%20OTP%20is%201125&sender=VERIFY&route=4&country=91');
		$otpresponse = file_get_contents($baseurl.$authkey.$mobilenumber.$message.$sender);
		//$otpresponse = file_get_contents('localhost:90/otp.php?json={"phone":"'.$phone.'","otp":"'.$result[0]['otp'].'"}');	
		//echo "otpresponse = ".$otpresponse;
	}
	
	if (is_numeric($result[0]['result'])) { //successfully completed phone validation hence a session is started for the user just like normal login
        session_start();
		$_SESSION["username"] = $name;
		$_SESSION["userid"] = $result[0]['result'];
		$_SESSION["phonenumber"] = $phone;
    } 
	echo $result[0]['result'];
}catch(PDOException $e){
    //echo "Connection failed: ". $e->getMessage();
	echo "Connection failed: ";
}
?>