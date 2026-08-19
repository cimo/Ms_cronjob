#!/bin/bash

p1=$(printf '%s' "${1}" | xargs)
p2=$(printf '%s' "${2}" | xargs)

if [ "$#" -lt 2 ]
then
    echo -e "\n❌ container_execute.sh - Missing parameter."

    exit 1
fi

parameter1="${p1}"
parameter2="${p2}"

bash "./script/tls.sh" ""

echo -e "\nExecute container."

projectName="cimo"

if [ "${parameter2}" = "build-up" ]
then
    docker compose -f "docker-compose.yaml" --env-file "./env/${parameter1}.env" --env-file "./env/${parameter1}.secret.env" build --no-cache &&
    docker compose -f "docker-compose.yaml" --env-file "./env/${parameter1}.env" --env-file "./env/${parameter1}.secret.env" up --detach --pull always --wait
elif [ "${parameter2}" = "up" ]
then
    docker compose -f "docker-compose.yaml" --env-file "./env/${parameter1}.env" --env-file "./env/${parameter1}.secret.env" up --detach --pull always --wait
fi

if [ "${parameter2}" = "build-up" ] || [ "${parameter2}" = "up" ]
then
    docker compose -f "docker-compose.yaml" --env-file "./env/${parameter1}.env" --env-file "./env/${parameter1}.secret.env" exec -u root -T "${projectName}_ms_cronjob" sh -c 'cp -a "${PATH_ROOT}certificate/." "/usr/local/share/ca-certificates/"' &&
    docker compose -f "docker-compose.yaml" --env-file "./env/${parameter1}.env" --env-file "./env/${parameter1}.secret.env" exec -u root -T "${projectName}_ms_cronjob" update-ca-certificates
fi
