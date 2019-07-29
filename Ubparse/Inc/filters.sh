#!/bin/bash

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