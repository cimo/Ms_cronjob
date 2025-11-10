# Ms_cronjob

Microservice cronjob.

## Installation

1. In case of proxy, put the certificate in "/docker/certificate/proxy/" folder before start the build.

2. For full build write on terminal:

```
bash docker/container_execute.sh
```

3. For light build (just env variable change) remove the container and write on terminal:

```
bash docker/container_execute.sh "fast"
```

## Reset

1. Remove this from the root:

    - .file_share
    - .npm

2. Follow the "Installation" instructions.
