<?php
include 'dbconnect.php'; 
include "globalvariables.php";
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
    //echo ($input);
//    $injson = '{"a":1,"b":2,"c":3,"d":4,"e":5}';
//    echo ($injson);
//    var_dump(json_decode($injson, true));
//    var_dump(json_decode($input, true));
    $jsonobject = json_decode($input, true);
    //echo ("testing");
    //echo ($input);
    $MasterID = $jsonobject["MasterID"];
    $ID = $jsonobject["input"];
    
    //echo ($MasterID);
//    echo ($ID);
    
    $stmt = $mysqlconn->prepare("CALL usp_rest_CallWaiter(:_MasterID, :_input)");
    $stmt->bindValue(':_MasterID', $MasterID);
    $stmt->bindValue(':_input', $ID);
    $stmt->execute();
	@file_get_contents($webserviceurl.'PushNotification.php');
    echo ("Success");
}catch(PDOException $e){
    echo "Connection failed: ". $e->getMessage();
}
?>