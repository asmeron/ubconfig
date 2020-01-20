Name: Соединения

<div class = "puz">
<h2>Сетевые соединения</h2>
	<table id="list_service">
		<thead>
		<tr>
			<th>Proto</th>
			<th>Recv-Q</th>
			<th>Send-Q</th>
			<th>Local Address</th>
			<th>Foreign Address</th>
			<th>State</th>
		</tr>
	</thead>
	<tboby>
	&:<tr>
		&:<td><p>`conn.sh@6`</p></td>:&
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
	word-break: break-word;
}

td
{
	padding-left: 5px;
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

.arrow
{
	width: 15px;
}
</style>

<SCRIPT src="/kernel/js/sort_table.js"></script>

<script>

	$("#list_service").tablesorter();

	$("th").click(

	function()
	{
		test = $(this).find("img").attr('class');

		if ( test == undefined )
			direction = "up"
		else
		{
			direction = $(this).children('img').attr('id');

			if ( direction == "up" )
				direction = "down"
			else
				direction = "up"

		}

		$('.arrow').detach();
		str = "<img src='/custom/pic/"+direction+"_arrow.png' class='arrow' id='"+direction+"'>";
		$(this).append(str);
	}

	)

	$('th:nth-child(1)').trigger('click');

</script>