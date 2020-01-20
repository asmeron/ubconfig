#!/bin/bash

cd kernel

if [ "$2" != "$3" ]; then
	exit
fi

pass=$(echo -n "$2" | md5sum | awk '{print $1}' )

str="$1:=$pass"

sed -i  '$ a \'$str user