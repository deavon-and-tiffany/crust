#! /usr/bin/env sh

set -e

apt install -y cloud-init

systemctl mask dhcpd
