<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
    $jsonobject = json_decode($input, true);
    
    $DeviceID = $jsonobject["DeviceID"];
    $EntityID = $jsonobject["EntityID"];
    $XMLData = $jsonobject["XMLData"];
    if($input == ""){
        return;
    }
    $stmt = $mysqlconn->prepare("CALL usp_add_UserSCEParam(:_DeviceID,:_EntityID,:_xmlData)");
    $stmt->bindValue(':_DeviceID', $DeviceID);
    $stmt->bindValue(':_EntityID', $EntityID);
    $stmt->bindValue(':_xmlData', $XMLData);
    $stmt->execute();
    //$result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
    //echo json_encode($result);
	echo 'Success';
}catch(PDOException $e){
    echo "Connection failed: ";
    echo $e->getMessage();
}
?>