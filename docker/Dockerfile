FROM python:3.8

ARG _ENV_NAME
ARG _DOMAIN
ARG _TIMEZONE
ARG _SERVER_PORT
ARG _VERSION_TAG

ENV ENV_NAME=${_ENV_NAME}
ENV DOMAIN=${_DOMAIN}
ENV TZ=${_TIMEZONE}
ENV VERSION_TAG=${_VERSION_TAG}

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes
ENV PATH="${PATH}:/home/root/.local/bin/:/root/.local/bin/"
ENV PYTHONPATH="/home/root/"
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

COPY ./application/tls/certificate/proxy/ /usr/local/share/ca-certificates/
COPY ./ /home/root/

RUN cd ~ \
    && VERSION_CODENAME=$(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) \
    && chmod -R 0644 /usr/local/share/ca-certificates/ \
    && apt-get update && apt-get install -y ca-certificates gnupg curl \
    && update-ca-certificates \
    # No root
    && groupadd -g 1000 pyuser \
    && useradd -d /home/root/ -s /bin/bash -u 1000 -g 1000 pyuser \
    && mkdir -p /home/root/ /home/root/file_share/certificate/ /home/root/file_share/db_backup/ /home/root/file_share/pod/ \
    && chown -R pyuser:pyuser /home/root/ \
    && chmod -R 775 /home/root/ \
    # Apt
    && apt-get update && apt-get install -y \
    fonts-noto \
    fonts-noto-cjk \
    postgresql-client \
    libpcre3-dev \
    # External library
    && wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
    && dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
    # Clean
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean -y \
    && apt-get autoclean -y \
    && apt-get autoremove -y

USER pyuser

WORKDIR /home/root/

# Pip
RUN python3 -m pip install pip --upgrade \
    && python3 -m pip install --user --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --trusted-host pypi.org -r /home/root/application/requirements.txt

# Tls
CMD chmod +x /home/root/application/tls/script/starter.sh \
    && bash /home/root/application/tls/script/starter.sh \
    && find /home/root/application/tls/certificate/ -maxdepth 1 -type f -exec cp {} /home/root/file_share/certificate/ \; \
    # Cron
    && yacron -c /home/root/cronjob.yaml -v \
    && yacron -c /home/root/cronjob.yaml \
    # Keep running
    && tail -f /dev/null

EXPOSE ${_SERVER_PORT}
