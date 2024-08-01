# Ms_cronjob

Microservice cronjob.

## Installation

1. Write on terminal:

```
docker compose -f docker-compose.yaml --env-file ./env/local.env build --no-cache \
&& docker compose -f docker-compose.yaml --env-file ./env/local.env up --detach --pull "always"
```

## Reset

1. Remove this from the root:

    - .cache
    - .config
    - .local
    - application/tls/certificate/tls.crt
    - application/tls/certificate/tls.key

2. Follow the "Installation" instructions.
