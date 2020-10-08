var DEBUG = false;
var selectedUser = null;

$(document).ready(function() {
	
	//set hostname for brand
	$("#hostname").text(lightdm.hostname);
	log("hostname: " + lightdm.hostname);

	//create a list of session options
	var sessions = [];

	for ( i in lightdm.sessions ) {
		var session = lightdm.sessions[i];
		log("session: " + session.name);
		if (session.name=='kiosk') continue;
		if (session.name=='ssm') continue;
		html_session = "<div class=\"radio\"><label>"+
				"<input type=\"radio\" name=\"session\" value=\""+i+"\" ";
		if (session.key==lightdm.default_session)
			html_session += " checked ";
		html_session += ">"+session.name+"</label></div>";
		sessions.push(html_session);

	}

	$("#session").append(sessions);

	$("#test").click( function() {
		log("test...");
		session_key = $('input[name="session"]:checked').val();
		session = lightdm.sessions[session_key];
		log("SESSION: "+session_key);
	});


	$("#login").click( function(e) {
		e.preventDefault();
		log("Log in button clicked");
		logIn();
	});
	
	$("#inputUsername").keypress(function(e) {
		if( e.which == 13 ) {
			e.preventDefault();
			$("#inputPassword").focus();
		}
	});

	$("#inputPassword").keypress(function(e) {
		if( e.which == 13 ) {
			e.preventDefault();
			logIn();
		}
	});
	
	$("#session").keypress(function(e) {
		if( e.which == 13 ) {
			e.preventDefault();
			logIn();
		}
	});
	
	$("#ospite").click(function(e) {
		e.preventDefault();
		$("#inputUsername").val("ospite");
		logIn();
	});

	if(DEBUG) {
		$("#log").show();

	}
	log("default_session: " + lightdm.default_session);

});

function logIn() {
    $("#connecting").show();
	selectedUser = $("#inputUsername").val();
	log("logging in with user: " + selectedUser);
	lightdm.start_authentication( selectedUser );
}

function submitPassword(){
	log("submitPassword called");
	lightdm.provide_secret($("#inputPassword").val());
}

function authentication_complete() {
    $("#connecting").hide();
	log("authentication_complete called");
	log("is_authenticated: " + lightdm.is_authenticated);
	log("auth_user: " + lightdm.authentication_user);
	if( lightdm.is_authenticated ) {
		session_key = $('input[name="session"]:checked').val();
		session = lightdm.sessions[session_key];
		lightdm.login( lightdm.authentication_user, session.key); 
	} else {
		log("authentication failed");
		$("#inputPassword").val("");
        $("#authfailed").show();
	}
}

function show_prompt(text) {
	log("show_prompt called");
	log("show_prompt text: " + text);
	submitPassword()
}

function log(text) {
	if(DEBUG) {
		$("#log").append(text);
		$("#log").append("<br/>");
	}
}

