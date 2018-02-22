
		<div id = "footer" data-role="footer" style="z-index:10;"> 
			<p id="contactus" class="footerpara" style="float:left;margin-left: 10px;" onclick="$('#feedbackpopup').popup('open');">Feedback</p>
			<p id="login" class="footerpara" style="float:right;margin-right: 10px;" onclick="showLogin();"><?php echo $username;?></p>
		</div>
		
		<div data-role="popup" id="popupLogin" class="ui-content" data-overlay-theme="b" data-position-to="#mainwin" data-transition="slideup">
			<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>
			
			<label id="lblinfo" style="display:none;font-size:1em;color:red;">Custom info</label>
			<label for="login">Login:</label>
			<div id="divname" style="display:none;">
				<input type="text" name="name" id="name" placeholder="Name"/>
			</div>
			<input type="number" name="phonenumber" id="phonenumber" placeholder="Phone number"/>
			<div id="divemail" style="display:none;">
				<input type="text" name="email" id="email" placeholder="Email"/>
			</div>
			<div id="divpassword">
				<input type="password" name="password" id="password" placeholder="Password" />
			</div>
			<div id="divconfipassword" style="display:none;">
				<input type="password" name="confipassword" id="confirmpassword" placeholder="Confirm Password" />
			</div>
			<div id="divotp" style="display:none;">
				<input type="password" name="inputotp" id="inputotp" placeholder="OTP" />
			</div>
			<div id="loginbtns" style="margin-bottom:30px">
				<a id="btncancle" href="#" class="ui-btn ui-btn-inline ui-corner-all ui-icon-back ui-btn-icon-left" onclick="$('#popupLogin').popup('close');">Cancel</a>
				<a id="btnsignin" href="#" style="float:right;margin-right:0px" class="ui-btn ui-btn-inline ui-corner-all ui-icon-check ui-btn-icon-right" onclick="signin();">Sign in</a>
				<br/>
				<p class="footerpara" style="float:left;color:blue;" id="newuser">New User</p>
				<p class="footerpara" style="float:right;color:blue;" id="forgotpassword">Forgot Password</p>
			</div>
		</div>
		
		<div data-role="popup" id="popupLogout" class="ui-content" data-overlay-theme="b" data-position-to="#mainwin" data-transition="slideup">
			<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>
			
			<div class="ui-content" style="padding:0px;">
				<a href="#" id="logout" class="ui-btn ui-btn-inline ui-corner-all ui-shadow" style="width:80%;">Logout</a>
				<br/>
				<a href="#" id="changepassword" class="ui-btn ui-btn-inline ui-corner-all ui-shadow" style="width:80%;">Change Password</a>
				<div id="divchangepassword" class="ui-content ui-corner-all" style="display:none;">
					<label for="chgnpaddword" id="chngpassowrdreason" style="display:none;font-size:1em;color:red;"></label>
					<input type="password" name="currentpassword" id="currentpassword" placeholder="Current password" />
					<input type="password" name="newpassword" id="newpassword" placeholder="New password" />
					<input type="password" name="confirmnewpassword" id="confirmnewpassword" placeholder="Confirm new password" />
					<a href="#" id="btnchngpass" class="ui-btn ui-btn-inline ui-corner-all ui-shadow" style="width:80%;">Save</a>
				</div>
				<br/>
				<a href="" id="history" class="ui-btn ui-btn-inline ui-corner-all ui-shadow" style="width:80%;">History</a>
			</div>
		</div>
		
		<div data-role="popup" id="popupsuggestlogin" class="ui-content" data-position-to="#mainwin" data-transition="slideup">
			<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>
			
			<div class="ui-content" style="display:block;margin:auto;text-align:center;padding:0px;">
				<label for="login" id="loginreason">NULL</label>
				<a href="#" id="slcancel" class="ui-btn ui-btn-inline ui-corner-all ui-shadow" onclick="$('#popupsuggestlogin').popup('close');">Cancel</a>
				<a href="#" id="slok" class="ui-btn ui-btn-inline ui-corner-all ui-shadow">Login</a>
			</div>
		</div>
		
		<div data-role="popup" id="feedbackpopup" class="ui-content" data-position-to="#mainwin" data-transition="slideup">
			<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>
			<label for="txtareafeedback"><u>We value your feedback.</u></label>
			<textarea type="text" id="txtareafeedback" maxlength="500" style="margin-bottom:0px;margin-top:0px;"></textarea>
			
			
			<div>
				<a href="#" class="ui-btn ui-btn-inline ui-corner-all ui-shadow ui-icon-back ui-btn-icon-left" onclick="$('#feedbackpopup').popup('close');">Cancel</a>
				<a href="#" id="fbsubmit" class="ui-btn ui-btn-inline ui-corner-all ui-shadow ui-icon-check ui-btn-icon-right" style="float:right;margin-right:0px">Submit</a>
			</div>
		</div>
	</body>
	<script src="/scripts/footer.js"></script>
</html> 