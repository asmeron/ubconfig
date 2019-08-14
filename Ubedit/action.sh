#!/bin/bash

# Удаление записи
#
# $1 - Индефикатор конфигураций
# $2 - Имя блока в котором нужно удалить запись
# $3 - Индефикатор записи
# $4 - Номер вхождения
function del_write
{	
	local date i
	
	let "i=($4-1)*2"0
	date=(${date[@]} $( ubparse -n "$2" -k "$3" -q $1))
	n_st=${date[$i]}
	path=${date[$i+1]}
	sed -i "$n_st d" $path
}

# Удаление блока
#
# $1 - Индефикатор конфигураций
# $2 - Имя блока
# $3 - Номер вхождения
function del_block
{
	local date i
	
	let "i=($3-1)*4"
	date=(${date[@]} $( ubparse -n "$2" -t "bb"  -q $1))
	sed -i "${date[$i]},${date[$i+2]}d" ${date[$i+1]}
}

# Вставка записи
#
# $1 - Индефикатор конфигураций
# $2 - Имя блока в котором нужно вставить запись
# $3 - Номер вхождения
# $4 - Строка вставки
function ins_write
{
 	local date i
	echo $1 $2 $3 $4
	let "i=($3-1)*4"
	date=(${date[@]} $( ubparse -n "$2" -t "bb"  -q $1))
	sed -i "${date[$i+2]}i $4" ${date[$i+1]}
}

# Вставка блока
#
# $1 - Индефикатор конфигураций
# $2 - Тип вставляемого блока
# $3 - Имя нового блока
function ins_block
{
	local date i
	
	date=(${date[@]} $( ubparse -t "bb_$2" -w -q $1))
	Begin_block=$(echo ${date[0]} | sed "s/(.+)/$3/")
	Begin_block=${Begin_block//[\^,?,$]/}
	Begin_block=${Begin_block/"\s"/ }
	Begin_block=${Begin_block//\\/}
	echo -e "$Begin_block\n${date[1]}\n" >> ${date[3]}
}
