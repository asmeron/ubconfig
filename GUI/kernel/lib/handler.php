<?php
	
	include 'api.php';
	include 'lib.php';
	include 'user.php';
	chdir('../..');

	$mode = $_REQUEST['mode'];
	unset($_REQUEST['mode']);

	if ( $mode == "del")
	{
		$conf = $_REQUEST['config'];
		$file = $_REQUEST['action'];

		$path = "./custom/modules/$conf/tabs/$file.tpl";
		unlink($path);

		$info = module_info($conf, ['Tab']);

		echo $info['Tab'];

	}

	if ( $mode == "exe" )
	{
		$script = $_REQUEST['script'];
		$conf = $_REQUEST['config'];

		$path = "\"./custom/modules/$conf/sh/";
		$per = "sudo ./kernel/stperm.sh ";
		$path = $per . " " . $path . $script . "\"";
		
		exec($path, $out);
		print_r($out);
	}

	if ( $mode == "exel" )
	{
		$k = 0;

		if ( !strrpos($action, ".sh") )
			$action = $_REQUEST['action'] . ".sh";

		$conf = $_REQUEST['config'];
		$str = " ";
		$path = "\"./custom/modules/$conf/sh/";

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
			elseif ( is_array( $value ) )
			{
				$str .= implode(" ", $value);
			}
			else
			{
				if ($value != "")
					$str .= "\"$value\"" . " ";
				else
					$str .= "\\\\". " ";
			}
		}

		$per = "sudo ./kernel/stperm.sh";
		$path = $per . " " . $path . $action . $str . "\"";

		print_r($path);
		exec($path, $out);
		print_r($out);

		$tr = "";

		while ( $k > 0)
		{
			unlink("$patht$k.txt");
			$k--;
		}


		foreach ($out as $key => $value) 
		{
			$tr .= "<br>$value<br>";
		}

		echo $tr;
	}

	if ( $mode == "gen" )
	{
		$conf = $_REQUEST['config'];
		$file = $_REQUEST['action'];
		unset($_REQUEST['action']);
		unset($_REQUEST['config']);

		$path = "./custom/modules/$conf/tabs/$file";
		$str = file_get_contents("$path.dpl");
		$k = 0;

		foreach ($_REQUEST as $key => $value) 
		{
			$str = str_replace("?$key?", $value, $str);
		}

		$path = "$path.tpl";

		while ( file_exists($path) ) 
		{
			$k++;

			if ( $k == 1)
			{
				$path= str_replace(".tpl", "_$k.tpl", $path);
			}
			else
			{
				$buf = $k - 1;
				$path = str_replace("_$buf.tpl", "_$k.tpl", $path);
			}

		}

		file_put_contents($path, $str);
		$path = str_replace(".tpl", "", $path);
		
		if ($k == 0) 
		{
			echo "$file";
		}
		else
		{
			echo $file."_".$k;
		}
	}

	if ($mode == "tail" )
	{
		$conf = $_REQUEST['config'];
		$action = $_REQUEST['action'];
		$text = $_REQUEST['text'];
		$path = "./custom/modules/$conf/sh/$action";

		$text = explode("\n", $text);
		$text = array_filter($text);
		$text = array_reverse($text);
		$text = implode("\n", $text);


		file_put_contents("tail.txt", $text);
		exec($path, $out);
		$out = array_reverse($out);
		
		foreach ($out as $key => $value)
		{
			echo "$value\n";
		}
	}

	if ( $mode == "aut" )
	{
		$status = aut($_REQUEST['login'], $_REQUEST['password']);

		if ( $status )
			file_put_contents("./kernel/aut", $_REQUEST['login']);

	}

	if ($mode == "file")
	{
		$file_or = $_REQUEST['file'];
		$file = strrchr($file_or, "/");
		$file = substr($file, 1);

		$root = "./kernel/stperm.sh";
		$command = $root . " \"cat " . $file_or ."\" > $file" ;

		exec($command);
		readfile($file);

		unlink($file);
		exit;
	}

	if ($mode == "out")
	{
		unlink('./kernel/aut');
	}

	if ($mode == "save" )
	{
		$root = "sudo ./kernel/stperm.sh";

		$script = "/usr/local/bin/save_conf_ubfs";
		$command = $root . " \"$script\"" ;

		exec($command, $out);
		print_r($out);
 	}

?>