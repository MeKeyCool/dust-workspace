FROM rust:1.79

ARG HOST_UID=1000
ARG HOST_GID=1000

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libpq-dev \
    libssl-dev \
    pkg-config \
    vim \
    redis-tools \
    postgresql-client \
    htop

# Gestion de l'utilisateur
RUN groupadd -g ${HOST_GID} appgroup && \
    useradd -m -u ${HOST_UID} -g appgroup appuser

# Installer nightly + le mettre par défaut
RUN rustup install nightly && rustup default nightly

WORKDIR /app
USER appuser
