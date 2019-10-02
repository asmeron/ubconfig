<div class = "puz">
<h2>Edit info</h2>
<formprepross action = 'test'>

[dir_module:DirectoryIndex]
{
	name = (Имя компьютера)
	alt = (name)
	type = (field)
    default = (`info.sh@1`)
    collect_values = ( )
}

[dir_module:DirectoryIndex]
{
	name = (Ip-адрес)
	alt = (adress)
	type = (field)
	default = (`info.sh@2`)
	collect_values = ( )
}

[dir_module:DirectoryIndex]
{
	name = (Домен)
	alt = (domian)
	type = (field)
	default = (`info.sh@3`)
	collect_values = ( )
}

</formprepross> 
</div>