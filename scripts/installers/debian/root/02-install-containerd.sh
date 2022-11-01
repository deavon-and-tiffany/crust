#! /usr/bin/env sh

set -e

. /etc/os-release

cat << EOF > /etc/apt/sources.list.d/docker.list
deb [arch=${TARGET_ARCH} signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable
EOF

apt update -y
apt install -y containerd.io
