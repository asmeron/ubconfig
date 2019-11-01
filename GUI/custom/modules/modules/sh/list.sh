#/bin/bash

cd custom
cd modules
ls -d */ | cut -d'/' -f1 | grep -v modules
