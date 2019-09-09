#!/bin/bash

if [ "$1" == "start" ]; then
	systemctl start sshd 2>&1
fi

if [ "$1" == "stop" ]; then
	systemctl stop sshd 2>&1
fi

if [ "$1" == "restart" ]; then
	systemctl restart sshd 2>&1
fi