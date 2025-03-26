#!/bin/sh
mkdir -p /var/log/xinetd
touch /var/log/xinetd/ctf.log
chmod 755 /var/log/xinetd

exec xinetd -dontfork -syslog local0 -f /etc/xinetd.conf