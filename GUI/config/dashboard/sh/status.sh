#!/bin/bash

status=$(systemctl status sshd)
reg='Active:\s([a-z]+)'

if [[ $status =~ $reg ]]; then
	status=${BASH_REMATCH[1]}
fi

echo $status