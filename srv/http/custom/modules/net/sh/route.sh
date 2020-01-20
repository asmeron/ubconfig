#!/bin/bash
netstat -r | sed -e "1,2d" -e "s/  */ /g" -e "s/ *$//" | tr " " "\n"