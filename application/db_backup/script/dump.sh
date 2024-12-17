#!/bin/bash

path="${PATH_ROOT}file_share/db_backup/"
filename="${DB_NAME}-$(date +%Y-%m-%d).dump"

echo "Dump ${DB_NAME}:\n"

PGPASSWORD="${DB_PASS}" pg_dump -Fc -v -h "${DB_HOST}" -U "${DB_USER}" -d "${DB_NAME}" -f "${path}${filename}"

find "${path}" -name "${DB_NAME}-*.dump" -type f -mtime +7 -delete
