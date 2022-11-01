#! /usr/bin/env sh

set -e

crane_arch=${TARGET_ARCH}

if [ "${crane_arch}" = "amd64" ]; then
	crane_arch="x86_64"
fi

download-tool \
	"https://github.com/google/go-containerregistry/releases/latest/download/go-containerregistry_Linux_${crane_arch}.tar.gz" \
	crane.tar.gz

tar --extract --gzip \
	--directory=/usr/local/bin \
	--file crane.tar.gz \
	crane \
	gcrane
chmod ugo=rx \
	/usr/local/bin/crane \
	/usr/local/bin/gcrane
