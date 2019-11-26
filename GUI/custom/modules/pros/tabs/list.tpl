Name: Список

<div class = "puz">
<H3> Список процессов</h3>
&:<span>`info.sh@`</span>:&

<table id="list_service">
		<thead>
		<tr>
			<th>PID</th>
			<th>Пользователь</th>
			<th>CPU</th>
			<th>MEM</th>
			<th>Время</th>
			<th>Процесс</th>
	</tr>
	</thead>
	<tboby>
	&:<tr>
		&:<td><p>`pross.sh@6`</p></td>:&
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
	margin-top: 15px;
}

td
{
	padding-left: 5px;
}

td:nth-child(1)
{
	width: 10%;
}

td:nth-child(2)
{
	width: 7%;
}

td:nth-child(3)
{
	width: 5%;
}
td:nth-child(4)
{
	width: 5%;
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
    width: 23% !important;
    font-size: 11px;
    padding-bottom: 10px;
    padding-top: 10px;
    border-radius: 3px;
    border-width: 0px;
    cursor: pointer;
    word-break: break-word;
    color: #FFF6E8;
    text-transform: uppercase;
}
h3
{
	text-align: center;
    text-transform: uppercase;
    color: #203D61;
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