#!/bin/bash

openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
    -keyout /home/root/application/tls/certificate/tls.key \
    -out /home/root/application/tls/certificate/tls.crt -subj "/C=JP/ST=Tokyo/L=Tokyo/O=CIMO/OU=CIMO/CN=$DOMAIN" > /var/log/ms_cronjob/tls/starter.log 2>&1

chmod 0644 /home/root/application/tls/certificate/tls.key
