#!/bin/bash

mkdir -p "${PATH_ROOT}.file_share/certificate/proxy/"

pathCrt="${PATH_ROOT}.file_share/certificate/tls.crt"
pathKey="${PATH_ROOT}.file_share/certificate/tls.key"
pathPem="${PATH_ROOT}.file_share/certificate/tls.pem"
pathLog="${PATH_ROOT}${MS_C_PATH_LOG}tls.log"

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
            DNS:cimo-ms-ai-cpu,\
            DNS:cimo-ms-ai-gpu,\
            DNS:cimo-ms-antivirus,\
            DNS:cimo-ms-automate-test,\
            DNS:cimo-ms-cronjob,\
            DNS:cimo-ms-file-converter,\
            DNS:cimo-ms-mcp,\
            DNS:cimo-ms-ocr-cpu,\
            DNS:cimo-ms-ocr-gpu" \
        -subj "/C=JP/ST=Tokyo/L=Tokyo/O=CIMO/OU=LOCAL/CN=${DOMAIN}" >> "${pathLog}" 2>&1

    chmod 0644 "${pathKey}"

    concatenate
}

proxy() {
    source="${PATH_ROOT}certificate/proxy/"
    target="${PATH_ROOT}.file_share/certificate/proxy/"

    mapfile -d '' -t fileList < <(find "${source}" -type f \( -name '*.crt' -o -name '*.key' -o -name '*.pem' \) -print0 2>/dev/null)

    if [ ${#fileList[@]} -gt 0 ]
    then
        for file in "${source}"*
        do
            fileName=$(basename "${file}")

            if [ ! -e "${target}${fileName}" ]
            then
                cp "${file}" "${target}"

                echo "Proxy certificate '${fileName}' copied." >> "${pathLog}"
            else
                echo "Proxy certificate '${fileName}' already exist." >> "${pathLog}"
            fi
        done
    fi
}

proxy

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
