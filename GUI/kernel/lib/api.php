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
				$temp = element_code($conf);
				$temp = $temp['html'];

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

		$but = kernel_tmp('button') . PHP_EOL . "</formprepross>";
		$str = str_replace("</formprepross>", $but, $str);
		$str = str_replace("formprepross", "form", $str);

		return $str;

	}

?>