#!/bin/bash

systemctl status $1 | grep Active | cut -d':' -f2 