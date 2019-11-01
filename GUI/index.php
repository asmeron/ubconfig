<?php 

	include './kernel/lib/api.php';

	/* Обработка параметров */
	/************************************************************/
	$conf = $_REQUEST['conf'];
	$mode = $_REQUEST['mode'];
	$info = read_info("./kernel/base.info", ["Tab", "Module"]);

	if ( $mode == NULL )
		$mode = $info['Tab'];

	if ( $conf == NULL )
		$conf = $info['Module'];
	/************************************************************/
	

	/* Формирование заголовка и меню модулей */
	/************************************************************/
	$html = handler_pattern("./kernel/tpl/base.tpl");

	$modules = scandir("./custom/modules");
	$modules = array_diff($modules, array('.', '..', 'stperm.sh'));

	$in = array_search($info['Module'], $modules);
	$id = array_search( reset($modules), $modules);

	if ( $in > 0 )
		list( $modules[$id], $modules[$in] ) = array($modules[$in], $modules[$id]);
	
	foreach ( $modules as $key => $module )
	{
		$path = "custom/modules/" . $module . "/" . $module . ".info";
		$info = read_info($path);

		if ( $info['Status'] == "Active" )
		{
			$buff[$key]['Tab'] = $info['Tab'];
			$buff[$key]['Name'] = $info['Name'];
			$buff[$key]['module'] = $module;
		}
	}

	$str = handler_temp("./kernel/tpl/modules.tpl", $buff);
	unset($buff);
	$html = str_replace( "\$modules_list\$", $str,  $html);
	/************************************************************/
	$str = "";

	$path = "./custom/modules/$conf/tabs/$mode.tpl";
	$tpl = handler_pattern($path);

	$path = "./custom/modules/$conf/tabs";
	$tabs = scandir($path);
	$tabs= array_diff($tabs, array('.', '..'));

	foreach ( $tabs as $key => $tab )
	{
		if ( strrpos($tab, ".tpl") )
		{
			$tab = strstr($tab, ".tpl", true);
			$buff[$key]['conf'] = $conf;
			$buff[$key]['tab'] = $tab;
		}
	}

	$str = handler_temp("./kernel/tpl/tabs.tpl", $buff);
	unset($buff);

	$html = str_replace( "\$work\$", $tpl,  $html);
	$html = str_replace( "\$tabs\$", $str,  $html);

	echo $html;
	
?>