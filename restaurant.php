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
$businesshours = json_decode(@file_get_contents($webserviceurl.'GetBusinessHours.php?id='.$id), true);
$restaurantmenu = json_decode(@file_get_contents($webserviceurl.'GetRestaurantMenu.php?input='.$id.'&PageNumber=1&PageCount=1000'), true);
$entityinfo = $entityinfoarray[0];
//echo ($webserviceurl.'GetEntityDetails.php?id='.$id);
//var_dump($entityinfoarray);
?>
<script>
var selectedItems = {};
function sticky_relocate() {
	var window_top = $(window).scrollTop();
	var div_top = $('#sticky-anchor').offset().top;
	if (window_top > div_top) {
		$('#resoptionbtns').addClass('stick');
		$('#sticky-anchor').height($('#resoptionbtns').outerHeight());
	} else {
		$('#resoptionbtns').removeClass('stick');
		$('#sticky-anchor').height(0);
	}
}	

function defaultorder(){
	//alert($("#userid").html());
	$.ajax({
		type: "POST",
		url: "db_calls/GetRestaurantOrderSelf",
		data: { 'id': '<?php echo $id;?>', 'userid': ''+$("#userid").html()+'' },
		cache: false,
		success: function (data, status)
		{
			var json = JSON.parse(data);
			//alert(data);
			if(json.length > 0){
				$("#resoptionbtns").removeClass("withoutorder").addClass("withorder");
				$("#callwaiter").show();
				$("#cancelorder").show();
				$("#orderid").html(json[0]['MasterID']);
				//alert(data);
				selectedItems = {};
				$.each(json, function(idx, item) {
				
					var id = item['TID'];
					
					selectedItems[id] = item['Quantity'];
					
					$("#anc"+id).css({'background-color':'#3F51B5'});
					$("#anc"+id).css({'color':'white'});
					var itemprice = parseInt($("#ip"+id).html());
					itemprice = itemprice * parseInt(item['Quantity']);
					$("#qty"+id).html("Qty: "+item['Quantity']);
					$("#ip"+id).html(itemprice);
					cascade = false;
				});
			}
		},
		error: function (xhr, desc, err)
		{
			alert("We could not placeorder! please try again.");
		}
	});	
}

$(document).ready(function(event) {
	
	//alert("here");
	var cascade = false;
	var taxdata;
	
	defaultorder();
		
	$("#gototop").click(function(){
		$("html, body").animate({ scrollTop: 0 }, 300);
	});
	
	$(function() {
		$(window).scroll(sticky_relocate);
		sticky_relocate();
	});

	$("#callwaiter").click(function (e) {
		var jsoninput = '{"MasterID":"'+$("#orderid").html()+'","input":"'+<?php echo $id?>+'"}'
		$.ajax({
			type: "POST",
			url: "db_calls/CallWaiter",
			data: { 'json': jsoninput },
			cache: false,
			success: function (data, status)
			{
				$("#custinfo").html("We acknowledge your call.<br/>Visiting your table right away.");
				$( '#autopopup' ).popup( 'open' );	
			},
			error: function (xhr, desc, err)
			{
				alert("We could not placeorder! please try again.");
			}
		});	
	});	
	
	$(".menuitemli").on("click", function(e){
		var id = $(this).attr('id').replace("li","") ;
		var qty = parseInt($("#qty"+id).html().replace("Qty: ",""));
		var itemprice = parseInt($("#ip"+id).html());
		itemprice = itemprice/qty;
		
		
		if(selectedItems[id] == null || cascade){
			$("#anc"+id).css({'background-color':'#3F51B5'});
			$("#anc"+id).css({'color':'white'});
			selectedItems[id] = qty;
			cascade = false;
		}else{
			$("#anc"+id).css({'background-color':'#f6f6f6'});
			$("#anc"+id).css({'color':'black'});
			delete selectedItems[id];
			$("#qty"+id).html("Qty: 1");
			$("#ip"+id).html(itemprice);
		}
		
		/*
		if($(this).css('border-left-width') == "0px" || cascade){
			$(this).css({'border-left':'5px solid #3F51B5'});
			selectedItems[id] = qty;
			cascade = false;
		}else{
			$(this).css({'border-left':'0px none #3F51B5'});
			delete selectedItems[id];
			$("#qty"+id).html("Qty: 1");
			$("#ip"+id).html(itemprice);
		}
		*/
	});
	
	$(".cqtyminus").on("click", function(e){
		var id = $(this).attr('id').replace("qtym","") ;
		var qty = parseInt($("#qty"+id).html().replace("Qty: ",""));
		var itemprice = parseInt($("#ip"+id).html());
		itemprice = itemprice/qty;
		if(qty > 1)
			qty = qty-1;
		$("#qty"+id).html("Qty: "+qty);
		$("#ip"+id).html(itemprice*qty);
		cascade = true; //this is required because after this click event the list item click event will also be fired
	});
	
	$(".cqtyplus").on("click", function(e){
		var id = $(this).attr('id').replace("qtyp","") ;
		var qty = parseInt($("#qty"+id).html().replace("Qty: ",""));
		var itemprice = parseInt($("#ip"+id).html());
		itemprice = itemprice/qty;
		qty = qty+1;
		$("#qty"+id).html("Qty: "+qty);
		$("#ip"+id).html(itemprice*qty);
		cascade = true; //this is required because after this click event the list item click event will also be fired
	});
	
	$("#btnorder").on("click", function(e){
		//alert(jQuery.isEmptyObject(selectedItems));
		if($("#login").html() == "Login"){
			
			$("#osinfo").toggle();
			$("#osinfo").html("Please login to place order");	
		}
		else if (jQuery.isEmptyObject(selectedItems)){
			$("#osinfo").toggle();
			$("#osinfo").html("Please select items to place order");
		}else{
			var xmlorder = "<order>";
			$.each( selectedItems, function( key, value ) {
				xmlorder = xmlorder+"<TID>"+key+"</TID><QTY>"+value+"</QTY>";
				//alert(key);
			});
			xmlorder = xmlorder + "</order>"
			var jsoninput = '{"SubjectID":"'+<?php echo $id?>+'","DeviceType":"1","XMLOrder":"'+xmlorder+'","DeviceID":"'+$('#userid').html()+'","PersonName":"'+$('#usernamehidden').html()+'"}'
			//alert(jsoninput);
			//return;
			$.mobile.loading( "show", {text: "Loading.."});
			$.ajax({
				type: "POST",
				url: "db_calls/AddRestaurantOrder",
				data: { 'json': jsoninput },
				cache: false,
				success: function (data, status)
				{
					$.mobile.loading( "hide");
					var json = JSON.parse(data);
					//alert(data);
					$("#resoptionbtns").removeClass("withoutorder").addClass("withorder");
					$("#callwaiter").show();
					$("#cancelorder").show();
					$("#popupos").popup("close");
					$("#orderid").html(json[0]['MasterID']);
					$("#custinfo").html("Order received!<br>We will be at your table in a moment.");
					
					setTimeout( function() { $( '#autopopup' ).popup( 'open' ); }, 400 );
					
				},
				error: function (xhr, desc, err)
				{
					$.mobile.loading( "hide");
					alert("We could not placeorder! please try again.");
				}
			});	
			
		}
	});
	
	$("#btncoyes").on("click", function(e){
		$("#cancelorderconfirm").popup("close");
		var jsoninput = '{"MasterID":"'+$("#orderid").html()+'","Status":"","GUID":"","DeviceID":"'+$('#userid').html()+'"}'
		$.ajax({
			type: "POST",
			url: "db_calls/DeleteRestaurantOrder",
			data: { 'json': jsoninput },
			cache: false,
			success: function (data, status)
			{
				//alert(data);
				$("#resoptionbtns").removeClass("withorder").addClass("withoutorder");
				$("#callwaiter").hide();
				$("#cancelorder").hide();
				$("#orderid").html("-1");
				$.each( selectedItems, function( id, value ) {
					$("#anc"+id).css({'background-color':'#f6f6f6'});
					$("#anc"+id).css({'color':'black'});
					
					var qty = parseInt($("#qty"+id).html().replace("Qty: ",""));
					var itemprice = parseInt($("#ip"+id).html());
					itemprice = itemprice/qty;
					$("#qty"+id).html("Qty: 1");
					$("#ip"+id).html(itemprice);
				});
				selectedItems = {};
			},
			error: function (xhr, desc, err)
			{
				alert("We could not cancel order! please try again.");
			}
		});	
	});
	
	$("#btnplaceorder").on("click", function(e){
		$("#osinfo").hide();
		/*
		geolocation.location(function (returninfo) {
			if(returninfo['status'] == 'Error'){
				//alert(returninfo['info']);
				$('#popupos').popup('open');
				$("#osinfo").html(returninfo['info']);
				$("#btnorder").prop('disabled', true).addClass('ui-disabled');
				$("#osinfo").show();
				return;
				//console.log(returninfo);
			}
			if(!inrange(<?php echo $entityinfo['Lat']; ?>, <?php echo $entityinfo['Long']; ?>, returninfo['latitude'], returninfo['longitude'], <?php echo $entityinfo['PD']; ?>)){
				//alert("We do not find you at the table.\nWe can not accept your order.");
				$('#popupos').popup('open');
				$("#osinfo").html("We do not find you at the table.<br/>We can not accept your order.");
				$("#btnorder").prop('disabled', true).addClass('ui-disabled');
				$("#osinfo").show();
				return;
			}
			if (taxdata == null){
				//alert("calling");
				$("#btnorder").prop('disabled', true).removeClass('ui-disabled');
				$.ajax({
					type: "POST",
					url: "db_calls/GetRestaurantTaxes",
					data: { 'id': <?php echo $id ?> },
					cache: false,
					success: function (data, status)
					{
						taxdata = data;
						//alert(taxdata);
						populatesummarytable(data);
					},
					error: function (xhr, desc, err)
					{
						alert("falied");
					}
				});	
			}else{
				//alert("saved");
				populatesummarytable(taxdata);
			}
					
			//console.log(returninfo);
		});
		*/
		
		if (taxdata == null){
			//alert("calling");
			$.ajax({
				type: "POST",
				url: "db_calls/GetRestaurantTaxes",
				data: { 'id': <?php echo $id ?> },
				cache: false,
				success: function (data, status)
				{
					taxdata = data;
					//alert(taxdata);
					populatesummarytable(data);
				},
				error: function (xhr, desc, err)
				{
					alert("falied");
				}
			});	
		}else{
			//alert("saved");
			populatesummarytable(taxdata);
		}
		
		
	});
	
	function populatesummarytable(data){
		var taxes = jQuery.parseJSON(data);
		var totalbill = 0;
		var bill = 0;
		//alert (selectedItems['64']);
		$("#summarytable").html("");
		var items = new Array();
		items.push(["Name", "Qty", "Price"]);
		$.each(selectedItems, function( k, v ) {
			var itemname = $("#in"+k).html()
			var itemqty = $("#qty"+k).html().replace("Qty: ","")
			var itemprice = $("#ip"+k).html()
			items.push([itemname, itemqty, itemprice]);
			//alert( "Key: " + k + ", Value: " + v );
		});
		var columnCount = items[0].length;
		var table = "<table data-role=\"table\" class=\"ui-responsive ui-shadow table-stripe\" id=\"ordersummarytable\" style=\"font-family:Times New Roman;font-size:.7em\">";
		table = table + "<thead><tr>";
		for (var i = 0; i < columnCount; i++) {
            table = table + "<th style=\"color:#3F51B5\">"+items[0][i]+"</th>";
        }
		table = table + "</tr></thead><tbody>";
		
		for (var i = 1; i < items.length; i++) {
            table = table + "<tr>";
			table = table + "<td>"+items[i][0]+"</td>";
			table = table + "<td>"+items[i][1]+"</td>";
			table = table + "<td>"+items[i][2]+"</td>";
			table = table + "</tr>";
			totalbill = totalbill + parseInt(items[i][2]);
        }
		//alert (totalbill);
		$.each(taxes, function(idx, tax) {
			table = table + "<tr style=\"color:#3F51B5;\">";
			table = table + "<td>"+tax.TaxName+"</td>";
			if(tax.TaxName == "Sub Total")
				table = table + "<td>"+(items.length-1)+"</td>";
			else
				table = table + "<td>"+tax.TaxPercentage+"%</td>";
			var taxamt = (parseFloat(tax.TaxPercentage)*totalbill)/100;
			bill = bill + taxamt;
			if(tax.TaxName == "Sub Total")
				table = table + "<td>&#8377; "+taxamt.toFixed(0)+"</td>";
			else
				table = table + "<td>&#8377; "+taxamt.toFixed(2)+"</td>";
			table = table + "</tr>";
		});
		
		table = table + "<tr style=\"background-color:#3F51B5;color:white;\">";
		table = table + "<td>Total</td>";
		table = table + "<td></td>";
		table = table + "<td>&#8377; "+bill.toFixed(0)+"</td>";
		table = table + "</tr>";
		
		table = table + "</tbody></table>";
		$("#summarytable").append(table);
		$('#popupos').popup('open');
	}
	
});

</script>
<div id="mainwin" data-role="main" class="ui-content" style="padding-left:7px;padding-right:7px;">
	<p id="orderid" style="display:none">-1</p>
	<div data-role="collapsibleset" data-theme="a" data-mini="true" style="margin-bottom:0px;">
      <div data-role="collapsible" data-collapsed="true">
        <h3 >Restaurant details</h3>
        <div class="ui-grid-b ui-responsive" data-mini="true">
			<div class="ui-block-a ui-shadow" style="margin-bottom:10px;background-color:#F5F5F5;padding:3px;border: 1px solid #3F51B5"">
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
			
			<div class="ui-block-c" style="margin-bottom:10px;padding:1px;background-color:#F5F5F5;border: 1px solid #3F51B5"">
				<table data-role="table" class="ui-responsive ui-shadow" id="businesshours" style="font-size:.8em">
				  <thead><tr><th></th></tr></thead>
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
		</div>						
      </div>
    </div>
	<div id="sticky-anchor"></div> <!--this div to requite to stick the options on top-->
	<div id="resoptionbtns" class="ui-content withoutorder" data-mini="true" style="padding-top:3px;padding-bottom:1px;padding-left:0px;padding-right:0px;">
		<div style="display:block;margin:auto;text-align:center;" onclick="window.history.back();">
					<!--<img src="/images/backarrow.png" alt="Back" style="width:30px;height:30px;"/>-->
					<a href="#" class="ui-btn ui-corner-all ui-icon-carat-l ui-btn-icon-notext" style="margin:auto;"></a>
					<p style="margin:0px;font-size:.6em;">Back</p>
		</div>
		<div id="cancelorder" style="display:none;margin:auto;text-align:center;" onclick="$('#cancelorderconfirm').popup('open');">
					<!--<img src="/images/cancleorder.png" alt="Cancel" style="width:30px;height:30px;"/>-->
					<a href="#" class="ui-btn ui-corner-all ui-icon-delete ui-btn-icon-notext" style="margin:auto;"></a>
					<p style="margin:0px;font-size:.6em;">Cancel</p>
		</div>
		<div id="btnplaceorder" style="display:block;margin:auto;text-align:center;">
					<!--<img src="/images/placeorder.png" alt="Order" style="width:30px;height:30px;"/>-->
					<a href="#" class="ui-btn ui-corner-all ui-icon-grid ui-btn-icon-notext" style="margin:auto;"></a>
					<p style="margin:0px;font-size:.6em;">Order Summary</p>
		</div>
		<div id="callwaiter" style="display:none;margin:auto;text-align:center;">
					<!--<img src="/images/callwaiter.png" alt="Callwaiter" style="width:30px;height:30px;"/>-->
					<a href="#" class="ui-btn ui-corner-all ui-icon-user ui-btn-icon-notext" style="margin:auto;"></a>
					<p style="margin:0px;font-size:.6em;">Call Waiter</p>
		</div>
		<div id="gototop" style="display:block;margin:auto;text-align:center;">
					<!--<img src="/images/gototop.png" alt="Top" style="width:30px;height:30px;"/>-->
					<a href="#" class="ui-btn ui-corner-all ui-icon-carat-u ui-btn-icon-notext" style="margin:auto;"></a>
					<p style="margin:0px;font-size:.6em;">Top</p>
		</div>
	</div>
	
	<div data-role="collapsibleset" data-theme="a" data-mini="true" style="margin-bottom:30px;margin-top:1px;" style="z-index:20;">
		<div data-role="collapsible" data-collapsed="false" >
        <h3 >Restaurant Menu</h3>
			<?php 
				$itemgroup = '';
				echo '<ul id="menulist" data-role="listview" data-filter="true" data-inset="false">';
				foreach($restaurantmenu as $menuitem) { //foreach element in $arr
					if($itemgroup != $menuitem['IG']){
						$itemgroup = $menuitem['IG'];
						echo '<li data-role="list-divider">'.$itemgroup.'</li>';
					}
					$IT = ($menuitem['IT'] == 1)?'ic_veg.png':'ic_nonveg.png';
					echo '<li id="li'.$menuitem['TID'].'" class="menuitemli" data-icon="false"><a href="" id="anc'.$menuitem['TID'].'" style="padding-left:3px;padding-right:3px;">';
						echo '<div>';
							echo '<p id="tid" style="display:none">'.$menuitem['TID'].'</p>';
							echo '<div><button id="qtym'.$menuitem['TID'].'" class="ui-btn ui-btn-inline ui-corner-all ui-icon-minus ui-btn-icon-top cqtyminus" style="padding-top:10px;padding-bottom:30px;margin:0px;float:left;margin-right:5px;"></button></div>';
							echo '<div><button id="qtyp'.$menuitem['TID'].'" class="ui-btn ui-btn-inline ui-corner-all ui-icon-plus  ui-btn-icon-top cqtyplus" style="padding-top:10px;padding-bottom:30px;margin:0px;float:right;margin-left:5px;"></button></div>';
							
							echo '<div style="float:left;margin-top:4px;">';
								echo '<p id="oid'.$menuitem['TID'].'" style="margin:0px;font-weight:bold;float:left;margin-right:5px;">'.$menuitem['OID'].'.</p>';
								echo '<img id="img'.$menuitem['IT'].$menuitem['TID'].'" src="/images/'.$IT.'" style="width:15px;height:15px;float:left;"><br/>';
								echo '<p id="in'.$menuitem['TID'].'" style="margin:0px;">'.$menuitem['IN'].'</p>';
							echo '</div>';
							
							echo '<div style="float:right;margin-right:0px;margin-top:4px;">';
								echo '<p id="qty'.$menuitem['TID'].'" style="margin:0px;font-weight:bold;">Qty: 1</p>';
								echo '<p id="pip'.$menuitem['TID'].'" style="float:right;margin-top:7px;margin-bottom:0px">&#8377;&nbsp;<font id="ip'.$menuitem['TID'].'">'.$menuitem['IP'].'</font></p>';
							echo '</div>';
							
							if($menuitem['ID'] != ''){
								echo '<br/><br/><div>';
								echo '<p>'.$menuitem['ID'].'</p>';
								echo '</div>';
							}
							
						echo '</div>';
					echo '</a></li>'; 
				}
				echo '</ul>';
			?>
		</div>
    </div>	
	
	<div data-role="popup" id="popupos" class="ui-content" data-position-to="#resoptionbtns" data-transition="slideup">
		<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>
		
		<label id="osinfo" style="display:none;font-size:1em;color:red;">Custom info</label>
		<label for="Order"><u>Order summary</u>:</label>
		
		<div id="summarytable">
		</div>
		
		<div>
			<a id="btncancleos" href="#" class="ui-btn ui-btn-inline ui-corner-all ui-icon-back ui-btn-icon-left" onclick="$('#popupos').popup('close');">Cancel</a>
			<a id="btnorder" href="#" style="float:right;margin-right:0px" class="ui-btn ui-btn-inline ui-corner-all ui-icon-bullets ui-btn-icon-right">Order</a>
		</div>
	</div>
	
	<div data-role="popup" id="cancelorderconfirm" class="ui-content" data-position-to="#mainwin" data-transition="slideup">
		<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>
		
		<label for="Order"><u>Cancel Order?</u>:</label>	
		<div>
			<a  id="btncono" href="#" class="ui-btn ui-btn-inline ui-corner-all ui-icon-delete ui-btn-icon-left" onclick="$('#cancelorderconfirm').popup('close');"> No</a>
			<a id="btncoyes" href="#" class="ui-btn ui-btn-inline ui-corner-all ui-icon-check ui-btn-icon-right">Yes</a>
		</div>
	</div>
	
	<div data-role="popup" id="autopopup" class="ui-content" data-position-to="#mainwin" data-transition="slideup">
		<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>
		<label id="custinfo">Order received!<br>We will be at your table in a moment.</label>	
		
		<div style="display:block;margin:auto;text-align:center;">
			<a id="btnciok" href="#" class="ui-btn ui-btn-inline ui-corner-all ui-icon-check ui-btn-icon-right" onclick="$('#autopopup').popup('close')">Ok</a>
		</div>
	</div>
	
</div>
<?php include "footer.php" ?>