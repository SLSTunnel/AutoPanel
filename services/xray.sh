#!/bin/bash
bash <(curl -Ls https://raw.githubusercontent.com/XTLS/Xray-install/main/install-release.sh)

UUID=$(cat /proc/sys/kernel/random/uuid)

cat > /usr/local/etc/xray/config.json <<EOF
{
"inbounds":[{"port":443,"protocol":"vless","settings":{"clients":[{"id":"$UUID"}]},"streamSettings":{"network":"tcp","security":"reality","realitySettings":{"dest":"www.cloudflare.com:443","serverNames":["www.cloudflare.com"],"privateKey":"","shortIds":["6ba85179e30d4fc2"]}}}]
}
EOF

xray x25519 > /tmp/key
priv=$(grep Private /tmp/key | awk '{print $3}')
sed -i "s|\"privateKey\": \"\"|\"privateKey\": \"$priv\"|" /usr/local/etc/xray/config.json

systemctl enable xray
systemctl restart xray
