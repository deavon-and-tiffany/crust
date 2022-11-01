#! /usr/bin/env sh

set -e

# cleanup man pages and docs
rm -rf /var/share/man/* 1>/dev/null
rm -rf /var/share/doc/* 1>/dev/null

# delete all compressed and rotated log files
find /var/log -type f -regex ".*\.gz$" -delete 1>/dev/null
find /var/log -type f -regex ".*\.[0-9]$" -delete 1>/dev/null

# wipe log files
find /var/log/ -type f -exec truncate -s 0 {} \; 1>/dev/null

# disable swap and clean
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
rm -f /swapfile
