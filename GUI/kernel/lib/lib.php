<?php

	// Информационный компонент
	// **************************************************************

	/**
   	* Извлечение служебных данных из файлов
    *  
    * @param $reg Шаблон формата служебных данных
    * @param $str содержимое файла
    * @param $keys набор ключей по которым необходимо получиь данные
    *
    * @return массив с служебными данными
    */
	function parse_info($reg, $str, $keys)
	{
		preg_match_all($reg, $str, $buff);

		foreach ($buff[0] as $index => $val) 
		{
			$key = $buff[1][$index];
			$value = $buff[2][$index];

			if ( $keys == NULL or in_array($key, $keys) )
				$result[$key] = $value; 
		}

		foreach ($keys as $key) 
			if ( !array_key_exists($key, $result) )
				$result[$key] = "Not_found";

		return $result;

	}

	/**
   	* Получение всех подкаталогов в катологе
    *  
    * @param $path Путь до каталога
    *
    * @return массив с именами подкатологов
    */
	function list_catalog($path)
	{
		$catalogs = scandir($path);
		$catalogs = array_diff($catalogs, array('.', '..'));

		foreach ($catalogs as  $key => $catalog) 
		{
			if ( !is_dir("$path/$catalog") )
				unset($catalogs[$key]);
		}

		return array_values($catalogs);
	}

	/**
   	* Получение служебной информаций о модуле
    *  
    * @param $module системное имя модуля
    * @param $keys набор ключей по которым необходимо получиь данные
    *
    * @return массив с данными о модуле
    */
	function module_info($module, $keys = NULL)
	{
		$path = "./custom/modules/$module/base.info";

		if ( file_exists($path) )
			$file = file_get_contents($path);
		else
			return "Module not found";

		$reg = '/([A-z]+)\s*=\s*(.+)/';
		$result = parse_info($reg, $file, $keys);

		return $result;
	}

	/**
   	* Получение справочной информации модуля
    *  
    * @param $module системное имя модуля
    *
    * @return Текст справки
    */
	function moudule_help($module)
	{
		$path = "./custom/modules/$module/help";

		if ( file_exists($path) )
			$result = file_get_contents($path);
		else
			$result = "Help file not found";

		return $result;
	}

	/**
   	* Получение всех установленых модулей
    *
    * @return Массив с системными именами модулей
    */
	function module_list()
	{
		$path = "./custom/modules";
		return list_catalog($path);
	}

	/**
   	* Проверка статуса доступности модуля
    *
    * @param $module системное имя модуля
    *
    * @return TRUE в случае доступности
    */
	function module_status($module)
	{
		$status = module_info($module, ['Status']);
		$status = $status['Status'];

		if ( $status == 'Active')
			$status = TRUE;
		else
			$status = FALSE;

		return $status;
	}

	/**
   	* Получение служебной информаций о вкладке
    *  
    * @param $module системное имя модуля
    * @param $tab системное имя вкладки
    * @param $keys набор ключей по которым необходимо получиь данные
    *
    * @return массив с данными о вкладке
    */
	function tab_info($module, $tab, $keys = NULL)
	{
		$path = "./custom/modules/$module/tabs/$tab.tpl";
		
		if ( file_exists($path) )
			$file = file_get_contents($path);
		else
			return "Tab not found";

		$reg = '/([A-z]+):\s*(.+)/';
		$result = parse_info($reg, $file, $keys);

		return $result;
	}

	/**
   	* Извлечение кода шаблона вкладки
    *  
    * @param $module системное имя модуля
    * @param $tab системное имя вкладки
    * @param $type тип вкладки
    *
    * @return код вкладки
    */
	function tab_code($module, $tab, $type = 'tpl')
	{
		$path = "./custom/modules/$module/tabs/$tab.$type";

		if ( file_exists($path) )
			$file = file_get_contents($path);
		else
			return "Tab not found";

		$pos = strpos($file, "<");
		$result = substr($file, $pos);

		return $result;
	}

	/**
   	* Получение всех вкладок из модуля
    *  
    * @param $module системное имя модуля
    *
    * @return Массив с вкладками
    */
	function tab_list($module)
	{
		$path = "./custom/modules/$module/tabs/*.tpl*";
		$buff = glob($path);

		foreach ($buff as $key => $value) 
		{
			$tab = explode("/", $value);
			$tab = array_pop($tab);
			$tab = strstr($tab, ".", TRUE);

			$name = tab_info($module, $tab, ['Name'] );
			$name = $name['Name'];

			$result[$tab] = $name;
		}

		return $result;
	}

	/**
   	* Получение кода шаблона ядра
    *  
    * @param $tmp Имя шаблона
    *
    * @return Код шаблона
    */
	function kernel_tmp($tmp)
	{
		$path = "./kernel/tpl/$tmp.tpl";
		
		if ( file_exists($path) )
			$tpl = file_get_contents($path);
		else
			return "Template not found";

		return $tpl;
	}

	/**
   	* Получение набора визуальный обьектов
    *  
    * @return массив с именами обьектов
    */
	function element_list()
	{
		$path = "./custom/elements";
		return list_catalog($path);
	}

	/**
   	* Получение руководство использование визуального обьекта
    *  
    * @param $element Имя визуального обьекта
    *
    * @return Текст руководства
    */
	function element_help($element)
	{
		$path = "./custom/elements/$element/man";

		if ( file_exists($path) )
			$result = file_get_contents($path);
		else
			return "Man not found";

		return $result;
	}

	/**
   	* Получение реализаций визуального обьекта
    *  
    * @param $element Имя визуального обьекта
    *
    * @return Массив с кодом визуального обьекта
    */
	function element_code($element)
	{
		$path = "./custom/elements/$element";
		$type = ['main.html', 'style.css', 'script.js'];

		foreach ($type as $key => $value) 
		{
			$buff = "$path/$value";
			$value = strstr($value, ".");
			$value = substr($value,1);

			if ( file_exists($buff) )
				$result[$value] = file_get_contents($buff);
			else
				$result[$value] = "$value file not found";
		}

		return $result;	
	}

	// **************************************************************


	// Компонент базовой обработки 
	// **************************************************************

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

	// **************************************************************

	// **************************************************************
	/* Компонент обработки шаблонов

	/**
   	* Анализ шаблона на вложености
    *  
    * @param $tmp Код шаблона
    *
    * @return Массив с кодом вложеностей
    */
	function sh_analysis_nesting($tmp)
	{

		$pos1 = strpos($tmp, "&:") + 2;
		$pos2 = strpos($tmp, ":&");
		$pos3 = strpos($tmp, "&:", $pos1);

		$i = 0;
		$j = 0;

		while ( $pos1 && $pos2 ) 
		{

			if ( $pos3 != FALSE && $pos3 < $pos2 )
			{
				$leg = $pos2 - $pos3 - 2;
				$result[$i][$j] = substr($tmp, $pos3 + 2, $leg);

				$pos2 = strpos($tmp, ":&", $pos2 + 2);
				$j++;
			}
			
			$leg = $pos2 - $pos1;
			$line = substr($tmp, $pos1, $leg);
			$result[$i][$j] = $line;
			$result[$i]['nes'] = $j + 1;

			$tmp = str_replace("&:".$line.":&", "", $tmp);
			$i++;

			$pos1 = strpos($tmp, "&:") + 2;
			$pos2 = strpos($tmp, ":&");
			$pos3 = strpos($tmp, "&:", $pos1);
			$j = 0;

		}

		$reg = '/.*`(.+)`.*/';
		preg_match_all($reg, $tmp, $out);

		foreach ($out[0] as $key => $line)
		{
			$result[$i][0] = $line;
			$result[$i]['nes'] = 0;
			$i++;
		}

		return $result;
	}

	/**
   	* Анализ шаблона на содержание скриптов
    *  
    * @param $nesting Массив с кодом вложеностей
    *
    * @return Массив с кодом вложеностей и обнаружеными скриптами
    */
	function sh_analysis_script($nesting)
	{
		foreach ($nesting as $key => $nes) 
		{
			$nes = $nes[0];

			$reg = '/`(.+)`/';
			preg_match_all($reg, $nes, $out);

			$script = $out[1][0];
			$param = strstr($script, "@");
			$param = substr($param, 1);

			if ( $param != "") 
			{
				$param = explode(",", $param);
				$nesting[$key]['param'] = $param;
			}

			$nesting[$key]['script'] = strstr($script, "@", TRUE);
		}

		return $nesting;
	}

	/**
   	* Исполнение и излечение данных из скриптов
    *  
    * @param $module Системное имя модуля
    * @param $nesting Массив с кодом вложеностей
    *
    * @return Массив с данными от скриптов
    */
	function sh_execution($module, $nesting)
	{
		if ($module != "kernel")
			$path = "./custom/modules/$module/sh";
		else
			$path = "./kernel/tpl/sh";


		$root = "./kernel/stperm.sh";

		foreach ($nesting as $key => $nes) 
			$scripts[] = $nes['script'];
			
		$scripts = array_unique($scripts);

		foreach ($scripts as $key => $script) 
		{
			$command = "$root \"$path/$script\"";
			exec($command, $buff);

			$result[$script] = $buff;
			$buff = "";
		}

		return $result;
	}


	/**
   	* Обработка одиночной выборки
    *  
    * @param $tmp Код шаблона
    * @param $nesting Массив с кодом вложеностей
    * @param $data Массив с данными от скриптов
    * @param $ind Индекс выборки
    *
    * @return Код шаблона с подстановкой данных
    */
	function sh_single($tmp, $nesting, $data, $ind = 0)
	{
		$script = $nesting['script'];
		$str = "`$script@";

		if ( $ind != 0)
		{
			$str .= "$ind";
			$ind--;
		}
		
		$str .= "`";
		$value = $data[$script][$ind];
		$tmp = str_replace($str, $value, $tmp);

		return $tmp;
	}


	/**
   	* Обработка простой множественой выборки
    *  
    * @param $tmp Код шаблона
    * @param $nesting Массив с кодом вложеностей
    * @param $data Массив с данными от скриптов
    * @param $min Индекс начальной точки выборки
    * @param $max Индекс конечной точки выборки
    *
    * @return Код шаблона с подстановкой данных
    */
	function sh_easy_multiple($tmp, $nesting, $data, $min = 0, $max = 0)
	{
		$script = $nesting['script'];
		$line = $nesting[0];
		$str = "`$script@";
		$result = "";

		if ( $min != 0 )
		{
			$str .= "$min";
			$min--;
		}

		if ( $max != 0 )
		{	
			$str .= ",$max";
			$max--;

			if ( $max > $data[$script] )
				$max = count($data[$script]) - 1;
		}
		else
			$max = count($data[$script]) - 1;

		$str .= "`";

		for ( $i = $min; $i <= $max; $i++)
		{
			$result .= str_replace($str, $data[$script][$i], $line);
			$result .= PHP_EOL;
		}

		$tmp = str_replace("&:$line:&", $result, $tmp);

		return $tmp;
	}


	/**
   	* Обработка сложной множественой выборки
    *  
    * @param $tmp Код шаблона
    * @param $nesting Массив с кодом вложеностей
    * @param $data Массив с данными от скриптов
    * @param $repeat Количество элементов в группе
    * @param $count Количество групп
    *
    * @return Код шаблона с подстановкой данных
    */
	function sh_hard_multiple($tmp, $nesting, $data, $repeat, $count = 0)
	{
		$script = $nesting['script'];
		$line = $nesting[1];
		$str = "`$script@$repeat";
		$result = "";

		if ( $count == 0)
		{
			$count = count($data[$script]);
			$count = intdiv($count, $repeat) - 1;
		}
		else
			$str .= ",$count";

		$str .= "`";

		for ( $i = 0; $i <= $count; $i++)
		{
			$min = $i * $repeat + 1;
			$max = $min + $repeat - 1;
			$st = "`$script@$min,$max`";

			$buff = str_replace($str, $st, $line);
			$nes = $nesting;
			$nes[0] = str_replace($str, $st, $nes[0]);
			$buff = sh_easy_multiple($buff, $nes, $data, $min, $max);

			$nes = sh_analysis_nesting($buff);
			$nes = sh_analysis_script($nes);

			$min--;

			for ( $j = $min; $j < $max; $j++)
				$dat[$script][] = $data[$script][$j];

			$buff = sh_control($buff, $nes, $dat);
			$dat[$script] = array();

			$result .= $buff;
			
		}

		$tmp = str_replace("&:$line:&", $result, $tmp);

		return $tmp;
	}

	/**
   	* Управление обработчиками выборки
    *  
    * @param $tmp Код шаблона
    * @param $nesting Массив с кодом вложеностей
    * @param $data Массив с данными от скриптов
    *
    * @return Код шаблона с подстановкой данных
    */
	function sh_control($tmp,$nesting, $data)
	{
		foreach ($nesting as $key => $nes) 
		{
			$nest = $nes['nes'];
			$param = count($nes['param']);

			if ( $nest == 0 )
			{
				if ($param == 0)
					$tmp = sh_single($tmp, $nesting[$key], $data);
				else
					$tmp = sh_single($tmp, $nesting[$key], $data, $nes['param'][0]);

			}

			if ($nest == 1)
			{
				if ($param == 0)
					$tmp = sh_easy_multiple($tmp, $nesting[$key], $data);
				elseif ($param == 1) 
					$tmp = sh_easy_multiple($tmp, $nesting[$key], $data, $nes['param'][0]);
				else
					$tmp = sh_easy_multiple($tmp, $nesting[$key], $data, $nes['param'][0], $nes['param'][1]);
			}

			if ($nest == 2)
			{
				if ($param == 1)
					$tmp = sh_hard_multiple($tmp, $nesting[$key], $data, $nes['param'][0]);
				else
					$tmp = sh_hard_multiple($tmp, $nesting[$key], $data, $nes['param'][0], $nes['param'][1]);
			}
		}

		return $tmp;
		
	}

	/**
   	* Обработчик шаблонов
    *  
    * @param $tmp Код шаблона
    * @param $module Системное имя модуля
    *
    * @return Код шаблона с подстановкой данных
    */
	function sh_handler($module, $tmp)
	{
		$nesting = sh_analysis_nesting($tmp);
		$nesting = sh_analysis_script($nesting);
		$data = sh_execution($module, $nesting);
		
		$tmp = sh_control($tmp, $nesting, $data);

		return $tmp;
	}

	// **************************************************************

?>