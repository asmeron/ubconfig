#/bin/bash

file=$1
shift
echo $@


owner=$(ls -l $file | cut -d' ' -f3)
su $owner -c "$file $(echo $@)" > "/tmp/ubconfig/$file.txt" 