<?php 

	$html = file_get_contents('./tpl/header.htm');
	$html = $html . file_get_contents('./tpl/nav.html');
	$html = $html . file_get_contents('./tpl/work.html');
	echo $html;

?>