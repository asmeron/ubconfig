var $content, form, config;

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
		form = $(this).parent();
		action = form.attr('action');
		config = get_id_config();

		form = form.serializeArray();
		form.push({name: 'action', value: action });
		form.push({name: 'config', value: config });

		$.post("/handler.php?mode=exel", form,

			function(date)
			{
				alert(date);
			}

		);
	}

);