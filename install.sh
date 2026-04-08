#!/bin/bash

echo "[KING]DevSupport AutoPanel PRO Installing..."

apt update -y && apt upgrade -y

apt install -y openvpn nginx squid apache2 php php-fpm jq curl wget python3 python3-pip certbot python3-certbot-nginx

mkdir -p /etc/autopanel/{core,services,data}

cp -r core/* /etc/autopanel/core/
cp -r services/* /etc/autopanel/services/
cp -r web /var/www/html/
cp autopanel /usr/bin/autopanel

chmod +x /usr/bin/autopanel

touch /etc/autopanel/data/users.db
touch /etc/autopanel/data/expiry.db

bash services/openvpn.sh
bash services/squid.sh
bash services/websocket.sh
bash services/nginx.sh
bash services/xray.sh

cp openvpn/checkpsw.sh /etc/openvpn/checkpsw.sh
chmod +x /etc/openvpn/checkpsw.sh

echo "0 0 * * * root /etc/autopanel/core/expiry.sh" >> /etc/crontab
echo "* * * * * root /etc/autopanel/core/limiter.sh" >> /etc/crontab

echo "INSTALL COMPLETE → Run: autopanel"
