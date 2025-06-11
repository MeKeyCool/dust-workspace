FROM rust:1.79

ARG HOST_USR=appuser
ARG HOST_UID=1000
ARG HOST_GID=1000

# Paquets système nécessaires pour compiler + client Postgres pour debug éventuel
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libpq-dev \
    libssl-dev \
    pkg-config \
    postgresql-client \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Création de l'utilisateur
RUN groupadd -g ${HOST_GID} appgroup && \
    useradd -m -u ${HOST_UID} -g appgroup ${HOST_USR}

# Définir les dossiers Rust pour l'utilisateur (optionnel, déjà faits automatiquement mais explicite ici)
ENV CARGO_HOME=/home/${HOST_USR}/.cargo
ENV RUSTUP_HOME=/home/${HOST_USR}/.rustup
ENV PATH=$CARGO_HOME/bin:$PATH

USER ${HOST_USR}
WORKDIR /app

# Initialisation rustup pour l'utilisateur final
RUN rustup default stable
