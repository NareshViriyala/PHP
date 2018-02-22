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
    $Add1 = $jsonobject["Add1"];
    $Add2 = $jsonobject["Add2"];
    $City = $jsonobject["City"];
    $State = $jsonobject["State"];
    $Country = $jsonobject["Country"];
    $Zip = $jsonobject["Zip"];
    //echo ($DeviceID);
    
    $stmt = $mysqlconn->prepare("CALL usp_add_UserOfficeAddress(:_DeviceID, :_Add1, :_Add2, :_City, :_State, :_Country, :_Zip)");
    $stmt->bindValue(':_DeviceID', $DeviceID);
    $stmt->bindValue(':_Add1', $Add1);
    $stmt->bindValue(':_Add2', $Add2);
    $stmt->bindValue(':_City', $City);
    $stmt->bindValue(':_State', $State);
    $stmt->bindValue(':_Country', $Country);
    $stmt->bindValue(':_Zip', $Zip);
    $stmt->execute();
    echo ("Success");
}catch(PDOException $e){
    echo "Connection failed: ". $e->getMessage();
}
?>