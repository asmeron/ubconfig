Name: Вкл\Выкл
<div class = "puz">
<h2>Список модулей</h2>
<form action = "mod">
<fieldset>
	<legend>Список модулей</legend>
	&:<div class = "list_modules"><input type="checkbox" value="`list.sh@`" 
	id="`list.sh@`" name="modul[]"><span>
	`list.sh@`</span></div>:&
</fieldset>
<button class='form_handler'>Сохранить</button>
</form>
</div>

<style>

list_modules
{
	margin-top: 5px;
}

.list_modules input
{
	display: inline-block;
}

.list_modules span
{
	display: inline-block;
    margin: 0;
    position: relative;
    vertical-align: top;
}

</style>

<script>

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

</script>