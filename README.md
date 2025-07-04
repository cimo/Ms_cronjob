# Ms_cronjob

Microservice cronjob.

## Installation

1. For full build write on terminal:

```
docker compose -f docker-compose.yaml --env-file ./env/local.env build --no-cache \
&& docker compose -f docker-compose.yaml --env-file ./env/local.env up --detach --pull "always"
```

2. For light build (just env variable change) remove the container and write on terminal:

```
docker compose -f docker-compose.yaml --env-file ./env/local.env up --detach --pull "always"
```

3. Copy the file "/application/tls/certificate/proxy/ZscalerRootCa.crt" in "/certificate/proxy/" folder for each branch and start the docker build.

## Reset

1. Remove this from the root:

    - .cache
    - .config
    - .local
    - application/tls/certificate/tls.crt
    - application/tls/certificate/tls.key
    - application/tls/certificate/tls.pem

2. Follow the "Installation" instructions.
