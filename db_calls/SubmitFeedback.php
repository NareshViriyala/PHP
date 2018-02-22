<?php
include 'dbconnect.php'; 
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $input = $_REQUEST["json"];
	if($input == null)
		return;
    $jsonobject = json_decode($input, true);
    $uid = $jsonobject["userid"];
    $eid = $jsonobject["entityid"];
    $fbi = json_encode($jsonobject["feedbackinfo"]);
    //echo $uid;
	//echo $eid;
	//echo $fbi;
 
    $stmt = $mysqlconn->prepare("CALL usp_add_entityfeedback(:_userid, :_entityid, :_feedback)");
    $stmt->bindValue(':_userid', $uid);
    $stmt->bindValue(':_entityid', $eid);
    $stmt->bindValue(':_feedback', $fbi);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
    echo json_encode($result);   

}catch(PDOException $e){
    //echo "Connection failed: ". $e->getMessage();
	echo "Connection failed: ";
}
?>