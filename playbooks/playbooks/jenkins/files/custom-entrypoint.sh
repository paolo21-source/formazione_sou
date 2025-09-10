#!/bin/sh
set -e

ssh-keygen -A

mkdir -p /var/run/sshd
/usr/sbin/sshd -D &

echo "${AUTHORIZED_KEYS:-}" > /root/.ssh/authorized_keys
mkdir -p /root/.docker/ && echo ${DOCKER_CONFIG_JSON:-} > /root/.docker/config.json

# Avvia Jenkins
exec /usr/local/bin/jenkins.sh "$@"
