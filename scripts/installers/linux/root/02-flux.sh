#! /usr/bin/env sh

set -e

flux_arch=${TARGET_ARCH}

flux_version=${flux_version:-$(get-latest-release fluxcd flux2)}

download-tool \
	"https://github.com/fluxcd/flux2/releases/download/v${flux_version}/flux_${flux_version}_linux_${flux_arch}.tar.gz" \
	flux.tar.gz

tar --extract --gzip \
	--directory=/usr/local/bin \
	--file flux.tar.gz \
	flux
chmod ugo=rx /usr/local/bin/flux
