#!/bin/bash

echo "[KING] Configuring Nginx..."

cat > /etc/nginx/sites-enabled/default <<EOF
server {
    listen 8080 default_server;
    server_name _;

    location / {
        root /var/www/html;
        index index.php index.html;
    }

    location /ws {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "Upgrade";
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php-fpm.sock;
    }
}
EOF

systemctl restart nginx
