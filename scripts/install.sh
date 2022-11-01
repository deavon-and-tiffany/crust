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

# set script path target variables
export SCRIPT_PATH="${SCRIPT_PATH:-$(cd -- "$(dirname -- "$0")" && pwd -P)}"
export TARGETPLATFORM="${TARGETPLATFORM:-"linux/${arch}"}"
export TARGET_OS="${TARGETPLATFORM%%\/*}"
export TARGET_ARCH="${TARGETPLATFORM#*\/}"
export TARGET_ARCH="${TARGET_ARCH%\/*}"

TARGET_DISTRO=
TARGET_DISTROS=
TARGET_DISTRO_VERSION=

# detect os release
if [ -f /etc/os-release ]; then

	# source release info
	. /etc/os-release

	# collect the unames
	TARGET_DISTROS="${ID} ${ID_LIKE:-unknown}"
	TARGET_DISTRO=$(printf "%s" "${ID}" | tr '[:upper:]' '[:lower:]')
	TARGET_DISTRO_VERSION="${VERSION_ID}"

	# determine if linux is not included
	if [ "${TARGET_DISTROS%%linux}" = "${TARGET_DISTROS}" ]; then

		# add linux to the list
		TARGET_DISTROS="${TARGET_DISTROS} linux"
	fi

	export TARGET_DISTRO
	export TARGET_DISTROS
	export TARGET_DISTRO_VERSION
fi

export PATH="/usr/local/bin:${PATH}"

# set default env
printf 'PATH="%s"' "${PATH}" > /etc/environment

# symlink env
mv "${SCRIPT_PATH}"/env.sh /usr/local/bin/import-env

# import env
. import-env

# set platform environment variables
env_set 'SETUP_OS' "${TARGET_OS}"
env_set 'SETUP_DISTRO' "${TARGET_DISTRO}"
env_set 'SETUP_ARCH' "${TARGET_ARCH}"

# fix resolver within packer to use public
mv /etc/resolv.conf /etc/resolv.conf.final
cat << EOF > /etc/resolv.conf
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF

# install base packages
"${SCRIPT_PATH}/install-user.sh" base

# install base packages
"${SCRIPT_PATH}/install-user.sh" root

# protect usr local
chown -R root:root /usr/local
chmod -R u=rX,g=rX,o=rX /usr/local/bin

# capture current disk usage
before=$(df -Pm / | awk 'NR==2{print $4}')

# clean up after the distro
"${SCRIPT_PATH}/install-user.sh" clean

# capture disk usage after cleanup
after=$(df -Pm / | awk 'NR==2{print $4}')

# display the delta
printf "before : %s MB\n" "$before"
printf "after  : %s MB\n" "$after"
printf "delta  : %s MB\n" "$((after-before))"

# restore resolver
rm -f /etc/resolv.conf
mv /etc/resolv.conf.final /etc/resolv.conf
