<?php 
session_start(); 
if(isset($_SESSION['username'])){
	//$_SESSION['username'] = '';
	$username = $_SESSION['username'];
	$phonenumber = $_SESSION['phonenumber'];
	$userid = $_SESSION["userid"];
	//echo 'Username:'.$username.'--Phone:'.$phonenumber.'--UserID:'.$userid;
	if($username == 'False' || $username == ''){
		$username = 'Login';
	}else{
		$username = '<img src="images\settings.png" class="ui-btn-center" style="width:10px;height:10px"/>&nbsp;&nbsp;&nbsp;'.$_SESSION['username'];
	}
}else{
	$username = 'Login';
	$userid = -1;
}
?>	
<script>
/*
window.onunload = function () {
    $.ajax({
		type: "POST",
		url: "db_calls/Logout",
		cache: false
	});
};*/
</script>

<html>
	<head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
		<title>logmenow</title>
		<link rel="stylesheet" type="text/css" href="/css/styletheme.css">
		<link rel="shortcut icon" href="/images/favicon.ico" type="image/x-icon"/>
		<!--<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>-->
        
        <!-- Include meta tag to ensure proper rendering and touch zooming -->
        <meta name="viewport" content="width=device-width, initial-scale=1">
        
        <!-- Include the jQuery library -->
        <!--<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>-->
		<script src="/scripts/jquery-1.11.3.min.js"></script>
		
        <!-- Include the jQuery Mobile library -->
        <!--<script src="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>-->
		<script src="/scripts/jquery.mobile-1.4.5.min.js"></script>
		
		<!-- Include jQuery Mobile stylesheets -->
        <!--<link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css">-->
		<link rel="stylesheet" href="/css/jquery.mobile-1.4.5.min.css">
		<script type="text/javascript" src="/scripts/jquery.qrcode.min.js"></script>
		<script type="text/javascript" src="/scripts/jquery.jqChart.min.js"></script>
		<script type="text/javascript" src="/scripts/jquery.jqRangeSlider.min.js"></script>
		<script type="text/javascript" src="/scripts/jquery.mousewheel.js"></script>
		
		<link rel="stylesheet" href="/css/jquery.jqChart.css">
		<link rel="stylesheet" type="text/css" href="/css/jquery.jqRangeSlider.css" />
		<link rel="stylesheet" type="text/css" href="/css/jquery-ui-1.10.4.min.css" />
	</head>
	<body>
		<label id="userid" style="display:none"><?php echo $userid; ?></label>
		<label id="usernamehidden" style="display:none"><?php if(isset($_SESSION['username'])) echo $_SESSION['username']; ?></label>
		<label id="userphonehidden" style="display:none"><?php if(isset($_SESSION['phonenumber'])) echo $_SESSION['phonenumber']; ?></label>
		
		<!--<div data-role="header">
		<h1>Insert Page Title Here</h1>
		</div>-->
		