Name: Список
<div class = "puz">
<h2>Лог файлы</h2>
	<table id="list_service">
		<thead>
		<tr>
			<th>Имя лога</th>
			<th>Размер</th>
			<th>Дата последней модификаций</th>
			<th>Доступные действия</th>
	</tr>
	</thead>
	<tboby>
	&:<tr>
		&:<td><p>`log.sh@3`</p></td>:&
		<td>
			<button class = "down_file" file="`log.sh@1`">Dowloand</button>
			<button class = "page_gen" file="log" par_name="log" par_val="`log.sh@1`">View</button>
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
	border-spacing: 2px;
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
	background: rgba(52,141,216,0.3);
    padding-left: 5px;
    text-transform: uppercase;
}
button
{
    background: rgba(237,83,17,0.3);
    width: 48%;
}
h3
{
	text-align: center;
    text-transform: uppercase;
    color: #203D61;
}

.puz button:nth-of-type(2)
{
	background-color: #3A6B76;
}
</style>

<SCRIPT src="/kernel/js/sort_table.js"></script>

<script>

	$("#list_service").tablesorter();

</script>