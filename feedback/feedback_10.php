<?php include $_SERVER['DOCUMENT_ROOT']."/header.php" ?>
<?php include $_SERVER['DOCUMENT_ROOT']."/db_calls/globalvariables.php" ?>
<?php 
$uid = $_REQUEST['route'];
$eid = $_REQUEST['reroute'];

if($uid == null || $eid == null){
	//echo $id;
	header("Location: /");
    return;
}else{
	$userinfoarray = json_decode(@file_get_contents($webserviceurl.'GetUserBasicInfo.php?uid='.$uid),true);
	$userinfo = $userinfoarray[0];
	echo $userinfo;
}

?>
<script>
$(document).ready(function(event) {
	var jsonfb = JSON.parse('{}');
	$('#tbx_fname').val("<?php echo $userinfo['FirstName']?>");
	$('#tbx_lname').val("<?php echo $userinfo['LastName']?>");
	$('#tbx_phone').val("<?php echo $userinfo['Phone']?>");
	$('#tbx_email').val("<?php echo $userinfo['Email']?>");
	
	$("#var5,#var4,#var3,#var2,#var1").click(function(){changeOpacity("Variety", $(this).attr('id'));});	
	$("#qua5,#qua4,#qua3,#qua2,#qua1").click(function(){changeOpacity("Quality", $(this).attr('id'));});	
	$("#ser5,#ser4,#ser3,#ser2,#ser1").click(function(){changeOpacity("ServingPortion", $(this).attr('id'));});
	$("#pre5,#pre4,#pre3,#pre2,#pre1").click(function(){changeOpacity("Presentation", $(this).attr('id'));});
	$("#vfm5,#vfm4,#vfm3,#vfm2,#vfm1").click(function(){changeOpacity("ValueforMoney", $(this).attr('id'));});
	$("#sos5,#sos4,#sos3,#sos2,#sos1").click(function(){changeOpacity("SpeedofService", $(this).attr('id'));});
	$("#fri5,#fri4,#fri3,#fri2,#fri1").click(function(){changeOpacity("Friendliness", $(this).attr('id'));});
	$("#pro5,#pro4,#pro3,#pro2,#pro1").click(function(){changeOpacity("Professionalism", $(this).attr('id'));});
	$("#kno5,#kno4,#kno3,#kno2,#kno1").click(function(){changeOpacity("Knowledge", $(this).attr('id'));});
	$("#lig5,#lig4,#lig3,#lig2,#lig1").click(function(){changeOpacity("Lighting", $(this).attr('id'));});
	$("#roo5,#roo4,#roo3,#roo2,#roo1").click(function(){changeOpacity("RoomTemperature", $(this).attr('id'));});
	$("#cli5,#cli4,#cli3,#cli2,#cli1").click(function(){changeOpacity("Cleanliness", $(this).attr('id'));});
	$("#mus5,#mus4,#mus3,#mus2,#mus1").click(function(){changeOpacity("MusicSelection", $(this).attr('id'));});
	$("#btn_back").click(function(){window.location.href = '../';});

	$("#btnfbsubmit").click(function(){
		//jsonfb['userid'] = $('#userid').html();
		//jsonfb['userid'] = <?php echo $uid;?>;
		//jsonfb['entityid'] = <?php echo $eid;?>;
		jsonfb['title'] = $("#titlegroup :radio:checked").val();
		if($('#tbx_fname').val())
			jsonfb['fname'] = $('#tbx_fname').val();
		if($('#tbx_lname').val())
			jsonfb['lname'] = $('#tbx_lname').val();
		if($('#tbx_email').val())
			jsonfb['email'] = $('#tbx_email').val();
		if($('#tbx_phone').val())
			jsonfb['phone'] = $('#tbx_phone').val();		
		//console.log(jsonfb);
		
		var jsoninput = '{"userid":"<?php echo $uid;?>","entityid":"<?php echo $eid;?>","feedbackinfo":'+JSON.stringify(jsonfb)+'}'
		//console.log(jsoninput);
		$.ajax({
			type: "POST",
			url: "../db_calls/SubmitFeedback",
			data: { 'json': jsoninput },
			cache: false,
			success: function (data, status)
			{
				//$('#success_msg').show();
				$('#success_msg').html("Thanks for your feedback.</br></br>back to home...");
				$('#success_msg').css("display","inline-block");
				$("#success_msg").fadeOut(2000);
				setTimeout(function(){window.location.href = '../';}, 2000);
			},
			error: function (xhr, desc, err){
				$('#success_msg').css("display","inline-block");
				$('#success_msg').css("background","#F44336");
				$('#success_msg').html("Something went wrong.</br></br>back to home...");
				$("#success_msg").fadeOut(2000);
				setTimeout(function(){window.location.href = '../';}, 2000);
			}
		});
	});
	
	function changeOpacity(grouptype, groupitem){
		jsonfb[grouptype] = groupitem.substr(3);
		$('#'+groupitem.substr(0,3)+'1').css({ opacity: 0.3 });
		$('#'+groupitem.substr(0,3)+'2').css({ opacity: 0.3 });
		$('#'+groupitem.substr(0,3)+'3').css({ opacity: 0.3 });
		$('#'+groupitem.substr(0,3)+'4').css({ opacity: 0.3 });
		$('#'+groupitem.substr(0,3)+'5').css({ opacity: 0.3 });
		$('#'+groupitem).css({ opacity: 1 });			
	}
});
</script>


<div data-role="page" id="pageone">
  <div data-role="main" class="ui-content" style="padding:0px">
	<table style="font-size:.8em;width:100%">
		<tr>
			<td colspan="2">
				<div data-role="header" style="padding-left:2px;padding-right:2px">
					<h1>Contact Info 1/4</h1>
				</div>
			 </td>
		</tr>
		<tr>
			<td>Title</td>
			<td><fieldset data-role="controlgroup" data-type="horizontal" data-mini="true" id="titlegroup">
					<label for="mr">Mr</label>
					<input type="radio" name="gendertitle" id="mr" value="mr" checked>
					<label for="mrs">Mrs</label>
					<input type="radio" name="gendertitle" id="mrs" value="mrs">
					<label for="ms">Ms</label>
					<input type="radio" name="gendertitle" id="ms" value="ms">
				</fieldset>
			</td>
		</tr>
		<tr>
			<td>First Name</td>
			<td><input type="text"  id="tbx_fname" name="tbx_fname" data-mini="true"/></td>
		</tr>
		<tr>
			<td>Last Name</td>
			<td><input type="text"  id="tbx_lname" name="tbx_lname" data-mini="true"/></td>
		</tr>
		<tr>
			<td>Email</td>
			<td><input type="email"  id="tbx_email" name="tbx_email" data-mini="true"/></td>
		</tr>
		<tr>
			<td>Contact number</td>
			<td><input type="number"  id="tbx_phone" name="tbx_phone" data-mini="true"/></td>
		</tr>	

		<tr>
			<td><a id="btn_back" data-mini="true" class="ui-btn ui-btn-inline ui-corner-all ui-icon-carat-l ui-btn-icon-left" style="align:center" onclick="btn_back_mobile.performClick();">Back</a></td>
			<td align="right"><a href="#pagetwo" data-transition="slide" data-mini="true" class="ui-btn ui-btn-inline ui-corner-all ui-icon-carat-r ui-btn-icon-right" style="align:center">Next</a></td>			
		</tr>
	</table>
  </div>
</div> 

<div data-role="page" id="pagetwo">
	<div data-role="main" class="ui-content"  style="padding:0px">
		<table style="font-size:.8em;width:100%">
			<tr>
				<td colspan="2">
					<div data-role="header" style="padding-left:2px;padding-right:2px">
						<h1>Food 2/4</h1>
					</div>
				 </td>
			</tr>
			<tr>
				<td></td>
				<td>
					<div class="ui-grid-d" data-mini="true">
						<div class="ui-block-a"><p style="text-align: center;font-size:.8em;margin:0px">5</p></div>
						<div class="ui-block-b"><p style="text-align: center;font-size:.8em;margin:0px">4</p></div>
						<div class="ui-block-c"><p style="text-align: center;font-size:.8em;margin:0px">3</p></div>
						<div class="ui-block-d"><p style="text-align: center;font-size:.8em;margin:0px">2</p></div>
						<div class="ui-block-e"><p style="text-align: center;font-size:.8em;margin:0px">1</p></div>
					</div>
				</td>
			</tr>
			<tr>
				<td>Variety</td>
				<td>
					<div class="ui-grid-d" data-mini="true">
						<div id="var5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
						<div id="var4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
						<div id="var3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
						<div id="var2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
						<div id="var1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
					</div>
				</td>
			</tr>
			<tr>
				<td>Quality</td>
				<td>
					<div class="ui-grid-d" data-mini="true">
						<div id="qua5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
						<div id="qua4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
						<div id="qua3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
						<div id="qua2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
						<div id="qua1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
					</div>
				</td>
			</tr>	
			<tr>
				<td>Serving Portion</td>
				<td>
					<div class="ui-grid-d" data-mini="true">
						<div id="ser5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
						<div id="ser4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
						<div id="ser3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
						<div id="ser2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
						<div id="ser1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
					</div>
				</td>
			</tr>
			<tr>
				<td>Presentation</td>
				<td>
					<div class="ui-grid-d" data-mini="true">
						<div id="pre5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
						<div id="pre4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
						<div id="pre3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
						<div id="pre2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
						<div id="pre1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
					</div>
				</td>
			</tr>	
			<tr>
				<td>Value for Money</td>
				<td>
					<div class="ui-grid-d" data-mini="true">
						<div id="vfm5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
						<div id="vfm4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
						<div id="vfm3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
						<div id="vfm2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
						<div id="vfm1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
					</div>
				</td>
			</tr>	
			<tr>
				<td><a href="#pageone" data-transition="slide" data-direction="reverse" data-mini="true" class="ui-btn ui-btn-inline ui-corner-all ui-icon-carat-l ui-btn-icon-left" style="align:center">Back</a></td>
				<td align="right"><a href="#pagethree" data-transition="slide" data-mini="true" class="ui-btn ui-btn-inline ui-corner-all ui-icon-carat-r ui-btn-icon-right" style="align:center">Next</a></td>
			</tr>	
		</table>
	</div>
</div> 

<div data-role="page" id="pagethree">
	<div data-role="main" class="ui-content" style="padding:0px">
		<table style="font-size:.8em;width:100%">
			<tr>
				<td colspan="2">
					<div data-role="header" style="padding-left:2px;padding-right:2px">
						<h1>Service 3/4</h1>
					</div>
				 </td>
			</tr>
			<tr>
				<td></td>
				<td>
					<div class="ui-grid-d" data-mini="true">
						<div class="ui-block-a"><p style="text-align: center;font-size:.8em;margin:0px">5</p></div>
						<div class="ui-block-b"><p style="text-align: center;font-size:.8em;margin:0px">4</p></div>
						<div class="ui-block-c"><p style="text-align: center;font-size:.8em;margin:0px">3</p></div>
						<div class="ui-block-d"><p style="text-align: center;font-size:.8em;margin:0px">2</p></div>
						<div class="ui-block-e"><p style="text-align: center;font-size:.8em;margin:0px">1</p></div>
					</div>
				</td>
			</tr>
			<tr>
				<td>Speed of Service</td>
				<td>
					<div class="ui-grid-d" data-mini="true">
						<div id="sos5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
						<div id="sos4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
						<div id="sos3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
						<div id="sos2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
						<div id="sos1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
					</div>
				</td>
			</tr>
			<tr>
				<td>Friendliness/Courtesy</td>
				<td>
					<div class="ui-grid-d" data-mini="true">
						<div id="fri5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
						<div id="fri4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
						<div id="fri3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
						<div id="fri2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
						<div id="fri1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
					</div>
				</td>
			</tr>	
			<tr>
				<td>Professionalism</td>
				<td>
					<div class="ui-grid-d" data-mini="true">
						<div id="pro5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
						<div id="pro4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
						<div id="pro3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
						<div id="pro2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
						<div id="pro1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
					</div>
				</td>
			</tr>
			<tr>
				<td>Knowledge</td>
				<td>
					<div class="ui-grid-d" data-mini="true">
						<div id="kno5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
						<div id="kno4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
						<div id="kno3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
						<div id="kno2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
						<div id="kno1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
					</div>
				</td>
			</tr>		
			<tr>
				<td><a href="#pagetwo" data-transition="slide" data-direction="reverse" data-mini="true" class="ui-btn ui-btn-inline ui-corner-all ui-icon-carat-l ui-btn-icon-left" style="align:center">Back</a></td>
				<td align="right"><a href="#pagefour" data-transition="slide" data-mini="true" class="ui-btn ui-btn-inline ui-corner-all ui-icon-carat-r ui-btn-icon-right" style="align:center">Next</a></td>
			</tr>	
		</table>
	</div>
</div> 

<div data-role="page" id="pagefour">
	<div data-role="main" class="ui-content" style="padding:0px">
		<table style="font-size:.8em;width:100%">
			<tr>
				<td colspan="2">
					<div data-role="header" style="padding-left:2px;padding-right:2px">
						<h1>Ambience 4/4</h1>
					</div>
				 </td>
			</tr>
			<tr>
				<td></td>
				<td>
					<div class="ui-grid-d" data-mini="true">
						<div class="ui-block-a"><p style="text-align: center;font-size:.8em;margin:0px">5</p></div>
						<div class="ui-block-b"><p style="text-align: center;font-size:.8em;margin:0px">4</p></div>
						<div class="ui-block-c"><p style="text-align: center;font-size:.8em;margin:0px">3</p></div>
						<div class="ui-block-d"><p style="text-align: center;font-size:.8em;margin:0px">2</p></div>
						<div class="ui-block-e"><p style="text-align: center;font-size:.8em;margin:0px">1</p></div>
					</div>
				</td>
			</tr>
			<tr>
				<td>Lighting</td>
				<td>
					<div class="ui-grid-d" data-mini="true">
						<div id="lig5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
						<div id="lig4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
						<div id="lig3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
						<div id="lig2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
						<div id="lig1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
					</div>
				</td>
			</tr>
			<tr>
				<td>Room Temperature</td>
				<td>
					<div class="ui-grid-d" data-mini="true">
						<div id="roo5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
						<div id="roo4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
						<div id="roo3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
						<div id="roo2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
						<div id="roo1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
					</div>
				</td>
			</tr>	
			<tr>
				<td>Cleanliness</td>
				<td>
					<div class="ui-grid-d" data-mini="true">
						<div id="cli5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
						<div id="cli4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
						<div id="cli3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
						<div id="cli2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
						<div id="cli1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
					</div>
				</td>
			</tr>
			<tr>
				<td>Music Selection</td>
				<td>
					<div class="ui-grid-d" data-mini="true">
						<div id="mus5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
						<div id="mus4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
						<div id="mus3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
						<div id="mus2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
						<div id="mus1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
					</div>
				</td>
			</tr>		
			<tr>
				<td><a href="#pagethree" data-transition="slide" data-direction="reverse" data-mini="true" class="ui-btn ui-btn-inline ui-corner-all ui-icon-carat-l ui-btn-icon-left" style="align:center">Back</a></td>
				<td align="right"><a href="#" id="btnfbsubmit" data-transition="slide" data-mini="true" class="ui-btn ui-btn-inline ui-corner-all ui-icon-check ui-btn-icon-right" style="align:center" onclick="btn_submit_mobile.performClick();">Submit</a></td>
			</tr>	
			<tr >
				<td colspan="2" align="center"><p id="success_msg" style="background:#8BC34A;display:none;padding:10px 30px 10px 30px;color:black">Thanks for your feedback.</br></br>back to home...</p></td>
			</tr>
		</table>
	</div>
</div> 

