/**
* Парсер адресной строки
* @param count - номер элемнта по размешение в строке(через слеш)
* 
* @return Извлеченую подстроку
*
*/
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

/**
* Получение активного модуля
* 
* @return Системное имя активного модуля
*
*/
function get_id_module()
{
	return parese_url(1);
}

/**
* Получение активной вкладки
* 
* @return Системное имя активного вкладки
*
*/
function get_id_tab()
{
	return parese_url(2);
}