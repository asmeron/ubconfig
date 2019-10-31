#/bin/bash

systemctl list-unit-files | cut -d' ' -f1 | sed 's/.service/ /' | grep -v @