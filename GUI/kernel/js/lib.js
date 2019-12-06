function parese_url(count)
{
	config = window.location.href;
	pos1 = config.indexOf('/');
	pos1 += 2;

	for ( i=0; i < count; i++)
	{
		pos1 = config.indexOf('/', pos1);
		pos1 += 1;
	}

	pos2 = config.indexOf('/', pos1);

	if (pos2 == -1)
		pos2 = config.length;

	config = config.slice(pos1, pos2);

	return config;
}

function get_id_config()
{
	return parese_url(1);
}

function get_id_tab()
{
	return parese_url(2);
}