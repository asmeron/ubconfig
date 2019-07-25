#!/bin/bash

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
	end=0
	
	while read LINE;
	do
	
		# Считываев путь к файлу конфигураций
		#####################################
		if [ $i == 0 ]; then
			conf=$LINE 
			(( i++ ))
		
			if [ ! -e "$conf" ] || [ "$conf" == "" ]; then
				return 1
			fi
		#####################################
		
		# Считываем шаблон
		#####################################
		else
		
			type=$(echo $LINE | cut -d' ' -f1 )
			

			case "$type" in
				'Comment') comment=($(echo $LINE | cut -d' ' -f2 ) );;
				'Key') separ=$(echo $LINE | cut -d' ' -f2 ) ;;
				'Group') group=(${group[@]} $(echo $LINE | cut -d' ' -f2 ));;
				'Block') blocks=(${blocks[@]} $(echo $LINE | cut -d' ' -f2 ))
			 	 	     blocks=(${blocks[@]} $(echo $LINE | cut -d' ' -f3 ))
					 	 (( count++ ));;
				'End') blocks=(${blocks[@]} $(echo $LINE | cut -d' ' -f2 ));;
				'Off') func=($(echo $LINE | cut -d' ' -f2 ) );;
				'I') inc=($(echo $LINE | cut -d' ' -f2 ) );;
				'Q') f_path=($(echo $LINE | cut -d' ' -f2 ) );;
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

# Извлечение имени блока по шаблону парсинга
#
# $1 - регулярное выражение по которому определяется блок
# $2 - Строка содержашие начало блока
#
# Возвращает имя блока
function get_name
{
	# reg - шаблон извлечение имени
	local reg
	
	# Преобразуем рег.выражение для парсинга имени
	reg=$(echo $1| sed 's/.+/(.+)/' )
	
	# Извлекаем имя
	if [[ $2 =~ $reg ]]; then
		echo ${BASH_REMATCH[1]}
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
				name=$(get_name "$exp" "$1")
				type="bb_${blocks[$i-1]}_$name"
			elif [[ $1 =~ $str ]] && [ $nest -gt 1 ]; then
				type="bb_end"
			fi
		
		done
		#####################################
	fi
	
	i=0
	key=$(echo $1 | cut -d"$separ" -f1 )
	
	# Проверка на особые ключи
	#####################################
	if [ "$type" == "0" ]; then
		
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
		
		# Проверка на предмет пустой строки
		if [ "$1" == "" ]; then
			type="em_st"
		# Проверка на дериктиву подключения
		elif [[ "$key" == "$inc" ]]; then
			name=$(echo $1 | cut -d' ' -f2 | awk -F '/' '{print $NF}' )
			type="bb_inc_$name"
		else
			type="set"
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
			path=$(echo $line | cut -d" " -f2 )
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
	echo $type | cut -d'_' --complement -f"1,2"
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
		i=$(echo $i | sed 's/@/ /g' )
		$i
		
		if [ $? == 1 ]; then
			return 1
		fi
		
	done
	
}
