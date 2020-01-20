<?php
	
	/**
   	* Исполнение и излечение данных из скриптов
    *  
    * @param $module Системное имя модуля
    * @param $nesting Массив с кодом вложеностей
    *
    * @return Массив с данными от скриптов
    */
	function sh_execution_new($module, $nesting)
	{
		$path = $_SERVER['DOCUMENT_ROOT'];
		$file = "/ubconfig/turn_run";
		$timeout = 10;

		if ($module != "kernel")
			$path .= "/custom/modules/$module/sh";
		else
			$path .= "./kernel/tpl/sh";

		foreach ($nesting as $key => $nes) 
			$scripts[] = $nes['script'];
			
		$scripts = array_unique($scripts);

		foreach ($scripts as $key => $script) 
		{
			$command = "$timeout $path/$script";
			file_put_contents($file, "$command\n", FILE_APPEND);

			$file_result = "/ubconfig/$script.txt";

			while ( !file_exists($file_result) ) {}

			$result[$script] = file($file_result);
			unlink($file_result);
		}

		return $result;
	}

	/**
   	* Обработчик шаблонов
    *  
    * @param $tmp Код шаблона
    * @param $module Системное имя модуля
    *
    * @return Код шаблона с подстановкой данных
    */
	function sh_handler_new($module, $tmp)
	{
		$nesting = sh_analysis_nesting($tmp);
		$nesting = sh_analysis_script($nesting);
		$data = sh_execution_new($module, $nesting);

		$tmp = sh_control($tmp, $nesting, $data);

		return $tmp;
	}



?>