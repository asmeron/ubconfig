function get_id_config()
{
	config = window.location.href;
	pos1 = config.indexOf('fig/');
	pos1 += 4;
	pos2 = config.indexOf('/', pos1);
	config = config.slice(pos1, pos2);

	return config;
}

function get_id_tab()
{
	tab = window.location.href;
	pos = tab.indexOf('fig/');
	pos += 4;
	pos = tab.indexOf('/', pos);
	pos++;
	tab = tab.slice(pos);

	return tab;
}