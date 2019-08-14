<?php 

	include 'api.php';

	$conf = $_REQUEST['conf'];

	$html = file_get_contents("./tpl/header.tpl");
    $html = $html . file_get_contents("./tpl/nav.tpl");

	$modules = scandir("config");
	$modules = array_diff($modules, array('.', '..'));
	
	foreach ( $modules as $module )
		$str = $str . "<li><a href = '$module'>$module</a></li>" . PHP_EOL;
		
	$html = str_replace( "@@@@@", $str,  $html);

	$html = $html . file_get_contents("./tpl/work.tpl");
	$str = file_get_contents("./config/$conf/pattern.html");
	$html = str_replace( "@@@@@", $str,  $html);
	
	echo $html;

?>