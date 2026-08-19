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
cp -a "/home/source/." "/home/target/" &&
chown -R "${HOST_UID}:${HOST_GID}" "/home/target/" &&
chmod -R u+rwX,go+rX "/home/target/" &&
chmod 600 "/home/target/ca.key" "/home/target/tls.key"
'
