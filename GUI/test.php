<?php

	function out($title, $reg, $game)
	{
		preg_match_all($reg, $game, $status);
		$status = $status[1][0];

		if ( $status != NULL )
			$status = "Cracked!";
		else
			$status = "Not cracked?";
			
		echo "$title...$status<br><br>";
	}

	$page = $_REQUEST['page'];
	$page1 = $_REQUEST['page1'];
	$search = $_REQUEST['search'];

	if ( $page == NULL )
		$page = 0;

	if ( $page1 == NULL )
		$page1 = $page;

	$text = "";

	for ( $i = $page; $i < $page1+1; $i++)
	{
		$request = "https://api.crackwatch.com/api/games?page=$i&sort_by=release_date&is_released=true";
		$text = file_get_contents($request);
	

		$reg = '/{([^}]+)}/';
		preg_match_all($reg, $text, $games);

		$reg = '/"title":"([^"]+)"/';
		$reg1 = '/"crackDate":"([^"]+)"/';

		foreach ($games[1] as $key => $game) 
		{
			preg_match_all($reg, $game, $title);
			$title = $title[1][0];

			if ( $search == NULL )
				out($title, $reg1, $game);
			else
				if ( $title == $search)
					out($title, $reg1, $game);
			
		}
	}

?>