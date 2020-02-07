#!/bin/bash

buff=(${buff[@]} $(find /var/log -name "*log*" | xargs stat -c%n" "%s" "%y) )
i=0


size()
{
	size=$1
	preffix=('B' 'Kb' 'Mb' 'Gb')
	i=0

	while [ $size -ge 1024 ]
	do
		let "size=$size/1024"
		(( i++ ))
	done

	echo "$size${preffix[$i]}"

}

date()
{
	j=$1
	echo "${buff[j]}@${buff[j+1]}" | cut -d'.' -f1
}

for (( i=0; i < ${#buff[*]}; i=i+2 ))
{
	result=(${result[@]} ${buff[$i]})
	(( i++ ))

	result=(${result[@]} $(size ${buff[$i]} ) )
	(( i++ ))

	result=(${result[@]} $(date $i) )
	(( i++ ))
}

for (( i=0; i < ${#result[*]}; i=i+1 ))
{
	echo ${result[$i]}
}
