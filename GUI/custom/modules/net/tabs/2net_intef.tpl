Name: Сетевые интерфейсы

<div class = "puz">
<h2>Сетевые интерфейсы</h2>
&:<div class="net">
&:<span style="display:none">`if.sh@15`</span>:&
<form action="ifc">
	<fieldset>
		<legend>`if.sh@1`</legend>
		<ul>
			<li>IP Адрес: `if.sh@3`</li>
			<li>MAС Адрес: `if.sh@5`</li>
		</ul>
		<input type="hidden" name="ifn" value="`if.sh@1`"/>
		<input type="radio" name="mode_inf" value="auto" `if.sh@11`>Автоматически (DHCP)<br>
		<input type="radio" name="mode_inf" value="link-local" `if.sh@12`>Автоматически (DHCP, только адрес)<br>
		<input type="radio" name="mode_inf" value="manual" `if.sh@13`>Вручную
		<input type="radio" name="mode_inf" value="disabled" `if.sh@14`>Отключен<br><br>
		
		<div class="input">
			<span>Адрес:</span><br>
			<input type="text" name="ip" value="`if.sh@2`">
		</div>
		<div class="input">
			<span>Маска сети:</span><br>
			<input type="text" name="netmask" value="`if.sh@4`">
		</div>
		<div class="input">
			<span>Шлюз:</span><br>
			<input type="text" name="gateway" value="`if.sh@6`">
		</div>
		<br>
		<br>
		<div class="input_long">
			<span>Дополнительные серверы DNS:</span><br>
			<input type="text" name="dns" value="`if.sh@7`">
		</div>
		<br>
		<input type="checkbox" name="proxy" value="proxy" `if.sh@8`>Использовать прокси
		<input type="checkbox" name="bronly" value="bronly" `if.sh@10`>Только для браузера

		<button class="form_handler">Применить</button>
	</fieldset>
</form>
:&
</div>

<style>

form ul
{
	list-style: none;
    padding: 0;
    margin-left: 5px;
}

form span
{
	display: inline-block;
    color: black;
    margin: 0
}

.input INPUT[type="text"]
{
	width: 110px !important;
}
.input
{
	display: inline-block;
}

.input_long INPUT
{
	width: 385px !important;
}
</style>