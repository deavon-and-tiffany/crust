#! /usr/bin/env sh

set -e

binfmt --install all

mkdir -p "${PACKER_PLUGIN_PATH}"
mkdir -p "${PACKER_CACHE_DIR}"
mkdir -p images

packer "${@}"
