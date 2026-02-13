#!/bin/bash

p1=$(printf '%s' "${1}" | xargs)
p2=$(printf '%s' "${2}" | xargs)

if [ -z "${p1}" ] || [ -z "${p2}" ]
then
    echo "container_execute.sh - Missing parameter."

    exit 1
fi

parameter1="${1}"
parameter2="${2}"

bash "./script/tls.sh" "${parameter1}" "-"

echo "Execute container."

if [ "${parameter2}" = "build-up" ]
then
    docker compose -f docker-compose.yaml --env-file ./env/${parameter1}.env build --no-cache &&
    docker compose -f docker-compose.yaml --env-file ./env/${parameter1}.env up --detach --pull always
elif [ "${parameter2}" = "up" ]
then
    docker compose -f docker-compose.yaml --env-file ./env/${parameter1}.env up --detach --pull always
fi
