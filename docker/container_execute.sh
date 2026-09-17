#!/bin/bash

p1=$(printf '%s' "${1}" | xargs)
p2=$(printf '%s' "${2}" | xargs)
p3=$(printf '%s' "${3}" | xargs)

if [ "$#" -lt 2 ]
then
    echo -e "\n❌ container_execute.sh - Missing parameter."

    exit 1
fi

parameter1="${p1}"
parameter2="${p2}"
parameter3="${p3}"

projectName="cimo"
volumeName="${projectName}_${parameter1}_ms_cronjob-volume"

bash "./script/tls.sh" "${parameter3}"

echo -e "\nExecute container."

if [ "${parameter2}" = "build-up" ]
then
    docker compose -f "docker-compose.yaml" --env-file "./env/${parameter1}.env" --env-file "./env/${parameter1}.secret.env" build --no-cache &&
    docker compose -f "docker-compose.yaml" --env-file "./env/${parameter1}.env" --env-file "./env/${parameter1}.secret.env" create
elif [ "${parameter2}" = "up" ]
then
    docker compose -f "docker-compose.yaml" --env-file "./env/${parameter1}.env" --env-file "./env/${parameter1}.secret.env" create
fi

if [ "${parameter2}" = "build-up" ] || [ "${parameter2}" = "up" ]
then
    echo -e "\nCopying to volume..."

    docker run --rm \
    -e HOST_UID="$(id -u)" \
    -e HOST_GID="$(id -g)" \
    -v "${volumeName}:/home/target/" \
    -v "$(pwd)/certificate/:/home/source/:ro" \
    alpine sh -c '
    cp -a "/home/source/." "/home/target/" &&
    chown -R "${HOST_UID}:${HOST_GID}" "/home/target/" &&
    chmod -R u+rwX,go+rX "/home/target/" &&
    chmod 600 "/home/target/ca.key" "/home/target/tls.key"
    ' &&
    docker compose -f "docker-compose.yaml" --env-file "./env/${parameter1}.env" --env-file "./env/${parameter1}.secret.env" up --detach --pull always --force-recreate --wait &&
    docker compose -f "docker-compose.yaml" --env-file "./env/${parameter1}.env" --env-file "./env/${parameter1}.secret.env" exec -u root -T "${projectName}_ms_cronjob" update-ca-certificates
fi
