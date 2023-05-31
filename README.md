# Ms_cronjob

Microservice cronjob.

## Setup

1. Wrinte on terminal:

```
docker compose -f docker-compose.yaml --env-file ./env/local.env up -d --build
```

2. If you have a proxy execute this command (if you use a certificate put it in "/certificate/proxy/" folder):

```
DOCKERFILE="Dockerfile_local_proxy" docker compose -f docker-compose.yaml --env-file ./env/local.env up -d --build
```
