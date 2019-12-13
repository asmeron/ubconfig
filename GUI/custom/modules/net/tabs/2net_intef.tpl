Name: Сетевые интерфейсы

<div class = "puz">
<h2>Сетевые интерфейсы</h2>
&:<div class="net">
&:<span style="display:none">`if_r.sh@15`</span>:&
<form action="ifc">
	<fieldset>
		<legend>`if_r.sh@1`</legend>
		<ul>
			<li>IP Адрес: `if_r.sh@2`</li>
			<li>MAС Адрес: `if_r.sh@3`</li>
		</ul>
		<input type="hidden" name="ifn" value="`if_r.sh@4`"/>
		<input type="radio" name="mode_inf" value="auto" `if_r.sh@9`>Автоматически (DHCP)<br>
		<input type="radio" name="mode_inf" value="only_address" `if_r.sh@10`>Автоматически (DHCP, только адрес)<br>
		<input type="radio" name="mode_inf" value="manual" `if_r.sh@11`>Вручную
		<input type="radio" name="mode_inf" value="disabled" `if_r.sh@12`>Отключен
		<br><br>
		<div class="input">
			<span>Адрес:</span><br>
			<input type="text" name="ip" value="`if_r.sh@5`">
		</div>
		<div class="input">
			<span>Маска сети:</span><br>
			<input type="text" name="netmask" value="`if_r.sh@6`">
		</div>
		<div class="input">
			<span>Шлюз:</span><br>
			<input type="text" name="gateway" value="`if_r.sh@7`">
		</div>
		<br>
		<br>
		<div class="input_long">
			<span>Дополнительные серверы DNS:</span><br>
			<input type="text" name="dns" value="`if_r.sh@8`">
		</div>
		<br>
		<input type="checkbox" name="proxy" value="proxy" `if_r.sh@13`>Использовать прокси
		<input type="checkbox" name="browse" value="method" `if_r.sh@14`>Только для браузера

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