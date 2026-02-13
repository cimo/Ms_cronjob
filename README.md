# Ms_cronjob

Microservice cronjob.

It's possible to use a custom certificate instead of internal, just add it to the "certificate" folder before build the container.

## Info:

-   Cross platform (Windows, Linux)

## Installation

1. For build and up write on terminal:

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
    bash script/tls.sh "local" "force"
    ```
