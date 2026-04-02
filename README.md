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
1. Create the root folder "ms_cronjob" and create this folder inside:
    - /certificate/custom/
    - /certificate/proxy/
    - /env/
    - /file/cronjob/
    - /log/

2. Create a "docker-compose.yaml" file and insert (replace xxx with your preferred name):
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

3. Copy the files "local.env" and "local.secret.env" from the github repository "https://github.com/cimo/Ms_cronjob.git", put it in your local "/ms_cronjob/env/" folder (you can replace "local" with your preferred name).
Change the variable values as needed.

4. For use the cronjob logic follow the example in this repository:

    https://github.com/cimo/Ms_cronjob.git

5. For up write on terminal:
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
