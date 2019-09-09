<?php
	
	$mode = $_REQUEST['mode'];
	unset($_REQUEST['mode']);

	if ( $mode == "update")
	{

		/* Фильтрация пустых данных */
		/************************************************************/
		foreach ($_REQUEST as $key => $a) 
		{
			if ( is_array($a) )
			{
				$form[$key] = array_diff($a, array(''));
			}
			else
			{
				$form[$key] = $a;
			}

			if ( empty($form[$key]) )
			{
				unset( $form[$key] );
			}
		}
		/************************************************************/

		$conf = $form['config'];
		unset( $form['config'] );

		$str = "";
		foreach ($form as $key => $set) 
		{
			foreach ($set as $nest => $value) 
			{
				$nest++;
				$value = addslashes($value);
				$str = "$conf $key $nest $value";
				exec('sudo ./ubedit/ubedit -u "' . $str . '"');
			}
		}
	}


	if ( $mode == "ins_wr")
	{
		foreach ($_REQUEST as $key => $value) 
		{
			$str = $str . $value . " ";
		}

		exec('sudo ./ubedit/ubedit -l "' . $str . '"');
	}

	if ( $mode == "exe" )
	{
		$script = $_REQUEST['script'];
		$conf = $_REQUEST['config'];

		$path = "\"./config/$conf/sh/";
		$per = "sudo ./config/stperm.sh";
		$path = $per . " " . $path . $script . "\"";
		
		exec($path, $out);
	}

	if ( $mode == "exel" )
	{
		$k = 0;
		$action = $_REQUEST['action'] . ".sh";
		$conf = $_REQUEST['config'];
		$str = " ";
		$path = "\"./config/$conf/sh/";

		unset($_REQUEST['action']);
		unset($_REQUEST['config']);

		foreach ($_REQUEST as $key => $value) 
		{
			if ( strstr($value, "\n") )
			{
				$k++;
				file_put_contents("$patht$k.txt", $value);
				$str .= "$patht$k.txt";
			}
			else
			{
				$str .= $value . " ";
			}
		}

		$per = "sudo ./config/stperm.sh";
		$path = $per . " " . $path . $action . $str . "\"";
		print_r($path);


		exec($path, $out);

		while ( $k > 0)
		{
			unlink("$patht$k.txt");
			$k--;
		}
	}
?>