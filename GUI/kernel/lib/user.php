<?php

	function aut($login, $password)
	{

		$file = file_get_contents("./kernel/user");

		$reg = '/([A-z]+):=(.+)/';
		preg_match_all($reg, $file, $users);

		$ind = array_search($login, $users[1]);

		if ( md5($password) == $users[2][$ind] )
			return TRUE;
		else
			return FALSE;
	
	}
?>