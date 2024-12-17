FROM python:3.10.14

ARG _ENV_NAME
ARG _DOMAIN
ARG _TIMEZONE
ARG _SERVER_PORT
ARG _SERVER_LOCATION
ARG _PATH_ROOT
ARG _VERSION_TAG

ENV ENV_NAME=${_ENV_NAME}
ENV DOMAIN=${_DOMAIN}
ENV TZ=${_TIMEZONE}
ENV SERVER_PORT=${_SERVER_PORT}
ENV SERVER_LOCATION=${_SERVER_LOCATION}
ENV PATH_ROOT=${_PATH_ROOT}
ENV VERSION_TAG=${_VERSION_TAG}

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes
ENV PATH="${PATH}:${PATH_ROOT}.local/bin/:/root/.local/bin/"
ENV PYTHONPATH="${PATH_ROOT}"
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV SUDO_FORCE_REMOVE=yes

COPY ./application/tls/certificate/proxy/ /usr/local/share/ca-certificates/
COPY ./ ${PATH_ROOT}

RUN cd ~ \
    # No root
    && mkdir -p ${PATH_ROOT} /var/log/django/ \
    && useradd -U pyuser -d ${PATH_ROOT} -s /bin/bash \
    && chown -R pyuser:pyuser ${PATH_ROOT} /var/log/django/ \
    && chmod -R 775 ${PATH_ROOT} /var/log/django/ \
    # Update
    && VERSION_CODENAME=$(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) \
    && chmod -R 0644 /usr/local/share/ca-certificates/ \
    && apt-get update && apt-get install -y ca-certificates curl \
    && update-ca-certificates \
    # Apt
    && apt-get update && apt-get install -y \
    fonts-noto \
    fonts-noto-cjk \
    postgresql-client \
    # Clean
    && apt-get remove --purge -y sudo \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean -y \
    && apt-get autoclean -y \
    && apt-get autoremove -y

USER pyuser

WORKDIR ${PATH_ROOT}

RUN python3 -m pip install pip --upgrade \
    && python3 -m pip install --user --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --trusted-host pypi.org -r ${PATH_ROOT}application/requirements.txt

# Tls
CMD chmod +x ${PATH_ROOT}application/tls/script/starter.sh \
    && bash ${PATH_ROOT}application/tls/script/starter.sh \
    && find ${PATH_ROOT}application/tls/certificate/ -maxdepth 1 -type f -exec cp {} ${PATH_ROOT}file_share/certificate/ \; \
    # DB backup
    && chmod +x ${PATH_ROOT}application/db_backup/script/dump.sh \
    # Cron
    && yacron -c ${PATH_ROOT}cronjob.yaml -v \
    && yacron -c ${PATH_ROOT}cronjob.yaml \
    # Keep running
    && tail -f /dev/null

EXPOSE ${SERVER_PORT}
