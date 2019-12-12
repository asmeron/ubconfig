#!/bin/bash

mode=$2
echo "$1 $mode"

if [ "$mode" == "auto" ]; then
	nmcli device modify $1 ipv4.method auto
	echo "Auto Mod!"
fi

if [ "$mode" == "disable" ]; then
	nmcli device modify $1 ipv4.method disable 
fi

if [ "$mode" == "manual" ]; then
	nmcli device modify $1 ipv4.method manual ipv4.address $3/$4 ipv4.gateway $5
fi