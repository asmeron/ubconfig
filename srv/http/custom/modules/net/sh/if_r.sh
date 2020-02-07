#!/bin/bash

convert ()
{
	local ind 

	ind=$1
	let "ind=8-$ind"

	let "ind=2**$ind"
	let "ind=256-$ind"

	echo $ind
}

check ()
{
	local ind result i

	result=(0 0 0 0)
	i=0
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

path_dev="/sys/class/net"
cd $path_dev
list=( ${list[@]} $(ls | grep -v 'lo') )

path_conn="/etc/NetworkManager/system-connections"

for i in ${list[@]}
do
	address=(${address[@]} $(cat "$i/address") )
	cd $path_conn
	connect[${#connect[@]}]=$(grep -r "interface-name=$i" | cut -d':' -f1 | cut -d'.' -f1 | sed 's/ /@/g')
	cd $path_dev
	ip=(${ip[@]} $(ifconfig $i | grep "inet " | awk '{print $2}') )

done

cd $path_conn

for i in ${connect[@]}
do
	i=${i//@/ }
	buff=$(cat "$i.nmconnection"  | grep address1 )

	if [ "$buff" == "" ]; then
		ipv4[${#ipv4[@]}]=""
		mask[${#mask[@]}]=""
		gateway[${#gateway[@]}]=""
	else
		ipv4[${#ipv4[@]}]=$(echo $buff | cut -d'=' -f2 | cut -d'/' -f1)
		gateway[${#gateway[@]}]=$(echo $buff | cut -d'/' -f2 | cut -d',' -f2)
		buff=$(echo $buff | cut -d'/' -f2 | cut -d',' -f1)
		mask[${#mask[@]}]=$(check $buff)
	fi

	buff=$(cat "$i.nmconnection" | grep dns=  | grep ";" | cut -d'=' -f2)

	if [ "$buff" == "" ]; then
		dns[${#dns[@]}]=""
	else
		buff=${buff/;/ }
		dns[${#dns[@]}]=$buff
	fi

	buff=$(cat "$i.nmconnection" | grep method | head -n 1 | cut -d'=' -f2)

	if [ "$buff" == "auto" ]; then
		buff=$(cat "$i.nmconnection" | grep ignore-auto-dns=true )

		if [ "$buff" != "" ];then
			buff="only-address"
		else
			buff="auto"
		fi

	fi

	method[${#method[@]}]=$buff

	buff=$(cat "$i.nmconnection"  | grep method=1 )

	if [ "$buff" != "" ]; then
		proxy[${#proxy[@]}]="checked"
	else
		proxy[${#proxy[@]}]=""
	fi

	buff=$(cat "$i.nmconnection"  | grep browser-only=true )

	if [ "$buff" != "" ]; then
		browser[${#browser[@]}]="checked"
	else
		browser[${#browser[@]}]=""
	fi

done

for (( i=0; i < ${#list[*]}; i=i+1 ))
do
	echo ${list[$i]}
	echo ${ip[$i]}

	echo ${address[$i]}
	echo ${connect[$i]}

	echo ${ipv4[$i]}
	echo ${mask[$i]}

	echo ${gateway[$i]}
	echo ${dns[$i]}

	case ${method[$i]} in
		'auto') echo "checked"
				echo ""
				echo ""
				echo "";;
		'only-address') echo ""
					  echo "checked"
				      echo ""
				      echo "";;
		'manual') echo ""
				  echo ""
				  echo "checked"
				  echo "";;
		'disabled') echo ""
					echo ""
					echo ""
					echo "checked";;
	esac

	echo ${proxy[$i]}
	echo ${browser[$i]}

	echo ""

done

