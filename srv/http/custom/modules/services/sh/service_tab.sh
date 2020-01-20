#/bin/bash

list=($(systemctl list-units --type=service --all | awk '{$2=""; $4="";  print $0}' | grep service | grep -v not-found | grep -v ●
) )

i=0
flag=0


while [ $i -lt ${#list[*]} ]
do

	echo ${list[$i]} | cut -d'.' -f1
	(( i++ ))

	echo ${list[$i]}
	(( i++ ))

	str=""

	while [ $flag -ne 1 ] && [ $i -lt ${#list[*]} ]
	do

		if [[ "${list[$i]}" =~ "service" ]]; then
			flag=1
		else
			str="$str ${list[$i]}"
			(( i++ ))
		fi

	done

	echo $str
	flag=0

done
