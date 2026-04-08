#!/bin/bash

echo "[KING] Installing OpenVPN..."

apt install -y openvpn easy-rsa

make-cadir /etc/openvpn/easy-rsa
cd /etc/openvpn/easy-rsa

./easyrsa init-pki
./easyrsa build-ca nopass <<EOF
KING
EOF

./easyrsa gen-req server nopass <<EOF
KING
EOF

./easyrsa sign-req server server <<EOF
yes
EOF

./easyrsa gen-dh
openvpn --genkey --secret ta.key

cp pki/ca.crt pki/private/server.key pki/issued/server.crt /etc/openvpn/
cp ta.key /etc/openvpn/
cp pki/dh.pem /etc/openvpn/

cat > /etc/openvpn/server.conf <<EOF
port 1194
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
auth SHA256
tls-auth ta.key 0
cipher AES-256-CBC
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn/status.log
verb 3
EOF

systemctl enable openvpn@server
systemctl start openvpn@server
