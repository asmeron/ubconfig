#/bin/bash

cd /srv/http/custom/modules

ls -d */ | cut -d'/' -f1 | grep -v modules
