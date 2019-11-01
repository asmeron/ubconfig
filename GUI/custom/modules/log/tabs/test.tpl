<div class = "puz">
	<h2>Просмоторшик Логов</h2>
	<div class = "list_log">
<form action="log_in"><input type="text" value="`log.sh#`" name="log" readonly><button class = "page_gen" file="log">Start</button><button class = "page_gen" file="tail">Tail</button></form>
</div>
	<div class = "out_div"></div>
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
	float: left;
}
</style>
