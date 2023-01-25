<?php

if ($_SERVER['REQUEST_METHOD'] != 'POST' ) {
  exit('Wrong request');
}

$expected = 'mY5p00n2';
$key = $_POST['key'];
if ($key != $expected) {
  exit('Wrong key');
} 


$data = $_FILES['data'];
$path = '/home/jerome/public_html/myspoons/collect/files/';

$uploaded_file = $data['tmp_name'];



$uuid = $_POST['uuid'];
$birth = $_POST['birth'];
$gender = $_POST['gender'];
$lang = $_POST['lang'];

$date = date_create();
$stamp = date_timestamp_get($date);

$uuid = trim($uuid, '[]#');

$id = $uuid . '_' . $birth. '_' . $gender . '_' . $lang . '_' .$stamp;
$file = $path . $id;
$target_file = $file;

//file_put_contents($file, $id, FILE_APPEND);
move_uploaded_file($uploaded_file, $target_file);
?>
