Name: Список

<div class = "puz">
<H2>Список пользователей</h2>
	<table id="list_service">
		<thead>
		<tr>
			<th>Имя Пользователя</th>
			<th>Доступные действия</th>
	</tr>
	</thead>
	<tboby>
	&:<tr>
		&:<td><p>`list.sh@1`</p></td>:&
		<td>
			<button class = "page_gen" file = "edit_login" par_name = "user" par_val = "`list.sh@`">Edit Login</button>
			<button class = "page_gen" file = "edit_password" par_name = "user" par_val = "`list.sh@`">Edit Password</button>
			<button class = "action" value="delete.sh `list.sh@`">Delete</button>
		</td>
	</tr>:&
	</tboby>
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
	margin-top: 15px;
	word-break: break-all;
}

td
{
	padding-left: 5px;
}

td:nth-child(1)
{
	width: 60%;
}

td:nth-child(2)
{
	width: 40%;
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
    width: 32%;
}
h3
{
	text-align: center;
    text-transform: uppercase;
    color: #203D61;
}

.puz button:nth-of-type(3)
{
	background-color: #b65b4f;
}

.puz button:nth-of-type(2)
{
	background-color: #bf8d5b;
}
.puz button:nth-of-type(1)
{
	background-color: #438f78;
}
</style>

<SCRIPT src="/kernel/js/sort_table.js"></script>

<script>

	$("#list_service").tablesorter();

</script>