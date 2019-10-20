<?php

	function read_setting($str)
	{
		$directives = ["name", "alt", "type", "default", "collect_values" ];

		foreach ($directives as $key => $directive) 
		{
			$reg = "/$directive\s=\s\(((.|\n)*?)\)/";
			preg_match_all($reg, $str, $temp);
			$result[$directive] = $temp[1];
		}

		return $result;
	}

	function read_info($path, $directives = NULL)
	{
		$reg = '/(.+)\s=\s(.+)/i';

		if ( $directives == NULL)
			$directives = ["Name", "Status", "Tab"];

		$info = file_get_contents($path);
		preg_match_all($reg, $info, $res);

		foreach ($res[1] as $key => $directive) 
		{
			if ( in_array($directive, $directives) )
			{
				$result["$directive"] = $res[2][$key];
			}
		}
		
		return $result;

	}
	
	function form_generation($str)
	{
		$reg = '/<formprepross\saction\s=.+>((.|\n)*?)<\/formprepross>/i';
		preg_match_all( $reg, $str, $pattern);
		$pattern = $pattern[1];

		foreach ($pattern as $key => $pat) 
		{	
			$form = read_setting($pat);

			foreach ($form['type'] as $key => $conf) 
			{
				$temp = file_get_contents("./grf/$conf/pattern.html");

				$temp = preg_replace('/\$name/', $form['name'][$key], $temp);
				$temp = preg_replace('/\$default/', $form['default'][$key], $temp);
				$temp = preg_replace('/\$alt/', $form['alt'][$key], $temp);

				preg_match_all('/@(.+)@/', $temp, $array);
				$st = '';
				print_r($form['value'][$key]);
				$values = preg_split('/[,]/', $form['collect_values'][$key]);

				foreach ($values as $keys => $value) 
				{
					$array1 = explode(":", $value);
					$buff = $array[1][0];
					$buff = preg_replace('/\$value_key/', $array1[0], $buff);
					$buff = preg_replace('/\$value_name/', $array1[1], $buff);
					$st .= $buff . PHP_EOL;
				}

				$temp = preg_replace('/@.+@/', $st, $temp);
				$ar .= $temp . PHP_EOL;
			}

			$str = str_replace($pat, $ar, $str);
			$ar = "";
		}

		$but = file_get_contents("./tpl/button.tpl") . PHP_EOL . "</formprepross>";
		$str = str_replace("</formprepross>", $but, $str);
		$str = str_replace("formprepross", "form", $str);

		return $str;

	}

	function handler_temp($path, $values)
	{
		$tpl = file_get_contents($path);
		preg_match_all('/@(.+)@/', $tpl, $str);
		$str = $str[1][0];
		$result = "";
		
		foreach ($values as $key => $value) 
		{
			$buff = $str;

			foreach ($value as $key => $val) 
			{
				$buff = str_replace("$".$key, $val, $buff);
			}

			$result .= $buff . PHP_EOL;
		}

		$result = str_replace("@".$str."@", $result, $tpl);
		return $result;
		
	}

	function handler_pattern($path)
	{
		$str = file_get_contents($path);
		$str = form_generation($str);
		
		if ( strstr($path, "tabs", true) )
			$path = strstr($path, "tabs", true);
		else
			$path = strstr($path, "base", true);

		
		$reg = '/`.*?([A-z | \.  | " | \/ | 0-9 ]+)[ @ | #][0-9]*?`/';

		preg_match_all($reg, $str, $scripts);
		$scripts[0] = array_unique($scripts[0]);
		$scripts[1] = array_unique($scripts[1]);

		foreach ($scripts[1] as $key => $script) 
		{
			exec($path . "sh/" . $script, $out[$script]);
		}

		foreach ($scripts[0] as $key => $value) 
		{
			if ( strpos($value, "@") )
			{
				$ind = strstr($value, "@");
				$ind = strstr($ind, "`", true);
				$ind = substr($ind, 1);
				$ind --;

				$name = strstr($value, "@", true);
				$name = substr($name, 1);

				$str = str_replace($value , $out[$name][$ind],  $str);
			}

			if ( strpos($value, "#") )
			{
				$valuecs = addcslashes($value, "/");
				$reg = "/.*$valuecs.*/";
				preg_match_all($reg, $str, $pat);
				$pat = $pat[0];

				$name = strstr($value, "#", true);
				$name = substr($name, 1);

				foreach ($pat as $key => $pat) 
				{
					$res = "";

					foreach ($out[$name] as $key => $val) 
					{
						$st = str_replace($value, $val, $pat);
						$res .= $st . PHP_EOL;
					}

					$str = str_replace($pat, $res, $str);
				}
			}

		}

		return $str;
	}

?>