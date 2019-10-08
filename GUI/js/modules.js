var coll, i, str;

coll = $(".modules a").map
(
	function()
	{
		return $(this).attr("href");
	}

).get();

for (i = 0; i < coll.length; i++)
{
	str = coll[i];
	str = str.slice(1);
	pos = str.indexOf('/');
	str = str.slice(0,pos);
	
	$('#'+str).attr('checked', true);
}