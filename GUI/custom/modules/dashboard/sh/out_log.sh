#!/bin/bash

tail --lines=10 /var/log/httpd/access_log | cut -d' ' -f1,4-8
