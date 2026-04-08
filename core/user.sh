#!/bin/bash

DB="/etc/autopanel/data/users.db"
EXP="/etc/autopanel/data/expiry.db"

case $1 in
create)
read -p "User: " u
read -p "Pass: " p
read -p "Days: " d

exp=$(date -d "+$d days" +"%Y-%m-%d")
uuid=$(cat /proc/sys/kernel/random/uuid)

echo "$u:$(echo -n $p | sha256sum | awk '{print $1}')" >> $DB
echo "$u $exp" >> $EXP

jq ".inbounds[0].settings.clients += [{\"id\": \"$uuid\"}]" \
/usr/local/etc/xray/config.json > /tmp/x && mv /tmp/x /usr/local/etc/xray/config.json

systemctl restart xray

echo "User Created"
echo "User: $u"
echo "Pass: $p"
echo "UUID: $uuid"
;;
delete)
read -p "User: " u
sed -i "/^$u:/d" $DB
sed -i "/^$u /d" $EXP
;;
list)
cat $EXP
;;
esac
