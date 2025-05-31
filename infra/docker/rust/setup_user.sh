#!/bin/bash

HOST_USR=$1
HOST_UID=$2
HOST_GID=$3

# If the user already exists, delete it
EXISTING_USERNAME=$(getent passwd | awk -F: '$3 == '"${HOST_UID}"' { print $1 }')
if [ ! -z "$EXISTING_USERNAME" ]; then
    userdel -r $EXISTING_USERNAME
else
    echo "Aucun utilisateur trouvé avec l'UID ${HOST_UID}"
fi

# Create docker user with the same UID and GID as the host user
groupadd -g ${HOST_GID} ${HOST_USR}
useradd -u ${HOST_UID} -g ${HOST_GID} -s /bin/zsh -m ${HOST_USR}
echo ${HOST_USR} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${HOST_USR}
chmod 0440 /etc/sudoers.d/${HOST_USR}