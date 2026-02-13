#!/bin/bash

# Environment
chmod +x "script/environment.sh"
source "script/environment.sh" "${1}"

pathCertificate="${PATH_ROOT}.file_share/certificate/"
pathCaKey="${pathCertificate}ca.key"
pathCaPem="${pathCertificate}ca.pem"
pathKey="${pathCertificate}tls.key"
pathCrt="${pathCertificate}tls.crt"
pathLog="${PATH_ROOT}${MS_C_PATH_LOG}tls.log"

common() {
    local source="${1}"
    local target="${2}"

    mapfile -d '' -t fileList < <(find "${source}" -type f \( -name '*.crt' -o -name '*.key' -o -name '*.pem' \) -print0 2>/dev/null)

    if [ ${#fileList[@]} -gt 0 ]
    then
        for file in "${source}"*
        do
            fileName=$(basename "${file}")

            if [ ! -e "${target}${fileName}" ]
            then
                cp "${file}" "${target}"

                echo "Certificate '${fileName}' copied." >> "${pathLog}"
            else
                echo "Certificate '${fileName}' already exist." >> "${pathLog}"
            fi
        done
    fi
}

custom() {
    mkdir -p "${PATH_ROOT}.file_share/certificate/custom/"

    source="${PATH_ROOT}certificate/custom/"
    target="${PATH_ROOT}.file_share/certificate/custom/"

    common "${source}" "${target}"
}

proxy() {
    mkdir -p "${PATH_ROOT}.file_share/certificate/proxy/"
    
    source="${PATH_ROOT}certificate/proxy/"
    target="${PATH_ROOT}.file_share/certificate/proxy/"

    common "${source}" "${target}"
}

generate() {
    echo "Generate new certificate." >> "${pathLog}"

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
        -out "${pathCertificate}server.csr" >> "${pathLog}" 2>&1

    openssl x509 -req -in "${pathCertificate}server.csr" \
        -CA "${pathCaPem}" -CAkey "${pathCaKey}" -CAcreateserial \
        -out "${pathCrt}" -days 365 -sha256 \
        -copy_extensions copy >> "${pathLog}" 2>&1

    rm -f "${pathCertificate}server.csr"

    chmod 600 "${pathKey}"
}

custom

proxy

if [ -f "${pathCrt}" ]
then
    expiry=$(openssl x509 -enddate -noout -in "${pathCrt}" | cut -d= -f2)
    expiryTimestamp=$(date -d "${expiry}" +%s)
    currentDateTimestamp=$(date +%s)
    expiryDifference=$((${expiryTimestamp} - ${currentDateTimestamp}))
    
    if [ "${1}" = "force" ]
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
    echo "Certificate does not exist." >> "${pathLog}"

    generate
fi
