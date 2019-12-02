#!/bin/bash

cd kernel
str=$(cat user| grep -w $1)
nm=$(sed -n '/'$str'/=' user)

sed -i ${nm}'d' user

