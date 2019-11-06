<div class = "puz">
	<H2>SSH</H2>
	<h4>Status</h4>
	<P>Program status: <span class = "`status.sh@1`">`status.sh@1`</span></p>
	<P>Program version: `version.sh@1`</p>
	<h4>Management</h4>
	<button class = "action" value="control.sh start">Start</button>
	<button class = "action" value="control.sh stop">Stop</button>
	<button class = "action" value="control.sh restart">Restart</button>
</div>

<style>

.inactive,
.active
{
	display: inline-block;
	margin: 0;
	text-transform: capitalize;
}

.inactive
{
	color: #b65b4f;
}

.active
{
	color: #438f78;
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