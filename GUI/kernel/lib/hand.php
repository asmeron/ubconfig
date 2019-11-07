<?php

	/**
   	* Обработка шаблона на слияние с другими
    *  
    * @param $tpl код шаблона
    *
    * @return Код шаблона слитый с другими
    */
	function handler_join($tpl)
	{
		$reg = '/\?(.+)\?/';
		preg_match_all($reg, $tpl, $list);

		foreach ($list[1] as $key => $pattern) 
		{
			$buff = kernel_tmp($pattern);
			$tpl = str_replace($list[0][$key], $buff, $tpl);
		}

		return $tpl;
	}

	/**
   	* Анализ шаблона на наличие переменых значений
    *  
    * @param $tpl код шаблона
    *
    * @return Массив с структурой переменых значений
    */
	function handler_analysis($tpl)
	{
		$reg = '/.+(\$[A-z]+).+/';

		preg_match_all($reg, $tpl, $out);

		foreach ($out[0] as $key => $value) 
				$result[][0] = $value;


		foreach ($result as $key => $res) 
		{
			$buff = $res[0];
			preg_match_all($reg, $buff, $out);

			do 
			{
				$var = $out[1][0];

				$result[$key][1][] = $var;
				$buff = str_replace($var,"", $buff);
				preg_match_all($reg, $buff, $out);
			} 
			while ( !empty($out[0]) );

		}

		return $result;

	}

	/**
   	* Подстановка переменых значений в шаблон
    *  
    * @param $tpl код шаблона
    * @param $chaches массив с информацией о подстановке
    * @param $values Набор значеней для подстановки
    *
    * @return Код шаблона с подстановочными значениями
    */
	function handler_replace($tpl, $chaches, $values)
	{
		foreach ($chaches as $key => $chache) 
		{
			$obj = $chache[0];
			$test = $chache[1][0];
			$test = substr($test, 1);
			$str = "";

			foreach ($values[$test] as $key => $value) 
			{
				$st = $obj;

				foreach ($chache[1] as $ind => $variable) 
				{
					$var = substr($variable, 1);
					$st = str_replace($variable, $values[$var][$key], $st);
				}

				$str .= $st;
			}

			$tpl = str_replace($obj, $str, $tpl);
		}

		return $tpl;
	}

	/**
   	* Базовая обработка шаблона
    *  
    * @param $tpl код шаблона
    * @param $values Набор значеней для подстановки
    *
    * @return Код шаблона готовый к отрисовки
    */
	function handler_base($tpl, $values)
	{
		$tpl = kernel_tmp($tpl);
		$tpl = handler_join($tpl);
		
		$chaches = handler_analysis($tpl);
		$tpl = handler_replace($tpl, $chaches, $values);

		return $tpl;
	}

?>