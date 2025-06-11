# FROM node:24.0-bullseye
# FROM node:22.16-bullseye
FROM node:20.13-bullseye

# --- 1. Packages de base + outils dev ---
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y sudo wget git zsh zplug vim redis-tools postgresql-client htop && \
    apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# --- 2. User non-root avec UID/GID ---
ARG HOST_USR=appuser
ARG HOST_UID=1000
ARG HOST_GID=1000
COPY setup_user.sh /tmp/setup-user.sh
RUN chmod +x /tmp/setup-user.sh && /tmp/setup-user.sh ${HOST_USR} ${HOST_UID} ${HOST_GID}
USER ${HOST_USR}

# --- 3. Environnement shell confortable ---
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" && \
    echo "export PATH=\"/home/${HOST_USR}/.local/bin:\$PATH\"" >> ~/.zshrc

# NPM global sans sudo
RUN mkdir "${HOME}/.npm-packages" && \
    npm config set prefix "${HOME}/.npm-packages" && \
    echo "NPM_PACKAGES=\"${HOME}/.npm-packages\"" >> ~/.zshrc && \
    echo "export PATH=\"\$PATH:\$NPM_PACKAGES/bin\"" >> ~/.zshrc && \
    echo "# Preserve MANPATH if already defined." >> ~/.zshrc && \
    echo "export MANPATH=\"${MANPATH-$(manpath)}:\$NPM_PACKAGES/share/man\"" >> ~/.zshrc

# --- 4. NPM tools globaux ---
RUN npm install -g ts-node typescript '@types/node' concurrently
ENV PATH="/home/${HOST_USR}/.npm-packages/bin:${PATH}"

# --- 5. Entrée par défaut ---
WORKDIR /app
