#!/bin/bash

timedatectl set-ntp $1
timedatectl set-time "$2 $3"
sudo timedatectl set-timezone "$4"
