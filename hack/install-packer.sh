#! /usr/bin/env sh

set -e

# get the current architecture
arch=$(uname -m)

# normalise architecture across distros
if [ "${arch}" = "x86_64" ]; then
	arch="amd64"
elif [ "${arch}" = "aarch64" ]; then
	arch="arm64"
fi

# set script path and agent tools directory
TARGETPLATFORM="${TARGETPLATFORM:-"linux/${arch}"}"
TARGET_ARCH="${TARGETPLATFORM#*\/}"
TARGET_ARCH="${TARGET_ARCH%\/*}"

PACKER_VERSION=$(curl --silent https://checkpoint-api.hashicorp.com/v1/check/packer | jq -r .current_version)

curl --location --silent --fail --output packer.zip \
	"https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_${TARGET_ARCH}.zip"

unzip -q packer.zip -d /bin
