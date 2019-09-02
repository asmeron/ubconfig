<?php 

	include 'api.php';

	/* Обработка параметров */
	/************************************************************/
	$conf = $_REQUEST['conf'];
	$mode = $_REQUEST['mode'];

	if ( $mode == NULL )
		$mode = "base";

	if ( $conf == NULL )
		$conf = "dashboard";
	/************************************************************/
	

	/* Формирование заголовка и меню модулей */
	/************************************************************/
	$html = file_get_contents("./tpl/base.tpl");

	$modules = scandir("config");
	$modules = array_diff($modules, array('.', '..', 'grf', 'stperm.sh'));
	
	foreach ( $modules as $module )
	{
		$st = file_get_contents("config/" . $module . "/" . $module . ".info");
		print_r($st);
		$str = $str . "<li><a href = '/$module/base'>$module</a></li>" . PHP_EOL;
	}
		
	$html = str_replace( "\$modules_list\$", $str,  $html);
	/************************************************************/

	if ( $conf != "base" )
	{
		/* Формирование вкладок */
		/************************************************************/
		$str = "<a href = '/$conf/base'><h3>base</h3></a>";
		$modules = scandir("./config/$conf/patterns");
		$modules = array_diff($modules, array('.', '..'));
		
		foreach ( $modules as $module )
			$str = $str . "<a href = '/$conf/$module'><h3>$module</h3></a>";
			
		$html = str_replace( "\$tabs\$", $str,  $html);
		/************************************************************/

		if ( $mode == "base")
		{
			$path = "./config/$conf/";
			$str = handler_pattern($path);

		}

		elseif ( $mode == "expert" ) 
		{
			/* Формирование основной формы редактирования */
			/************************************************************/
			exec('./ubparse/ubparse -t "set bb" -f ' . $conf, $str);
			$str = implode($str);
			/************************************************************/
		}

		else
		{
			/* Генерация продвинутой графической формы */
			/************************************************************/
			$test = read_setting("./config/$conf/patterns/$mode");
			$str = "<div class='block'><h2>$mode</h2>";

			foreach ($test['type'] as $key => $conf) 
			{
				$temp = file_get_contents("./config/grf/$conf/pattern.html");
				$temp = preg_replace('/\$name/', $test['name'][$key], $temp);
				preg_match_all('/@(.+)@/', $temp, $array);
				$st = '';
				$values = preg_split('/[,]/', $test['value'][$key]);

				foreach ($values as $keys => $value) 
				{
					$array1 = explode(":", $value);
					$buff = $array[1][0];
					$buff = preg_replace('/\$value_key/', $array1[0], $buff);
					$buff = preg_replace('/\$value_name/', $array1[1], $buff);
					$st = $st . $buff . PHP_EOL;
				}

				$temp = preg_replace('/@.+@/', $st, $temp);
				$str = $str . $temp;
				/************************************************************/

			}


		}
		
		$html = str_replace( "\$work\$", $str,  $html);
	}
	else
	{
		$html = str_replace( "\$tabs\$", "",  $html);
		$html = str_replace( "\$work\$", "",  $html);
	}
	
	echo $html;
	
?>