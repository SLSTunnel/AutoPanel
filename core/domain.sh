#!/bin/bash

read -p "Domain: " d
echo "$d" > /etc/autopanel/data/domain.conf

cat > /etc/nginx/sites-enabled/default <<EOF
server {
listen 80;
server_name $d;
return 301 https://\$host\$request_uri;
}

server {
listen 443 ssl;
server_name $d;

ssl_certificate /etc/letsencrypt/live/$d/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/$d/privkey.pem;

location /ws {
proxy_pass http://127.0.0.1:3000;
proxy_set_header Upgrade \$http_upgrade;
proxy_set_header Connection "Upgrade";
}

location /web {
root /var/www/html;
index index.php;
}

location ~ \.php$ {
include snippets/fastcgi-php.conf;
fastcgi_pass unix:/run/php/php-fpm.sock;
}
}
EOF

certbot --nginx -d $d --non-interactive --agree-tos -m admin@$d
systemctl restart nginx
