#!/bin/bash

PATH_CRT="${PATH_ROOT}application/tls/certificate/tls.crt"
PATH_KEY="${PATH_ROOT}application/tls/certificate/tls.key"
PATH_LOG="${PATH_ROOT}log/tls.log"

generate() {
    echo "Generate new certificate." >> "$PATH_LOG"

    openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
        -keyout "$PATH_KEY" \
        -out "$PATH_CRT" \
        -addext "subjectAltName=DNS:localhost,\
            DNS:cimo-ms-antivirus,\
            DNS:cimo-ms-automate-test,\
            DNS:cimo-ms-cronjob,\
            DNS:cimo-ms-file-converter,\
            DNS:cimo-ms-ocr" \
        -subj "/C=JP/ST=Tokyo/L=Tokyo/O=CIMO/OU=CIMO/CN=$DOMAIN" >> "$PATH_LOG" 2>&1

    chmod 0644 "$PATH_KEY"
}

if [ -f "$PATH_CRT" ];
then
    expiry=$(openssl x509 -enddate -noout -in "$PATH_CRT" | cut -d= -f2)
    expiryTimestamp=$(date -d "$expiry" +%s)
    currentDateTimestamp=$(date +%s)
    expiryDifference=$((expiryTimestamp - currentDateTimestamp))

    if [ "$expiryDifference" -lt 259200 ];
    then
        echo "Current certificate expires within 3 days." >> "$PATH_LOG"

        generate
    fi
else
    echo "Certificate does not exist." >> "$PATH_LOG"

    generate
fi
