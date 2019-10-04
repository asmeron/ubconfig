#!/bin/bash

path_run=$(dirname $0)

# Удаление записи
#
# $1 - Индефикатор конфигураций
# $2 - Индефикатор записи
# $3 - Номер вхождения
function del_write
{	
	local date i
	
	let "i=($3-1)*2"
	date=(${date[@]} $( ubparse -k "$2" -q $1))

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
# $3 - Номер вхождения блока
# $4 - Ключ
# $5 - Значение ключа
function ins_write
{
	local date i str reg

	let "i=($3-1)*4+2"
	date=(${date[@]} $( ubparse -n $2 -t "bb" -q $1))

	n_st=${date[$i]}
	path=${date[$i+1]}

	str=$( ubparse -t "set" -z 1  $1 )
	reg='([a-Z]+)(.?)(.+)'

	if [[ $str =~ $reg ]]; then

		key=${BASH_REMATCH[1]}
		value=${BASH_REMATCH[3]}

	fi

	str=${str/$key/$4}
	str=${str/$value/$5}
	
	sed -i "${n_st}i $str" $path
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

# Изменение значения существующей записи
#
# $1 - Индефикатор конфигураций
# $2 - Индефикатор записи
# $3 - Номер вхождения
# $4 - Значение ключа
function update_write
{
	local date i

	let "i=($3-1)*2"
	date=(${date[@]} $( ubparse -k "$2" -q $1))
	n_st=${date[$i]}
	path=${date[$i+1]}

	str=$(sed -n "${n_st}p" < $path)
	reg='[a-Z]+.?(.+)'

	if [[ $str =~ $reg ]]; then
		value=${BASH_REMATCH[1]}
	fi

	re_str=${str/$value/$4}
	sed -i "${n_st}s/$str/$re_str/" $path
}



while getopts "d:l:i:v:u:" opt
do

	case $opt in
		d) del_block $OPTARG;;
		l) del_write $OPTARG;;
		i) ins_block $OPTARG;;
		v) ins_write $OPTARG;;
		u) update_write $OPTARG;;
		*) echo "Emtry key";
	esac
done
