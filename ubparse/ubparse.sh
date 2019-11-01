#!/bin/bash

# Извлечение информаций из инфо.сущности
#
# $1 - регулярное выражение по которому определяется сущность
# $2 - Строка содержашие сущность
# $3 - Номер извлекаемого элемента
#
# Возвращает имя блока
function get_value
{
	# reg - шаблон извлечение имени
	local reg
	
	reg=$1
	
	# Извлекаем имя
	if [[ $2 =~ $reg ]]; then
		echo "${BASH_REMATCH[$3]}"
	fi
}

# Инициализация шаблона парсинга
#
# $1 - Файл с шаблоном
#
# Происходит запись шаблона в память
function init_pattern
{
	# type - Флаг типа записи
	# LINE - Строка файла
	# i - Бинарный флаг первой строки файла
	local type LINE i count
	i=0
	separ=" "
	inc="include"
	end=0
	
	while read LINE;
	do
	
		# Считываев путь к файлу конфигураций
		#####################################
		if [ $i == 0 ]; then
			conf=$(get_value "^[a-Z]+\\s(.+)" "$LINE" 1) 
			(( i++ ))
		
			if [ ! -e "$conf" ] || [ "$conf" == "" ]; then
				return 1
			fi
		#####################################
		
		# Считываем шаблон
		#####################################
		else
		
			type=$(get_value "^([a-Z]+)\\s.+" "$LINE" 1)

			case "$type" in
				'Comment') comment=$(get_value "^[a-Z]+\\s(.+)" "$LINE" 1);;
				'Set') set=$(get_value "^[a-Z]+\\s(.+)" "$LINE" 1) ;;
				'Group') group=(${group[@]} $(get_value "^[a-Z]+\\s(.+)" "$LINE" 1)) ;;
				'Block') blocks=(${blocks[@]} $(get_value "^[a-Z]+\\s([a-Z]+)\\s.+" "$LINE" 1))
			 	 	     blocks=(${blocks[@]} $(get_value "^[a-Z]+\\s[a-Z]+\\s(.+)" "$LINE" 1))
					 	 (( count++ ));;
				'Off') func=$(get_value "^[a-Z]+\\s(.+)" "$LINE" 1) ;;
				'DInclude') inc=$(get_value "^[a-Z]+\\s(.+)" "$LINE" 1) ;;
				'IncludePath') f_path=$(get_value "^[a-Z]+\\s(.+)" "$LINE" 1) ;;
				*) return 2;;
			esac
			
		fi
		#####################################
	
	done < $1
	
	if [ ${#blocks[*]} -gt 0 ]; then
	
		let "i=${#blocks[*]} / 3"
		
		if [ "$i" != "$count" ]; then
			return 3
		fi
	fi
}


# Определение типа строки конфигураций
#
# $1 - Проверяемая строка
#
# Возвращает тип строки
function check_str
{
	# i - Счетчик для циклов
	# type - Флаг типа записи
	# key - Ключ строки параметра
	# exp - Регулярное выражение
	# str - Строка содержашие конец блока
	# name - Имя блока
	local i type key exp str name
	type=0
	
	# Проверка на предмет откл. Функций
	if [[ $1 =~ $func ]]; then
		type="off_func"
	# Проверка на предмет комментария
	elif [[ $1 =~ $comment ]]; then
		type="comment"
	else
		
		# Проверка на начало и конец блока
		#####################################
		for (( i=1; i <= ${#blocks[*]}; i=i+3 ))
		do
			str=${blocks[$i+1]}
			exp=${blocks[$i]}
		
			if [[ $1 =~ $exp ]]; then
				name=$(get_value "$exp" "$1" 1)
				type="bb_${blocks[$i-1]}_$name"
			elif [[ $1 =~ $str ]] && [ $nest -gt 1 ]; then
				type="bb_end"
			fi
		
		done
		#####################################
	fi
	
	# Проверка на предмет пустой строки
	if [ "$type" == "0" ]; then
		if [ "$1" == "" ]; then
			type="em_st"
		fi
	fi
	
	i=0

	# Проверка на особые ключи
	#####################################
	if [ "$type" == "0" ]; then
	
		key=$(get_value "$set" "$1" 1)
		
		while [ $i -lt ${#group[*]} -a "$type" == "0" ]
		do
			if [ "$key" == "${group[$i]}" ]; then
				type="group_${group[$i]}"
			else
				(( i++ ))
			fi
			
		done
	fi
	#####################################
	
	
	if [ "$type" == "0" ]; then
	
		# Проверка на дериктиву подключения
		if [[ "$key" == "$inc" ]]; then
			name=$(get_value "$set" "$1" 2)
			name=$(get_value "([^\\/]+)$" "$name" 1)
			type="bb_inc_$name"
		elif [[ "$1" =~ $set ]]; then
			type="set"
		else
			type="unk"
		fi
	fi
		
	
	echo $type
}

# Рекурсивное чтение конф.файлов
#
# $1 - Файл конфигурациий
# $2 - Функция обработчик
#
# Построчно возвращает обработчику тип и содержимое строки
function recursive_read
{
	# line - Прочтеная строка из файла
	# type - Тип строки
	# str - Номер строки
	local line type str
	
	while read line
	do
		(( str++ ))
		type=$(check_str "$line")
		
		if [[ $type =~ ^bb_end ]]; then
			(( nest-- ))
		fi
		
		handlers $2
		
		# Читаем подключаемый файл
		if [[ $type =~ ^bb_inc ]]; then
			path=$(get_value "$set" "$line" 2)
			(( nest++ ))
			recursive_read $f_path$path "$2"
		elif [[ $type =~ ^bb_[^end] ]]; then
			(( nest++ ))
		fi
		

	done < $1
	
	# Обозначаем конец файла
	type="bb_end"
	line="EOF"
	path=""
	(( nest-- ))
	handlers $2

}

# Извлечение имени из типа
#
# $1 - Тип записи
#
# Возврашает имя блока
function block_name
{
	echo $(get_value "^[a-Z]+_[a-Z]+_(.+)" "$type" 1)
	return 1
}

# Последовательный вызов обработчиков
#
# $ - Набор функций который необходимо исполнить
#
# Обеспечивает универсальную построчную обработку
function handlers
{
	local i
	
	for i in $@
 	do
		i=${i//@/ }
		$i
		
		if [ $? == 1 ]; then
			return 1
		fi
		
	done
	
	(( cx++ ))

	if [ "$limit" != "0" ] && [ "$limit" == "$cx" ]; then
		exit
	fi
	
}


# Фильтр вложений
#
# $ - Уровни вложений или их диапозоны
function filter_nest
{
	local i j bd ed
	
	for i in $@
 	do
		
		if [ "${i:1:1}" == ":" ]; then
			bd=${i:0:1}
			ed=${i:2:1}
		else
			bd=$i
			ed=$i
		fi
		
		
		for (( j=$bd; j <= $ed; j++ ))
		do
		
			if [ "$nest" == "$j" ]; then
				return 0
			fi
			
		done
	
	done
	
	return 1
	
}

# Фильтр по типу записи
#
# $ - Набор типов
function filter_type
{
	local i
	
	for i in $@
 	do
		
		i="^$i"
		if [[ $type =~ $i ]]; then
			return 0
		fi
		
	done
	
	return 1
}

# Фильтр по имени блока
#
# $ - Имена блоков
function filter_name
{
	local i

	for i in $@
	do
	
		
		if [ "$(block_name $type)" == "$i" ]; then
			fl=1
			return 0
		fi
		
		if [ $fl -gt 0 ]; then
			
			if [[ $type =~ ^bb_[^end] ]]; then
				(( fl++ ))
			elif [[ $type =~ ^bb_end ]]; then
				(( fl-- ))
			fi
			
			return 0
		fi
		
	done
	
	return 1
}

# Фильтр по ключам
#
# $ - Имена ключей
function filter_name_key
{
	local i

	for i in $@
	do
		if [ "$type" == "set" ] || [[ $type =~ ^group ]]; then
			key=$(get_value "$set" "$line" 1)
			
			if [[ $key =~ ^$i ]]; then
				return 0
			fi
		fi
	done
	
	return 1
}

function error_pros
{
	local error_code mess
	error_code=$1
	mess="\e[1;31mОШИБКА\e[0m:"
	
	case "$error_code" in
		1 ) echo -e "$mess Обьект конфигураций не задан!";;
		2 ) echo -e "$mess Не найден файл ассоциации!";;
		3 ) echo -e "$mess Неизвестный ключ!";;
		4 ) echo -e "$mess Не найден конф.файл!";;
		5 ) echo -e "$mess Нарушение формата файла ассоциации";;
		6 ) echo -e "$mess Нарушение описание блоков";;
		* ) echo -e "$mess Нейзвестная ошибка";;
	esac
	
	exit
}


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
			
	done < $path_run/out/format.out
	
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
		Set=${SetFormat//key/$key}
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
		Set=${GVFormat//name/$key}
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

if [ $# -eq 0 ]; then
	error_pros 1
fi

pattern=$path_run/parse/${@:$#}

if [ ! -e $pattern ]; then
	error_pros 2
fi

declare -a group
declare -a blocks
fl=0
nest=0
name_gr=" "
path=""
str=""
rn=""
limit=0
cx=0

init_pattern $pattern
init_format
type="bb_conf_${@:$#}"
line=""
i=$?

if [ $i -ne 0 ]; then
	let "i=$i+3"
	error_pros $i
fi

while getopts ":n:r:t:k:lfqeswz:" opt
do
	parm=${OPTARG// /@}
	case $opt in
		r) str="$str filter_nest@$parm";;
		n) str="$str filter_name@$parm";;
		t) str="$str filter_type@$parm";;
		k) str="$str filter_name_key@$parm";;
		l) str="$(list_block)";;
		f) rn="$rn render";;
		q) rn="$rn number_str";;
		e) rn="$rn log_out";;
		s) rn="$rn direct_render";;
		w) rn="$rn format_write";;
		z) limit=$parm;;
		*) error_pros 3;
	esac
done

if [ "$rn" == "" ]; then
	rn="direct_render"
fi

str="$str $rn"
handlers "$str"
(( nest++ ))
recursive_read $conf "$str"