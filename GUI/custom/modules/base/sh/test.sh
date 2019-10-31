#/bin/bash

echo $1 > /etc/hostname
cat /etc/hosts | head -n -1 > temp.txt
cat temp.txt > /etc/hosts
rm temp.txt
echo "$2 $1.$3 $1" >> /etc/hosts
systemctl restart systemd-hostnamed