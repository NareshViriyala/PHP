<?php include "header.php" ?>
<script>
var pagenumber = 0;
var pagecount = 10;
var fetching = false;
var allfetched = false;

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

function formatevent(historyevent){
	//alert(historyevent);
	var li = '<li data-icon="false" style="margin-bottom:8px;margin-left:8px;margin-right:8px;" class="ui-responsive ui-shadow"><a href="" style="padding-bottom:3px;padding-top:3px;">';
	var data = historyevent.Info.replace(/\|/g,"\"");//{"EntityName":"Cream Stone","Total items":2,"Total bill":226};
	//alert(data);
	var json = JSON.parse(data);
	//alert(json);
	li = li + '<img src="images\\'+historyevent.Image+'" style="position:absolute;top:0;bottom:0;margin:auto;padding-left:8px">';
	li = li + '<h2 style="margin-top:0px;">'+historyevent.OID+'. '+ historyevent.Type + '</h2>';
	li = li + '<div style="float:left;"><p style="color:#3F51B5;margin-top:0px;margin-bottom:0px;">'+json['EntityName']+'</p>';
	switch(historyevent.Type){
		case 'Restaurant':
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Items: '+json['Total items']+'</p>';
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Bill amount: &#8377; '+json['Total bill']+'</p>';
		break;
		case 'Hospital':
			li = li + '<p style="color:#3F51B5;font-weight:bold;margin-top:0px;margin-bottom:0px;">'+json['DoctorName']+'</p>';
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Appointment # '+json['ApptID']+'</p>';
			if(json['OutDate'] == '')
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Queue # '+json['QCnt']+'</p>';
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Consultation Fee : &#8377; '+json['Fee']+'</p>';
			if(json['InDate'] != '')
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">In time : '+json['InDate']+'</p>';
			if(json['OutDate'] != '')
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Out time : '+json['OutDate']+'</p>';	
			if(json['Remark'] != '')
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Remark : '+json['Remark']+'</p>';
		break;
		case 'General Visit':
			var info = json['Information Shared'];
			if(info['Name'] != null)
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Name: '+info['Name']+'</p>';
			if(info['Phone'] != null)
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Phone: '+info['Phone']+'</p>';
			if(info['Email'] != null)
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Email: '+info['Email']+'</p>';
			if(info['HomeAddress'] != null)
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">HomeAddress: '+info['HomeAddress']+'</p>';
			if(info['OfficeAddress'] != null)
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">OfficeAddress: '+info['OfficeAddress']+'</p>';
			if(info['DOB'] != null)
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Date of birth: '+info['DOB']+'</p>';
			if(info['Age'] != null)
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Age: '+info['Age']+'</p>';
			if(info['Sex'] != null)
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Gender: '+info['Sex']+'</p>';
			if(info['Vehicle'] != null)
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Vehicle# : '+info['Vehicle']+'</p>';
			if(info['ComingFrom'] != null)
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Coming From: '+info['ComingFrom']+'</p>';
			if(info['Purpose'] != null)
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Purpose of visit: '+info['Purpose']+'</p>';
			if(info['VisitingCompany'] != null)
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Visiting Company: '+info['VisitingCompany']+'</p>';
			if(info['ContactPerson'] != null)
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Contact Person: '+info['ContactPerson']+'</p>';
			if(info['Block'] != null)
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Block: '+info['Block']+'</p>';
			if(info['Flat'] != null)
			li = li + '<p style="margin-top:0px;margin-bottom:0px;">Flat: '+info['Flat']+'</p>';
		break;
		default:
		break;
	}
	li = li + '<h6 style="font-size:.7em;margin-bottom:0px;">' + historyevent.LogTime + '</h6>';
	li = li + '</div>';
	li = li + '</a></li>';
	return li;
}

function fetchhistory(){
	pagenumber = pagenumber + 1;
	//alert(pagenumber)
	$.ajax({
		type: "POST",
		url: "db_calls/GetClientHistory",
		data: { 'DeviceID': $('#userid').html(), 'PageNumber':pagenumber, 'PageCount': pagecount},
		cache: false,
		success: function (data, status)
		{
			//alert(data);
			var json = JSON.parse(data);
			if(json.length < pagecount)
				allfetched = true;
			$.each(json, function(i, historyevent){
				$("#userhistory").append(formatevent(historyevent));
			});
			$("#userhistory").listview("refresh");
			fetching = false;
		},
		error: function (xhr, desc, err)
		{
			alert("We could not fetch your history! please try again.");
		}
	});	
	
}

$(document).ready(function(event) {
	//fetchhistory();
	
	$("#gototop").click(function(){
		$("html, body").animate({ scrollTop: 0 }, 300);
	});
	
	$(function() {
		$(window).scroll(sticky_relocate);
		sticky_relocate();
	});
	
	$(window).scroll(function() {
	   if($(window).scrollTop() + $(window).height() > $(document).height() - 100 && !fetching && !allfetched) {
		   //$(window).unbind('scroll');
		   //alert("scroll end");
		   fetching = true;
		   fetchhistory();
	   }
	});
});
</script>
<div id="mainwin" data-role="main" class="ui-content" style="padding-top:3px">
	<div id="sticky-anchor"></div> <!--this div to requite to stick the options on top-->
	<div id="resoptionbtns" class="ui-content withoutorder" data-mini="true" style="padding-top:3px;padding-bottom:1px;padding-left:0px;padding-right:0px;">
		<div style="display:block;margin:auto;text-align:center;" onclick="window.history.back();">
					<!--<img src="/images/backarrow.png" alt="Back" style="width:30px;height:30px;"/>-->
					<a href="#" class="ui-btn ui-corner-all ui-icon-carat-l ui-btn-icon-notext" style="margin:auto;"></a>
					<p style="margin:0px;font-size:.6em;">Back</p>
		</div>
		
		<div id="btnhome" style="display:block;margin:auto;text-align:center;" onclick='document.location.href="/"'>
					<!--<img src="/images/placeorder.png" alt="Order" style="width:30px;height:30px;"/>-->
					<a href="#" class="ui-btn ui-corner-all ui-icon-home ui-btn-icon-notext" style="margin:auto;"></a>
					<p style="margin:0px;font-size:.6em;">Home</p>
		</div>
		<div id="gototop" style="display:block;margin:auto;text-align:center;">
					<!--<img src="/images/gototop.png" alt="Top" style="width:30px;height:30px;"/>-->
					<a href="#" class="ui-btn ui-corner-all ui-icon-carat-u ui-btn-icon-notext" style="margin:auto;"></a>
					<p style="margin:0px;font-size:.6em;">Top</p>
		</div>
	</div>
	<ul data-role="listview" data-inset="false" id="userhistory" data-filter="true" data-filter-placeholder="Search..." style="margin-bottom:35px;">
		
    </ul>
</div>
<?php include "footer.php" ?>