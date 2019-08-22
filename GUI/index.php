<?php 

	include 'api.php';

	$conf = $_REQUEST['conf'];
	$mode = $_REQUEST['mode'];

	if ( $mode == NULL )
		$mode = "base";

	//foreach(find_file('./tpl', 'tpl') as $file)
            //$html = $html . file_get_contents("./tpl/$file");
	$html = file_get_contents("./tpl/header.tpl");
    $html = $html . file_get_contents("./tpl/nav.tpl");

	$modules = scandir("config");
	$modules = array_diff($modules, array('.', '..', 'grf'));
	
	foreach ( $modules as $module )
		$str = $str . "<li><a href = '/$module/base'>$module</a></li>" . PHP_EOL;
		
	$html = str_replace( "@@@@@", $str,  $html);
	$str= "<a href = '/$conf/base'><h3>base</h3></a>";


	//$test=shell_exec("/srv/http/Ubparse/test2");
	$html = $html . file_get_contents("./tpl/work.tpl");

	$modules = scandir("./config/$conf/patterns");
	$modules = array_diff($modules, array('.', '..'));
	
	foreach ( $modules as $module )
		$str = $str . "<a href = '/$conf/$module'><h3>$module</h3></a>";
		
	$html = str_replace( "\$tabs", $str,  $html);

	if ( $mode == "base")
	{
		$str = file_get_contents("./config/$conf/pattern.html");
	}
	else
	{
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

		}

		$str = $str . "</div>";

	}
	
	$html = str_replace( "@@@@@", $str,  $html);
	echo $html;

	/*$test = read_setting("./config/apache/patterns/test");

	foreach ($test['type'] as $key => $conf) 
	{
		$temp = file_get_contents("./config/grf/$conf/pattern.html");
		$temp = preg_replace('/\$name/', $test['name'][$key], $temp);
		preg_match_all('/@(.+)@/', $temp, $array);
		$str = '';
		$values = preg_split('/[,]/', $test['value'][$key]);

		foreach ($values as $keys => $value) 
		{
			$array1 = explode(":", $value);
			$buff = $array[1][0];
			$buff = preg_replace('/\$value_key/', $array1[0], $buff);
			$buff = preg_replace('/\$value_name/', $array1[1], $buff);
			$str = $str . $buff . PHP_EOL;
		}

		$temp = preg_replace('/@.+@/', $str, $temp);

	}
	
	//print_r($test);*/
?>