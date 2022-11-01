#! /usr/bin/env sh

set -e

# cleanup apt cache
apt autoremove -y
apt clean -y
rm -rf /var/lib/apt/lists/*
