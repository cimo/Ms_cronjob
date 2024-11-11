#!/bin/bash

pathCrt="${PATH_ROOT}application/tls/certificate/tls.crt"
pathKey="${PATH_ROOT}application/tls/certificate/tls.key"
pathLog="${PATH_ROOT}log/tls.log"

generate() {
    echo "Generate new certificate." >> "$pathLog"

    openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
        -keyout "$pathKey" \
        -out "$pathCrt" \
        -addext "subjectAltName=DNS:localhost,\
            DNS:cimo-ms-antivirus,\
            DNS:cimo-ms-automate-test,\
            DNS:cimo-ms-cronjob,\
            DNS:cimo-ms-file-converter,\
            DNS:cimo-ms-ocr" \
        -subj "/C=JP/ST=Tokyo/L=Tokyo/O=CIMO/OU=CIMO/CN=${DOMAIN}" >> "$pathLog" 2>&1

    chmod 0644 "$pathKey"
}

if [ -f "$pathCrt" ];
then
    expiry=$(openssl x509 -enddate -noout -in "$pathCrt" | cut -d= -f2)
    expiryTimestamp=$(date -d "$expiry" +%s)
    currentDateTimestamp=$(date +%s)
    expiryDifference=$((expiryTimestamp - currentDateTimestamp))

    if [ "$expiryDifference" -lt 259200 ];
    then
        echo "Current certificate expires within 3 days." >> "$pathLog"

        generate
    fi
else
    echo "Certificate does not exist." >> "$pathLog"

    generate
fi
