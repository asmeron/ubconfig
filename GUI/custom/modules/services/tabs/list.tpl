<div class = "puz">
<h2>Доступные сервисы</h2>
<h3>Активные</h3>
	<div class = "list_log">
	<form action="log_in"><input type="text" value="`active_service.sh#`" name="service" readonly><button class = "page_gen" file="mang">Managment</button></form>
	</div>
<h3>Неактивные</h3>
	<div class = "list_log">
	<form action="log_in"><input type="text" value="`disable_service.sh#`" name="service" readonly><button class = "page_gen" file="mang">Managment</button></form>
	</div>
</div>

<style>
form
{
	padding: 2px;
}
input
{
	width: 180px !important;
    display: inline-block !important;
}
.list_log
{
	width: 300px;
}
</style>
