<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
    if($input == ""){
        return;
    }
    $jsonobject = json_decode($input, true);
    $DeviceID = $jsonobject["DeviceID"];
    $FName = $jsonobject["FName"];
    $MName = $jsonobject["MName"];
    $LName = $jsonobject["LName"];
    $Email = $jsonobject["Email"];
    $Phone = $jsonobject["Phone"];

    //echo ($DeviceID);
    
    $stmt = $mysqlconn->prepare("CALL usp_add_UserPersonalInfo(:_DeviceID, :_FName, :_MName, :_LName, :_Email, :_Phone)");
    $stmt->bindValue(':_DeviceID', $DeviceID);
    $stmt->bindValue(':_FName', $FName);
    $stmt->bindValue(':_MName', $MName);
    $stmt->bindValue(':_LName', $LName);
    $stmt->bindValue(':_Email', $Email);
    $stmt->bindValue(':_Phone', $Phone);
    $stmt->execute();
    echo ("Success");
}catch(PDOException $e){
    echo "Connection failed: ". $e->getMessage();
}
?>