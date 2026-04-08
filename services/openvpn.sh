#!/bin/bash

echo "[KING] Installing OpenVPN..."

apt update -y
apt install -y openvpn easy-rsa

mkdir -p /etc/openvpn/server
make-cadir /etc/openvpn/easy-rsa

cd /etc/openvpn/easy-rsa

./easyrsa init-pki

# Build CA
./easyrsa build-ca nopass <<EOF
KING
EOF

# Generate server cert
./easyrsa gen-req server nopass <<EOF
KING
EOF

./easyrsa sign-req server server <<EOF
yes
EOF

# DH + TLS key (FIXED)
./easyrsa gen-dh
openvpn --genkey secret ta.key

# Copy files
cp pki/ca.crt /etc/openvpn/server/
cp pki/private/server.key /etc/openvpn/server/
cp pki/issued/server.crt /etc/openvpn/server/
cp pki/dh.pem /etc/openvpn/server/
cp ta.key /etc/openvpn/server/

# Create config
cat > /etc/openvpn/server/server.conf <<EOF
port 1194
proto tcp
dev tun

ca ca.crt
cert server.crt
key server.key
dh dh.pem

auth SHA256
cipher AES-256-GCM

tls-auth ta.key 0

topology subnet
server 10.8.0.0 255.255.255.0

keepalive 10 120

persist-key
persist-tun

user nobody
group nogroup

script-security 3
auth-user-pass-verify /etc/openvpn/checkpsw.sh via-env
client-cert-not-required
username-as-common-name

status /var/log/openvpn/status.log
log /var/log/openvpn.log

verb 3
EOF

# Enable IP forward (IMPORTANT)
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Start service (FIXED NAME)
systemctl daemon-reexec
systemctl enable openvpn-server@server
systemctl start openvpn-server@server

echo "[KING] OpenVPN Installed Successfully"
