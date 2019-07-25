#!/bin/bash

# Инициализация формата вывода
function init_format
{
	while read LINE;
	do
		type=$(echo $LINE | cut -d' ' -f1 )
			

			case "$type" in
				'Set') SetFormat=$(echo $LINE | cut -d' ' --complement -f1) ;;
				'Block') BlockFormat=$(echo $LINE | cut -d' ' --complement -f1) ;;
				'End') EndBlock=$(echo $LINE | cut -d' ' --complement -f1) ;;
				'BeginGroup') GroupFormat=$(echo $LINE | cut -d' ' --complement -f1);;
				'ValueGroup') GVFormat=$(echo $LINE | cut -d' ' --complement -f1);;
				'EndGroup') GEFormat=$(echo $LINE | cut -d' ' --complement -f1);;
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
		key=$(echo $line | cut -d "$separ" -f1)
		value=$(echo $line | cut -d "$separ" --complement -f1)
		Set=${SetFormat/key/$key}
		Set=${Set/value/$value}
		Set=${Set//'\n'/'\n'$tab}
		echo -e "$tab$Set"
	#####################################
	
	# Форматирование блоков
	#####################################
	elif [[ $type =~ ^bb_[^end] ]]; then
		bl=$(echo $type | cut -d "_" -f2)
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
	key=$(echo $line | cut -d "$separ" -f1)
	value=$(echo $line | cut -d "$separ" --complement -f1)
	
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
		echo $separ
	elif [[ $type =~ ^bb_[^end] ]]; then
		tp=$(echo $type | cut -d'_' -f2)
		
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
