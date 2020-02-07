#!/bin/bash

cd kernel

if [ "$3" != "$4" ]; then
	exit
fi

old_pass=$(cat user | grep -w "$1" | cut -d'=' -f2)
enter_pass=$(echo -n "$2" | md5sum | awk '{print $1}' )

if [ "$old_pass" != "$enter_pass" ]; then
	exit
fi

new_pass=$(echo -n "$3" | md5sum | awk '{print $1}' )

str=$(cat user | grep -w "$1")
str1=$(echo $str | sed 's/'$old_pass'/'$new_pass'/')

sed -i 's/'$str'/'$str1'/' user