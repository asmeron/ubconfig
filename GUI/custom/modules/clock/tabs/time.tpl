Name: Время и Дата

<div class = "puz">
<H2> Настроики даты и времени</H2>
<form action="edit">
<fieldset>
<legend>Автоматическая синхронизация даты и времени с интернета</legend>
	<p><input type="radio" name="sin" value="yes" `info.sh@`>Включить</p>
	<p><input type="radio" name="sin" value="no" `info.sh@2`>Отключить</p>
</fieldset>

<fieldset id ="manual">
<legend>Ручная настроика</legend>
	<p>Дата:<br><input type="date" name="date" id="date" value="`info.sh@4`" 
	`info.sh@3`></p>

	<p>Время:<br><input type="time" name="time" id="time" value="`info.sh@5`" 
	`info.sh@3`></p>

	<p>Часовой пояс:<br><select name="timezone" id="timezone" `info.sh@3`>
	&:<option value=`info.sh@7`>
	`info.sh@7`</option>:&
	</select>
	</p>
</fieldset>

<button class="form_handler">Сохранить</button>
</form>
</div>

<style>
p
{
	display: inline-block;
}

#date
{
	width: 132px;
}
#time
{
	width: 71px;
}
#timezone
{
	width: 120px;
}
#manual p:nth-child(3),
#manual p:nth-child(4)
{
	margin-left: 5px;
}
</style>

<script>

	var timezone = "`info.sh@6`";
	$('option').each(

		function(i, elem)
		{
			val = $(this).attr('value');

			if ( val == timezone )
				$(this).attr('selected', 'selected');
		}

	);

</script>