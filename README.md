# Ms_cronjob

Microservice cronjob.

## Installation

1. In case of a proxy, place the certificate in the "/certificate/proxy/" folder before starting the build.

2. For build and up write on terminal:

```
bash docker/container_execute.sh "local" "build-up"
```

3. Just for up write on terminal:

```
bash docker/container_execute.sh "local" "up"
```

## Reset

1. Remove this from the root:

    - .cache
    - .config
    - .file_share
    - .local
    - .npm
    - .pki
    - dist
    - node_modules
    - package-lock.json

2. Follow the "Installation" instructions.

## Command

1. To force certificate regeneration write on terminal:

    ```
    bash script/tls.sh "force"
    ```
