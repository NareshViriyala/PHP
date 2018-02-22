<?php 
include "header.php";
include "db_calls/globalvariables.php";

$id = $_REQUEST['entityid'];
if($id == null){
	//echo $id;
	header("Location: home.php");
    return;
}
$hospinfoarray = json_decode(@file_get_contents($webserviceurl.'GetEntityDetails.php?id='.$id),true);
$doctinfoarray = json_decode(@file_get_contents($webserviceurl.'GetDoctorDetails.php?id='.$id), true);
$hospimage = @file_get_contents($webserviceurl.'GetEntityImage.php?id='.$id);
$doctimage = @file_get_contents($webserviceurl.'GetDoctorImage.php?id='.$id);
$doctqload = json_decode(@file_get_contents($webserviceurl.'GetDoctorQLoadSelf.php?id='.$id.'&userid='.$userid), true);
$businesshours = json_decode(@file_get_contents($webserviceurl.'GetBusinessHours.php?id='.$id), true);
$entityinfo = $hospinfoarray[0];
$doctinfo = $doctinfoarray[0];
$waittime = $doctqload[0]['AWT'];
$h = floor($waittime / 60);
if($h < 10) $h = '0'.$h;	
$m = ($waittime % 60);
if($m < 10) $m = '0'.$m;

//var_dump($doctqload);	
?>
<script>
	function yettoimplement(){
		alert('yettoimplement');
	}
	
	function openappointmentpopup(){
		//alert($("#userid").html());
		if($("#login").html() == "Login"){
			$("#loginreason").html("Please login to take appointment:");
			$( "#popupsuggestlogin" ).popup("open");
		}
		else{
			/*
			geolocation.location(function (returninfo) {
				if(returninfo['status'] == 'Error'){
					$("#apptinfo").show();
					$("#apptinfo").html(returninfo['info']);
					$("#btntakeappt").prop('disabled', true).addClass('ui-disabled');
					$("#popupappointment").popup("open");
					return;
				}
				if(!inrange(<?php echo $entityinfo['Lat']; ?>, <?php echo $entityinfo['Long']; ?>, returninfo['latitude'], returninfo['longitude'], <?php echo $entityinfo['PD']; ?>)){
					$("#apptinfo").show();
					$("#apptinfo").html("We do not find you inside our hospital.<br/>You cannot take the appointment.");
					$("#btntakeappt").prop('disabled', true).addClass('ui-disabled');
					$("#popupappointment").popup("open");
					return;
				}
				$( "#popupappointment" ).popup("open");
			});
			*/
			$( "#popupappointment" ).popup("open");
		}
	}
	
	function takeappointment() {
	
		if(validatename($('#patientname').val())){
			$('#patientname').parent().css('border-color','green');
		}else{
			$('#patientname').parent().css('border-color','red');
			$("#apptinfo").show();
			$("#apptinfo").html("invalid patient name.");
			return;
		}
		
		if(validateage("years", $('#ay').val())){
			$('#ay').parent().css('border-color','green');
			if($('#ay').val() == "")
				$('#ay').val("0");
		}else{
			$('#ay').parent().css('border-color','red');
			$("#apptinfo").show();
			$("#apptinfo").html("invalid age in years.");
			return;
		}
		
		if(validateage("months", $('#am').val())){
			$('#am').parent().css('border-color','green');
			if($('#am').val() == "")
				$('#am').val("0");
		}else{
			$('#am').parent().css('border-color','red');
			$("#apptinfo").show();
			$("#apptinfo").html("invalid age in months.");
			return;
		}
		
		if($('#am').val() == "0" && $('#ay').val() == "0"){
			$('#am').parent().css('border-color','red');
			$('#ay').parent().css('border-color','red');
			$("#apptinfo").show();
			$("#apptinfo").html("both age year and month can not be 0.");
			return;
		}
		
		if($("#gendergroup :radio:checked").val() == null){
			$("#apptinfo").show();
			$("#apptinfo").html("Select gender.");
			return;
		}
		
		var DocGuid = <?php echo '"'.$id.'";';?>
		var PatientName = $('#patientname').val();
		var AgeYear = $('#ay').val();
		var AgeMonth = $('#am').val();
		var Gender = ($("#gendergroup :radio:checked").val() == "Male")?1:0;
		var PatientDeviceID = $('#userid').html();
		var PatientPhone = $('#userphonehidden').html();
		var CurrApptID = ($('#apptid').html() == "N\\A")?"0":$('#apptid').html();
		//alert(DocGuid+"--"+PatientName+"--"+AgeYear+"--"+AgeMonth+"--"+Gender+"--"+PatientDeviceID+"--"+CurrApptID);
		//alert($('#apptid').html());
		var jsoninput = "{\"DocGuid\":\""+DocGuid+"\",\"PatientName\":\""+PatientName+"\",\"AgeYear\":\""+AgeYear+"\",\"AgeMonth\":\""+AgeMonth+"\",\"Gender\":\""+Gender+"\",\"PatientDeviceID\":\""+PatientDeviceID+"\",\"CurrApptID\":\""+CurrApptID+"\",\"PatientPhone\":\""+PatientPhone+"\"}";
		//console.log(jsoninput);
		//console.log('localhost:90/db_calls/AddDoctorAppointment?json='+jsoninput);
		//return;
		$.ajax({
			type: "POST",
			url: "db_calls/AddDoctorAppointment",
			data: { 'json': jsoninput },
			cache: false,
			success: function (data, status)
			{
				var json = JSON.parse(data);
				$("#pup_apptid").html(json[0]['ApptID']);
				$("#apptid").html(json[0]['ApptID']);
				$("#pup_qcnt").html(json[0]['Qcnt']);
				$("#btntakeapptmain").html("Edit appointment");
				var qtime = json[0]['AWT']
				var hr = Math.floor(qtime / 60);
				if(hr < 10) hr = '0'+ hr;	
				var mn = (qtime % 60);
				if(mn < 10) mn = '0'+mn;
				
				$("#pup_waittime").html(hr+":"+mn+":00");
				
				$("#popupappointment").popup("close");
				qcntclick();
				/*
				$("#popupappointment").on("popupafterclose", function () {
					setTimeout(function(){
						$( "#popupsetappt" ).popup("open");
					}, 100);
				});
				*/
			},
			error: function (xhr, desc, err)
			{
				alert("falied");
			}
		});	
	}

	function qcntclick(){
		$("#p_qcnt").hide();
		$("#img_qcnt").show();
		//$("#qcnt").animate({box-shadow: "3px 3px 3px white"});
		//alert($("#userid").html());
		//console.log('localhost:90/db_calls/GetDoctorQLoadSelf?id=4,userid='+$("#userid").html());
		//return;
		$.ajax({
			type: "POST",
			url: "db_calls/GetDoctorQLoadSelf",
			data: { 'id': '<?php echo $id;?>', 'userid': ''+$("#userid").html()+'' },
			cache: false,
			success: function (data, status)
			{
				//console.log(data);
				var json = JSON.parse(data);
				
				$("#p_qcnt").html(json[0]['Qcnt']);
				var qtime = json[0]['AWT']
				var hr = Math.floor(qtime / 60);
				if(hr < 10) hr = '0'+ hr;	
				var mn = (qtime % 60);
				if(mn < 10) mn = '0'+mn;
				
				$("#p_waittime").html(hr+":"+mn+":00");
				if(json[0]['ApptID'] == 0){
					$("#apptid").html("N\\A");
					$("#apptdetails").hide();
					$("#btntakeapptmain").html("Take appointment");
					$("#patientname").val('');
					$("#ay").val('');
					$("#am").val('');
					$("#rbmale").prop( "checked", false ).checkboxradio( "refresh" );
					$("#rbfemale").prop( "checked", false ).checkboxradio( "refresh" );
				}
				else{
					$("#apptdetails").show();
					$("#apptid").html(json[0]['ApptID']);
					$("#btntakeapptmain").html("Edit appointment");
					
					$("#patientname").val(json[0]['PatientName']);
					$("#p_pname").html("Patient Name: "+json[0]['PatientName']);
					
					$("#ay").val(json[0]['AgeYear']);
					$("#am").val(json[0]['AgeMonth']);
					$("#p_page").html("Age: "+json[0]['AgeYear']+" years "+json[0]['AgeMonth']+" months");
					
					if(json[0]['Gender'] == 1){
						$("#rbmale").prop( "checked", true ).checkboxradio( "refresh" );
						$("#p_gender").html("Gender: Male");
					}else{
						$("#rbfemale").prop( "checked", true ).checkboxradio( "refresh" );
						$("#p_gender").html("Gender: Female");
					}
					
					$("#p_appttime").html("Appt Time: "+json[0]['ApptTime']);
				}
				$("#p_qcnt").show();
				$("#img_qcnt").hide();
			},
			error: function (xhr, desc, err)
			{
				$("#p_qcnt").show();
				$("#img_qcnt").hide();
			}
		});
	}
		
	$(document).ready(function(event) {
		qcntclick();
		$("#btncanclesavedappt").click(function (e) {
			$( "#popupconfrmcancelappt" ).popup("open");
		});
		
		$("#pup_btncapptyes").click(function (e) {
			//console.log("cancle appt");
			
			var jsoninput = '{"ApptID":"'+$("#apptid").html()+'","CallType":"UserCancelled","CallFrom":"0","DeviceID":"'+$('#userid').html()+'"}'
			$.ajax({
				type: "POST",
				url: "db_calls/SetDoctorAppointment",
				data: { 'json': jsoninput },
				cache: false,
				success: function (data, status)
				{
					//console.log(data);
					if(data.toLowerCase() == "success"){
						qcntclick();
					}
				},
				error: function (xhr, desc, err)
				{
					alert("Failure::"+err);
				}
			});
			$( "#popupconfrmcancelappt" ).popup("close");
		});
		
		//var elapsed_seconds = <?php echo $doctqload[0]['AWT']?>*60;
		//alert(time[0]+'--'+time[1]+'--'+time[2]+'--'+time[0]*3600+time[1]*60+time[2]*1);
		setInterval(function() {
			var time = $("#p_waittime").html().split(':')
			var elapsed_seconds = time[0]*3600+time[1]*60+time[2]*1;
			elapsed_seconds = elapsed_seconds - 1;
			if(elapsed_seconds > 0)
				$('#p_waittime').text(get_elapsed_time_string(elapsed_seconds));
		}, 1000);
		
		function get_elapsed_time_string(total_seconds) {
			  function pretty_time_string(num) {
				return ( num < 10 ? "0" : "" ) + num;
			  }

			  var hours = Math.floor(total_seconds / 3600);
			  total_seconds = total_seconds % 3600;

			  var minutes = Math.floor(total_seconds / 60);
			  total_seconds = total_seconds % 60;

			  var seconds = Math.floor(total_seconds);

			  // Pad the minutes and seconds with leading zeros, if required
			  hours = pretty_time_string(hours);
			  minutes = pretty_time_string(minutes);
			  seconds = pretty_time_string(seconds);

			  // Compose the string for display
			  var currentTimeString = hours + ":" + minutes + ":" + seconds;

			  return currentTimeString;
		}
	});
</script>
<div id="mainwin" data-role="main" class="ui-content" style="padding-left:7px;padding-right:7px;">
	<div data-role="collapsibleset" data-theme="a" data-mini="true">
		<div data-role="collapsible" data-collapsed="true" id="docdetail" >
			<h3 >Doctor & Hospital details</h3>
			<div class="ui-grid-d ui-responsive" data-mini="true">
				<div class="ui-block-a ui-shadow" style="margin-bottom:10px;background-color:#F5F5F5;padding:3px;border: 1px solid #3F51B5">
					<img src="<?php echo $doctimage;?>" alt="image" id="docimage" style="display:table-cell;vertical-align:middle;margin:auto;">					
				</div>
				<div class="ui-block-b" style="margin-bottom:10px;padding:1px;background-color:#F5F5F5;border: 1px solid #3F51B5">
					<table data-role="table" class="ui-responsive ui-shadow" id="doctorinfo" style="font-size:.8em">
					  <thead>
						<tr><th data-priority="1"></th></tr>
					  </thead>
					  <tbody >
						<tr><td style="padding-left:3px;font-style:bold;color:#3F51B5;"><?php echo $doctinfo['Dname'].' ('.$doctinfo['Deg'].')'; ?></td></tr>
						<tr><td style="padding-left:3px;padding-right:3px"><b>Specialty:</b> <?php echo $doctinfo['Spec']; ?></td></tr>
						<tr><td style="padding-left:3px;padding-right:3px"><b>ConsultationFee:</b> <?php echo $doctinfo['Fee']."/-"; ?></td></tr>
						<tr><td style="padding-left:3px;padding-right:3px"><b>AvgConsultationTime:</b> <?php echo $doctinfo['Act']." minutes"; ?></td></tr>
						<tr><td style="padding-left:3px;padding-right:3px"><b>Mobile:</b> <?php echo $doctinfo['Mobile']; ?></td></tr>
						<tr><td style="padding-left:3px;padding-right:3px"><b>Work:</b> <?php echo $doctinfo['Land']; ?></td></tr>
						<tr><td style="padding-left:3px;padding-right:3px"><b>Email:</b> <?php echo $doctinfo['email']; ?></td></tr>
					  </tbody>
					</table>
				</div>				
				<div class="ui-block-c" style="margin-bottom:10px;padding:1px;background-color:#F5F5F5;border: 1px solid #3F51B5">
					<table data-role="table" class="ui-responsive ui-shadow" id="businesshours" style="font-size:.8em">
					  <thead><tr><th></th><th></th></tr></thead>
					  <tbody>					  
						<?php
							echo '<tr><td style="padding-left:2px;font-style:bold;color:#3F51B5;">Consultation timings</td></tr>';
							foreach($businesshours as $item) { 
								$day = $item['Day'];
								if($day == 'Thu')
									$day = 'Thu&nbsp;';
								else if($day == 'Tue')
									$day = 'Tue&nbsp;';
								else if($day == 'Fri')
									$day = 'Fri&nbsp;&nbsp;&nbsp;';
								else if($day == 'Sat')
									$day = 'Sat&nbsp;&nbsp;';
								else if($day == 'Sun')
									$day = 'Sun&nbsp;';									
								echo '<tr>'; 
								echo '<td style="padding-left:2px"><b>'.$day.'</b>&emsp;'.$item['BH'].'</td>';
								echo '</tr>'; 
							}
						?>
					  </tbody>
					</table>
				  </div>
				<div class="ui-block-d ui-shadow" style="margin-bottom:10px;background-color:#F5F5F5;padding:3px;border: 1px solid #3F51B5">
					<img src="<?php echo $hospimage;?>" alt="image" style="display:table-cell;vertical-align:middle;margin:auto;">
				</div>
				<div class="ui-block-e" style="margin-bottom:10px;padding:1px;background-color:#F5F5F5;border: 1px solid #3F51B5">
					<table data-role="table" class="ui-responsive ui-shadow" id="entityaddress" style="font-size:.8em">
					  <thead><tr><th data-priority="1"></th></tr></thead>
					  <tbody>
						<tr><td style="font-style:bold;color:#3F51B5;text-align:center;"><?php echo $entityinfo['Ename']; ?></td></tr>
						<tr>
							<tr><td style="padding-left:2px;padding-right:2px"><?php echo $entityinfo['Add1']; ?></td></tr>
						</tr>
						<tr>
							<tr><td style="padding-left:2px;padding-right:2px"><?php echo $entityinfo['Add2']; ?></td></tr>
						</tr>
						<tr>
							<tr><td style="padding-left:2px;padding-right:2px"><?php echo $entityinfo['City'].', '.$entityinfo['State'].', '.$entityinfo['Country']; ?></td></tr>
						</tr>
						<tr>
							<tr><td style="padding-left:2px;padding-right:2px">Pin: <?php echo $entityinfo['Zip']; ?></td></tr>
						</tr>
						<tr>
							<tr><td style="padding-left:2px;padding-right:2px">Contact No: <?php echo $entityinfo['ContactNo1']; ?></td></tr>
						</tr>
						<tr>
							<tr><td style="padding-left:2px;padding-right:2px"><?php echo $entityinfo['EmailID']; ?></td></tr>
						</tr>
						<tr>
							<tr><td style="padding-left:2px;padding-right:2px"><?php echo $entityinfo['WebSite']; ?></td></tr>
						</tr>
					  </tbody>
					</table>
				</div>
			</div>
		</div>
    </div>
	
	
	<div data-role="collapsibleset" data-theme="a" data-mini="true">
      <div data-role="collapsible" data-collapsed="false" >
        <h3>Queue time & Consultation hours</h3>
		<span>
			<div style="display:block;margin:auto;text-align:center;">
				<p>Appointment #:<font id="apptid" color=red></font></p>
				<p style="margin-bottom:0px;margin-top:0px;">Waiting Time: <font id="p_waittime" color=red></font></p>	
				<div id="qcnt" onclick="qcntclick();" style="margin-bottom:16px;margin-top:16px;margin-left:auto;margin-right:auto;">
					<p id="p_qcnt" style="display:block;margin:0px;"></p>
					<img id="img_qcnt" src="/images/loading.gif" style="display:none;margin:auto;">
				</div>
				<div id="apptdetails" style="box-shadow: 1px 3px 3px grey;">
					<p id="p_pname" style="font-style:bold;color:#3F51B5;margin-bottom:0px;margin-top:0px;"></p>
					<p id="p_page" style="margin-bottom:0px;margin-top:0px;"></p>
					<p id="p_gender" style="margin-bottom:0px;margin-top:0px;"></p>
					<p id="p_appttime" style="margin-bottom:0px;margin-top:0px;"></p>
					<a id="btncanclesavedappt" href="#" class="ui-btn ui-btn-inline ui-corner-all ui-icon-delete ui-btn-icon-top" style="margin:8px;font-size:0.8em;">Cancel</a>
				</div>
			</div>
		</span>
      </div>
    </div>

	<div id="optionbtns" style="margin-bottom:30px" data-mini="true">
		<a id="btnback" href="#" href="#" data-rel="back"  data-mini="true" class="ui-btn ui-btn-inline ui-corner-all ui-icon-back ui-btn-icon-left">Back</a>
		<a id="btntakeapptmain" style="float:right;margin-right:0px" data-mini="true" class="ui-btn ui-btn-inline ui-corner-all ui-icon-grid ui-btn-icon-right" onclick="openappointmentpopup();">Take appointment</a>
	</div>
	
	<div data-role="popup" id="popupappointment" class="ui-content" data-position-to="#mainwin" data-transition="slideup">
		<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>
		
		<label id="apptinfo" style="display:none;font-size:1em;color:red;">Custom info</label>
		<label for="appointment"><u>Appointment</u>:</label>
		
		<label for="patientname">Name:</label>
		<input type="text" name="patientname" id="patientname" placeholder="Patient Name" />

		<fieldset class="ui-grid-a" data-mini="true">
			<div class="ui-block-a">
				<fieldset data-role="fieldcontain" style="padding-right:3px;margin:0px;">
				  <label for="date">Age:</label>
				  <input type="number" name="ay" id="ay" placeholder="Years" min="0" max="127">
				</fieldset>
			</div>
			<div class="ui-block-b">
				<fieldset data-role="fieldcontain" style="padding-left:3px;margin:0px;">
					<label for="time">&nbsp;</label>
					<input type="number" name="am" id="am" placeholder="Months" min="0" max="11">
				</fieldset>
			</div>
		</fieldset>

		<fieldset data-role="controlgroup" data-type="horizontal" data-mini="true" id="gendergroup">
			<legend>Gender:</legend>
			<!--<input type="radio" name="rbmale" id="rbmale" value="Male" checked="checked">-->
			<input type="radio" name="rbmale" id="rbmale" value="Male">
			<label for="rbmale">&nbsp;&nbsp;&nbsp;&nbsp;Male&nbsp;&nbsp;</label>
			<input type="radio" name="rbmale" id="rbfemale" value="Female">
			<label for="rbfemale">Female</label>    
		</fieldset>
		
		<div id="apptbtns" >
			<a id="btncancleappt" href="#" class="ui-btn ui-btn-inline ui-corner-all ui-icon-back ui-btn-icon-left" onclick="$('#popupappointment').popup('close');">Cancel</a>
			<a id="btntakeappt" href="#" style="float:right;margin-right:0px" class="ui-btn ui-btn-inline ui-corner-all ui-icon-check ui-btn-icon-right" onclick="takeappointment();">Submit</a>
		</div>
	</div>
	
	<div data-role="popup" id="popupsetappt" class="ui-content" data-position-to="#mainwin" data-transition="slideup">
		<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>
		<div class="ui-content" style="display:block;margin:auto;text-align:center;">
			<p>Appointment #:<font id="pup_apptid" color=red></font></p>
			<p style="color:red;">Below is your Q number</p>
			<div id="popupqcnt" style="display:block;margin:auto;text-align:center;">
				<p id="pup_qcnt" style="display:block;margin:0px;"></p>
			</div>
			<p>Wait Time: <font id="pup_waittime" color=red></font></p>	
			<a href="#" class="ui-btn ui-btn-inline ui-corner-all" onclick="$('#popupsetappt').popup('close');">OK</a>	
		</div>
	</div>
	
	<div data-role="popup" id="popupconfrmcancelappt" class="ui-content" data-position-to="#mainwin" data-transition="slideup">
		<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>
		<div class="ui-content" style="display:block;margin:auto;text-align:center;">
			<p style="color:red;">Cancel appointment !!!<br/>Are you sure?</p>
			<a id="pup_btncapptno" href="#" class="ui-btn ui-btn-inline ui-corner-all" onclick="$('#popupconfrmcancelappt').popup('close');">&nbsp;No </a>
			<a id="pup_btncapptyes" href="#" class="ui-btn ui-btn-inline ui-corner-all">Yes</a>			
		</div>
	</div>
</div>

<?php include "footer.php" ?>