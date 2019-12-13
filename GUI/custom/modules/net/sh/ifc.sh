#!/bin/bash

mode=$2
echo "$1 $mode $3 $4 $5"
str=""

if [ "$mode" == "auto" ]; then
	nmcli connect modify $1 ipv4.method auto ipv4.ignore-auto-dns "" ipv4.address "" ipv4.dns "" ipv4.gateway "" ipv4.ignore-auto-dns ""
fi

if [ "$mode" == "only_address" ]; then
	nmcli connect modify $1 ipv4.method auto ipv4.ignore-auto-dns true ipv4.dns "" ipv4.gateway "" ipv4.ignore-auto-dns "" ipv4.address ""
fi

if [ "$mode" == "disabled" ]; then
	nmcli connect modify $1 ipv4.method disable ipv4.address "" ipv4.dns "" ipv4.gateway "" ipv4.ignore-auto-dns ""
fi

if [ "$mode" == "manual" ]; then

	if [ "$4" != "" ]; then
		str="$str/$4"
	fi

	if [ "$5" != "" ]; then
		str="$str ipv4.gateway $5"
	fi

	if [ "$6" != "" ]; then
		str="$str ipv4.dns $6"
	fi
	
	nmcli connect modify $1 ipv4.method manual ipv4.address ${3}${str} ipv4.ignore-auto-dns ""
fi

if [ "$7" == "proxy" ]; then
	nmcli connect modify $1 proxy.method auto
else
	nmcli connect modify $1 proxy.method ""
fi
