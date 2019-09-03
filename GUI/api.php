<?php

	function read_setting($str)
	{
		$reg = '/name\s=\s(.+)\n.+alt\s=\s(.+)\n.+type\s=\s(.+)\n.+action\s=(.+)\n.+collect_values\s=\s\((.+)\)/';
		preg_match_all($reg, $str, $temp);


		$result['name'] = $temp[1];
		$result['alt'] = $temp[2];
		$result['type'] = $temp[3];
		$result['action'] = $temp[4];
		$result['value'] = $temp[5];

		return $result;
	}

	function read_info($path, $derictives = NULL)
	{
		$reg = '/(.+)\s=\s(.+)/i';

		if ( $derictives == NULL)
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
		$reg = '/<formprepross>((.|\n)*?)<\/formprepross>/i';
		preg_match_all( $reg, $str, $pattern);
		$pattern = $pattern[1];

		foreach ($pattern as $key => $pat) 
		{	
			$form = read_setting($pat);

			foreach ($form['type'] as $key => $conf) 
			{
				$temp = file_get_contents("./config/grf/$conf/pattern.html");
				$temp = preg_replace('/\$name/', $form['name'][$key], $temp);
				preg_match_all('/@(.+)@/', $temp, $array);
				$st = '';
				$values = preg_split('/[,]/', $form['value'][$key]);

				foreach ($values as $keys => $value) 
				{
					$array1 = explode(":", $value);
					$buff = $array[1][0];
					$buff = preg_replace('/\$value_key/', $array1[0], $buff);
					$buff = preg_replace('/\$value_name/', $array1[1], $buff);
					$st = $st . $buff . PHP_EOL;
				}

				$temp = preg_replace('/@.+@/', $st, $temp);
				$ar = $ar . $temp;
			}

			$str = str_replace($pattern, $ar, $str);
			$ar = "";
		}


		
		return $str;

	}

	function handler_pattern($path)
	{
		$str = file_get_contents($path);
		$path = strstr($path, "tabs", true);
		preg_match_all('/`(.+)`/', $str, $scripts);

		foreach ($scripts[1] as $key => $script) 
		{
			exec($path . "sh/" . $script, $out);
			$str = str_replace( "`" . $script . "`", $out[0],  $str);
			unset($out);
		}

		$str = form_generation($str);
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

?>