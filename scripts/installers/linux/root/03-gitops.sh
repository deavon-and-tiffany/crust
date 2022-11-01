#! /usr/bin/env sh

set -e

gitops_arch=${TARGET_ARCH}

download-tool \
	"https://github.com/weaveworks/weave-gitops/releases/latest/download/gitops-linux-${gitops_arch}.tar.gz" \
	gitops.tar.gz

tar --extract --gzip \
	--directory=/usr/local/bin \
	--file gitops.tar.gz \
	gitops
chmod ugo=rx /usr/local/bin/flux
