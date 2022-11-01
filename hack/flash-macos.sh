#! /usr/bin/env sh

set -e

device=${1:-}

if [ -z "${device:-}" ]; then
	printf 'error: device must be specified\n'
	exit 1
fi

device="/dev/r${device}"

diskutil unmountDisk "${device}" || true
sudo dd bs=4m if=images/ubuntu-22.04.1-arm64.img of="${device}"
diskutil eject "${device}"
