<?php 

	include 'api.php';

	/* Обработка параметров */
	/************************************************************/
	$conf = $_REQUEST['conf'];
	$mode = $_REQUEST['mode'];
	$info = read_info("./base.info", ["Tab", "Module"]);

	if ( $mode == NULL )
		$mode = $info['Tab'];

	if ( $conf == NULL )
		$conf = $info['Module'];
	/************************************************************/
	

	/* Формирование заголовка и меню модулей */
	/************************************************************/
	$html = file_get_contents("./tpl/base.tpl");

	$modules = scandir("config");
	$modules = array_diff($modules, array('.', '..', 'grf', 'stperm.sh'));
	
	foreach ( $modules as $key => $module )
	{
		$path = "config/" . $module . "/" . $module . ".info";
		$info = read_info($path);

		if ( $info['Status'] == "Active" )
		{
			$buff[$key]['Tab'] = $info['Tab'];
			$buff[$key]['Name'] = $info['Name'];
			$buff[$key]['module'] = $module;
		}
	}

	$str = handler_temp("./tpl/modules.tpl", $buff);
	unset($buff);
	$html = str_replace( "\$modules_list\$", $str,  $html);
	/************************************************************/
	$str = "";

	if ( $mode != "expert" )
	{
		$path = "./config/$conf/tabs/$mode.tpl";
		$tpl = handler_pattern($path);

		$path = "./config/$conf/tabs";
		$tabs = scandir($path);
		$tabs= array_diff($tabs, array('.', '..'));

		foreach ( $tabs as $key => $tab )
		{
			$tab = strstr($tab, ".tpl", true);
			$buff[$key]['conf'] = $conf;
			$buff[$key]['tab'] = $tab;
		}

		$str = handler_temp("./tpl/tabs.tpl", $buff);
		unset($buff);

	}
	else
	{
		/* Формирование экспертной формы редактирования */
		/************************************************************/
		exec('./ubparse/ubparse -t "set bb" -f ' . $conf, $tpl);
		$tpl = implode($tpl);
		$tpl .= file_get_contents("./tpl/button.tpl");
		/************************************************************/
	}

	$html = str_replace( "\$work\$", $tpl,  $html);
	$html = str_replace( "\$tabs\$", $str,  $html);

	echo $html;
	
?>