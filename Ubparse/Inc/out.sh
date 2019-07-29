#!/bin/bash

# Инициализация формата вывода
function init_format
{
	while read LINE;
	do
		type=$(get_value "^([a-Z]+)\\s.+" "$LINE" 1)
			

			case "$type" in
				'Set') SetFormat=$(get_value "^[a-Z]+\\s(.+)" "$LINE" 1);;
				'Block') BlockFormat=$(get_value "^[a-Z]+\\s(.+)" "$LINE" 1) ;;
				'End') EndBlock=$(get_value "^[a-Z]+\\s(.+)" "$LINE" 1) ;;
				'BeginGroup') GroupFormat=$(get_value "^[a-Z]+\\s(.+)" "$LINE" 1);;
				'ValueGroup') GVFormat=$(get_value "^[a-Z]+\\s(.+)" "$LINE" 1);;
				'EndGroup') GEFormat=$(get_value "^[a-Z]+\\s(.+)" "$LINE" 1);;
			esac
			
	done < $path_run/format.out
	
}

# Получение имен всех блоков
function list_block
{
	echo "filter_type@bb_[^end] block_name"
	return 1
}


# Форматирование строк конфигураций
function render
{	
	
	# Колибровка табуляций
	#####################################
	tab=""
	if [ $nest -gt 0 ]; then
	
		for (( i=0; i < $nest; i++))
		do
			tab="$tab\t"
		done
	fi
	#####################################
	
	# Обработка групп значений
	#####################################
	if [[ $type =~ ^group ]]; then
		render_group
	else
	
		if [ "$name_gr" != " " ]; then
			name_gr=" "
			Set=${GEFormat//'\n'/'\n'$tb}
			echo -e "$tb$Set"
		fi
	fi
	#####################################
	
	# Форматирование строк настроек
	#####################################
	if [ "$type" == "set" ]; then
		key=$(get_value "$set" "$line" 1)
		value=$(get_value "$set" "$line" 2)
		Set=${SetFormat/key/$key}
		Set=${Set/value/$value}
		Set=${Set//'\n'/'\n'$tab}
		echo -e "$tab$Set"
	#####################################
	
	# Форматирование блоков
	#####################################
	elif [[ $type =~ ^bb_[^end] ]]; then
		bl=$(get_value "^[a-Z]+_([a-Z]+)_.+" "$type" 1)
		name=$(block_name $type)
		Set=${BlockFormat/type/$bl}
		Set=${Set/name/$name}
		Set=${Set//'\n'/'\n'$tab}
		echo -e "$tab$Set"
	#####################################
	
	# Обозначение конца блоков
	#####################################
	elif [[ $type =~ ^bb_end ]]; then
		Set=${EndBlock//'\n'/'\n'$tab}
		echo -e "$tab$Set"
	#####################################
	
	elif [ "$type" == "comment" -o "$type" == "off_func"  ]; then
		echo -e $tab$line
	fi
	
}

# Форматирование отдельных групп
function render_group
{
	key=$(get_value "$set" "$line" 1)
	value=$(get_value "$set" "$line" 2)
	
	if [ "$name_gr" == "$key" ]; then
		Set=${GVFormat/name/$key}
		Set=${Set/value/$value}
		Set=${Set//'\n'/'\n'$tab}
		echo -e "$tab$Set"
	else
	
		if [ "$name_gr" != " " ]; then
			Set=${GEFormat//'\n'/'\n'$tb}
			echo -e "$tb$Set"
		fi
		
		name_gr=$key
		Set=${GroupFormat/name/$key}
		Set=${Set/value/$value}
		Set=${Set//'\n'/'\n'$tab}
		echo -e "$tab$Set;"
		tb=$tab
	fi
}

# Прямой вывод
function direct_render
{
	echo $line
}

# Вывод номера строк и путь до файла источника
function number_str
{
	if [ "$path" == "" ]; then
		l=$conf
	else
		l=$f_path$path
	fi
	
	echo $str $l
}

# Вывод формата записи
function format_write
{
	if [ "$type" == "set" ]; then
		echo $set
	elif [[ $type =~ ^bb_[^end] ]]; then
		tp=$(get_value "^[a-Z]+_([a-Z]+)_.+" "$type" 1)
		
		for (( i=0; i <= ${#blocks[*]}; i=i+3 ))
		do
			if [ "$tp" == "${blocks[$i]}" ]; then
				echo "${blocks[$i+1]} ${blocks[$i+2]}" 
			fi
		done
	fi
		
}

# Диагностический вывод
function log_out
{
	echo -e "Type=$type Nest=$nest Number=$str\n String=[$line]\n"
}
