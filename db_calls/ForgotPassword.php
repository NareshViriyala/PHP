<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
	if($input == null)
		return;
    $jsonobject = json_decode($input, true);
    $phone = $jsonobject["phone"];
    $otp = $jsonobject["otp"];
	$newpassword = $jsonobject["newpassword"];
    
    
    $stmt = $mysqlconn->prepare("CALL usp_web_forgotpassword(:_phone, :_otp, :_newpassword)");
    $stmt->bindValue(':_phone', $phone);
    $stmt->bindValue(':_otp', $otp);
	$stmt->bindValue(':_newpassword', $newpassword);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
	if(strcmp($result[0]['result'],"Enter OTP") == 0){
		$baseurl = "https://control.msg91.com/api/sendhttp.php?";
		$authkey = "authkey=139187ASehoZ5QNuKp58905ae9";
		$mobilenumber = "&mobiles=".$phone;
		$message = "&message=Logmenow OTP is ".$result[0]['otp'];
		$sender = "&sender=VERIFY&route=4";
		//$otpresponse = file_get_contents($baseurl.$authkey.$mobilenumber.$message.$sender);		
	}
	
	if (is_numeric($result[0]['result'])) { //successfully updated forgot password option with new password hence a session is started for the user just like normal login
        session_start();
		$_SESSION["username"] = $result[0]['otp'];
		$_SESSION["userid"] = $result[0]['result'];
		$_SESSION["phonenumber"] = $phone;
		echo $result[0]['result'].'-'.$result[0]['otp'];
    }else{ 
		echo $result[0]['result'];
	}
}catch(PDOException $e){
    //echo "Connection failed: ". $e->getMessage();
	echo "Connection failed: ";
}
?>