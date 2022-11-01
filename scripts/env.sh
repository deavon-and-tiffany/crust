#! /usr/bin/env sh

__environment_file=${__environment_file:-/etc/environment}

if [ ! -f "${__environment_file}" ]; then
	printf '' > "${__environment_file}"
fi

env_get() {
    name="${1}"
    grep "^${name}=" "${__environment_file}" | sed -E "s%^${name}=\"?([^\"]+)\"?.*$%\1%"
}

env_add() {
	__sudo_cmd=$(command -v sudo 2>/dev/null || printf '')

	name="${1%%=*}"
    value="${2:-${1#*=}}"

    printf '%s="%s"\n' "${name}" "${value}" | ${__sudo_cmd} tee -a "${__environment_file}"

	export "${name}"="${value}"
}

env_replace() {
	__sudo_cmd=$(command -v sudo 2>/dev/null || printf '')

	name="${1%%=*}"
    value="${2:-${1#*=}}"

    ${__sudo_cmd} sed -i -e "s%^${name}=.*$%${name}=\"${value}\"%" "${__environment_file}"

	export "${name}"="${value}"
}

env_set() {
    name="${1%%=*}"
    value="${2:-${1#*=}}"

    if grep "${name}" "${__environment_file}" > /dev/null; then
        env_replace "${name}" "${value}"
    else
        env_add "${name}" "${value}"
    fi
}

env_prepend() {
    name="${1%%=*}"
    part="${2:-${1#*=}}"

    value=$(env_get "${name}")
    env_set "${name}" "${part}:${value}"
}

env_append() {
    name="${1%%=*}"
    part="${2:-${1#*=}}"

    value=$(env_get "${name}")
    env_set "${name}" "${value}:${part}"
}

env_prepend_path() {
    part="${1}"
    env_prepend PATH "${part}"
}

env_append_path() {
    part="${1}"
    env_append PATH "${part}"
}

env_reload() {
    eval "$(grep -Ev '^PATH=' "${__environment_file}" | sed -e 's%^%export %')"
    etc_path=$(env_get PATH)

    export PATH="${PATH}:${etc_path}"
}

env_save() {
	__newline=$(printf '\n')

	env | while IFS=${__newline} read -r env_var; do
		env_set "${env_var}"
	done
}

# always reload env on source
env_reload
