#!/bin/bash
set -euo pipefail

sudo yum update -y
sudo yum install -y nginx

sudo systemctl start nginx
sudo systemctl enable nginx

echo 'server_names_hash_bucket_size 128;' | sudo tee -a /etc/nginx/nginx.conf

echo 'server {
    listen 80;
    server_name ${nlb_dns_name};

    location / {
        proxy_pass http://${alb_dns_name};
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}' | sudo tee /etc/nginx/conf.d/proxy.conf

sudo nginx -t
sudo systemctl reload nginx
