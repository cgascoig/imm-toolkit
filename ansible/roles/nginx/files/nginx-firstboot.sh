#!/bin/sh

mkdir -p /etc/nginx/ssl
openssl req -new 
openssl req -new -subj "/C=US/CN=imm-toolkit" \
    -addext "subjectAltName = DNS:imm-toolkit.local" \
    -newkey rsa:2048 -days 1095 -nodes -x509 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
