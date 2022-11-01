#! /usr/bin/env sh

set -e

__github_release() {
	org=
	repo=
	filter='.[] | select(.prerelease | not) | .tag_name'
	index=
	route="releases"
	selector='. | contains("-") or contains("a") or contains("b") or contains("rc") | not'

	while :; do
		case $1 in
			-dr|--dry-run)
				dry_run=1
				;;
			--debug)
				debug=1
				;;
			-o|--org|--organization|--organisation)
				org="${2}"
				shift
				;;
			--org=*|--organization=*|--organisation=*)
				org="${1#*=}"
				;;
			-r|--repo|--repository)
				repo="${2}"
				shift
				;;
			--repo=*|--repository=*)
				repo="${1#*=}"
				;;
			-p|--pre|--prerelease)
				selector='.'
				filter='.[].tag_name'
				;;
			-t|--tag|--tags)
				filter='.[].name'
				route="tags"
				;;
			-i|--index)
				index="${2}"
				shift
				;;
			--index=*)
				index="${2#*=}"
				;;
			?*)
				if [ -z "${org:-}" ]; then
					org="${1}"
				elif [ -z "${repo:-}" ]; then
					repo="${1}"
				elif [ -z "${index:-}" ]; then
					index="${1}"
				else
					printf 'get-latest-release: too many arguments, argument: %s is unexpected\n' "${1}"
					return 1
				fi
				;;
			*)
				break
				;;
		esac
		shift
	done

	if [ -z "${org:-}" ]; then
		printf "github-release: org is required"
		return 1
	fi

	if [ -z "${repo:-}" ]; then
		repo="${org}"
	fi

	index=${index:-0}

	if [ -n "${dry_run:-}" ]; then
		printf '%s\n' '' \
			'GITHUB RELEASE' \
			"org    : ${org}" \
			"repo   : ${repo}" \
			"filter : ${filter}" \
			"index  : ${index}" \
		''

		return 0
	fi

	(
		if [ -n "${debug:-}" ]; then
			set -x
		fi

		if [ -f "/run/secrets/GITHUB_TOKEN" ]; then
			# tricky: we have to cat with sudo to make sure the secret can be read by non-root user
			GITHUB_TOKEN=$(sudo cat /run/secrets/GITHUB_TOKEN)
		fi

		if [ -n "${GITHUB_TOKEN:-}" ]; then
			set -- --header "Authorization: token ${GITHUB_TOKEN}"
		fi

		set -- "$@" --ipv4 --silent --location "https://api.github.com/repos/${org}/${repo}/${route}"
		set -- "$@" "https://api.github.com/repos/${org}/${repo}/${route}?page=2"
		set -- "$@" "https://api.github.com/repos/${org}/${repo}/${route}?page=3"

		query="[${filter} | select(. != null) | select(contains(\".\")) | sub(\$org;\"\") | sub(\$repo;\"\") | sub(\".*/\";\"\") | sub(\"^v\"; \"\") | sub(\"^-\"; \"\") | select(${selector})]"

		curl "$@" \
			| jq '.[]' \
			| jq --slurp --arg org "${org}" --arg repo "${repo}" "${query}" > VERSIONS

		jq -r --arg index "${index}" '.[$index | tonumber]' VERSIONS
	)
}

__github_release "$@"
