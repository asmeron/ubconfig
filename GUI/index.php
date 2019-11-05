<?php 

	include './kernel/lib/info.php';
	include './kernel/lib/api.php';

	/* Обработка параметров */
	/************************************************************/
	$conf = $_REQUEST['conf'];
	$mode = $_REQUEST['mode'];

	$base = file_get_contents("./kernel/base.info");
	$reg = '/([A-z]+)\s*=\s*(.+)/';

	$info = parse_info($reg, $base, ['Module', 'Tab']);

	if ( $mode == NULL )
		$mode = $info['Tab'];

	if ( $conf == NULL )
		$conf = $info['Module'];
	/************************************************************/
	

	/* Формирование заголовка и меню модулей */
	/************************************************************/
	$tmp = kernel_tmp("base");
	$html = handler_pattern($tmp, "./kernel/tpl/");

	$modules = module_list();

	$in = array_search($info['Module'], $modules);
	$id = array_search( reset($modules), $modules);

	if ( $in > 0 )
		list( $modules[$id], $modules[$in] ) = array($modules[$in], $modules[$id]);

	
	foreach ( $modules as $key => $module )
	{
		$info = module_info($module);

		if ( module_status($module) )
		{
			$buff[$key]['Tab'] = $info['Tab'];
			$buff[$key]['Name'] = $info['Name'];
			$buff[$key]['module'] = $module;
		}
	}

	$tmp = kernel_tmp("modules");
	$str = handler_temp($tmp, $buff);
	unset($buff);
	$html = str_replace( "\$modules_list\$", $str,  $html);
	/************************************************************/
	$str = "";

	$path = "./custom/modules/$conf/";
	$tmp = tab_code($conf, $mode);
	$tpl = handler_pattern($tmp, $path);

	$tabs = tab_list($conf);

	foreach ( $tabs as $key => $tab )
	{
		$buff[$key]['conf'] = $conf;
		$buff[$key]['tab'] = $key;
	}

	$tmp = kernel_tmp('tabs');
	$str = handler_temp($tmp, $buff);
	unset($buff);

	$html = str_replace( "\$work\$", $tpl,  $html);
	$html = str_replace( "\$tabs\$", $str,  $html);

	echo $html;
	
?>