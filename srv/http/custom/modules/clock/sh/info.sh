#!/bin/bash

ntp=$( timedatectl | grep NTP | cut -d':' -f2)

if [ "$ntp" == " inactive" ]; then
	echo ""
	echo "checked"
	echo ""
else
	echo "checked"
	echo ""
	echo "disabled"
fi

timedatectl | grep Local | cut -d':' -f2 | cut -d' ' -f3
timedatectl | grep Local | awk '{print $5}'
timedatectl | grep Time | awk '{print $3}'
timedatectl list-timezones
