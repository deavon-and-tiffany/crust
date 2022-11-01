#! /usr/bin/env sh

download_tool() {
	url="${1}"
	destination="${2:-${url##*/}}"

	# reset args and fail on http error
	set -- --write-out '%{http_code}'

	# detect the github token
	if [ -f "/run/secrets/GITHUB_TOKEN" ]; then
		# load the github token
		# tricky: we have to cat with sudo to make sure the secret can be read by non-root user
		GITHUB_TOKEN=$(sudo cat /run/secrets/GITHUB_TOKEN)
	fi

	# if the github token is set and the url is a github url
	if [ -n "${GITHUB_TOKEN:-}" ] && [ "${url#*github}" != "${url}" ]; then
		# print a message about the token
		printf 'found github token for: %s; adding authorization header\n' "${url}"

		# add the authorization header
		set -- "$@" --header "'Authorization: token ${GITHUB_TOKEN}'"
	fi

	# set the args
	set -- "$@" --ipv4 --silent --output "${destination}" --location "${url}"
	printf 'attempting to download: %s to %s\n' "${url}" "${destination}"

	attempts=0

	# continue attempting for up to 3 requests
	while [ $attempts -lt 3 ]; do
		: $((attempts=attempts+1))

		# get the status code
		status_code=$(curl "$@")

		# determine if the request was successful; if so, we're good to go
		test "${status_code}" -eq 200 && return 0

		# print a failure message
		printf "failed to download: %s after %s attempts with status code: %s\n" "${url}" "${attempts}" "${status_code}"

		# determine if the error is non-recoverable (404) and break
		test "${status_code}" -eq 404 && break

		# wait to retry
		sleep 10
	done

	# we reached the end of the line
	printf 'failed to download: %s\n' "${url}"

	# return an error code
	return 1
}

download_tool "$@"
