#! /usr/bin/env sh

set -e

# source env scripts
. import-env

k3s_arch=${TARGET_ARCH}
asset_name="k3s-airgap-images-${k3s_arch}"
output_dir=/var/lib/rancher/k3s/agent/images/

download-tool \
	"https://github.com/k3s-io/k3s/releases/latest/download/${asset_name}.tar.gz" \
	"${asset_name}.tar.gz"

gzip --decompress "${asset_name}.tar.gz"

mkdir -p "${output_dir}"
mv "${asset_name}.tar" "${output_dir}"

download-tool \
	"https://github.com/k3s-io/k3s/releases/latest/download/k3s-${k3s_arch}" \
	/usr/local/bin/k3s
chmod ugo=rx /usr/local/bin/k3s

download-tool \
	https://get.k3s.io \
	/usr/local/bin/install-k3s
chmod ugo=rx /usr/local/bin/install-k3s

env_set INSTALL_K3S_SKIP_DOWNLOAD 'true'

# enable cgroups
sed -i '1s/$/ cgroup_enable=cpuset cgroup_enable=memory/' /boot/firmware/cmdline.txt
