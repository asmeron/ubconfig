#!/bin/bash

#tmpfile=`mktmp /var/tmp/ifcXXXXX`
tmpfile="ifc.tmp"
confpath="/etc/NetworkManager/system-connections/"

mask2cdr ()
{
   local x=${1##*255.}
   set -- 0^^^128^192^224^240^248^252^254^ $(( (${#1} - ${#x})*2 )) ${x%%.*}
   x=${1%%$3*}
   echo $(( $2 + (${#x}/4) ))
}

echo >$tmpfile

ifn=`echo $1 |  tr -d '" '`
method=`echo $2 | tr -d '" '`
ip=`echo $3 |  tr -d '" '`
netmask=`echo $4 | tr -d '" '`
gateway=`echo $5 | tr -d '" '`
dns=`echo $6 |  tr -d '" '`
if [ "$ip" == '' -o "$netmask" == "" ]
then
	addr=
else
	addr="$ip/`mask2cdr $netmask`"
fi
if [ "$7" == '"proxy"' -o "$8" == '"proxy"' ]
then
	proxy="TRUE"
fi
if [ "$7" == '"bronly"' -o "$8" == '"bronly"' ]
then
	bronly="TRUE"
fi
for fn in `ls "$confpath"`
do
	ifnt=`cat "$confpath$fn" | grep -o "interface-name=.*" | cut -d"=" -f2`
	#echo "$fn [$ifnt] [$ifn]"
	if [ "$ifnt" == "$ifn" ]
	then
		#echo "found" > $tmpfile
		break
	fi
done

IFS=$'\n'
p="n"
while read line
do
	if [ "$line" == "" ]
	then
		continue
	fi
	c1=`echo $line | head -c1`
	if [ "$line" == "[ipv4]" ] 
	then
		p="y"
	elif [ "$p" == "y" -a "$c1" == "[" ] 
	then
		p="c"
	fi
	case $p in 
		y)	field=`echo $line | cut -d"=" -f1`
			case $field in
				method) ;;
				address-data) ;;
				gateway) ;;
				dns) ;;
				proxy) ;;
				browser-only) ;;
				*) echo $line >>$tmpfile ;;
			esac
			;;
		n)	echo $line >>$tmpfile
			;;
		c)	p="n"
			echo "method=$method" >>$tmpfile
			if [ "$addr" != "" ]
			then
				echo "address-data=$addr" >>$tmpfile
			fi
			if [ "$gateway" != "" ]
			then
				echo "gateway=$gateway" >>$tmpfile
			fi
			if [ "$dns" != "" ]
			then
				echo "dns=$dns" >>$tmpfile
			fi
			if [ "$proxy" == "TRUE" ]
			then
				echo "proxy=TRUE" >>$tmpfile
			fi
			if [ "$bronly" == "TRUE" ]
			then
				echo "browser-only=TRUE" >>$tmpfile
			fi		
			echo $line >>$tmpfile	
			;;
	esac
done <$confpath$fn
chown root:http $tmpfile
chmod 0666 $tmpfile
mv $tmpfile $confpath$fn
