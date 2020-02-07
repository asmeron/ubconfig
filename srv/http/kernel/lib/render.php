<?php

	include 'lib.php';
	include 'api.php';
	chdir('../..');

	$mode_render = $_REQUEST['mode_render'];

	$conf = $_REQUEST['conf'];

	if ( $mode_render == "work" )
	{
		$mode = $_REQUEST['mode'];

		$tmp = tab_code($conf, $mode);

		$tmp = sh_handler($conf, $tmp);
		$tmp = form_generation($tmp);

		echo $tmp;
	}

	if ( $mode_render == "tabs" )
	{
		$tabs = tab_list($conf);

		foreach ( $tabs as $key => $tab )
		{
			$buff['conf'][] = $conf;
			$buff['tab'][] = $key;
			$buff['tab_name'][] = tab_info($conf, $key, ['Name'])['Name'];
			$buff['but'][] = tab_info($conf, $key, ['Button_close'])['Button_close'];
		}

		$tmp  = handler_base("tabs", $buff);

		echo $tmp;
	}
?>