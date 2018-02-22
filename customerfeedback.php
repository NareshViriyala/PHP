<?php include "header.php" ?>
<?php include "db_calls/globalvariables.php" ?>
<?php 
$uid = $_REQUEST['route'];
$eid = $_REQUEST['reroute'];
$type = $_REQUEST['type'];

if($uid == null || $eid == null || $type == null){
	header("Location: /"); //go back to index page "a back slash means root page which in this case is index.php, you can mention where ever page you want here"
    return;
}else{
	//the names "route" & "reroute" are intentionally taken as opposed to "userid" & "entityid"
	//to create the diversion to the user when they look at the browser.
	if(file_exists ('feedback/feedback_'.$eid.'.php')){	
		header("Location: ".$feedbackurl."feedback_".$eid.".php?route=".$uid."&reroute=".$eid);
		//echo "Location: ".$feedbackurl."feedback_".$eid.".php?route=".$uid."&reroute=".$eid;
	}elseif (file_exists ('feedback/feedback_'.$type.'.php')){	
		header("Location: ".$feedbackurl."feedback_".$type.".php?route=".$uid."&reroute=".$eid);
		//echo "Location: ".$feedbackurl."feedback_".$type.".php?route=".$uid."&reroute=".$eid;
	}else{
		header("Location: /");
		//echo "Location: /";
	}
    return;
}

?>