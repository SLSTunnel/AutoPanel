#!/bin/bash
LIMIT=2
for u in $(grep CLIENT_LIST /var/log/openvpn/status.log | cut -d',' -f2 | sort | uniq); do
c=$(grep CLIENT_LIST /var/log/openvpn/status.log | grep $u | wc -l)
if [ $c -gt $LIMIT ]; then pkill -f "$u"; fi
done
