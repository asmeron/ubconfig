#!/bin/bash

if [ "$1" == "start" ]; then
	systemctl start $2 2>&1
fi

if [ "$1" == "stop" ]; then
	systemctl stop $2 2>&1
fi

if [ "$1" == "restart" ]; then
	systemctl restart $2 2>&1
fi