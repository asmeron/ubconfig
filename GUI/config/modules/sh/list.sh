#/bin/bash

cd config
ls -d */ | cut -d'/' -f1 | grep -v modules