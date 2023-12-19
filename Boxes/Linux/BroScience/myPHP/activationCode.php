<?php

function generate_activation_code() {
	$chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
	$timeCode = readline('Enter Timestamp: ');
	srand($timeCode);
	$activation_code = "";
	
	for ($i = 0; $i < 32; $i++) {
        $activation_code = $activation_code . $chars[rand(0, strlen($chars) - 1)];
	}

	return $activation_code;
}

$nURL = 'https://broscience.htb/activate.php?code=' . generate_activation_code();
echo $nURL;

?>
