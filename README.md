# Ms_cronjob

Microservice cronjob.

## Installation

1. In case of proxy, put the certificate in "/certificate/proxy/" folder before start the build.

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

    - .file_share
    - .npm
    - dist
    - node_modules
    - package-lock.json

2. Follow the "Installation" instructions.
