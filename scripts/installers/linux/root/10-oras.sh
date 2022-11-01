#! /usr/bin/env sh

set -e

oras_arch=${TARGET_ARCH}

oras_version=${oras_version:-$(get-latest-release oras-project oras)}

download-tool \
	"https://github.com/oras-project/oras/releases/download/v${oras_version}/oras_${oras_version}_linux_${oras_arch}.tar.gz" \
	oras.tar.gz

tar --extract --gzip \
	--directory=/usr/local/bin \
	--file oras.tar.gz \
	oras
chmod ugo=rx /usr/local/bin/oras
