#!/bin/bash

today=$(date +"%Y-%m-%d")

while read line; do
u=$(echo $line | cut -d ' ' -f1)
exp=$(echo $line | cut -d ' ' -f2)

if [[ "$today" > "$exp" ]]; then
sed -i "/^$u:/d" /etc/autopanel/data/users.db
sed -i "/^$u /d" /etc/autopanel/data/expiry.db
fi
done < /etc/autopanel/data/expiry.db
