#!/bin/bash

netstat -4 -6 -n | sed -e "1,2d" -e "s/  */ /g" -e "s/ *$//" | tr " " "\n"