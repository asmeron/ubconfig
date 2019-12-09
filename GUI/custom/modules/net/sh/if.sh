#!/bin/bash

path="/sys/class/net"
cd $path
list=( ${list[@]} $(ls | grep -v 'lo') )

for i in ${list[@]}
do
	address=(${address[@]} $(cat "$i/address") )
	ip=(${ip[@]} $(nmcli dev show $i | grep IP4.AD | awk '{print $2}' | cut -d'/' -f1) )
	mask=(${mask[@]} $(nmcli dev show $i | grep IP4.AD | awk '{print $2}' | cut -d'/' -f2) )
	gateway=(${gateway[@]} $(nmcli dev show $i | grep IP4.GATE | awk '{print $2}') )
	dns=(${dns[@]} $(nmcli dev show $i | grep IP4.DNS | awk '{print $2}' | xargs | sed -e 's/ /;/') )

done

for (( i=0; i < ${#list[*]}; i=i+1 ))
do
	echo ${list[$i]}
	echo ${address[$i]}

	echo ${ip[$i]}
	echo ${mask[$i]}

	echo ${gateway[$i]}
	echo ${dns[$i]}
	
	echo " "

done

