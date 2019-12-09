#!/bin/bash

intf=(${intf[@]} $(ip addr | grep "<" | cut -d' ' -f2 | cut -d':' -f1) )
ip=(${ip[@]} $(ip addr | grep "inet " | awk '{print $2}' |cut -d'/' -f1) )
mac=(${mac[@]} $(ip addr | grep link/ | awk '{print $2}') )

for (( i=0; i < ${#intf[*]}; i=i+1 ))
do

	echo ${intf[$i]}
	echo ${ip[$i]}
	echo ${mac[$i]}
	echo ""

done
