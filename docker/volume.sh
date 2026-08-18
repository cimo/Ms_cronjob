#!/bin/bash

p1=$(printf '%s' "${1}" | xargs)

if [ -z "${p1}" ]
then
    echo -e "\n❌ volume.sh - Missing parameter."

    exit 1
fi

parameter1="${p1}"

docker run --rm \
-e HOST_UID="$(id -u)" \
-e HOST_GID="$(id -g)" \
-v "cimo_${parameter1}_ms_cronjob-volume:/home/target/" \
-v "$(pwd)/certificate/:/home/source/:ro" \
alpine sh -c '
cp "/home/source/ca.key" "/home/source/ca.pem" "/home/source/tls.crt" "/home/source/tls.key" "/home/target/" &&
chown "$HOST_UID:$HOST_GID" "/home/target/ca.key" "/home/target/ca.pem" "/home/target/tls.crt" "/home/target/tls.key" &&
chmod 644 "/home/target/ca.pem" "/home/target/tls.crt" && chmod 600 "/home/target/ca.key" "/home/target/tls.key"
'
