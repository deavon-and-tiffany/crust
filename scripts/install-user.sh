#! /usr/bin/env sh

set -e

user=${1:-root}

# source the env scripts
. import-env

__sudo_cmd=$(command -v sudo 2>/dev/null || printf '')
__who=$(whoami)

# shellcheck disable=SC2086
for distro in ${TARGET_DISTROS}; do
	# get the install path
	install_path="${SCRIPT_PATH}"/installers/"${distro}"/"${user}"

	# determine if the install path does not exist
	if [ ! -d "${install_path}" ]; then

		# move on to the next uname
		continue
	fi

	printf '\nattempting install for: %s@%s\n' "${user}" "${distro}"

	# iterate over every installer that runs as root
	for installer in "${install_path}"/*.sh; do
		# create a temp for the installer
		tmp=$(mktemp -d)

		# mv into temp
		cd "${tmp}"

		# get the name of the tool
		name=$(basename "${installer}")
		name=${name#*-}
		name=${name%%.sh*}
		logfile="${user}-${distro}-${name}.log"
		full_name="${user}@${distro}/${name}"

		# print the installer
		printf "installing: %s...\n" "${full_name}"

		if ! INSTALLER_PATH="$install_path" "$installer" 1> "${logfile}" 2>&1; then

			# print an error message and the associated log
			printf "\n\nERROR: %s...\n\n" "${full_name}"
			cat "${logfile}"

			# we failed
			exit 1
		fi

		# move back to cwd
		cd "${SCRIPT_PATH}"

		rm -rf "${tmp}"

		# reload the env
		env_reload
	done
done
