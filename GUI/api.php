<?php

	function read_setting($path)
	{
		$conf = file_get_contents($path);
		$reg = '/name\s=\s(.+)\n.+alt\s=\s(.+)\n.+type\s=\s(.+)\n.+collect_values\s=\s\((.+)\)/';
		preg_match_all($reg, $conf, $temp);


		$result['name'] = $temp[1];
		$result['alt'] = $temp[2];
		$result['type'] = $temp[3];
		$result['value'] = $temp[4];

		return $result;
	}
	

?>