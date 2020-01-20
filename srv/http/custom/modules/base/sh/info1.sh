#!/bin/bash

hostname
ifconfig | grep inet | head -n 1 | awk '{print $2}'
hostname -d
