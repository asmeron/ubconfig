<?php

	/*
	* Поиск файлов определеного типа
	*
	* @param $path путь поиска
	* @param $type искомый тип файла
	*
	* @returns массив с именами файлов
	*/

	function find_file($path, $type) 
	{
		$files = scandir($path);
		$files = array_diff($files, array('.', '..'));

		foreach($files as $file) 
		{
			if (strpos($file, '.' . $type)) 
				$result[] = $file;
		}

		return $result;

	 }
	 
?>