Name: Список

<div class = "puz">
<h2>Доступные сервисы</h2>
	<table id="list_service">
		<thead>
		<tr>
			<th>Имя сервиса</th>
			<th>Статус</th>
			<th>Описание</th>
			<th>Доступные действия</th>
	</tr>
	</thead>
	<tboby>
	&:<tr>
		&:<td><p>`service_tab.sh@3`</p></td>:&
		<td><button class = "action" value="control.sh start `service_tab.sh@1`">Start</button>
			<button class = "action" value="control.sh stop `service_tab.sh@1`">Stop</button>
			<button class = "action" value="control.sh restart `service_tab.sh@1`">Restart</button>
			<button class = "page_gen" file = "status" par_name = "service" par_val = "`service_tab.sh@1`">Status</button>
		</td>
	</tr>:&
	</tboby>
	</table>
</div>

<style>
form
{
	padding: 2px;
}
input
{
	width: 80% !important;
    display: inline-block !important;
    background: none !important;
    text-align: center;
    border: none !important;
}
.list_log
{
	width: 300px;
}
table
{
	width: 100%;
	margin-top: 15px;
	word-break: break-all;
}

td
{
	padding-left: 5px;
}

td:nth-child(1)
{
	width: 24%;
}

td:nth-child(2)
{
	width: 7%;
}

td:nth-child(3)
{
	width: 39%;
}

tr:nth-child(2n+1)
{
	background: rgba(52,141,216,0.3);
}
th
{
	background: rgba(52,141,216,0.3);
    text-transform: uppercase;
}
button
{
    background: rgba(237,83,17,0.3);
    width: 23%
}

.puz button:nth-of-type(2)
{
	background-color: #b65b4f;
}

.puz button:nth-of-type(3)
{
	background-color: #bf8d5b;
}
.puz button:nth-of-type(4)
{
	background-color: #3A6B76;
}
</style>

<SCRIPT src="/kernel/js/sort_table.js"></script>

<script>

	$("#list_service").tablesorter();

</script>