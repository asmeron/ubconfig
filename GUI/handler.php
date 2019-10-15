<?php
	
	$mode = $_REQUEST['mode'];
	unset($_REQUEST['mode']);

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

?>