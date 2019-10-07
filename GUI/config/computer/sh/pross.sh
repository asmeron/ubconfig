#!/bin/bash

cores=$(cat /proc/cpuinfo | grep "cpu cores" | head -n 1 | cut -d' ' -f3)

beg=1

for (( i=1; i <= $cores; i=i+1 ))
do
	let "end=$beg+26"
	cat /proc/cpuinfo | sed -n $beg,${end}p
	echo "_________________________________________________"
	
	beg=$end
	(( beg++ ))

done
