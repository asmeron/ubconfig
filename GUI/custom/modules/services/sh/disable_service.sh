#/bin/bash

systemctl list-unit-files | grep disable | cut -d' ' -f1 | sed 's/.service/ /' | grep -v @