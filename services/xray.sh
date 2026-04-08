#!/bin/bash

echo "[KING] Installing Xray Reality..."

bash <(curl -Ls https://raw.githubusercontent.com/XTLS/Xray-install/main/install-release.sh)

KEYS=$(xray x25519)
PRIVATE=$(echo "$KEYS" | grep Private | awk '{print $3}')
PUBLIC=$(echo "$KEYS" | grep Public | awk '{print $3}')

UUID=$(cat /proc/sys/kernel/random/uuid)

cat > /usr/local/etc/xray/config.json <<EOF
{
  "inbounds": [{
    "port": 443,
    "protocol": "vless",
    "settings": {
      "clients": [{"id": "$UUID"}],
      "decryption": "none"
    },
    "streamSettings": {
      "network": "tcp",
      "security": "reality",
      "realitySettings": {
        "dest": "www.cloudflare.com:443",
        "serverNames": ["www.cloudflare.com"],
        "privateKey": "$PRIVATE",
        "shortIds": ["6ba85179e30d4fc2"]
      }
    }
  }]
}
EOF

systemctl enable xray
systemctl restart xray

echo "Public Key: $PUBLIC"
echo "UUID: $UUID"
