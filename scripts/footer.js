        $("#fbsubmit").click(function (e) {
			if($('#txtareafeedback').val().length > 0);{
				$.ajax({
					type: "POST",
					url: "db_calls/AddUserFeedBack",
					data: { 'id': $('#userid').html(), 'feedback': $('#txtareafeedback').val() },
					cache: false
				});	
			}
			$('#feedbackpopup').popup('close');
		});
		
		
		function showLogin(){
			if($("#login").html() == "Login")
				$( "#popupLogin" ).popup("open");
			else
				$( "#popupLogout" ).popup("open");
		}
		
		/*
		function closeloginpopup(){
			//$.mobile.loading( "hide");
			$( "#popupLogin" ).popup("close");
		}
		

		$("#slcancel").click(function (e) {
			$( "#popupsuggestlogin" ).popup("close");
		});
		*/
		
		$("#history").click(function (e) {
			$('#popupLogout').popup('close');
			$("#popupLogout").on("popupafterclose", function () {
				window.location.href = "history";
			});
		});
		
		$("#slok").click(function (e) {
			$( "#popupsuggestlogin" ).popup("close");
			
			$("#popupsuggestlogin").on("popupafterclose", function () {
				setTimeout(function(){
					$( "#popupLogin" ).popup("open");
				}, 100);

			});
		});
		
		/*
		//$("#popupLogin").on("popupafterclose", function () {
			//any action you want like opening another popup
			//$.mobile.loading( "hide");
		//})
		*/
		
		//new user link click
		$("#newuser").click(function (e) {
		
			if($('#divconfipassword').is(":visible")){
				//$("#divconfipassword").toggle();
				//$("#divemail").toggle();
				//$("#divname").toggle();
				$("#divconfipassword").hide();
				$("#divemail").hide();
				$("#divname").hide();
				$("#divotp").hide();
				$("#lblinfo").hide();	
			}else{
				$("#divconfipassword").show();
				$("#divemail").show();
				$("#divname").show();
				$("#divpassword").show();
				$("#lblinfo").hide();	
			}
			
			//$('#dddd').css('display', 'none').parent('div').parent('.ui-select').css('display', 'none');
			//$('select').selectmenu('refresh');
		});
		
		//forgot password link click
		$("#forgotpassword").click(function (e) {
			//var val = $('#phonenumber').val();
			
			$("#phonenumber").show();

			if($('#divpassword').is(":visible")){	
			
				$("#divname").hide();						
				$('#divpassword').hide()
				$("#divconfipassword").hide();
				$("#divotp").hide();
				$("#divemail").hide();
				$("#lblinfo").html("Enter phone and click Sign in");
				$("#lblinfo").show();				
			}else{
				$("#phonenumber").show();
				$("#divpassword").show();				
				$("#lblinfo").hide();					
			}
			
			
			/*
			if(validatephonenumber($('#phonenumber').val())){
				$('#phonenumber').parent().css('border-color','green');
				//$('#password').attr("placeholder", "Enter OTP");
				//$("#lblinfo").text("OTP sent to your mobile.");
				//$("#lblinfo").show();
			}else{
				$('#phonenumber').val("");
				$('#phonenumber').parent().css('border-color','red');
				$('#phonenumber').attr("placeholder", "Enter phone number");
			}	
			
			if(validateemail($('#email').val())){
				
				$('#email').parent().css('border-color','green');
			}else{
				$('#email').val("");
				$('#email').parent().css('border-color','red');
				$('#email').attr("placeholder", "Enter registered email");
			}
			*/
		});
		
		function signin(){
			
			//validate name if visible
			if($('#name').is(":visible")){
				if(validatename($('#name').val()))
					$('#name').parent().css('border-color','green');
				else{
					//alert("Invalid name.");
					$('#lblinfo').parent().css('border-color','red');
					$("#lblinfo").text("Invalid name.");
					$("#lblinfo").show();
					return;
				}
			}
			
			//validate phone number
			if(validatephonenumber($('#phonenumber').val())){
				$('#phonenumber').parent().css('border-color','green');
			}else{
				$('#phonenumber').parent().css('border-color','red');
				$("#lblinfo").text("Invalid phone number.");
				$("#lblinfo").show();
				return;
			}
			
			//validate email if visible
			if($('#email').is(":visible")){
                if(!validatepassword($('#email').val())){
    				$('#email').parent().css('border-color','red');
    				$("#lblinfo").text("Invalid email.");
    				$("#lblinfo").show();
    				return;
    			}
    			else{
    				$('#email').parent().css('border-color','green');
    				$("#lblinfo").hide();
    			}
            }
			
			//validate password
			if($('#divpassword').is(":visible")){
				if(!validatepassword($('#password').val())){
					$('#password').parent().css('border-color','red');
					$("#lblinfo").text("Password criteria did not match.");
					$("#lblinfo").show();
					return;
				}else{
					$('#password').parent().css('border-color','green');
					$("#lblinfo").hide();
				}
			}
            
            //validate confirm password if visible
            if($('#confirmpassword').is(":visible")){
                var valcp = $('#confirmpassword').val();
                var valp = $('#password').val();
                
                if(valcp != valp){
    				$('#confirmpassword').parent().css('border-color','red');
    				$("#lblinfo").text("Passwords did not match.");
    				$("#lblinfo").show();
    				return;
    			}
    			else{
    				$('#confirmpassword').parent().css('border-color','green');
    				$("#lblinfo").hide();
    			}
            }
			
			//validate OTP
			if($('#divotp').is(":visible")){
				if($('#inputotp').val() && $('#inputotp').val() > 999 && $('#inputotp').val() < 10000){
					$('#inputotp').parent().css('border-color','green');
					$("#lblinfo").hide();
				}else{
					$('#inputotp').parent().css('border-color','red');					
					$("#lblinfo").text("Invalid OTP.");
					$("#lblinfo").show();
					return;
				}
			}
            
			$.mobile.loading( "show", {text: "Loading.."});
			if($('#email').is(":visible")){ //new user login action
				if($('#divotp').is(":visible")){ //sign in click after reciving OTP
					$.ajax({
						type: "POST",
						url: "db_calls/AddWebUser",
						data: { 'json': '{"name":"'+$('#name').val()+'","phone":"'+$('#phonenumber').val()+'","pin":"'+$('#password').val()+'","email":"'+$('#email').val()+'","otp":"'+$('#inputotp').val()+'"}' },
						cache: false,
						success: function (data, status)
						{
							$.mobile.loading( "hide");
							//var json = JSON.parse(data);
							//console.log(data);
							if(data.toLowerCase() == "invalid otp"){
								$("#lblinfo").show();
								$("#lblinfo").html("Invalid OTP.");
							}else{
								var settings_iconhtml = "<img src=\"images/settings.png\" class=\"ui-btn-center\" style=\"width:10px;height:10px\"/>&nbsp;&nbsp;&nbsp;";
								$("#login").html(settings_iconhtml+$('#name').val());
								$("#userid").html(data);
								$("#usernamehidden").html($('#name').val());
								$("#userphonehidden").html($('#phonenumber').val());
								//alert(json[0]['id']);
								$("#popupLogin").popup("close");
								switch(location.pathname.split('/').slice(-1)[0].replace(".php","")){
									case 'hospital':
										qcntclick();
									break;
									case 'restaurant':
										defaultorder();
									break;
									case 'securitycheck':
										getcontent();
									break;
									default:
									break;
								}
							}
						},
						error: function (xhr, desc, err)
						{
							$.mobile.loading( "hide");
							$("#lblinfo").show();
							$("#lblinfo").html("Something is wrong.<br/>Please try after sometime.");
						}
					});
				}else{ //sign in click before reciving OTP
					$.ajax({
						type: "POST",
						url: "db_calls/AddWebUser",
						data: { 'json': '{"name":"'+$('#name').val()+'","phone":"'+$('#phonenumber').val()+'","pin":"'+$('#password').val()+'","email":"'+$('#email').val()+'","otp":0}' },
						cache: false,
						success: function (data, status)
						{
							$.mobile.loading( "hide");
							//var json = JSON.parse(data);
							if(data.toLowerCase() == "user already exists"){
								$("#lblinfo").show();
								$("#lblinfo").html("This phone number is already registered.");
							}else{
								$("#lblinfo").show();
								$("#divotp").show();
								$('#inputotp').focus();
								$("#lblinfo").html("Enter OTP and click Sign in.");
							}
						},
						error: function (xhr, desc, err)
						{
							$.mobile.loading( "hide");
							$("#lblinfo").show();
							$("#lblinfo").html("Something is wrong.<br/>Please try after sometime.");
						}
					});
				}
			}else if(($("#phonenumber").is(":visible") && !$('#password').is(":visible")) || ($("#phonenumber").is(":visible") && $('#password').is(":visible") && $('#divotp').is(":visible"))){ //forgot password action				
				$.ajax({
					type: "POST",
					url: "db_calls/ForgotPassword",
					data: { 'json': '{"phone":"'+$('#phonenumber').val()+'","newpassword":"'+$('#password').val()+'","otp":"'+$('#inputotp').val()+'"}' },
					cache: false,
					success: function (data, status)
					{
						$.mobile.loading("hide");
						if(data.toLowerCase() == "enter otp"){
							$("#lblinfo").show();
							$("#divotp").show();
							$("#divpassword").show();
							$('#password').focus();
							$("#lblinfo").html("Enter OTP and new password.");
						}else if(data.indexOf('-') >= 0){
							var settings_iconhtml = "<img src=\"images/settings.png\" class=\"ui-btn-center\" style=\"width:10px;height:10px\"/>&nbsp;&nbsp;&nbsp;";
							$("#login").html(settings_iconhtml+data.substr(data.indexOf('-')+1));
							$("#userid").html(data.substr(0,data.indexOf('-')));
							$("#usernamehidden").html(data.substr(data.indexOf('-')+1));
							$("#userphonehidden").html($('#phonenumber').val());
							$("#popupLogin").popup("close");
							switch(location.pathname.split('/').slice(-1)[0].replace(".php","")){
								case 'hospital':
									qcntclick();
								break;
								case 'restaurant':
									defaultorder();
								break;
								case 'securitycheck':
									getcontent();
								break;
								default:
								break;
							}							
						}else{
							$("#lblinfo").show();
							$("#lblinfo").html(data);
						}
					},
					error: function (xhr, desc, err)
					{
						$.mobile.loading( "hide");
						$("#lblinfo").show();
						$("#lblinfo").html("Something is wrong.<br/>Please try after sometime.");
					}
				});
			}else{ //normal sign in
				//alert ("normal sign in");
				$.ajax({
					type: "POST",
					url: "db_calls/ValidateWebUser",
					data: { 'json': '{"phone":"'+$('#phonenumber').val()+'","pin":"'+$('#password').val()+'"}' },
					cache: false,
					success: function (data, status)
					{
						$.mobile.loading("hide");
						//alert(data);
						var json = JSON.parse(data);
						if(json[0]['result'].toLowerCase() == "user does not exists"){
							$("#lblinfo").show();
							$("#lblinfo").html("This phone number is not registered.<br/>Click <u>New User</u> to register.");
						}else if(json[0]['result'].toLowerCase() == "false"){
							$("#lblinfo").show();
							$("#lblinfo").html("invalid phone or password.");
						}else{//valid login
							var settings_iconhtml = "<img src=\"images/settings.png\" class=\"ui-btn-center\" style=\"width:10px;height:10px\"/>&nbsp;&nbsp;&nbsp;";
							$("#usernamehidden").html(json[0]['result']);
							$("#userphonehidden").html($('#phonenumber').val());
							$("#login").html(settings_iconhtml+json[0]['result']);
							$("#userid").html(json[0]['id']);							
							//alert(json[0]['result']);
							$("#popupLogin").popup("close");
							switch(location.pathname.split('/').slice(-1)[0].replace(".php","")){
								case 'hospital':
									qcntclick();
								break;
								case 'restaurant':
									defaultorder();
								break;
								case 'securitycheck':
									getcontent();
								break;
								default:
								break;
							}
							
							//alert(location.pathname.split('/').slice(-1)[0].replace(".php",""))
							/*
							$("#popupLogin").on("popupafterclose", function () {
								setTimeout(function(){
									location.reload(true);
								}, 100);

							});
							*/
						}
					},
					error: function (xhr, desc, err)
					{
						$.mobile.loading( "hide");
						$("#lblinfo").show();
						$("#lblinfo").html("Something is wrong.<br/>Please try after sometime.");
					}
				});
			
				//alert('sign in request sent');
			}
			//$('#btnsignin').buttonMarkup({ icon: "lock" });
			//$( "#popupLogin" ).popup("close");
		}
		
		//name input validation
		$('#name').keyup(function(event) {
			var val = $('#name').val();
			if(validatename(val)){
				$('#name').parent().css('border-color','green');
				$("#lblinfo").hide();
			}
			else
				$('#name').parent().css('border-color','red');
		
			if (event.keyCode == 13 ) {
				$('#phonenumber').focus();
			}
		});	
		
		//phone input validation
		$('#phonenumber').keyup(function(event) {
			var val = $('#phonenumber').val();
			if(validatephonenumber(val)){
				$('#phonenumber').parent().css('border-color','green');
				$("#lblinfo").hide();
			}
			else
				$('#phonenumber').parent().css('border-color','red');
		
			if (event.keyCode == 13 ) {
				if($('#email').is(":visible"))
					$('#email').focus();
				else	
					$('#password').focus();
			}
		});	
		
		//password input validation
		$('#password').keyup(function(event) {
			var val = $('#password').val();
			if(validatepassword(val)){
				$('#password').parent().css('border-color','green');
                $("#lblinfo").hide();
			}
			else
				$('#password').parent().css('border-color','red');
		
			if (event.keyCode == 13 ) {
			    if($('#confirmpassword').is(":visible"))
					$('#confirmpassword').focus();
				else	
					signin();
			}
		});
        
		//email input validation
        $('#email').keyup(function(event) {
			var val = $('#email').val();
			if(validateemail(val)){
				$('#email').parent().css('border-color','green');
                $("#lblinfo").hide();
			}
			else{
				$('#email').parent().css('border-color','red');
                //$("#lblinfo").text("Invalid email.");
				//$("#lblinfo").show();
            }
			if (event.keyCode == 13 ) {
				$('#password').focus();
			}
		});
        
		//confirm password input validation
        $('#confirmpassword').keyup(function(event) {
			var valcp = $('#confirmpassword').val();
            var valp = $('#password').val();
            //alert(valp+'-'+valcp);
			if(valcp == valp && $.trim(valp) != ""){
				$('#confirmpassword').parent().css('border-color','green');
			}
			else{
				$('#confirmpassword').parent().css('border-color','red');
                //$("#lblinfo").text("Passwords do not match.");
				//$("#lblinfo").show();
            }
		
			if (event.keyCode == 13 ) {
				signin();
			}
		});
		
		//otp input validation
        $('#inputotp').keyup(function(event) {			
			if (event.keyCode == 13 ) {
				signin();
			}
		});		
		
		$("#logout").click(function (e) {
		
			$.ajax({
				type: "POST",
				url: "db_calls/Logout",
				cache: false,
				success: function (data, status)
				{
					window.location.href = "/";
				},
				error: function (xhr, desc, err)
				{
					window.location.href = "/";
				}
			});
			$( "#popupLogout" ).popup("close");
		});
		
		$("#changepassword").click(function (e) {
			$("#divchangepassword").toggle();
			//$( "#popupLogout" ).popup("close");
			
		});
		
		$("#btnchngpass").click(function (e) {
			if(!$('#currentpassword').val()){
				$('#chngpassowrdreason').show();
				$('#chngpassowrdreason').text('Current password?');
				return;
			}else	
				$('#chngpassowrdreason').hide();
				
			if(!$('#newpassword').val()){
				$('#chngpassowrdreason').show();
				$('#chngpassowrdreason').text('New password?');
				return;
			}else	
				$('#chngpassowrdreason').hide();
				
			if(!$('#confirmnewpassword').val()){
				$('#chngpassowrdreason').show();
				$('#chngpassowrdreason').text('Confirm new password?');
				return;
			}else	
				$('#chngpassowrdreason').hide();
				
			if($('#currentpassword').val() == $('#newpassword').val()){
				$('#chngpassowrdreason').show();
				$('#chngpassowrdreason').text('Old and new passwords can not be same.');
				return;
			}else{
				$('#chngpassowrdreason').hide();
			}	
				
			if($('#confirmnewpassword').val() != $('#newpassword').val()){
				$('#chngpassowrdreason').show();
				$('#chngpassowrdreason').text('New passwords do not match.');
				return;
			}else{
				$('#chngpassowrdreason').show();
				$('#chngpassowrdreason').text('Changing password....');
				$.mobile.loading( "show", {text: "Loading.."});
				$.ajax({
					type: "GET",
					url: "db_calls/ChangeWebUserPassword",
					data: { 'json': '{"userid":"'+$('#userid').html()+'","currentpin":"'+$('#currentpassword').val()+'","newpin":"'+$('#newpassword').val()+'"}' },
					cache: false,
					success: function (data, status)
					{
						$.mobile.loading( "hide");
						if(data.toLowerCase() == 'password changed.'){
							$('#chngpassowrdreason').text(data);
							setTimeout(function(){
								$('#chngpassowrdreason').hide();
								$('#currentpassword').val('');
								$('#newpassword').val('')
								$('#confirmnewpassword').val('')
								$("#divchangepassword").toggle();
								$( "#popupLogout" ).popup("close");
							}, 300);						
						}else
							$('#chngpassowrdreason').text(data);
					},
					error: function (xhr, desc, err)
					{
						$('#chngpassowrdreason').text('Something went wrong.');
						$.mobile.loading( "hide");
						setTimeout(function(){$( "#popupLogout" ).popup("close");}, 300);
					}
				});
				
			}			
		});
		
		$("#settings").click(function (e) {
			$( "#popupLogout" ).popup("close");			
		});


function validatephonenumber(val) {
	var filter = /^[789]\d{9}$/;
	if (filter.test(val))
		return true;
	else 
		return false;
}

function validateage(type, val){
	if(val == "")
		return true;
	
	var yearfilter = /^([0-9]|[1-9][0-9]|1[0-2][0-9])$/;
	var monthfilter = /^([0-9]|1[0-1])$/;

	if(type == "years" && yearfilter.test(val)){
		return true;
	}else if (type == "months" && monthfilter.test(val)){
		return true;
	}else{ 
		return false;
	}
}

function validatepassword(val){
	if(val.length > 3)
		return true;
	else
		return false;
}

function validatename(val){
	var filter = /^[a-zA-Z\s]+$/;
	if($.trim(val) == "")
		return false;
	if (filter.test(val))
		return true;
	else 
		return false;
}

function validateemail(val){
    var filter = /^[-a-zA-Z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/;
	if(filter.test(val))
		return true;
	else
		return false;
}

function validatedbo(val){
	
	var comp = val.split('/');
	var m = parseInt(comp[0], 10);
	var d = parseInt(comp[1], 10);
	var y = parseInt(comp[2], 10);
	var date = new Date(y,m-1,d);
	if (date.getFullYear() == y && date.getMonth() + 1 == m && date.getDate() == d) {
	  return true;
	} else {
	  return false;
	}
	
	/*
	var filter = /^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/;	
	if (filter.test(val))
		return true;
	else 
		return false;
	*/
}

function validatevehicleno(val){
	val = val.replace(/\s/g,'');
	//alert(val);
	var filter = /^([A-Za-z]{2}[0-9]{1,2}[A-Za-z]{1,2}[0-9]{1,4})|([A-Za-z]{3}[0-9]{1,4})$/;
	if (filter.test(val))
		return true;
	else 
		return false;
}

function validatemisc(val){
	val = val.replace(/\s/g,'');
	if (val.length == 0)
		return false;
	else 
		return true;
}

var longitude = 0.0;
var latitude = 0.0;
var alloweddistance = 0;

/*
function getCoords() {

    var deferred = $.Deferred();

    navigator.geolocation.getCurrentPosition(
		function (position) {
			deferred.resolve({
				longitude: position.coords.longitude,
				latitude: position.coords.latitude,
			});
		}, 
		function (error) {
			deferred.resolve({error
		});
    });

    return deferred.promise();
}
*/

var geolocation = (function() {
	'use strict';

	var geoposition;
	var options = {
		maximumAge: 1000,
		timeout: 15000,
		enableHighAccuracy: true
	};

	function _onSuccess (callback, position) {
		//console.log('DEVICE POSITION');
		//console.log('LAT: ' + position.coords.latitude + ' - LON: ' +  position.coords.longitude);
		//geoposition = position
		var returnmsg = JSON.parse('{"status":"Success","latitude":'+position.coords.latitude+',"longitude":'+position.coords.longitude+'}');
		callback(returnmsg);
	};

	function _onError (callback, error) {
		var errortext = "";
		switch(error.code) {
			case error.PERMISSION_DENIED:
				errortext = "cannot proceed further without accessing your location.<br/>Please enable location sharing from the settings of the browser."
				break;
			case error.POSITION_UNAVAILABLE:
				errortext = "Your location information is unavailable."
				break;
			case error.TIMEOUT:
				errortext = "The request to get your location timed out."
				break;
			case error.UNKNOWN_ERROR:
				errortext = "An unknown error occurred."
				break;
		}
		var returnmsg = JSON.parse('{"status":"Error","info":"'+errortext+'"}');
		callback(returnmsg);
	};
	
	function _templocation(callback, position){
		//console.log(position.loc.substr());
		var loc = position.loc;
		//console.log(loc);
		//console.log(loc.substr(loc.indexOf(',')+1));
		var returnmsg = JSON.parse('{"status":"Success","latitude":'+loc.substr(0, loc.indexOf(','))+',"longitude":'+loc.substr(loc.indexOf(',')+1)+'}');
		callback(returnmsg);
	};

	function _getLocation (callback) {
		//$.get("http://ipinfo.io", _templocation.bind(this, callback), "jsonp");
		
		navigator.geolocation.getCurrentPosition(
		_onSuccess.bind(this, callback),
		_onError.bind(this, callback), 
		options
		);
	}

	return {location: _getLocation }

}());

/*
function allowedlocation(latitude, longitute, distance) {
	this.longitude = longitute;
	this.latitude = latitude;
	alloweddistance = distance;
	
	
	
	getCoords().done(function (data) {
		var dist = getDistance(data['latitude'],data['longitude'],latitude,longitude)
		alert(dist+'----'+alloweddistance);
		if(dist <= alloweddistance)
			return true;
		else
			return false;
	}).fail(function (error) {
		switch(error.code) {
			case error.PERMISSION_DENIED:
				alert("cannot proceed further without accessing your location.");
				break;
			case error.POSITION_UNAVAILABLE:
				alert("Your location information is unavailable.");
				break;
			case error.TIMEOUT:
				alert("The request to get your location timed out.");
				break;
			case error.UNKNOWN_ERROR:
				alert("An unknown error occurred.");
				break;
		}
	});
	
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition, showError);
    } else {
        alert("Geolocation is not supported by your browser.");
    }
	
}

function showPosition(position) {
	var dist = getDistance(position.coords.latitude, position.coords.longitude, latitude, longitude);
	alert(dist+'----'+alloweddistance);
	if(dist <= alloweddistance)
		return true;
	else
		return false;
	//alert(getDistance(position.coords.latitude, position.coords.longitude, latitude, longitude));
    //alert ('Current lat:'+position.coords.latitude +'\nCurrent long: ' + position.coords.longitude + '\nEntity lat:'+Lat+'\nEntity long:'+Long);
}

function showError(error) {
    switch(error.code) {
        case error.PERMISSION_DENIED:
            alert("cannot proceed further without accessing your location.");
            break;
        case error.POSITION_UNAVAILABLE:
            alert("Your location information is unavailable.");
            break;
        case error.TIMEOUT:
            alert("The request to get your location timed out.");
            break;
        case error.UNKNOWN_ERROR:
            alert("An unknown error occurred.");
            break;
    }
}
*/

function inrange(lat1,lon1,lat2,lon2, alloweddistance){
	var actualdistance = getDistance(lat1,lon1,lat2,lon2);
	//alert("lat1:"+lat1+"\nlon1:"+lon1+"\nlat2:"+lat2+"\nlon2:"+lon2+"\nactualdistance:"+actualdistance+"\nalloweddistance"+alloweddistance);
	if(actualdistance <= alloweddistance)
		return true;
	else
		return false;
}

function getDistance(lat1,lon1,lat2,lon2) {
	var R = 6371; // Radius of the earth in km
	var dLat = deg2rad(lat2-lat1);  // deg2rad below
	var dLon = deg2rad(lon2-lon1); 
	var a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon/2) * Math.sin(dLon/2); 
	var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
	var d = R * c * 1000; // Distance in meters
	return d;
}

function deg2rad(deg) {
	return deg * (Math.PI/180)
}













