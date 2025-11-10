#!/bin/bash

echo "Execute container."

if [ -n "${1}" ] && [ "${1}" = "fast" ]
then
    docker compose -f docker-compose.yaml --env-file ./env/local.env up --detach --pull always
else
    docker compose -f docker-compose.yaml --env-file ./env/local.env build --no-cache
    docker compose -f docker-compose.yaml --env-file ./env/local.env up --detach --pull always
fi
