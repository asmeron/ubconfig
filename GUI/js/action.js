var $content;

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