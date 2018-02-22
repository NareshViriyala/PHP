<?php include "header.php" ?>
<?php include "db_calls/globalvariables.php" ?>
<script>
		function submitclicked(){
			var val = $("#tbx_root").val();
			if (!$.isNumeric(val)){
				$('#tbx_root').parent().css('border-color','red');
				return;
			}
			
			$.ajax({
				type: "GET",
				url: "db_calls/GetEntityType?id=" + val,
				cache: false,
				success: function (data, status)
				{
					//alert(data);
					//return;
					if(data == "[]"){
						//$( "#popupCloseRight" ).popup("open");
						$( "#lbltextinfo" ).show();
						return;
					}
					
					var json = JSON.parse(data);
					
					switch(json[0].EntityType.toLowerCase()){
						case "restaurant":
							window.location.href = "restaurant?entityid="+val;
						break;
						case "hospital":
							window.location.href = "hospital?entityid="+val;
						break;
						case "securitycheck":
							window.location.href = "securitycheck?entityid="+val;
						break;
						case "customerfeedback":
							//window.location.href = "feedback/feedback_"+json[0].SubjectType.toLowerCase()+"?route="+$('#userid').html()+"&reroute="+val;							
							window.location.href = "customerfeedback?route="+$('#userid').html()+"&reroute="+val+"&type="+json[0].SubjectType.toLowerCase();							
						break;
						default:
							$('#tbx_root').parent().css('border-color','red');
						break;
					}
				},
				error: function (xhr, desc, err){$('#tbx_root').parent().css('border-color','red');}
			});				
		}
    	
    	function setBorder(){
    		$('#tbx_root').parent().css('border-color','grey');
    	}
    	
    	$(document).ready(function(event) {
    		$('#tbx_root').keypress(function(event) {
				$('#lbltextinfo').hide();
    			if (event.which == 13 ) {
    				submitclicked();
    			}
    		});
    	});
    </script>
    
    <div id="mainwin" data-role="main" class="ui-content contentcss">
		
    	<p class="highlights" style="margin-bottom:10px">logmenow</p>
    	<input type="search"  id="tbx_root" name="tbx_root" style="border-radius:4px" data-transition="slide" data-mini="true"/>
		<label id="lbltextinfo" style="display:none;font-size:1em;color:red;">Apollogies! we could not find any data for this ID.</label>
        <button class="ui-btn ui-btn-inline ui-corner-all ui-shadow ui-icon-search ui-btn-icon-left" onclick="submitclicked();">Search</button>			
    	<div data-role="popup" id="popupCloseRight" class="ui-content" data-arrow="true" style="max-width:280px" data-transition="slidedown" data-position-to="#tbx_root">
    		<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right" onclick="setBorder();">Close</a>
    		<p>Apollogies! we could not find any data for this ID.</p>
    	</div>
		
		<!--<div data-role="main" id="msg91" class="ui-content">
			<a href="https://msg91.com/startups/?utm_source=startup-banner">
				<img src="https://msg91.com/images/startups/msg91badge.png" width="120" height="90" title="msg91 - sms for startups" alt="bulk sms - msg91">
			</a>
    	</div>-->
		
    </div>
    
<?php include "footer.php" ?>