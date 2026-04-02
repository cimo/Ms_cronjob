# Ms_cronjob
Microservice cronjob.

It's possible to use a custom certificate instead of self‑signed.
Just add it to the "/certificate/custom/" folder and change the env variable before build the container.

## Info:
- Cross platform (Windows, Linux)

## Installation from source
1. Clone the repository:

    https://github.com/cimo/Ms_cronjob.git

2. For build and up write on terminal:
```
bash docker/container_execute.sh "local" "build-up"
```

3. Just for up write on terminal:
```
bash docker/container_execute.sh "local" "up"
```

## Installation from hub image
1. Create the root folder "/ms_cronjob/" and create this folder inside:
    - /certificate/custom/
    - /certificate/proxy/
    - /env/
    - /file/cronjob/
    - /log/

2. Create a "docker-compose.yaml" file in the root folder and insert (replace xxx with your preferred name):
```
services:
  xxx_ms_cronjob:
    container_name: xxx-ms-cronjob
    env_file:
      - ./env/local.env
      - ./env/local.secret.env
    environment:
      LIBGL_ALWAYS_SOFTWARE: "1"
      GALLIUM_DRIVER: "llvmpipe"
      MESA_LOADER_DRIVER_OVERRIDE: "llvmpipe"
    shm_size: "2gb"
    image: cimo001/ms_cronjob:1.0.0
    ports:
      - 127.0.0.1:${SERVER_PORT}:${SERVER_PORT}
    extra_hosts:
      - "host.docker.internal:host-gateway"
    volumes:
      - ./certificate/:${PATH_ROOT}/certificate/
      - ./file/:${PATH_ROOT}/file/
      - ./log/:${PATH_ROOT}/log/
      - ms_cronjob-volume:/usr/local/share/ca-certificates/
      - /var/run/docker.sock:/var/run/docker.sock
      - /mnt/wslg:/mnt/wslg
      - /usr/lib/wsl/lib:/usr/lib/wsl/lib
volumes:
  ms_cronjob-volume:
```

3. Create the "/ms_cronjob/env/local.env" file and insert (change the variable value as needed):
```
BUILD_ENV='development'
COMPOSE_PROJECT_NAME='xxx_local'
DOCKERFILE=''

ENV_NAME='local'
DOMAIN='localhost'
TIME_ZONE='Asia/Tokyo'
LANG='C.UTF-8'
SERVER_PORT='1041'
PATH_ROOT='/home/app/'

MS_C_NAME='Ms cronjob'
MS_C_LABEL='ms_c'
MS_C_IS_DEBUG='true'
MS_C_NODE_ENV='development'
MS_C_URL_ROOT=''
MS_C_URL_CORS_ORIGIN='["http://localhost","https://localhost","http://host.docker.internal","https://host.docker.internal"]'
MS_C_PATH_CERTIFICATE_KEY='/usr/local/share/ca-certificates/tls.key'
MS_C_PATH_CERTIFICATE_CRT='/usr/local/share/ca-certificates/tls.crt'
MS_C_PATH_CERTIFICATE_PEM='/usr/local/share/ca-certificates/ca.pem'
MS_C_PATH_FILE='file/'
MS_C_PATH_LOG='log/'
MS_C_PATH_SCRIPT='script/'
```

4. Create the "/ms_cronjob/env/local/secret.env" (will be use only for secret value).

5. For use the cronjob logic follow the "example" in this repository:

    https://github.com/cimo/Npm_cronjob

6. For up write on terminal:
```
docker compose -f docker-compose.yaml --env-file ./env/local.env --env-file ./env/local.secret.env up --detach --pull always
```

## Reset
1. Delete this from the root:
    - .cache
    - .config
    - .local
    - .npm
    - .pki
    - .venv
    - dist
    - node_modules
    - package-lock.json

2. Follow the "Installation" instructions.

## Command
1. To force self‑signed certificate regeneration write on terminal:
```
bash script/tls.sh "force"
```
