<?php

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
				$result[$key] = "Not found";

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

		$reg = '/([A-z]+):=\s*(.+)/';
		$result = preg_replace($reg, '', $file);

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

?>