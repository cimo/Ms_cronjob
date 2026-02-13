#!/bin/bash

p1=$(printf '%s' "${1}" | xargs)

if [ -z "${p1}" ]
then
    echo "environment - Missing parameter."

    exit 1
fi

parameter1="${1}"

pathEnvFile="./env/${parameter1}.env"

if [ -f "${pathEnvFile}" ]
then
    while IFS= read -r line
    do
        if [ -n "${line}" ]
        then
            key=$(echo "${line}" | cut -d "=" -f 1)

            value=$(echo "${line}" | cut -d "=" -f 2-)
            value=$(echo "${value}" | sed "s/^'\(.*\)'$/\1/")

            if [ -z "$(printenv "${key}")" ]
            then
                export "${key}=${value}"
            fi
        fi
    done < "${pathEnvFile}"
fi

export PATH="${PATH}:${PATH_ROOT}.local/bin/:/root/.local/bin/"
