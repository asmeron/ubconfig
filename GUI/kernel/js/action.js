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

///////////////////////////////////////////////////////////

// Ajax-обработка изменений в форме
///////////////////////////////////////////////////////////
$('#save').on('click',

	function()
	{
		config = get_id_config();

		form = $('#EditForm').serializeArray();
		form.push({name: 'config', value: config });

		$.post("/kernel/lib/handler.php?mode=update", form,

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

		$.post("/kernel/lib/handler.php?mode=ins_wr", { config : config, key : key, nest : nest }, 

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

		$.post("/kernel/lib/handler.php?mode=exe", {script : test, config : config},

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

		$.post("/kernel/lib/handler.php?mode=exel", form,

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

		$.post("/kernel/lib/handler.php?mode=exel", form,

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
		par = $(this).attr('par_name');
		val = $(this).attr('par_val');
		config = get_id_config();

		form = form.serializeArray();
		form.push({name: 'action', value: action });
		form.push({name: 'config', value: config });
		form.push({name: par , value: val });

		$.post("/kernel/lib/handler.php?mode=gen", form,

			function(date)
			{
				document.location.href = './' + date;
			}

		);
	}
);

$('.close').on('click',

	function()
	{
		config = get_id_config();
		file = get_id_tab();

		$.post("/kernel/lib/handler.php?mode=del", {action : file, config : config},

			function(date)
			{
				document.location.href = date;
			}

		);
	}
);

$('.sumb').on('click',

	function()
	{
		form = $('#aut').serializeArray();

		$.post("/kernel/lib/handler.php?mode=aut", form,

			function(date)
			{
				location.reload();
			}

		);
	}

);

$('.down_file').on('click',

	function()
	{
		form = $(this).parent();
		file = $(this).attr('file');

		form = form.serializeArray();
		form.push({name: 'file', value: file });

		$.post("/kernel/lib/handler.php?mode=file", form,

			function(date)
			{
				var data = new Blob(["\ufeff", [date]],{type:'plain/text'});
				var file = window.URL.createObjectURL(data);
				window.location.href=file;
			}

		);
	}
);