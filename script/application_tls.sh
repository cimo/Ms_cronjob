#!/bin/bash

pathCrt="${PATH_ROOT}.file_share/certificate/tls.crt"
pathKey="${PATH_ROOT}.file_share/certificate/tls.key"
pathPem="${PATH_ROOT}.file_share/certificate/tls.pem"
pathLog="${PATH_ROOT}log/tls.log"

proxy() {
    echo "Copy proxy certificate." >> "${pathLog}"

    cp ${PATH_ROOT}certificate/proxy/* "${PATH_ROOT}.file_share/certificate/proxy/"
}

concatenate() {
    echo "Concatenate in pem." >> "${pathLog}"

    cat "${pathCrt}" "${pathKey}" > "${pathPem}"
}

generate() {
    echo "Generate new certificate." >> "${pathLog}"

    openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
        -keyout "${pathKey}" \
        -out "${pathCrt}" \
        -addext "subjectAltName=DNS:localhost,\
            DNS:cimo-ms-ai,\
            DNS:cimo-ms-antivirus,\
            DNS:cimo-ms-automate-test,\
            DNS:cimo-ms-cronjob,\
            DNS:cimo-ms-file-converter,\
            DNS:cimo-ms-ocr" \
        -subj "/C=JP/ST=Tokyo/L=Tokyo/O=CIMO/OU=LOCAL/CN=${DOMAIN}" >> "${pathLog}" 2>&1

    chmod 0644 "${pathKey}"

    concatenate
}

if [ -f "${pathCrt}" ];
then
    expiry=$(openssl x509 -enddate -noout -in "${pathCrt}" | cut -d= -f2)
    expiryTimestamp=$(date -d "${expiry}" +%s)
    currentDateTimestamp=$(date +%s)
    expiryDifference=$((${expiryTimestamp} - ${currentDateTimestamp}))

    if [ ${expiryDifference} -lt 259200 ];
    then
        echo "Current certificate expires within 3 days." >> "${pathLog}"

        generate
    else
        echo "Certificate exists and is valid." >> "${pathLog}"
    fi
else
    echo "Certificate does not exist." >> "${pathLog}"

    generate
fi

proxy
