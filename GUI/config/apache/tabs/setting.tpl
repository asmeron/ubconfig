<H2>Set Apache</H2>
<formprepross>
[dir_module:DirectoryIndex]
{
   name = Входной файл
   alt = Файл, который будет вызыватся при обращение к серверу
   type = check
   action = ubedit
   collect_values = (index.php: Файл PHP, index.html:Файл HTML)
}
</formprepross>
<div class='button'><button id='form_handler'>Сохранить</button></div>