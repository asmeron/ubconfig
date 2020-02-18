<?php 

	include './kernel/lib/lib.php';
	include './kernel/lib/new_lib.php';
	include './kernel/lib/api.php';

	if ( file_exists("./kernel/aut") )
	{
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
		
		$Modules = Modules::getListModules();

		$in = array_search($info['Module'], array_keys($Modules));

		foreach ( $Modules as $IdModule => $Module )
		{
			if ( $Module->isStatusActive() )
			{
				$buff['Tab'][] = $Module->getTabDefault();
				$buff['Name'][] = $Module->getName();
				$buff['module'][] = $IdModule;
			}
		}

		$tabs = tab_list($conf);

		foreach ( $tabs as $key => $tab )
		{
			$buff['conf'][] = $conf;
			$buff['tab'][] = $key;
			$buff['tab_name'][] = tab_info($conf, $key, ['Name'])['Name'];
			$buff['but'][] = tab_info($conf, $key, ['Button_close'])['Button_close'];
		}

		$html = handler_base("base", $buff);

		$html = sh_handler("kernel", $html);
		$tmp = tab_code($conf, $mode);
		$html = str_replace( "@work@", $tmp,  $html);

		$html = sh_handler($conf, $html);
		$html = form_generation($html);

		echo $html;
	}
	else
	{
		$html = kernel_tmp("aut");
		echo $html;
	}
?>