FROM python:3.10.14

ARG _ENV_NAME
ARG _DOMAIN
ARG _TIME_ZONE
ARG _LANG
ARG _SERVER_PORT
ARG _PATH_ROOT
ARG _VERSION_TAG

ENV ENV_NAME=${_ENV_NAME}
ENV DOMAIN=${_DOMAIN}
ENV TZ=${_TIME_ZONE}
ENV LANG=${_LANG}
ENV SERVER_PORT=${_SERVER_PORT}
ENV PATH_ROOT=${_PATH_ROOT}
ENV VERSION_TAG=${_VERSION_TAG}

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes
ENV SUDO_FORCE_REMOVE=yes
ENV PATH="${PATH}:${PATH_ROOT}.local/bin/:/root/.local/bin/"
ENV PYTHONPATH="${PATH_ROOT}"
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

COPY ./application/tls/certificate/proxy/ /usr/local/share/ca-certificates/
COPY ./ ${PATH_ROOT}

RUN cd ~ \
    # No root
    && mkdir -p ${PATH_ROOT} ${PATH_ROOT}file_share/certificate/ ${PATH_ROOT}file_share/db_backup/ \
    && useradd -U pyuser -d ${PATH_ROOT} -s /bin/bash \
    && chown -R pyuser:pyuser ${PATH_ROOT} ${PATH_ROOT}file_share/certificate/ ${PATH_ROOT}file_share/db_backup/ \
    && chmod -R 775 ${PATH_ROOT} ${PATH_ROOT}file_share/certificate/ ${PATH_ROOT}file_share/db_backup/ \
    # Update
    && VERSION_CODENAME=$(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) \
    && chmod -R 0644 /usr/local/share/ca-certificates/ \
    && apt-get update && apt-get install -y ca-certificates tzdata curl \
    && update-ca-certificates \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone \
    # Apt
    && apt-get update && apt-get install -y \
    fonts-noto \
    fonts-noto-cjk \
    media-types \
    postgresql-client \
    # Clean
    && apt-get remove --purge -y sudo \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean -y \
    && apt-get autoclean -y \
    && apt-get autoremove -y

USER pyuser

WORKDIR ${PATH_ROOT}

# Pip
RUN python3 -m pip install pip --upgrade \
    && python3 -m pip install --user --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --trusted-host pypi.org -r ${PATH_ROOT}application/requirements.txt

# DB backup
CMD chmod +x ${PATH_ROOT}application/db_backup/script/dump.sh \
    # Cron
    && yacron -c ${PATH_ROOT}cronjob.yaml -v \
    && yacron -c ${PATH_ROOT}cronjob.yaml \
    # Keep running
    && tail -f /dev/null

EXPOSE ${SERVER_PORT}
