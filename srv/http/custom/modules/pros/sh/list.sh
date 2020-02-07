#!/bin/bash

top -w -b -c -n 1 > pross.txt

cat pross.txt | head -5
cat pross.txt | sed -n '8,$p' | awk '{print $1, $2, $9, $10, $11, $12}'

rm pross.txt