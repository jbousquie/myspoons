<?php
$data = $_FILES['data'];
$file = '/home/jerome/public_html/myspoons/collect/log.txt';

//$st = var_dump($data);
$uploaded_file = $data['tmp_name'];
$target_file = $file;

$uuid = $_POST['uuid'];
$birth = $_POST['birth'];
$gender = $_POST['gender'];
$lang = $_POST['lang'];

file_put_contents($file, $lang);
//move_uploaded_file($uploaded_file, $target_file);
?>
