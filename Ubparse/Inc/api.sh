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
			conf=$LINE 
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
				'End') blocks=(${blocks[@]} $(get_value "^[a-Z]+\\s(.+)" "$LINE" 1)) ;;
				'Off') func=$(get_value "^[a-Z]+\\s(.+)" "$LINE" 1) ;;
				'I') inc=$(get_value "^[a-Z]+\\s(.+)" "$LINE" 1) ;;
				'Q') f_path=$(get_value "^[a-Z]+\\s(.+)" "$LINE" 1) ;;
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
	if [ "$1" == "" ]; then
		type="em_st"
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
	
}
