#!/bin/bash

p1=$(printf '%s' "${1}" | xargs)
p2=$(printf '%s' "${2}" | xargs)

if [ -z "${p1}" ] || [ -z "${p2}" ]
then
    echo "tls.sh - Missing parameter."

    exit 1
fi

parameter1="${1}"
parameter2="${2}"

# Environment
chmod +x "./script/environment.sh"
source "./script/environment.sh" "${parameter1}"

pathCaKey="./certificate/ca.key"
pathCaPem="./certificate/ca.pem"
pathKey="./certificate/tls.key"
pathCrt="./certificate/tls.crt"
pathLog="${MS_C_PATH_LOG}tls.log"

generate() {
    echo "Generate certificate."

    openssl genrsa -out "${pathCaKey}" 4096 >> "${pathLog}" 2>&1

    openssl req -x509 -new -nodes -key "${pathCaKey}" -sha256 -days 365 \
        -out "${pathCaPem}" \
        -subj "/C=JP/ST=Tokyo/L=Tokyo/O=CIMO/OU=LOCAL/CN=CIMO-LOCAL-CA" >> "${pathLog}" 2>&1

    openssl genrsa -out "${pathKey}" 4096 >> "${pathLog}" 2>&1

    openssl req -new -key "${pathKey}" \
        -subj "/C=JP/ST=Tokyo/L=Tokyo/O=CIMO/OU=LOCAL/CN=${DOMAIN}" \
        -addext "subjectAltName=DNS:localhost,DNS:host.docker.internal,DNS:cimo-ms-ai-cpu,DNS:cimo-ms-ai-gpu,DNS:cimo-ms-antivirus,DNS:cimo-ms-automate-test,DNS:cimo-ms-cronjob,DNS:cimo-ms-file-converter,DNS:cimo-ms-mcp,DNS:cimo-ms-ocr-cpu,DNS:cimo-ms-ocr-gpu,IP:127.0.0.1" \
        -addext "extendedKeyUsage=serverAuth" \
        -addext "basicConstraints=CA:FALSE" \
        -out "./certificate/tls.csr" >> "${pathLog}" 2>&1

    openssl x509 -req -in "./certificate/tls.csr" \
        -CA "${pathCaPem}" -CAkey "${pathCaKey}" -CAcreateserial \
        -out "${pathCrt}" -days 365 -sha256 \
        -copy_extensions copy >> "${pathLog}" 2>&1

    rm -f "./certificate/tls.csr"

    chmod 600 "${pathKey}"
}

if [ -f "${pathCrt}" ]
then
    expiry=$(openssl x509 -enddate -noout -in "${pathCrt}" | cut -d= -f2)
    expiryTimestamp=$(date -d "${expiry}" +%s)
    currentDateTimestamp=$(date +%s)
    expiryDifference=$((${expiryTimestamp} - ${currentDateTimestamp}))
    
    if [ "${parameter2}" = "force" ]
    then
        generate
    else
        if [ ${expiryDifference} -lt 259200 ]
        then
            echo "Current certificate expires within 3 days." >> "${pathLog}"

            generate
        else
            echo "Certificate exists and is valid." >> "${pathLog}"
        fi
    fi
else
    generate
fi
