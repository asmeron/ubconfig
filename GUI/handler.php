<?php
	
	include 'api.php';

	$mode = $_REQUEST['mode'];
	unset($_REQUEST['mode']);

	if ( $mode == "del")
	{
		$conf = $_REQUEST['config'];
		$file = $_REQUEST['action'];

		$path = "./config/$conf/tabs/$file.tpl";
		unlink($path);

		$info = read_info("./config/$conf/$conf.info", ["Tab"]);

		echo $info['Tab'];

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
			elseif ( is_array( $value ) )
			{
				$str .= implode(" ", $value);
			}
			else
			{
				$str .= $value . " ";
			}
		}

		$per = "sudo ./config/stperm.sh";
		$path = $per . " " . $path . $action . $str . "\"";

		exec($path, $out);

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

		$path = "./config/$conf/tabs/$file";
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

		$str .= "<button class='close'>Close</button>";
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

?>