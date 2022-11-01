#! /usr/bin/env sh

set -e

apt update -y

# update the kernel and add additional modules (vxlan)
apt install -y \
	linux-image-raspi \
	linux-modules-extra-raspi
