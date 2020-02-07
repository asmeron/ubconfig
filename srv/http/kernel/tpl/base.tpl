<!DOCTYPE html>
<HTML lang="en">
	<HEAD>
		<META name="viewport" content="width=device-width, initial-scale=1.0">
		<META name="Description" content="Ubconfig GUI">
		<link href="/kernel/pic/favicon.ico" rel="shortcut icon" type="image/icon">
		<SCRIPT src="../kernel/js/jq.js"></script>
		<SCRIPT src="../kernel/js/lib.js"></script>
		<LINK rel="stylesheet" href="../kernel/style/base.css">
		<TITLE>Ubconfig</TITLE>
	</HEAD>
	<BODY>
		<img src="/kernel/pic/enterprise.png" class = "pic_logo">
		<header>
			<div class="left_header">
				<div class="head_info">
					<img src="/kernel/pic/logo.png" class = "logo">
					<H1> enterprise config </H1>
				</div>
			</div>
			<div class="right_header">
				<div class="pic_button">
					<img src="/kernel/pic/out.png" id="out_login" title="Выход">
					<img src="/kernel/pic/save.png" id="save" title="Сохранить все настройки">
				</div>
				<ul>
					<li>`info.sh@1`</li>
					<li>`info.sh@2`</li>
					<li>`date.sh@1`</li>
				</ul>
			</div>
		</header>
		<div class = "base_area">
			?modules?
			<DIV class = "work">
				<div class = "tabs_r">
				?tabs?
			    </div>
				<div class = "work_zone">
				@work@
			    </div>
			</DIV>
		</div>
		<div class = "mask"></div>
		<div class = "error_window">
			<h3> Возникли проблемы во время исполнения</h3>
			<div class = "area_error">
				<h4>Список ошибок</h4>
				<p>@error@</p>
			</div>
			<button id = 'close'>Ок</button>
		</div>
	</BODY>
<LINK href="https://fonts.googleapis.com/css?family=Anonymous+Pro&display=swap" rel="stylesheet">
<SCRIPT id="script_connect" src="/kernel/js/action.js"></script>
		
