#! /usr/bin/env sh

set -e

cosign_arch=${TARGET_ARCH}

download-tool \
	"https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-${cosign_arch}" \
	/usr/local/bin/cosign
chmod ugo=rx /usr/local/bin/cosign
