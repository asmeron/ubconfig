function reqw(config, action)
{
	text = $("#tail").val();

	$.post("/handler.php?mode=tail", {action : action, config : config, text : text},

			function(date)
			{
				text = date + text;
				$("#tail").val(text);
			}

		);
}

config = get_id_config();

par = $('#par').text();
pos = par.indexOf(':');
pos++;
par = par.slice(pos);

action= "tail_log.sh " + par;

reqw(config, action);
setInterval( function() {reqw(config, action);}, 3000);