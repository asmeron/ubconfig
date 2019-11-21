<div class = "puz">
<h2>Доступные сервисы</h2>
	<table class = "header_table">
	<tr>
	<td>Имя сервиса</td>
	<td>Статус</td>
	<td>Описание</td>
	<td>Доступные действия</td>
	</tr>
	</table>
	<div class = "test">
		<table>
		&:<tr>
			&:<td><p>`service_tab.sh@3`</p></td>:&
			<td><button class = "action" value="control.sh start `service_tab.sh@1`">Start</button>
				<button class = "action" value="control.sh stop `service_tab.sh@1`">Stop</button>
				<button class = "action" value="control.sh restart `service_tab.sh@1`">Restart</button>
			</td>
		</tr>:&
		</table>
	</div>
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
	border-spacing: 0px;
	margin-top: 15px;
}

td
{
	text-align: center;
}

td:nth-child(1)
{
	width: 25%;
}

td:nth-child(2)
{
	width: 5%;
}

td:nth-child(3)
{
	width: 40%;
}

tr
{
	line-height: 20px;
}
tr:nth-child(2n),
.header_table tr
{
	background: rgba(52,141,216,0.3);
}
button
{
    background: rgba(237,83,17,0.3);
    width: 28% !important;
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
</style>