# Ms_cronjob

Microservice cronjob.

## Installation

1. For the proxy, copy the xxx.crt file in each "/certificate/proxy/" project folder before start the docker build.

2. For full build write on terminal:

```
docker compose -f docker-compose.yaml --env-file ./env/local.env build --no-cache \
&& docker compose -f docker-compose.yaml --env-file ./env/local.env up --detach --pull "always"
```

3. For light build (just env variable change) remove the container and write on terminal:

```
docker compose -f docker-compose.yaml --env-file ./env/local.env up --detach --pull "always"
```

## Reset

1. Remove this from the root:

    - .cache
    - .config
    - .local
    - .pki
    - application/tls/certificate/tls.crt
    - application/tls/certificate/tls.key
    - application/tls/certificate/tls.pem

2. Follow the "Installation" instructions.
