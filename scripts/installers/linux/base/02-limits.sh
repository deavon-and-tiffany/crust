#! /usr/bin/env sh

{
	# raise number of file descriptors
	printf '* soft nofile 65536\n'
	printf '* hard nofile 65536\n'

	# increase stack size
	printf '* soft stack 16384\n'
	printf '* hard stack 16384\n'
 } >> /etc/security/limits.conf

printf 'session required pam_limits.so\n' >> /etc/pam.d/common-session
printf 'session required pam_limits.so\n' >> /etc/pam.d/common-session-noninteractive

{
	printf 'DefaultLimitNOFILE=65536\n'
	printf 'DefaultLimitSTACK=16M:infinity\n'
} >> /etc/systemd/system.conf
