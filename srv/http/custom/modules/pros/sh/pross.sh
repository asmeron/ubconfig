#!/bin/bash

date=(${date[@]} $(top -b -n 1 | sed -n '8,$p' | awk '{print $1, $2, $9, $10, $11, $12}') )

for (( i=0; i < ${#date[*]}; i=i+1 ))
do
	echo ${date[$i]}
done
