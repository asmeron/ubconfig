#!/bin/bash
netstat -4 -6 | sed -e "1,2d" -e "s/  */ /g" -e "s/ *$//" | tr " " "\n"