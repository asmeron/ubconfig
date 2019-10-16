var $content, form, config;


tab = get_id_tab();

$('.'+tab).addClass('Active_tab');

// Расвертывание/Свертывание блоков
///////////////////////////////////////////////////////////
$('.block .block h2').on('click',
	
	function()
	{
		$content = $(this).parent();
		
		if ( $content.css('border-style') != 'none' )
		{
			$content.children('span').css('display','none');
			$content.children('div').css('display','none');
			$content.css('border', 'none');
		}
		else
		{
			$content.children('span').css('display','list-item');
			$content.children('div').css('display','block');
			$content.css('border', 'solid 4px #0C2C4B');
		}
	}
	
);

$('Form').on('submit',

	function(e)
	{
 		e.preventDefault();
	}

);


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

///////////////////////////////////////////////////////////

// Ajax-обработка изменений в форме
///////////////////////////////////////////////////////////
$('#save').on('click',

	function()
	{
		config = get_id_config();

		form = $('#EditForm').serializeArray();
		form.push({name: 'config', value: config });

		$.post("/handler.php?mode=update", form,

			function( data )
			{
				alert( "Complite" );
			}

		);
	}

);
///////////////////////////////////////////////////////////

$('.delete').on('click',

	function()
	{
		config = get_id_config();

		$content = $(this).parent();
		$content = $content.children("label");

		key = $content.text();
		nest = $content.index("[for = " + key + " ]");
		nest++;

		$.post("/handler.php?mode=ins_wr", { config : config, key : key, nest : nest }, 

			function( date )
			{

			},
		)
		.done
		(
			function()
			{
				$content.parent().remove();
			}

		)

	}

);

$('.action').on('click',

	function()
	{
		test = $(this).attr("value");
		config = get_id_config();

		$.post("/handler.php?mode=exe", {script : test, config : config},

			function(date)
			{
				location.reload()
			}

		);
	}

);

$('.form_handler').on('click',

	function()
	{
		$('.mask').fadeIn(200);
		form = $(this).parent();
		action = form.attr('action');
		config = get_id_config();

		form = form.serializeArray();
		form.push({name: 'action', value: action });
		form.push({name: 'config', value: config });

		$.post("/handler.php?mode=exel", form,

			function(date)
			{
				alert("Изменения внесены");
				location.reload();
			}

		);
	}

);

$('.out_handler').on('click',

	function()
	{
		form = $(this).parent();
		action = form.attr('action');
		config = get_id_config();

		form = form.serializeArray();
		form.push({name: 'action', value: action });
		form.push({name: 'config', value: config });

		$.post("/handler.php?mode=exel", form,

			function(date)
			{
				$('.out_div').html(date);
			}

		);
	}
);

$('.page_gen').on('click',

	function()
	{
		form = $(this).parent();
		action = $(this).attr('file');
		config = get_id_config();

		form = form.serializeArray();
		form.push({name: 'action', value: action });
		form.push({name: 'config', value: config });

		$.post("/handler.php?mode=gen", form,

			function(date)
			{
				document.location.href = './' + action;
			}

		);
	}
);