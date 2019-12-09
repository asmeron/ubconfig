#!/bin/bash

confpath="/etc/NetworkManager/system-connections/"
#confpath="/home/superadmin/testconf/"
#confpath="/srv/http/custom/modules/net/sh/testconf/"

cdr2mask ()
{
   set -- $(( 5 - ($1 / 8) )) 255 255 255 255 $(( (255 << (8 - ($1 % 8))) & 255 )) 0 0 0
   [ $1 -gt 1 ] && shift $1 || shift
   echo ${1-0}.${2-0}.${3-0}.${4-0}
}

IFS=$'\n'
for fn in `ls $confpath`
do
	ifn=" " 
	ip=" "
	actip=" "
	netmask=" "
	gateway=" "
	dns=" "
	mac=" "
	proxy=" "
	proxyip=" " 
	bronly=" "
	method=" "

	p="y"
	while read line
	do
		c1=`echo $line | head -c1`
		if [ "$line" == "[ipv6]" ] 
		then
			p="n"
		elif [ "$c1" == "[" ] 
		then
			p="y"
			continue
		fi
		if [ $p == "n" ]
		then 
			continue
		fi
		field=`echo $line | cut -d"=" -f1`
		val=`echo $line | cut -d"=" -f2`
		case $field in
			address-data) 
				ip=`echo $val | cut -d'/' -f1`
				netmask=`echo $val | cut -d'/' -f2`
				netmask=`cdr2mask $netmask`
				;;
			interface-name) 
				ifn=$val 
				;;
			gateway) 
				gateway=$val
				;;
			mac-address)
				mac=$val
				;;
			dns) 
				dns=$val 
				;;
			browser-only)
				if [ $val == 'TRUE' ] 
				then
					bronly="checked"
				fi
				;;
			proxy)
				if [ $val == 'TRUE' ]
				then
					proxy="checked"
				fi
				;;
			method)
				method=$val
				;;
		esac
	done <$confpath$fn
	if [ "$ifn" == "" -o "$ifn" == " " ]
	then
		ifn="ERROR"
	else
		actip=`ifconfig $ifn | grep -o "inet [0-9.]*" | cut -d" " -f2`
	fi
	if [ "$actip" == "" ]
	then 
		actip=" "
	fi
	printf "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n" \
	$ifn $ip $actip $netmask $mac $gateway $dns $proxy $proxyip $bronly
	#1   2   3      4        5    6        7    8      9        10
	case $method in
		auto) printf "checked\n\n\n\n\n" ;;       
		link-local) printf "\nchecked\n\n\n\n" ;; 
		manual) printf "\n\nchecked\n\n\n" ;;
		disabled) printf "\n\n\nchecked\n\n" ;;
		*) printf "\n\n\n\n\n"
	esac
done