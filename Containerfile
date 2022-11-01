FROM tonistiigi/binfmt:qemu-v7.0.0 AS binfmt
FROM golang:bullseye AS plugin

RUN set -ex; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
    ca-certificates \
    curl \
    jq \
    unzip \
    upx-ucl

WORKDIR /workspace
COPY hack/install-packer.sh .
RUN ./install-packer.sh

ENV GOBIN=/bin

RUN go install github.com/mkaczanowski/packer-builder-arm@latest
RUN upx-ucl --lzma /bin/packer-builder-arm /bin/packer

FROM ubuntu:latest

RUN set -ex; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
    ca-certificates \
    dosfstools \
    fdisk \
    gdisk \
    kpartx \
    libarchive-tools \
    parted \
    psmisc \
    qemu-utils \
    sudo \
    xz-utils; \
    rm -rf /var/lib/apt/lists/*

COPY --from=plugin /bin/packer /bin/packer-builder-arm /bin/
COPY --from=binfmt /usr/bin/ /usr/bin

WORKDIR /workspace
COPY entrypoint.sh /usr/local/bin/entrypoint

ENV PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
    PACKER_CACHE_DIR=/workspace/.packer.d/cache \
    PACKER_LOG=1 \
    DONT_SETUP_QEMU=1

ENTRYPOINT [ "entrypoint" ]
