/**
* Поиск и выделение активной вкладки
*
*/
function active_tab()
{
	tab = get_id_tab();

	if ( $('div').hasClass('tabs_r') )
	{
		$('.tabs_r .tabs h3').removeClass('Active_tab');
		$('.tabs_r .tabs .'+tab).addClass('Active_tab');

	}

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
			render_work();
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
			conf = get_id_module();
			mode = get_id_tab();

			conf = "/"+conf+"/"+mode;
			history.pushState(null, null, conf);
			render_work();
			render_tabs();
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
			conf = get_id_module();

			conf = "/"+conf+"/"+date;
			history.pushState(null, null, conf);
			render_work();
			render_tabs();
			
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
			conf = get_id_module();

			conf = "/"+conf+"/"+date;
			history.pushState(null, null, conf);
			render_work();
			render_tabs();
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
* Показ и скрытие окна ошибко
*
* @param status
*
*/
function show_window_eror(status)
{
	if ( !status )
	{

		$('.mask').fadeIn(500);
		$('.error_window').css('display', 'block');
	}
	else
	{
		$('.error_window').css('display', 'none');
		$('.mask').fadeOut(500);
	}
}

function check_error()
{
	error = $('.area_error p').text();

	if (error != "@error@")
	{
		show_window_eror(false);
	}
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


function render(data, div_draw)
{		
	$.post("/kernel/lib/render.php", data, 

			function(date)
			{
				delete_handlers();
				$(div_draw).html(date);
				active_tab();
				add_hadlers();

			}
		);
}

function render_work()
{
	conf = get_id_module();
	mode = get_id_tab();
	mode_render = "work";

	render({conf : conf, mode : mode, mode_render : mode_render}, '.work_zone');
}

function render_tabs()
{
	conf = get_id_module();
	mode_render = "tabs";

	render({conf : conf, mode_render : mode_render}, '.tabs_r');
}

function transition(element)
{
	event.preventDefault()
	link = element.attr('href');
	history.pushState(null, null, link);

	type = element.parent().attr('class');

	if ( type == 'modules' )
		render_tabs();
	
	render_work();
	
	active_tab();
}



let list_element = ['.action',
					 '.form_handler',
					 '.page_gen',
					 '.close',
					 '.sumb',
					 '#out_login',
					 '.down_file',
					 '#close',
					 '.modules a',
					 '.tabs a'];

let list_function = [action,
					 form_handler,
					 page_gen,
					 close,
					 aut,
					 out_log,
					 downloand_file,
					 show_window_eror,
					 transition,
					 transition];

active_tab();

function add_hadlers()
{

	list_element.forEach(

		function(item, i)
		{
			add_handler(item, list_function[i]);
		}

		);

	$('Form').on('submit',

	function(e)
	{
 		e.preventDefault();
	}

);

}

function delete_handlers()
{
	list_element.forEach(

		function(item)
		{
			$(item).off();
		}

		);
}

check_error();
add_hadlers();
