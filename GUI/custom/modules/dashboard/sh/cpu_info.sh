#!/bin/bash

cat /proc/cpuinfo | grep -e "model name" -e "cpu cores" | head -n 2 | cut -d ':' -f2
