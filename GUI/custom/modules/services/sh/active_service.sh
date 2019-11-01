#/bin/bash

systemctl list-unit-files | grep enable | cut -d' ' -f1 | sed 's/.service/ /' | grep -v @