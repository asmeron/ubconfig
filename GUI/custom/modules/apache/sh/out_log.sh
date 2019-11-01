#!/bin/bash

cat /var/log/httpd/access_log | cut -d' ' -f1,4-8
