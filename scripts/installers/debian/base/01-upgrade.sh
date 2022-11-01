#! /usr/bin/env sh

set -e

apt update -y

# update dependencies
apt full-upgrade -y
apt autoremove -y
