<?php include "header.php" ?>
<?php include "db_calls/globalvariables.php" ?>
<?php
$id = $_REQUEST['entityid'];
if($id == null){
	//echo $id;
	header("Location: home.php");
    return;
}
$entityinfoarray = json_decode(@file_get_contents($webserviceurl.'GetEntityDetails.php?id='.$id),true);
$entityimage = @file_get_contents($webserviceurl.'GetEntityImage.php?id='.$id);
$entityinfo = $entityinfoarray[0];
?>
<script>
var params = {};

function generateqr(){
	if(validateformdata()){
		var texttoqr = "0."+$("#userid").html();;
		var texttoshow = '<table data-role="table" class="ui-responsive ui-shadow"><tbody>';
		var texttopush = "<Data>";
		$.each( params, function( key, value ) {
			var j = JSON.parse(value)
			texttoqr = texttoqr + '\n' + j['ID'] + '.' + j['Value'];
			texttoshow = texttoshow + '<tr style="font-size:0.6em;"><td><b>' + j['Name'] + '</b></td><td>' + j['Value'] + '</td></tr>';
			texttopush = texttopush + '<ID>'+j['ID']+'</ID><Value>'+j['Value']+'</Value>';
			//alert(key['ID']);			
		});
		texttopush = texttopush + "</Data>";
		texttoshow = texttoshow + '</tbody></table>';
		//alert(texttopush);
		$('#qrinfo').hide();
		$('#qrcode').html("");
		$('#qrcode').qrcode({width: 200,height: 200,text:texttoqr});
		$('#qrcontent').html(texttoshow);
		if($("#userid").html() != -1)
			saveinformation(texttopush);
		$('#qrpopup').popup('open');		
	}
}

function saveinformation(texttopush){
	var jsoninput = '{"DeviceID":'+$("#userid").html()+',"EntityID":'+<?php echo $id?>+', "XMLData":"'+texttopush+'"}';
	//alert(jsoninput);
	
	$.ajax({
		type: "POST",
		url: "db_calls/AddUserSCEParams",
		data: { 'json': jsoninput },
		cache: false
	});	
	
}

function validateformdata(){
	//texttoqr = "1."+$("#userid").html();
	//texttoshow = "";
	var str = "";
	var ID = 0;
	//params['userid'] = '{"ID":1,"Value":"'+$("#userid").html()+'","Name":"UserID"}';
	
	//validating name
	if($("#scname").length){
		if(validatename($("#scname").val())){
			ID = (JSON.parse(params['name']))['ID'];
			$('#scname').parent().css('border-color','green');
			str = '{"ID":'+ID+', "Value":"'+$('#scname').val()+'", "Name":"Name"}';
			params['name'] = str;
			//texttoqr = texttoqr + '\n' + params['name']+'.'+$('#scname').val();
			//texttoshow = texttoshow + '\nName: '+$('#scname').val();
		}else{
			$('#qrinfo').html("Invalid name");
			$('#scname').parent().css('border-color','red');
			$('#qrinfo').show();
			return false;
		}
	}
	
	//validating email
	if($("#scemail").length){
		if(validateemail($("#scemail").val())){
			ID = (JSON.parse(params['email']))['ID'];
			$('#scemail').parent().css('border-color','green');
			str = '{"ID":'+ID+', "Value":"'+$('#scemail').val()+'", "Name":"Email"}';
			params['email'] = str;			
			//texttoqr = texttoqr + '\n' + params['email']+'.'+$('#scemail').val();
			//texttoshow = texttoshow + '\nEmail: '+$('#scemail').val();
		}else{
			$('#qrinfo').html("Invalid email");
			$('#scemail').parent().css('border-color','red');
			$('#qrinfo').show();
			return false;
		}
	}
	
	//validating phone
	if($("#scphone").length){
		if(validatephonenumber($("#scphone").val())){
			ID = (JSON.parse(params['phone']))['ID'];
			$('#scphone').parent().css('border-color','green');
			str = '{"ID":'+ID+', "Value":"'+$('#scphone').val()+'", "Name":"Phone"}';
			params['phone'] = str;
			//texttoqr = texttoqr + '\n' + params['phone']+'.'+$('#scphone').val();
			//texttoshow = texttoshow + '\nPhone: '+$('#scphone').val();
		}else{
			$('#qrinfo').html("Invalid phone number");
			$('#scphone').parent().css('border-color','red');
			$('#qrinfo').show();
			return false;
		}
	}
	
	//validating dateofbirth
	if($("#dateofbirth").length){
		if(validatedbo($("#dateofbirth").val())){
			ID = (JSON.parse(params['dob']))['ID'];
			$('#dateofbirth').parent().css('border-color','green');
			$('#scphone').parent().css('border-color','green');
			str = '{"ID":'+ID+', "Value":"'+$('#dateofbirth').val()+'", "Name":"Date of birth"}';
			params['dob'] = str;
			//texttoqr = texttoqr + '\n' + params['dob']+'.'+$('#dateofbirth').val();
			//texttoshow = texttoshow + '\nDate of birth: '+$('#dateofbirth').val();
		}else{
			$('#qrinfo').html("Invalid date of birth");
			$('#dateofbirth').parent().css('border-color','red');
			$('#qrinfo').show();
			return false;
		}
	}
	
	//validating age
	if($("#age").length){
		if($("#age").val() == ""){
			$('#qrinfo').html("Invalid age");
			$('#age').parent().css('border-color','red');
			$('#qrinfo').show();
			return false;
		}else if(validateage('years', $("#age").val())){
			$('#age').parent().css('border-color','green');
			ID = (JSON.parse(params['age']))['ID'];
			str = '{"ID":'+ID+', "Value":"'+$('#age').val()+'", "Name":"Age"}';
			params['age'] = str;
			
			//texttoqr = texttoqr + '\n' + params['age']+'.'+$('#age').val();
			//texttoshow = texttoshow + '\nAge: '+$('#age').val();
		}else{
			$('#qrinfo').html("Invalid age");
			$('#age').parent().css('border-color','red');
			$('#qrinfo').show();
			return false;
		}
	}
	
	//validating gender
	if($("#gendergroup").length){
		if($("#gendergroup :radio:checked").val() == null){
			$('#qrinfo').html("Select gender.");
			$('#qrinfo').show();
			return false;
		}else{
			ID = (JSON.parse(params['gender']))['ID'];
			str = '{"ID":'+ID+', "Value":"'+$("#gendergroup :radio:checked").val()+'", "Name":"Gender"}';
			params['gender'] = str;
			
			//texttoqr = texttoqr + '\n' + params['gender']+'.'+$("#gendergroup :radio:checked").val();
			//texttoshow = texttoshow + '\nGender: '+$("#gendergroup :radio:checked").val();
		}
	}
	
	//validateing vehicle no
	if($("#vehicleno").length){
		if(validatevehicleno($("#vehicleno").val())){
			ID = (JSON.parse(params['vehicleno']))['ID'];
			$('#vehicleno').parent().css('border-color','green');
			str = '{"ID":'+ID+', "Value":"'+$('#vehicleno').val().toUpperCase()+'", "Name":"Vehicle#"}';
			params['vehicleno'] = str;
			
			//texttoqr = texttoqr + '\n' + params['vehicleno']+'.'+$('#vehicleno').val().toUpperCase();
			//texttoshow = texttoshow + '\nVehicle#: '+$("#vehicleno").val();
		}else{
			$('#qrinfo').html("Invalid vehicle number");
			$('#vehicleno').parent().css('border-color','red');
			$('#qrinfo').show();
			return false;
		}
	}
	
	//validating vehicle type
	if($("#vgroup").length){
		if($("#vgroup :radio:checked").val() == null){
			$('#qrinfo').html("Select vehicle type.");
			$('#qrinfo').show();
			return false;
		}else{
			ID = (JSON.parse(params['vehicletype']))['ID'];
			str = '{"ID":'+ID+', "Value":"'+$("#vgroup :radio:checked").val()+'", "Name":"Vehicle type"}';
			params['vehicletype'] = str;
			
			//texttoqr = texttoqr + '\n' + params['gender']+'.'+$("#gendergroup :radio:checked").val();
			//texttoshow = texttoshow + '\nGender: '+$("#gendergroup :radio:checked").val();
		}
	}
	
	//validateing comingfrom
	if($("#comingfrom").length){
		if(validatemisc($("#comingfrom").val())){
			ID = (JSON.parse(params['comingfrom']))['ID'];
			$('#comingfrom').parent().css('border-color','green');
			str = '{"ID":'+ID+', "Value":"'+$('#comingfrom').val()+'", "Name":"Coming from"}';
			params['comingfrom'] = str;
			
			//texttoqr = texttoqr + '\n' + params['comingfrom']+'.'+$('#comingfrom').val();
			//texttoshow = texttoshow + '\nComing from: '+$("#comingfrom").val();
		}else{
			$('#qrinfo').html("invalid \"coming from\"");
			$('#comingfrom').parent().css('border-color','red');
			$('#qrinfo').show();
			return false;
		}
	}
	
	//validating purpose of visit
	if($("#purposeofvisit").length){
		//alert($('#purposeofvisit :selected').text());
		if($('#purposeofvisit :selected').text() != "Choose.."){
			ID = (JSON.parse(params['purposeofvisit']))['ID'];
			$('#purposeofvisit').parent().css('border-color','green');
			str = '{"ID":'+ID+', "Value":"'+$('#purposeofvisit :selected').text()+'", "Name":"Purpose of visit"}';
			params['purposeofvisit'] = str;
			
			//texttoqr = texttoqr + '\n' + params['purposeofvisit']+'.'+$('#purposeofvisit :selected').text();
			//texttoshow = texttoshow + '\nPurpose of visit: '+$('#purposeofvisit :selected').text();
		}else{
			$('#qrinfo').html("mention your purpose of visit.");
			$('#purposeofvisit').parent().css('border-color','red');
			$('#qrinfo').show();
			return false;
		}
	}
	
	//validating visiting company
	if($("#visitingcompany").length){
		if(validatemisc($("#visitingcompany").val())){
			ID = (JSON.parse(params['visitingcompany']))['ID'];
			$('#visitingcompany').parent().css('border-color','green');
			str = '{"ID":'+ID+', "Value":"'+$('#visitingcompany').val()+'", "Name":"Visiting company"}';
			params['visitingcompany'] = str;
			
			//texttoqr = texttoqr + '\n' + params['visitingcompany']+'.'+$('#visitingcompany').val();
			//texttoshow = texttoshow + '\nVisiting company: '+$("#visitingcompany").val();
		}else{
			$('#qrinfo').html("invalid \"Visiting company\"");
			$('#visitingcompany').parent().css('border-color','red');
			$('#qrinfo').show();
			return false;
		}
	}
	
	//validating meeting person
	if($("#meetingperson").length){
		if(validatename($("#meetingperson").val())){
			ID = (JSON.parse(params['meetingperson']))['ID'];
			$('#meetingperson').parent().css('border-color','green');
			str = '{"ID":'+ID+', "Value":"'+$('#meetingperson').val()+'", "Name":"Meeting person"}';
			params['meetingperson'] = str;
			
			//texttoqr = texttoqr + '\n' + params['meetingperson']+'.'+$('#meetingperson').val();
			//texttoshow = texttoshow + '\nMeeting person: '+$("#meetingperson").val();
		}else{
			$('#qrinfo').html("invalid meeting person name.");
			$('#meetingperson').parent().css('border-color','red');
			$('#qrinfo').show();
			return false;
		}
	}
	
	//validating block
	if($("#block").length){
		if(validatemisc($("#block").val())){
			ID = (JSON.parse(params['block']))['ID'];
			$('#block').parent().css('border-color','green');
			str = '{"ID":'+ID+', "Value":"'+$('#block').val()+'", "Name":"Block"}';
			params['block'] = str;
			
			
			//texttoqr = texttoqr + '\n' + params['block']+'.'+$('#block').val();
			//texttoshow = texttoshow + '\nBlock: '+$("#block").val();
		}else{
			$('#qrinfo').html("invalid block.");
			$('#block').parent().css('border-color','red');
			$('#qrinfo').show();
			return false;
		}
	}
	
	//validating flat
	if($("#flat").length){
		if(validatemisc($("#flat").val())){
			ID = (JSON.parse(params['flat']))['ID'];
			$('#flat').parent().css('border-color','green');
			str = '{"ID":'+ID+', "Value":"'+$('#flat').val()+'", "Name":"Flat"}';
			params['flat'] = str;
			
			//texttoqr = texttoqr + '\n' + params['flat']+'.'+$('#flat').val();
			//texttoshow = texttoshow + '\nFlat: '+$("#flat").val();
		}else{
			$('#qrinfo').html("invalid flat.");
			$('#flat').parent().css('border-color','red');
			$('#qrinfo').show();
			return false;
		}
	}
	
	return true;
}

function getcontent(){
	var jsoninput = '{"EntityID":'+<?php echo $id; ?>+',"DeviceID":'+$('#userid').html()+'}';
	$.ajax({
		type: "POST",
		url: "db_calls/GetEntitySCEParam",
		data: { 'json': jsoninput },
		cache: false,
		success: function (data, status)
		{
			//alert(data);
			params = {};
			var divhtml = "";
			var json = JSON.parse(data);
			$.each(json, function(id, item){
				switch(item['ParamType'].toLowerCase()){
					case "name":
						params['name'] = '{"ID":'+item['ParamID']+'}';
						divhtml = divhtml + '<div class="ui-field-contain" style="padding-bottom:5px;padding-top:0px;border:0px;">';
						divhtml = divhtml + '<label for="name" style="margin-bottom:0px;font-size:.7em;">Name:</label>';
						divhtml = divhtml + '<input type="text" class="ui-corner-all" name="name" value="'+item['ParamValue']+'" id="scname"></div>';
					break;
					case "email":
						params['email'] = '{"ID":'+item['ParamID']+'}';
						divhtml = divhtml + '<div class="ui-field-contain" style="padding-bottom:5px;padding-top:0px;border:0px;">';
						divhtml = divhtml + '<label for="email" style="margin-bottom:0px;font-size:.7em;">Email:</label>';
						divhtml = divhtml + '<input type="text" class="ui-corner-all" name="email" value="'+item['ParamValue']+'" id="scemail"></div>';
					break;
					case "phone":
						params['phone'] = '{"ID":'+item['ParamID']+'}';
						divhtml = divhtml + '<div class="ui-field-contain" style="padding-bottom:5px;padding-top:0px;border:0px;">';
						divhtml = divhtml + '<label for="phone" style="margin-bottom:0px;font-size:.7em;">Phone:</label>';
						divhtml = divhtml + '<input type="text" class="ui-corner-all" name="phone" value="'+item['ParamValue']+'" id="scphone"></div>'
					break;
					case "date of birth":
						params['dob'] = '{"ID":'+item['ParamID']+'}';
						divhtml = divhtml + '<div id="dobdiv" class="ui-field-contain" style="padding-bottom:5px;padding-top:0px;border:0px;">';
						divhtml = divhtml + '<label for="dob" style="margin-bottom:0px;font-size:.7em;">Date of birth:</label>';
						divhtml = divhtml + '<input type="text" placeholder="dd/mm/yyyy" class="ui-corner-all" name="dob" value="'+item['ParamValue']+'" id="dateofbirth" onclick="dobkeypress();"></div>';						
					break;
					case "age":
						params['age'] = '{"ID":'+item['ParamID']+'}';
						divhtml = divhtml + '<div class="ui-field-contain" style="padding-bottom:5px;padding-top:0px;border:0px;">';
						divhtml = divhtml + '<label for="age" style="margin-bottom:0px;font-size:.7em;">Age:</label>';
						divhtml = divhtml + '<input type="text" class="ui-corner-all" placeholder="Years" name="age" value="'+item['ParamValue']+'"  id="age" min=0 max=127></div>'
					break;
					case "gender":
						params['gender'] = '{"ID":'+item['ParamID']+'}';
						divhtml = divhtml + '<div class="ui-field-contain" style="padding-bottom:3px;padding-top:0px;border:0px;z-index:0">';
						divhtml = divhtml + '<label for="gender" style="margin-bottom:0px;font-size:.7em;">Gender:</label>'
						divhtml = divhtml + '<fieldset data-role="controlgroup" data-type="horizontal" id="gendergroup">';
						divhtml = divhtml + '<label for="male">&nbsp;&nbsp;Male&nbsp;&nbsp;</label><input type="radio" name="gender" '+((item['ParamValue'] == 'male')?'checked="checked"':'')+' id="male" value="male">';
						divhtml = divhtml + '<label for="female">Female</label><input type="radio" name="gender" '+((item['ParamValue'] == 'female')?'checked="checked"':'')+' id="female" value="female">';
						divhtml = divhtml + '</fieldset>'
						divhtml = divhtml + '</div>'
					break;
					case "vehicle no":
						params['vehicleno'] = '{"ID":'+item['ParamID']+'}';
						divhtml = divhtml + '<div class="ui-field-contain" style="padding-bottom:5px;padding-top:0px;border:0px;">';
						divhtml = divhtml + '<label for="vehicleno" style="margin-bottom:0px;font-size:.7em;">Vehicle #:</label>';
						divhtml = divhtml + '<input type="text" class="ui-corner-all" name="vehicleno" value="'+item['ParamValue']+'" id="vehicleno"></div>'
					break;

					case "vehicle type":
						params['vehicletype'] = '{"ID":'+item['ParamID']+'}';
						divhtml = divhtml + '<div class="ui-field-contain" style="padding-bottom:3px;padding-top:0px;border:0px;z-index:0">';
						divhtml = divhtml + '<label for="vtype" style="margin-bottom:0px;font-size:.7em;">Vehicle type:</label>'
						divhtml = divhtml + '<fieldset data-role="controlgroup" data-type="horizontal" id="vgroup">';
						divhtml = divhtml + '<label for="w2">2 Wheeler</label><input type="radio" name="veh" '+((item['ParamValue'] == '2')?'checked="checked"':'')+' id="w2" value="2">';
						divhtml = divhtml + '<label for="w3">3 Wheeler</label><input type="radio" name="veh" '+((item['ParamValue'] == '3')?'checked="checked"':'')+' id="w3" value="3">';
						divhtml = divhtml + '<label for="w4">4 Wheeler</label><input type="radio" name="veh" '+((item['ParamValue'] == '4')?'checked="checked"':'')+' id="w4" value="4">';
						divhtml = divhtml + '<label for="w0">&nbsp;&nbsp;&nbsp;&nbsp;None&nbsp;&nbsp;&nbsp;&nbsp;</label><input type="radio" name="veh" '+((item['ParamValue'] == '0')?'checked="checked"':'')+' id="w0" value="0">';
						divhtml = divhtml + '</fieldset>'
						divhtml = divhtml + '</div>'
					break;
					case "coming from":
						params['comingfrom'] = '{"ID":'+item['ParamID']+'}';
						divhtml = divhtml + '<div class="ui-field-contain" style="padding-bottom:5px;padding-top:0px;border:0px;">';
						divhtml = divhtml + '<label for="comingfrom" style="margin-bottom:0px;font-size:.7em;">Coming from:</label>';
						divhtml = divhtml + '<input type="text" class="ui-corner-all" name="comingfrom" value="'+item['ParamValue']+'" id="comingfrom"></div>'
					break;
					case "visiting company":
						params['visitingcompany'] = '{"ID":'+item['ParamID']+'}';
						divhtml = divhtml + '<div class="ui-field-contain" style="padding-bottom:5px;padding-top:0px;border:0px;">';
						divhtml = divhtml + '<label for="visitingcompany" style="margin-bottom:0px;font-size:.7em;">Visiting Company:</label>';
						divhtml = divhtml + '<input type="text" class="ui-corner-all" name="visitingcompany" value="'+item['ParamValue']+'" id="visitingcompany"></div>'
					break;
					case "meeting person":
						params['meetingperson'] = '{"ID":'+item['ParamID']+'}';
						divhtml = divhtml + '<div class="ui-field-contain" style="padding-bottom:5px;padding-top:0px;border:0px;">';
						divhtml = divhtml + '<label for="meetingperson" style="margin-bottom:0px;font-size:.7em;">Meeting person:</label>';
						divhtml = divhtml + '<input type="text" class="ui-corner-all" name="meetingperson" value="'+item['ParamValue']+'" id="meetingperson"></div>'
					break;
					case "block":
						params['block'] = '{"ID":'+item['ParamID']+'}';
						divhtml = divhtml + '<div class="ui-field-contain" style="padding-bottom:5px;padding-top:0px;border:0px;">';
						divhtml = divhtml + '<label for="block" style="margin-bottom:0px;font-size:.7em;">Block #:</label>';
						divhtml = divhtml + '<input type="text" class="ui-corner-all" name="block" value="'+item['ParamValue']+'" id="block"></div>'
					break;
					case "flat":
						params['flat'] = '{"ID":'+item['ParamID']+'}';
						divhtml = divhtml + '<div class="ui-field-contain" style="padding-bottom:5px;padding-top:0px;border:0px;">';
						divhtml = divhtml + '<label for="flat" style="margin-bottom:0px;font-size:.7em;">Flat #:</label>';
						divhtml = divhtml + '<input type="text" class="ui-corner-all" name="flat" value="'+item['ParamValue']+'" id="flat"></div>'
					break;
					case "purpose of visit":
						params['purposeofvisit'] = '{"ID":'+item['ParamID']+'}';
						divhtml = divhtml + '<div class="ui-field-contain" style="padding-bottom:5px;padding-top:0px;border:0px;">';
						divhtml = divhtml + '<label for="purposeofvisit" style="margin-bottom:0px;font-size:.7em;">Purpose of visit:</label>';
						divhtml = divhtml + '<select name="select-native-1" id="purposeofvisit">';
						divhtml = divhtml + '<option value="1">Choose..</option>';
						divhtml = divhtml + '<option value="1">Food delivery</option>';
						divhtml = divhtml + '<option value="2">Interview</option>';
						divhtml = divhtml + '<option value="3">Courier</option>';
						divhtml = divhtml + '<option value="4">Postal delivery</option>';
						divhtml = divhtml + '<option value="4">Personal visit</option>';
						divhtml = divhtml + '<option value="4">Official visit</option>';
						divhtml = divhtml + '</select>';
						divhtml = divhtml + '</div>';
					break;
					default:
					break;
				}
			});
			if($("#userid").html() == -1)
				divhtml = divhtml+'<label id="qrinfo" style="font-size:0.7em;color:red;">*Login to save the information for future use.</label>';
			else
				divhtml = divhtml+'<label id="qrinfo" style="display:none;font-size:1em;color:red;">Custom info</label>';
			divhtml = divhtml+'<a href="#" id="generate" onclick="generateqr();" class="ui-btn ui-btn-inline ui-corner-all ui-shadow" style="display:block;margin-right:auto;margin-left:auto;margin-top:20px;">Generate QR</a>';
			$('#content').html(divhtml);
			//$("#dobdialog").dialog({autoOpen: false,});
			//$("#dobdiv").datepicker();
			$("#content").trigger("create");
			
		},
		error: function (xhr, desc, err)
		{
			alert("falied");
		}
	});
	
	
}

function dobkeypress(){
	var curryear = new Date().getFullYear();
	$('#dobyear').attr('max', curryear).slider("refresh");
	$('#dobdialog').popup('open');
}

$(document).ready(function(event) {
	getcontent();
	$("#btnsetdob").click(function (e) {
		var dy = $("#dobday").val();	
		var mo = $("#dobmonth").val();		
		var yr = $("#dobyear").val();
		
		if(validatedbo(mo+'/'+dy+'/'+yr)){	
			mo = (mo < 10)?'0'+mo:mo;
			dy = (dy < 10)?'0'+dy:dy;
			$('#dateofbirth').val(dy+'/'+mo+'/'+yr);
			$('#dobdialog').popup('close');
			$('#custinfodob').hide();
		}else{			
			$('#custinfodob').show();			
		}
	});	
});

</script>
<div id="mainwin" data-role="main" class="ui-content" style="padding-left:7px;padding-right:7px;">

	<div data-role="collapsibleset" data-theme="a" data-mini="true" style="margin-bottom:0px;">
      <div data-role="collapsible" data-collapsed="true">
        <h3 >Entity details</h3>
        <div class="ui-grid-a ui-responsive" data-mini="true">
			<div class="ui-block-a ui-shadow" style="margin-bottom:10px;background-color:#F5F5F5;padding:3px;border: 1px solid #3F51B5">
				<img src="<?php echo $entityimage;?>" alt="image" id="docimage" style="display:table-cell;vertical-align:middle;margin:auto;">
			</div>
			<div class="ui-block-b" style="margin-bottom:10px;padding:1px;background-color:#F5F5F5;border: 1px solid #3F51B5">		
				<table data-role="table" class="ui-responsive ui-shadow" id="entityaddress" style="font-size:.8em">
					<thead><tr><th data-priority="1"></th></tr></thead>
					<tbody>
						<tr><td style="padding-left:2px;font-style:bold;color:#3F51B5;"><?php echo $entityinfo['Ename']; ?></td></tr>
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
	
	
	<div data-role="collapsibleset" data-theme="a" data-mini="true" style="margin-bottom:50px;">
      <div data-role="collapsible" data-collapsed="false">
        <h3 >Visiter Information</h3>
        <div class="ui-grid-a" data-mini="true">
			
			<div id="content" class="ui-content"></div>
		</div>
      </div>
    </div>
	
	<div data-role="popup" id="qrpopup" class="ui-content" data-position-to="#mainwin" data-transition="slideup" style="display:block;margin:auto;text-align:center;">
		<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>
		<label for="QRCode"><u>My Information</u></label>	
		<div id="qrcode" class="ui-content"></div>
		<div data-role="collapsible" data-collapsed="true" data-mini="true">
			<h1>What am i sharing?</h1>
			<div id="qrcontent" style="margin:auto"/>
			<!--<label id="qrcontent" style="font-size:0.6em;margin-bottom:0px;margin-top:0px;"></label>
			<textarea type="text" id="qrcontent" style="font-size:0.6em;margin-bottom:0px;margin-top:0px;"></textarea>-->
		</div>
		
		<div>
			<a  id="btncono" href="#" class="ui-btn ui-btn-inline ui-corner-all" onclick="$('#qrpopup').popup('close');">Ok</a>
		</div>
	</div>
	
	<div data-role="popup" id="dobdialog" class="ui-content" data-position-to="#mainwin" data-transition="slideup">
		<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>
		<label id="custinfodob" style="color:red;display:none">Invalid date of birth</label>	
		<label for="day">Day:</label>
		<input type="range" name="day" id="dobday" value="1" min="1" max="31" data-popup-enabled="true">
		<label for="month">Month:</label>
		<input type="range" name="month" id="dobmonth" value="1" min="1" max="12" data-popup-enabled="true">
		<label for="year">Year:</label>
		<input type="range" name="year" id="dobyear" value="1900" min="1900" max="2017" data-popup-enabled="true">
		<div>
			<a  id="btncandob" href="#" class="ui-btn ui-btn-inline ui-corner-all ui-icon-delete ui-btn-icon-left" onclick="$('#dobdialog').popup('close');">Cancel</a>
			<a id="btnsetdob" href="#" class="ui-btn ui-btn-inline ui-corner-all ui-icon-check ui-btn-icon-right">&nbsp;&nbsp;&nbsp;Set&nbsp;&nbsp;&nbsp;</a>
		</div>
	</div>
</div>
<?php include "footer.php" ?>















