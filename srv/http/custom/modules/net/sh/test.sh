#!/bin/bash

result=(0 0 0 0)
i=0

convert ()
{
	local ind 

	ind=$1
	let "ind=8-$ind"

	let "ind=2**$ind"
	let "ind=256-$ind"

	echo $ind
}

convert_r()
{
	local ind i

	ind=$1
	i=0

	let "ind=256-$ind"

	while [ $ind -ge 2 ]
	do
		let "ind=$ind/2"
		(( i++ ))
	done

	let "i=8-$i"
	echo $i
}

check ()
{
	local ind

	ind=$1
	in=$1
	let "ind=$ind/8"

	for (( i=0; i < $ind; i=i+1 ))
	do
		result[$i]=255
	done

	if [ "$i" != 4 ]; then
	
		let "in=$in%8"
		result[$i]=$(convert $in)
	fi

	echo "${result[0]}.${result[1]}.${result[2]}.${result[3]}"

}

check_r()
{
	local result address buff
	result=0

	IFS='.' read -ra address <<< "$1"

	for i in ${address[@]}
	do
		buff=$(convert_r $i)
		let "result=$result+$buff"
	done

	echo $result

}

mode=$1

if [ "$mode" == "-c" ]; then
	check $2
else
	check_r $2
fi