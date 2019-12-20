/**
* Поиск и выделение активной вкладки
*
*/
function active_tab()
{
	tab = get_id_tab();

	if ( $('div').hasClass('tabs') )
		$('.'+tab).addClass('Active_tab');
}

/**
* Централизуем post-запросы
*
* @param mode - флаг обработки отправляемый серверу
* @parem date - Дополнительные данные для отправки на сервер
* @param action - Функция которую небходимо выполнить при завершения запроса
*/
function post_req(mode, date, action)
{
	$.post("/kernel/lib/handler.php?mode="+mode, date, action);
}


/**
* Централизуем обьявленеие обработчика нажатия
*
* @param descript - Селектор элемента
* @parem action - Функция обработчика
*
*/
function add_handler(descript, action)
{
	$(''+descript).on('click', function() { action( $(this) ) } );
}


/**
* Обработчик элементов класса action
*
* @param element - Нажатый элемент
*
*/
function action(element)
{
	test = element.attr("value");
	config = get_id_module();

	post_req("exe", {script : test, config : config}, 
			
		function(date) 
		{
			location.reload();
		}
	);
}

/**
* Обработчик элементов класса form_handler
*
* @param element - Нажатый элемент
*
*/
function form_handler(element)
{
	form = element;

	while ( form.prop("tagName") != "FORM" )
	{
		form = form.parent();
	}

	action = form.attr('action');
	config = get_id_module();

	form = form.serializeArray();
	form.push({name: 'action', value: action });
	form.push({name: 'config', value: config });

	post_req("exel", form, 

		function()
		{
			location.reload();
		}
	)
}

/**
* Обработчик элементов класса page_gen
*
* @param element - Нажатый элемент
*
*/
function page_gen(element)
{
	form = element.parent();
	action = element.attr('file');

	par = element.attr('par_name');
	val = element.attr('par_val');
	config = get_id_module();

	form = form.serializeArray();
	form.push({name: 'action', value: action });

	form.push({name: 'config', value: config });
	form.push({name: par , value: val });

	post_req("gen", form,

		function(date)
		{
			//document.location.href = date;
			location.reload();
		}

	)

}

/**
* Обработчик удаление вкладок
*
* @param element - Нажатый элемент
*
*/
function close(element)
{
	config = get_id_module();

	file = element.parent().parent();
	file = file.children('h3');
	file = file.attr('class');

	pos = file.indexOf(' ',0);

	if (pos > 0)
		file = file.slice(0,pos);

	post_req("del", {action : file, config : config},

		function(date)
		{
			document.location.href = date;
		}

	);
}

/**
* Обработчик аутентификаций
*/
function aut()
{
	form = $('#aut').serializeArray();

	post_req("aut", form,

		function(date)
		{
			location.reload();
		}

	);
}

/**
* Обработчик выхода
*/
function out_log()
{
	post_req("out","", 

		function()
		{
			location.reload();
		}

	)
}

/**
* Обработчик скачивание файлов
*
* @param element - Нажатый элемент
*
*/
function downloand_file(element)
{
	form = element.parent();
	file = element.attr('file');

	form = form.serializeArray();
	form.push({name: 'file', value: file });

	post_req("file", form,

		function(date)
		{
			var data = new Blob(["\ufeff", [date]],{type:'plain/text'});
			var file = window.URL.createObjectURL(data);
			window.location.href=file;
		}

	);
}

/**
* Перехватываем стандартный обработчик форм
*
*/
$('Form').on('submit',

	function(e)
	{
 		e.preventDefault();
	}

);

active_tab();

add_handler('.action', action );
add_handler('.form_handler', form_handler);

add_handler('.page_gen', page_gen);
add_handler('.close', close);

add_handler('.sumb', aut);
add_handler('#out_login', out_log);

add_handler('.down_file', downloand_file);