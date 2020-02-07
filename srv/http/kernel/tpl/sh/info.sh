#!/bin/bash

echo $(hostname).$(hostname -d)
ifconfig | grep inet | head -n 1 | awk '{print $2}'