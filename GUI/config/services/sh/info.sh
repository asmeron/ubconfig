#!/bin/bash

systemctl status $1 | grep Active | cut -d':' -f2 | cut -d' ' -f2
systemctl status $1 | grep Active | cut -d':' -f2 | cut -d' ' --complement -f1,2