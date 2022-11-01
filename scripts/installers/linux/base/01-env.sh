#! /usr/bin/env sh

set -e

# source env functions
. import-env

# symlink tools
mv "${SCRIPT_PATH}/download-tool.sh" /usr/local/bin/download-tool
mv "${SCRIPT_PATH}/get-latest-release.sh" /usr/local/bin/get-latest-release
