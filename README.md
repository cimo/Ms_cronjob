# Ms_cronjob

Microservice cronjob.

Rename "/env/local.env.public" in "/env/local.env" and adjust the variable for your environment.

## Setup WSL

1. Wrinte on terminal:

```
docker compose -f docker-compose.yaml --env-file ./env/local.env up --detach --build --pull "always"
```
