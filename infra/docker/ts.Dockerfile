FROM node:22.4-bullseye


RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y sudo wget git zsh zplug

# Clean up
RUN apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Set user and group
ARG HOST_USR=appuser
ARG HOST_UID=1000
ARG HOST_GID=1000

COPY setup_user.sh /tmp/setup-user.sh
RUN chmod +x /tmp/setup-user.sh && /tmp/setup-user.sh ${HOST_USR} ${HOST_UID} ${HOST_GID}

# Switch to user
USER ${HOST_USR}


# Oh My zsh
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" && \
    echo "export PATH=\"/home/${HOST_USR}/.local/bin:\$PATH\"" >> ~/.zshrc

# https://github.com/sindresorhus/guides/blob/main/npm-global-without-sudo.md
RUN mkdir "${HOME}/.npm-packages" && \ 
    npm config set prefix "${HOME}/.npm-packages" && \ 
    echo "NPM_PACKAGES=\"${HOME}/.npm-packages\"" >> ~/.zshrc && \ 
    echo "export PATH=\"\$PATH:\$NPM_PACKAGES/bin\"" >> ~/.zshrc && \ 
    echo "# Preserve MANPATH if you already defined it somewhere in your config." >> ~/.zshrc && \ 
    echo "# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`." >> ~/.zshrc && \ 
    echo "export MANPATH=\"${MANPATH-$(manpath)}:\$NPM_PACKAGES/share/man\"" >> ~/.zshrc

# Install global npm packages
RUN npm install -g ts-node typescript '@types/node'


