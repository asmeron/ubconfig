#!/bin/bash

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