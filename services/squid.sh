#!/bin/bash
echo "http_port 8080" > /etc/squid/squid.conf
systemctl restart squid
