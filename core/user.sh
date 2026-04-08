#!/bin/bash

DB="/etc/autopanel/data/users.db"
EXP="/etc/autopanel/data/expiry.db"

create_user() {

read -p "Username: " user
read -p "Password: " pass
read -p "Days valid: " days

expiry=$(date -d "+$days days" +"%Y-%m-%d")
uuid=$(cat /proc/sys/kernel/random/uuid)

hash=$(echo -n "$pass" | sha256sum | awk '{print $1}')

echo "$user:$hash" >> $DB
echo "$user $expiry" >> $EXP

# Add to Xray
jq ".inbounds[0].settings.clients += [{\"id\": \"$uuid\"}]" \
/usr/local/etc/xray/config.json > /tmp/xray.json

mv /tmp/xray.json /usr/local/etc/xray/config.json
systemctl restart xray

SERVER=$(cat /etc/autopanel/data/domain.conf 2>/dev/null || curl -s ifconfig.me)

echo ""
echo "====== ACCOUNT DETAILS ======"
echo "User: $user"
echo "Pass: $pass"
echo "Expiry: $expiry"
echo ""
echo "OpenVPN + WS:"
echo "Server: $SERVER"
echo "Port: 443"
echo "Proxy: $SERVER:8080"
echo "WS Path: /ws"
echo ""
echo "XRAY:"
echo "UUID: $uuid"
echo "============================="
}

case $1 in
create) create_user ;;
delete) read -p "User: " u; sed -i "/$u/d" $DB ;;
list) cat $EXP ;;
esac
