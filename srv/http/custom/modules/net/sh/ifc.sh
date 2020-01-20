#!/bin/bash

convert()
{
	local ind i

	ind="$name"
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

check()
{
	local result address buff
	result=0

	IFS='.' read -ra address <<< ""$name""

	for i in ${address[@]}
	do
		buff=$(convert $i)
		let "result=$result+$buff"
	done

	echo $result

}

mode=$2
str=""
name=${1//@/ }
echo "$name $mode $3 $4 $5 $6"

if [ "$mode" == "auto" ]; then
	nmcli connect modify "$name" ipv4.method auto ipv4.ignore-auto-dns "" ipv4.address "" ipv4.dns "" ipv4.gateway "" ipv4.ignore-auto-dns ""
fi

if [ "$mode" == "only_address" ]; then
	nmcli connect modify "$name" ipv4.method auto ipv4.ignore-auto-dns true ipv4.gateway ""  ipv4.address ""
fi

if [ "$mode" == "disabled" ]; then
	nmcli connect modify "$name" ipv4.method disable ipv4.address "" ipv4.dns "" ipv4.gateway "" ipv4.ignore-auto-dns ""
fi

if [ "$mode" == "manual" ]; then

	if [ "$4" != "\\" ]; then
		len=$(echo $4 | wc -c)

		if [ "$len" -lt 4 ]; then
			str="$str/$4"
		else
			str="$str/$(check $4)"
		fi
	fi

	if [ "$5" != "\\" ]; then
		str="$str ipv4.gateway $5"
	fi

	if [ "$6" != "\\" ]; then
		str="$str ipv4.dns $6"
	fi
	
	nmcli connect modify "$name" ipv4.method manual ipv4.address ${3}${str} ipv4.ignore-auto-dns ""
fi

if [ "$7" == "proxy" ]; then
	nmcli connect modify "$name" proxy.method auto
else
	nmcli connect modify "$name" proxy.method ""
fi

if [ "$7" == "browse"  -o "$8" == "browse" ]; then
	nmcli connect modify "$name" proxy.browser-only true
else
	nmcli connect modify "$name" proxy.browser-only ""
fi
