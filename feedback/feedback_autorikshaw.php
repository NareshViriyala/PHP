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
	$driverinfoarray = json_decode(@file_get_contents($webserviceurl.'GetDoctorDetails.php?id='.$eid), true);
	$driverimage = @file_get_contents($webserviceurl.'GetDoctorImage.php?id='.$eid);
	$driveraverage = @file_get_contents($webserviceurl.'GetAutoDriverFeedback.php?id='.$eid.'&gettype=Average');
	$driverhistory = @file_get_contents($webserviceurl.'GetAutoDriverFeedback.php?id='.$eid.'&gettype=History');
	$driverinfo = $driverinfoarray[0];
}

?>
<script>
$(document).ready(function(event) {
	var jsonfb = JSON.parse('{}');
	var avgnumbers = <?php echo $driveraverage;?>;
	var historynumbers = <?php echo $driverhistory;?>;
	var graph1data = [];
	
	function round(d) {
		return Math.round(100 * d) / 100;
	}

	var data1 = [];
	var data2 = [];

	var yValue1 = 50;
	var yValue2 = 200;

	for (var i = 0; i < 60000; i++) {

		yValue1 += Math.random() * 10 - 5;
		data1.push([i, round(yValue1)]);

		yValue2 += Math.random() * 10 - 5;
		data2.push([i, round(yValue2)]);
	}
	
	var background = {
		type: 'linearGradient',
		x0: 0,
		y0: 0,
		x1: 0,
		y1: 1,
		colorStops: [{ offset: 0, color: '#d2e6c9' },
					 { offset: 1, color: 'white'}]
	};

	
	//console.log(historynumbers);
	if(avgnumbers.length != 0){
		$.each(avgnumbers[0], function(key,value) {
			graph1data.push(JSON.parse('{"key":"'+key+'","value":'+value+'}'));
		}); 
	}
	//console.log(graph1data);
	//console.log(model);
	$("#btn_back").click(function(){window.location.href = '../';});
	
	$("#pol5,#pol4,#pol3,#pol2,#pol1").click(function(){changeOpacity("Politeness", $(this).attr('id'));});
	$("#dri5,#dri4,#dri3,#dri2,#dri1").click(function(){changeOpacity("Driving", $(this).attr('id'));});
	$("#tra5,#tra4,#tra3,#tra2,#tra1").click(function(){changeOpacity("TrafficRules", $(this).attr('id'));});
	$("#int5,#int4,#int3,#int2,#int1").click(function(){changeOpacity("AutoInterior", $(this).attr('id'));});
	$("#far5,#far4,#far3,#far2,#far1").click(function(){changeOpacity("AutoFare", $(this).attr('id'));});
	
	function changeOpacity(grouptype, groupitem){
		jsonfb[grouptype] = groupitem.substr(3);
		$('#'+groupitem.substr(0,3)+'1').css({ opacity: 0.3 });
		$('#'+groupitem.substr(0,3)+'2').css({ opacity: 0.3 });
		$('#'+groupitem.substr(0,3)+'3').css({ opacity: 0.3 });
		$('#'+groupitem.substr(0,3)+'4').css({ opacity: 0.3 });
		$('#'+groupitem.substr(0,3)+'5').css({ opacity: 0.3 });
		$('#'+groupitem).css({ opacity: 1 });			
	}
	
	$("#btnfbsubmit").click(function(){				
		var jsoninput = '{"userid":"<?php echo $uid;?>","entityid":"<?php echo $eid;?>","feedbackinfo":'+JSON.stringify(jsonfb)+'}'		
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
	
	if(graph1data.length > 0){
		$('#jqChartAverage').jqChart({
			title: { text: 'Average Rating' },
			animation: { duration: 0.5 },
			shadows: {enabled: true},
			dataSource: graph1data,
			legend: {visible: false},
			border: {cornerRadius: 5,lineWidth: 0,strokeStyle: '#FFFFFF'},
			axes: [
                    {
                        type: 'category',
                        location: 'bottom',
                        labels: {font: '12px sans-serif',angle: -45}
                    }
                ],
			series: [
				{
					type: 'column',
					xValuesField: {name: 'key',type: 'String'},
					yValuesField: 'value'
				}
			]
		});
	}
	
	/*
	if(historynumbers.length > 0){
		$('#jqChartHistory').jqChart({
			title: { text: 'History' },
			animation: { duration: 0.5 },
			shadows: {enabled: true},
			dataSource: historynumbers,			
			border: {cornerRadius: 5,lineWidth: 0,strokeStyle: '#FFFFFF'},
			axes: [
                    {
                        type: 'linear',
                        location: 'bottom',						
                        //labels: {font: '12px sans-serif',angle: -45},
						zoomEnabled: true
                    }
                ],
			series: [
					{
						type: 'line',
						title: 'Politeness',
						fillStyle: '#418CF0',
						xValuesField: { name: 'FBDate', type: 'datetime' },
						yValuesField: 'Politeness',
						markers: null,
						//labels: { font: '12px sans-serif', fillStyle: '#418CF0' },
						cursor: 'pointer'
					},
					{
						type: 'line',
						title: 'Driving',
						fillStyle: '#418CF0',
						xValuesField: { name: 'FBDate', type: 'datetime' },
						yValuesField: 'Driving',
						markers: null,
						//labels: { font: '12px sans-serif', fillStyle: '#418CF0' },
						cursor: 'pointer'
					}
				]
		});
	}
	
	
	$('#jqChart').jqChart({
		dataSource: historynumbers,	
		title: { text: 'Two series with 60000 points each.', font: '18px sans-serif' },
		axes: [
				{
					type: 'linear',
					location: 'bottom',
					zoomEnabled: true
				}
			  ],
		border: { strokeStyle: '#6ba851' },
		background: background,
		tooltips: {
			type: 'shared'
		},
		crosshairs: {
			enabled: true,
			hLine: false,
			vLine: { strokeStyle: '#cc0a0c' }
		},
		series: [
					{
						title: 'Series 1',
						type: 'line',
						xValuesField: { name: 'FBDate', type: 'datetime' },
						yValuesField: 'Politeness',
						markers: null
					},
					{
						title: 'Series 2',
						type: 'line',
						xValuesField: { name: 'FBDate', type: 'datetime' },
						yValuesField: 'Driving',
						markers: null
					}
				]
	});
	*/
});
</script>

<div data-role="main" class="ui-content" style="padding:2px" data-mini="true">
	<div class="ui-grid-solo ui-responsive" data-mini="true">
		<div class="ui-block-a ui-shadow" style="margin-bottom:10px;background-color:#F5F5F5;padding:3px;border: 1px solid #3F51B5">
			<div data-role="header" style="padding-left:2px;padding-right:2px;margin-bottom:3px;margin-top:3px">
				<h1 style="padding-top:2px;padding-bottom:2px">Driver Info</h1>
			</div>
			<img src="<?php echo $driverimage;?>" alt="image" id="docimage" style="display:table-cell;vertical-align:middle;margin:auto;">
			<h3 style="margin:0px;" align="center"><?php echo 'Name: '.$driverinfo['Dname']; ?></h3>
			<h6 style="margin:0px" align="center"><?php echo 'Auto No: '.$driverinfo['Deg']; ?></h6>
			<h6 style="margin:0px" align="center"><?php echo 'Mobile: '.$driverinfo['Mobile']; ?></h6>
		</div>		
	</div>
	
	<div class="ui-grid-solo ui-responsive" data-mini="true">
		<div class="ui-block-a ui-shadow" style="margin-bottom:10px;background-color:#F5F5F5;padding:3px;border: 1px solid #3F51B5">
			<table style="font-size:.8em;width:100%">
				<tr>
					<td colspan="2">
						<div data-role="header" style="padding-left:2px;padding-right:2px;margin-bottom:3px;margin-top:3px">
							<h1 style="padding-top:2px;padding-bottom:2px">Feedback</h1>
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
					<td>Politeness</td>
					<td>
						<div class="ui-grid-d" data-mini="true">
							<div id="pol5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
							<div id="pol4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
							<div id="pol3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
							<div id="pol2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
							<div id="pol1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
						</div>
					</td>
				</tr>
				<tr>
					<td>Driving</td>
					<td>
						<div class="ui-grid-d" data-mini="true">
							<div id="dri5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
							<div id="dri4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
							<div id="dri3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
							<div id="dri2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
							<div id="dri1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
						</div>
					</td>
				</tr>	
				<tr>
					<td>Traffic Rules</td>
					<td>
						<div class="ui-grid-d" data-mini="true">
							<div id="tra5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
							<div id="tra4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
							<div id="tra3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
							<div id="tra2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
							<div id="tra1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
						</div>
					</td>
				</tr>
				<tr>
					<td>Auto Interior</td>
					<td>
						<div class="ui-grid-d" data-mini="true">
							<div id="int5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
							<div id="int4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
							<div id="int3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
							<div id="int2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
							<div id="int1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
						</div>
					</td>
				</tr>
				<tr>
					<td>Auto Fare</td>
					<td>
						<div class="ui-grid-d" data-mini="true">
							<div id="far5" class="ui-block-a" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiexcellent.png";?>" alt="excellent" style="width:30px;height:30px"></div>
							<div id="far4" class="ui-block-b" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverygood.png";?>" alt="verygood" style="width:30px;height:30px"></div>
							<div id="far3" class="ui-block-c" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojigood.png";?>" alt="good" style="width:30px;height:30px"></div>
							<div id="far2" class="ui-block-d" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojipoor.png";?>" alt="poor" style="width:30px;height:30px"></div>
							<div id="far1" class="ui-block-e" style="padding:5px;opacity:0.3;text-align:center;"><img src="<?php echo $imageurl."Emojiverypoor.png";?>" alt="verypoor" style="width:30px;height:30px"></div>
						</div>
					</td>
				</tr>				
				<tr>
					<td><a id="btn_back" data-mini="true" class="ui-btn ui-btn-inline ui-corner-all ui-icon-carat-l ui-btn-icon-left" style="align:center" onclick="btn_back_mobile.performClick();">Back</a></td>
					<td align="right"><a href="#" id="btnfbsubmit" data-transition="slide" data-mini="true" class="ui-btn ui-btn-inline ui-corner-all ui-icon-check ui-btn-icon-right" style="align:center" onclick="btn_submit_mobile.performClick();">Submit</a></td>
				</tr>	
				<tr >
					<td colspan="2" align="center"><p id="success_msg" style="background:#8BC34A;display:none;padding:10px 30px 10px 30px;color:black">Thanks for your feedback.</br></br>back to home...</p></td>
				</tr>
			</table>
		</div>	
	</div>

	<div class="ui-grid-solo ui-responsive" data-mini="true">
		<div class="ui-block-a ui-shadow" style="margin-bottom:10px;background-color:#F5F5F5;padding:3px;border: 1px solid #3F51B5">
			<div data-role="header" style="padding-left:2px;padding-right:2px;margin-bottom:3px;margin-top:3px">
				<h1 style="padding-top:2px;padding-bottom:2px">Driver History</h1>
			</div>
			<div id="jqChartAverage" style="width: 100%; height: 30%;"></div>
			<div id="jqChartHistory" style="width: 100%; height: 30%;"></div>
		</div>		
	</div>
	
</div>
	