#! /usr/bin/env sh

set -e

apt update -y
apt install --no-install-recommends -y \
	ca-certificates \
	curl \
	gzip \
	jq \
	ssh-import-id \
	tar
