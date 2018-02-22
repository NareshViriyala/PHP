<?php
try {
	session_start();
	session_destroy();
    echo "Success";
}catch(PDOException $e){
    //echo "Connection failed: ". $e->getMessage();
	echo "Failed";
}
?>