FROM debian:bookworm-slim

LABEL org.opencontainers.image.source https://github.com/boringwolf/pterodactyl-fivem

# 加入 MariaDB 官方套件來源
RUN apt-get update && apt-get install -y \
    gnupg \
    lsb-release \
    curl && \
    curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash

# 安裝其他必要套件與最新版 MariaDB client
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    build-essential \
    curl \
    git \
    libssl-dev \
    pkg-config \
    tar \
    jq \
    procps \
    liblua5.3-0 \
    libz-dev \
    tzdata \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# 建立 container 使用者
RUN useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
COPY        --chmod=777 ./start.sh /start.sh

CMD         [ "/bin/bash", "/entrypoint.sh" ]
